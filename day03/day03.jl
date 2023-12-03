# Day 03: Gear Ratios

# ==============================================================================

# Get input filename as CLI arg. If not given, default to "day<X>.in"
if length(ARGS) > 0
  fname = ARGS[1]
else
  fname = replace(PROGRAM_FILE, ".jl" => ".in")
end

# Parse input
lines = readlines(fname)
nx = length(lines)
ny = length(lines[1])

# ------------------------------------------------------------------------------
# Part 1

function is_part_number(l, x1, x2)
  for i in l-1:l+1
    for j in x1-1:x2+1
      if 1 <= i <= nx && 1 <= j <= ny
        if !isdigit(lines[i][j]) && lines[i][j] != '.'
          return true
        end
      end
    end
  end
  return false
end

total = 0
numbers = Dict()
for l in 1:length(lines)
  line = lines[l]
  x = 1
  while x <= nx
    if isdigit(line[x])
      x1 = x
      while x1+1 <= nx && isdigit(line[x1+1])
        x1 += 1
      end
      number = parse(Int, line[x:x1])
      if !haskey(numbers, l)
        numbers[l] = []
      end
      push!(numbers[l], (number, x, x1))
      if is_part_number(l, x, x1)
        global total += number
      end
      x = x1
    end 
    x += 1
  end 
end


println("Part 1: ", total)

# ------------------------------------------------------------------------------
# Part 2

function find_adjacent_numbers(x, y)
  adjacent = []
  for xx in (x-1, x, x+1)
    if 1 <= xx <= nx
      for (num, j1, j2) in numbers[xx]
        if j1-1 <= y <= j2+1
          push!(adjacent, num)
        end
      end
    end
  end
  return adjacent
end

total = 0
for x in 1:nx
  for y in 1:ny
    if lines[x][y] == '*'
      adjacent = find_adjacent_numbers(x, y)
      if length(adjacent) == 2
        gear_ratio = adjacent[1] * adjacent[2]
        global total += gear_ratio
      end
    end
  end
end

println("Part 2: ", total)