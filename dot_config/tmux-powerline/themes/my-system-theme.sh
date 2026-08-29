#!/usr/bin/env bash
# shellcheck shell=bash

# My tmux-powerline system theme.

if tp_patched_font_in_use; then
  TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=""
  TMUX_POWERLINE_SEPARATOR_LEFT_THIN=""
  TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=""
  TMUX_POWERLINE_SEPARATOR_RIGHT_THIN=""
else
  TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="◀"
  TMUX_POWERLINE_SEPARATOR_LEFT_THIN="❮"
  TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="▶"
  TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="❯"
fi

# Muted non-critical color used by all normal segments.
TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-'236'}
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-'252'}

TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}
TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}

# Helpers

# Prints the current UNIX time.
__tp_now() {
  if [[ -v EPOCHSECONDS ]]; then
    printf '%s' "$EPOCHSECONDS"
  else
    date +%s
  fi
}

# Prints the cached value (computing and caching it when missing).
__tp_cached() {
  local name="$1" ttl="$2" compute="$3"
  local file="${TMUX_POWERLINE_DIR_TEMPORARY:-/tmp}/tp_cache_${name}.txt"
  local ts val now
  if [ -f "$file" ] && read -r ts val <"$file" && [ -n "$val" ]; then
    now=$(__tp_now)
    if [ $((now - ts)) -lt "$ttl" ]; then
      printf '%s' "$val"
      return 0
    fi
  fi
  val=$("$compute") || return 1
  [ -n "$val" ] || return 1
  printf '%s %s\n' "$(__tp_now)" "$val" >"$file" 2>/dev/null || true
  printf '%s' "$val"
}

# Retrieves CPU usage using /proc/stat in Linux.
__tp_cpu_usage_linux() {
  local u1 n1 s1 i1 o1 ir1 si1 st1 u2 n2 s2 i2 o2 ir2 si2 st2
  local idle1 idle2 tot1 tot2 dtotal didle
  read -r _ u1 n1 s1 i1 o1 ir1 si1 st1 _ < <(grep '^cpu ' /proc/stat)
  sleep 0.25
  read -r _ u2 n2 s2 i2 o2 ir2 si2 st2 _ < <(grep '^cpu ' /proc/stat)
  idle1=$((i1 + o1))
  idle2=$((i2 + o2))
  tot1=$((u1 + n1 + s1 + i1 + o1 + ir1 + si1 + st1))
  tot2=$((u2 + n2 + s2 + i2 + o2 + ir2 + si2 + st2))
  dtotal=$((tot2 - tot1))
  didle=$((idle2 - idle1))
  if [ "$dtotal" -le 0 ]; then
    echo 0
  else
    echo $((100 * (dtotal - didle) / dtotal))
  fi
}

# Prints current CPU usage using `top -e -l 1` in MacOS.
__tp_cpu_usage_macos() {
  local cpu_idle
  cpu_idle=$(top -e -l 1 | grep "CPU usage:" | sed 's/CPU usage: //' | awk '{print $5}' | sed 's/%//')
  if [ -n "$cpu_idle" ]; then
    awk -v idle="$cpu_idle" 'BEGIN { printf "%.0f", 100 - idle }'
  fi
}

# Combined CPU usage percent (100 - idle).
tp_cpu_usage_percent() {
  if tp_shell_is_linux; then
    __tp_cached "cpu_usage" 10 __tp_cpu_usage_linux
  elif tp_shell_is_macos; then
    __tp_cached "cpu_usage" 10 __tp_cpu_usage_macos
  fi
}

if tp_shell_is_linux; then
  # Prints the average of all CPU core temps (°C).
  __tp_cpu_temp_linux() {
    local out temp
    out=$(sensors 2>/dev/null)
    [ -n "$out" ] || return 1
    temp=$(printf '%s\n' "$out" |
      grep -E '^Core [0-9]+:' |
      sed -e 's/[^+]*+\([0-9.]*\).*/\1/' |
      awk '{ s += $1; n++ } END { if (n) printf "%.0f", s / n }')
    if [ -z "$temp" ]; then
      temp=$(printf '%s\n' "$out" |
        grep -m 1 -E 'Package id 0|Physical id 0|Tctl|Tdie|temp1' |
        sed -e 's/[^+]*+\([0-9.]*\).*/\1/' | bc -l | awk '{ printf "%.0f", $1 }')
    fi
    [ -n "$temp" ] && echo "$temp"
  }

  tp_cpu_temp_value() {
    __tp_cached "cpu_temp" 10 __tp_cpu_temp_linux
  }
fi

if tp_shell_is_linux; then
  # Prints the current memory usage.
  __tp_mem_used_linux() {
    awk '
      /^MemTotal:/     { t = $2 }
      /^MemFree:/      { f = $2 }
      /^Shmem:/        { s = $2 }
      /^Buffers:/      { b = $2 }
      /^Cached:/       { c = $2 }
      /^SReclaimable:/ { r = $2 }
      END {
        if (t > 0)
          printf "%d %d", (t - f + s - b - c - r) * 1024, t * 1024
      }' /proc/meminfo
  }

  __tp_mem_used_info() {
    __tp_cached "mem_used" 10 __tp_mem_used_linux
  }
fi

if tp_shell_is_linux; then
  # Prints the battery percentage. Cached for 30s.
  __tp_battery_linux() {
    local dir status capacity
    for dir in /sys/class/power_supply/*/; do
      [ -r "$dir/type" ] || continue
      [ "$(cat "$dir/type" 2>/dev/null)" = "Battery" ] || continue
      status=$(cat "$dir/status" 2>/dev/null)
      capacity=$(cat "$dir/capacity" 2>/dev/null)
      [ -n "$capacity" ] || continue
      if [ "$status" = "Discharging" ]; then
        echo "$capacity"
      else
        echo "100"
      fi
      return 0
    done
  }

  tp_battery_percentage() {
    __tp_cached "battery" 30 __tp_battery_linux
  }
fi

if tp_shell_is_linux; then
  # Prints the round-trip latency (ms) to the ping target. Cached for 15s.
  __tp_ping_linux() {
    local out ms
    out=$(ping -c 1 -W 1 "${TMUX_POWERLINE_SEG_PING_TARGET:-1.1.1.1}" 2>/dev/null) || return 1
    ms=$(printf '%s\n' "$out" | sed -nE 's/.*[= ]([0-9.]+) ms.*/\1/p')
    [ -n "$ms" ] || return 1
    printf '%.0f' "$ms"
  }

  tp_ping_ms() {
    __tp_cached "ping" 15 __tp_ping_linux
  }
fi

# Most recent earthquake within RADIUS_KM of LAT/LON, from the USGS all-day feed.
tp_earthquake_info() {
  local tmp_file="${TMUX_POWERLINE_DIR_TEMPORARY}/earthquake_region.txt"
  if ! tp_is_tmp_valid "$tmp_file" "$TMUX_POWERLINE_SEG_EARTHQUAKE_UPDATE_PERIOD"; then
    curl --max-time 5 -s "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson" |
      jq -r '.features[] | [(.properties.mag // 0), .properties.time, .geometry.coordinates[1], .geometry.coordinates[0], (.properties.place // "")] | @tsv' |
      awk -v lat="$TMUX_POWERLINE_SEG_EARTHQUAKE_LAT" -v lon="$TMUX_POWERLINE_SEG_EARTHQUAKE_LON" \
        -v rad="$TMUX_POWERLINE_SEG_EARTHQUAKE_RADIUS_KM" -v minmag="$TMUX_POWERLINE_SEG_EARTHQUAKE_MIN_MAGNITUDE" '
				function hav(lat1, lon1, lat2, lon2,   dlat, dlon, a) {
					dlat = (lat2 - lat1) * 3.141592653589793 / 180
					dlon = (lon2 - lon1) * 3.141592653589793 / 180
					a = sin(dlat / 2)^2 + cos(lat1 * 3.141592653589793 / 180) * cos(lat2 * 3.141592653589793 / 180) * sin(dlon / 2)^2
					return 6371 * 2 * atan2(sqrt(a), sqrt(1 - a))
				}
				$1 >= minmag && hav($3, $4, lat, lon) <= rad { printf "%s %s", $1, $2; $1 = $2 = $3 = $4 = ""; sub(/^ +/, ""); print " " $0 }
			' | sort -k2 -n | tail -1 >"$tmp_file"
  fi
  cat "$tmp_file" 2>/dev/null
}

# Segment configuration

# shellcheck disable=SC1143,SC2128
if [ -z "$TMUX_POWERLINE_LEFT_STATUS_SEGMENTS" ]; then
  TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
    "tmux_session_info 236 252"
  )
fi

# shellcheck disable=SC1143,SC2128
if [ -z "$TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS" ]; then
  TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
    "$(
      eq_mag=$(tp_earthquake_info | awk '{print $1}')
      if [ -n "$eq_mag" ] && (($(echo "$eq_mag >= 6.0" | bc -l))); then
        echo "earthquake #ff2020 235"
      elif [ -n "$eq_mag" ] && (($(echo "$eq_mag >= 4.0" | bc -l))); then
        echo "earthquake 179 235"
      else
        echo "earthquake 236 252"
      fi
    )"
    "github_notifications 236 252"
    "ifstat 236 252"
    "ping 236 252"
    "$(
      cpu_usage=$(tp_cpu_usage_percent)
      cpu_temp=""
      if declare -F tp_cpu_temp_value >/dev/null; then
        cpu_temp=$(tp_cpu_temp_value)
      fi
      hot=0
      warn=0
      if [ -n "$cpu_usage" ]; then
        ((cpu_usage >= 80)) && hot=1
        ((cpu_usage >= 50)) && warn=1
      fi
      if [ -n "$cpu_temp" ]; then
        ((cpu_temp >= 75)) && hot=1
        ((cpu_temp >= 65)) && warn=1
      fi
      if ((hot)); then
        echo "cpu #ff2020 235"
      elif ((warn)); then
        echo "cpu 179 235"
      else
        echo "cpu 236 252"
      fi
    )"
    "$(
      if (($(tp_mem_used_percentage_at_least 90))); then
        echo "mem_used #ff2020 235"
      elif (($(tp_mem_used_percentage_at_least 75))); then
        echo "mem_used 179 235"
      else
        echo "mem_used 236 252"
      fi
    )"
    "disk_usage 236 252"
    "$(
      battery_percent=$(tp_battery_percentage)
      if [ -n "$battery_percent" ] && ((battery_percent <= 15)); then
        echo "battery #ff2020 235"
      elif [ -n "$battery_percent" ] && ((battery_percent <= 30)); then
        echo "battery 179 235"
      else
        echo "battery 236 252"
      fi
    )"
    "date 236 252 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}"
    "time 236 252 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}"
  )
fi
