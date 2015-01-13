#encoding: utf-8
require 'pp'
require_relative 'lib/stuff'

fasta = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
r = []

# class Mu
# 	def self.shuffle_ends(fasta)
# 		l = fasta.length/6
# 		l = l.to_i 
# 		master = fasta.each_slice(l).to_a
# 		new_array = []
# 		x = 0
# 		l.times do
# 			new_array = (master[x] << master[-(x+1)]).flatten!.shuffle 
# 			lu = new_array.each_slice(2).to_a
# 			master.delete_at(x)
# 			master.insert(x, lu[0])
# 			master.delete_at(-(x+1))
# 			master.insert(-(x+1), lu[1])
# 			new_array = []
# 			lu = []
# 			x =+ 1
# 		end
# 		return master 
# 	end
# end

bla = Stuff.shuffle_ends(fasta)

pp bla 

# right.length/3
# # left.length/3
# pp "this is new #{new_array}"
# pp "this is l #{left}"

# l = fasta.length/6
# l = l.to_i 
# master = fasta.each_slice(l).to_a
# new_array = []
# x = 0
# l.times do
# 	new_array = (master[x] << master[-(x+1)]).flatten!.shuffle 
# 	lu = new_array.each_slice(2).to_a
# 	master.delete_at(x)
# 	master.insert(x, lu[0])
# 	master.delete_at(-(x+1))
# 	master.insert(-(x+1), lu[1])
# 	new_array = []
# 	lu = []
# 	x =+ 1
# end

# pp master