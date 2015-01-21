#encoding: utf-8
require_relative 'lib/write_it'
require_relative 'lib/locate_mutation'
require_relative 'lib/snp_dist'
require_relative 'lib/reform_ratio'
require_relative 'lib/fitness_score'
require 'csv'

dataset = ARGV[0]
perm_files = ARGV[1]

n = 1048576*4

genome_length = ReformRatio::genome_length("arabidopsis_datasets/#{dataset}/frags.fasta")
div = 10000

fasta_file = "arabidopsis_datasets/#{dataset}/frags.fasta"
fasta = ReformRatio::fasta_array(fasta_file)
contigs = fasta.length.to_i

Dir.chdir(File.join(Dir.home, "small_genomes_SNPs/arabidopsis_datasets/#{dataset}")) do
	
	hm = WriteIt.file_to_ints_array("hm_snps.txt") # Get SNP distributions
	ht = WriteIt.file_to_ints_array("ht_snps.txt")

	ratios = FitnessScore::ratio(hm, ht, div, genome_length) # Calculate homozygous/heterozygous ratio and make approximate distribution
	hyp = SNPdist.hyp_snps(ratios, genome_length)

	peak =  LocateMutation.find_peak(hyp, n) # Find the peak in the approximated (hypothetical SNP) distribution
	causal = LocateMutation.closest_snp(peak, hm)

	perm_hm = WriteIt.file_to_ints_array("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/#{perm_files}/perm_hm.txt")
	perm_ht = WriteIt.file_to_ints_array("/Users/morenop/small_genomes_SNPs/arabidopsis_datasets/#{dataset}/#{perm_files}/perm_ht.txt")

	perm_ratios = FitnessScore::ratio(perm_hm, perm_ht, div, genome_length) # Calculate homozygous/heterozygous ratio and make approximate distribution
	perm_hyp = SNPdist.hyp_snps(perm_ratios, genome_length)

	perm_peak = LocateMutation.find_peak(perm_hyp, n)
	candidate = LocateMutation.closest_snp(perm_peak, perm_hm)

	puts "Location of causal mutation in correctly ordered genome: #{causal}"
	puts "Candidate SNP position in permutation: #{candidate}"

	if candidate > causal 
		normalised = candidate - causal
	else
		normalised = causal - candidate
	end
	
	percent = (normalised*100)/genome_length.to_f

	puts "Shift #{percent} %"

	Dir.chdir(File.join(Dir.home, "small_genomes_SNPs/arabidopsis_datasets")) do
		CSV.open("mutation.csv", "ab") do |csv|
			csv << ["#{genome_length}", "#{contigs}", "#{causal}", "#{candidate}", "#{percent}"]
		end

	end 
end 
