#!/usr/bin/env ruby

require 'PDist'
require_relative 'lib/model_genome'
require_relative 'lib/reform_ratio'
require 'json'
require 'csv'

dataset = ARGV[0]
run = ARGV[1]
gen = ARGV[2]

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

perm = []

File.open("arabidopsis_datasets/#{dataset}/#{run}/Gen#{gen}/best_permutation.txt").each do |line|
	perm << line.split("\n")[0]
end
perm.shift

# puts perm.to_json


length = correct_frags.length

master_perm	= []
master_x = []
dist = []
while length > 2 
	correct_frags = correct_frags[1..-2]
	perm = perm[1..-2]
	dist << PDist.deviation(correct_frags, perm)
	master_perm << perm
	master_x << correct_frags
	length = correct_frags.length
end

CSV.open("arabidopsis_datasets/#{dataset}/#{run}/table_distances_shorter.csv", 'ab') 
x = 0
dist.each do |element|
	if x <= gen.to_i
		x = x + 1
		CSV.open("arabidopsis_datasets/#{dataset}/#{run}/table_distances_shorter.csv", "ab") do |csv|
		csv << [x, element]
	end
end
end