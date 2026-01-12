#!/usr/bin/env python3

"""
SYNAPSNEX OSS-Protection License (SOPL) v1.0
Copyright (c) 2026 Dulsara Pieris

STAR RUNNER ENHANCED — Python Edition
Main Game Entry Point
"""

import sys
import time
import argparse

# Core
from core.config import *
from core.utils import *
from core.input import handle_input
from core.render import (
    on_enter, draw_border, draw_ship, draw_hud, draw_stars, move_cursor
)
from core.menu import show_main_menu
from core.effects import launch_sequence

# Player
from player.profile import init_profile, save_profile
from player.ships import get_ship_ammo
from player.skins import *

# Game
from game.entities import *
from game.collision import *
from game.weapons import *
from game.punishments import check_long_term_punishment
from game.inventory import *

# Shop
from shop.shop import *

# ------------------------------
# CLI ARGUMENTS
# ------------------------------

def parse_args():
    parser = argparse.ArgumentParser(prog="star-runner")
    parser.add_argument("-u", "--update", action="store_true")
    return parser.parse_args()


# ------------------------------
# GAME INITIALIZATION
# ------------------------------

def init_game_state():
    return {
        "ship_line": NUM_LINES // 2,
        "ship_column": 5,
        "paused": False,
        "frame": 0,
        "score": 0,
        "level": 1,
        "speed_multiplier": 0,

        "ammo": 0,
        "weapon_type": 1,
        "weapon_timer": 0,

        "laser_active": False,
        "shield_active": False,
        "shield_timer": 0,
        "super_mode_active": False,
        "super_timer": 0,

        "crystals_collected": 0,
        "asteroids_destroyed": 0,
    }


# ------------------------------
# MAIN GAME LOOP
# ------------------------------

def game_loop(state, profile):
    on_enter()
    draw_border()
    draw_ship(state)

    launch_sequence()

    while True:
        if not state["paused"]:
            handle_input(state)

            # --------------------------
            # LEVEL PROGRESSION
            # --------------------------
            new_level = state["score"] // 200 + 1
            if new_level != state["level"]:
                state["level"] = new_level
                state["speed_multiplier"] = new_level - 1
                level_up_banner(new_level)

            # --------------------------
            # BACKGROUND & SPAWNING
            # --------------------------
            if state["frame"] % 10 == 0:
                draw_stars()

            spawn_freq = max(2, 4 - state["speed_multiplier"])
            if state["frame"] % spawn_freq == 0:
                spawn_asteroid()

            if state["frame"] % 20 == 0:
                spawn_crystal()
                spawn_powerup()

            # --------------------------
            # UPDATE ENTITIES
            # --------------------------
            check_long_term_punishment(profile)
            move_asteroids()
            move_crystal()
            move_powerup()
            move_lasers()

            # --------------------------
            # COLLISIONS & TIMERS
            # --------------------------
            check_laser_hits(state)
            check_collisions(state)
            update_timers(state)

            # --------------------------
            # RENDER
            # --------------------------
            draw_ship(state)
            draw_hud(state, profile)

            # --------------------------
            # STATS UPDATE
            # --------------------------
            profile["high_score"] = max(profile["high_score"], state["score"])
            profile["total_crystals"] += state["crystals_collected"]
            profile["total_asteroids"] += state["asteroids_destroyed"]
            profile["crystals_bank"] += state["crystals_collected"]

            save_profile(profile)

            state["frame"] += 1
            time.sleep(TURN_DURATION)

        else:
            handle_input(state)
            draw_ship(state)


# ------------------------------
# ENTRY POINT
# ------------------------------

def main():
    args = parse_args()

    if args.update:
        update_game()
        sys.exit(0)

    profile = init_profile()
    show_main_menu(profile)

    state = init_game_state()
    state["ammo"] = get_ship_ammo(profile["current_ship"])

    game_loop(state, profile)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        cleanup_and_exit()
