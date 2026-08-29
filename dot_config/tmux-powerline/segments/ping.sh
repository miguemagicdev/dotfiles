#!/usr/bin/env bash
# shellcheck shell=bash

# My tmux-powerline Ping Segment.

# Prints the round-trip latency (ms) to the configured target host.
# Custom segment for tmux-powerline.

run_segment() {
  local ms

  ms=$(tp_ping_ms)
  if [ -n "$ms" ]; then
    echo " ${ms}ms"
    return 0
  fi
  return 1
}
