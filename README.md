
# AI-Gold-Digger-Robot
Haskell
This project implements a state search solution using Haskell for navigating a grid and performing a series of operations such as moving up, down, left, right, and digging at specific locations.

## Data Structures

### Cell
```haskell
type Cell = (Int, Int)
```
- **Description**: A `Cell` represents a coordinate in the grid, defined by a tuple of integers `(row, column)`.

### MyState
```haskell
data MyState = Null | S Cell [Cell] String MyState deriving (Show, Eq)
```
- **Description**: The `MyState` data type represents the current state of the agent. It stores the current position, a list of remaining "dig" cells, the last action as a string, and the previous state.

## Movement Functions

### up
```haskell
up :: MyState -> MyState
up (S (r, c) x str s) = if r == 0 then Null else (S (r-1, c) x "up" (S (r, c) x str s))
```
- **Description**: Moves the agent up in the grid. If the agent is at the top (row 0), returns `Null`.

### down
```haskell
down :: MyState -> MyState
down (S (r, c) x str s) = if r == 3 then Null else (S (r+1, c) x "down" (S (r, c) x str s))
```
- **Description**: Moves the agent down in the grid. If the agent is at the bottom (row 3), returns `Null`.

### left
```haskell
left :: MyState -> MyState
left (S (r, c) x str s) = if c == 0 then Null else (S (r, c-1) x "left" (S (r, c) x str s))
```
- **Description**: Moves the agent left in the grid. If the agent is at the leftmost column (column 0), returns `Null`.

### right
```haskell
right :: MyState -> MyState
right (S (r, c) x str s) = if c == 3 then Null else (S (r, c+1) x "right" (S (r, c) x str s))
```
- **Description**: Moves the agent right in the grid. If the agent is at the rightmost column (column 3), returns `Null`.

### dig
```haskell
dig :: MyState -> MyState
dig (S (r, c) l str s) = if elem (r, c) l == False then Null else (S (r, c) (filter (/=(r, c)) l) "dig" (S (r, c) l str s))
```
- **Description**: Digs at the current position `(r, c)` if it is in the list of diggable cells. The cell is removed from the list of diggable cells after being dug.

## Goal Checking

### isGoal
```haskell
isGoal :: MyState -> Bool
isGoal (S (r, c) x str s) = x == []
```
- **Description**: Checks if all diggable cells have been dug (i.e., the list of diggable cells is empty).

## State Transitions

### nextMyStates
```haskell
nextMyStates :: MyState -> [MyState]
nextMyStates x = filter (/= Null) ([up x, down x, right x, left x, dig x])
```
- **Description**: Generates the next possible states by moving in all four directions or digging, filtering out invalid states (`Null`).

## Search Algorithm

### search
```haskell
search :: [MyState] -> MyState
search (x:xs) = if isGoal x then x else search (xs ++ (nextMyStates x))
```
- **Description**: Uses breadth-first search to find the goal state. It explores the list of states, checking if the current state is the goal, and if not, it adds the next possible states to the search list.

## Solution Construction

### constructSolution
```haskell
constructSolution :: MyState -> [String]
constructSolution (S (r, c) x "" Null) = []
constructSolution (S (r, c) x str s) = (constructSolution s ++ [str])
```
- **Description**: Recursively constructs the solution by building the sequence of actions (up, down, left, right, dig) taken to reach the goal state.

## Main Function

### solve
```haskell
solve :: Cell -> [Cell] -> [String]
solve a k = constructSolution(search [S a k "" Null])
```
- **Description**: The main function to solve the problem. It takes a starting position (`Cell`) and a list of diggable cells (`[Cell]`), then returns a list of actions required to dig all cells.

## Example Usage

```haskell
-- Define the starting position and list of diggable cells
let start = (0, 0)
let diggableCells = [(1, 2), (2, 3), (3, 1)]

-- Solve the problem
let solution = solve start diggableCells

-- Output the sequence of actions
print solution
```

## Explanation

1. The program starts at a given position on a 4x4 grid.
2. It moves up, down, left, right, and digs at specified positions.
3. The goal is to dig all the given positions by finding the shortest sequence of moves.
4. The `solve` function uses breadth-first search (`search`) to explore all possible paths, and `constructSolution` builds the sequence of actions that lead to the goal.

## Assumptions

- The grid is 4x4 (from row 0 to row 3 and column 0 to column 3).
- The initial state includes the current position, a list of diggable cells, and the action history.
- The solution is found when all the diggable cells have been dug.

## Notes

- If the agent reaches the edge of the grid, further movement in that direction results in a `Null` state.
- The `search` function implements a breadth-first search to ensure all paths are explored to find the optimal solution.
- The `constructSolution` function constructs the path from the initial state to the goal by tracing the series of actions.

## Future Improvements

- The grid size can be parameterized to allow for grids of different dimensions.
- Additional constraints such as obstacles could be added to make the search more complex.

## License

This project is open-source and available for modification and distribution.
