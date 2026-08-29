#!/usr/bin/env bash
# shellcheck shell=bash

# My tmux-powerline CPU Segment.

# Prints a combined CPU usage (100 - idle)
# Custom segment for tmux-powerline.

run_segment() {
  local cpu_usage cpu_temp output

  cpu_usage=$(tp_cpu_usage_percent)
  [ -n "$cpu_usage" ] || return 1

  output=" ${cpu_usage}%"

  if declare -F tp_cpu_temp_value >/dev/null; then
    cpu_temp=$(tp_cpu_temp_value)
    if [ -n "$cpu_temp" ]; then
      output="${output} ${TMUX_POWERLINE_SEG_CPU_TEMP_ICON:- }${cpu_temp}°C"
    fi
  fi

  echo "$output"
  return 0
}
