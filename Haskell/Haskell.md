# Brief Intro to Haskell

## Functors
Functor class in Haskell simply means something that can be mapped over with a function. Any instance of Functor must implement the `fmap` function
```haskell
fmap :: Functor f => (a -> b) -> f a -> f b
``` 
where f is a wrapper for some value of any type, `(a -> b)` is simple a function that takes value of type `a` as a parameter and return value of type `b`. The `fmap` function applies the function to the value which is wrapped by `f` and produces a new value wrapped in the exact same form.

Differnt instances of functor have their implementations for `fmap`, for example, `fmap` of List is simply `map`, therefore the following statements are identical
```haskell
fmap (1+) [1,2,3]
map (1+) [1,2,3]
```

### Type constructor being an instance of Functor
Type constructors can be functors. For instance, the `Maybe` type can be defined as 
```haskell
instance Functor Maybe where
    fmap _ Nothing = Nothing
    fmap f $ Just a = Just $ f a
```
Note that in the type definition of fmap, the wrapper `f` only takes one parameter as type parameter, therefore, the type constructor in implementations should take exact one parameter as well. Consider the `Either` type 
```haskell
instance Functor Either where
    fmap:: (a -> b) -> Either a -> Either b
```
This is incorrect, because the type constructor `Either` takes two parameters. In order to make it valid, simple partially apply the first parameter with a
```haskell
instance Functor Either a where
    fmap :: (b -> c) -> Either a b -> Either a c 
```

### Function as an instance of Functor
Function is first class citizen in Haskell so it makes sense for it to be an instance of some Class. The function as a functor has the form `(->) r`. This can be simply treat as application of a function that takes exact one parameter (or wrap the parameter with this function). According the previous definition, the function Functor can be defined as 
```haskell
instance Functor ((->) r) where
    fmap f g = (\x -> f (g x))
```
In another word, `fmap f g` returns a function which takes a value x, apply `g` to it and apply `f` to the result. In order to explain why does this happen, we need to look at the original definition of `fmap` function 
```haskell
fmap :: Functor f => (a -> b) -> f a -> f b
```
Replace `f` with `(->) r` in this case, we have

```haskell
fmap :: (a -> b) -> ((->) r a) -> ((->) r b)
```
which is 
```haskell
fmap :: (a -> b) -> (r -> a) -> (r -> b)
```
It is obvious that the `fmap` function takes an function that takes `a` as parameter and return b, and a function takes `r` returns `a` and outputs a function takes `r` and returns `b`. So the second function is applied to `r` to get the result `a` then `a -> b` can be applied to `a` to get `b`.

Intuitively, this is function composition that we really love about in Haskell. So for function 
```haskell
fmap = (.)

-- The following equations are all equivalent
fmap a b
a . b
(.) a b
\x -> a $ b x
```