
#encoding: utf-8
require_relative 'reform_ratio'
require 'bio'

##Open the vcf file and create lists of heterozygous and homozygous SNPs

class Stuff
	##Input: vcf file
	##Ouput: lists of hm and ht SNPS
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

	##Input: Lists of hm and ht SNPs
	##Output: dictionaries with the id of the fragment as key and the absolute number of SNPs as value
	def self.create_hash_snps(hm, ht)
		dic_hm, dic_ht = {}, {}
		hm.uniq.each do |elem|
			dic_hm.store("#{elem}", "#{hm.count(elem).to_i}" )
		end
		ht.uniq.each do |elem|
			dic_ht.store("#{elem}", "#{ht.count(elem).to_i}" )
		end
		return dic_hm, dic_ht
	end

	##Input 1: Array of IDs (from shuffled fasta file)
	##Input 2: Hash of hm SNPs
	##Input 3: Hash of ht SNPs
	##Assign the number of SNPs to each fragment in the shuffled list. 
	##If a fragment does not have SNPs, the value assigned will be 0.
	##Output: New hashes with SNP values assigned to the unordered fragments
	def self.define_snps(ids, hm, ht) 
		shuf_ht, shuf_hm = {}, {}
		ids.each do |frag|
			if hm.has_key?(frag)
				shuf_hm.store(frag, hm[frag].to_f)
			else
				shuf_hm.store(frag, 0)
			end 
			if ht.has_key?(frag)
				shuf_ht.store(frag, ht[frag].to_f)
			else 
				shuf_ht.store(frag, 0)
			end 
		end 
		snps_hm, snps_ht = [], []
		shuf_hm.each { |id, snp| snps_hm << snp }
		shuf_ht.each { |id, snp| snps_ht << snp }
		return shuf_hm, shuf_ht, snps_hm, snps_ht
	end

	##Invert the keys and values in a hash. 
	##Avoid elimination of pairs key-value if values in the first hash are repeated. 
	# def safe_invert
	# 	self.each_with_object( {} ) { |(key, value), out| ( out[value] ||= [] ) << key }
	# end

	##Inputs: hashes with IDs as keys and the SNP density as values

	def self.normalise_by_length(shuf_hm, shuf_ht, snps_hm, snps_ht, lengths)
		shuf_hm_norm, shuf_ht_norm = {}, {}
		x = 0
		l = snps_hm.length
		Array(0..l-1).each do |i|
			snp_norm = snps_hm[x].to_f/lengths[x].to_f
			keys = shuf_hm.keys
			shuf_hm_norm.store(keys[x], snp_norm)
			x +=1
		end 
		x = 0
		l2 = snps_ht.length
		Array(0..l2-1).each do |i|
			snp_norm_ht = snps_ht[x].to_f/lengths[x].to_f
			keys = shuf_ht.keys
			shuf_ht_norm.store(keys[x], snp_norm_ht)
			x +=1
		end 
		return shuf_hm_norm, shuf_ht_norm
		##Invert the hashes to have the SNP number as the key and all the fragments with the same SNP number together as valuess
	end

	def self.create_perm_fasta(perm, frags, ids)
		defs, data, defs_p, data_p = [], [], [], [] 
		frags.each do |i|
			defs << i.definition
			data << i.data 
		end 
		perm.each do |frag|
			index_frag = ids.index(frag).to_i
			defs_p << defs[index_frag]
			data_p << data[index_frag]
		end 

		###Create fasta array with the information above 
		fasta_perm = []
		x = 0
		Array(0..perm.length-1).each do |i|
			fasta_perm << defs_p[x]
			fasta_perm << data_p[x]
			x += 1
		end 
		fasta_perm.each do |line|
			if line.start_with?("\n")
				line[0] = '' 
			else 
				line.insert(0, ">")
			end
		end	
		return fasta_perm
	end 

	##

	# def self.shuffle_ends(fasta)
	# 	l = fasta.length/10.to_i
	# 	q = l - 1
	# 	master = fasta.each_slice(l).to_a
	# 	new_array = []
	# 	new_array2 = []
	# 	x = 0
	# 	q.times do
	# 		new_array = (master[x] << master[-(x+1)]).flatten!.shuffle 
	# 		lu = new_array.each_slice(2).to_a
	# 		master.delete_at(x)
	# 		master.insert(x, lu[0])
	# 		master.delete_at(-(x+1))
	# 		master.insert(-(x+1), lu[1])
	# 		new_array = []
	# 		lu = []
	# 		x =+ 1
	# 	end
	# 	return master.flatten! 
	# end
end
