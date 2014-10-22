RESULTS
========================================================
Generating plots for the 2 kb genome
-------
### 1. Maximum density method

The **Homozygous SNP density obtained by the maximum density method** is not really accurate. Every generation, the distribution changes a lot. As the number of generations increases, the main peak is moving to the left and at the end, it is completely out of place. Also, in some cases, alternative peaks appear. Also, the peak is much  

In the **ratio hm/ht SNP density plot**, the distribution also changes a lot each generation, without following any useful trend. 


![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small2kb/max_density_150gen/images_hm.gif?raw=true)

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small2kb/max_density_150gen/images_hyp.gif?raw=true)

### 2. Maximum ratio method
Similar results to those observed above.

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small2kb/max_ratio_150gen/images_hm.gif?raw=true)

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small2kb/max_ratio_150gen/images_hyp.gif?raw=true)

### 3. SNP distance method
In this case, as the number of generations increases, the distribution approches to the model SNP distribution (blue line). With small genomes, I can conclude that this fitness method is the most accurate of the 3 I used. However, the **ratio hm/ht SNP density plot** looks the same for the three methods used. 

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small2kb/snp_distance_150gen/images_hm.gif?raw=true)

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small2kb/snp_distance_150gen/images_hyp.gif?raw=true)

Generating plots for the 8 kb genome
-------
### 1. Maximum density method

An initial approach to the model distribution is observed in the first generations. However, the main peak is out of place after a few generations (it moves to the left). Also, the distribution is not homogeneous, since other smaller peaks appear. The **ratio hm/ht SNP density plot** is not consistent again, as in each generation is completely different to the previous one. However, the shape is more or less correct. 

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small8kb/max_density_150gen/images_hm.gif?raw=true)

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small8kb/max_density_150gen/images_hyp.gif?raw=true)

### 2. Maximum ratio method

Similar results to those observed above.

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small8kb/max_ratio_150gen/images_hm.gif?raw=true)

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small8kb/max_ratio_150gen/images_hyp.gif?raw=true)

### 3. SNP distance method

As stated in the 2kb-genome, the distribution approches to the model distribution (blue line) as the number of generations increases. However, in this case, instead of getting to an only peak, when we reach around 100 generations, two main density peaks appear. 

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small8kb/snp_distance_150gen/images_hm.gif?raw=true)

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small8kb/snp_distance_150gen/images_hyp.gif?raw=true)



### Possible improvements I can think of

- The increase in the genome size (2-->8 kb) doesn't seem to improve the accuracy of the distribution plots.
- Increase the number of generations? 
- Try with new parameters.  By increasing the number of permutations, we will probably have a best_permutation per generation with a **better fitness score.**. I could increase the select_num (number of permutations from each population to create a new population from. Also, I could increase the population size (numnber of permutations in each population)
- Use the count_ratio method
