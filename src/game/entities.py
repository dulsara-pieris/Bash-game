"""
Star Runner — Entities Module
Handles asteroids, crystals, and power-ups
"""

entities = {
    "asteroids": [],
    "crystals": [],
    "powerups": []
}

# ------------------------------
# Spawning
# ------------------------------

def spawn_asteroid():
    entities["asteroids"].append({"x": 0, "y": 0})  # simple placeholder

def spawn_crystal():
    entities["crystals"].append({"x": 0, "y": 0})

def spawn_powerup():
    entities["powerups"].append({"x": 0, "y": 0})

# ------------------------------
# Movement
# ------------------------------

def move_asteroids():
    # move asteroids down
    for a in entities["asteroids"]:
        a["y"] += 1

def move_crystal():
    for c in entities["crystals"]:
        c["y"] += 1

def move_powerup():
    for p in entities["powerups"]:
        p["y"] += 1
