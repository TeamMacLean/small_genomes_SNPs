#encoding: utf-8

require_relative 'lib/reform_ratio'

dataset = ARGV[0]

fasta_file = "arabidopsis_datasets/#{dataset}/frags_ordered.fasta"
fasta = ReformRatio::fasta_array(fasta_file)

fasta_file2 = "arabidopsis_datasets/#{dataset}/frags.fasta"
fasta2 = ReformRatio::fasta_array(fasta_file2)

puts fasta.length
puts fasta2.length

