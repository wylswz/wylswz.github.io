# Brief Intro to Haskell
Note: Some codes in this article may not be legal haskell codes, they are only used to explain some facts.

This article is not originally written by me, I just read some Haskell articles online and put them together:

[Real World Haskell](http://book.realworldhaskell.org/)

[Learn You a Haskell for Great Good!](http://learnyouahaskell.com/chapters)

[Monday Morning Haskell](https://mmhaskell.com/)


Haskell is a declarative (functional) programming language. You know what is functional programming, so I'll skip that part. This introduction will start with some basic stuff like data type.

## `type`, `data` and `newtype` 
At the beginning of this article, let's make sure we don't mess up some of the terminologies in Haskell in terms of data types. When we manipulate data types, there are three keywords that we might use, `type`, `data` and `newtype`.

The `type` keyword is nothing more than defining type synonyms for existing types, that is, you take a type, add a new name referring to it, then you can use the new name and original name interchangably.

```haskell
type IntList = [Int]
let a = [1,2,3] :: IntList
let b = [1,2,3] :: [Int]
a == b

> True
```

The `data` keyword is used to create you own data types, which is quite straightforward:
```haskell
type ID = Int
type Name = String
type DEAD = ()
data Person = Person ID Name
            | Dead
``` 

The `newtype` keyword is to wrap an existing type in a new defined type. The difference between `type` and `newtype` is that the `type` produces a synonym fro existing type, which means the new type is identical to original one, while `newtype` produces a new type. In fact, `newtype` is like a special kind of `data` which has only one constructor with only one field, but not exactly (There are differences in efficiency and lazyness).

### `newtype` efficiency and lazyness

`newtype` is more efficient than `data` in terms of wrapping types. With `data` keyword, you create a new data type, which brings overhead for wrapping and unwrapping operations. While with `newtype`, the Haskell knows the underlying type that you have wrapped, therefore the wrapped data can directly be referred to without extra overhead.

The `newtype` also has extra lazyness in it. Because Haskell has known the wrapped type and there is only one constructor with one fixed field, sometimes the construction is not necessarily evaluated in some cases (like pattern matching with wildcards). While using `data`, construction is evaluated everytime because there might be different constructors with unfixed fields, Haskell need to figure out which one to go with.

Now that we have understood some confusing terminologies, let's dive into one of most things in Haskell, which is Functor.

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

In `Applicative Functor`, two new terms are introduced, which are `pure` and `<*>`. These two terms are not defined by default, the developer who defines the data type should implement them. The `Applicative` class can be defined as 

```haskell
class (Functor f) => Applicative f where
    pure :: a -> f a
    (<*>) :: f (a -> b) -> f a -> f b
```
It's quite obvious from the class definition is that in order to be an instanve of `Applicative`, a variable need to be `Functor` first. The `pure` function takes a value of any type as parameter and return an applicative functor with the value in it. (Put the value in some sort of default context -- a minimal context that still yields the value). The `(<*>)` extracts the function from the first functor and map over the second one.

For instance, the `Maybe` is a kind of `Applicative Functor`, which is defined as 
```haskell
instance Applicative Maybe where
    pure = Just
    Nothing <*> _ = Nothing
    Just f <*> something = f <$> something
```

With normal functor, you can only map a function over a functor without being able to get the result out of it or manipulate it. While `Applicative Functor` allows you to operate on several functors with a single function. Look at the following example:

```haskell
pure (+) <*> Just 3 <*> Just 5
Just (3 +) <*> Just 5
```
The first line can be aggregated to the second one by paritally apply the plus to `Just 3`. Thanks to the unwrapping capability of `<*>` function, the wrapped function is easily unwrapped and applied. The good thing is that the second line has almost identical structure with the first one: Partially applying a wrapped function still yields a wrapped function, that why we can easily cascade multiple `<*>` functions. 

If we generalize the usage of `Applicative Functor`, that becomes the following form

```haskell
pure f <*> x <*> y <*> ...
```
Again, the strength of `Applicative Functor` over normal `Functor` is that it support function with any number of inputs and is able to cascade values in a fairly elegant manner.

The `<*>` has the pre-condition that the function is wrapped, which is not always necessary, say, if we just want to apply a function to a couple of wrapped values, there is no need to wrap the function up explicitly, that's why the `Applicative` module introduces another function called `<$>`, which is exact same as `fmap` but has more elegant form when applied.

```haskell
(<$>) :: Functor f => (a -> b) -> f a -> f b
```

For instance, if we want to apply `(+)` to `Just 3` and `Just 5`, now we can simply write 
```haskell
(+) <$> Just 3 <*> Just 5
```
which is quite intuitive.

I think that's some basic knowledge a beginner should know about Haskell before he actually start doing codes. In the following sections, I'll talk about Haskell `IO`, datatypes, monads, something like that.

## I/O
Haskell strictly separate pure codes and non-pure ones, which may cause the world to change. Therefore, a complete isolation of side-effects is provided from the language level, which is a nice feature that helps improve program stability, because many bugs in programs are caused by unanticipated side-effects.

Haskell I/O is a subset of those actions that might have side effect. Here are some examples of I/O functions

### IO actions

```haskell
putStrLn :: String -> IO ()
-- This writes out a string to standard output which an end-of-line char

getLine :: IO String
-- This gets a string from the standard input
```

Anything with `IO Something` in it is an IO action, which can be stored in a variable and evaluated later (because they are functions). They can also be glued toghther to form a larger block of action using `do`, like this
```haskell
myblock = do
    putStrLn "Please type something"
    myStr <- getLine
```

Any IO action has an underlying data type bound to it, for example, the `getLine` function has a `IO String` in the type definition, which means it has a `String` value bound to it. Using `<-` when calling IO actions can get the underlying value and store it in a variable. The value of action block is the value of the last action in that block.

Some actions have `IO ()` in their type definitions, which means there is nothing (called 'unit') bound to it. The `()` is simply an empty tuple, indicating there is nothing (Like `void` in C++). Consider following code:
```haskell
let writefoo = putStrLn "foo"
writefoo

-- we get foo in console
```
We have "foo" printed in the console, but that's not the value of writefoo statement, instead, that's caused by the side effect of IO action, which write a string to the standard output handle.

So what the fuck is IO action? Here are the ideas
- It has the type of `IO t` where `t` is the data type of the value it yields
- It is first-class value and can be seamlessly fit into Haskell's type system
- It produces side effect when performed (called by something outside the IO context)
- Performaing IO action yields a value of type associalted to it.

### Handles, Standard Input, Output and Error
File I/O is another kind of IO in Haskell, which differs from standard IO in that File IO operates on file Handles which are get from opening a file.

```haskell
openFile :: filePath -> IOMode -> IO Handle
-- IOMode can be WriteMode, ReadMode, ReadWriteMode, AppendMode

hPutStr :: Handle -> String -> IO ()
```
In order to use it, we simple to the following operations
```haskell
myHandle <- openFile "a.txt" WriteMode
hPutStr myHandle "This is a string"
```
We may find that for each standard IO function, there is a File IO function associated to it, with a 'h' at the front of the function name, which is True. In fact, the non-h functions are just the result of partially applying the h functions to a pre-defined handle (Standard IO handles defined in `System.IO`). Which is, 

```haskell
import System.IO
getLine = hGetLine stdin
putStrLn = hPutStrLn stdout
...
```
Some operating systems let you redirect file handlers to come from or go to different places (files, devices or other programs). For example
```sh
echo John | runghc callingpure.hs
```
It doesn't read input from keyboard, instead, it receives the output from echo command.

### Lazy IO
We know that Haskell is lazy; Variables in Haskell are not evaluated until it is necessary to do so. IO actions also have lazyness to them, One typical example is `hGetContents`. This is an IO action which is used to read all the contents in a `Handle` in the form of `String`. It has type of 
```haskell
hGetContents :: Handle -> IO String
``` 

In some other languages, thing such as "reading everything into memory" can crash the program because the file is way too large. In Haskell, this is avoided because of lazy evaluation. Data in the file (`Char`s) is only read into memory when they are processed (Like converting to upper case). The data that is nolonger used is automatically collected by Haskell Garbage Collector. The good thing is that Haskell has shielded all these facts from programmers, so the result of `hGetContent` is just like a `String` from the developers' point of views. They can pass it to any pure function that takes String as parameter without eating up all the memory.

(If you do need to read the whole file into memory for later use, Haskell is not able to save you.)

## Monad