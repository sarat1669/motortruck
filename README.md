# MotorTruck

### Usage
Start iex with `iex -S mix`
```
InitStore took 934 ms
Interactive Elixir (1.8.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> MotorTruck.run("6686787825")
Executed in 1 ms
[
  ["noun", "struck"],
  ["onto", "struck"],
  ["motor", "truck"],
  ["motor", "usual"],
  ["nouns", "truck"],
  ["nouns", "usual"],
  "motortruck"
]
```

Parsing takes 900 - 950 ms (Mac Pro 2015)
Execution under 1ms

### Approach:
1) All the words are read from a file and are converted into numbers using the given configuration
2) The converted words are stored in the ETS along with the conflicting members
3) Since a number can be of length 10, and with the condition that the words should be of minimum 3
characters, the search scope is reduced to the following patterns

```
10
7, 3
6, 4
5, 5
4, 3, 3
```

4) Now that we have this range, we can narrow our searches to the range between 3 to 7 and 10
5) 3..7 check for each length if there is a matching word. If its available, store it in an array
and continue checking if there are characters left. If the remaining characters are below 3, that
means it cannot become a word, so it can be discarded. If the word didn't match, the branch will be
discarded.
6) Once you have the array of possible items at each iteration.

`Ex: ["noun", "onto"] ["struck"]`

Get the combinations of the possibilities
7) Concatenate the array and the output is available
