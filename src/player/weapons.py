"""
Star Runner — Weapons Module
Handles lasers, ammo, and firing logic
"""

from core.config import NUM_COLUMNS
from core.utils import move_cursor, colored
from core.config import COLOR_GREEN

# ------------------------------
# Active lasers list
# ------------------------------

lasers = []  # Each laser: {"line": int, "col": int, "hit": False}

# ------------------------------
# Fire laser
# ------------------------------

def fire_laser(state):
    """Fire a laser from the ship if ammo available."""
    if state.get("ammo", 0) > 0:
        line = state["ship_line"] + 1  # fire from middle of ship
        col = state["ship_column"] + 5  # just in front of ship
        lasers.append({"line": line, "col": col, "hit": False})
        state["ammo"] -= 1


# ------------------------------
# Move lasers
# ------------------------------

def move_lasers():
    """Move all active lasers rightwards."""
    global lasers
    new_list = []
    for l in lasers:
        l["col"] += 1
        if l["col"] < NUM_COLUMNS and not l.get("hit", False):
            new_list.append(l)
    lasers[:] = new_list


# ------------------------------
# Render lasers
# ------------------------------

def render_lasers():
    """Draw lasers on the screen."""
    for l in lasers:
        move_cursor(l["line"], l["col"])
        print(colored("-", COLOR_GREEN), end="")
