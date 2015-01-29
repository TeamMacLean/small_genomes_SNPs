#encoding: utf-8

require_relative 'lib/reform_ratio'
require_relative 'lib/write_it'
require_relative 'lib/stuff'
require_relative 'lib/mutation'
require_relative 'lib/SDM'

require 'Bio'
require 'pp'
require 'pdist'
require 'csv'

dataset = ARGV[0] # Name of dataset directory in 'small_genomes_SNPs/arabidopsis_datasets'
perm_files = ARGV[1]
# frags_ordered = ARGV[2]
i = ARGV[2].to_i 

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

##From the previous array take ids and lengths and put them in 2 new arrays
ids, lengths = ReformRatio.fasta_id_n_lengths(frags_shuffled)
genome_length = ReformRatio.genome_length(fasta_file).to_i 


##Assign the number of SNPs to each fragment in the shuffled list. 
##If a fragment does not have SNPs, the value assigned will be 0.

dic_shuf_hm, dic_shuf_ht, snps_hm, snps_ht = Stuff.define_snps(ids, dic_hm, dic_ht)

dic_shuf_hm_norm, dic_shuf_ht_norm = Stuff.normalise_by_length(dic_shuf_hm, dic_shuf_ht, snps_hm, snps_ht, lengths)

class Hash
  def safe_invert
    self.each_with_object( {} ) { |(key, value), out| ( out[value] ||= [] ) << key }
  end
end

dic_hm_inv = dic_shuf_hm_norm.safe_invert

dic_ht_inv = dic_shuf_ht_norm.safe_invert

# pp dic_hm_inv

##Iteration: look for the minimum value in the array of values, that will be 0 (fragments without SNPs) and put the fragments 
#with this value in a list. Then, the list is cut by half and each half is added to a new array (right, that will be used 
#to reconstruct the right side of the distribution, and left, for the left side)
perm_hm = SDM.sorting(dic_hm_inv)
# measure = Measure.distance(ids, perm_hm)
# puts measure 

##Take IDs, lenght and sequence from the shuffled fasta file and add them to the permutation array 

fasta_perm = Stuff.create_perm_fasta(perm_hm, frags_shuffled, ids)

##Create new fasta file with the ordered elements
File.open("arabidopsis_datasets/#{dataset}/frags_ordered.fasta", "w+") do |f|
  fasta_perm.each { |element| f.puts(element) }
end

fasta_ordered = "arabidopsis_datasets/#{dataset}/frags_ordered.fasta"
frags_ordered = ReformRatio.fasta_array(fasta_ordered)

#Create .txt files with the lists of SNP positions in the new file.

snp_data = ReformRatio.get_snp_data(vcf_file)

het_snps, hom_snps = ReformRatio.perm_pos(frags_ordered, snp_data)

# puts hm
# puts ht
# puts hom_snps
# puts het_snps

Dir.chdir(File.join(Dir.home, "small_genomes_SNPs/arabidopsis_datasets/#{dataset}")) do
	hm_list = WriteIt.file_to_ints_array("hm_snps.txt") # Get SNP distributions
	ht_list = WriteIt.file_to_ints_array("ht_snps.txt")
	mutation = Mutation.define(hm_list, ht_list, hom_snps, het_snps) 
	if mutation > 1
		i.times do 
			perm, original =  Stuff.top_and_tail(ids, fasta_perm)
			het_snps, hom_snps = ReformRatio.perm_pos(frags_ordered, snp_data)
			mutation = Mutation.define(hm_list, ht_list, hom_snps, het_snps) 
			CSV.open("top_and_tail.csv", "ab") do |csv|
				csv << [i, mutation]
			end
		end
	end

end 


Dir.mkdir("arabidopsis_datasets/#{dataset}/#{perm_files}")

Dir.chdir("arabidopsis_datasets/#{dataset}/#{perm_files}") do
	WriteIt::write_txt("perm_hm", hom_snps) # save the SNP distributions for the best permutation in the generation
	WriteIt::write_txt("perm_ht", het_snps)
end