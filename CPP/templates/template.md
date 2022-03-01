# C++ Template and Type trait


# Two Phase translation

- The compiler is limited in what it can di when it first encounters a template definition
- It can't generate code
- It just scoops up the template and store it in the symbol table

## Phase 1
parse the template declaration

## Phase 2
Deduce things, instantiate the template. (This happens at each instantiation)


# Dependent vs Non-dependent Names
- A name appearing in a template whose meaning depends on one or more template parameter is a dependent name.
- A dependent name may have a different meaning in each instantiation

```c++
template <typename T>
T::size_type munge(T const &a) {
    T::size_type * i(T::npos);
}

// compiler does not know that size_type is type, npos is constant

// if size_type is type, npos is type
//  T::size_type * i(T::npos) is a function


// if size_type is type, npos is const, object or function
// -> object definition

// if both are not type
// multiplication
```

How does compiler handle this?
- A name used in a template delcaration that is dependent on template parameter is assumed not to name a type unless the name is qualified by the keyword typename

# Type trait
- Type trait is a templated `struct`
- member variables and member types give you information about the type that it is templated on

## Vector pushback
- if size() == capacity()
- allocate new memory, copy items to new memory, destruct old items, deallocate old memory
- if insufficient room, throw exception. Original vector is unchanged;

What if T is movable? (Move is faster than copy)
- Allocate new memory, move, destruct old items
- What if move fails?
  - Try to move back
  - What if that move fails

Vector moves items if they are move-constructible