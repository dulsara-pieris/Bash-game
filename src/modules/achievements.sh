#!/usr/bin/env bash
# SYNAPSNEX OSS-Protection License (SOPL) v1.0
# Copyright (c) 2026 Dulsara Pieris

# STAR RUNNER - Achievements Module
# Full achievements system, safe and integrated with profile

ACHIEVEMENTS_FILE="$HOME/.star_runner_achievements"

# Colors
COLOR_NEUTRAL="\e[0m"
COLOR_YELLOW="\e[33m"
COLOR_CYAN="\e[36m"
COLOR_GREEN="\e[32m"

# -------------------------------
# Initialize achievements file
# -------------------------------
init_achievements() {
    if [[ ! -f "$ACHIEVEMENTS_FILE" ]]; then
        touch "$ACHIEVEMENTS_FILE"
        chown "$USER":"$USER" "$ACHIEVEMENTS_FILE"
        chmod 600 "$ACHIEVEMENTS_FILE"
    fi
}

# -------------------------------
# Unlock a single achievement
# -------------------------------
unlock_achievement() {
    local name="$1"
    # Skip if already unlocked
    if grep -q "^$name=true$" "$ACHIEVEMENTS_FILE" 2>/dev/null; then
        return
    fi
    # Mark as unlocked
    echo "$name=true" >> "$ACHIEVEMENTS_FILE"
    printf "${COLOR_YELLOW}★ Achievement unlocked: %s ★${COLOR_NEUTRAL}\n" "$name"
}

# -------------------------------
# Check and unlock achievements
# Call inside game loop
# -------------------------------
check_achievements() {
    # First Flight: start game
    [ "$frame" -ge 1 ] && unlock_achievement "First Flight"

    # Survivor: survive 600 frames (~1 min)
    [ "$frame" -ge 600 ] && unlock_achievement "Survivor"

    # Collector: collect 100 crystals
    [ "$crystals_collected" -ge 100 ] && unlock_achievement "Collector"

    # Level Up: reach level 5
    [ "$level" -ge 5 ] && unlock_achievement "Level Up"

    # Asteroid Destroyer: destroy 50 asteroids
    [ "$asteroids_destroyed" -ge 50 ] && unlock_achievement "Asteroid Destroyer"

    # Crystal Hoarder: bank 500 crystals
    [ "$crystal_bank" -ge 500 ] && unlock_achievement "Crystal Hoarder"

    # Speed Demon: reach level 10
    [ "$level" -ge 10 ] && unlock_achievement "Speed Demon"

    # Veteran: play 10 games
    [ "$games_played" -ge 10 ] && unlock_achievement "Veteran"

    # Master Pilot: reach level 20
    [ "$level" -ge 20 ] && unlock_achievement "Master Pilot"

    # Total Annihilation: destroy 200 asteroids
    [ "$total_asteroids" -ge 200 ] && unlock_achievement "Total Annihilation"

    # Ultimate Collector: collect 1000 crystals total
    [ "$total_crystals" -ge 1000 ] && unlock_achievement "Ultimate Collector"
}

# -------------------------------
# List unlocked achievements
# -------------------------------
list_achievements() {
    printf "${COLOR_CYAN}Unlocked Achievements:${COLOR_NEUTRAL}\n"
    if [[ -f "$ACHIEVEMENTS_FILE" ]]; then
        grep "=true$" "$ACHIEVEMENTS_FILE" | awk -F= '{print "★ "$1}'
    else
        echo "None"
    fi
}

# -------------------------------
# Reset achievements (if needed)
# -------------------------------
reset_achievements() {
    rm -f "$ACHIEVEMENTS_FILE"
    init_achievements
}

# -------------------------------
# Initialize automatically
# -------------------------------
init_achievements
