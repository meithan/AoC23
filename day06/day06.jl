# Day 06: Wait For It

# ==============================================================================

# Get input filename as CLI arg. If not given, default to "day<X>.in"
if length(ARGS) > 0
  fname = ARGS[1]
else
  fname = replace(PROGRAM_FILE, ".jl" => ".in")
end

# Parse input
lines = readlines(fname)
times = [parse(Int, x) for x in split(lines[1], " ", keepempty=false)[2:end]]
records = [parse(Int, x) for x in split(lines[2], " ", keepempty=false)[2:end]]
num_races = length(times)

# ------------------------------------------------------------------------------
# Part 1

counts = []
for i in 1:num_races
  race_time = times[i]
  record = records[i]
  count = 0
  for hold_time in 1:race_time-1
    distance = (race_time - hold_time) * hold_time
    if distance > record
      count += 1
    end
  end
  push!(counts, count)
end

answer = reduce(*, counts, init=1)

println("Part 1: ", answer)

# ------------------------------------------------------------------------------
# Part 2

time = parse(Int, replace(lines[1][10:end], " "=>""))
dist = parse(Int, replace(lines[2][10:end], " "=>""))

w1 = Int(ceil((time - sqrt(time^2-4*dist))/2))
w2 = Int(floor((time + sqrt(time^2-4*dist))/2))

answer = w2-w1+1

println("Part 2: ", answer)