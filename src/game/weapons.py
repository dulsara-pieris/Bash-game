"""
Star Runner — Weapons Module
Handles lasers and shooting
"""

lasers = []

# ------------------------------
# Fire Laser
# ------------------------------

def fire_laser(state):
    """Fire a laser from the ship's current position."""
    x = state["ship_column"] + 2  # center of ship
    y = state["ship_line"]        # top of ship
    lasers.append({"x": x, "y": y})

# ------------------------------
# Move Lasers
# ------------------------------

def move_lasers():
    """Move all lasers upwards."""
    for laser in lasers:
        laser["y"] -= 1
    # Remove lasers that go off-screen
    lasers[:] = [l for l in lasers if l["y"] > 0]

# ------------------------------
# Render Lasers
# ------------------------------

def render_lasers():
    """Draw lasers on the screen."""
    from core.render import move_cursor, colored
    for laser in lasers:
        move_cursor(laser["y"], laser["x"])
        print(colored("|", "\033[33m"), end="")  # Yellow laser
