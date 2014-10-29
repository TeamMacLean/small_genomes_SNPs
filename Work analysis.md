Review
========
The main questions we should ask are: 

**'How well does the algorithm work?'**

**'How useful are the fitness methods and the distance metrics used to evaluate their performance?'**

The fitness scores obtained after running the algorithm many times (replicates) are plotted against the number of generations (each generation is a new population of contig permutations). After that, the fitness scores are compared with the correct order by assinging a value ('distance') to the difference between each permutation and the correctly ordered genome by using the PDist class.  This takes two input arrays that are permutations of each other (in this case, correct order and permutation), and the chosen method calculates the 'distance' between these permutations, according to a certain measure/metric. The distance is normalized to a value between 0 (no distance, the permutations are the same) and 1 (they are completely different). Different distance methods are used. 

How well does the genetic algorithm work?
--------

###1. Using the [SNP distance method](https://github.com/pilarcormo/fragmented_genome_with_snps/blob/master/Progress/Results2_snp_distance/results.Rmd)

First, the algorithm is run for 40 replicates (40 times). In this case, 
4 parameter groupings are used, so there are 10 equal replicates per parameter. 

The fitness score (in this case **the sum of distances between adjacent homozygous SNPs**) seems to improve rapidly at the very beginning. However, the improvement is very slight afterwards and all the replicates get to the same point after 60 generations. The lowest total distance (lowest fitness score )would correspond to the correct permutation as the SNPs are clustered together around the causative mutation. 

Afterwards, those results are compared with the correct permutation's fitness (repilicate C). Any of the replicates produced permutations closed to the ordered genome and changing the parameters doesn't seem to improve this.

- **Distance metrics**

For every method used to measure the distance, its value oscillates between 0.5 and 1, so according to this, we never get close to the real ordered genome with this method. 

- **Location of causal mutation**

When we look at the causal mutation (main peak at the homozygous to heterozygous SNP ratio distribution plot), 
the peaks (real vs obtained with the algorithm) are almost 4,000,000 bp apart. Thus, this method is not completely accurate to find the causative SNP. 

###2.  Using the [maximum density method](https://github.com/pilarcormo/fragmented_genome_with_snps/blob/master/Progress/Results3_max_density/results.Rmd)

Same number of replicates and parameter groupings as I explained above. In this case, this method assigns a **maximum density value to each permutation**. This assumes the SNPs are clustered together around the causative mutation. In this case, after 400 generations, a maximum value does not seem to be reached (there is not a plateau). When compararing to the correct order of contigs, again the permutations never get to the real value (the distance is not close to 0 when using the distance metrics). As for the location of the causal mutation, the predicted and the correct SNP position are almost 5 Mb apart, so we can conclude that this fitness method is not really useful to predict the causative SNP either. 


###3. Using the [count ratio method](https://github.com/pilarcormo/fragmented_genome_with_snps/blob/master/Progress/Results1_count_ratio/results.Rmd). 


The count ratio method **counts the numbers of each type of SNP, in equally sized divisions of the genome**. In this case, there are 120 replicates (12 parameters groupings and 10 replicates per group of parameters). The comparison to the ordered genome is not shown and the mentioned plateau is reached after a few generations (around 100 depending on the replicate). 

While the distance between the ordered genome and the permutation is never close to 0, the location of the causal mutation is really accurate when running the algorithm with this method in comparison to the other methods, being only a few kb apart from the correctly located SNP. Therefore, we can conclude from this that: **even if the permutation that reaches a high score is not similar to the real order of contigs, the contigs that are in the middle are correctly ordered, so the causative SNP position can be succesfully characterized.** When using the small genome, the predicted SNP position is practically perfect. 

However, the replicate 60 is used to find the SNP position, what I don't really understand as the replicate is obtained using the group of conditions (p6) that gives quite low fitness scores. Actually, the parameters named p2 are equal to those in p6 except for the number of genome divisions. 

###Speculations

By looking at the causal mutation location, we might say that the best fitness method is the count ratio. However, the correctly ordered genome and the permutations are still 'far' from each other (it seems that the the algorithm doesn't get to the correct permutation of contigs), **suggesting that maybe the algorithm is good enough to predict the causal SNP position although the order of the contigs is not perfectly correct.**

**Also, it might be that the distance metrics used to validate the performance of the algorithm are not optimal for this experiment.**(See following section) 

Then, we have 2 options: 

1. If the aim was to obtain correct order, the algorithm seems to fail. 
2. If the aim was to get to the prediction of the causative mutation, the algorithm  works fine when using the count ratio method.

**Questions I don't know how to answer:**

1. Which criteria are applied to select the replicate used to define the SNP position? Which are really the differences between using a given group of parameters or another? 
2. Why do we need so many parameters to generate the permutations? 
3. Is the causative SNP identified here real? I mean, is the SNP distribution of the correctly ordered genome real? 

How useful are the fitness methods and the distance metrics used to evaluate their performance?
-------

[Do metrics work](https://github.com/pilarcormo/fragmented_genome_with_snps/blob/master/Progress/Do_metrics_work/do_metrics_work.Rmd)

To evaluate the usefulness of every fitness method and the distance metrics,  the optimal permutation (correctly ordered) is mutated by adding adjacent swap mutant (adjacent objects randomely swap position). The fitness score obtained with each fitness method when this is done is compared with a randomly ordered permutation

- **Count ratio**: permutations being attributed with high fitness scores should be approaching the correct order, as the score approaches to the random permutation when the original permutation is mutated. 

- **SNP distance**: the fitness score approaches to the randomly ordered permutation and it gets to it when a lot of swap mutants have been added. Therefore, we can assume that the lowest fitness score for this method would approach to the correct order. 

- **Max density**: the original permutation approaches again to the randomly order one as in the previous scenarios. 

- **Max ratio**: the fitness score assigned to the correctly order permutation is almost the same for the randomly order permutation. We cannot see a worsening of the fitness score value in this case, as it is almost a flat line. **Not useful**. 

- **Max hyp** (hypothetical distribution based on ratio of homozygous to heterozygous SNPs): In this case, we can see the worsening of the fitness score as we approach to the random permuation. 

- **Hyp distance**: Correctly order permutation and randomly ordered one have the same fitness score. **Not useful**. 

The same type of evaluation is carried out with the distance metrics. We see that the most accurate ones (those which approximate to the random distribution when the correct order is mutated) are the harming distance and the R distance. However, the other distance metrics, even though they slightly approximate to the random permutation, they never reach it. Also, some of them do not give the value "1" to the random permutation as I would expect. 


###Speculations

As it was anticipated in the previous section, the count ratio, SNP distance and max density methods work ok for the purpose of the algorithm. However, the max ratio and hyp distance methods do not seem to be very useful. **What about the maximum hypothesis method?** When it was used with the small genome, the candidate SNP position was really close to the causal mutation in the correctly ordered genome. 

Some distance metrics seem to work just fine so, going back to my previous assumption, does the algorithm never gets to the correctly ordered permutation then? 

Future perspectives
========
More realistic model? Maybe the whole genome? 
