#!/usr/bin/env ruby

require 'json'
require 'PDist'

# Deviation distance metrics between correctly ordered permutation and best permutation  
# by taking out progresively the first and last element of each array to measure 
# the distance only in the middle of the permutation


class Measure

	def self.distance(original, perm)
		distances = []
		# square = []
		# deviation = []
		# lcs = []
		# rdist = []
		# kendalls = []
		# hamming = []
		
		length = original.length
		i = 1
		x = 0
		while i < length/2 do
			left = i
			right = (length-1) - i
			p = perm[left..right]
			perm.each do |a|
				unless p.include?(a)
					original.delete(a)
				end
			end
			# puts p.to_json
			# puts original.to_json	
			distances << PDist.square(original, p)
			# distances << deviation << PDist.deviation(original, p)
			# distances << lcs << PDist.lcs(original, p)
			# distances << rdist << PDist.rdist(original, p)
			# distances << kendalls << PDist.kendalls_tau(original, p)
			# distances << hamming << PDist.hamming(original, p)
			i+=1
		end
		return distances
		# puts "square is #{square}"
		# puts "deviation is #{deviation}"
		# puts "lcs is #{lcs}"
		# puts "rdist is #{rdist}"
		# puts "kendalls is #{kendalls}"
		# puts "hamming is #{hamming}"
	end
end 



