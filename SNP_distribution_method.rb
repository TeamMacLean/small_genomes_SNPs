#encoding: utf-8

require_relative 'lib/reform_ratio'
require_relative 'lib/write_it'
require_relative 'lib/stuff'
require 'Bio'
require 'pp'
require 'pdist'

dataset = ARGV[0] # Name of dataset directory in 'small_genomes_SNPs/arabidopsis_datasets'
perm_files = ARGV[1]

vcf_file = "arabidopsis_datasets/#{dataset}/snps.vcf"
fasta_file = "arabidopsis_datasets/#{dataset}/frags.fasta"
fasta_shuffle = "arabidopsis_datasets/#{dataset}/frags_shuffled.fasta"

##Open the vcf file and create lists of heterozygous and homozygous SNPs
hm, ht = Stuff.snps_in_vcf(vcf_file)

##Create dictionaries with the id of the fragment as key and the NUMBER of SNP as value
dic_hm, dic_ht = Stuff.dic_snps_fasta(hm, ht)

##Open the fasta file with the randomly ordered fragments and create an array with all the info there
##From the array take only the ids and put them in a new array

ids_s = [] 
frags = []
fasta_file = File.open(fasta_shuffle)
fasta_file.each do |line|
	frags << line
end


##Open the fasta file with the randomly ordered fragments  and create an array with all the information
frags_shuffled = ReformRatio.fasta_array(fasta_shuffle)

##From the previous array take only the ids and put them in a new array
ids, lengths = ReformRatio.fasta_id_n_lengths(frags_shuffled)

##Assign the number of SNPs to each fragment in the shuffled list. 
##If a fragment does not have SNPs, the value assigned will be 0.

dic_shuf_hm, dic_shuf_ht, snps_hm, snps_ht = Stuff.define_snps(ids, dic_hm, dic_ht)

dic_shuf_hm_norm, dic_shuf_ht_norm = {}, {}

x = 0
l = snps_hm.length
Array(0..l-1).each do |i|
	snp_norm = snps_hm[x].to_f/lengths[x].to_f
	keys = dic_shuf_hm.keys
	dic_shuf_hm_norm.store(keys[x], snp_norm)
	x +=1
end 

x = 0
l2 = snps_ht.length
Array(0..l2-1).each do |i|
	snp_norm_ht = snps_ht[x].to_f/lengths[x].to_f
	keys = dic_shuf_ht.keys
	dic_shuf_ht_norm.store(keys[x], snp_norm_ht)
	x +=1
end 


##Invert the hashes to have the SNP number as the key and all the fragments with the same SNP number together as values
class Hash
  def safe_invert
    self.each_with_object( {} ) { |(key, value), out| ( out[value] ||= [] ) << key }
  end
end

dic_hm_inv = dic_shuf_hm_norm.safe_invert

dic_ht_inv = dic_shuf_ht_norm.safe_invert

##Iteration: look for the minimum value in the array of values, that will be 0 (fragments without SNPs) and put the fragments 
#with this value in a list. Then, the list is cut by half and each half is added to a new array (right, that will be used 
#to reconstruct the right side of the distribution, and left, for the left side)

pp dic_hm_inv

###########Homozygous
list1_hm = []
list2_hm = []
left_hm = []
right_hm = []

keys_hm = dic_hm_inv.keys.to_a
length_hm = keys_hm.length

Array(1..length_hm/2).each do |i|
	min1 = keys_hm.min 
	list1_hm << dic_hm_inv.values_at(min1)
	list1_hm.flatten!
	keys_hm.delete(min1)
	if list1_hm.length.to_i % 2 == 0 
		l = list1_hm.length
		d = l/2.to_i
		lu = list1_hm.each_slice(d).to_a
		right_hm << lu[0]
		left_hm << lu[1]
	else
	 	if list1_hm.length.to_i > 2
			object = list1_hm.shift
			l = list1_hm.length
			d = l/2.to_i
			lu2 = list1_hm.each_slice(d).to_a
			right_hm << lu2[0]
			left_hm << lu2[1]
			right_hm << object
		else
			right_hm << list1_hm 
		end

	end
	min2 = keys_hm.min 
	keys_hm.delete(min2)
	list2_hm << dic_hm_inv.values_at(min2)
	list2_hm.flatten!
	if list2_hm.length.to_i % 2 == 0
		l = list2_hm.length
		d = l/2.to_i
		lu = list2_hm.each_slice(d).to_a
		right_hm << lu[0]
		left_hm << lu[1]
	else 
		if list2_hm.length.to_i > 2 
			object = list2_hm.shift
			l = list2_hm.length
			d = l/2.to_i
			lu2 = list2_hm.each_slice(d).to_a
			right_hm << lu2[0]
			left_hm << lu2[1]
			left _hm << object
		else
			left_hm << list2_hm 
		end

	end
	list1_hm = []
	list2_hm = []
end
 

right_hm = right_hm.flatten

pp right_hm


left_hm = left_hm.flatten.compact
left_hm = left_hm.reverse #we need to reverse the left array to build the distribution properly

pp left_hm
puts left_hm.length 
puts right_hm.length

perm_hm = right_hm << left_hm #combine together both sides of the distribution
perm_hm.flatten!

# pp perm_hm 

puts perm_hm.length


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

##Take IDs, lenght and sequence from the shuffled fasta file and add them to the permutation array 

defs, data= [], []

frags_shuffled.each do |i|
	defs << i.definition
	data << i.data 
end 

defs_p, data_p = [], [] 

perm_hm.each do |frag|
	index_frag = ids.index(frag).to_i
	defs_p << defs[index_frag]
	data_p << data[index_frag]
end 


###Create fasta array with the information above 
fasta_perm = []
x = 0
Array(0..perm_hm.length-1).each do |i|
	fasta_perm << defs_p[x]
	fasta_perm << data_p[x]
	x += 1
end 


fasta_perm.each do |line|
	if line.start_with?("\n")
		line[0] = '' 
	else 
		line.insert(0, ">")
	end
end	

File.open("arabidopsis_datasets/#{dataset}/frags_ordered.fasta", "w+") do |f|
  fasta_perm.each { |element| f.puts(element) }
end

fasta_ordered = "arabidopsis_datasets/#{dataset}/frags_ordered.fasta"
frags_ordered = ReformRatio.fasta_array(fasta_ordered)


snp_data = ReformRatio.get_snp_data(vcf_file)

het_snps, hom_snps = ReformRatio.perm_pos(frags_ordered, snp_data)

Dir.mkdir("arabidopsis_datasets/#{dataset}/#{perm_files}")

Dir.chdir("arabidopsis_datasets/#{dataset}/#{perm_files}") do
	WriteIt::write_txt("perm_hm", hom_snps) # save the SNP distributions for the best permutation in the generation
	WriteIt::write_txt("perm_ht", het_snps)
end