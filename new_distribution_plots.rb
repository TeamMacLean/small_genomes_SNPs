#encoding: utf-8
require_relative 'lib/reform_ratio'
require_relative 'lib/write_it'
require_relative 'lib/snp_dist'
require_relative 'lib/fitness_score'

dataset = ARGV[0]

div = 1

genome_length = ReformRatio::genome_length("arabidopsis_datasets/#{dataset}/frags.fasta")

hm, ht, hyp, ylim_hm, ylim_ht, ylim_hyp = [],[],[],[],[],[]

Dir.chdir(File.join(Dir.home, "small_genomes_SNPs/arabidopsis_datasets/#{dataset}")) do
	
	hom_snps = WriteIt.file_to_ints_array("hm_snps.txt")
	hm << hom_snps
	ylim_hm << SNPdist.get_ylim(hom_snps, genome_length, 'density')

	het_snps = WriteIt.file_to_ints_array("ht_snps.txt")
	ht << het_snps
	ylim_ht << SNPdist.get_ylim(het_snps, genome_length, 'density')

	expected_ratio = FitnessScore::ratio(hom_snps, het_snps, div, genome_length)
	hyp_snps = SNPdist.hyp_snps(expected_ratio, genome_length)
	hyp << hyp_snps
	ylim_hyp << SNPdist.get_ylim(hyp_snps, genome_length, 'density')

end

Dir.chdir(File.join(Dir.home, "small_genomes_SNPs/arabidopsis_datasets/#{dataset}/Perm_snps")) do

	perm_hm = WriteIt.file_to_ints_array("perm_hm.txt")
	SNPdist.plot_snps(perm_hm, hm[0], "small_genomes_SNPs/arabidopsis_datasets", "#{dataset}/Perm_snps", 1, genome_length, 'hm',
		'Homozygous SNP density', ylim_hm[0])

	perm_ht = WriteIt.file_to_ints_array("perm_ht.txt")
	SNPdist.plot_snps(perm_ht, ht[0], "small_genomes_SNPs/arabidopsis_datasets", "#{dataset}/Perm_snps", 1, genome_length, 'ht',
		'Heterozygous SNP density', ylim_ht[0])

	ratios = FitnessScore::ratio(perm_hm, perm_ht, div, genome_length)
	perm_hyp = SNPdist.hyp_snps(ratios, genome_length)
	SNPdist.plot_snps(perm_hyp, hyp[0], "small_genomes_SNPs/arabidopsis_datasets", "#{dataset}/Perm_snps", 1, genome_length, 'hyp', 
		'Approximated ratio of homozygous to heterozygous SNP density', ylim_hyp[0])
end
