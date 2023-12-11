# Day 10: Pipe Maze

# ==============================================================================

# Get input filename as CLI arg. If not given, default to "day<X>.in"
if length(ARGS) > 0
  fname = ARGS[1]
else
  fname = replace(PROGRAM_FILE, ".jl" => ".in")
end

# Parse input
maze = []
lines = readlines(fname)
for line in lines
  push!(maze, [x for x in line])
end
nx = length(maze[1])
ny = length(maze)

# ------------------------------------------------------------------------------
# Part 1

# Find starting position
for x in 1:nx
  for y in 1:ny
    if maze[y][x] == 'S'
      global start = [x,y]
      break
    end
  end
end

# Determine the starting direction (one of the two possible)
x, y = start
if maze[y][x+1] in ['-', '7', 'J']
  next_dir = "east"
elseif maze[y][x-1] in ['-', 'F', 'L']
  next_dir = "west"
elseif maze[y+1][x] in ['|', 'L', 'J']
  next_dir = "south"
elseif maze[y-1][x] in ['|', '7', 'F']
  next_dir = "north"
end

# Walk until we come back to the start
loop = Set()
segments = []
x, y = start
steps = 0
while true

  push!(loop, [x,y])
  # print([x,y], " ")

  if next_dir == "east"
  
    push!(segments, [[x, y], [x+1, y]])
    global x += 1
    if (maze[y][x] == '-')
      global next_dir = "east"
    elseif (maze[y][x] == '7')
      global next_dir = "south"
    elseif (maze[y][x] == 'J')
      global next_dir = "north"
    end
  
  elseif next_dir == "west"

    push!(segments, [[x, y], [x-1, y]])
    global x -= 1
    if (maze[y][x] == '-')
      global next_dir = "west"
    elseif (maze[y][x] == 'F')
      global next_dir = "south"
    elseif (maze[y][x] == 'L')
      global next_dir = "north"
    end    

  elseif next_dir == "south"

    push!(segments, [[x, y], [x, y+1]])
    global y += 1
    if (maze[y][x] == '|')
      global next_dir = "south"
    elseif (maze[y][x] == 'L')
      global next_dir = "east"
    elseif (maze[y][x] == 'J')
      global next_dir = "west"
    end    

  elseif next_dir == "north"

    push!(segments, [[x, y], [x, y-1]])
    global y -= 1
    if (maze[y][x] == '|')
      global next_dir = "north"
    elseif (maze[y][x] == '7')
      global next_dir = "west"
    elseif (maze[y][x] == 'F')
      global next_dir = "east"
    end

  end

  global steps += 1

  if [x,y] == start
    break
  end

end

answer1 = Int(steps/2)
println("Part 1: ", answer1)

# ------------------------------------------------------------------------------
# Part 2

# Replace the pipe chars by nicely-connecting unicode bars
function niceify(char)
  if char == '|' return '│'
  elseif char == '-' return '─'
  elseif char == 'F' return '┌'
  elseif char == 'J' return '┘'
  elseif char == 'L' return '└'
  elseif char == '7' return '┐'
  elseif char == '.' return ' '
  else return char
  end
end

# Print the maze to the terminal using ANSI color codes
function print_maze(maze)
  for y in 1:ny
    for x in 1:nx
      if maze[y][x] == 'S' print("\e[;46m")
      elseif [x,y] in loop print("\e[1m")
      elseif [x,y] in inside print("\e[30;42m")
      else print("\e[30;1m") end
      print(niceify(maze[y][x]))
      print("\e[0m")
    end
    println()
  end
end

# Returns the "2D cross product", i.e. the z-component of the cross product
# of two 3D vectors that lie in the xy plane
function cross2D(a, b)
  return a[1]*b[2] - a[2]*b[1]
end

# Returns whether ray p + t*d (t>=0) intersects segment a+u*(b-a)
# p, d, a and b are expected to be 2D vectors
using LinearAlgebra: dot
function ray_intersects_segment(p, d, a, b)
  v1 = p - a
  v2 = b - a
  v3 = [-d[2], d[1]]
  t = cross2D(v2, v1)/dot(v2, v3)
  u = dot(v1, v3)/dot(v2, v3)
  return t >= 0 && 0 <= u <= 1
end

# For every non-loop tile, check how many times a ray starting from it
# crosses the loop; if it's odd, then the tile is inside the loop
# Note that we choose non-integer ray direction and starting point
# to prevent intersections with pipe corners
inside = Set()
for x in 1:nx
  # println(x, "/", nx)
  for y in 1:ny
    if !([x,y] in loop)
      count = 0
      for (a, b) in segments
        if ray_intersects_segment([x+0.3,y+0.7], [0.9,0.9], a, b)
          count += 1
        end
      end
      if count % 2 == 1
        push!(inside, [x,y])
      end
    end
  end
end

# print_maze(maze)

println("Part 2: ", length(inside))