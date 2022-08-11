#!/usr/bin/env nim

import std/random
import std/strutils
import std/sequtils
import std/math
import seqtools

randomize()

#[
  Genetic algorithm by Nim
]#


# Arrays

const
  n_genes: int = 10
type
  Chromosome = array[n_genes, int]  # Array's are fixed length and

type
  Population = object
    chromosomes: seq[Chromosome]
    hof: seq[Chromosome]


proc fitness(c: Chromosome): int

proc `$` (c: Chromosome): string =
  return c.join("|") & " = " & $fitness(c)


proc `!` (mother: Chromosome): Chromosome =
  var son = mother
  var position: int
  for position in 0 ..< n_genes:
    if rand(1.0) < 0.25:
      son[position] = 1 - son[position]
  return son



proc `*` (mother: Chromosome, father:Chromosome): Chromosome = 
  let position = rand(9)
  var son = father
  son[position..9] = mother[position..9]
  return son

# proc `@` (pop: Population): Population = 
#   let position = rand(9)
#   var offspring: Population
#   var n = len(pop.chromesomes)
#   for (i, c) in pairs(pop.chromesomes & pop.hof):
#     for cc in pop.chromesomes[i..^1]:
#       if rand(1.0) < 2/n:
#         offspring.chromesomes.add c * cc
#   pop.chromesomes = offspring.chromesomes
#   return pop

# proc update_hof(pop: Population): Population =
#   pop.hof = @[best(pop.chromesomes, fitness)]


proc rand_chromesome(): Chromosome =
  var c:Chromosome
  for i in 0 ..< n_genes:
    c[i] = rand(1)
  return c

proc rand_population(size:int): Population =
  var p: seq[Chromosome] = @[]
  for i in 0 ..< size:
    let c = rand_chromesome()
    p.add c
  pop.chromosomes = p
  # pop.update_hof()

var p: Population
p = rand_population()
for c in p.chromesomes:
  echo c

proc select_aspirants(pop: Population, size: int = 3): Population =
  # select `size` individuals from the list `individuals` in one tournament.
  var copy = pop
  shuffle(copy)
  return (copy[0..<size])

proc best(pop:Population, fitness: proc (c:Chromosome): int ):Chromosome =
  var fitnesses = pop.chromesomes.map(fitness)
  let i = maxIndex(fitnesses)
  if fitness(pop.chromesomes[i]) < fitness(pop.hof[0]):
    return pop.hof[0]
  else:
    return pop.chromesomes[i]

