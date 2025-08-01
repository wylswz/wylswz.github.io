## Haskell Workshop (1 to 5)


```haskell
{-
    Revision of Haskell workshops
    Author: Yunluw@student.unimelb.edu.au
    name rules:
        wsx_prefix_variableName
        WSX_ClassName
-}

-- Workshop 1

ws1_support_conTwoElem :: [a] -> a -> [a] 
ws1_support_conTwoElem  b a = a:b

ws1_myReverse :: [a] -> [a]
ws1_myReverse [] = []
ws1_myReverse l = 
    foldl ws1_support_conTwoElem [] l

ws1_getNthElem :: Int -> [a] -> a
ws1_getNthElem 0 (x:xs) = x
ws1_getNthElem n (x:xs) = 
    ws1_getNthElem (n-1) xs

-- Workshop 2

-- Q1 Define pocker 
data WS2_Suite = Clubs | Diamonds | Hearts | Spades
data WS2_Pocker = WS2_Pocker Int WS2_Suite

-- Q2 Define a HTML font tag
-- Typeface, font size and color
type WS2_Typeface = String
type WS2_FontSize = Int
type WS2_R = Int
type WS2_G = Int
type WS2_B = Int
data WS2_Color = WS2_Color_RGB WS2_R WS2_G WS2_B |
    WS2_Color_Name String |
    WS2_Color_Hex Int

data Font = Font (Maybe WS2_Typeface) (Maybe WS2_FontSize) (Maybe WS2_Color)

-- Q3
ws2_factorial :: Int -> Int
ws2_factorial 0 = 1
ws2_factorial n = 
    n * (ws2_factorial $ n - 1)

-- Q4 myElem True of elem in list else false
ws2_myElem :: Eq a => a -> [a] -> Bool
ws2_myElem _ [] = False
ws2_myElem a (x:xs)
    | a == x = True
    | otherwise = (ws2_myElem a xs)

-- Q5 longest common prefix of two lists

ws2_longestPrefix :: Eq a => [a] -> [a] -> [a]
ws2_longestPrefix _ [] = []
ws2_longestPrefix [] _ = []
ws2_longestPrefix (a:as) (b:bs) 
    | a == b = (a: ws2_longestPrefix as bs)
    | otherwise = []

-- Q7 build a list from min to max
ws2_range :: Int -> Int -> [Int]
ws2_range min max 
    | min > max = []
    | otherwise = min : ws2_range (min+1) max

-- Workshop 3 Fahrenheit to Celsius

-- Q2
-- C = (5/9) * (F - 32)
-- When commented out type declaration
-- Fractional a => a -> a
ws3_ftoc :: Double -> Double
ws3_ftoc f = (5/9) * (f-32)

--Q4 Merge sorted
ws3_mergeSorted :: Ord a => [a] -> [a] -> [a]
ws3_mergeSorted [] a = a
ws3_mergeSorted a [] = a
ws3_mergeSorted (a:as) (b:bs)
    | a > b = b:ws3_mergeSorted (a:as) bs
    | a <= b = a:ws3_mergeSorted as (b:bs)

-- Q5 Quick sort on list (inefficient)
ws3_qsort :: Ord a => [a] -> [a]
ws3_qsort [] = []
ws3_qsort (pivot:xs) = 
    ws3_qsort less ++ [pivot] ++ ws3_qsort greater
        where less = filter (< pivot) xs
              greater = filter (>= pivot) xs

-- Q6 If two trees have same shape
data WS3_Tree k v = WS3_Leaf |
    WS3_Node k v (WS3_Tree k v) (WS3_Tree k v)
ws3_sameShape :: WS3_Tree a b -> WS3_Tree c d -> Bool
ws3_sameShape WS3_Leaf WS3_Leaf = True
ws3_sameShape WS3_Leaf (WS3_Node _ _ _ _) = False
ws3_sameShape (WS3_Node _ _ _ _) WS3_Leaf = False
ws3_sameShape (WS3_Node _ _ ta tb) (WS3_Node _ _ tc td)
    = ws3_sameShape ta tc && ws3_sameShape tb td

-- Q7 Evaluation expression

data WS3_Variable = WS3_A | WS3_B
data WS3_Expression 
         = WS3_Var WS3_Variable
         | WS3_Num Integer
         | WS3_Plus WS3_Expression WS3_Expression
         | WS3_Minus  WS3_Expression WS3_Expression
         | WS3_Times  WS3_Expression WS3_Expression
         | WS3_Div  WS3_Expression WS3_Expression

ws3_eval :: Integer -> Integer -> WS3_Expression -> Integer
ws3_eval a _ (WS3_Var WS3_A) = a
ws3_eval _ b (WS3_Var WS3_B) = b
ws3_eval _ _ (WS3_Num n) = n
ws3_eval a b (WS3_Plus e1 e2) = 
    ws3_eval a b  e1 + ws3_eval a b e2
ws3_eval a b (WS3_Minus e1 e2) = 
    ws3_eval a b  e1 - ws3_eval a b e2
ws3_eval a b (WS3_Times e1 e2) = 
    ws3_eval a b  e1 * ws3_eval a b e2
ws3_eval a b (WS3_Div e1 e2) = 
    ws3_eval a b  e1 `quot` ws3_eval a b e2

-- Workshop 4

-- Q1 Haskell version of tree sort algorithm
-- Insert data into a Tree
-- In order traverse
data WS4_Tree a = WS4_Leaf |
    WS4_Node a (WS4_Tree a) (WS4_Tree a)

ws4_insert :: Ord a => WS4_Tree a -> a -> WS4_Tree a
ws4_insert WS4_Leaf a = WS4_Node a (WS4_Leaf) (WS4_Leaf)
ws4_insert (WS4_Node v left right) a 
    | a < v = WS4_Node v (ws4_insert left a) right
    | a >= v = WS4_Node v left (ws4_insert right a)

{- Legacy version..
ws4_insert_all :: Ord a => WS4_Tree a -> [a] -> WS4_Tree a
ws4_insert_all t [] = t
ws4_insert_all t (x:xs) = 
    ws4_insert_all t1 xs where 
        t1 = ws4_insert t x
-}

-- New version using foldl. 
ws4_insert_all :: Ord a => [a] -> WS4_Tree a
ws4_insert_all = foldl ws4_insert WS4_Leaf
ws4_traverse :: WS4_Tree a -> [a]
ws4_traverse WS4_Leaf = []
ws4_traverse (WS4_Node v left right) = 
    ws4_traverse left ++ [v] ++ ws4_traverse right

{- Legacy version
ws4_treeSort :: Ord a => [a] -> [a]
ws4_treeSort [] = []
ws4_treeSort l = 
    ws4_traverse tree where
        tree = ws4_insert_all l
-}

-- New version using function composition
ws4_treeSort :: Ord a => [a] -> [a]
ws4_treeSort = ws4_traverse . ws4_insert_all


-- Q2 Transpose a matrix

ws4_transpose :: [[a]] -> [[a]]
ws4_transpose m
    | length (head m) == 0 = []
    | otherwise = [head x | x <- m] : (ws4_transpose [tail x| x <- m])

-- Q3 take a list of number, return (len, sum, sum_of_square)
-- Do with three traversal and single traversal

ws4_support_accum :: Num a => (Integer, a, a) -> (Integer, a, a) -> (Integer, a, a)
ws4_support_accum (cnt, sum, ssum) (cnt', sum', ssum') = 
    (cnt + cnt', sum + sum', ssum + ssum')

{- Legacy Method
ws4_listsum :: Num a => [a] -> (Integer, a, a)
ws4_listsum [] = (0,0,0)
ws4_listsum (x:xs) = ws4_support_accum (1, x, x^2) $ ws4_listsum xs
-}

-- More declarative approach using foldl
ws4_accAll :: Num a => a -> (Int, a, a) -> (Int, a, a)
ws4_accAll a (len, sum, sums) = (len + 1, sum + a, sums + a^2)
ws4_listsum :: Num a => [a] -> (Int, a, a)
ws4_listsum = foldr ws4_accAll (0,0,0)

-- Workshop 5

-- Q1 
ws5_maybeApply :: (a -> b) -> Maybe a -> Maybe b
ws5_maybeApply _ Nothing = Nothing
ws5_maybeApply f (Just a) = Just (f a)

-- Q2 
-- Apply first argument to corresponding elements of two 
-- input lists. If different length, extra elems are ignored
ws5_zWith :: (a -> b -> c) -> [a] -> [b] -> [c]
ws5_zWith _ [] _ = []
ws5_zWith _ _ [] = []
ws5_zWith f (x:xs) (y:ys) = 
    (f x y) : (ws5_zWith f xs ys)

-- Q3
-- Multiply elem in list by first arg and add to second arg
ws5_support_convert :: Num a => a -> a -> a -> a
ws5_support_convert a b c = c * a + b

ws5_linearEqn :: Num a => a -> a -> [a] -> [a]
ws5_linearEqn _ _ [] = []
ws5_linearEqn a b l= map (ws5_support_convert a b) l

-- Q4
-- sqrtPM return postive and negative sqrt of 
-- a floating number
-- Apply to all elems in a list and concat them together
ws5_support_sqrtPM :: (Floating a, Ord a) => a -> [a]
ws5_support_sqrtPM x 
    | x > 0 = let y = (sqrt x) in [y, -y]
    | x == 0 = [0]
    | otherwise = []

ws5_allSqrts :: (Floating a, Ord a) => [a] -> [a]
ws5_allSqrts = (foldl (++) []) . (map ws5_support_sqrtPM)

-- Q5 
-- Filter out negative number and sqrt on remain integers
-- a. Use filter and map
-- b. Don't use high order functions

ws5_sqrt_filter :: (Floating a, Ord a) => [a] -> [a]
ws5_sqrt_filter= (map sqrt) . (filter (>0))

-- I'll skip the easy part

```

## Haskell Workshop 10

```haskell
import Data.Char

-- Q1
maybe_tail :: [a] -> Maybe [a]
maybe_tail [] = Nothing
maybe_tail (x:xs) = Just xs

-- Drop first N elems of a list
-- Method 1: Check Nothing explicitly
-- Method 2: use >>=
maybe_drop :: Int -> [a] -> Maybe [a]
maybe_drop 0 l = Just l
maybe_drop n (x:xs)
    | n<0 = Nothing
    | otherwise = maybe_drop (n-1) xs

-- This is method 2
-- (>>=) :: Monad m => m a -> (a -> m b) -> m b
maybe_drop' :: Int -> [a] -> Maybe [a]
maybe_drop' 0 l = Just l
maybe_drop' n l = 
    Just (l) >>= maybe_tail >>= maybe_drop' (n-1)


-- Q2
{-
    Print the content of each node of the tree
    What's the advantage and disadvantege of this method??
-}

data Tree a = Empty |
                Node (Tree a) a (Tree a)

print_tree :: Show a => Tree a -> IO ()
print_tree Empty = do
    putStrLn "Empty"

print_tree (Node left content right)
    = do
        print_tree left
        print content
        print_tree right

-- Q3

convert_digit :: Char -> Maybe Int
convert_digit c
        | isDigit c = Just (digitToInt c)
        | otherwise = Nothing

str_to_num_r :: Int -> String -> Maybe Int
str_to_num_r _ "" = Just 0
str_to_num_r power (n:ns) =
    case convert_digit n of 
        Nothing -> Nothing
        Just s  -> Just ((s * 10 ^ power) + rest) where
            Just rest = str_to_num_r  (power + 1) ns
    
str_to_num :: String -> Maybe Int
str_to_num = str_to_num_r 0 . reverse


-- Q4

{-
    reads in a list of lines containing numbers, return their sum
    Version 1: Sum up as read
    Version 2: Collect all numbers, then sum up
-}


-- Version 2
read_sum' :: Int -> IO Int
read_sum' n = do 
    line <- getLine
    let res = str_to_num line
    case res of 
        Nothing -> return n
        Just num -> read_sum' (n + num)

read_sum = read_sum' 0

-- Version 1
-- I pretty much similar thing, put we just push them to list and sum up later

-- Q5
{-
        Repeatedly read in and execute command. Some commands:
        - print: print the phone book
        - add name num: add num as the phone number for name
        - delete name: delete entry for name
        - loopup name: print entry match
        - quit exit the program
-}
    

cmd :: [(String, String)] -> IO ()
cmd book = do 
    command <- getLine
    let (c:cs) = words command
    case c of 
        "print" -> do 
                print book
                cmd book
        "add" -> let name:num:_ = cs in
                    cmd ((name, num):book)
        "delete" -> let name:_ = cs in
                    cmd (filter (\(x,y) -> x /=name) book) 
        "lookup" -> do 
                let name:_ = cs in
                    let lookup_res =  filter (\(x,y) -> x == name) book in
                        print lookup_res
                cmd book
        "quit" -> return ()
                    
```