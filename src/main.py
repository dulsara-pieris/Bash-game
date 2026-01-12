#!/usr/bin/env python3
"""
Star Runner — Main Entry Point (Python)
"""

import time
import sys
# Core modules
from core.config import NUM_LINES, NUM_COLUMNS, COLOR_CYAN, COLOR_GREEN, COLOR_NEUTRAL
from core.render import (
    on_enter, on_exit, draw_border, draw_ship, draw_hud,
    draw_stars, move_cursor, launch_sequence, colored, center_text
)
from core.input import handle_input
from core.menu import show_main_menu
from core.effects import launch_sequence

# Player modules
from player.profile import init_profile, save_profile
from player.ships import get_ship_ammo
from player.skins import load_skins  # optional if you use skins

# Game modules
from game.entities import (
    spawn_asteroid, spawn_crystal, spawn_powerup,
    move_asteroids, move_crystal, move_powerup
)
from game.weapons import move_lasers, fire_laser, render_lasers
from game.collision import check_collisions, check_laser_hits
from game.punishments import check_long_term_punishment, apply_punishment_effects
from game.inventory import update_career_stats, calculate_rank

# Shop module
from shop.shop import open_shop  # optional if using shop

# ------------------------------
# Game State
# ------------------------------

state = {
    "ship_line": NUM_LINES // 2,
    "ship_column": 5,
    "paused": 0,
    "asteroid_count": 0,
    "crystal_active": 0,
    "powerup_active": 0,
    "laser_active": 0,
    "shield_active": 0,
    "super_mode_active": 0,
    "weapon_type": 1,
    "frame": 0,
    "score": 0,
    "level": 1,
    "speed_multiplier": 0,
    "crystals_collected": 0,
    "asteroids_destroyed": 0,
    "ammo": 10,
    "shield_active": False,
    "super_mode_active": False
}

# ------------------------------
# Initialize profile
# ------------------------------
profile = init_profile()

# ------------------------------
# Show main menu
# ------------------------------
show_main_menu(profile)

# ------------------------------
# Set ammo based on selected ship
# ------------------------------
current_ship = profile.get("current_ship", 0)
state["ammo"] = get_ship_ammo(current_ship)

# ------------------------------
# Configure terminal input
# ------------------------------
# (handled in core.input if needed)

# ------------------------------
# Initialize screen
# ------------------------------
on_enter()
draw_border()
draw_ship(state)

# ------------------------------
# Launch sequence
# ------------------------------
print(COLOR_CYAN)
launch_sequence()
time.sleep(2)
# Clear banner
move_cursor(NUM_LINES // 2, 0)
print(" " * NUM_COLUMNS)

# ------------------------------
# Main Game Loop
# ------------------------------
try:
    while True:
        if state["paused"] == 0:
            # Player input
            handle_input(state)

            # Level progression
            new_level = state["score"] // 200 + 1
            if new_level != state["level"]:
                state["level"] = new_level
                state["speed_multiplier"] = new_level - 1
                # Level-up notification
                center_text(f"★ LEVEL {state['level']} ★")
                time.sleep(1)
                move_cursor(NUM_LINES // 2, 0)
                print(" " * NUM_COLUMNS)

            # Background and spawning
            if state["frame"] % 10 == 0:
                draw_stars()
            spawn_freq = max(4 - state["speed_multiplier"], 2)
            if state["frame"] % spawn_freq == 0:
                spawn_asteroid()
            if state["frame"] % 20 == 0:
                spawn_crystal()
                spawn_powerup()

            # Update entities
            check_long_term_punishment(profile)
            move_asteroids()
            move_crystal()
            move_powerup()
            move_lasers()

            # Collisions & timers
            check_laser_hits(state)
            check_collisions(state)

            # Render frame
            draw_ship(state)
            render_lasers()
            draw_hud(state, profile)

            # Increment frame
            state["frame"] += 1

            # Update career stats
            update_career_stats(state, profile)

            # Rank calculation
            rank = calculate_rank(profile)

            # Save profile periodically
            save_profile(profile)

        else:
            # Paused: only handle input & draw ship
            handle_input(state)
            draw_ship(state)

        # Frame delay
        time.sleep(0.05)  # adjust speed as needed

except KeyboardInterrupt:
    # Exit gracefully
    on_exit()
    save_profile(profile)
    print("\nExiting Star Runner. Goodbye!")
    sys.exit(0)
