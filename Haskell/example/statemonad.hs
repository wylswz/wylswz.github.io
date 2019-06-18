import Control.Monad.State
{-
    depends on:
    - libghc-mtl-dev
-}
-- Increase Nth element in list by N
incList :: [Int] -> [Int]
incList l = fst (runState (incList' l) 1)

incList' :: [Int] -> State Int [Int]
incList' [] = return []
incList' (x:xs) = do
    newTail <- incList' xs
    n <- get
    let res = (x+n):newTail
    put (n + 1)
    return res

{-

-}

type Stack = [Int]

pop :: State Stack Int
pop = State $ \(x:xs) -> (x, xs)