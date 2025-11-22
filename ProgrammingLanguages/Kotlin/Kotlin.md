# Learning Kotlin

## Inline functions
Inline functions are introduced as a part of functional programming features in Kotlin. Let's just look at a high order function

```kotlin

fun ordinaryFun(f: () -> Unit) {
    println("Executing ordinary function")
    f()
}

fun main() {
    ordinaryFun {
        println("Invoked")
    }
}

```

which is dead simple. A code block as a `fun` with type of `() -> Unit` is passed as argument to `ordinaryFun`, and is invoked inside. The problem is that this anonymous function is instantiated and produce a closure, where the variables are only accessible from inside. Let's put it in java's way

```java

Function<Void, Void> f = () -> {
    System.out.println("Invoked")
}

ordinaryFun(f)

```
See? A function object is instantiated and passed to the function, which introduces overhead in object creation, which is quite expensive.

Therefore inline function is introduced to reduce this. Look at this `inline` modifier

```kotlin
inline fun inlineFun(f: () -> Unit) {
    println("Inline function")
}

```

When the compiler sees the `inline` keyword, it automatically generate the byte code of that function, therefor the overhead is eliminated and lambda behaves like normal function calls.

## Reified type parameter
 
a `reified` type parameter is a special type of type parameter that can be used like a `Class`. The `reified` type parameter can only be used in `inline` functions. The reason is that in ordinary functions, the parameter is erased at compile time, so if you want to access the class object, you need to pass in arguments. 

A `inline` function is inlined where it is used, so then the compile see that reference to `inline` function, it knows what is the parameterized type exactly.

In java, the generic functions behaves like this
```java
// Before compile
public class BoundStack<E extends Comparable<E>> {
    private E[] stackContent;
 
    public BoundStack(int capacity) {
        this.stackContent = (E[]) new Object[capacity];
    }
 
    public void push(E data) {
        // ..
    }
 
    public E pop() {
        // ..
    }
}


// After compile
public class BoundStack {
    private Comparable [] stackContent;
 
    public BoundStack(int capacity) {
        this.stackContent = (Comparable[]) new Object[capacity];
    }
 
    public void push(Comparable data) {
        // ..
    }
 
    public Comparable pop() {
        // ..
    }
}

```

The compiler "sort of" knows about the real type, but not really. What it does is just bound the type depending on how type parameters are defined.

In kotlin, it would be something like this
```kotlin


// Some function that check whether 
// integer 1 is of given type
// Before compile
inline fun<reified T> foo() {
    return 1 is T
}

/*
We have three invokations
*/
foo<Double>()

foo<Int>()

foo<String>()


// After compile

fun foo1() {return 1 is Double}
fun foo2() {return 1 is Int}
fun foo3() {return 1 is String}
```

