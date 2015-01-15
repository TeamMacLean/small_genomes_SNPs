
#encoding: utf-8

require_relative 'reform_ratio'
require 'Bio'

##Open the vcf file and create lists of heterozygous and homozygous SNPs

class Stuff
	def self.get_snp_data(vcf_file)
		hm = []
		ht = []
		File.open(vcf_file, 'r').each do |line|
			next if line =~ /^#/
			v = Bio::DB::Vcf.new(line)
			a = line.split("\t")
			first =  a.first
			last = a.last
			if last == "AF=0.5\n"
				ht << first
			elsif last == "AF=1.0\n"
				hm << first
			end
		return ht, hm
		end
	end

	def self.take_ids_from_fasta(fasta_file)
		ids_s = [] 
		frags = []
		fasta_file = File.open(fasta_file)
		fasta_file.each do |line|
			frags << line
		end
		frags.each do |line|
			line = line.split(" ")
			id_only = line[0]
			if id_only.start_with?(">")
				ids_s << id_only
			end
		end
		return ids_s
	end


	def self.shuffle_ends(fasta)
		l = fasta.length/6
		l = l.to_i 
		master = fasta.each_slice(l).to_a
		new_array = []
		x = 0
		l.times do
			new_array = (master[x] << master[-(x+1)]).flatten!.shuffle 
			lu = new_array.each_slice(2).to_a
			master.delete_at(x)
			master.insert(x, lu[0])
			master.delete_at(-(x+1))
			master.insert(-(x+1), lu[1])
			new_array = []
			lu = []
			x =+ 1
		end
		return master.flatten! 
	end
end
