#!/usr/bin/env bash
# shellcheck shell=bash

# Recent earthquakes near my country (Venezuela), from the USGS feed.
# Overrides the repo segment, which only supports the goo feed.
run_segment() {
  local info mag epoch place

  info=$(tp_earthquake_info)
  [ -n "$info" ] || return 1
  mag=$(echo "$info" | awk '{print $1}')
  epoch=$(echo "$info" | awk '{print $2}')
  place=$(echo "$info" | cut -d' ' -f3-)
  if [ -n "$mag" ] && [ -n "$epoch" ]; then
    if [ -n "$place" ]; then
      if [ "${#place}" -gt 40 ]; then
        place="${place:0:40}…"
      fi
      echo "~ M${mag} $(date -d "@$((epoch / 1000))" +%H:%M) ${place}"
    else
      echo "~ M${mag} $(date -d "@$((epoch / 1000))" +%H:%M)"
    fi
    return 0
  fi
  return 1
}
