
- [Learning Golang](#Learning-Golang)
  - [Install Go](#Install-Go)
- [Something to remember...](#Something-to-remember)
  - [package/import](#packageimport)
  - [Functions](#Functions)
  - [Variables](#Variables)
  - [Basic types](#Basic-types)
  - [Confrol flow](#Confrol-flow)
    - [For loop](#For-loop)
    - [Switch](#Switch)
    - [Defer](#Defer)
  - [Pointer](#Pointer)
  - [Structs](#Structs)
  - [Arrays & Slice](#Arrays--Slice)
  - [Maps](#Maps)
  - [Closures](#Closures)
  - [Methods](#Methods)
  - [Interface](#Interface)
  - [Type Assertion](#Type-Assertion)
  - [Type switch](#Type-switch)
  - [Stringer](#Stringer)
  - [Error](#Error)
  - [Channel](#Channel)
  - [Select](#Select)
  - [Mutex](#Mutex)
## Learning Golang

This is not a tutorial, and I'm not expecting anyone to learning Go by reading this because I'm a novice as well. This is somewhere I write down some notes as I learn.

### Install Go
Installing Go is quite simple, which is nothing more than

- Downloading and installing the binary
- Setting GOPATH
- Adding Go executables to PATH

```sh
# Download the binary and install to /usr/local/go

TAR_URL=https://dl.google.com/go/go1.12.6.linux-amd64.tar.gz
rm -rf /usr/local/go
wget -O- $TAR_URL | tar -C /usr/local -xvz
```

```sh
# Add these two lines to .bashrc

export PATH=$PATH:/usr/local/go/bin
export GOPATH=/home/ubuntu/go
```

What is the difference between `GOPATH` and `GOROOT`. Well, `GOPATH` is like your working dir, where you put third party packages or source codes. The following code installs testify package,

```sh
# install the package testify
# https://github.com/stretchr/testify 
go get github.com/stretchr/testify
```
and you get this in `GOPATH/pkg`

```
/home/ubuntu/go/pkg/
└── linux_amd64
    └── github.com
        └── stretchr
            └── testify.a
```

While `GOROOT` is like the path to your Golang software, which is needed if you have multiple versions of Go installed.

## Something to remember...

### package/import
Go programs are made up of packages. Program start running in package `main`. The following code imports `fmt` and `math/rand` to do a fairly simple job. The last element of package path can be directly used.

```go
package main
import "fmt"
import "math/rand"
func main() {
    fmt.Print(rand.Intn(10))
    // use rand.Xxx directly
}

```
The import can also be
```go
import (
    "pkg1"
    "pkg2"
)
```
Exported name start with capital letter.

### Functions

```go
// Define a function
func funcName(arg type, arg2 type2) (type3, type4) {
    return val1, val2
}

// Named return
// Don't use too much
// Unreadable
func add(a, b int) (x int) {
    x = a + b
    return
}
```

### Variables
```go

package main

import "fmt"

var a, b, c int // package level

func main() {
    var i int // function level declaration
    var j int = 3 // with init value
    k := 8 // Implicite type
    const g = 12 // Constant
    const (
        Big = 1 << 100 // shift 1 100 left
        // Untyped numeric const takes the type needed by context
    )
}

```
### Basic types
- bool
- string
- int
- uint
- byte (uint8)
- rune (int32)
- float32 float64
- complex64 complex128

```go
T(x) // type conversion
```

### Confrol flow

#### For loop
```go
for init; end; inc {

}

for cond {
    // like while
}
for {
    // forever
}
```
#### Switch 
```go

switch var {
    case value1:
        do something
    case value2:
        do something else
    default:
        do default_ shit
}
```

Evalute from top to bottom, stop when a case succeeds.

```go
// switch with no condition
switch {
    case cond1:
        do_something
    case cond2:
        do_something_else
    default:
        do_default_shit
}
```

When used with no condition, a full condition can be placed after `case`.

#### Defer
Defers the execution of a function until the surrounding function returns
```go
func main() {
    defer fmt.Println("world")

    fmt.Println("hello, ")
}
// Get hello, world in console
```

Deferred fn are pushed to stack, so executed first-in-last-out order.

### Pointer
```go

func incr(i *int) {
    i ++
}

i := 1
p := &i
incr(p)

// We get i=2 as a result
```

### Structs

```go
// struct is a collection of fields

type Vertex struct {
    X int
    Y int
}

v := Vertex{1,2}
v.X = 3
// Modify X to 3

p := &v
(*p).X
p.X
// Both are valid

v2 := Vertex{X:1}
// Y is 0 by default


```

### Arrays & Slice
```go
[n]T
// Array of type T with lengh n
// Length is an attribute, which is immutable

var a [10]int
// a is an int array with length 10


```

Slice is dynamically sized, references to arrays.
```go
[]T
// Slice of type T
c := [3]int{1,2,3}
a := []int{1,2,3}
cs := []int c[0:2] // [2,3]
nilSlice := nil // can be nil

makeslice := make([]int, 5)
matrix := [][]int {
    []int{1,2,3},
    []int{3,4,5},
} // 2d slice

append(a, 1) // append to slice
// array re-allocation happens

for i, v := range a {
    do sth to i and v
}
```

- **len()** is the number of element in slice
- **cap()** is the number of elements in underlying array, counting from first elem in the slice

Slicing from the beginning does not affect cap, and you can always re-slice to extend. But slicing from the middle cut down cap, you cannot re-slice to extend back.


### Maps
```go
m := map[string]int
// map string to int

m = make(map[keyType]valType)
m[key] = val
delete(m,key) // delete a value

elem, ok = map["key"]
```

### Closures

```go
func adder() func(int) int {
    sum := 0
    return func(x int) int {
        sum += x
        return sum
    }
}
// adder() returns a closure, each one with its own sum bounded

func main() {
	pos, neg := adder(), adder()
	for i := 0; i < 10; i++ {
		fmt.Println(
			pos(1),
			neg(-1),
		)
	}
}
```

### Methods

```go
type Vertex struct {
	X, Y float64
}

func (v Vertex) Abs() float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

func (v *Vertex) Testp() int {
    v.X = 1
    return v.X
    // Pointer receiver
    // Modifies struct value
}

func main() {
    v := Vertex{3, 4}
    v.Testp()
    (&v).Testp()
    // Can either take pointer or value, interpreted as accepted by pointer
	fmt.Println(v.Abs())
}
```


### Interface
An interface type is defined as a set of method signatures. A value of interface can hold any value that implements those methods.

```go
type Int_f interface {
    Incr() int
}

type Int struct {
    V int
}

func (i *Int) Incr() int {
    return i.V + 1
}

var a Int_f
v := Int{1}

a = v // Error, no implementation for Int
a = &v // Correct, pointer receiver is implemented
```

Interface values can be thought of as a tuple of a value and a concrete type
```go
(value, type)
```
An interface value holds a value of specific underlying concrete type. Calling a method of interface value executes the method of same name on its underlying type
 
```go
var i interface {} 
// Holds any type
```

### Type Assertion
```go
v, ok = i.(int)
// Type Assertion
```

### Type switch
```go
switch v := i.(type) {
    case ...
}
```

### Stringer
`fmt.Print` looks for `Stringer` interface to print values

```go
func (v Type) String() string {
    return fmt.Sprintf("asdasd")
}
```

### Error
error interface implements `Error()` method
```go
func (e *MyErr) Error() string {
    return "Error message"
}
```

### Channel
```go
ch <- v // Send v to channel
v := <- ch // Recv val from channel

ch := make(chan int)
// Create the chennel

ch := make(chan int, 100)
// buffered channel, blocks

for i := range c {
    //recv value repeatedly until closed
}

close(ch) // close channel

v, ok := <- ch
// Ok is false if channel closed

```

### Select
```go
select {
    case c <- x:
        ops
    default:
        wait
}
// Block until some case can run
// Randomly select one if multiple are ready
```

### Mutex
```go
type Counter struct {
    v int
    mux sync.Mutex
}

c:= Counter{v:1}
func (c *Counter) {
    c.mux.Lock()
    defer c.mux.Unlock()
    c.v = 3 
}

```