# Day 08: Haunted Wasteland

# ==============================================================================

# Get input filename as CLI arg. If not given, default to "day<X>.in"
if length(ARGS) > 0
  fname = ARGS[1]
else
  fname = replace(PROGRAM_FILE, ".jl" => ".in")
end

# Parse input
nodes_map = Dict()
lines = readlines(fname)
instructions = lines[1]
num_inst = length(instructions)
for line in lines[3:end]
  node = line[1:3]
  left = line[8:10]
  right = line[13:15]
  nodes_map[node] = (left, right)
end

function walk_map(start)
  steps = 0
  i = 1
  cur_node = start
  while true
    if part == 1 && cur_node == "ZZZ" break
    elseif part == 2 && cur_node[3] == 'Z' break
    end
    inst = instructions[i]
    if inst == 'L'
      cur_node = nodes_map[cur_node][1]
    elseif inst == 'R'
      cur_node = nodes_map[cur_node][2]
    end
    steps += 1
    i += 1
    if i > num_inst i = 1 end
  end
  return steps
end

# ------------------------------------------------------------------------------
# Part 1

part = 1

steps = walk_map("AAA")

println("Part 1: ", steps)

# ------------------------------------------------------------------------------
# Part 2

part = 2

all_steps = []
for node in keys(nodes_map)
  if node[3] == 'A'
    _steps = walk_map(node)
    push!(all_steps, _steps)
  end
end

answer = lcm(all_steps...)

println("Part 2: ", answer)