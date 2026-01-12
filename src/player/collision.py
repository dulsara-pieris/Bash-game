"""
Star Runner — Collision Module
Handles collisions between ship, asteroids, crystals, power-ups, and lasers
"""

from core.utils import move_cursor, colored
from core.config import COLOR_GREEN, COLOR_RED, COLOR_YELLOW, NUM_LINES, NUM_COLUMNS
from game.entities import asteroids, crystals, powerups
from game.weapons import lasers
from core.render import draw_hud

# ------------------------------
# Collision Checks
# ------------------------------

def check_collisions(state):
    """Check collisions between ship and entities."""
    ship_line = state["ship_line"]
    ship_col = state["ship_column"]

    # Asteroids collision
    for a in asteroids[:]:
        if a["line"] in range(ship_line, ship_line + 3) and a["col"] in range(ship_col, ship_col + 5):
            asteroids.remove(a)
            state["score"] = max(0, state["score"] - 10)
            state["shield_active"] = False  # ship takes damage
            # Could trigger punishment logic here

    # Crystals collision
    for c in crystals[:]:
        if c["line"] in range(ship_line, ship_line + 3) and c["col"] in range(ship_col, ship_col + 5):
            crystals.remove(c)
            state["score"] += 20
            state["crystals_collected"] += 1

    # Power-ups collision
    for p in powerups[:]:
        if p["line"] in range(ship_line, ship_line + 3) and p["col"] in range(ship_col, ship_col + 5):
            powerups.remove(p)
            state["super_mode_active"] = True
            state["super_timer"] = 50  # lasts 50 frames


def check_laser_hits(state):
    """Check if lasers hit asteroids."""
    global asteroids
    for laser in lasers[:]:
        for a in asteroids[:]:
            if a["line"] == laser["line"] and a["col"] == laser["col"]:
                asteroids.remove(a)
                state["score"] += 10
                state["asteroids_destroyed"] += 1
                laser["hit"] = True
