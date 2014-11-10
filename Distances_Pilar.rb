#!/usr/bin/env ruby

require 'PDist'
require_relative 'lib/model_genome'
require_relative 'lib/reform_ratio'
require 'json'
require 'csv'

dataset = ARGV[0]
run = ARGV[1]
gen = ARGV[2]

path = "/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/frags.fasta"

correct_frags = []

f = File.open(path, 'r') do |f|
	size = f.readlines.size
	count = size.to_i/2
	x = 0
	Array(1..count).each do |i|
		x = x + 1
		correct_frags << "frag#{x}"
	end
end 

master_array = []
Array(1..gen.to_i).each do |i|
	slave_array = []
	File.open("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/#{run}/Gen#{i}/best_permutation.txt").each do |line|
		slave_array << line.split("\n")[0]
	end
	slave_array.shift
	master_array << slave_array
end

# puts master_array.to_json

#####################Deviation##################

dist = []
master_array.each do |array|
	dist << PDist.deviation(correct_frags, array)
end

puts dist.length

CSV.open("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/#{run}/deviation.csv", 'ab') 
x = 0
dist.each do |element|
	if x <= gen.to_i
		x = x + 1
		CSV.open("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/#{run}/deviation.csv", "ab") do |csv|
		csv << [x, element]
	end
end
end
#############################################

#####################Square##################

dist = []
master_array.each do |array|
	dist << PDist.square(correct_frags, array)
end

puts dist.length

CSV.open("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/#{run}/square.csv", 'ab') 
x = 0
dist.each do |element|
	if x <= gen.to_i
		x = x + 1
		CSV.open("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/#{run}/square.csv", "ab") do |csv|
		csv << [x, element]
	end
end
end
#############################################

#####################Square##################

dist = []
master_array.each do |array|
	dist << PDist.hamming(correct_frags, array)
end

puts dist.length

CSV.open("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/#{run}/hamming.csv", 'ab') 
x = 0
dist.each do |element|
	if x <= gen.to_i
		x = x + 1
		CSV.open("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/#{run}/hamming.csv", "ab") do |csv|
		csv << [x, element]
	end
end
end
#############################################
#####################Square##################

dist = []
master_array.each do |array|
	dist << PDist.rdist(correct_frags, array)
end

puts dist.length

CSV.open("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/#{run}/rdist.csv", 'ab') 
x = 0
dist.each do |element|
	if x <= gen.to_i
		x = x + 1
		CSV.open("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/#{run}/rdist.csv", "ab") do |csv|
		csv << [x, element]
	end
end
end
#############################################
#####################Square##################

dist = []
master_array.each do |array|
	dist << PDist.lcs(correct_frags, array)
end

puts dist.length

CSV.open("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/#{run}/lcs.csv", 'ab') 
x = 0
dist.each do |element|
	if x <= gen.to_i
		x = x + 1
		CSV.open("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/#{run}/lcs.csv", "ab") do |csv|
		csv << [x, element]
	end
end
end
#############################################
####################Kendall's tau#################
dist = []
master_array.each do |array|
	dist << PDist.kendalls_tau(correct_frags, array)
end

puts dist.length

CSV.open("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/#{run}/kendallstau.csv", 'ab') 
x = 0
dist.each do |element|
	if x <= gen.to_i
		x = x + 1
		CSV.open("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/#{run}/kendallstau.csv", "ab") do |csv|
		csv << [x, element]
	end
end
end
###################################################

