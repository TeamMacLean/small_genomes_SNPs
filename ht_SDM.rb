###########Heterozygous

# list1_ht = []
# list2_ht = []
# values_ht = []
# left_ht = []
# right_ht = []

# keys_ht = dic_ht_inv.keys.to_a
# length_ht = keys_ht.length

# Array(1..length_ht/2).each do |i|
# 	min1 = keys_ht.min 
# 	list1_ht << dic_ht_inv.values_at(min1)
# 	list1_ht.flatten!
# 	keys_ht.delete(min1)
# 	if list1_ht.length.to_i % 2 == 0 
# 		l = list1_ht.length
# 		d = l/2.to_i
# 		lu = list1_ht.each_slice(d).to_a
# 		right_ht << lu[0]
# 		left_ht << lu[1]
# 	else 
# 		right_ht << list1_ht
# 	end
# 	min2 = keys_ht.min 
# 	keys_ht.delete(min2)
# 	list2_ht << dic_ht_inv.values_at(min2)
# 	list2_ht.flatten!
# 	if list2_ht.length.to_i % 2 == 0
# 		l = list2_ht.length
# 		d = l/2.to_i
# 		lu = list2_ht.each_slice(d).to_a
# 		right_ht << lu[0]
# 		left_ht << lu[1]
# 	else 
# 		left_ht << list2_ht
# 	end
# 	list1_ht, list2_ht = [], []
# end


# right_ht = right_ht.flatten

# pp "This is r #{right_ht}"

# left_ht = left_ht.flatten.compact
# left_ht = left_ht.reverse #we need to reverse the left array to build the distribution properly

# pp "This is l #{left_ht}"

# perm_ht = right_ht << left_ht #combine together both sides of the distribution
# perm_ht.flatten!

# pp perm_ht

# l = perm.length/10.to_i
# q = l - 1

# master = perm.each_slice(l).to_a

# new_array = []
# x = 0

# q.times do
# 	puts master[x]
# 	puts master[-(x+1)]
# 	new_array = (master[x] << master[-(x+1)]).flatten!.shuffle 
# 	new_array2 = (master[x] << master[-(x+)]).flatten!.shuffle 
# 	ln = new_array.length/2
# 	lu = new_array.each_slice(ln).to_a
# 	ln = new_array.length/2
# 	lu = new_array.each_slice(ln).to_a
# 	master.delete_at(x)
# 	master.insert(x, lu[0])
# 	master.delete_at(-(x+1))
# 	master.insert(-(x+1), lu[1])
# 	new_array = []
# 	lu = []
# 	x =+ 1
# end


# pp "this is master final #{master.flatten}"