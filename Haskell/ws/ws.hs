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

ws4_insert_all :: Ord a => WS4_Tree a -> [a] -> WS4_Tree a
ws4_insert_all t [] = t
ws4_insert_all t (x:xs) = 
    ws4_insert_all t1 xs where 
        t1 = ws4_insert t x
ws4_traverse :: WS4_Tree a -> [a]
ws4_traverse WS4_Leaf = []
ws4_traverse (WS4_Node v left right) = 
    ws4_traverse left ++ [v] ++ ws4_traverse right


ws4_treeSort :: Ord a => [a] -> [a]
ws4_treeSort [] = []
ws4_treeSort l = 
    ws4_traverse tree where
        tree = ws4_insert_all WS4_Leaf l

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

ws4_listsum :: Num a => [a] -> (Integer, a, a)
ws4_listsum [] = (0,0,0)
ws4_listsum (x:xs) = ws4_support_accum (1, x, x^2) $ ws4_listsum xs


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
ws5_allSqrts [] = []
ws5_allSqrts l = foldl (++) [] mapped where
    mapped = (map ws5_support_sqrtPM l)

-- Q5 
-- Filter out negative number and sqrt on remain integers
-- a. Use filter and map
-- b. Don't use high order functions

ws5_sqrt_filter :: (Floating a, Ord a) => [a] -> [a]
ws5_sqrt_filter l = 
    map sqrt pl where 
        pl = filter (>0) l

-- I'll skip the easy part
