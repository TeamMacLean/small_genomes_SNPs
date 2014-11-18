#!/usr/bin/env ruby

require 'json'
require 'PDist'

# Deviation distance metrics between correctly ordered permutation and best permutation  
# by taking out progresively the first and last element of each array to measure 
# the distance only in the middle of the permutation


class Measure

	def self.distance(original, perm)
		dist = []
		# CSV.open("arabidopsis_datasets/#{dataset}/#{run}/table_distances_shorter.csv", 'ab') 
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
			puts p.to_json
			puts original.to_json	
			dist << PDist.kendalls_tau(original, p)

			i+=1
		end
		return dist

	end
end 



