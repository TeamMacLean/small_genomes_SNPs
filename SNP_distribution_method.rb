#encoding: utf-8

require_relative 'lib/reform_ratio'
require_relative 'lib/write_it'
require_relative 'lib/stuff'
require 'Bio'
require 'pp'
require 'pdist'

##Open the vcf file and create lists of heterozygous and homozygous SNPs
path = "/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/dataset_small2kb/snps.vcf"
hm = []
ht = []
File.open(path, 'r').each do |line|
	next if line =~ /^#/
	v = Bio::DB::Vcf.new(line)
	a = line.split("\t")
	first =  a.first
	last = a.last
	if last == "AF=0.5\n"
		ht << first
	elsif last == "AF=1.0\n"
		hm << first
	end
end


##Create dictionaries with the id of the fragment as key and the NUMBER of SNP as value

dic_hm = {}
dic_ht = {}

hm.uniq.each do |elem|
	dic_hm.store("#{elem}", "#{hm.count(elem).to_i}" )
end

ht.uniq.each do |elem|
	dic_ht.store("#{elem}", "#{ht.count(elem).to_i}" )
end


##Open the fasta file with the randomly ordered fragments and create an array with all the info there
##From the array take only the ids and put them in a new array
path = "/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/dataset_small2kb/frags_shuffled.fasta"

ids_s = [] 
frags = []
fasta_file = File.open(path)
fasta_file.each do |line|
	frags << line
end
frags.each do |line|
	line = line.split(" ")
	id_only = line[0]
	if id_only.start_with?(">")
		ids_s << id_only
	end
end

# pp ids_s
# ids_s = Stuff.take_ids_from_fasta(path)

##Open the fasta file with the randomly ordered fragments  and create an array with all the information
fasta_file_shuffle = File.open("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/dataset_small2kb/frags_shuffled.fasta")
# fasta_file = File.open("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/dataset_small2kb/frags.fasta")
frags_shuffled = ReformRatio.fasta_array(fasta_file_shuffle)
# frags = ReformRatio.fasta_array(fasta_file)

##From the previous array take only the ids and put them in a new array

ids = [] 
frags_shuffled.each do |i|
	ids << i.entry_id
end

dic_shuf_ht = {}
dic_shuf_hm = {}

##Assign the number of SNPs to each fragment in the shuffled list. 
##If a fragment does not have SNPs, the value assigned will be 0.

ids.each do |frag|
	if dic_hm.has_key?(frag)
		dic_shuf_hm.store(frag, dic_hm[frag].to_i)
	else
		dic_shuf_hm.store(frag, 0)
	end 
	if dic_ht.has_key?(frag)
		dic_shuf_ht.store(frag, dic_ht[frag].to_i)
	end 
end 


##Invert the hashes to have the SNP number as the key and all the fragments with the same SNP number together as values
class Hash
  def safe_invert
    self.each_with_object( {} ) { |(key, value), out| ( out[value] ||= [] ) << key }
  end
end

dic_hm_inv = dic_shuf_hm.safe_invert


left = []
right = []

##Create an array with all the SNP numbers
keys = dic_hm_inv.keys.to_a
length = keys.length
l = (length/2).to_i

##If we have an even number of SNP density values, the iteration will run for length times
##If we have an odd number of SNP density values, the iteration will run for length-1 times
##Iteration: look for the minimum value in the array of values, that will be 0 (fragments without SNPs) and put the fragments 
#with this value in a list. Then, the list is cut by half and each half is added to a new array (right, that will be used 
#to reconstruct the right side of the distribution, and left, for the left side)
list = []
new_list = []
values = []
if l % 2 == 0
	Array(0..l).each do |i|
		min1 = keys.min 
		list << dic_hm_inv.values_at(min1)
		list.flatten!
		l = list.length.to_i
		d = l/2.to_i
		l = list.each_slice(d).to_a
		right << l[0]
		left << l[1]
		keys.delete(min1)
		list = new_list
	end
else
	Array(0..l-1).each do |i|
		min1 = keys.min 
		list << dic_hm_inv.values_at(min1)
		list.flatten!
		l = list.length.to_i
		d = l/2.to_i
		l = list.each_slice(d).to_a
		right << l[0]
		left << l[1]
		keys.delete(min1)
		list = new_list
	end
end

right = right.flatten
left = left.flatten
left = left.reverse #we need to reverse the left array to build the distribution properly

# puts right


perm = right << left #combine together both sides of the distribution
perm.flatten!

pp perm 
pp ids

lala =  frags.each_slice(2).to_a

# pp lala 

perm.each do |x|
	# ind = perm.index(elem).to_i
	ind = perm.each_index.select{|i| perm[i] == x}
	puts ind
	# ind_s = ids.index(elem).to_i
	ind_s = ids.each_index.select{|i| ids[i] == x}
	puts ind_s
	lala.each do |array|
		lala.insert(ind, array)
		lala.delete_at(ind_s)
	end
end



# pp lala 

# frags
	# if perm.include


# perm.each do |frag|
# 	lala.each do |array|
# 		if array.include?(frag)
# 			ind = perm.index(frag).to_i
# 			ind_s = lala.index(array).to_i
# 			lala.insert(ind, array)
# 			lala.delete_at(ind_s)
# 		end
# 	end 
# end
# 	end
# end


# pp "this is perm #{perm}"


# # snp_data = ReformRatio::get_snp_data(vcf)
# pp snp_data
# ht, hm = ReformRatio.perm_pos(perm, snp_data)
# pp ht
# pp hm 
# distance = PDist.deviation(ids, perm)

# density_order, density_perm =[], []
# density_order << dic_hm.values
# density_perm << perm_dic.values


##Compare two halfs of the ordered genome with the unordered one. 


# pp dichm2
# pp "right is #{right}"
# # pp "right is #{right}"
# pp "left is #{left}"
# puts l.length
# puts r.length

# puts values 

