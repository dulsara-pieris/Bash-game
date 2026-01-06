#!/bin/sh
# Merge all player profiles into data/players_merged.profile

PLAYERS_DIR="./data/players"
MERGED_FILE="./data/players_merged.profile"

echo "# Merged player profiles" > "$MERGED_FILE"

for file in "$PLAYERS_DIR"/*.profile; do
  [ -f "$file" ] || continue
  echo "" >> "$MERGED_FILE"
  echo "# $(basename "$file")" >> "$MERGED_FILE"
  cat "$file" >> "$MERGED_FILE"
done

echo "All player profiles merged into $MERGED_FILE"
