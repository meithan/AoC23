# Day 07: Camel Cards

# ==============================================================================

# Get input filename as CLI arg. If not given, default to "day<X>.in"
if length(ARGS) > 0
  fname = ARGS[1]
else
  fname = replace(PROGRAM_FILE, ".jl" => ".in")
end

const FIVE_OF_A_KIND = 7
const FOUR_OF_A_KIND = 6
const FULL_HOUSE = 5
const THREE_OF_A_KIND = 4
const TWO_PAIRS = 3
const ONE_PAIR = 2
const HIGH_CARD = 1

const hands_names = ["High Card", "One Pair", "Two Pairs", "Three of a Kind", "Full House", "Four of a Kind", "Five of a Kind"]

const card_names = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2']

# Get a cards value, so the letters return a value
# For part 2, we assign 'J' a value of 1 instead of 11
function get_card_value(card)
  if card == 'A' return 14
  elseif card == 'K' return 13
  elseif card == 'Q' return 12
  elseif card == 'J'
    if part == 1 return 11
    elseif part == 2 return 1
    end
  elseif card == 'T' return 10
  else return parse(Int, card)
  end
end

# Evaluate a hand
function evaluate_hand(hand)

  # Count the number of repetitions of each card
  counts_dict = Dict()
  for card in hand
    if !haskey(counts_dict, card) counts_dict[card] = 0 end
    counts_dict[card] += 1
  end
  counts = values(counts_dict)

  if 5 in counts return FIVE_OF_A_KIND
  elseif 4 in counts return FOUR_OF_A_KIND
  elseif 3 in counts && 2 in counts return FULL_HOUSE
  elseif 3 in counts return THREE_OF_A_KIND
  elseif count(x->(x==2), counts) == 2 return TWO_PAIRS
  elseif 2 in counts return ONE_PAIR
  else return HIGH_CARD
  end

end

# Hand sorting comparison function: returns whether hand1 < hand2
function compare_hands(hand1, hand2)
  if hand1[1] < hand2[1]
    return true
  elseif hand1[1] > hand2[1]
    return false
  else
    for i in 1:5
      if get_card_value(hand1[2][i]) < get_card_value(hand2[2][i])
        return true
      elseif get_card_value(hand1[2][i]) > get_card_value(hand2[2][i])
        return false
      end
    end
  end
  return false
end

# Parse input
hands = []
lines = readlines(fname)
for line in lines
  cards, bid = split(line, " ")
  push!(hands, (evaluate_hand(cards), cards, parse(Int, bid)))
end


# ------------------------------------------------------------------------------
# Part 1

# Sort the hands by increasing value
part = 1
hands_sorted = sort(hands, lt=compare_hands)

# Coompute total winnings with sorted hands
total_winnings1 = 0
for (rank, hand) in enumerate(hands_sorted)
  global total_winnings1 += hand[3] * rank
end

println("Part 1: ", total_winnings1)

# ------------------------------------------------------------------------------
# Part 2

# New hand evaluation function, including jokers
# The rules are a bit more complicated now
function evaluate_hand2(hand)

  # Separately count repetitions of non-Joker card and number of jokers
  counts_dict = Dict()
  num_Js = 0
  for card in hand
    if card == 'J'
      num_Js += 1
      continue
    end
    if !haskey(counts_dict, card) counts_dict[card] = 0 end
    counts_dict[card] += 1
  end
  counts = values(counts_dict)
  # println(counts, " J=", num_Js)

  if (5 in counts) || (num_Js >= 4) || (num_Js == 3 && 2 in counts ) || (num_Js == 2 && 3 in counts) || (num_Js == 1 && 4 in counts)
    return FIVE_OF_A_KIND
  
  elseif (4 in counts) || (num_Js == 3) || (num_Js == 2 && 2 in counts) || (num_Js == 1 && 3 in counts)
    return FOUR_OF_A_KIND
  
  elseif (3 in counts && 2 in counts) || (count(x->(x==2), counts) == 2 && num_Js == 1)
    return FULL_HOUSE
  
  elseif 3 in counts || (2 in counts && num_Js == 1) || (num_Js == 2)
    return THREE_OF_A_KIND
  
  elseif count(x->(x==2), counts) == 2 || (2 in counts && num_Js == 1)
    return TWO_PAIRS
  
  elseif 2 in counts || num_Js == 1
    return ONE_PAIR
  
  else
    return HIGH_CARD
  end

end

# Re-evaluate hands now including jokers
for i in 1:length(hands)
  hands[i] = (evaluate_hand2(hands[i][2]), hands[i][2], hands[i][3])
end

# Sort the hands by increasing value
part = 2
hands_sorted = sort(hands, lt=compare_hands)

# Coompute total winnings with sorted hands
total_winnings2 = 0
for (rank, hand) in enumerate(hands_sorted)
  global total_winnings2 += hand[3] * rank
end

println("Part 2: ", total_winnings2)