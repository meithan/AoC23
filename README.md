# AoC23
My solutions for [Advent of Code 2023](https://adventofcode.com/2023).

This year I began dual-solving them in Python and in Julia, as I want to learn/practice Julia, but starting from Day 5 I only solve them in Julia, as I think I'm almost as fluent with it than I am with Python. I left myself Julia learning notes and comments in each problem.

As last year, I'm generally not starting the problems as soon as they open, so I won't usually be reporting solve times.

Go to day: [1](#day1) [2](#day2) [3](#day3) [4](#day4) [5](#day5) [6](#day6) [7](#day7) [8](#day8) [9](#day9) [10](#day10) [11](#day11)

---

**Day 11**: [Cosmic Expansion](https://adventofcode.com/2023/day/11)<a name="day11"></a> - [my solution](https://github.com/meithan/AoC23/blob/main/day11)

When solving Part 1 I actually created the expanded map, as I thought it would be needed for Part 2, which required some fumbling around with awkward not-quite-2D-arrays in Julia (as far as I could tell you can't really transpose a vector of vectors, since they're not actual 2D arrays). After creating the expanded map, it's then a matter of going through all pairs of galaxies (each only once) and computing the Manhattan distance betwen them.

Then, when I got to Part 2 I realized that creating the expanded map is useless. All that was needed is how the expansion alters the coordinates of the galaxies. The rule is simple: for each empty row, the x-coordinate of all galaxies *below* that row get expanded (by adding 1 in Part 1 or 999,999 in Part 2); similarly, for each empty column, the y-coordinate of all galaxies *to the right* of it get expanded. Perhaps the only catch is that we need to keep the original (non-expanded) coordinates to check which galaxies should get updated, and keep the updated coordinates in a separate array.

After doing this, the same Manhattan distance calculation between all pairs (which did not require more time in Part 2) solved the problem.

Julia notes:
* Beware of using `copy` vs `deepcopy()` when cloning nested arrays.
* Once can use thousands separators, e.g. `1_000_000`, for large numeric literals
* I should dig deeper into [multi-dimensional arrays](https://docs.julialang.org/en/v1/manual/arrays/) in Julia, as when done properly they offer many tools and performance gains (just as in Numpy)


---

**Day 10**: [Pipe Maze](https://adventofcode.com/2023/day/10)<a name="day10"></a> - [my solution](https://github.com/meithan/AoC23/blob/main/day10)

Whew, Part 2 of this one took a while.

For Part 1 I simply wrote code to follow the pipes through the maze. This doesn't require a full graph walking/search algorithm (determining which neighbors are reachable), as any tile on the loop only connects to two other tiles: the one we came from, and the next we'll visit. So it's just a matter of switching directions carefully and waiting till we come back to the start. After that, the maximum distance (along the loop) is just half the total distance of the loop.

Part 2, however, was significantly more difficult. What looked like a straightforward flood fill problem was rendered more complicated by the rule that one can "squeeze" between the pipes. I immediately thought of [polygon inclusion testing](https://en.wikipedia.org/wiki/Point_in_polygon): a point lies inside a given polygon if the half-line emanating from it towards infinity (or, in practice, enough distance to exit the bounding box of the polygon) crosses the boundary of the polygon an *odd* number of times, or lies outside the polygon if the number of crossings is even.

Given that the segments of this polygon were either horizontal or vertical, I first tried walking along horizontal or vertical directions, seeing how many squares with part of the loop were encountered. But traveling along the boundary of the polygon is a problem, and I couldn't make it work.

The next morning I revisited the problem bringing out the big cannons: instead of walking through the discrete space of tiles in an axis-align direction, I solved the more general problem of finding ray-segment intersections: from some point inside each candidate tile, I followed a ray towards the outside following a non-horizontal or vertical direction (so as to avoid moving along the boundary) and checked for intersection against every single segment of the loop.

The ray-segment intersection algorithm is as follows: the ray starting at point `p` moving towards direction `d` can be written parametrically as `p + t*d`, where `t >= 0`, while the line segment between points a and b is defined as `a + u*(b-a)` with `0 <= u <= 1`. By setting `p + t*d = a + u*(b-a)` we have two linear equations that can be solved for parameters `t` and `u`. Defining the auxiliary vectors `v1 = p - a`, `v2 = b - a` and `v3 = [-dy, dx]` (a vector normal to the ray), the solution is:

~~~
t = (v2 ⨯ v1)_z / (v2 • v3)
u = (v1 • v3) / (v2 • v3)
~~~

Then, barring degenerate cases such as the ray and segment overlapping or being parallel, the ray and segment intersect iff the found parameters are valid, i.e. `t >= 0` and `0 <= u <= 1`.

To make it work for the problem I had to make sure the ray wouldn't cross corners (where it would technically intersect two segments and thus give an incorrect count). This was achieved by picking appropriate starting point inside each tile and direction.

Julia:
* I used Julia's `LinearAlgebra` module to import the `dot` product operator, which works directly on native Julia arrays. The cross product is also defined there (and a [host of other functions](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/)), but it only operates on 3D vectors. Instead of augmenting the 2D vectors, I instead wrote a function to directly compute the z-component of the cross product of 2D vectors (it's nice that this is [what numpy does](https://numpy.org/doc/stable/reference/generated/numpy.cross.html) when doing the cross product of 2D vectors).
* I also used Julia's `Set` for quick inclusion checking; they're as handy as the Python ones.

As part of the solution process I made some semi-fancy visualizations of the maze in the terminal. Here's my input, with the loop highlighted, inside tiles in green and the starting tile in cyan (click to view the full-size image):

![](https://github.com/meithan/AoC23/blob/main/day10/maze.png)

---

**Day 9**: [Mirage Maintenance](https://adventofcode.com/2023/day/9)<a name="day9"></a> - [my solution](https://github.com/meithan/AoC23/blob/main/day09)

Day 9 broke the theory that odd days are harder in AoC23: this was perhaps the easiest so far. In fact, I was surprised that Part 2 was really the same thing as Part 1: it didn't require us to search in a bigger space or answer a fundamentally different thing. At one point I was worried that Part 2 would ask to give what the next value in the sequence would be a billion steps further or something like that, which would've required figuring out the pattern. But nope.

Julia:
* `all(x->x==0, cur_seq)` is very useful, specially in this form that takes a predicate as first argument. The single-argument variant just checks whether all values are `true`.

---

**Day 8**: [Haunted Wasteland](https://adventofcode.com/2023/day/8)<a name="day8"></a> - [my solution](https://github.com/meithan/AoC23/blob/main/day08)

Part 1 was simple. Part 2 was the first problem where brute force will not work at all, as the answer would require walking on the order of 10^13 steps.

However, the example in the problem's description provided a hint that the walks are cyclic, just with different periods. If that's the case, then the first time all of them will synchronize is given by the [least common multiple](https://en.wikipedia.org/wiki/Least_common_multiple) of the periods. Before even checking if the walks in the input are actually periodic, I tried the lcm and it just worked! I was also surprised that Julia not only has a built-in lcm function, but it can actually take more than two arguments. Nice.

Julia notes:
* Julia has a built-in `lcm` function! It can even take more than two arguments.
* To unpack an iterable into separate arguments in a function call, equivalent to using `*` in python, we use `...`, for instance: `lcm(array...)`.

---

**Day 7**: [Camel Cards](https://adventofcode.com/2023/day/7)<a name="day7"></a> - [my solution](https://github.com/meithan/AoC23/blob/main/day07)

Not difficult but a bit tedious, as coming up with the rules to correctly evaluate a hand is a bit complicated when jokers are involved.

The evaluation is based on counting the number of repetitions of each card in the hand, and then checking whether enough repetitions occur for each hand type. The `counts` array holds the result: it's a list of numbers that has the repetition counts (of 2 or more of the same card) for each different type of card in the hand. So 'AAAAA' would yield only `[5]`, while 'AAQQ3' would yield `[2,2]` (note the 2 is repeated, because two different cards are each repeated two times).

With jokers (wildcards) the approach is the same, but it took me a while to get the correct set of rules.

Julia notes:
* Passing a custom comparison function for the `sort()` function is very useful, glad Julia has it too; the comparison function, `lt(x,y)`, must return whether `x` is *strictly less* than `y` (so `false` in the case of equality).
* `values(dict)` returns an array with the values of a dict (`keys(dict)` retuns the keys).

---

**Day 6**: [Wait For It](https://adventofcode.com/2023/day/6)<a name="day6"></a> - [my solution](https://github.com/meithan/AoC23/blob/main/day06)

For Part 1 I simply checked all wait times and computed the distance traveled, as described.

For Part 2, since doing that would be too slow, I just used math: the distance `D` traveled by waiting for a time `W` in a race of total time `T` is given by `D = (T-W)*W`, which is a quadratic equation in `W`. Its solution is:

`W = (T +/- sqrt(T^2-4D))/2`

Since we're looking for integer solutions we take the ceiling of the smaller of the two roots and the floor of the larger one. That then gives us the minimum and maximum wait times that result in us beating the record, and hence the answer (the number of integers between those two, inclusive).

Julia notes:
* It's nice that `ceil`, `floor` and `sqrt` are just native functions
* I used `reduce()` to compute the product of an array of numbers (using `init=1`); reminds me of the old Python days where `map`, `filter` and `reduce` were common

---

**Day 5**: [If You Give A Seed A Fertilizer](https://adventofcode.com/2023/day/5)<a name="day5"></a> - [my solution](https://github.com/meithan/AoC23/blob/main/day05)

Since Julia is turning out to be as powerful and expressive as Python, I decided to try this solution in Julia from the get-go. In fact, I think I'll be sticking to Julia only, unless things get too hairy.

Part 1 was easy: it was just a matter of correctly parsing the input and writing the function to map a seed to its final location by following the rules.

From the moment I saw the input I feared that Part 2 was going to ask to search in a huge space -- and that's exactly what happened. After writing a "reverse map function" (to map locations back to the coresponding seed) it was a matter of trying locations and seeing if they mapped to a *valid* seed (checking if a seed is valid is easy: we just check if it's in one of the 10 ranges specified).

So then began the search. Checking the "humidity-to-location map" informed that the kind of values the locations could end up being was possibly in the hundreds of millions -- large, but not intractable. So I began brute-forcing sequential location values starting from zero, stopping the moment a location was found that mapped into a valid seed. Trying the first million locations took about 10 seconds. So I decided to split the search space from 0 to 200 million into 8 parallel instances of the program, each starting from a different value in 25 million increments. Many of the searches starting at higher values actually finished instantly, since their starting values yielded valid seeds. But I had to wait for all of them to finish to find the lowest.

And lo and behold, after about 5 minutes all searches finished, and the lowest location that resulted from a valid seed was around 104 millions. Whew!

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
