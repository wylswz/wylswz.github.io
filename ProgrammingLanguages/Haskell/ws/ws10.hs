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
                    
    





