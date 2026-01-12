#!/usr/bin/env bash

#SYNAPSNEX OSS-Protection License (SOPL) v1.0
#Copyright (c) 2026 Dulsara Pieris

# STAR RUNNER ENHANCED - Main Game Entry Point

# ------------------------------
# Setup
# ------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source modules
source "$SCRIPT_DIR/modules/config.sh"
source "$SCRIPT_DIR/modules/utils.sh"
source "$SCRIPT_DIR/modules/profile.sh"
source "$SCRIPT_DIR/modules/ships.sh"
source "$SCRIPT_DIR/modules/skins.sh"
source "$SCRIPT_DIR/modules/menu.sh"
source "$SCRIPT_DIR/modules/shop.sh"
source "$SCRIPT_DIR/modules/render.sh"
source "$SCRIPT_DIR/modules/entities.sh"
source "$SCRIPT_DIR/modules/weapons.sh"
source "$SCRIPT_DIR/modules/collision.sh"
source "$SCRIPT_DIR/modules/input.sh"
source "$SCRIPT_DIR/modules/effects.sh"
source "$SCRIPT_DIR/modules/punishments.sh"  # PUNISHMENT MODULE
source "$SCRIPT_DIR/modules/inventory.sh"   # Optional: career stats module

# Init tamper-proof achievements
#init_achievements

# Parse CLI arguments
while :; do
  case "$1" in
    -h|--help) show_help; exit 0 ;;
    -u|--update) update; exit 0 ;;
    --) shift; break ;;
    -?*) printf 'ERROR: Unknown option: %s\n' "$1" >&2; exit 1 ;;
    *) break ;;
  esac
  shift
done

# ------------------------------
# Game State
# ------------------------------
ship_line=$((NUM_LINES / 2))
ship_column=5
ship_x=5  # ← ADD THIS
ship_y=$((NUM_LINES / 2))  # ← ADD THIS
paused=0
asteroid_count=0
crystal_active=0
powerup_active=0
laser_active=0
laser2_active=0
laser3_active=0
shield_active=0
shield_timer=0
super_mode_active=0
super_timer=0
weapon_type=1
weapon_timer=0
frame=0
score=0
level=1
speed_multiplier=0
crystals_collected=0
asteroids_destroyed=0
game_over=0  # ← ADD THIS

# Load profile (high score, crystals, stats)
init_profile

# Check if long-term punishment is still active
check_long_term_punishment

# Show main menu
show_main_menu

# Set ammo based on selected ship
current_ship=$((current_ship + 0))
ammo=$(get_ship_ammo "$current_ship")
ammo=$((ammo + 0))

# Configure terminal input
stty -icanon -echo time $TURN_DURATION min 0

# Initialize screen
on_enter
draw_border
draw_ship

# Show launch sequence
printf "$COLOR_CYAN"
center_col=$((NUM_COLUMNS / 2 - 12))
center_line=$((NUM_LINES / 2))
move_cursor $center_line $center_col
printf " ▶ LAUNCHING STAR RUNNER ◀ "
printf "$COLOR_NEUTRAL"
sleep 2
move_cursor $center_line $center_col
printf "                           "

# ------------------------------
# MAIN GAME LOOP
# ------------------------------
while [ "$game_over" -eq 0 ]; do
  if [ "$paused" -eq 0 ]; then
    
    # ========================================
    # PUNISHMENT SYSTEM - TICK FIRST!
    # ========================================
    punishment_tick
    
    # --------------------------
    # Player input (WITH PUNISHMENT)
    # --------------------------
    read -t 0.05 -n 1 key
    
    # Use punishment-aware input handler
    handle_input_with_punishment "$key"
    
    # Also handle your other keys (pause, etc.)
    case "$key" in
      p|P)
        paused=1
        ;;
      q|Q)
        game_over=1
        ;;
    esac

    # --------------------------
    # Level progression
    # --------------------------
    new_level=$((score / 200 + 1))
    if [ "$new_level" -ne "$level" ]; then
      level=$new_level
      speed_multiplier=$((level - 1))

      # Level-up notification
      printf "$COLOR_GREEN"
      center_col=$((NUM_COLUMNS / 2 - 10))
      center_line=$((NUM_LINES / 2))
      move_cursor $center_line $center_col
      printf " ★ LEVEL $level ★ "
      printf "$COLOR_NEUTRAL"
      sleep 1
      move_cursor $center_line $center_col
      printf "                      "
    fi

    # --------------------------
    # Background and spawning
    # --------------------------
    [ $((frame % 10)) -eq 0 ] && draw_stars

    spawn_frequency=$((4 - speed_multiplier))
    [ "$spawn_frequency" -lt 2 ] && spawn_frequency=2
    [ $((frame % spawn_frequency)) -eq 0 ] && spawn_asteroid

    [ $((frame % 20)) -eq 0 ] && { spawn_crystal; spawn_powerup; }

    # --------------------------
    # Update entities
    # --------------------------
    move_asteroids
    move_crystal
    move_powerup
    move_laser

    # --------------------------
    # Collisions & timers
    # --------------------------
    check_laser_hits
    check_collisions
    update_timers

    # --------------------------
    # Render frame
    # --------------------------
    draw_ship
    draw_hud

    # ========================================
    # PUNISHMENT CHECKS
    # ========================================
    # Check every 100 frames if punishment should trigger
    if [ $((frame % 100)) -eq 0 ]; then
      check_low_score_punishment
    fi
    
    # Check every 500 frames if long-term punishment expired
    if [ $((frame % 500)) -eq 0 ]; then
      check_long_term_punishment
    fi

    # --------------------------
    # Increment frame
    # --------------------------
    frame=$((frame + 1))

    # --------------------------
    # Update career stats
    # --------------------------
    if [ "$score" -gt "$high_score" ]; then
      high_score=$score
    fi
    total_crystals=$((total_crystals + crystals_collected))
    total_asteroids=$((total_asteroids + asteroids_destroyed))
    crystals_bank=$((crystals_bank + crystals_collected))

    # Rank calculation
    if [ "$high_score" -ge 1000 ]; then
      rank="Star Pilot"
    elif [ "$high_score" -ge 500 ]; then
      rank="Space Cadet"
    else
      rank="Neural Trash"
    fi

    # Save stats periodically (every 50 frames)
    if [ $((frame % 50)) -eq 0 ]; then
      save_profile
    fi

  else
    # Paused: only handle input & draw ship
    read -t 0.05 -n 1 key
    case "$key" in
      p|P)
        paused=0
        printf "$COLOR_CYAN"
        center_col=$((NUM_COLUMNS / 2 - 5))
        center_line=$((NUM_LINES / 2))
        move_cursor $center_line $center_col
        printf " RESUMED "
        printf "$COLOR_NEUTRAL"
        sleep 0.5
        move_cursor $center_line $center_col
        printf "         "
        ;;
      q|Q)
        game_over=1
        ;;
    esac
    draw_ship
  fi
done

# ========================================
# GAME OVER
# ========================================
clear
printf "$COLOR_RED"
center_col=$((NUM_COLUMNS / 2 - 10))
center_line=$((NUM_LINES / 2 - 5))
move_cursor $center_line $center_col
printf "╔════════════════════╗"
move_cursor $((center_line + 1)) $center_col
printf "║   GAME OVER!       ║"
move_cursor $((center_line + 2)) $center_col
printf "║                    ║"
move_cursor $((center_line + 3)) $center_col
printf "║ Score: %-11s ║" "$score"
move_cursor $((center_line + 4)) $center_col
printf "║ Level: %-11s ║" "$level"
move_cursor $((center_line + 5)) $center_col
printf "╚════════════════════╝"
printf "$COLOR_NEUTRAL"

# Add to hall of shame if score is terrible
check_and_add_to_shame

# Show hall of shame
move_cursor $((center_line + 7)) 0
show_hall_of_shame

# Final save
save_profile

# Restore terminal
on_exit

printf "\n\nThanks for playing STAR RUNNER!\n"
printf "High Score: $high_score\n"
printf "Crystals Earned: $crystals_collected\n"
printf "Asteroids Destroyed: $asteroids_destroyed\n\n"