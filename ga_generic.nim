#!/usr/bin/env nim

import std/[random,
  strutils,
  sequtils,
  math,
  algorithm]
import seqtools

randomize()

#[
  Genetic algorithm by Nim
]#


# Arrays

const
  n_genes: int = 15

type
  Gene = int
  Chromosome[L: static[int]] = array[L, Gene]  # Array's are fixed length and
  Population[L: static[int]] = seq[Chromosome[L]]


func fitness(c: Chromosome): int

proc `$` (c: Chromosome): string =
  return c.join("|") & " = " & $fitness(c)


proc `!` (mother: Chromosome): Chromosome =
  var son = mother
  var position: int
  for position in 0 ..< n_genes:
    if rand(1.0) < 0.25:
      son[position] = 1 - son[position]
  return son

proc `!` (pop: Population): Population =
  return pop.map(`!`)

proc `*` (mother: Chromosome, father:Chromosome): Chromosome = 
  var position = rand(8) + 1
  var son: Chromosome
  son = father
  son[0..^position] = mother[0..^position]
  return son

proc `@` (pop: Population): Population = 
  let position = rand(9)
  var offspring: Population = @[]
  var n = len(pop)
  for i, c in pop:
    for cc in pop[0..i-1]:
      if rand(1.0) < 2/n:
        offspring.add(c * cc)
    for cc in pop[i+1..^1]:
      if rand(1.0) < 2/n:
        offspring.add(c * cc)
  return offspring


proc rand_chromesome(size:static int): Chromosome[size] =
  for val in result.mitems:
    val = rand(1)


proc rand_population(size:int, n:static int): Population[n] =

  for _ in 0 ..< size:
    let c = rand_chromesome(n)
    result.add c


proc select_aspirants(pop: Population, size: int = 3): Population =
  # select `size` individuals from the list `individuals` in one tournament.
  var copy = pop
  copy.shuffle()
  return (copy[0..<size])

func best(pop:Population, fitness: proc (c:Chromosome): int):Chromosome = 
  let i = maxIndex pop.map(fitness)
  return pop[i]


proc select(pop:Population, n_sel:int=10, tournsize:int=3): Population =

  #[The standard method of selecting operation in GA
    
    Select the best individual among `tournsize` randomly chosen
    individuals, `n_sel` times.
  ]#

  var winners, rest, aspirants: Population
  rest = pop
  var size = tournsize
  var n_rest = len(pop)
  for i in 0 ..< n_sel:
    if n_rest == 0:
        break
    elif n_rest <= size:
        aspirants = rest
    else:
        aspirants = select_aspirants(rest, size)
    var winner = best(aspirants, fitness)
    winners.add(winner); rest.remove(winner) # move winner from original pop to winners
    n_rest -= 1
  return winners

func fitness(c:Chromosome):int =
  return c.sum() - 2*(c[1] + c[4]+c[9])


proc evolve(pop:Population, n_gens:int=10, verbose:bool=true):Population =
  var
    hof:Population = @[]
    new_pop:Population = @[]
  let hof_size = 3
  hof = pop.sortedByIt(-it.fitness())[0..^hof_size]
  var b = hof.best(fitness)
  if verbose:
    echo $b, '~', len(pop)
  for i in 1..n_gens:
    new_pop = select(pop)
    new_pop = @new_pop
    new_pop = !new_pop
    b = new_pop.best(fitness)
    for i, c in hof:
      if b.fitness() > hof[i].fitness():
        hof[i+1..^1] = hof[i..^2]
        hof[i] = b

    b = hof.best(fitness)
    if verbose:
      echo $b, '~', len(new_pop)
    new_pop.add hof

  return new_pop

var pop = rand_population(30, n_genes)
pop = evolve(pop, 50)
