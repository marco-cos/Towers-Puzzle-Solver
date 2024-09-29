# Towers Puzzle Solver

## Overview
This project implements a solver for the Towers puzzle, a logical grid-based puzzle where the objective is to fill an N×N grid with integers from 1 to N, such that each row and column contains all integers from 1 through N. Additionally, the grid must satisfy visibility constraints given by counts from the edges of the grid. The solver has two implementations: one using Prolog's finite domain solver (`ntower/3`), and one without the finite domain solver (`plain_ntower/3`). The project also explores ambiguous puzzles (puzzles with more than one valid solution). Project for UCLA CS 131 class.

## Features
- **Finite Domain Solver (`ntower/3`)**: Solves the Towers puzzle using Prolog's finite domain solver for faster performance on large grids.
- **Plain Solver (`plain_ntower/3`)**: A simpler solver without finite domain capabilities, using standard Prolog predicates like `member/2` and `is/2`.
- **Performance Comparison (`speedup/1`)**: Compares the performance of `ntower/3` and `plain_ntower/3`, measuring the speedup provided by the finite domain solver.
- **Ambiguous Puzzles (`ambiguous/4`)**: Identifies Towers puzzles with two distinct solutions.

## Functions
### `ntower/3`
Solves the Towers puzzle for an N×N grid using the finite domain solver. The function takes three arguments:
- `N`: Size of the grid (must be a non-negative integer).
- `T`: A list of N lists, each representing a row of the grid, containing distinct integers from 1 to N.
- `C`: A structure representing the visibility counts from the top, bottom, left, and right edges of the grid.

#### Example Usage:
```prolog
?- ntower(5,
          [[2,3,4,5,1],
           [5,4,1,3,2],
           [4,1,5,2,3],
           [1,2,3,4,5],
           [3,5,2,1,4]],
          C).
C = counts([2,3,2,1,4],
           [3,1,3,3,2],
           [4,1,2,5,2],
           [2,4,2,1,2]).
```

### `plain_ntower/3`
Solves the Towers puzzle without the finite domain solver, using standard Prolog predicates. This is a simpler, yet potentially slower, implementation.

#### Example Usage:
```prolog
?- plain_ntower(2, T, counts([2,1],[1,2],[2,1],[1,2])).
T = [[1,2],[2,1]] ;
T = [[2,1],[1,2]].
```

### `speedup/1`
Compares the CPU time taken by `ntower/3` and `plain_ntower/3` to solve the same puzzle, returning the ratio of the time taken by the plain solver to the finite domain solver. Ideally, this ratio should be greater than 1, indicating a speedup from using the finite domain solver.

#### Example Usage:
```prolog
?- speedup(Ratio).
Ratio = 3.5.  % (example output, actual value may vary)
```

### `ambiguous/4`
Finds an ambiguous Towers puzzle, i.e., a puzzle with two distinct solutions. It uses `ntower/3` to generate the solutions.

#### Example Usage:
```prolog
?- ambiguous(3, counts([3,2,1],[1,2,2],[3,2,1],[1,2,2]), T1, T2).
T1 = [[1,2,3],[2,3,1],[3,1,2]],
T2 = [[3,1,2],[2,3,1],[1,2,3]].
```

## Performance Testing
To test the performance of the two solvers, use the `speedup/1` predicate. It runs both `ntower/3` and `plain_ntower/3` on a predefined puzzle and measures the time taken by each.

```prolog
?- speedup(Ratio).
```

## Installation
1. Ensure you have GNU Prolog installed.
2. Copy the provided Prolog code into a file named `tower.pl`.

## Running the Code
You can run the predicates in GNU Prolog by loading the `tower.pl` file and invoking the predicates. For example, to solve a 5×5 Towers puzzle using the finite domain solver:

```prolog
?- consult('tower.pl').
?- ntower(5, T, counts([2,3,2,1,4],[3,1,3,3,2],[4,1,2,5,2],[2,4,2,1,2])).
```

## Notes
- **Finite Domain Solver**: The `ntower/3` predicate uses Prolog's finite domain solver for performance improvements, especially on larger grids.
- **Plain Solver**: The `plain_ntower/3` predicate uses standard Prolog primitives and may be slower but is not restricted by finite domain constraints.
- **Ambiguous Puzzle Detection**: The `ambiguous/4` predicate helps detect puzzles that have more than one valid solution, providing insights into the ambiguity of Towers puzzles.