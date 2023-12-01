# Day 01: Trebuchet?!

# ==============================================================================

# Get input filename as CLI arg. If not given, default to "day<X>.in"
if length(ARGS) > 0
  fname = ARGS[1]
else
  fname = replace(PROGRAM_FILE, ".jl" => ".in")
end

# Parse input
lines = readlines(fname)

# ------------------------------------------------------------------------------
# Part 1

digits = ['1', '2', '3', '4', '5', '6', '7', '8', '9']

total = 0
for line in lines
  chars = []
  for c in line
    if c in digits
      push!(chars, c)
    end 
  end
  global total += parse(Int, first(chars)*last(chars))
end

println("Part 1: ", total)

# ------------------------------------------------------------------------------
# Part 2

subs = Dict("one"=>'1', "two"=>'2', "three"=>'3', "four"=>'4', "five"=>'5', "six"=>'6', "seven"=>'7', "eight"=>'8', "nine"=>'9')

total = 0
for line in lines
  # forward
  digit1 = nothing
  for i in 1:length(line)
    if line[i] in digits
      digit1 = line[i]
      break
    end
    for (k, v) in subs
      i2 = min(i+length(k)-1, length(line))
      if line[i:i2] == k
        digit1 = v
        break
      end
    end
    if !isnothing(digit1)
      break
    end
  end
  # backward
  digit2 = nothing
  for i in length(line):-1:1
    if line[i] in digits
      digit2 = line[i]
      break
    end
    for (k, v) in subs
      i2 = min(i+length(k)-1, length(line))
      if line[i:i2] == k
        digit2 = v
        break
      end
    end
    if !isnothing(digit2)
      break
    end
  end  
  global total += parse(Int, digit1*digit2)
  
end

println("Part 2: ", total)