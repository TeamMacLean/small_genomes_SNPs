Review
========
We are looking for the permutation of the contig order that has the correct homozygous/heterozygous SNP ratio distribution. Permutations with distributions close to the expected, are likely be ordered in an arrangement close to the correct. 

The main questions we should ask are: 

1. 'How well does the algorithm work?'
2. 'How useful are the fitness methods and the distance metrics used to evaluate their performance?'

We get fitness scores by running the algorithm many times (replicates).  Those fitness scores are assigned to each permutation by comparing the contig orders and calculating a distance to the correctly ordered permutation. we plot these scores against the number of generations (each generation is a new population of contig permutations). After that, we try to determine the efficiency of the algorithm by asigning a normalised value ('distance') to the difference between each permutation and the correctly ordered genome by using the PDist class.  This takes two input arrays that are permutations of each other (in this case, correct order and permutation), and the chosen method calculates the 'distance' between these permutations, according to a certain measure/metric. The distance is normalized to a value between 0 (no distance, the permutations are the same) and 1 (they are completely different). Different distance methods are used. 

How well does the genetic algorithm work?
--------

###1. Using the [SNP distance method](https://github.com/pilarcormo/fragmented_genome_with_snps/blob/master/Progress/Results2_snp_distance/results.Rmd)

First, the algorithm is run for 40 replicates (40 times) since we have 10 replicates for 4 different sets of parameters. The test genome is round 18 Mb large, and the fragment size is 10-20 kb so between 900 and 1800 fragments are generated. 

The fitness score is in this case **the sum of distances between adjacent homozygous SNPs.** *The lowest total distance -highest fitness- would correspond to the correct permutation as the SNPs are clustered together around the causative mutation.  It seems to improve rapidly at the very beginning. However, the improvement is very slight afterwards and all the replicates get to the same point after 60 generations. I don't observe a great difference when using a group of parameters or another.  

Afterwards, those results are [compared to the correct permutation's fitness score](https://raw.githubusercontent.com/edwardchalstrey1/fragmented_genome_with_snps/max_density/arabidopsis_datasets/10K_dataset4a/umbrella_plot_fits_total_snp_distance_with_correct.png).  For doing this, the correct permutation fitness score is plotted together with the fitness scores obtained from the genetic algorithm.  This is shown on the red line created from "replicate C". None of the replicates has produced permutations with fitness scores close to that of the correctly ordered genome.

As for the **distance metrics**, the value oscillates between 0.5 (squared deviation distance and kendall's tau distance) and 1, so according to this, we never get close to the correctly ordered genome with this method.  However, I just realised one thing: when analysing the [effectiveness of the distance methods](https://github.com/pilarcormo/fragmented_genome_with_snps/blob/master/Progress/Do_metrics_work/do_metrics_work.Rmd), the Square desviation distance and the Kendall's tau distance (those which give a 0.5 value to the permutations in this fitness method), assigned the same value (0.5) to the [completely random permutation](https://raw.githubusercontent.com/edwardchalstrey1/fragmented_genome_with_snps/master/arabidopsis_datasets/small_dataset2a/adjacent_swaps_SquareDeviationDistance_2000pop_10size_0.1Kdiv_swap1.png). So, can we trust them? **The conclusion from this, then, is that the distance metrics aren't good at discriminating the small changes in the large data sets we are looking at. So we need to be looking for a better, more discriminating way. It is interesting that the SNP containing fraragment goes to the middle quite quickly. Does this mean after X permutations, we can discard fragments?**

Then the [**location of the causal mutation**](https://raw.githubusercontent.com/edwardchalstrey1/fragmented_genome_with_snps/master/arabidopsis_datasets/10K_dataset4a/p_run39/images_hyp.gif) is determined by looking at the main peak at the homozygous to heterozygous SNP ratio distribution plot. The predicted and the correct SNP position are just over 4 Mb apart. On a 18 Mb, 4 Mb is not a very bad shift from the correct position.  

###2.  Using the [maximum density method](https://github.com/pilarcormo/fragmented_genome_with_snps/blob/master/Progress/Results3_max_density/results.Rmd)

Same number of replicates and parameter groupings as above. In this case, this method assigns a **maximum density value to each permutation**. This assumes the SNPs are clustered together around the causative mutation. In this case, after 400 generations, a maximum value does not seem to be reached (there is not a plateau). Event though, the [location of the causal SNP](https://raw.githubusercontent.com/edwardchalstrey1/fragmented_genome_with_snps/master/arabidopsis_datasets/10K_dataset4b/p_run16/images_hyp.gif) does not change after 100 generations, we could try reducing the size of the population to see if it has a positve effect in the fitness. 

Again, the permutations never get exactly to the correct ordered genome (the distance is not close to 0 when using any of the distance metrics, although it is 0.5 when using some of the metrics). As for the location of the causal mutation, the predicted and the correct SNP position are almost 5 Mb apart, so we can conclude that this fitness method is not really useful to predict the causative SNP either. 


###3. Using the [count ratio method](https://github.com/pilarcormo/fragmented_genome_with_snps/blob/master/Progress/Results1_count_ratio/results.Rmd). 


The count ratio method **counts the numbers of each type of SNP, in equally sized divisions of the genome**. In this case, there are 120 replicates (12 parameters groupings and 10 replicates per group of parameters). The comparison to the ordered genome is not shown and the mentioned plateau is reached after a few generations (around 100 depending on the replicate).

This method uses a certain number of divisions to break the genome in parts. In each part, we can count the number of homozygous and heterozygous SNPs and a hm to ht ratio can be calculated for each fragment. 

While the distance between the ordered genome and the permutation is never close to 0 again, the position of the causal mutation is really accurate, being only a few kb apart from the SNP position in the correctly ordered genome. Therefore, we can conclude from this that: **even if the permutation which is assigned with a high score is not completely similar to the real order of contigs, the contigs that are in the middle of the permutation are correctly ordered, because the causative SNP position can be succesfully determined.** When using the small genome, the predicted SNP position is practically perfect.

The replicate 60 is used to determine the SNP position. This replicate is obtained using the group of conditions (p6) that gives quite low fitness scores.  However, the parameters don't seem to affect the performance of the algorithm, as the distance metrics are the same for every replicate. The change of the parameters doesn't seem to improve the approximation of the permutation to the correct order. 

In general, it seems that the increase in the genome divisions (number of breaks in the genome to count the number of SNPs in) using 1 division provides worse fitness scores. 


###Speculations

By looking at the causal mutation location, we might say that the best fitness method is the count ratio. However, the correctly ordered genome and the permutations are still 'far' from each other (it seems that the the algorithm doesn't get to the correct permutation of contigs). This **suggests that maybe the algorithm is good enough to predict the causal SNP position although the order of the contigs is not perfectly correct.** However, we should check the reproducibility of this method. 

**Also, it might be that the distance metrics used to validate the performance of the algorithm are not optimal for this experiment.**(See following section) 

Then, we have 2 options: 

1. If the aim was to obtain correct order, the algorithm seems to fail. 
2. If the aim was to get the prediction of the causative mutation, the algorithm  works fine when using the count ratio method. 

**Questions I don't know how to answer:**

1. Which criteria are applied to select the **replicate used to define the SNP position**? Which are the differences between using a given group of parameters or another? Shouldn't the replicate that is assigned with a higher fitness score be selected? _DM! higher fitness permutations should be selected, but there is a problem with being too fit, you may reach a local maximum on the fitness hill-climb, so need to mix in some worse ones to allow you to come back down_
2. Why do we need so many parameters to generate the permutations? By changing the parameters, I don't see a great improvement in the algorithm performance. So, why don't we set the parameters in the algorithm in advance instead of changing them as command line arguments? _DM! Good point, if they do nothing, we can ignore them. The trick is to find the important ones. It seems like the important one is really how you define the fitness score_ 



How useful are the fitness methods and the distance metrics used to evaluate their performance?
-------

[Do metrics work](https://github.com/pilarcormo/fragmented_genome_with_snps/blob/master/Progress/Do_metrics_work/do_metrics_work.Rmd)

To evaluate the usefulness of every fitness method and the distance metrics,  the optimal permutation (correctly ordered) is mutated by adding adjacent swap mutant (2 adjacent contigs randomly swap positions). The fitness score obtained with each fitness method when this is done is compared with a randomly ordered permutation. For this tests, a small 2 kb genome is used 

- **Count ratio**: permutations being attributed with a high fitness score should approach the correct order, as the score worsen when it approaches the random permutation.

- **SNP distance**: the fitness score approaches to the randomly ordered permutation and it gets to it when a lot of swap mutants are added. Therefore, we can assume that the lowest fitness score (best) would approach the correct order. 

- **Max density**: the original permutation approaches again to the randomly order one as in the previous scenarios. 

- **Max ratio**: the fitness score assigned to the correctly order permutation is almost the same for the randomly order permutation. We cannot see a worsening of the fitness score value in this case, as it is almost a flat line. **Not useful**. 

- **Max hyp** (hypothetical distribution based on ratio of homozygous to heterozygous SNPs): In this case, we can see the worsening of the fitness score as we approach to the random permuation. 

- **Hyp distance**: Correctly order permutation and random one have the same fitness score. **Not useful**. 

The same type of evaluation is carried out with the distance metrics. We see that the most accurate ones (those which approximate to the random distribution when the correct order is mutated) are the harming distance and the R distance. However, the other distance metrics, even though they slightly approximate to the random permutation, they never reach it. Also, some of them do not give the value "1" to the random permutation as I would expect. 


###Speculations

It seems that the count ratio, SNP distance and max density methods work more or less ok (in theory) for the purpose of the algorithm. However, the max ratio and hyp distance methods do not seem to be very useful. **What about the maximum hypothesis method?** When it was used with the small genome, the candidate SNP position was really close to the causal mutation in the correctly ordered genome, What happen if we use it with a larger genome? 

In this test we only have 53 contigs because we use the 2 kb genome , and the population size is 10 (10 different permutations are obtained each generation), so I guess we get to the 'random' state faster than with the larger genome (~1500 contigs), in which we will need to do more swapping to get to the same point. We only need to swap e.g 5000 for the distance to be like random. With the random start point we are coming from the other side, so how many swaps do we need to make from random to get to the correct order? Is this why we dont see a distance improvement in our graphs? 

But, for example, the Hamming distance or the R distance that seem to measure the distance as it was expected, give a constant value of 1 to all the replicates in the count ratio method. This probably  means that the Hamming distance can't discriminate on permutations of sets of the size we are giving to it. It may work with the small genome. 

Future perspectives
========

1. Choose a set of distance methods to focus on. 
2. Run the algorithm on genome divisions of different sizes. Startin by using the count ratio method. 
3. Work out (possibly with Carlos) how many swaps we need to make from random to get to within x swaps of an original permutation (Im pretty certain this is a solved maths problem and Carlos will know of the right question to ask. So how many swaps do we need from perfect until our distance method tells us that it looks like the random (hint: See ed's graphs). Can we make a graph or model that tells us for a given genome size and given number of fragments how many swaps we are going to need.
