# AoC23
My solutions for Advent of Code 2023. In Python 3, and I'm also porting them to Julia as this year I want to learn it. I'll be leaving myself learning notes and comments on the Julia language as I go.

As last year, I'm generally not starting the problems as soon as they open, so I won't usually be reporting solve times.

Go to day: [1](#day1) [2](#day2)

---

**Day 3**: [Gear Ratios](https://adventofcode.com/2023/day/3)<a name="day3"></a> - [my solution](https://github.com/meithan/AoC23/blob/main/day03)

Not difficult, just a matter of correctly parsing the numbers and of finding what's around them in the grid. Had to be specially wary of [off-by-one](https://en.wikipedia.org/wiki/Off-by-one_error) errors.

Julia notes:
* I keep putting colons after `for` and `if` XD
* Length-1 substrings must be compared against characters, using `' '`, nor strings
* Again, Julia shows how much more intuitive indexing from 1 is

---

**Day 2**: [Cube Conundrum](https://adventofcode.com/2023/day/2)<a name="day2"></a> - [my solution](https://github.com/meithan/AoC23/blob/main/day02)

No surprises for Day 2. I did start this one on time and solved Part 1 in 10:00 and Part 2 in an addiional 3:46. It took me way too long to parse the input, as I initially tried to do it with a single regular expression, failed, and went back to less elegant string splitting.

Julia notes and observations:

* It's surprising how similar Julia is to Python (and so far, just as powerful): string splitting (done with `split`, which is a native function and not a method of the String class as in Python) and array/tuple manipulations (defining empty arrays, appending to them, unpacking tuples, e.g. `amount, color = draw`) all are very similar. Porting the Python solution was straightforward and quick.

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