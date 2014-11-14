#!/usr/bin/env ruby

require_relative 'Make_them_shorter'

original =  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
perm = [9, 3, 8, 4, 5, 6, 7, 1, 2, 10]

Measure::distance(original, perm)

