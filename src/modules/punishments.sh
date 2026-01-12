#!/usr/bin/env bash

# STAR RUNNER - BRUTAL Punishments Module (MAXIMUM HUMILIATION)
# Author: Dulsara Pieris (SYNAPSNEX)
# Handles long-term and short-term punishments - MUCH WORSE FOR LOSERS

# ============================================================================
# INTEGRATION INSTRUCTIONS - HOW TO USE IN YOUR MAIN GAME LOOP
# ============================================================================
#
# 1. Source this file in your main game script:
#    source ./punishments.sh
#
# 2. In your GAME LOOP, add this BEFORE reading input:
#    punishment_tick
#
# 3. Replace your input handling code with:
#    read -t 0.05 -n 1 key
#    key=$(apply_punished_movement "$key")  # This applies reverse controls!
#
# 4. For ship movement, use the function instead of direct assignment:
#    # OLD WAY:
#    # case "$key" in
#   #!/usr/bin/env bash

# STAR RUNNER - BRUTAL Punishments Module (MAXIMUM HUMILIATION)
# Author: Dulsara Pieris (SYNAPSNEX)
# Handles long-term and short-term punishments - MUCH WORSE FOR LOSERS

# ------------------------------
# Config
# ------------------------------
LOW_SCORE_THRESHOLD=150
PUNISHMENT_DURATION=80  # Longer punishment
SUPER_PUNISHMENT_THRESHOLD=100
EXTREME_LOSER_THRESHOLD=50  # Ultimate humiliation

# Short-term punishment state
PUNISHMENT_ACTIVE=0
PUNISHMENT_TIMER=0
PUNISHMENT_OLD_SKIN=""
PUNISHMENT_OLD_SPEED=0

# Long-term punishment (persisted)
punishment_level=${punishment_level:-0}
punishment_expires=${punishment_expires:-0}

# Original profile backup (persisted)
punishment_backup_name="${punishment_backup_name:-}"
punishment_backup_gender="${punishment_backup_gender:-}"
punishment_backup_title="${punishment_backup_title:-}"
punishment_backup_skin="${punishment_backup_skin:-}"
punishment_backup_ship="${punishment_backup_ship:-}"
punishment_backup_ammo="${punishment_backup_ammo:-}"

# BRUTAL punishment names
LOSER_NAMES=(
    "TotalTrash" "EpicFailure" "DisasterPilot" "CrashMaster"
    "SpaceGarbage" "CosmicWaste" "StellarIdiot" "GalaxyShame"
    "AsteroidFood" "NebulaNoob" "VoidLoser" "QuasarQuitter"
    "TrashCompactor" "FailFactory" "DisasterClass" "WorthlessWreck"
    "AbsoluteGarbage" "CompleteWaste" "TotalEmbarrassment" "UltimateFailure"
)

# HUMILIATING titles
LOSER_TITLES=(
    "the Pathetic" "the Worthless" "the Incompetent" "the Disaster"
    "the Failure" "the Embarrassment" "the Joke" "the Laughingstock"
    "the Useless" "the Hopeless" "the Terrible" "the Abysmal"
    "the Disgraceful" "the Shameful" "the Pitiful" "the Deplorable"
)

PUNISHMENT_SKINS=(5 4 3)

# Super punishment effects (ACTUALLY WORKING)
REVERSE_CONTROLS_ACTIVE=0
DRUNK_MODE_ACTIVE=0
RANDOM_TELEPORT_ACTIVE=0
SHRINKING_SHIP_ACTIVE=0
INVERTED_SCREEN=0
SUPER_SPEED_ASTEROIDS=0

# ------------------------------
# Helper function to safely get ship speed
# ------------------------------
safe_get_ship_speed() {
    local ship_id=$1
    # Return speed based on ship type if get_ship_speed doesn't exist
    if type get_ship_speed &>/dev/null; then
        get_ship_speed "$ship_id"
    else
        case $ship_id in
            1) echo 2 ;;
            2) echo 3 ;;
            3) echo 4 ;;
            *) echo 3 ;;
        esac
    fi
}

# ------------------------------
# Helper function to safely set ship speed
# ------------------------------
safe_set_ship_speed() {
    local ship_id=$1
    local speed=$2
    # Only set if function exists
    if type set_ship_speed &>/dev/null; then
        set_ship_speed "$ship_id" "$speed"
    fi
}

# ------------------------------
# Helper function to safely get ship ammo
# ------------------------------
safe_get_ship_ammo() {
    local ship_id=$1
    # Return ammo based on ship type if get_ship_ammo doesn't exist
    if type get_ship_ammo &>/dev/null; then
        get_ship_ammo "$ship_id"
    else
        case $ship_id in
            1) echo 10 ;;
            2) echo 20 ;;
            3) echo 30 ;;
            *) echo 20 ;;
        esac
    fi
}

# ------------------------------
# Helper function to safely spawn asteroids
# ------------------------------
safe_spawn_asteroid() {
    if type spawn_asteroid &>/dev/null; then
        spawn_asteroid
    fi
}

# ------------------------------
# Helper function to safely draw ship
# ------------------------------
safe_draw_ship() {
    if type draw_ship &>/dev/null; then
        draw_ship
    fi
}

# ------------------------------
# Helper function to safely draw border
# ------------------------------
safe_draw_border() {
    if type draw_border &>/dev/null; then
        draw_border
    fi
}

# ------------------------------
# Helper function to safely save profile
# ------------------------------
safe_save_profile() {
    if type save_profile &>/dev/null; then
        save_profile
    fi
}

# ------------------------------
# Backup original profile
# ------------------------------
backup_profile_for_punishment() {
    if [ -z "$punishment_backup_name" ]; then
        punishment_backup_name="$player_name"
        punishment_backup_gender="$player_gender"
        punishment_backup_title="$player_title"
        punishment_backup_skin="$current_skin"
        punishment_backup_ship="$current_ship"
        punishment_backup_ammo="$ammo"
    fi
}

# ------------------------------
# Restore profile after punishment expires
# ------------------------------
restore_profile_after_punishment() {
    player_name="$punishment_backup_name"
    player_gender="$punishment_backup_gender"
    player_title="$punishment_backup_title"
    current_skin="$punishment_backup_skin"
    current_ship="$punishment_backup_ship"
    ammo="$punishment_backup_ammo"

    # Clear ALL punishment state
    punishment_level=0
    punishment_expires=0
    punishment_backup_name=""
    punishment_backup_gender=""
    punishment_backup_title=""
    punishment_backup_skin=""
    punishment_backup_ship=""
    punishment_backup_ammo=""

    # Reset effects
    REVERSE_CONTROLS_ACTIVE=0
    DRUNK_MODE_ACTIVE=0
    RANDOM_TELEPORT_ACTIVE=0
    SHRINKING_SHIP_ACTIVE=0
    INVERTED_SCREEN=0
    SUPER_SPEED_ASTEROIDS=0

    safe_save_profile
    printf "${COLOR_GREEN:-\033[32m} ✓ Punishment expired! Profile restored. Don't mess up again! ${COLOR_NEUTRAL:-\033[0m}\n"
}

# ------------------------------
# Apply BRUTAL long-term punishment
# ------------------------------
apply_long_term_punishment() {
    local current_time
    current_time=$(date +%s)
    punishment_level=${punishment_level:-0}

    # Backup original profile if first punishment
    if [ -z "$punishment_backup_name" ]; then
        backup_profile_for_punishment
    fi

    # Check if punishment is active (ESCALATE HARD)
    if [ "$punishment_expires" -gt "$current_time" ]; then
        punishment_level=$((punishment_level + 1))

        # Duration TRIPLES each time (gets MUCH worse)
        local prev_days=${punishment_prev_days:-3}
        local days=$(( prev_days * 3 ))
        [ "$days" -gt 90 ] && days=90  # Cap at 90 days max
        punishment_prev_days=$days
        punishment_expires=$((current_time + days*24*60*60))

        # INVERT gender from ORIGINAL backup (not current)
        case "$punishment_backup_gender" in
            "Male")
                player_gender="Female"
                player_title="Lady ${LOSER_TITLES[$RANDOM % ${#LOSER_TITLES[@]}]}"
                ;;
            "Female")
                player_gender="Male"
                player_title="Lord ${LOSER_TITLES[$RANDOM % ${#LOSER_TITLES[@]}]}"
                ;;
            *)
                player_gender="Alien"
                player_title="Entity ${LOSER_TITLES[$RANDOM % ${#LOSER_TITLES[@]}]}"
                ;;
        esac

        # Progressively WORSE names
        local base_name="${LOSER_NAMES[$RANDOM % ${#LOSER_NAMES[@]}]}"
        
        if [ "$punishment_level" -eq 2 ]; then
            player_name="${base_name}9000"
        elif [ "$punishment_level" -eq 3 ]; then
            player_name="xXx_${base_name}_xXx"
        elif [ "$punishment_level" -eq 4 ]; then
            player_name="${base_name}_FAIL"
        elif [ "$punishment_level" -ge 5 ]; then
            player_name="ULTIMATE_${base_name}_666"
        else
            player_name="$base_name"
        fi

        # BRUTAL equipment downgrades
        current_skin=${PUNISHMENT_SKINS[$RANDOM % ${#PUNISHMENT_SKINS[@]}]}
        current_ship=1  # Worst ship always
        ammo=$((ammo / 3))
        [ "$ammo" -lt 1 ] && ammo=1

        # Make name PERMANENT if level >= 3 (BRUTAL)
        if [ "$punishment_level" -ge 3 ]; then
            punishment_backup_name="$player_name"
            printf "${COLOR_RED:-\033[31m} ☠ YOUR SHAMEFUL NAME IS NOW PERMANENT! ☠ ${COLOR_NEUTRAL:-\033[0m}\n"
        fi

        # Activate PROGRESSIVE super punishments
        REVERSE_CONTROLS_ACTIVE=0
        DRUNK_MODE_ACTIVE=0
        RANDOM_TELEPORT_ACTIVE=0
        SHRINKING_SHIP_ACTIVE=0
        INVERTED_SCREEN=0
        SUPER_SPEED_ASTEROIDS=0

        if [ "$punishment_level" -ge 2 ]; then
            REVERSE_CONTROLS_ACTIVE=1
        fi
        if [ "$punishment_level" -ge 3 ]; then
            DRUNK_MODE_ACTIVE=1
            SUPER_SPEED_ASTEROIDS=1
        fi
        if [ "$punishment_level" -ge 4 ]; then
            RANDOM_TELEPORT_ACTIVE=1
            INVERTED_SCREEN=1
        fi
        if [ "$punishment_level" -ge 5 ]; then
            SHRINKING_SHIP_ACTIVE=1
            # MAXIMUM PUNISHMENT
            printf "${COLOR_RED:-\033[31m}\n"
            printf "╔═══════════════════════════════════════════╗\n"
            printf "║  ☠ MAXIMUM PUNISHMENT ACTIVATED ☠        ║\n"
            printf "║  YOU ARE THE WORST PILOT IN THE GALAXY!  ║\n"
            printf "║  SHAME! SHAME! SHAME!                    ║\n"
            printf "╚═══════════════════════════════════════════╝\n"
            printf "${COLOR_NEUTRAL:-\033[0m}\n"
        fi

        safe_save_profile
        
        printf "${COLOR_RED:-\033[31m}\n"
        printf "⚠⚠⚠ PUNISHMENT ESCALATED TO LEVEL $punishment_level ⚠⚠⚠\n"
        printf "╔═══════════════════════════════════════════╗\n"
        printf "║ Name: %-37s ║\n" "$player_name"
        printf "║ Title: %-36s ║\n" "$player_title"
        printf "║ Gender: %-35s ║\n" "$player_gender"
        printf "║ Duration: %-32s ║\n" "$days day(s)"
        printf "║ Ammo: %-36s ║\n" "$ammo"
        printf "╠═══════════════════════════════════════════╣\n"
        [ "$REVERSE_CONTROLS_ACTIVE" -eq 1 ] && printf "║ 🔄 REVERSE CONTROLS ACTIVE                ║\n"
        [ "$DRUNK_MODE_ACTIVE" -eq 1 ] && printf "║ 🍺 DRUNK MODE ACTIVE                      ║\n"
        [ "$RANDOM_TELEPORT_ACTIVE" -eq 1 ] && printf "║ 🌀 RANDOM TELEPORTS ACTIVE                ║\n"
        [ "$SHRINKING_SHIP_ACTIVE" -eq 1 ] && printf "║ 📉 SHRINKING SHIP ACTIVE                  ║\n"
        [ "$INVERTED_SCREEN" -eq 1 ] && printf "║ 🙃 INVERTED SCREEN ACTIVE                 ║\n"
        [ "$SUPER_SPEED_ASTEROIDS" -eq 1 ] && printf "║ ⚡ SUPER SPEED ASTEROIDS ACTIVE           ║\n"
        printf "╚═══════════════════════════════════════════╝\n"
        printf "${COLOR_NEUTRAL:-\033[0m}\n"
        
        return
    fi

    # FIRST-TIME PUNISHMENT
    punishment_level=1
    local days=3
    punishment_prev_days=$days
    punishment_expires=$((current_time + days*24*60*60))

    # Invert gender from ORIGINAL backup
    case "$punishment_backup_gender" in
        "Male")
            player_gender="Female"
            player_title="Lady ${LOSER_TITLES[$RANDOM % ${#LOSER_TITLES[@]}]}"
            ;;
        "Female")
            player_gender="Male"
            player_title="Lord ${LOSER_TITLES[$RANDOM % ${#LOSER_TITLES[@]}]}"
            ;;
        *)
            player_gender="Alien"
            player_title="Entity ${LOSER_TITLES[$RANDOM % ${#LOSER_TITLES[@]}]}"
            ;;
    esac

    # First punishment name and equipment
    player_name="${LOSER_NAMES[$RANDOM % ${#LOSER_NAMES[@]}]}"
    current_skin=${PUNISHMENT_SKINS[$RANDOM % ${#PUNISHMENT_SKINS[@]}]}
    current_ship=1
    ammo=$((ammo / 2))
    [ "$ammo" -lt 1 ] && ammo=1

    safe_save_profile
    
    printf "${COLOR_RED:-\033[31m}\n"
    printf "╔═══════════════════════════════════════════╗\n"
    printf "║    ⚠ PUNISHMENT ACTIVATED ⚠              ║\n"
    printf "║ You have brought shame upon yourself!    ║\n"
    printf "╠═══════════════════════════════════════════╣\n"
    printf "║ Duration: $days days | Level: $punishment_level                  ║\n"
    printf "║ Name: %-37s ║\n" "$player_name"
    printf "║ Title: %-36s ║\n" "$player_title"
    printf "║ Gender: %-35s ║\n" "$player_gender"
    printf "╚═══════════════════════════════════════════╝\n"
    printf "${COLOR_NEUTRAL:-\033[0m}\n"
}

# ------------------------------
# Check if long-term punishment expired
# ------------------------------
check_long_term_punishment() {
    local current_time
    current_time=$(date +%s)
    if [ "$punishment_expires" -gt 0 ] && [ "$punishment_expires" -le "$current_time" ] && [ -n "$punishment_backup_name" ]; then
        restore_profile_after_punishment
    fi
}

# ------------------------------
# BRUTAL short-term chaos punishment
# ------------------------------
apply_short_punishment() {
    if [ "$PUNISHMENT_ACTIVE" -eq 1 ]; then return; fi
    
    PUNISHMENT_ACTIVE=1
    PUNISHMENT_TIMER=$PUNISHMENT_DURATION

    # Insult messages
    local messages=(
        "✗ PATHETIC! Even space debris flies better!"
        "✗ Your ancestors are ASHAMED!"
        "✗ The galaxy mocks your incompetence!"
        "✗ DISGRACEFUL PERFORMANCE!"
        "✗ Are you TRYING to fail?!"
        "✗ A TRAINED MONKEY could do better!"
        "✗ WORTHLESS PILOT DETECTED!"
        "✗ GARBAGE! ABSOLUTE GARBAGE!"
    )
    printf "\n${COLOR_RED:-\033[31m} ${messages[$RANDOM % ${#messages[@]}]} ${COLOR_NEUTRAL:-\033[0m}\n"

    # Save original values
    PUNISHMENT_OLD_SKIN="$current_skin"
    PUNISHMENT_OLD_SPEED=$(safe_get_ship_speed "$current_ship")

    # HARSH penalties
    local new_speed=$((PUNISHMENT_OLD_SPEED - 2))
    [ "$new_speed" -lt 1 ] && new_speed=1
    safe_set_ship_speed "$current_ship" "$new_speed"

    # Brutal ammo reduction
    ammo=$((ammo / 4))
    [ "$ammo" -lt 1 ] && ammo=1

    # Visual punishment
    blink_ship_effect
    shake_screen_effect

    # Spawn MANY asteroids based on how bad you are
    local asteroid_count=8
    if [ "$score" -lt "$SUPER_PUNISHMENT_THRESHOLD" ]; then
        asteroid_count=15
        printf "${COLOR_RED:-\033[31m} ☠ SUPER PUNISHMENT ACTIVATED! ☠ ${COLOR_NEUTRAL:-\033[0m}\n"
    fi
    if [ "$score" -lt "$EXTREME_LOSER_THRESHOLD" ]; then
        asteroid_count=25
        printf "${COLOR_RED:-\033[31m}\n"
        printf "╔═══════════════════════════════════════════╗\n"
        printf "║ ☠☠☠ EXTREME LOSER DETECTED! ☠☠☠          ║\n"
        printf "║ YOU ARE A DISGRACE TO ALL PILOTS!        ║\n"
        printf "╚═══════════════════════════════════════════╝\n"
        printf "${COLOR_NEUTRAL:-\033[0m}\n"
    fi
    
    for i in $(seq 1 $asteroid_count); do
        safe_spawn_asteroid
    done

    # Force ugliest skin
    current_skin=5

    # Activate random BRUTAL effects
    local effect=$((RANDOM % 6))
    case $effect in
        0)
            INVERTED_SCREEN=1
            printf "${COLOR_YELLOW:-\033[33m} 🙃 SCREEN INVERTED! ${COLOR_NEUTRAL:-\033[0m}\n"
            ;;
        1)
            REVERSE_CONTROLS_ACTIVE=1
            printf "${COLOR_YELLOW:-\033[33m} ⬅➡ CONTROLS REVERSED! ${COLOR_NEUTRAL:-\033[0m}\n"
            ;;
        2)
            DRUNK_MODE_ACTIVE=1
            printf "${COLOR_YELLOW:-\033[33m} 🍺 DRUNK MODE! ${COLOR_NEUTRAL:-\033[0m}\n"
            ;;
        3)
            SHRINKING_SHIP_ACTIVE=1
            printf "${COLOR_YELLOW:-\033[33m} 📉 SHIP SHRINKING! ${COLOR_NEUTRAL:-\033[0m}\n"
            ;;
        4)
            RANDOM_TELEPORT_ACTIVE=1
            printf "${COLOR_YELLOW:-\033[33m} 🌀 RANDOM TELEPORTS! ${COLOR_NEUTRAL:-\033[0m}\n"
            ;;
        5)
            SUPER_SPEED_ASTEROIDS=1
            printf "${COLOR_YELLOW:-\033[33m} ⚡ SUPER SPEED ASTEROIDS! ${COLOR_NEUTRAL:-\033[0m}\n"
            ;;
    esac
}

# ------------------------------
# Process input with reverse controls
# ------------------------------
process_punishment_input() {
    local input="$1"
    local output="$input"
    
    # Reverse controls if active
    if [ "$REVERSE_CONTROLS_ACTIVE" -eq 1 ]; then
        case "$input" in
            w|W) output="s" ;;
            s|S) output="w" ;;
            a|A) output="d" ;;
            d|D) output="a" ;;
            *) output="$input" ;;
        esac
    fi
    
    echo "$output"
}

# ------------------------------
# Apply drunk mode ship drift
# ------------------------------
apply_drunk_drift() {
    if [ "$DRUNK_MODE_ACTIVE" -eq 1 ] && [ -n "${ship_y:-}" ] && [ -n "${ship_x:-}" ]; then
        if [ $((RANDOM % 4)) -eq 0 ]; then
            local drift=$((RANDOM % 3 - 1))
            ship_y=$((ship_y + drift))
            ship_x=$((ship_x + drift))
            # Boundary check
            [ -n "${HEIGHT:-}" ] && [ -n "${WIDTH:-}" ] && {
                [ "$ship_y" -lt 2 ] && ship_y=2
                [ "$ship_y" -gt $((HEIGHT - 3)) ] && ship_y=$((HEIGHT - 3))
                [ "$ship_x" -lt 2 ] && ship_x=2
                [ "$ship_x" -gt $((WIDTH - 10)) ] && ship_x=$((WIDTH - 10))
            }
        fi
    fi
}

# ------------------------------
# Check and apply random teleport
# ------------------------------
apply_random_teleport() {
    if [ "$RANDOM_TELEPORT_ACTIVE" -eq 1 ] && [ -n "${WIDTH:-}" ] && [ -n "${HEIGHT:-}" ]; then
        if [ $((RANDOM % 30)) -eq 0 ]; then
            ship_x=$((RANDOM % (WIDTH - 15) + 5))
            ship_y=$((RANDOM % (HEIGHT - 8) + 4))
            printf "${COLOR_YELLOW:-\033[33m} ⚡ TELEPORTED! ${COLOR_NEUTRAL:-\033[0m}\n"
            blink_ship_effect
        fi
    fi
}

# ------------------------------
# Get ship size scale factor
# ------------------------------
get_ship_scale() {
    if [ "$SHRINKING_SHIP_ACTIVE" -eq 1 ]; then
        echo "$((50 + (PUNISHMENT_TIMER % 50)))"
    else
        echo "100"
    fi
}

# ------------------------------
# Get asteroid speed multiplier
# ------------------------------
get_asteroid_speed_multiplier() {
    if [ "$SUPER_SPEED_ASTEROIDS" -eq 1 ]; then
        echo "3"
    else
        echo "1"
    fi
}

# ------------------------------
# Check if screen should be inverted
# ------------------------------
is_screen_inverted() {
    [ "$INVERTED_SCREEN" -eq 1 ] && return 0 || return 1
}

# ------------------------------
# Punishment tick - ACTUALLY APPLY EFFECTS
# ------------------------------
punishment_tick() {
    if [ "$PUNISHMENT_ACTIVE" -eq 0 ] && [ "$punishment_level" -eq 0 ]; then
        return
    fi

    # Apply drunk mode drift
    apply_drunk_drift
    
    # Apply random teleport
    apply_random_teleport

    # Set global flags for other systems to use
    export CONTROLS_REVERSED=$REVERSE_CONTROLS_ACTIVE
    export SHIP_SHRINK_FACTOR=$(get_ship_scale)
    export ASTEROID_SPEED_MULTIPLIER=$(get_asteroid_speed_multiplier)
    export SCREEN_INVERTED=$INVERTED_SCREEN

    # Blink effect during punishment
    if [ "$PUNISHMENT_ACTIVE" -eq 1 ]; then
        if [ -n "${frame:-}" ] && [ $((frame % 7)) -eq 0 ]; then
            safe_draw_ship
        fi
        
        # Countdown timer
        PUNISHMENT_TIMER=$((PUNISHMENT_TIMER - 1))
        
        if [ "$PUNISHMENT_TIMER" -le 0 ]; then
            # END SHORT-TERM PUNISHMENT
            PUNISHMENT_ACTIVE=0
            
            # Restore original values
            current_skin="$PUNISHMENT_OLD_SKIN"
            safe_set_ship_speed "$current_ship" "$PUNISHMENT_OLD_SPEED"
            ammo=$(safe_get_ship_ammo "$current_ship")
            
            # Clear short-term effects only
            REVERSE_CONTROLS_ACTIVE=0
            DRUNK_MODE_ACTIVE=0
            RANDOM_TELEPORT_ACTIVE=0
            SHRINKING_SHIP_ACTIVE=0
            INVERTED_SCREEN=0
            SUPER_SPEED_ASTEROIDS=0
            
            export CONTROLS_REVERSED=0
            export SHIP_SHRINK_FACTOR=100
            export ASTEROID_SPEED_MULTIPLIER=1
            export SCREEN_INVERTED=0
            
            printf "${COLOR_GREEN:-\033[32m} ✓ Short-term punishment ended! ${COLOR_NEUTRAL:-\033[0m}\n"
        fi
    fi
}

# ------------------------------
# Apply movement with punishment effects
# ------------------------------
apply_punished_movement() {
    local input="$1"
    local processed_input
    
    # Process input through reverse controls if active
    processed_input=$(process_punishment_input "$input")
    
    # Apply the processed movement
    case "$processed_input" in
        w|W)
            if [ "$ship_y" -gt 2 ]; then
                ship_y=$((ship_y - 1))
            fi
            ;;
        s|S)
            if [ "$ship_y" -lt $((HEIGHT - 3)) ]; then
                ship_y=$((ship_y + 1))
            fi
            ;;
        a|A)
            if [ "$ship_x" -gt 2 ]; then
                ship_x=$((ship_x - 1))
            fi
            ;;
        d|D)
            if [ "$ship_x" -lt $((WIDTH - 10)) ]; then
                ship_x=$((ship_x + 1))
            fi
            ;;
    esac
    
    # Apply drunk drift after movement
    apply_drunk_drift
}

# ------------------------------
# Visual effects
# ------------------------------
blink_ship_effect() {
    for i in {1..4}; do
        if [ -n "${ship_y:-}" ] && [ -n "${ship_x:-}" ]; then
            # Only execute tput if in terminal
            if [ -t 1 ]; then
                tput cup "$ship_y" "$ship_x" 2>/dev/null && printf "   "
            fi
            sleep 0.08
            safe_draw_ship
            sleep 0.08
        fi
    done
}

shake_screen_effect() {
    if [ -t 1 ]; then
        for i in {1..8}; do
            tput cup $((RANDOM % 4)) $((RANDOM % 4)) 2>/dev/null
            sleep 0.04
        done
        tput cup 0 0 2>/dev/null
    fi
}

# ------------------------------
# Insult generator
# ------------------------------
generate_insult() {
    local insults=(
        "You're a DISGRACE to all pilots!"
        "My TOASTER flies better than you!"
        "Are you BLIND or just INCOMPETENT?"
        "The asteroids are EMBARRASSED for you!"
        "PATHETIC! Absolutely PATHETIC!"
        "You should be BANNED from flying!"
        "WORST. PILOT. EVER."
        "Your flight school wants a REFUND!"
        "Even SPACE DEBRIS has better aim!"
        "SHAMEFUL! Your family weeps!"
        "Git gud, SCRUB!"
        "You're making EVERYONE look bad!"
    )
    printf "${COLOR_RED:-\033[31m} ► ${insults[$RANDOM % ${#insults[@]}]} ${COLOR_NEUTRAL:-\033[0m}\n"
}

# ------------------------------
# Main punishment trigger
# ------------------------------
check_low_score_punishment() {
    if [ "${score:-0}" -lt "$LOW_SCORE_THRESHOLD" ]; then
        apply_short_punishment
        apply_long_term_punishment
        
        # Extra insults for terrible players
        if [ "${score:-0}" -lt "$SUPER_PUNISHMENT_THRESHOLD" ]; then
            generate_insult
        fi
        
        if [ "${score:-0}" -lt "$EXTREME_LOSER_THRESHOLD" ]; then
            generate_insult
            generate_insult
        fi
    fi
}

# ------------------------------
# Hall of Shame
# ------------------------------
SHAME_FILE="${GAME_DIR:-.}/.hall_of_shame"

add_to_hall_of_shame() {
    local shame_score=$1
    local shame_name=$2
    echo "$shame_score|$shame_name|$(date '+%Y-%m-%d %H:%M')" >> "$SHAME_FILE"
    printf "${COLOR_RED:-\033[31m}\n"
    printf "╔═══════════════════════════════════════════╗\n"
    printf "║  📜 ADDED TO HALL OF SHAME! 📜            ║\n"
    printf "║  Your failure is now PERMANENT!          ║\n"
    printf "╚═══════════════════════════════════════════╝\n"
    printf "${COLOR_NEUTRAL:-\033[0m}\n"
}

show_hall_of_shame() {
    if [ -f "$SHAME_FILE" ]; then
        printf "\n${COLOR_RED:-\033[31m}"
        printf "╔═══════════════════════════════════════════╗\n"
        printf "║         HALL OF SHAME (Top 10)           ║\n"
        printf "╠═══════════════════════════════════════════╣\n"
        sort -t'|' -k1 -n "$SHAME_FILE" 2>/dev/null | head -10 | while IFS='|' read -r score name datetime; do
            printf "║ %-5s | %-20s | %-10s ║\n" "$score" "${name:0:20}" "${datetime:0:10}"
        done
        printf "╚═══════════════════════════════════════════╝\n"
        printf "${COLOR_NEUTRAL:-\033[0m}\n"
    fi
}

# Auto-add to shame on game over if score is terrible
check_and_add_to_shame() {
    if [ "${score:-0}" -lt "$EXTREME_LOSER_THRESHOLD" ]; then
        add_to_hall_of_shame "${score:-0}" "${player_name:-Unknown}"
    fi
}