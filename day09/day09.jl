# Day 09: Mirage Maintenance

# ==============================================================================

# Get input filename as CLI arg. If not given, default to "day<X>.in"
if length(ARGS) > 0
  fname = ARGS[1]
else
  fname = replace(PROGRAM_FILE, ".jl" => ".in")
end

# Parse input
histories = []
lines = readlines(fname)
for line in lines
  push!(histories, [parse(Int, x) for x in split(line, " ")])
end

function predict(sequence, part)
  seqs = [sequence]
  while true
    cur_seq = seqs[end]
    if all(x->x==0, cur_seq) break end
    new_seq = []
    for i in 1:length(cur_seq)-1
      push!(new_seq, cur_seq[i+1] - cur_seq[i])
    end
    push!(seqs, new_seq)
  end
  value = 0
  for i in length(seqs)-1:-1:1
    if part == 1
      value += seqs[i][end]
    elseif part == 2
      value = seqs[i][1] - value
    end
  end
  return value
end

# ------------------------------------------------------------------------------
# Part 1

answer1 = 0
for history in histories
  global answer1 += predict(history, 1)
end

println("Part 1: ", answer1)

# ------------------------------------------------------------------------------
# Part 2

answer2 = 0
for history in histories
  global answer2 += predict(history, 2)
end

println("Part 2: ", answer2)