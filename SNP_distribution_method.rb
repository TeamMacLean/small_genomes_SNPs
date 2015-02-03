#encoding: utf-8

require_relative 'lib/reform_ratio'
require_relative 'lib/write_it'
require_relative 'lib/stuff'
require_relative 'lib/mutation'
require_relative 'lib/SDM'

require 'Bio'
require 'pp'
require 'csv'
require 'benchmark'

dataset = ARGV[0] # Name of dataset directory in 'small_genomes_SNPs/arabidopsis_datasets'
perm_files = ARGV[1]
# frags_ordered = ARGV[2]
# i = ARGV[2].to_i 

######Files
vcf_file = "arabidopsis_datasets/#{dataset}/snps.vcf"
fasta_file = "arabidopsis_datasets/#{dataset}/frags.fasta"
fasta_shuffle = "arabidopsis_datasets/#{dataset}/frags_shuffled.fasta"
############

##Lists of SNPs
hm, ht = Stuff.snps_in_vcf(vcf_file)

##Create dictionaries with the id of the fragment as key and the NUMBER of SNP as value
dic_hm, dic_ht = Stuff.create_hash_snps(hm, ht)

##Open the fasta file with the randomly ordered fragments  and create an array with all the information
frags_shuffled = ReformRatio.fasta_array(fasta_shuffle)
frags = ReformRatio.fasta_array(fasta_file)

##From the previous array take ids and lengths and put them in 2 new arrays
ids_ok, lengths_ok = ReformRatio.fasta_id_n_lengths(frags)
ids, lengths = ReformRatio.fasta_id_n_lengths(frags_shuffled)

ok_hm, ok_ht, snps_hm, snps_ht = Stuff.define_snps(ids_ok, dic_hm, dic_ht)
hm, ht, snps_hm_sh, snps_ht_sh = Stuff.define_snps(ids, dic_hm, dic_ht)
# ok_hm.each { |id, snp| }
# 	shuf_hm.each { |id, snp| snps_hm << snp }


x = 0
dic_ratios = {}
ratios = []
snps_hm.length.times do
	ratio = (snps_hm[x]+1)/(snps_ht[x]+1)
	dic_ratios.store(ids_ok[x], ratio.to_f)
	ratios << ratio 
	x = x + 1
end
dic_ratios.delete_if { |id, ratio|  ratio <= 1  }
# pp expected_ratios
# pp ratios 


		



# ratios.each do |element|
# 	if element <= 1.0
# 		ratios.delete(element)
# 	end 
# end
# expected_ratios.each do |element|
# 	if element <= 1.0
# 		expected_ratios.delete(element)
# 	end 
# end 

genome_length = ReformRatio.genome_length(fasta_file) 
##Assign the number of SNPs to each fragment in the shuffled list. 
##If a fragment does not have SNPs, the value assigned will be 0.

dic_shuf_hm_norm, dic_shuf_ht_norm = Stuff.normalise_by_length(ids, dic_hm, dic_ht, lengths)
dic_hm_norm, dic_ht_norm = Stuff.normalise_by_length(ids_ok, dic_hm, dic_ht, lengths)

# dic_shuf_hm_norm.delete_if {|key, value| value = 0.0 } 

class Hash
  def safe_invert
    self.each_with_object( {} ) { |(key, value), out| ( out[value] ||= [] ) << key }
  end
end

dic_hm_inv = dic_shuf_hm_norm.safe_invert


# dic_hm_inv.delete_if {|key, value| key <= 0.0 } 


##Iteration: look for the minimum value in the array of values, that will be 0 (fragments without SNPs) and put the fragments 
#with this value in a list. Then, the list is cut by half and each half is added to a new array (right, that will be used 
#to reconstruct the right side of the distribution, and left, for the left side)
perm_hm = SDM.sorting(dic_hm_inv)
# measure = Measure.distance(ids, perm_hm)

# dic_norm_hm_2, new_dic_norm_2 = Stuff.normalise_by_length(perm_hm, dic_hm, dic_ht, lengths)
# dic_norm_hm_inv_2 = dic_norm_hm_2.safe_invert
# perm_hm_2 = SDM.sorting(dic_norm_hm_inv_2)
	
# dic_norm_hm_3, dic_norm_ht_3 = Stuff.normalise_by_length(perm_hm, dic_hm, dic_ht, lengths)
# dic_norm_hm_inv_3 = dic_norm_hm_3.safe_invert
# perm_hm_3 = SDM.sorting(dic_norm_hm_inv_3)



dic_or_hm, dic_or_ht, snps_hm_or, snps_ht_or = Stuff.define_snps(perm_hm, dic_hm, dic_ht)

# pp snps_ht_or
# pp snps_hm_or

x = 0
dic_expected_ratios = {}
expected_ratios = []
snps_hm_or.length.times do
	expected_ratio = (snps_hm_or[x]+1)/(snps_ht_or[x]+1)
	expected_ratios << expected_ratio
	dic_expected_ratios.store(perm_hm[x], expected_ratio.to_f)
	x = x + 1
end


dic_expected_ratios.delete_if { |id, ratio|  ratio <= 1  } #revise this, maybe 1 is to restrictive, just to try for now 

short_ok = []
short_sh = []

short_sh = dic_expected_ratios.keys
short_ok = dic_ratios.keys


pp short_sh
# pp perm_hm 
# pp perm_hm_2
# pp perm_hm_3

# dic_hm_norm_or, dic_ht_norm_or = Stuff.normalise_by_length(perm_hm, dic_hm, dic_ht, lengths)

# pp dic_hm_norm_or

##Take IDs, lenght and sequence from the shuffled fasta file and add them to the permutation array 

fasta_perm = Stuff.create_perm_fasta(short_sh, frags_shuffled, ids)
fasta_ok = Stuff.create_perm_fasta(short_ok, frags, ids_ok)

##Create new fasta file with the ordered elements
File.open("arabidopsis_datasets/#{dataset}/frags_ordered.fasta", "w+") do |f|
  fasta_perm.each { |element| f.puts(element) }
end

fasta_ordered = "arabidopsis_datasets/#{dataset}/frags_ordered.fasta"
frags_ordered = ReformRatio.fasta_array(fasta_ordered)

#Create .txt files with the lists of SNP positions in the new file.

snp_data = ReformRatio.get_snp_data(vcf_file)

het_snps, hom_snps = ReformRatio.perm_pos(frags_ordered, snp_data)

contig_size = (genome_length/perm_hm.length).to_f
center = contig_size*(short_sh.length)

puts center

Dir.chdir(File.join(Dir.home, "small_genomes_SNPs/arabidopsis_datasets/#{dataset}")) do
	hm_list = WriteIt.file_to_ints_array("hm_snps.txt") # Get SNP distributions
	ht_list = WriteIt.file_to_ints_array("ht_snps.txt")
	mutation = Mutation.define(hm_list, ht_list, hom_snps, het_snps, center, ratios, expected_ratios) 
end 

Dir.mkdir("arabidopsis_datasets/#{dataset}/#{perm_files}")

Dir.chdir("arabidopsis_datasets/#{dataset}/#{perm_files}") do
	WriteIt::write_txt("perm_hm", hom_snps) # save the SNP distributions for the best permutation in the generation
	WriteIt::write_txt("perm_ht", het_snps)
end

 Benchmark.bm do |b|
    b.report {10.times do ; perm_hm = SDM.sorting(dic_hm_inv);  end}
    # b.report {10.times do ; mutation = Mutation.define(hm_list, ht_list, hom_snps, het_snps, genome_length);  end}
end


