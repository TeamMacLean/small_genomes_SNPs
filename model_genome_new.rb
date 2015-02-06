#encoding: utf-8
require_relative 'lib/model_genome'
require_relative 'lib/write_it'

name = ARGV[0]

size = ARGV[1].to_i

contig_size = ARGV[2].to_i
i = ARGV[3].to_i




# make the directory to put data files into
Dir.mkdir(File.join(Dir.home, "/small_genomes_SNPs/arabidopsis_datasets/#{name}"))

# Create the lists of homozygous and heterozygous SNPs
hm_r = "hm <- rnorm(50, #{i}, 100)" # Causative SNP at/near 10000
ht_r = "ht <- runif(50, 1, #{size})"   # Genome length of 10000
hm, ht = ModelGenome::get_snps(hm_r, ht_r)
snp_pos = [hm, ht].flatten

puts "There are #{hm.length} homozygous SNPs"
puts "There are #{ht.length} heterozygous SNPs"
# puts "Is there a SNP at the centre of the distribution? -- #{snp_pos.include?(size/2)}"

arabidopsis_c4 = ModelGenome::fasta_to_char_array("TAIR10_chr4.fasta")
puts "Creating the genome..."
small_genome = arabidopsis_c4[-size..-1] # Genome length of 100 kb
puts "...and generating the fragments"
frags = ModelGenome::get_frags(small_genome, contig_size)

puts "Small genome     length: #{small_genome.length} bases"
puts "You have created #{frags.length} fragments of sizes #{contig_size}-#{contig_size*2}"


# Get the positions of the SNPs on fragments
pos_on_frags, snp_pos_all = ModelGenome::pos_each_frag(snp_pos, frags)

fastaformat_array = ModelGenome::fasta_array(frags)
fastaformat_array_shuf = fastaformat_array.shuffle
vcf = ModelGenome::vcf_array(frags, pos_on_frags, snp_pos_all, hm, ht)

WriteIt::write_data("arabidopsis_datasets/#{name}/frags.fasta", fastaformat_array)
WriteIt::write_data("arabidopsis_datasets/#{name}/snps.vcf", vcf)
WriteIt::write_data("arabidopsis_datasets/#{name}/frags_shuffled.fasta", fastaformat_array_shuf)
WriteIt::write_txt("arabidopsis_datasets/#{name}/info", [hm_r, ht_r, "Contig size = #{contig_size}"])
WriteIt::write_txt("arabidopsis_datasets/#{name}/hm_snps", hm)
WriteIt::write_txt("arabidopsis_datasets/#{name}/ht_snps", ht)