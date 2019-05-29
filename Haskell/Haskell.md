# Brief Intro to Haskell
Note: Some codes in this article may not be legal haskell codes, they are only used to explain some facts.

Haskell is a declarative (functional) programming language. You know what is functional programming, so I'll skip that part. This introduction will start with Functor.

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

### Why functor? 
When we use a programming language to interact with pieces of data to produce something that is useful, it's hard to make sure everything is in the same data structure. Data is organized in different ways in differnt scenarios in order to achieve higher runtime or development efficiency. In order to manipulate all these different types of data, we want the programming language to gerneralize well, that is, we can perform similar actions to different types with a unified interface (Like Abstract Class and  Interface in Java). 

Think about the following scenario, we have a datatype constructed from a `Tuple`

```haskell
data Student = Student {
    id :: Int,
    mark :: Int
}

buildFromTuple :: (Int, Int) -> Student
buildFromTuple (id, mark) = Student id mark
```

Then we want to create a list of `Student` type values from a list of tuples, we have

```haskell
map buildFromTuple [(1,20),(2,57)]
```
which is intuitive. But what if the tuples are stored in other data structures like `Vector`? With the help of functor, we can simply unify the interface with fmap.


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
In another word, `fmap f g` returns a function which takes a value x, apply `g` to it and apply `f` to the result. In order to explain why does this happen, we need to go back to the original definition of `fmap` function 
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

### Functor Laws
In the above sessions, we discussed about the "Instance of Functor" instead of functor directly. The reason is that in order for an instance of Functor to be a functor, it need to obey functor rules which ensures calling a functor only maps a function over it without doing anything more. Here are the two rules

- If we map id function over a functor, the functor we get back should be the exact same one.
- Composing two functions and then map it over a functor is same as mapping one over it and then mapping another

`Maybe` is a functor, let's see how it obeys the functor laws.
```haskell
-- Law 1
fmap id Nothing = Nothing -- trivial
fmap id (Just x) = Just (id x) = Just x

-- Law 2
fmap (f . g) Nothing = Nothing
fmap (f . g) (Just x) 
    = Just (f $ g x)
    = fmap f Just (g x)
    = fmap f (fmap g (Just x))
    = (fmap f) (fmap g (Just x))
``` 
There also examples that a type construct is an instance of a functor but isn't an actual functor. Consider a data type with a counter which increases by one everytime fmap is applied to it.

```haskell
data CtrMaybe a = CtrNothing
                | CtrJust Int a
                deriving (Show)

instance Functor CtrMaybe where 
    fmap _ CtrNothing = CtrNothing
    fmap f $ CtrJust ctr x = CtrJust $ ctr + 1 $ f x
```

In this case, everytime the `id` function is mapped over the structure, the counter has increased by 1, which is not identical to previous one anymore (side effect). Therefore, this is not a functor.

## Applicative Functors
In the cases we discussed above, we map a function that takes one paramter and produces one result over an instance of `Functor` to yield the exact same wrapper but with the value changed.

What if we have a function that accepts more than one parameter, for example `(+)` which takes two `Num` type values and add them together.

```haskell
fmap (+) (Just 3) = Just ( (+) 3 )
```
We have a partially applied function wrapped in `Just`~ Let's think about how we gonna use it. What everyone can simple see is that it is a functor, so one intuitive way of using it is to map a function over it. What can we do to a function with another function, well, simply apply the function in another function that takes a function as parameter.

```haskell
fmap (\f -> f 3) a
-- For value wrapped in a, apply it to value 3
```

This sounds like trivial, but it does have some fancy usages in Haskell with the `Applicative` class.

Suppose that we have two numbers wrapped by a functor, `Just 3` and `Just 5`, how do we add them together? As we previously discussed, we can use fmap with (+) to produce a functor wrapped function, then map over it with another value.

```haskell
a = fmap (+) (Just 3)
fmap (\f -> f 5) a
```
Well, that looks really bad. You are using two lines of codes and an anonymous function in order for a task as simple as adding two numbers! That's where `Applicative Functor` comes in.