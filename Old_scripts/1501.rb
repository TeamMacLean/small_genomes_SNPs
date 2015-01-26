#encoding: utf-8

require_relative 'lib/reform_ratio'
require_relative 'lib/stuff'
require 'pp'

vcf_file = "arabidopsis_datasets/dataset_small2kb/snps.vcf"

snp_data = ReformRatio.get_snp_data(vcf_file)

fasta_file = "arabidopsis_datasets/dataset_small2kb/frags.fasta"
fasta = ReformRatio::fasta_array(fasta_file)
fasta_ordered = "arabidopsis_datasets/dataset_small2kb/frags_ordered.fasta"
frags_ordered = ReformRatio.fasta_array(fasta_ordered)

het_snps, hom_snps = ReformRatio.perm_pos(frags_ordered, snp_data)

puts het_snps
