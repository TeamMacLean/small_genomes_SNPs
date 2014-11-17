#!/usr/bin/env ruby

require 'json'
require 'PDist'

# Deviation distance metrics between correctly ordered permutation and best permutation  
# by taking out progresively the first and last element of each array to measure 
# the distance only in the middle of the permutation


class Measure

	def self.top_and_tail(original, perm)
		original.delete(perm.shift)
		original.delete(perm.pop)
		return original, perm
	end

	def self.deviation(original, perm)
		distances = []
		while perm.length > 3
			original, perm = Measure.top_and_tail(original, perm)
			distances << PDist.deviation(original, perm)
		end
		return distances
	end
	
	def self.square(original, perm)
		distances = []
		while perm.length > 3
			original, perm = Measure.top_and_tail(original, perm)
			distances << PDist.square(original, perm)
		end
		return distances
	end	

	def self.rdist(original, perm)
		distances = []
		while perm.length > 3
			original, perm = Measure.top_and_tail(original, perm)
			distances << PDist.rdist(original, perm)
		end
		return distances
	end	

	def self.LCS(original, perm)
		distances = []
		while perm.length > 3
			original, perm = Measure.top_and_tail(original, perm)
			distances << PDist.LCS(original, perm)
		end
		return distances
	end

	def self.kendalls_tau(original, perm)
		distances = []
		while perm.length > 3
			original, perm = Measure.top_and_tail(original, perm)
			distances << PDist.kendalls_tau(original, perm)
		end
		return distances
	end

	def self.hamming(original, perm)
		distances = []
		while perm.length > 3
			original, perm = Measure.top_and_tail(original, perm)
			distances << PDist.hamming(original, perm)
		end
		return distances
	end

end 