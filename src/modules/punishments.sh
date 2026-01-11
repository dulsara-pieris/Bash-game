#!/usr/bin/env bash

# SYNAPSNEX OSS-Protection License (SOPL) v1.0
# Copyright (c) 2026 Dulsara Pieris

# STAR RUNNER - Punishments Module
# Long-term and short-term punishments, fully reversible

# ------------------------------
# Config
# ------------------------------
LOW_SCORE_THRESHOLD=50
PUNISHMENT_DURATION=50  # frames
PUNISHMENT_ACTIVE=0
PUNISHMENT_TIMER=0

# Long-term punishment (days)
punishment_expires=0
punishment_backup=()  # stores original profile: name, gender, skin, ship, ammo

FUNNY_NAMES=("AsteroidMagnet" "NoobSauce" "TrashPilot" "SpacePeasant" "NeuralTrash" "OopsiePilot")
PUNISHMENT_SKINS=(5 4 3)

# ------------------------------
# Backup original profile before long-term punishment
# ------------------------------
backup_profile_for_punishment() {
    punishment_backup=("$player_name" "$player_gender" "$current_skin" "$current_ship" "$ammo")
}

# ------------------------------
# Restore profile after punishment expires
# ------------------------------
restore_profile_after_punishment() {
    player_name="${punishment_backup[0]}"
    player_gender="${punishment_backup[1]}"
    current_skin="${punishment_backup[2]}"
    current_ship="${punishment_backup[3]}"
    ammo="${punishment_backup[4]}"
    punishment_backup=()
    punishment_expires=0
    save_profile
    printf "$COLOR_GREEN ✓ Your profile has been restored to normal! $COLOR_NEUTRAL\n"
}

# ------------------------------
# Apply long-term name/skin/ship/gender punishment
# ------------------------------
# Apply long-term name/skin/ship/gender punishment
apply_long_term_punishment() {
    current_time=$(date +%s)

    # If punishment still active, skip
    if [ "$punishment_expires" -gt "$current_time" ]; then return; fi

    # Backup original profile if first time
    if [ "${#punishment_backup[@]}" -eq 0 ]; then
        backup_profile_for_punishment
        punishment_level=1
    else
        # Already punished before
        punishment_level=$((punishment_level + 1))
    fi

    # Punishment duration increases each level
    base_days=3
    days=$((base_days * punishment_level))
    punishment_expires=$((current_time + days*24*60*60))

    # Apply funny/harsher name
    if [ "$punishment_level" -eq 1 ]; then
        player_name=${FUNNY_NAMES[$RANDOM % ${#FUNNY_NAMES[@]}]}
    else
        # Harsher names second time
        HARSH_NAMES=("TrashPilot" "NeuralTrash" "SpacePeasant" "AsteroidMagnet")
        player_name=${HARSH_NAMES[$RANDOM % ${#HARSH_NAMES[@]}]}
    fi

    # Invert gender/title based on original profile
    original_gender="${punishment_backup[1]}"
    original_title="${punishment_backup[5]:-$player_title}" # store original title in backup[5] if available

    case "$original_gender" in
        "Male")
            player_gender="Female"
            player_title="Madam"
            ;;
        "Female")
            player_gender="Male"
            player_title="Sir"
            ;;
        *)
            player_gender="Alien"
            player_title="SpaceBeing"
            ;;
    esac

    # Force ugly skin and slowest ship (more extreme if second punishment)
    if [ "$punishment_level" -eq 1 ]; then
        current_skin=${PUNISHMENT_SKINS[$RANDOM % ${#PUNISHMENT_SKINS[@]}]}
        current_ship=1
    else
        # Harsh punishment: forced skin + slowest ship
        current_skin=5
        current_ship=1
    fi

    ammo=$(get_ship_ammo "$current_ship")

    # Optional: additional chaos for repeated punishment
    [ "$punishment_level" -gt 1 ] && apply_reverse_controls

    # Save profile changes
    save_profile

    printf "$COLOR_RED ⚠ Punishment applied for $days day(s)! Level: $punishment_level, Name: $player_name, Gender: $player_gender $COLOR_NEUTRAL\n"
}


# ------------------------------
# Check if long-term punishment expired
# ------------------------------
check_long_term_punishment() {
    current_time=$(date +%s)
    if [ "$punishment_expires" -gt "$current_time" ]; then
        # Punishment still active
        :
    else
        # Punishment expired
        if [ "${#punishment_backup[@]}" -gt 0 ]; then
            restore_profile_after_punishment
        fi
    fi
}

# ------------------------------
# Short-term chaos punishment
# ------------------------------
apply_short_punishment() {
    if [ "$PUNISHMENT_ACTIVE" -eq 1 ]; then return; fi
    PUNISHMENT_ACTIVE=1
    PUNISHMENT_TIMER=$PUNISHMENT_DURATION

    printf "\n$COLOR_RED ✗ Chaos punishment activated! $COLOR_NEUTRAL\n"

    # Reduce ship speed
    original_speed=$(get_ship_speed "$current_ship")
    new_speed=$((original_speed - 1))
    [ "$new_speed" -lt 1 ] && new_speed=1
    set_ship_speed "$current_ship" "$new_speed"

    # Halve ammo
    ammo=$((ammo / 2))
    [ "$ammo" -lt 1 ] && ammo=1

    # Blink ship effect
    blink_ship_effect

    # Spawn extra asteroids
    for i in {1..5}; do spawn_asteroid; done

    # Force ugly skin temporarily
    old_skin="$current_skin"
    current_skin=${PUNISHMENT_SKINS[$RANDOM % ${#PUNISHMENT_SKINS[@]}]}
}

# ------------------------------
# Punishment tick per frame
# ------------------------------
punishment_tick() {
    if [ "$PUNISHMENT_ACTIVE" -eq 1 ]; then
        [ $((frame % 5)) -eq 0 ] && draw_ship
        PUNISHMENT_TIMER=$((PUNISHMENT_TIMER - 1))
        if [ "$PUNISHMENT_TIMER" -le 0 ]; then
            PUNISHMENT_ACTIVE=0
            ammo=$(get_ship_ammo "$current_ship")
            set_ship_speed "$current_ship" "$(get_ship_speed "$current_ship")"
            printf "$COLOR_GREEN ✓ Chaos punishment ended! $COLOR_NEUTRAL\n"
        fi
    fi
}

# ------------------------------
# Blink ship effect
# ------------------------------
blink_ship_effect() {
    for i in {1..3}; do
        clear
        draw_border
        sleep 0.1
        draw_ship
        sleep 0.1
    done
}

# ------------------------------
# Trigger punishments if low score
# ------------------------------
check_low_score_punishment() {
    if [ "$score" -lt "$LOW_SCORE_THRESHOLD" ]; then
        apply_short_punishment
        apply_long_term_punishment
    fi
}
