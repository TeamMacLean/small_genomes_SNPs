#encoding: utf-8
# require_relative 'lib/write_it'
require_relative 'locate_mutation'
require_relative 'snp_dist'
require_relative 'reform_ratio'
require_relative 'fitness_score'

class Mutation
	def self.define(hm, ht, perm_hm, perm_ht) 
		genome_length = 1000000
		div = 1000
		n = 1048576*4
		ratios = FitnessScore::ratio(hm, ht, div, genome_length) # Calculate homozygous/heterozygous ratio and make approximate distribution
		ratios.each do |element|
			if element == 0.0
				ratios.delete(element)
			end 
		end
		pp ratios
		hyp = SNPdist.hyp_snps(ratios, genome_length)
		peak =  LocateMutation.find_peak(hyp, n) # Find the peak in the approximated (hypothetical SNP) distribution
		pp "this is the peak #{peak}" 

		causal = LocateMutation.closest_snp(peak, hm)
		# perm_hm = WriteIt.file_to_ints_array("#{perm_files}/perm_hm.txt")
		# perm_ht = WriteIt.file_to_ints_array("#{perm_files}/perm_ht.txt")
		perm_ratios = FitnessScore::ratio(perm_hm, perm_ht, div, genome_length) # Calculate homozygous/heterozygous ratio and make approximate distribution
		perm_ratios.each do |element|
			if element == 0.0
				perm_ratios.delete(element)
			end 
		end 
		pp perm_ratios
		perm_hyp = SNPdist.hyp_snps(perm_ratios, genome_length)
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