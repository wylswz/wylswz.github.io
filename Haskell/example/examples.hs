import Data.Monoid
import Data.Foldable as F

-- Define a Tree
data Tree a = Empty
            | Node a (Tree a) (Tree a)
            deriving(Show, Read, Eq)

-- Create an instance for that Tree
a  = Node 3 (Node 4 (Node 5 Empty Empty) Empty) (Node 6 (Empty) (Node 8 (Empty)(Empty)))

{-
    Here we define three wrappers of Tree which indicate three
    traversal behaviors, Pre-order, Post-order and In-order
    They have exact same underlying data structure, but slightly 
    different in folding
-}
newtype PreOrderTree a = PreOrderTree {getPreOrderTree :: Tree a} deriving(Show, Read, Eq)
newtype PostOrderTree a = PostOrderTree {getPostOrderTree :: Tree a} deriving(Show, Read, Eq)
newtype InOrderTree a = InOrderTree {getInOrderTree :: Tree a} deriving(Show, Read, Eq)

preA = PreOrderTree a
postA = PostOrderTree a
inA = InOrderTree a
{-
    Simply define different Folding behaviors for three
    wrappers. (Different order in recursive traversal)
-}
instance F.Foldable PreOrderTree where 
    foldMap f (PreOrderTree Empty) = mempty
    foldMap f (PreOrderTree (Node x l r)) = 
        f x `mappend`
        F.foldMap f (PreOrderTree l) `mappend`
        F.foldMap f (PreOrderTree r)

instance F.Foldable PostOrderTree where 
    foldMap f (PostOrderTree Empty) = mempty
    foldMap f (PostOrderTree (Node x l r)) = 
        F.foldMap f (PostOrderTree l) `mappend`
        F.foldMap f (PostOrderTree r) `mappend`
        f x 
        
instance F.Foldable InOrderTree where
    foldMap f (InOrderTree Empty) = mempty
    foldMap f (InOrderTree (Node x l r)) = 
        F.foldMap f (InOrderTree r) `mappend`
        f x `mappend`
        F.foldMap f (InOrderTree l) 


{-
    Create an aggregation function that takes a string and 
    anything which is an instance of Show type class, and 
    we keep push the string version of it to the base string
    and return the result
-}
serializeApp :: Show a => String -> a  -> String
serializeApp cache val = 
    cache ++ (show val)

-- Do some tests
test = foldl serializeApp "" preA
test = foldl serializeApp "" postA
test = foldl serializeApp "" inA


