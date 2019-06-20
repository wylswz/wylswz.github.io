import Control.Monad.State
{-
    depends on:
    - libghc-mtl-dev
    - libghc-random-dev
-}
-- Increase Nth element in list by N
incList :: [Int] -> [Int]
incList l = fst (runState (incList' l) 2)

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


