# Day 02: Cube Conundrum

# ==============================================================================

# Get input filename as CLI arg. If not given, default to "day<X>.in"
if length(ARGS) > 0
  fname = ARGS[1]
else
  fname = replace(PROGRAM_FILE, ".jl" => ".in")
end

# Parse input
games = []
lines = readlines(fname)
for line in lines
  part1, part2 = split(line, ":")
  game_num = parse(Int, part1[6:end])
  sets = []
  for _set in split(part2, ";")
    set = []
    for draw in split(_set, ",")
      amount, color = split(strip(draw), " ")
      push!(set, (parse(Int, amount), color))
    end
    push!(sets, set)
  end
  push!(games, (game_num, sets))
end

# ------------------------------------------------------------------------------
# Part 1

max_cubes = Dict("red"=>12, "green"=>13, "blue"=>14)

function is_valid(game)
  game_num, sets = game
  for set in sets
    for draw in set
      amount, color = draw
      if amount > max_cubes[color]
        return false
      end
    end
  end
  return true
end

valids = []
for game in games
  if is_valid(game)
    push!(valids, game[1])
  end
end

println("Part 1: ", sum(valids))

# ------------------------------------------------------------------------------
# Part 2

tot_power = 0
for game in games
  num, sets = game
  min_cubes = Dict("red"=>0, "green"=>0, "blue"=>0)
  for set in sets
    for draw in set
      amount, color = draw
      min_cubes[color] = max(amount, min_cubes[color])
    end
  end
  power = min_cubes["red"]*min_cubes["green"]*min_cubes["blue"]
  global tot_power += power
end

println("Part 2: ", tot_power)