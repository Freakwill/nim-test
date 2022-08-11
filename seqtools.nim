#!/usr/bin/env nim


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
  # Usage: var a = arrayWith(4, rand(1))
  var arr: array[size, typeof(val)]
  for aVal in arr.mitems:
    aVal = val
  arr
