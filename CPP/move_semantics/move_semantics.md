# References, Values, Pointers

When a variable is declared as a reference, it becomes an alternative name for an existing variable.

|Operation|Value|Reference|Pointer|
|---|---|---|---|
|Init by assign|`My_Class c = obj1;`|`My_Class& c = obj1;`|`My_Class *c = &obj1;`|

When we do something like 

```c++
My_Class& m = obj1;
```
it simply creates a reference to `obj1`. The reference is pretty similar to pointers, that is, the reference has an underlying pointer pointing to the object. The main difference is that, the reference can not be modified, which means the reference can only refer to one object.

Look at following code snippet, which explains the behavior of value, reference and pointer.

```c++

// Copy obj1 to m_val by calling its copy constructor
// Compiling err when no suitable copy constructor is present
My_Class m_val = obj1;

// Creates a reference that refers to obj1
My_Class& m = obj1;

// Attempt to call its = operator, the behavior depends on implementation
// Compiling err when no suitable = implementation is provided
m = obj2;

// Creates a pointer pointing to obj1
My_Class* m_ptr = &obj1;

// The pointer now points to the address of obj2
// Reference can't do this!
m_ptr = &obj2;

```

Now we roughly have the idea of how to refer to something in C++, and when the object is moved, copied or the pointer is changed. C++ was designed as a high-performance programming language, but if you don't use it carefully, the performance becomes really really bad, like this

```c++
My_Class get_object_by_copying_temp_value() {
    return My_Class();
}

// Calls the function, and COPY the constructed object to value m
My_Class m = get_object_by_copying_temp_value();
```

Such operations may destroy your application! Although in Java we always do this

```java

MyClass getObject() {

    return new MyClass();
}

```
but that's totally different story. In Java, this function simply instantiate an object on **heap**, then return a reference to it, that's why we say in Java, we always pass and return by **value**, but the value itself can be reference to the actual instance. In C/C++, a value is a value, unless it's declared as a pointer or reference explicitly.

In the past, we could allocate memory on heap, and pass by pointers to prevent copying.

```c++
My_Class* get_pointer() {
    My_Class* m_ptr = (My_Class*) malloc(sizeof(My_Class));
    // Init values
    // ...
    return m_ptr;
}

My_Class* m_ptr = get_pointer();
free(m_ptr);
```

Or you can do with `const` references.

```c++
// Not the const here. The code won't compile without it
// C++ has some magic to extend the scope of the object to the scope of constant reference
const My_Class& get_object() {
    // The returned rvalue is temprory, unless its const reference
    return My_Class();
}
```

However, this solution only applies to constant references.

# Move Constructors and Move Assignment
In C++11, move semnatics is introduced. The main idea is that why can't we STEAL some values from temporary objects?

In order to support move semantics, we need to implement move assignment operation and move constructor in our class, like this:

```cpp
public:
    int val;

    My_Class() {
        this -> val = 4;
    }

    My_Class(My_Class&& that) {
        cout<<"moved"<<endl;
        val = that.val;
    }

    My_Class& operator = (My_Class&& that) {
        cout<<"move assigned"<<endl;
        return *this;
    }

};
```

And now if we construct an object by passing the temporary object to it:

```cpp
My_Class get_object() {
    return My_Class();
}

My_Class obj2 = get_object();

```
we can see the move constructor is invoked. So by adding a constructor and an operator, the performance of the code is improved without changing the business logic.

[RVO](http://www.fluentcpp.com/2016/11/28/return-value-optimizations/)
NOTE: Add -fno-elide-constructors to g++ to prevent return elision

# Vector Optimization with No-Throw Moving

In `stdlib` vector implementation, moving or copying is one decision to make when trying to enlarge itself. When the size and capacity of a vector are equal, it allocates a new block of memory, and copy items to that new memory space. When the copy finishes, the original vector is destroyed. If exception is thrown in the copy process, the new memory is thrown away and the original vector is unchanged. However, always copying items is pretty slow, why can't we just move items by shifting the pointers? The problem is that moving might throw. It is pretty hard to rollback the move operation because undoing a move might also throw, that's when you get messed up.

The good news is that if we tell the compiler that our object never throw when being moved, vector will use move operation in expansion, which speeds up you code. We'll discuss this in [template](../templates/template.md) section.