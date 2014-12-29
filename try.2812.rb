#encoding: utf-8

perm = [1, 2, 4, 5, 6, 7, 8]
ids = [1, 2, 4, 8, 5, 7, 6]
defs = [1, 2, 4, 8, 5, 7, 6]

ind = []

defs2 = []

perm.each do |frag|
	indp =  perm.index(frag).to_i
	indi = ids.index(frag).to_i
	defs2 << defs[indi]
	# defs2 << defs[indp]

	# defs = defs.collect! { |e| defs[indp] : e }
end 


# ind = ind.each_slice(2).to_a

# defs.each do |elem|
# 	ind.each do |i|
# 		defs[i[1]]
# 		defs.delete_at(i[1])
# 	end
# end



puts defs2 