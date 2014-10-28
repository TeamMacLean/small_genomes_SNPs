#!/usr/bin/env ruby

# puts "Name of the input dataset: "
# dataset = gets.chomp

# puts "Name of the subdirectory: "
# subdir = gets.chomp

# puts "Number of generations: "
# gen = gets.chomp.to_i

dataset = ARGV[0]
subdir = ARGV[1]
gen = ARGV[2]
name = ARGV[3]

require 'csv'
require 'rinruby'


CSV.open("#{name}.csv", "wb") do |csv|
	csv << ["Generation", "Best fitness score"]
end

x = 0

Array(1..gen.to_i).each do |i|
	x = x + 1
	f = File.open("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/#{subdir}/Gen#{i}/best_permutation.txt") 
		f.pos = 0
		q = f.gets
		CSV.open("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/#{subdir}/#{name}.csv", "ab") do |csv|
		csv << [x, q]
	end
end

puts "CSV file generated! Check for #{name}.csv"
 


