a =  do 
    b <- [1,2,3]
    [b]

b = do 
    c <- Just 3
    Nothing
    c <- Just 4
    return c