"""
Star Runner — Collision Detection Module
Handles collisions between ship, asteroids, crystals, power-ups, and lasers
"""

from game.entities import entities

# ------------------------------
# Laser Hits
# ------------------------------
def check_laser_hits(state):
    """Check if lasers hit asteroids."""
    for laser in state.get("lasers", []):
        for asteroid in entities["asteroids"]:
            if laser["x"] == asteroid["x"] and laser["y"] == asteroid["y"]:
                # Remove asteroid
                entities["asteroids"].remove(asteroid)
                state["score"] += 10
                state["asteroids_destroyed"] += 1
                if laser in state["lasers"]:
                    state["lasers"].remove(laser)

# ------------------------------
# Ship Collisions
# ------------------------------
def check_collisions(state):
    """Check if ship collides with asteroid or powerup."""
    ship_x = state["ship_column"] + 2
    ship_y = state["ship_line"]
    
    # Asteroid collision
    for asteroid in entities["asteroids"]:
        if asteroid["x"] == ship_x and asteroid["y"] == ship_y:
            # Handle collision (reduce shield / end game)
            state["paused"] = 1  # temporary pause as example

    # Crystal collection
    for crystal in entities["crystals"]:
        if crystal["x"] == ship_x and crystal["y"] == ship_y:
            entities["crystals"].remove(crystal)
            state["crystals_collected"] += 1

    # Powerup collection
    for powerup in entities["powerups"]:
        if powerup["x"] == ship_x and powerup["y"] == ship_y:
            entities["powerups"].remove(powerup)
            state["super_mode_active"] = True
