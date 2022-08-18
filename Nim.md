# Nim

[TOC]

## Examples

```nim
import std/math
import timeit

proc primes(): seq[int] =
    # sieve of Eratosthenes
    const n = 1000000
    var f: array[1..n, bool]
    for i in 1..n:
        f[i] = (i mod 2) == 1
    var i: int = 3
    var nn: int = int(floor(sqrt(float(n))))
    discard """var
      i: int
      nn: int
    i = 3
    nn = int(floor(sqrt(float(n))))
    """
    while i <= nn:
        if f[i]:
            var j :int = i^2
            while j<=n:
                f[j] = false
                j = j+ 2*i
        i = i + 2

    var P: seq[int]
    P = @[2]
    for x in countup(3, n, 2):
        if f[x]:
            P.add x
    return P


timeOnce("timeit"):
    discard primes()
```

`nim --eval:"import std/random;randomize();echo rand(5)"`



## Type

### basic type

#### strings

```nim
import std/strutils
let
  numbers = @[867, 5309]
  poem = "I love three things:\nthe sun,\nthe moon and you"

let jenny = numbers.join("-")
assert jenny == "867-5309"

assert splitLines(poem) ==
       @["I love three things:", "the sun,", "the moon and you"]
assert split(poem) == @["I", "love", "three",...]
assert indent(poem, 4) ==
       "    I love three things:\n    the sun,\n    the moon"
assert 'z'.repeat(5) == "zzzzz"
```

### advanced type

#### array


```nim
type
  Room = array[0..3, string] # an array with the length of 4
var
  x: Room
x = ["Y Wang", "H Adami", "D Wu", "S Warakkagun"]
for i in 0 .. 3:
  echo x[i]


type
  Rooms = array[0..1, Room] # an 2-order array
var
  x: Rooms
x = [["Y Wang", "H Adami", "D Wu", "S Warakkagun"],
["P Hu", ...]]
for i in 0 .. 1:
  for j in 0 .. 3
    echo x[i][j]
```


#### Sequences

```nim
var x: seq[string]
x = @["Y Wang", "H Adami", "D Wu", "S Warakkagun"]
```

```nim
import std/sequtils
import std/sugar

# Creating a sequence from 1 to 10, multiplying each member by 2,
# keeping only the members which are not divisible by 6.
let
  foo = toSeq(1..10).map(x => x * 2).filter(x => x mod 6 != 0)
  bar = toSeq(1..10).mapIt(it * 2).filterIt(it mod 6 != 0)
  baz = collect:
    for i in 1..10:
      if i mod 6 != 0:
        i

```

#### tuple

```nim
type
  # type representing a person:
  # A person consists of a name and an age.
  Person = tuple
    name: string
    age: int

# <=> Person = tuple[name: string, age: int]

# anonymous field syntax
Person_ = (string, int)
```


## Functions/Procedures

```nim
proc square(n: int): int =
  return n*n

```

### forward declaration

```nim
# forward declaration:
proc even(n: int): bool

proc odd(n: int): bool =
  assert(n >= 0) # makes sure we don't run into negative recursion
  if n == 0: false
  else:
    n == 1 or even(n-1)

proc even(n: int): bool =
  assert(n >= 0) # makes sure we don't run into negative recursion
  if n == 1: false
  else:
    n == 0 or odd(n-1)
```

### overloading

```nim
# toString == $
```

### Procedural type

A procedural type is a (somewhat abstract) pointer to a procedure. nil is an allowed value for a variable of a procedural type. Nim uses procedural types to achieve functional programming techniques.

```nim

proc greet(name: string): string =
  "Hello, " & name & "!"

proc bye(name: string): string =
  "Goodbye, " & name & "."

proc communicate(greeting: proc (x: string): string, name: string) =
  echo greeting(name)

communicate(greet, "John")
communicate(bye, "Mary")
```


## OOP

```nim
type
  Person = object
    name: string
    age: int
    gender: bool
```


## generic type

```
type
  Vector[L: static[int]] = array[L, int]
  Basis[L: static[int]] = seq[Vector[L]]

proc rand_vector(n: static int=3): Vector[n] =
  for val in result.mitems:
    val = rand(1)


proc rand_basis(size:int, n:static int=3): Basis[n] =
  collect:
    for _ in 0 ..< size:
      rand_vector(n)


# proc fun[T:Vector](v: T):int = v[0]
proc fun(v: auto):int = v[0]

func best[T, S](b: seq[T], f:T->S): T =
  let i = maxIndex b.map(f)
  return b[i]

var basis = rand_basis(3)
echo best(basis, fun)
```

### typedesc

```nim
proc new(T: typedesc[int]): string = "yes"
echo int.new

template isNumber(t: typedesc[object]): string = "Don't think so."
template isNumber(t: typedesc[SomeInteger]): string = "Yes!"
```

## Module

```nim
# in a.nim
func f*() = ...
```

```nim
import a

f()  # or a.f()
```


## Masterpiece

```nim
import std/[math, sequtils, random, sugar]


const ndim = 2
type
  Point[T: static int] = array[T, float64]
  Data[T: static int] = seq[Point[T]]

proc choice(data:Data, n:int=1):Data = 
  var cpy = data
  cpy.shuffle()
  return cpy[0..<n]

proc dist(a, b: Point): float64 =
  for (ai, bi) in zip(a,b):
    result += (ai-bi)^2
  return result

func `+`(p, q:Point):Point =
  for i, (pi, qi) in zip(p, q):
    result[i] = pi + qi
  return result

proc `*`(p:Point, s: float64):Point =
  for i, pi in p:
    result[i] = pi * s
  return result

proc mean[T](s: seq[T]): T =
  var m: T
  for p in s:
    m = m + p
  return m * (1 / s.len())

proc get_labels[T](data, centroids:seq[T]):seq[int]=
  return data.map (p:T) => minIndex centroids.map((c:T) => dist(p, c))

proc get_centroids(data:Data, labels:seq[int]):Data =
  var centroids = collect:
    for c in 0..<n_clusters:
      var ps = collect:
        for (p, l) in zip(data, labels):
          if l == c:
            p
      ps.mean()

  return centroids
  
proc fit(data:auto, n_clusters:int=2, max_iter:int=10): tuple =
  var centroids = choice(data, n_clusters)
  var labels = get_labels(data, centroids)
  for _ in 1 .. max_iter:
    centroids = get_centroids(data, labels)
    labels = get_labels(data, centroids)
  return (labels, centroids)

const n_clusters = 5

randomize()

var data = collect:
    for _ in 0 ..< 5000:
      [gauss(mu=0, sigma=1), gauss(mu=0, sigma=1)]

var (labels, centroids) = fit(data)
```