#!/usr/bin/env bash

# STAR RUNNER - Ships Module
# Ship definitions and related functions

# Get ship name by ID
get_ship_name() {
  case $1 in
    1) printf "Scout" ;;
    2) printf "Interceptor" ;;
    3) printf "Frigate" ;;
    4) printf "Cruiser" ;;
    5) printf "Battleship" ;;
  esac
}

# Get ship icon/symbol
get_ship_icon() {
  case $1 in
    1) printf "▶" ;;
    2) printf "▷" ;;
    3) printf "⊳" ;;
    4) printf "⊲" ;;
    5) printf "⧐" ;;
  esac
}

# Get ship movement speed
get_ship_speed() {
  case $1 in
    1) printf "2" ;;  # Fast
    2) printf "2" ;;  # Fast
    3) printf "1" ;;  # Medium
    4) printf "1" ;;  # Medium
    5) printf "1" ;;  # Slow
  esac
}

# Get ship starting ammo
get_ship_ammo() {
  case $1 in
    1) printf "20" ;;
    2) printf "25" ;;
    3) printf "30" ;;
    4) printf "40" ;;
    5) printf "50" ;;
  esac
}

# Get ship price in crystals
get_ship_price() {
  case $1 in
    1) printf "0" ;;    # Free starter ship
    2) printf "150" ;;
    3) printf "300" ;;
    4) printf "500" ;;
    5) printf "800" ;;
  esac
}