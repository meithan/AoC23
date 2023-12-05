# Day 04: Scratchcards

# ==============================================================================

# Get input filename as CLI arg. If not given, default to "day<X>.in"
if length(ARGS) > 0
  fname = ARGS[1]
else
  fname = replace(PROGRAM_FILE, ".jl" => ".in")
end

# Parse input
cards = []
lines = readlines(fname)
 for (card_num, line) in enumerate(lines)
  winning, haves = split(split(line, ":")[2], "|")
  winning = map(x -> parse(Int, x), split(strip(winning), " ", keepempty=false))
  haves = map(x -> parse(Int, x), split(strip(haves), " ", keepempty=false))
  push!(cards, (card_num, winning, haves))
end


# ------------------------------------------------------------------------------
# Part 1

cards_matches = Dict()

tot_points = 0
for (card_num, winning, haves) in cards
  matches = 0
  for num in haves
    if num in winning
      matches += 1
    end
  end
  cards_matches[card_num] = matches
  if matches > 0
    global tot_points += 2^(matches-1)
  end
end

println("Part 1: ", tot_points)

# ------------------------------------------------------------------------------
# Part 2

cache = Dict()

function count_spawned(card_num)
  if haskey(cache, card_num)
    return cache[card_num]
  end
  count = 1
  matches = cards_matches[card_num]
  for n in card_num+1:card_num+matches
    count += count_spawned(n)
  end
  cache[card_num] = count
  return count
end 

total_cards = 0
for n in 1:length(cards)
  global total_cards += count_spawned(n)
end

println("Part 2: ", total_cards)