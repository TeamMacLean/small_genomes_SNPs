#!/usr/bin/env ruby

require 'json'
require_relative 'lib/pdist'
# Distance metrics between correctly ordered permutation and the last best permutation of the run 
# by taking out the first and last element of each array to compare the measure 
# the distance in the middle of the permutation

original =  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
perm = [9, 3, 8, 4, 5, 6, 7, 1, 2, 10]

# dist = PDist.square(original, perm)
# puts "This is the first distance #{dist}" 



# puts length

# puts x[1..-2]
dist = []
length = original.length


i = 1
while i < length/2 do
	left = i
	right = (length-1) - i
	o = original[left..right]
	p = perm[left..right]
	# puts "This is the original perm:" 
	# puts o.to_json
	# puts "This is the permutation:" 
	# puts p.to_json
	i+=1
	############################
	############################
	indices = []
	indices_o = []
	o.each do |i|
		if p.include?(i) then
			indices_o << p.index(i) # indices of original values in permutation
		else 
			indices_o << length
		end
	end
	indices << indices_o
	indices << Array(0..(o.length - 1))
	# puts "#{indices}"
	difference = indices.transpose.map {|x| x.reduce(:-)}
	# puts "The difference is #{difference}"
	absolute = difference.map! {|i| i.abs } # the deviation's, as absolute values (direction does not matter)
	# puts "The absolute difference is #{difference}"
	suma = absolute.inject(:+)
	puts "Addition is #{suma}"
	s = suma
	n = p.length
	if n % 2 == 0 
		distance = (2.0 / (n ** 2).to_f) * s
	else
		distance = (2.0 / ((n ** 2) - 1).to_f) * s
	end
	puts "The normalized distance is #{distance}" # if/else block normalizes the deviation distance
	############################
	############################
end 


# puts dist 
# dist = PDist.square(x, perm)
# puts "This is the first distance #{dist}" 

# master_perm.to_json
# puts master_x.to_json


