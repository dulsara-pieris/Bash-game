#!/usr/bin/env bash

# STAR RUNNER - Configuration Module
# All constants, colors, and terminal setup

# Color definitions
COLOR_BLUE='\e[1;34m'
COLOR_GREEN='\e[1;32m'
COLOR_MAGENTA='\e[1;35m'
COLOR_NEUTRAL='\e[0m'
COLOR_RED='\e[1;31m'
COLOR_YELLOW='\e[1;33m'
COLOR_CYAN='\e[1;36m'
COLOR_WHITE='\e[1;37m'

# Special characters
ESCAPE_CHAR=$(printf '\033')

# Terminal size requirements
MIN_NUM_COLUMNS=40
MIN_NUM_LINES=20

# Game timing
TURN_DURATION=2

# Get current terminal size
TERMINAL_SIZE=$(stty size)
NUM_COLUMNS="${TERMINAL_SIZE##* }"
NUM_LINES="${TERMINAL_SIZE%% *}"

# Validate terminal size
if [ "$NUM_LINES" -lt "$MIN_NUM_LINES" ] || [ "$NUM_COLUMNS" -lt "$MIN_NUM_COLUMNS" ]; then
  printf 'Error: Your terminal size is too small. Need at least 40x20.\n' >&2
  exit 1
fi

# Validate required commands
if ! type stty > /dev/null 2>&1; then
  printf 'Error: stty is required\n' >&2
  exit 1
fi