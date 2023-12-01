# AoC23
My solutions for Advent of Code 2023. In Python 3 and/or Julia, as this year I want to learn it properly. I'll be leaving myself notes on the language as I learn it.

As last year, I'm not trying to solve the problems as soon as they open, so I won't be reporting solve times.

Go to day: [1](#day1)

---

**Day 1**: [Trebuchet?!](https://adventofcode.com/2023/day/1)<a name="day1"></a> - [my solution](https://github.com/meithan/AoC23/blob/main/day01)

Whoah, solving Part 2 took like 15 minutes because of a nasty special case that is not clearly pointed out in the description (perhaps on purpose): overlaps are acceptable, so `twone` (part of the example) should be parsed as `21`.

My initial solution simply used Python's [`replace`](https://docs.python.org/3/library/stdtypes.html#str.replace), and so the overlaps weren't properly parsed and my first answer was wrong. Took some head scratching to realize what the problem was.

I then changed the code from doing string replacements to simply going over the sting character by character until finding the first occurrence of either a digit or a word representing a digit. Then, same process was done backwards, starting from the end.

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
* For this simple problem, the Julia code takes about 5x as long as the equivalent Python code
* The Julia solution is actually shorter than the Python one