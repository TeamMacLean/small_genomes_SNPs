#encoding: utf-8
require_relative 'lib/model_genome'
require_relative 'lib/write_it'

puts "Name of the output dataset: "

output = gets.chomp

# make the directory to put data files into
Dir.mkdir(File.join(Dir.home, "small_genomes_SNPs/arabidopsis_datasets/#{output}"))

puts "To create the model genome I'm using TAIR10_chr4.fasta"

# Create the lists of homozygous and heterozygous SNPs
hm_r = 'hm <- rnorm(50, 1000, 100)' # Causative SNP at/near 1000
ht_r = 'ht <- runif(50, 1, 8000)'   # Genome length of 2000
hm, ht = ModelGenome::get_snps(hm_r, ht_r)
snp_pos = [hm, ht].flatten

puts "There are #{hm.length} homozygous SNPs"
puts "There are #{ht.length} heterozygous SNPs"
puts "Is there a SNP at the centre of the distribution? -- #{snp_pos.include?(1000)}"


arabidopsis_c4 = ModelGenome::fasta_to_char_array("TAIR10_chr4.fasta")
small_genome = arabidopsis_c4[-8000..-1] # Genome length of 8Kb

contig_size = 25 # 25-50 bp
frags = ModelGenome::get_frags(small_genome, contig_size)

puts "Small genome     length: #{small_genome.length} bases"
puts "Fragmented seq   length: #{frags.join.length} = close enough? You decide."
puts "You have created #{frags.length} fragments of sizes #{contig_size}-#{contig_size*2}"


# Get the positions of the SNPs on fragments
pos_on_frags, snp_pos_all = ModelGenome::pos_each_frag(snp_pos, frags)

fastaformat_array = ModelGenome::fasta_array(frags)
fastaformat_array_shuf = fastaformat_array.shuffle # shuffle it to show that the order doesn't need to be conserved when working out density later on

vcf = ModelGenome::vcf_array(frags, pos_on_frags, snp_pos_all, hm, ht)

WriteIt::write_data("arabidopsis_datasets/#{output}/frags.fasta", fastaformat_array)
WriteIt::write_data("arabidopsis_datasets/#{output}/snps.vcf", vcf)
WriteIt::write_data("arabidopsis_datasets/#{output}/frags_shuffled.fasta", fastaformat_array_shuf)
WriteIt::write_txt("arabidopsis_datasets/#{output}/info", [hm_r, ht_r, "Contig size = #{contig_size}"])
WriteIt::write_txt("arabidopsis_datasets/#{output}/hm_snps", hm)
WriteIt::write_txt("arabidopsis_datasets/#{output}/ht_snps", ht)