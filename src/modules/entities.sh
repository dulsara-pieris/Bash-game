#!/usr/bin/env bash

#SYNAPSNEX OSS-Protection License (SOPL) v1.0
#Copyright (c) 2026 Dulsara Pieris

# STAR RUNNER - Entities Module
# Asteroids, crystals, and powerups

# Spawn a new asteroid
spawn_asteroid() {
  asteroid_count=$((asteroid_count + 1))
  i=$asteroid_count

  line=$(get_random_number 10 $((NUM_LINES - 10)))
  column=$((NUM_COLUMNS - 1))
  size=$(get_random_number 1 3)
  
  # UFO asteroids appear at level 3+
  if [ "$level" -ge 3 ]; then
    type_chance=$(get_random_number 1 10)
    if [ "$type_chance" -le 3 ]; then
      asteroid_type=2  # UFO type (tracks player)
    else
      asteroid_type=1  # Normal asteroid
    fi
  else
    asteroid_type=1
  fi

  eval "asteroid_${i}_line=$line"
  eval "asteroid_${i}_col=$column"
  eval "asteroid_${i}_size=$size"
  eval "asteroid_${i}_type=$asteroid_type"
  eval "asteroid_${i}_active=1"
}

# Move all active asteroids
move_asteroids() {
  i=1
  while [ $i -le "$asteroid_count" ]; do
    eval "active=\$asteroid_${i}_active"
    
    if [ "$active" = 1 ]; then
      eval "line=\$asteroid_${i}_line"
      eval "col=\$asteroid_${i}_col"
      eval "size=\$asteroid_${i}_size"
      eval "type=\$asteroid_${i}_type"
      
      # Clear old position
      move_cursor "$line" "$col"
      case $size in
        1) printf "   " ;;
        2) printf "    " ;;
        3) printf "     " ;;
      esac
      
      # Move based on type
      if [ "$type" = 2 ]; then
        # UFO type - tracks player vertically
        col=$((col - 1))
        if [ "$line" -lt "$ship_line" ]; then
          line=$((line + 1))
        elif [ "$line" -gt "$ship_line" ]; then
          line=$((line - 1))
        fi
      else
        # Normal asteroid - moves left with speed multiplier
        move_speed=$((1 + speed_multiplier / 2))
        col=$((col - move_speed))
      fi
      
      # Deactivate if off screen
      if [ "$col" -lt 1 ]; then
        eval "asteroid_${i}_active=0"
      else
        # Update position
        eval "asteroid_${i}_col=$col"
        eval "asteroid_${i}_line=$line"
        
        # Draw at new position
        move_cursor "$line" "$col"
        
        if [ "$type" = 2 ]; then
          # UFO appearance (magenta)
          printf "$COLOR_MAGENTA"
          case $size in
            1) printf "⊕" ;;
            2) printf "◉◉" ;;
            3) printf "◉⊕◉" ;;
          esac
        else
          # Normal asteroid appearance (red)
          printf "$COLOR_RED"
          case $size in
            1) printf "◆" ;;
            2) printf "◈◈" ;;
            3) printf "◈◆◈" ;;
          esac
        fi
        printf "$COLOR_NEUTRAL"
      fi
    fi
    i=$((i + 1))
  done
}

# Spawn a crystal collectible
spawn_crystal() {
  if [ "$crystal_active" = 0 ]; then
    line=$(get_random_number 3 $((NUM_LINES - 2)))
    column=$((NUM_COLUMNS - 2))
    crystal_line=$line
    crystal_col=$column
    crystal_active=1
  fi
}

# Move crystal across screen
move_crystal() {
  if [ "$crystal_active" = 1 ]; then
    # Clear old position
    move_cursor "$crystal_line" "$crystal_col"
    printf " "
    
    crystal_col=$((crystal_col - 1))
    
    if [ "$crystal_col" -lt 1 ]; then
      crystal_active=0
    else
      # Draw at new position
      move_cursor "$crystal_line" "$crystal_col"
      printf "${COLOR_CYAN}◇${COLOR_NEUTRAL}"
    fi
  fi
}

# Spawn a powerup
spawn_powerup() {
  if [ "$powerup_active" = 0 ]; then
    chance=$(get_random_number 1 8)
    if [ "$chance" = 1 ]; then
      line=$(get_random_number 3 $((NUM_LINES - 2)))
      column=$((NUM_COLUMNS - 2))
      
      # Advanced powerups at level 4+
      if [ "$level" -ge 4 ]; then
        powerup_type=$(get_random_number 1 5)
      else
        powerup_type=$(get_random_number 1 3)
      fi
      
      powerup_line=$line
      powerup_col=$column
      powerup_active=1
    fi
  fi
}

# Move powerup across screen
move_powerup() {
  if [ "$powerup_active" = 1 ]; then
    # Clear old position
    move_cursor "$powerup_line" "$powerup_col"
    printf "  "
    
    powerup_col=$((powerup_col - 1))
    
    if [ "$powerup_col" -lt 1 ]; then
      powerup_active=0
    else
      # Draw at new position with type-specific icon
      move_cursor "$powerup_line" "$powerup_col"
      case $powerup_type in
        1) printf "${COLOR_YELLOW}☢${COLOR_NEUTRAL}" ;;  # Shield
        2) printf "${COLOR_MAGENTA}◈${COLOR_NEUTRAL}" ;; # Super mode
        3) printf "${COLOR_GREEN}⊕${COLOR_NEUTRAL}" ;;   # Ammo pack
        4) printf "${COLOR_CYAN}⚡${COLOR_NEUTRAL}" ;;   # Spread shot
        5) printf "${COLOR_WHITE}◇${COLOR_NEUTRAL}" ;;  # Rapid fire
      esac
    fi
  fi
}