#encoding: utf-8

require_relative 'lib/reform_ratio'
require_relative 'lib/write_it'
require_relative 'lib/stuff'
require_relative 'lib/SDM'
require 'Bio'
require 'pp'
require 'pdist'

dataset = ARGV[0] # Name of dataset directory in 'small_genomes_SNPs/arabidopsis_datasets'
perm_files = ARGV[1]

######Files
vcf_file = "arabidopsis_datasets/#{dataset}/snps.vcf"
fasta_file = "arabidopsis_datasets/#{dataset}/frags.fasta"
fasta_shuffle = "arabidopsis_datasets/#{dataset}/frags_shuffled.fasta"
############

##Open the vcf file and create lists of heterozygous and homozygous SNPs
hm, ht = Stuff.snps_in_vcf(vcf_file)

##Create dictionaries with the id of the fragment as key and the NUMBER of SNP as value
dic_hm, dic_ht = Stuff.dic_snps_fasta(hm, ht)

##Open the fasta file with the randomly ordered fragments and create an array with all the info there
##From the array take only the ids and put them in a new array
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

dic_hm_inv, dic_ht_inv = Stuff.normalise_by_length(dic_shuf_hm, dic_shuf_ht, snps_hm, snps_ht)

##Iteration: look for the minimum value in the array of values, that will be 0 (fragments without SNPs) and put the fragments 
#with this value in a list. Then, the list is cut by half and each half is added to a new array (right, that will be used 
#to reconstruct the right side of the distribution, and left, for the left side)
perm_hm = SDM.sorting(dic_hm_inv)

##Take IDs, lenght and sequence from the shuffled fasta file and add them to the permutation array 

fasta_perm = Stuff.create_perm_fasta(perm_hm, frags_shuffled)

##Create new fasta file with the ordered elements
File.open("arabidopsis_datasets/#{dataset}/frags_ordered.fasta", "w+") do |f|
  fasta_perm.each { |element| f.puts(element) }
end

fasta_ordered = "arabidopsis_datasets/#{dataset}/frags_ordered.fasta"
frags_ordered = ReformRatio.fasta_array(fasta_ordered)

#Create .txt files with the lists of SNP positions in the new file.

snp_data = ReformRatio.get_snp_data(vcf_file)

het_snps, hom_snps = ReformRatio.perm_pos(frags_ordered, snp_data)

Dir.mkdir("arabidopsis_datasets/#{dataset}/#{perm_files}")

Dir.chdir("arabidopsis_datasets/#{dataset}/#{perm_files}") do
	WriteIt::write_txt("perm_hm", hom_snps) # save the SNP distributions for the best permutation in the generation
	WriteIt::write_txt("perm_ht", het_snps)
end