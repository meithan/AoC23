# Day 04: Scratchcards

import sys

# ==============================================================================

# If no specific input given, default to "day<X>.in"
if len(sys.argv) == 1:
  input_fname = sys.argv[0].replace(".py", ".in")
else:
  input_fname = sys.argv[1]

# Read and parse input
cards = []
with open(input_fname) as f:
  for line in f:
    parts = line.split(":")[1].split(" | ")
    winning = [int(x) for x in parts[0].strip().split(" ") if x != ""]
    own = [int(x) for x in parts[1].strip().split(" ") if x != ""]
    cards.append((winning, own))

# ------------------------------------------------------------------------------
# Part 1

cards_matches = []

tot_points = 0
for card in cards:
  winning, own = card
  matches = 0
  for num in own:
    if num in winning:
      matches += 1
  points = 2**(matches-1) if matches >= 1 else 0
  cards_matches.append(matches)
  tot_points += points

print("Part 1:", tot_points)

# ------------------------------------------------------------------------------
# Part 2

# Too slow!
# to_check = [i+1 for i in range(len(cards))]
# retired = []
# while len(to_check) > 0:
#   num = to_check.pop(0)
#   retired.append(num)
#   matches = cards_matches[num-1]
#   for n in list(range(num+1, num+matches+1)):
#     to_check.append(n)

spawns = {}
def count_spawns(num):
  if num in spawns:       # Memoization, baby!
    return spawns[num]
  matches = cards_matches[num-1]
  count = 1
  for n in range(num+1, num+1+matches):
    count += count_spawns(n)
  spawns[num] = count
  return count

tot_cards = 0
for num in range(1, len(cards)+1):
  tot_cards += count_spawns(num)

print("Part 2:", tot_cards)
