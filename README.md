# AoC23
My solutions for Advent of Code 2023. In Python 3, and I'm also porting them to Julia as this year I want to learn it. I'll be leaving myself learning notes and comments on the Julia language as I go.

As last year, I'm generally not starting the problems as soon as they open, so I won't usually be reporting solve times.

Go to day: [1](#day1) [2](#day2) [3](#day3) [4](#day4) [4](#day4)

---

**Day 5**: [If You Give A Seed A Fertilizer](https://adventofcode.com/2023/day/5)<a name="day5"></a> - [my solution](https://github.com/meithan/AoC23/blob/main/day05)

Since Julia is turning out to be as powerful and expressive as Python, I decided to try this solution in Julia from the get-go. In fact, I think I'll be sticking to Julia only, unless things get too hairy.

Part 1 was easy: it was just a matter of correctly parsing the input and writing the function to map a seed to its final location by following the rules.

From the moment I saw the input I feared that Part 2 was going to ask to search in a huge space -- and that's exactly what happened. After writing a "reverse map function" (to map locations back to the coresponding seed) it was a matter of trying locations and seeing if they mapped to a *valid* seed (checking if a seed is valid is easy: we just check if it's in one of the 10 ranges specified).

So then began the search. Checking the "humidity-to-location map" informed that the kind of values the locations could end up being was possibly in the hundreds of millions -- large, but not intractable. So I began brute-forcing sequential location values starting from zero. Trying the first million values took about 10 seconds. So I decided to split the search space from 0 to 200 million into 8 parallel instances of the program, each starting from a value in 25 million increments. Many of the searches starting at higher values actually finished instantly, since their starting values yielded valid seeds. But I had to wait for all of them to finish to find the minimum. 

And lo and behold, after about 5 minutes all searches finished, and the minimum location that resulted from a valid seed was about 104 millions. Whew!

Julia notes:
* `mod(x, y)` does x modulo y, and `div(a, b)` does integer division
* `reverse` reverses an array
* I used array comprehensions this time!

---

**Day 4**: [Scratchcards](https://adventofcode.com/2023/day/4)<a name="day4"></a> - [my solution](https://github.com/meithan/AoC23/blob/main/day04)

Fairly straightforward one. Except that for Part 2 my initial solution was too slow, as I was actually trying to build the list of all the "spawned" card numbers, and then counting how big it was -- turns out the answer was around 19 million for my input.

The solution was to only *count* how many cards each card spawns, which is the sum of of cards spawned by each the cards that follow it (according to its number of matches). That can be done recursively quite nicely.

To further optimize it (albeit it wasn't really needed), I also memoized the results (number of cards spawned by each card) using a dictionary. That brings to computation time from something like 3.8 seconds down to *24 milliseconds*.

Julia notes:
* `split()` accepts the useful optional boolean argument `keepempty`
* I used `map()` in this one, using the anonymous function definition syntax (similar to `lambda` in Python)
* I learned after the fact that Julia also has [array comprehensions](https://docs.julialang.org/en/v1/manual/arrays/#man-comprehensions)
* Still loving indexing from 1
* Exponentiation uses `^`, not `**`

---

**Day 3**: [Gear Ratios](https://adventofcode.com/2023/day/3)<a name="day3"></a> - [my solution](https://github.com/meithan/AoC23/blob/main/day03)

Not difficult, just a matter of correctly parsing the numbers and of finding what's around them in the grid. Was specially wary of [out of bounds](https://en.wikipedia.org/wiki/Bounds_checking) and [off-by-one](https://en.wikipedia.org/wiki/Off-by-one_error) errors.

Julia notes:
* I keep putting colons after `for`, `if` and `while` XD
* Length-1 substrings must be compared against characters (i.e. using `' '`), not strings
* Again, Julia shows how much more intuitive indexing from 1 is

---

**Day 2**: [Cube Conundrum](https://adventofcode.com/2023/day/2)<a name="day2"></a> - [my solution](https://github.com/meithan/AoC23/blob/main/day02)

No surprises for Day 2. I did start this one on time and solved Part 1 in 10:00 and Part 2 in an addiional 3:46. It took me way too long to parse the input, as I initially tried to do it with a single regular expression, failed, and went back to less elegant string splitting.

Julia notes and observations:

* It's surprising how similar Julia is to Python (and so far, it's just as powerful): string splitting (done with `split`, which is a native function and not a method of the String class as in Python) and array/tuple manipulations (defining arrays, appending to them, slicing them, unpacking tuples, e.g. `amount, color = draw`) all are very similar. Porting the Python solution was straightforward and quick.

---

**Day 1**: [Trebuchet?!](https://adventofcode.com/2023/day/1)<a name="day1"></a> - [my solution](https://github.com/meithan/AoC23/blob/main/day01)

Whoah, solving Part 2 took like 15 minutes because of a nasty special case that is not clearly pointed out in the description (perhaps on purpose): words representing digits can overlap, so `twone` (part of the example) should be parsed as `21`.

My initial solution simply used Python's [`replace`](https://docs.python.org/3/library/stdtypes.html#str.replace), and so the overlaps weren't properly parsed and my first answer was wrong. Took some head scratching to realize what the problem was.

I changed the code from doing string replacements to simply going over the sting character by character until finding the first occurrence of either a digit or a word representing a digit. Then, the same process was done backwards, starting from the end.

I also ported the Python solution to Julia. Notes to self and observations:

* Using `PROGRAM_FILE` and `ARGS` to parse CLI arguments is nice
* `readlines(fname)` is also quite nice
* Remember that in Julia array indices start at 1!
* Strings (using " ") and characters (using ' ') are not the same!
* Having to use `global` inside a loop (which defines its own local scope) to modify a variable that was defined outside the loop is _annoying_
* The exclamation mark after function names (e.g. `push!`) is a convention to indicate they modify their arguments (_side effects_ and stuff)
* `first` and `last` are quite idiomatic
* `nothing` is cute
* I honestly like that ranges include the end value, e.g. `a[1:3]` extracts the substring from position 1 to 3 and `for i in 1:10` includes 10
* For this simple problem, the Julia code takes about 5x as long as the equivalent Python code -- but I think this is mostly from running Julia from the command-line, which has a big initialization overhead it seems
* The Julia solution is actually shorter than the Python one
