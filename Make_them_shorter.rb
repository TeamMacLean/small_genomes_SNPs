#!/usr/bin/env ruby


# Deviation distance metrics between correctly ordered permutation and best permutation  
# by taking out progresively the first and last element of each array to measure 
# the distance only in the middle of the permutation


class Measure

	def self.distance(original, perm)

		dist = []
		length = original.length
		i = 1
		while i < length/2 do
			left = i
			right = (length-1) - i
			o = original[left..right]
			p = perm[left..right]
			# puts "This is the original perm:" 
			# puts "This is the permutation:" 
			i+=1
			indices = []
			indices_o = []
			o.each do |i|
				if p.include?(i) then
					indices_o << p.index(i) # indices of original values in permutation
				else 
					indices_o << 0
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
			# puts "Addition is #{suma}"
			s = suma
			n = p.length
			if n % 2 == 0 
				distance = (2.0 / (n ** 2).to_f) * s
			else
				distance = (2.0 / ((n ** 2) - 1).to_f) * s
			end
			dist << distance  
			return dist # if/else block normalizes the deviation distance
		end
	end
end 


# puts dist 
# dist = PDist.square(x, perm)
# puts "This is the first distance #{dist}" 

# master_perm.to_json
# puts master_x.to_json


