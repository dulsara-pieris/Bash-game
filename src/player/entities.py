"""
Star Runner — Entities Module
Handles asteroids, crystals, and power-ups
"""

import random
from core.config import NUM_LINES, NUM_COLUMNS
from core.utils import move_cursor, colored
from core.config import COLOR_YELLOW, COLOR_RED, COLOR_MAGENTA

# ------------------------------
# Entity Lists
# ------------------------------

asteroids = []
crystals = []
powerups = []

# ------------------------------
# Spawning Functions
# ------------------------------

def spawn_asteroid():
    """Spawn a new asteroid at random position on right side."""
    line = random.randint(2, NUM_LINES - 3)
    column = NUM_COLUMNS - 2
    asteroids.append({"line": line, "col": column, "symbol": "O"})


def spawn_crystal():
    """Spawn a crystal at random position."""
    line = random.randint(2, NUM_LINES - 3)
    column = NUM_COLUMNS - 2
    crystals.append({"line": line, "col": column, "symbol": "*"})  # could color differently


def spawn_powerup():
    """Spawn a power-up at random position."""
    line = random.randint(2, NUM_LINES - 3)
    column = NUM_COLUMNS - 2
    powerups.append({"line": line, "col": column, "symbol": "+"})


# ------------------------------
# Movement Functions
# ------------------------------

def move_asteroids():
    """Move all asteroids leftwards."""
    global asteroids
    new_list = []
    for a in asteroids:
        a["col"] -= 1
        if a["col"] > 0:
            new_list.append(a)
    asteroids = new_list


def move_crystal():
    """Move all crystals leftwards."""
    global crystals
    new_list = []
    for c in crystals:
        c["col"] -= 1
        if c["col"] > 0:
            new_list.append(c)
    crystals = new_list


def move_powerup():
    """Move all power-ups leftwards."""
    global powerups
    new_list = []
    for p in powerups:
        p["col"] -= 1
        if p["col"] > 0:
            new_list.append(p)
    powerups = new_list


# ------------------------------
# Rendering Helpers
# ------------------------------

def render_entities():
    """Draw all active entities on screen."""
    for a in asteroids:
        move_cursor(a["line"], a["col"])
        print(colored(a["symbol"], COLOR_RED), end="")
    for c in crystals:
        move_cursor(c["line"], c["col"])
        print(colored(c["symbol"], COLOR_YELLOW), end="")
    for p in powerups:
        move_cursor(p["line"], p["col"])
        print(colored(p["symbol"], COLOR_MAGENTA), end="")
