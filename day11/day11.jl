# Day 11: Cosmic Expansion

# ==============================================================================

# Get input filename as CLI arg. If not given, default to "day<X>.in"
if length(ARGS) > 0
  fname = ARGS[1]
else
  fname = replace(PROGRAM_FILE, ".jl" => ".in")
end

# Parse input
orig_map = []
lines = readlines(fname)
for line in lines
  push!(orig_map, [x for x in line])
end

function transpose_map(array)
  new_map = []
  for i in 1:length(array[1])
    line = []
    for j in 1:length(array)
      push!(line, array[j][i])
    end
    push!(new_map, line)
  end
  return new_map
end

function print_map(_map)
  println()
  for line in _map
    for c in line
      print(c)
    end
    println()
  end
end

# Expand universe
expanded_map1 = []
for line in orig_map
  if all(x->x=='.', line)
    push!(expanded_map1, line)
  end
  push!(expanded_map1, line)
end
expanded_map1 = transpose_map(expanded_map1)
expanded_map2 = []
for line in expanded_map1
  if all(x->x=='.', line)
    push!(expanded_map2, line)
  end
  push!(expanded_map2, line)
end
expanded_map = transpose_map(expanded_map2)

# ------------------------------------------------------------------------------
# Part 1

# Find galaxies in expanded map
galaxies = []
for i in 1:length(expanded_map)
  for j in 1:length(expanded_map[1])
    if expanded_map[i][j] == '#'
      push!(galaxies, (i,j))
    end
  end
end

answer1 = 0
# Compute Manhattan distance between all pairs and add them all up
for i in 1:length(galaxies)
  for j in i+1:length(galaxies)
    (x1, y1) = galaxies[i]
    (x2, y2) = galaxies[j]
    distance = abs(x1-x2) + abs(y1-y2)
    global answer1 += distance
  end
end

println("Part 1: ", answer1)

# ------------------------------------------------------------------------------
# Part 2

# How many extra new lines/columns we add during expansion
expansion = 1_000_000 - 1

# Find galaxies in original map
galaxies = []
for i in 1:length(orig_map)
  for j in 1:length(orig_map[1])
    if orig_map[i][j] == '#'
      push!(galaxies, [i,j])
    end
  end
end

# Create a (deep) copy to update coordinates
new_galaxies = deepcopy(galaxies)

# For every blank row in original map, add to the coordinates of
# all galaxies (originally) below it
for i in 1:length(orig_map)
  if all(x->x=='.', orig_map[i][1:end])
    for g in 1:length(galaxies)
      if galaxies[g][1] > i
        new_galaxies[g][1] += expansion
      end
    end
  end
end

# For every blank column in original map, add to the coordinates of
# all galaxies (originally) to the right of it
for j in 1:length(orig_map[1])
  if all(x->x=='.', [orig_map[i][j] for i in 1:length(orig_map)])
    for g in 1:length(galaxies)
      if galaxies[g][2] > j
        new_galaxies[g][2] += expansion
      end
    end
  end
end

answer2 = 0
# Compute Manhattan distance between all pairs and add them all up
for i in 1:length(new_galaxies)
  for j in i+1:length(new_galaxies)
    (x1, y1) = new_galaxies[i]
    (x2, y2) = new_galaxies[j]
    distance = abs(x1-x2) + abs(y1-y2)
    global answer2 += distance
  end
end

println("Part 2: ", answer2)