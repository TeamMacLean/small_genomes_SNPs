#encoding: utf-8
require_relative 'lib/model_genome'
require_relative 'lib/write_it'

# make the directory to put data files into
Dir.mkdir(File.join(Dir.home, "small_genomes_SNPs/arabidopsis_datasets/#{ARGV[0]}"))

# Create the lists of homozygous and heterozygous SNPs
hm_r = 'hm <- rnorm(50, 4000, 200)' # Causative SNP at/near 4000
ht_r = 'ht <- runif(50, 1, 8000)'   # Genome length of 8000
hm, ht = ModelGenome::get_snps(hm_r, ht_r)
snp_pos = [hm, ht].flatten

puts "There are #{hm.length} homozygous SNPs"
puts "There are #{ht.length} heterozygous SNPs"
puts "Is there a SNP at the centre of the distribution? -- #{snp_pos.include?(1000)}"

arabidopsis_c4 = ModelGenome::fasta_to_char_array("TAIR10_chr4.fasta")
small_genome = arabidopsis_c4[-8000..-1] # Genome length of 8Kb

contig_size = 50 # 25-50 bp
frags = ModelGenome::get_frags(small_genome, contig_size)

puts "Small genome     length: #{small_genome.length} bases"
puts "Fragmented seq   length: #{frags.join.length} = close enough? You decide."
puts "You have created #{frags.length} fragments of sizes #{contig_size}-#{contig_size*2}"

