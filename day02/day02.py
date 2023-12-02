# Day 02: Cube Conundrum

import string
import sys

# ==============================================================================

# If no specific input given, default to "day<X>.in"
if len(sys.argv) > 1:
  fname = sys.argv[1]
else:
  fname = sys.argv[0].replace(".py", ".in")

# Parse input
games = []
with open(fname) as f:
  for line in f:
    num = int(line.strip().split(":")[0].replace("Game ", ""))
    sets = []
    for _set in line.strip().split(":")[1].split(";"):
      draws = []
      draw = _set.split(",")
      for d in draw:
        amount = int(d.strip().split(" ")[0])
        color = d.strip().split(" ")[1]
        draws.append((amount, color))
      sets.append(draws)
    games.append((num, sets))     

# ------------------------------------------------------------------------------
# Part 1

max_cubes = {"red": 12, "green": 13, "blue": 14}

def is_valid(game):
  num, sets = game
  for _set in sets:
    for amount, color in _set:
      if amount > max_cubes[color]:
        return False
  return True

valids = []
for game in games:
  if is_valid(game):
    valids.append(game[0])

print("Part 1:", sum(valids))

# ------------------------------------------------------------------------------
# Part 2

tot_power = 0
for game in games:
  num, sets = game
  min_cubes = {"red": 0, "green": 0, "blue": 0}
  for _set in sets:
    for amount, color in _set:
      min_cubes[color] = max(amount, min_cubes[color])
  power = min_cubes["red"]*min_cubes["green"]*min_cubes["blue"]
  tot_power += power

print("Part 2:", tot_power)