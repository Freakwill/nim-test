#!/usr/bin/env nim

# import constructor/[constructor, defaults]

#[
Nim for Kmeans algorithm

Author: William
Date: 2022.8.18
]#

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
# echo labels

