"""
Star Runner — Punishments Module
Handles long-term punishments, timers, and effects that modify gameplay
"""

# Example punishment levels:
# 0 = none, 1 = mild, 2 = moderate, 3 = severe

import time

def check_long_term_punishment(profile):
    """
    Apply punishments based on profile['punishment_level'].
    Example:
      - Reduce crystals per frame
      - Force ship name change
      - Permanent effects at high levels
    """
    level = profile.get("punishment_level", 0)
    if level == 0:
        return

    # Example: crystals loss over time
    if profile.get("crystals_bank", 0) > 0:
        loss = level * 1  # 1,2,3 crystals per check
        profile["crystals_bank"] -= min(loss, profile["crystals_bank"])

    # Example: temporary stat penalty
    if level >= 2:
        profile["speed_multiplier_penalty"] = 1

    # Example: permanent effect at high level
    if level >= 3:
        profile["permanent_name_change"] = True

def apply_punishment_effects(state, profile):
    """
    Modify gameplay based on active punishments.
    Should be called every frame.
    """
    # Apply speed penalty
    penalty = profile.get("speed_multiplier_penalty", 0)
    state["speed_multiplier"] = max(0, state["speed_multiplier"] - penalty)

    # Example: forced gender/name change (if implemented)
    if profile.get("permanent_name_change", False):
        state["ship_name"] = "Punished Ship"
