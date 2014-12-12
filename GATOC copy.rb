#encoding: utf-8
### Required command line parameters #####################################################
dataset = ARGV[0] # Name of dataset directory in 'fragmented_genome_with_snps/arabidopsis_datasets'
run = ARGV[1] # Name of sub directory to create for this run of the algorithm, and to store output files in
fitness_method = 'count_ratio' # Fitness method to use from FitnessScore class
gen =  3 # Number of generations
pop_size = 3 # Population size
select_num = 3 # Number of permutations to select from each generation
c_mut = 2 # Number of chunk mutants (see GATOC and PMeth gem) in each new population
s_mut = 2 # Number of swap mutants (see GATOC and PMeth gem) in each new population
save = 2 # Number of permutations to save from each generation
ran = 1 # Number of random permutations in each generation
###########################################################################################


## Files ################################################
vcf_file = "arabidopsis_datasets/#{dataset}/snps.vcf"
fasta_file = "arabidopsis_datasets/#{dataset}/frags.fasta"
loc = 'small_genomes_SNPs/arabidopsis_datasets'
#############################################################


### Optional command line parameters ######################################################
div =  4 # Number of breaks (divisions) in the genome to count the number of SNPs in. ### max_hyp and count_ratio require this ###
restart = ARGV[2] # Tells the algorithm to continue from the most recent generation if it has stopped
############################################################################################

require_relative 'lib/fitness_score'
require_relative 'lib/write_it'
require_relative 'lib/reform_ratio'
require 'pmeth'
require 'rinruby'
require 'pp'
require 'csv'
require 'benchmark'

# Input 0: A permutation array of Bio::FastaFormat entries (contig arrangement)
# Input 1: Array of all the outputs from ReformRatio.get_snp_data method
# Input 2: Length of the genome
# Input 3: String indicating fitness method to use from FitnessScore class
# Output 0: Fitness score for the permutation
# Output 1: List of homozygous SNPs for the permutation
# Output 2: Heterozygous list
def self.fitness(fasta, snp_data, genome_length, method)
	het_snps, hom_snps = ReformRatio.perm_pos(fasta, snp_data)
	score = FitnessScore.count_ratio(hom_snps, het_snps, @div, genome_length, @expected_ratios)
	return score.to_f, hom_snps, het_snps
end

# Input 0: Array of Bio::FastaFormat entries
# Input 1: Integer of the desired population size
# Output: Population - Array of size "size", where each element is an array of a shuffled permutation of the input 0 array and the string 'random', in an array.
def self.initial_population(fasta, size)
	population = []
	size.times do
		population << [fasta.shuffle, 'random']
	end
	return population
end

# Input 0: Population - array of arrays where each sub array is a permutation of the fragments (Bio::FastaFormat entries)
# Input 1: Array of all the outputs from get_snp_data method
# Input 2: Integer of the desired number of permutations to be selected for the next generation
# Input 3: Length of the genome
# Input 4: String indicating fitness method to use from FitnessScore class
# Output 0: Array of fittest selection of Input 0 population: each sub array has two elements, the fitness and the permutation (which is itself an array of fragments)
# Output 1: Integer of leftover permutations, to be taken from the multiplied selected population
# Output 2: Pre-selected version of output 0
# Output 3: Array of strings, each string represents the method used to create a permutation followed by fitness score, and the array is ordered the same as output 2
def self.select(pop, snp_data, num, genome_length, fitness_method)
	fits = {}
	pop.each do |fasta_array, type|
		fitn = fitness(fasta_array, snp_data, genome_length, fitness_method)[0]
		fits[fasta_array] = [fitn, type] # maybe some have exact same fitness, perhaps we can make fitness the value, then sort by value
	end 
	if fits.size < pop.size # to compensate for duplicates, we add extra swap mutants
		diff = pop.size - fits.size
		x = 0
		diff.times do
			extra_swap = PMeth.swap_mutate(pop[rand(pop[0].length)][0].dup)
			fitn = fitness(extra_swap, snp_data, genome_length, fitness_method)[0]
			fits[extra_swap] = [fitn, 'extra_swap']
			x+=1
		end
	end
	fits = fits.sort_by {|k,v| v[0]} # sorting by fitness score
	types = []
	fits.each {|k,v| types << v.reverse} # adding the types with fitness to a new array
	x = 0
	fits.each {|k,v| fits[x][1] = v[0]; x+=1} # getting rid of the types, so v is now just fitness score
	pop_fits = []
	fits.each {|i| pop_fits << i.reverse} # swapping the permutation/fitness score around
	initial_pf = pop_fits # the input permutations ordered by fitness, not yet selcted
	if fitness_method == 'snp_distance'
		sliced = pop_fits.each_slice(num).to_a
		initial_pf.reverse!
		types.reverse!
	else
		sliced = pop_fits.reverse.each_slice(num).to_a # sliced the population ordered by fitness into chunks of size num, choosing the chunk with the highest fitness scores (reversing and choosing chunk 0)
	end
	pop_fits = sliced[0].reverse # creating the selected population, and reversing them to ascending fitness order
	if sliced[-1].length != sliced[0].length # if there is a remainder slice
		leftover = sliced[-1].length
	else 
		leftover = 0
	end
	return pop_fits, leftover, initial_pf, types
end

# Input 0: Array of fittest selection of previous population: each sub array has two elements, the fitness and the permutation (which is itself an array of fragments)
# Input 1: Integer of the desired population size
# Input 2: Integer of the desired number of chunk mutant permutations in the new population
# Input 3: Integer of the desired number of swap mutant permutations in the new population
# Input 4: Integer of the desired number of the best permutations from the previous population, to be included in the new one
# Input 5: Integer of the desired number of randomly shuffled permutations in a new population
# Input 6: Integer of the number of permutations selected by the select method
# Input 7: Integer of leftover permutations, to be taken from the multiplied selected population
# Output: New population - array of arrays where each sub array is a permutation of the fragments (Bio::FastaFormat entries)
def self.new_population(pop_fits, size, c_mut, s_mut, save, ran, select_num, leftover) # mut_num = no. of mutants, save = number saved; from best, ran = no. of random permutations
	x = (size-leftover)/select_num
	pop_fits = pop_fits * x
	if leftover != 0
		pop_fits = [pop_fits, pop_fits[-leftover..-1]].flatten(1) # add leftover number of frags (best)
		puts "#{leftover} leftover frags added"
	end
	pop_save = pop_fits.reverse.each_slice(save).to_a[0] # saving best "save" of permutations
	pop = []
	pop_save.each{|i| pop << [i[1], 'saved']} # adding the permutations only, not the fitness score
	c_mut.times{pop << [PMeth.chunk_mutate(pop_fits[rand(pop_fits.length)][1].dup), 'chunk_mutant']} # chunk_mutating randomly selected permutations from pop_fits
	s_mut.times{pop << [PMeth.swap_mutate(pop_fits[-1][1].dup), 'swap_mutant']} # swap_mutating the best permutations
	ran.times{pop << [pop_fits[0][1].shuffle, 'random']}
	return pop
end

# Input 0: See output 2 of select
# Input 1: Location to save files to
# Input 2: Dataset algorithm running on
# Input 3: Name of this run of the algorithm
# Input 4: Generation of the genetic algorithm
# Input 5: Output 3 of select
# Output: txt files with data interpretable by text-table gem AND txt files for each permutation
def self.save_perms(pop_fits, location, dataset, run, gen, types)
	# Dir.mkdir(File.join(Dir.home, "#{location}/#{dataset}/#{run}/Gen#{gen}"))
	Dir.chdir(File.join(Dir.home, "#{location}")) do
# 		table_data = [['Permutation', 'Fitness Score', 'Type', 'FASTA ids']]
# 		x = 1
# 		pop_fits.each do |fitness, permutation|
# 			table_data << ["permutation#{x}", fitness, types[x-1][0], ReformRatio::fasta_id_n_lengths(permutation)[0].join(", ")]
# 			x+=1
# 		end
# 		WriteIt::write_txt("#{dataset}/#{run}/Gen#{gen}/table_data", table_data)

		# x = 1
		# pop_fits.each do |fitness, perm|
		# 	ids = ReformRatio::fasta_id_n_lengths(perm)[0]
		# 	WriteIt::write_txt("#{dataset}/#{run}/Gen#{gen}_permutation#{x}", [fitness, ids].flatten)
		# 	x+=1
		# end
		if gen != 0
			ids = ReformRatio::fasta_id_n_lengths(pop_fits[-1][1])[0]
			WriteIt::write_txt("#{dataset}/#{run}/Gen#{gen}_best_permutation", [pop_fits[-1][0], ids].flatten) # fitness and ids
		end
	end
end

# Input: Array of number values
# Output: The area under the curve for the input array plotted against 1..input_length
# def self.quit(fitness_scores)
# 	myr = RinRuby.new(echo = false)
# 	myr.assign 'y', fitness_scores
# 	myr.eval 'x <- 1:length(y)'
# 	myr.eval 'library("pracma")'
# 	myr.eval 'require(pracma)'
# 	myr.eval 'auc <- trapz(x,y)'
# 	auc = myr.pull 'auc'
# 	myr.quit
# 	return auc
# end

# Input 0: FASTA file
# Input 1: VCF file
# Input 2: Hash of parameters for running the algorithm. See opts hash below for defaults.
# Output 1: A saved .txt file of the fragment identifiers, of a permutation with a fitness that suggests it is the correct order
# Output 2: A saved figure of the algorithm's performance
# Output 3: A saved figure of the best permuation's homozygous/heterozygous SNP density ratio across the genome, assuming the fragment permutation is correct

@expected_ratios = opts[:expected_ratios]
@div = opts[:div].to_i

snp_data = ReformRatio::get_snp_data(vcf_file) # array of vcf frag ids, snp positions (fragments with snps), hash of each frag from vcf with no. snps, array of info field
fasta = ReformRatio::fasta_array(fasta_file) # array of fasta format fragments
genome_length = ReformRatio::genome_length(fasta_file)

if opts[:start_pop] == nil
	pop = initial_population(fasta, opts[:pop_size]) # create initial population
else
	pop = opts[:start_pop] # use a pre-made starting population
end

gen, last_best, auc = opts[:start_gen], [], nil
opts[:gen].times do

	if opts[:start_gen] == 0 && opts[:restart_zero] != nil && gen == 0 # Enables restart of algorithm, where only generation 0 is already complete
		gen+=1
	end

	pop_fits, leftover, initial_pf, types = select(pop, snp_data, opts[:select_num], genome_length, opts[:fitness_method]) # select fittest permutations in population

	unless opts[:start_pop] != nil && gen == opts[:start_gen] # if using a starting population, we don't want to overwite files for that generation
		save_perms(initial_pf, opts[:loc], opts[:dataset], opts[:run], gen, types) # save the permutations from this generation, with fitness scores
	end

	puts "Gen#{gen}\n Fitness Score = #{pop_fits[-1][0]}" # print output to show improvement of best permutation over generations as algorithm runs
#####CSV file generation (Pilar)####################################################################################################################
	path = "arabidopsis_datasets/#{opts[:dataset]}/#{opts[:run]}/table.csv"

	# CSV.open(path, "wb") do |csv|
		# csv << ["Generation", "Best fitness score"]
	# end
	CSV.open(path, "ab") do |csv|
		q = pop_fits [-1][0]
		p = gen
		csv << [p, q]
	end
###################
		
	ht, hm = ReformRatio.perm_pos(pop_fits[-1][1], snp_data) # get the SNP distributions for the best permutation in the generation

	unless opts[:start_pop] != nil && gen == opts[:start_gen] # if using a starting population, we don't want to overwite files for that generation
		Dir.mkdir(File.join(Dir.home, "#{opts[:loc]}/#{opts[:dataset]}/#{opts[:run]}/Gen#{gen}_lists"))
		Dir.chdir(File.join(Dir.home, "#{opts[:loc]}/#{opts[:dataset]}/#{opts[:run]}/Gen#{gen}_lists")) do
			WriteIt::write_txt("gen_#{gen}_hm", hm) # save the SNP distributions for the best permutation in the generation
			WriteIt::write_txt("gen_#{gen}_ht", ht)
		end
	end
	
	pop = new_population(pop_fits, opts[:pop_size], opts[:c_mut], opts[:s_mut], opts[:save], opts[:ran], opts[:select_num], leftover)
	gen+=1

	last_best << pop_fits[-1][0]
	if last_best.length == opts[:auc_gen] 
		last_auc = auc
		auc = quit(last_best) # Decide whether algorithm improvement is negligible enough to quit
		if opts[:fitness_method] == 'snp_distance' # snp_distance is a decreasing score (with improvement)
			if last_auc != nil && (last_auc - auc) <= (last_auc/(100.0/opts[:auc].to_f))
				puts 'auc break'
				gen = opts[:gen]
			end
		else # all other fitness methods are increasing with improvement
			if last_auc != nil && (auc - last_auc) <= (last_auc/(100.0/opts[:auc].to_f))
				puts 'auc break'
				gen = opts[:gen]
			end
		end
		last_best = []
	end
	
	if gen >= opts[:gen] # Quit the algorithm after the specified number of generations is up
		then break
	end
	Signal.trap("PIPE", "EXIT")
end
