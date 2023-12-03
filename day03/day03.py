# Day 03: Gear Ratios

import string
import sys

# ==============================================================================

# If no specific input given, default to "day<X>.in"
if len(sys.argv) == 1:
  input_fname = sys.argv[0].replace(".py", ".in")
else:
  input_fname = sys.argv[1]

# Read and parse input
grid = []
with open(input_fname) as f:
  for line in f:
    grid.append(line.strip())
nx = len(grid)
ny = len(grid[0])

# ------------------------------------------------------------------------------
# Part 1

def is_part_number(x1, x2, y1, y2):
  x1 = max(x1, 0)
  x2 = min(x2, nx-1)
  y1 = max(y1, 0)
  y2 = min(y2, ny-1)
  chars = string.digits + "."
  for i in range(x1, x2+1):
    for j in range(y1, y2+1):
      if grid[i][j] not in chars:
        return True
  return False 

numbers = {x:[] for x in range(nx)}
total = 0
x = 0
while x < nx:
  y = 0
  while y < ny:
    if grid[x][y] in string.digits:
      j = y
      while j < ny-1 and grid[x][j+1] in string.digits:
        j += 1
      number = int(grid[x][y:j+1])
      numbers[x].append((y,j,number))
      valid = is_part_number(x-1, x+1, y-1, j+1)
      if valid:
        total += number
      y = j+1
    y += 1
  x += 1

print("Part 1:", total)

# ------------------------------------------------------------------------------
# Part 2

def find_adjacent_numbers(x, y):
  adjacent = []
  for xx in (x-1, x, x+1):
    if 0 <= xx < nx:
      for j1, j2, num in numbers[xx]:
        if j1-1 <= y <= j2+1:
          adjacent.append(num)
  return adjacent

total = 0
x = 0
while x < nx:
  y = 0
  while y < ny:
    if grid[x][y] == "*":
      adjacent = find_adjacent_numbers(x, y)
      if len(adjacent) == 2:
        gear_ratio = adjacent[0] * adjacent[1]
        total += gear_ratio
    y += 1
  x += 1    

print("Part 2:", total)
