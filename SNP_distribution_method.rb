#encoding: utf-8

require_relative 'lib/reform_ratio'
require_relative 'lib/write_it'
require_relative 'lib/stuff'
require 'Bio'
require 'pp'
require 'pdist'

dataset = ARGV[0] # Name of dataset directory in 'small_genomes_SNPs/arabidopsis_datasets'

vcf_file = "arabidopsis_datasets/#{dataset}/snps.vcf"
fasta_file = "arabidopsis_datasets/#{dataset}/frags.fasta"
fasta_shuffle = "arabidopsis_datasets/#{dataset}/frags_shuffled.fasta"

##Open the vcf file and create lists of heterozygous and homozygous SNPs
hm = []
ht = []
File.open(vcf_file, 'r').each do |line|
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
dic_shuf_ht = {}
dic_shuf_hm = {}
ids.each do |frag|
	if dic_hm.has_key?(frag)
		dic_shuf_hm.store(frag, dic_hm[frag].to_f)
	else
		dic_shuf_hm.store(frag, 0)
	end 
	if dic_ht.has_key?(frag)
		dic_shuf_ht.store(frag, dic_ht[frag].to_f)
	end 
end 

snps = []

dic_shuf_hm.each { |id, snp| snps << snp }

dic_shuf_hm_norm = {}

x = 0
l = snps.length
Array(0..l-1).each do |i|
	snp_norm = snps[x].to_f/lengths[x].to_f
	keys = dic_shuf_hm.keys
	dic_shuf_hm_norm.store(keys[x], snp_norm)
	x +=1
end 


##Invert the hashes to have the SNP number as the key and all the fragments with the same SNP number together as values
class Hash
  def safe_invert
    self.each_with_object( {} ) { |(key, value), out| ( out[value] ||= [] ) << key }
  end
end

dic_hm_inv = dic_shuf_hm_norm.safe_invert

##Iteration: look for the minimum value in the array of values, that will be 0 (fragments without SNPs) and put the fragments 
#with this value in a list. Then, the list is cut by half and each half is added to a new array (right, that will be used 
#to reconstruct the right side of the distribution, and left, for the left side)
list1 = []
list2 = []
values = []
left = []
right = []

keys = dic_hm_inv.keys.to_a
length = keys.length

Array(1..length/2).each do |i|
	min1 = keys.min 
	list1 << dic_hm_inv.values_at(min1)
	list1.flatten!
	keys.delete(min1)
	if list1.length.to_i >= 2 
		d = l/2.to_i
		lu = list1.each_slice(d).to_a
		right << lu[0]
		left << lu[1]
	else l < 2
		right << list1
	end

	min2 = keys.min 
	keys.delete(min2)
	list2 << dic_hm_inv.values_at(min2)
	list2.flatten!
	if list2.length.to_i >= 2 
		d = l/2.to_i
		lu = list2.each_slice(d).to_a
		right << lu[0]
		left << lu[1]
	else l < 2
		left << list2
	end
	list1, list2 = [], []
end


right = right.flatten

left = left.flatten.compact
left = left.reverse #we need to reverse the left array to build the distribution properly

perm = right << left #combine together both sides of the distribution
perm.flatten!


##Take IDs, lenght and sequence from the shuffled fasta file and add them to the permutation array 

defs, data= [], []

frags_shuffled.each do |i|
	defs << i.definition
	data << i.data 
end 

defs_p, data_p = [], [] 

perm.each do |frag|
	index_frag = ids.index(frag).to_i
	defs_p << defs[index_frag]
	data_p << data[index_frag]
end 


###Create fasta array with the information above 
fasta_perm = []
x = 0
Array(0..perm.length-1).each do |i|
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



