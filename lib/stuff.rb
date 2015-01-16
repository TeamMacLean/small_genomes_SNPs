
#encoding: utf-8
require_relative 'reform_ratio'
require 'Bio'

##Open the vcf file and create lists of heterozygous and homozygous SNPs

class Stuff
	def self.snps_in_vcf(vcf_file)

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
		end
		return hm, ht
	end

	# def self.take_ids_from_fasta(fasta_file)
	# 	ids_s = [] 
	# 	frags = []
	# 	fasta_file = File.open(fasta_file)
	# 	fasta_file.each do |line|
	# 		frags << line
	# 	end
	# 	frags.each do |line|
	# 		line = line.split(" ")
	# 		id_only = line[0]
	# 		if id_only.start_with?(">")
	# 			ids_s << id_only
	# 		end
	# 	end
	# 	return ids_s
	# end

	def self.dic_snps_fasta(hm, ht)
		dic_hm = {}
		dic_ht = {}

		hm.uniq.each do |elem|
			dic_hm.store("#{elem}", "#{hm.count(elem).to_i}" )
		end

		ht.uniq.each do |elem|
			dic_ht.store("#{elem}", "#{ht.count(elem).to_i}" )
		end
		return dic_hm, dic_ht
	end


	def self.define_snps(ids, dic_hm, dic_ht)
		dic_shuf_ht = {}
		dic_shuf_hm = {}
		ids.each do |frag|
			if dic_hm.has_key?(frag)
				dic_shuf_hm.store(frag, dic_hm[frag].to_f)
			else
				dic_shuf_hm.store(frag, 0)
			end 
			if dic_ht.has_key?(frag)
				dic_shuf_ht.store(frag, dic_ht[frag].to_f)
			else 
				dic_shuf_ht.store(frag, 0)
			end 
		end 
		snps_hm = []
		snps_ht = []
		dic_shuf_hm.each { |id, snp| snps_hm << snp }
		dic_shuf_ht.each { |id, snp| snps_ht << snp }
		return dic_shuf_hm, dic_shuf_ht, snps_hm, snps_ht
	end


	def self.shuffle_ends(fasta)
		l = fasta.length/10.to_i
		q = l - 1
		master = fasta.each_slice(l).to_a
		new_array = []
		new_array2 = []
		x = 0
		1.times do
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
