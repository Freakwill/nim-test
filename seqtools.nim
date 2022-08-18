#!/usr/bin/env nim

import std/[sequtils, sugar]

proc remove*[T](s: var seq[T], val: T): seq[T] {.discardable.} =
  for i, x in s:
    if x == val:
      s.delete(i)
      break

proc remove_all*[T](s: var seq[T], val: T): seq[T] {.discardable.} =
  for i, x in s:
    if x == val:
      s.delete(i)


template arrayWith*(size: static int, val: untyped): auto =
  # Usage: var a = arrayWith(3, rand(1))
  var result: array[size, typeof(val)]
  for aVal in result.mitems:
    aVal = val
  return result


func best*[T, S](b: seq[T], f: T->S): T =
  let i = maxIndex b.map(f)
  return b[i]
