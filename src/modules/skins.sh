#!/usr/bin/env bash

# STAR RUNNER - Skins Module
# Skin/color customization definitions

# Get skin name by ID
get_skin_name() {
  case $1 in
    1) printf "Default" ;;
    2) printf "Crimson" ;;
    3) printf "Cyber" ;;
    4) printf "Gold" ;;
    5) printf "Rainbow" ;;
  esac
}

# Get skin color code
get_skin_color() {
  case $1 in
    1) printf "$COLOR_GREEN" ;;
    2) printf "$COLOR_RED" ;;
    3) printf "$COLOR_CYAN" ;;
    4) printf "$COLOR_YELLOW" ;;
    5) printf "$COLOR_MAGENTA" ;;
  esac
}

# Get skin price in crystals
get_skin_price() {
  case $1 in
    1) printf "0" ;;    # Free default skin
    2) printf "100" ;;
    3) printf "150" ;;
    4) printf "200" ;;
    5) printf "300" ;;
  esac
}