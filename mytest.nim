#!/usr/bin/env nim

import constructor/[constructor, defaults]
import std/[math, sequtils, random]

type
  Vector[L: static[int]] = array[L, int]
  Basis = seq[Vector]



proc rand_vector(n: static int=3): Vector[n] =
  for val in result.mitems:
    val = rand(1)

let 

# proc rand_basis(size:int=10, n:static int=3): Basis[n] =
#   for i in 0 ..< size:
#     let c = rand_vector(n)
#     result.add c

# echo rand_basis()

# var a = [1,2]
# var t = [2,2]
# echo f(a, t) ,"Basis"


# type
#   User {.defaults.} = object
#     name: string = "Nim"
#     age: int = 0
#     lastOnline: Vector[3] = [1,2,3]

# implDefaults(User, {DefaultFlag.defExported}) # Required to embed the procedure

# proc initUser*(name: string, age: int): User {.constr.} # Can use like a forward declare.

# proc init(T: typedesc[User], name: string, age: int): User {.constr.} =
#   result.lastOnline = [2,2,2]


# echo User(lastOnline: [0,0,0], age: 10)
# echo initUser()
# echo User.init("hello", 30)


# type
#   Thingy {.defaults.} = object
#     a: float = 10 # Can do it this way
#     b = "Hmm" # Can also do it this way
#     c: int =1
# implDefaults(Thingy) # Required to embed the procedure
# echo initThingy()