# Background

Is it possible to generate a compiler by implementing interpreter? The answer is YES.

## Partial Evaluation

In functional programming, partial evaluation is defined as given a function which takes N parameters and return a output, if we apply the function with one parameter, when we get another function which takes (N-1) parameters and return one output.

In programming language implementation, a program is a function, with dynamic data and static data. Performing partial evaluation means given the static part, we can eliminate unnecessary behaviors and yield a compact and fast version of that program. This process is called specialization. If we specialize our program for each single problem, each of that specialized version of program runs really fast, but might explode in space, that's why we need to make decisions between specialization and generalization.

## Futamura's projection

Let's look at `Futamura's Projection`. Say we have following entities

- Program: `P`
- Data: `D`
- Output: `O`
- Executable: `E :: D -> O`
- Interpreter:  `I :: P -> D -> O`

## Futamura's 1st projection

This projections says if we specialize an interpreter with a program, we yield an executable. This is quite straightforward, let say this specializer is called `S1`

```haskell
S1 :: (P -> D -> O) -> (P) -> (D -> O)
```

This is pretty close to what we always have in functional programming, but this is a quite different story. When we apply specialization, we are optimize the interpreter by pruning out unreachable branches and yield an efficient executable.

## Futamura's 2nd projection

This projection says specializing specializer `S1` with an interpreter,  yields a compiler.

If we apply `(P -> D -> O)` to `S1` defined above, what we get a 

```haskell
(P) -> (D -> O)
```

which is a function that takes a program as input and product an efficient executable, this is a compiler! Let's say this specializer `S2` is written as 

```haskell
S2 :: S1 -> I -> C
```

## Futamura's 3rd projection

This projection says specializing specializer `S2` with specializer `S1` yields a interpreter to compiler converter. This is pretty intuitive if we apply `S1` to `S2` above, we get a function

```haskell
F :: I -> C
```

which is exactly what it describes.

Now we know that by implementing an interpreter, we get a compiler for free,  if we invent such a machine that performs `I -> C` for us. Fortunately, we have such a machine implemented by the community, which is called Truffle.  Truffle allows us to implement out interpreter on AST, and use declarative directives to get instructions specialized automatically.



# Simple Language (sl)

Simple language is a custom language implementation based on Truffle, which is object-oriented and has dynamic class definitions. This section we'll focus on implementation of simple language.

## Object Operations

Think about following expression in sl

```
obj = new()
obj.a = 4
```

This statement simply creates a new object, and then assign an integer, 4 to its property `a`. Such operation in sl is defined as `factor`. It looks like this

```
factor returns [SLExpressionNode result]
:
(
    IDENTIFIER                                  { SLExpressionNode assignmentName = factory.createStringLiteral($IDENTIFIER, false); }
    (
        member_expression[null, null, assignmentName] { $result = $member_expression.result; }
    |
                                                { $result = factory.createRead(assignmentName); }
    )
|
    STRING_LITERAL                              { $result = factory.createStringLiteral($STRING_LITERAL, true); }
|
    NUMERIC_LITERAL                             { $result = factory.createNumericLiteral($NUMERIC_LITERAL); }
|
...
;
```

It is matched against a identifier followed by `member_expression`. In this case, the `assignmentName` passed to `member_expression` is `'A'`.  `member_expression`  is defined as: 

```
member_expression [SLExpressionNode r, SLExpressionNode assignmentReceiver, SLExpressionNode assignmentName] returns [SLExpressionNode result]
:                                               { SLExpressionNode receiver = r;
                                                  SLExpressionNode nestedAssignmentName = null; }
```

It takes 

consists of several pattern matching rules

### Function call

```
    '('                                         { List<SLExpressionNode> parameters = new ArrayList<>();
                                                  if (receiver == null) {
                                                      receiver = factory.createRead(assignmentName);
                                                  } }
    (
        expression                              { parameters.add($expression.result); }
        (
            ','
            expression                          { parameters.add($expression.result); }
        )*
    )?
    e=')'
```

### Assignment

assignment starts with an `=` 

```
    '='
    expression                                  { if (assignmentName == null) {
                                                      SemErr($expression.start, "invalid assignment target");
                                                  } else if (assignmentReceiver == null) {
                                                      $result = factory.createAssignment(assignmentName, $expression.result);
                                                  } else {
                                                      $result = factory.createWriteProperty(assignmentReceiver, assignmentName, $expression.result);
                                                  } }
```

### Property Read

```
    '.'                                         { if (receiver == null) {
                                                       receiver = factory.createRead(assignmentName);
                                                  } }
    IDENTIFIER
                                                { nestedAssignmentName = factory.createStringLiteral($IDENTIFIER, false);
                                                  $result = factory.createReadProperty(receiver, nestedAssignmentName); }
```

 or

```
    '['                                         { if (receiver == null) {
                                                      receiver = factory.createRead(assignmentName);
                                                  } }
    expression
                                                { nestedAssignmentName = $expression.result;
                                                  $result = factory.createReadProperty(receiver, nestedAssignmentName); }
    ']'
```



Let's see how these rules handle `A.prop = 4`.

First of all, "A" is matched by `IDENTIFIER` and ".prop=4" is matched by `member_expression`. The `member_expression` is first invoked with parameter

```
member_expression(null, null, "A")
```

Because the receiver is unspecified, "A" is used to create a `Read` node which reads a variable from `VirtualFrame` using variable name. The token starts with "." thus the first result should be a property read, therefore we get

```
receiver = Read("A")
result = ReadProp($receiver, "prop")
nestedAssignmentName = "prop"
```

The second part is a recursive call on the remaining token

```
member_expression(ReadProp(Read("A"), "prop"), Read("A"), "prop")
```

This time, the token starts with "=" thus a `WriteProperty` node is generated, which is 

```
WriteProperty(Read("A"), "prop", 4)
```

This means assigning 4 to the "prop" property to variable "A".



## Function Definition



# Truffle DSL

## @Cached

### Usage

`@Cached` annotation is applied to parameters of specialized functions. Parameters annotated with `@Cached` is initialized once per specialization. 

`@Cache` accept expressions as argument, which can be used to access -

- parameters
- public functions
- use new() to access public constructor
- use create() to instantiate Class without public constructors



### Use case



```java
   @NodeChild("operand")
   abstract TestNode extends Node {
     abstract void execute(Object operandValue);
     // ... example here ...
   }
```

```java
    @Specialization
    void doCached(int operand,  @Cached("operand") int cachedOperand) {
        CompilerAsserts.compilationConstant(cachedOperand);
        ...
    }
```

```    java
    execute(1) => doCached(1, 1) // new instantiation, localOperand is bound to 1
    execute(0) => doCached(0, 1)
    execute(2) => doCached(2, 1)
```



## @Specialization

### Usage

`@Specialization` annotation is used together with `@NodeChild` to define a specialized operation of a node. Guards define when specializations happen and when the execution is returned to interpreter. It support following guards

-  Type guards: By define the parameter of type defined in `TypeSystem`, type guard is implicitly applied. When using `Object` as parameter, there would be no type guard is applied
- Expression guards: Use expressions as guards. Either simple operations or method calls can be used. It is suggested to use method calls to keep code maintainable.
- Event guards: This triggers re-specialization on certain events, like Exceptions. This will return the execution back to interpreter.
- Assumption guards: Assumption is initialized per specialization. This guard optimistically assume the state of Assumption remains true. Specialization is removed when assumption becomes invalid



Specialization generates a "specialized" program for a specific purpose, which means the compiler can potentially generate arbitrary number of specified programs. In order to prevent memory explosion, this `@Specialization` supports specifying limit of specialized programs using `limit()` property.





# Truffle Object Storage Model

## Components of OSM

### Storage Class

A Java class which contains fields used to store data of the guest language objects.

### Layout

Every storage class is assigned to a layout upon its first use. This provides info about its available fields, allocation strategy, and OSM features. 

### Shape

Shape contains all meta-data of a Truffle OSM object.

### Property

Describes a property by its identifier, location and attributes.

### Allocator

Allocator is used to create storage locations for new members. It maintains info about size of the extension arrays and which parts of the storage areas are in use. Allocator uses info provided by layout to do its job.

### Location

Defines the storage location of a property. Storage locations include:

- Object field location: denotes an instance field of the storage object that is used to store object reference. Additionally, it holds the lower bound type reference of referenced object.
- Primitive field location: stores primitive types
- Object extension array location: Object[] array, loaded from object field location.
- Primitive extension array location: 
- static location

By using extensions, it is possible to support arbitrary number of properties. Accessing field is faster than accessing extension array because of fewer memory indirection. Language implementer can decide the size of fields to provide, but more fields means higher heap consumption even if not used.

### Operation

Method table of operations applicable to the object. Language implementers can add/override these operations.

### Transition

When a property is added to object, or removed from it, it's shape changes. Transition defines such changes. Every shape has a transition map.

### Shared Data

A special storage area in the `Shape` that can be used by language implementation to store additional meta-data in the shape. This is inherited by successor shapes, therefore can survive the shape `Transitions`.

