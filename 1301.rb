#encoding: utf-8
require 'pp'
require_relative 'lib/stuff'

fasta = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
r = []

bla = Stuff.shuffle_ends(fasta)

pp bla 

