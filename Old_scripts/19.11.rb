
#!/usr/bin/ruby
# encoding: utf-8

require_relative 'measure'
require 'levenshtein'


dataset = ARGV[0]
run = ARGV[1]
gen = ARGV[2]

###################Creation of original array

path = "arabidopsis_datasets/#{dataset}/frags.fasta"
correct_frags = []

File.open(path, 'r') do |f|
	size = f.readlines.size
	count = size.to_i/2
	x = 0
	Array(1..count).each do |i|
		x = x + 1
		correct_frags << "frag#{x}"
	end
end 

#################Creation of permutation array

perm = []

File.open("arabidopsis_datasets/#{dataset}/#{run}/Gen#{gen}_best_permutation.txt").each do |line|
	perm << line.split("\n")[0]
end
perm.shift



a2 = correct_frags.to_s
b2 = perm.to_s

puts "#{a}"
puts "#{b}"

x = Levenshtein.distance(a2, b2)

puts x