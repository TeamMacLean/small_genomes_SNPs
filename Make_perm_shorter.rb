#!/usr/bin/env ruby

require_relative 'measure'
require 'json'
require 'csv'

dataset = ARGV[0]
run = ARGV[1]
gen = ARGV[2]
method = ARGV[3]
name = ARGV[4]


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

puts "Oh, master, original permutation created"

#################Creation of permutation array

perm = []

File.open("arabidopsis_datasets/#{dataset}/#{run}/Gen#{gen}_best_permutation.txt").each do |line|
	perm << line.split("\n")[0]
end
perm.shift

puts "Perm array created, master"

################Measure of the distance depeding on the metrics selected 

if method == 'square'
	dist = Measure::square(correct_frags, perm)
end

if method == 'deviation'
	dist = Measure::deviation(correct_frags, perm)
end

if method == 'LCS'
	dist = Measure::LCS(correct_frags, perm)
end

if method == 'hamming'
	dist = Measure::hamming(correct_frags, perm)
end

if method == 'rdist'
	dist = Measure::rdist(correct_frags, perm)
end

if method == 'kendalls_tau'
	puts "Yeah, Im using the kendalls_tau, master"
	dist = Measure::kendalls_tau(correct_frags, perm)
end

#################Put distances in a CSV file

x = 0
dist.each do |element|
	CSV.open("arabidopsis_datasets/#{dataset}/#{run}/#{name}.csv", "ab") do |csv|
		x += 1
		csv << [x, element]
	end
end

puts "YEAH"