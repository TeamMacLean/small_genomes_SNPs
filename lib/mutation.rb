#encoding: utf-8
# require_relative 'lib/write_it'
require_relative 'locate_mutation'
require_relative 'snp_dist'
require_relative 'reform_ratio'
require_relative 'fitness_score'
require 'csv'

class Mutation
	def self.define(hm, ht, perm_hm, perm_ht, genome_length, ratios, expected_ratios) 
		div = 100
		n = 1048576*4
		# ratios = FitnessScore::ratio(hm, ht, div, genome_length) # Calculate homozygous/heterozygous ratio and make approximate distribution
		ratios.each do |element|
			if element <= 1.0
				ratios.delete(element)
			end 
		end
		pp "this is ratios #{ratios}"
		hyp = SNPdist.hyp_snps(ratios, genome_length)

		peak =  LocateMutation.find_peak(hyp, n) # Find the peak in the approximated (hypothetical SNP) distribution
		# pp "this is the peak #{peak}" 

		causal = LocateMutation.closest_snp(peak, hm)
		# perm_hm = WriteIt.file_to_ints_array("#{perm_files}/perm_hm.txt")
		# perm_ht = WriteIt.file_to_ints_array("#{perm_files}/perm_ht.txt")
		# expected_ratios = FitnessScore::ratio(perm_hm, perm_ht, div, genome_length) # Calculate homozygous/heterozygous ratio and make approximate distribution
		expected_ratios.each do |element|
			if element <= 1.0
				expected_ratios.delete(element)
			end 
		end 
		pp "This is perm ratios #{expected_ratios}"

		# Dir.chdir(File.join(Dir.home, "small_genomes_SNPs/arabidopsis_datasets")) do
		# 	# CSV.open("ratios.csv", "ab") do |csv|
		# 	# 	csv << ["ratios", "perm_ratios"]
		# 	# end
		# 	ratios.each do |i|
		# 		CSV.open("expected_ratios.csv", "ab") do |csv|
		# 			csv << [i]
		# 		end
		# 	end
		# 	expected_ratios.each do |o|
		# 		CSV.open("expected_ratios.csv", "ab") do |csv|
		# 			csv << [o]
		# 		end
		# 	end 
		# end
		pp ratios.length


		perm_hyp = SNPdist.hyp_snps(expected_ratios, genome_length)
		pp perm_hyp

		perm_peak = LocateMutation.find_peak(perm_hyp, n)
		candidate = LocateMutation.closest_snp(perm_peak, perm_hm)

		puts "Location of causal mutation in correctly ordered genome: #{causal}"
		puts "Candidate SNP position in permutation: #{candidate}"

		normalised = (candidate - causal).abs
		
		percent = (normalised*100)/genome_length.to_f
		puts "Shift #{percent} %"

		return percent
	end
end