# Day 01: Trebuchet?!

import string
import sys

# ==============================================================================

# If no specific input given, default to "day<X>.in"
if len(sys.argv) == 1:
  sys.argv.append(sys.argv[0].replace(".py", ".in"))

# Parse input
lines = []
with open(sys.argv[1]) as f:
  for line in f:
    lines.append(line.strip())

# ------------------------------------------------------------------------------
# Part 1

total = 0
for line in lines:
  digits = [c for c in line if c in string.digits]
  total += int(digits[0]+digits[-1])

print("Part 1:", total)

# ------------------------------------------------------------------------------
# Part 2

subs = {"one": "1", "two": "2", "three": "3", "four": "4", "five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9"}

total = 0
for line in lines:
  # forward
  i = 0
  first = None
  while i < len(line):
    if line[i] in string.digits:
      first = line[i]
      break
    for k, v in subs.items():
      if line[i:i+len(k)] == k:
        first = v
        break
    if first is not None:
      break
    i += 1
  # backward
  i = len(line)-1
  last = None
  while i >= 0:
    if line[i] in string.digits:
      last = line[i]
      break
    for k, v in subs.items():
      if line[i:i+len(k)] == k:
        last = v
        break
    if last is not None:
      break
    i -= 1  
  
  total += int(first[0]+last[-1])

print("Part 2:", total)