# Day 05: If You Give A Seed A Fertilizer

# ==============================================================================

# Get input filename as CLI arg. If not given, default to "day<X>.in"
if length(ARGS) > 0
  fname = ARGS[1]
else
  fname = replace(PROGRAM_FILE, ".jl" => ".in")
end

# Parse input
seeds = nothing
maps = Dict()
lines = readlines(fname)
for lno in 1:length(lines)
  line = lines[lno]
  if length(line) == 0
    lno += 1
  elseif startswith(line, "seeds")
    global seeds = [parse(Int, x) for x in split(split(line, ":")[2], " ", keepempty=false)]
    lno += 1
  elseif occursin("map", line)
    map_name = split(line, " ")[1]
    maps[map_name] = []
    while length(line) > 0 && lno < length(lines)
      lno += 1
      line = lines[lno]
      numbers = [parse(Int, x) for x in split(line, " ", keepempty=false)]
      if length(numbers) > 0
        push!(maps[map_name], numbers)
      end
    end
  end
  if lno > length(lines)
    break
  end
end

maps_order = ["seed-to-soil", "soil-to-fertilizer", "fertilizer-to-water", "water-to-light", "light-to-temperature", "temperature-to-humidity", "humidity-to-location"]

# ------------------------------------------------------------------------------
# Part 1

function find_seed_location(seed)

  current = seed
  for map_name in maps_order
    
    # println(map_name)
    rules = maps[map_name]
    found = false
    for (dst, src, len) in rules
      if src <= current <= (src+len-1) 
        # println(src, " ", dst, " ", len)
        new_current = dst + (current-src)
        found = true
        break
      end
    end
    if !found 
      new_current = current
    end
    # println(current, "->", new_current)
    current = new_current
    
  end
  
  return current

end

min_loc1 = nothing
for seed in seeds
  loc = find_seed_location(seed)
  if min_loc1 == nothing || loc < min_loc1
    global min_loc1 = loc
  end
end

println("Part 1: ", min_loc1)

# ------------------------------------------------------------------------------
# Part 2

# Nope
# min_loc2 = nothing
# for i in 1:2:length(seeds)
#   start = seeds[i]
#   len = seeds[i+1]
#   for seed in start:(start+len-1)
#     loc = find_seed_location(seed)
#     if min_loc2 == nothing || loc < min_loc2
#       global min_loc2 = loc
#     end
#   end
# end

function location_to_seed(loc)

  current = loc
  for map_name in reverse(maps_order)
    
    # println(map_name)
    rules = maps[map_name]
    found = false
    for (src, dst, len) in rules
      if src <= current <= (src+len-1) 
        # println(src, " ", dst, " ", len)
        new_current = dst + (current-src)
        found = true
        break
      end
    end
    if !found 
      new_current = current
    end
    # println(current, "->", new_current)
    current = new_current
    
  end
  
  return current

end

start = Int(parse(Int, ARGS[2])*1e6)
stop = Int(parse(Int, ARGS[3])*1e6)
solution = nothing
sol_found = false
count = 0
for loc in start:stop
  
  seed = location_to_seed(loc)
  
  for i in 1:2:length(seeds)
    s1 = seeds[i]
    len = seeds[i+1]
    if s1 <= seed <= s1+len-1
      global solution = loc
      global sol_found = true
    end
  end

  if sol_found
    break
  end

  global count += 1

  if mod(count, 1000000) == 0
    println((start+count)/1e6)
  end

end

println("Part 2: ", solution)