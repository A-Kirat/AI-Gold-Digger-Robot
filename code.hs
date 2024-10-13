type Cell = (Int,Int) 
data MyState = Null | S Cell [Cell] String MyState deriving (Show,Eq)

up :: MyState -> MyState
up (S (r,c) x str s) = if r == 0 then Null  else (S (r-1,c) x "up" (S (r,c) x str s) ) 

down :: MyState -> MyState
down (S (r,c) x str s) = if r == 3 then Null  else (S (r+1,c) x "down" (S (r,c) x str s) ) 

left :: MyState -> MyState
left (S (r,c) x str s) = if c == 0 then Null  else (S (r,c-1) x "left" (S (r,c) x str s) ) 

right :: MyState -> MyState
right (S (r,c) x str s) = if c == 3 then Null  else (S (r,c+1) x "right" (S (r,c) x str s) ) 

dig :: MyState -> MyState 
dig (S (r,c) l str s) = if elem (r,c) l == False then Null else (S (r,c) (filter (/=(r,c)) l) "dig" (S (r,c) l str s))

isGoal :: MyState -> Bool
isGoal (S (r,c) x str s) = x == []

nextMyStates :: MyState -> [MyState]
nextMyStates x = filter (/= Null) ([up x, down x, right x, left x, dig x]) 

search :: [MyState] -> MyState
search (x:xs) = if isGoal x then x else search (xs ++ (nextMyStates x)) 

constructSolution :: MyState -> [String]
constructSolution  (S (r,c) x "" Null)= []
constructSolution (S (r,c) x str s) =  (constructSolution (s) ++ [str])

solve :: Cell -> [Cell] -> [String]
solve a k = constructSolution(search [S a k "" Null])