#!/usr/bin/env ruby

require 'json'
require 'PDist'
# Distance metrics between correctly ordered permutation and the last best permutation of the run 
# by taking out the first and last element of each array to compare the measure 
# the distance in the middle of the permutation

x =  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
perm = [10, 2, 3, 9, 5, 8, 7, 6, 4, 1]

dist = PDist.square(x, perm)
puts "This is the first distance #{dist}" 

length = x.length

# puts length

# puts x[1..-2]

master_perm	= []
master_x = []
dist = []
while length > 2 
	x = x[1..-2]
	perm = perm[1..-2]
	dist << PDist.lcs(x, perm)
	master_perm << perm
	master_x << x
	length = x.length
end

puts dist


# dist = []
# master_x.each do |array|
# 	master_perm.each do |perm|
# 		dist << PDist.lcs(array, perm)
# 	end
# end

# puts dist 
# dist = PDist.square(x, perm)
# puts "This is the first distance #{dist}" 

master_perm.to_json
puts master_x.to_json


