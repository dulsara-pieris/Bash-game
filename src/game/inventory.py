"""
Star Runner — Inventory Module
Tracks player career stats, collected crystals, and destroyed asteroids
"""

# ------------------------------
# Inventory Updates
# ------------------------------

def update_career_stats(state, profile):
    """
    Update career stats such as:
    - total crystals collected
    - total asteroids destroyed
    - high score
    """
    # Update high score
    if state["score"] > profile.get("high_score", 0):
        profile["high_score"] = state["score"]

    # Update totals
    profile["total_crystals"] = profile.get("total_crystals", 0) + state.get("crystals_collected", 0)
    profile["total_asteroids"] = profile.get("total_asteroids", 0) + state.get("asteroids_destroyed", 0)

    # Update crystals bank
    profile["crystals_bank"] = profile.get("crystals_bank", 0) + state.get("crystals_collected", 0)

    # Reset frame counters
    state["crystals_collected"] = 0
    state["asteroids_destroyed"] = 0


# ------------------------------
# Rank Calculation
# ------------------------------

def calculate_rank(profile):
    """Return rank string based on high score."""
    high_score = profile.get("high_score", 0)
    if high_score >= 1000:
        return "Star Pilot"
    elif high_score >= 500:
        return "Space Cadet"
    else:
        return "Neural Trash"
