Review
========
We are looking for the permutation of the contig order that has the correct homozygous/heterozygous SNP ratio distribution. Permutations with distributions close to the expected, are likely be ordered in an arrangement close to the correct. 

The main questions we should ask are: 

1. 'How well does the algorithm work?'
2. 'How useful are the fitness methods and the distance metrics used to evaluate their performance?'

_DM! Try using an active voice, rather than a passive one when possible_ We get fitness scores by running the algorithm many times (replicates), we plot these against the number of generations (each generation is a new population of contig permutations). After that, we compare the fitness scores with the correct order _DM! Im not sure that you do compare fitness scores with order. That doesn't follow_ by asigning a value ('distance') to the difference between each permutation and the correctly ordered genome by using the PDist class _DM! you get a fitness score by comparing the orders and calculating a distance_.  This takes two input arrays that are permutations of each other (in this case, correct order and permutation), and the chosen method calculates the 'distance' between these permutations, according to a certain measure/metric. The distance is normalized to a value between 0 (no distance, the permutations are the same) and 1 (they are completely different). Different distance methods are used. 

How well does the genetic algorithm work?
--------

###1. Using the [SNP distance method](https://github.com/pilarcormo/fragmented_genome_with_snps/blob/master/Progress/Results2_snp_distance/results.Rmd)

_DM!
First, the algorithm is run for 40 replicates (40 times). In this case, 
4 parameter groupings are used, so there are 10 equal replicates per parameter. _DM! So you have 10 replicates for 4 different sets of parameters?_ 

The fitness score is in this case **the sum of distances between adjacent homozygous SNPs.** *The lowest total distance -lowest fitness score- _DM! This doesn't make sense, the lowest distance = HIGHEST fitness_ would correspond to the correct permutation as the SNPs are clustered together around the causative mutation.* It seems to improve rapidly at the very beginning. However, the improvement is very slight afterwards and all the replicates get to the same point after 60 generations. I don't observe a great difference when using a group of parameters or another.  _DM! this is missing key details to make an interpretation, how big is the test genome, where is the causative SNP, what is the fragment size?_

Afterwards, those results are compared to the correct permutation's fitness. None of the permutations obtained is close to the ordered genome and changing the parameters doesn't seem to improve this. _DM! Again where is the evidence? The interpretation you have made may be fine, but I can't see on what basis you are making it. Just remember to be explicit about which part of which figure you are talking about_ 

As for the **distance metrics**, the value always oscillates between 0.5 and 1, so according to this, we never get close to the real ordered genome with this method. _DM! Explain why a distance of 0.5 is not a good distance, Im not sure that I agree with your conclusion_

Then the **location of the causal mutation** is determined by looking at the main peak at the homozygous to heterozygous SNP ratio distribution plot. The predicted and the correct SNP position are just over 4 Mb apart _DM! Are we looking at the same result [ie this picture](https://github.com/edwardchalstrey1/fragmented_genome_with_snps/blob/master/arabidopsis_datasets/10K_dataset4a/p_run39/images_hm.gif?raw=true)_. Thus, this method is not completely accurate to find the causative SNP. _DM! On a genome of what size? 4 / 18 Mb doesn't seem so bad!_ 

###2.  Using the [maximum density method](https://github.com/pilarcormo/fragmented_genome_with_snps/blob/master/Progress/Results3_max_density/results.Rmd)

Same number of replicates and parameter groupings as above. In this case, this method assigns a **maximum density value to each permutation**. This assumes the SNPs are clustered together around the causative mutation. In this case, after 400 generations, a maximum value does not seem to be reached (there is not a plateau). _DM! So we need to do more permutations?_ 
Again, the permutations never get to the correct ordered genome (the distance is not close to 0 when using any of the distance metrics). As for the location of the causal mutation, the predicted and the correct SNP position are almost 5 Mb apart, so we can conclude that this fitness method is not really useful to predict the causative SNP either. 


###3. Using the [count ratio method](https://github.com/pilarcormo/fragmented_genome_with_snps/blob/master/Progress/Results1_count_ratio/results.Rmd). 


The count ratio method **counts the numbers of each type of SNP, in equally sized divisions of the genome**. In this case, there are 120 replicates (12 parameters groupings and 10 replicates per group of parameters). The comparison to the ordered genome is not shown and the mentioned plateau is reached after a few generations (around 100 depending on the replicate). 

While the distance between the ordered genome and the permutation is never close to 0 again, the position of the causal mutation is really accurate, being only a few kb apart from the SNP position in the correctly ordered genome. Therefore, we can conclude from this that: **even if the permutation which is assigned with a high score is not similar to the real order of contigs, the contigs that are in the middle of the permutation are correctly ordered, because the causative SNP position can be succesfully determined.** When using the small genome, the predicted SNP position is practically perfect. _DM! Good! We have a candidate approach, perhaps._ 

The replicate 60 is used to determine the SNP position. This replicate is obtained using the group of conditions (p6) that gives quite low fitness scores.  However, the parameters don't seem to affect the performance of the algorithm, as the distance metrics are the same for every replicate. The change of the parameters doesn't seem to improve the approximation of the permutation to the correct order. 

In general, it seems that the increase in the genome divisions (number of breaks in the genome to count the number of SNPs in) using 1 division provides worse fitness scores. 


###Speculations

By looking at the causal mutation location, we might say that the best fitness method is the count ratio. However, the correctly ordered genome and the permutations are still 'far' from each other (it seems that the the algorithm doesn't get to the correct permutation of contigs). This **suggests that maybe the algorithm is good enough to predict the causal SNP position although the order of the contigs is not perfectly correct.** However, we should check the reproducibility of this method. _DM! So are you proposing a systematic check of the algorithm using the count ratio?_ 

**Also, it might be that the distance metrics used to validate the performance of the algorithm are not optimal for this experiment.**(See following section) 

Then, we have 2 options: 

1. If the aim was to obtain correct order, the algorithm seems to fail. 
2. If the aim was to get the prediction of the causative mutation, the algorithm  works fine when using the count ratio method. 

**Questions I don't know how to answer:**

1. Which criteria are applied to select the **replicate used to define the SNP position**? Which are the differences between using a given group of parameters or another? Shouldn't the replicate that is assigned with a higher fitness score be selected? _DM! higher fitness permutations should be selected, but there is a problem with being too fit, you may reach a local maximum on the fitness hill-climb, so need to mix in some worse ones to allow you to come back down_
2. Why do we need so many parameters to generate the permutations? By changing the parameters, I don't see a great improvement in the algorithm performance. So, why don't we set the parameters in the algorithm in advance instead of changing them as command line arguments? _DM! Good point, if they do nothing, we can ignore them. The trick is to find the important ones. It seems like the important one is really how you define the fitness score_ 
3. What is the meaning of this **'divisions' parameter** that seems to affect the count ratio method so much? What happen if we choose one replicate created with 1 division to determine the causal mutation? _DM! An excellent question, you should know this from the code. Try to find out._


How useful are the fitness methods and the distance metrics used to evaluate their performance?
-------

[Do metrics work](https://github.com/pilarcormo/fragmented_genome_with_snps/blob/master/Progress/Do_metrics_work/do_metrics_work.Rmd)

To evaluate the usefulness of every fitness method and the distance metrics,  the optimal permutation (correctly ordered) is mutated by adding adjacent swap mutant (2 adjacent contigs randomly swap positions). The fitness score obtained with each fitness method when this is done is compared with a randomly ordered permutation

- **Count ratio**: permutations being attributed with a high fitness score should approach the correct order, as the score worsen when it approaches the random permutation.

- **SNP distance**: the fitness score approaches to the randomly ordered permutation and it gets to it when a lot of swap mutants are added. Therefore, we can assume that the lowest fitness score (best) would approach the correct order. 

- **Max density**: the original permutation approaches again to the randomly order one as in the previous scenarios. 

- **Max ratio**: the fitness score assigned to the correctly order permutation is almost the same for the randomly order permutation. We cannot see a worsening of the fitness score value in this case, as it is almost a flat line. **Not useful**. 

- **Max hyp** (hypothetical distribution based on ratio of homozygous to heterozygous SNPs): In this case, we can see the worsening of the fitness score as we approach to the random permuation. 

- **Hyp distance**: Correctly order permutation and random one have the same fitness score. **Not useful**. 

The same type of evaluation is carried out with the distance metrics. We see that the most accurate ones (those which approximate to the random distribution when the correct order is mutated) are the harming distance and the R distance. However, the other distance metrics, even though they slightly approximate to the random permutation, they never reach it. Also, some of them do not give the value "1" to the random permutation as I would expect. 


###Speculations

It seems that the count ratio, SNP distance and max density methods work more or less ok (in theory) for the purpose of the algorithm. However, the max ratio and hyp distance methods do not seem to be very useful. **What about the maximum hypothesis method?** When it was used with the small genome, the candidate SNP position was really close to the causal mutation in the correctly ordered genome, What happen if we use it with a larger genome? 

Some of the distance metrics seem to work just fine, as they assign a 0 value to the correct order and approach to 1 when we get closer to the random permutation,  so we assume that the distance metrics are useful and evaluate correctly the performance of the genetic algorithm. 
_DM! How does the number of elements and adjacent swaps you make in these tests compare with the number of divisions of the genome you have_ _DM! we only need to swap e.g 5000 for the distance to be like random. With the random start point we are coming from the other side.. how many swaps do we need to make from Random to get to the correct order.. is this why we don't see a distance improvement in our graphs_
But, for example, the Hamming distance or the R distance that seem to measure the distance as it was expected, give a constant value of 1 to all the replicates in the count ratio method. **Would that mean that the permutation never approaches to the correct order? How is possible that the distance is constant? How can we be sure that the position of the causal SNP is correctly determined? Is the problem in the distance metrics or in the fitness method?** _DM! I think it means that the Hamming distance can't discriminate on permutations of sets of the size you are giving to it._  

Future perspectives
========
- Try to reproduce the results?  
- Determine why the algorithm never gets to the correcttly ordered permutation
- Use a more realistic model? 
- Maybe the whole genome? 
- Use real SNP data to see if the algorithm can predict the SNP position then?

1. Choose a set of distance methods to focus on.
2. Run the algorithm on genome divisions of different sizes
3. Work out (possibly with Carlos) how many swaps we need to make from random to get to within x swaps of an original permutation (Im pretty certain this is a solved maths problem and Carlos will know of the right question to ask.
