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

### Something to remember...

#### package/import
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

#### Functions

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

#### Variables
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
#### Basic types
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
