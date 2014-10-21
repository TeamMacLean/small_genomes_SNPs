RESULTS
========================================================
Generating plots for the 2 kb genome
-------
### 1. Maximum density method

The **Homozygous SNP density obtained by the maximum density method** is not really accurate. Every generation, the distribution changes a lot. As the number of generations increases, the main peak is moving to the left and at the end, it is out of place. Also, in some cases, alternative peaks appear. 

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

An initial approaching to the model distributithe on is observed in the first generations. However, the main peak is out of place after a few generations (it moves to the left). Also, the distribution is not homogeneous. The **ratio hm/ht SNP density plot** is not consistent again, as in each generation is completely different to the previous one. However, the shape is more or less correct. 

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small8kb/max_density_150gen/images_hm.gif?raw=true)

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small8kb/max_density_150gen/images_hyp.gif?raw=true)

### 2. Maximum ratio method

Similar to the plot explained above. 

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small8kb/max_ratio_150gen/images_hm.gif?raw=true)

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small8kb/max_ratio_150gen/images_hyp.gif?raw=true)

### 3. SNP distance method

As stated in the 2kb-genome, the distribution approches to the model SNP distribution (blue line) as the number of generations increases. However, in this case, instead of getting to an only peak, when we reach around 100 generations, two main density peaks appear. 

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small8kb/snp_distance_150gen/images_hm.gif?raw=true)

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/arabidopsis_datasets/dataset_small8kb/snp_distance_150gen/images_hyp.gif?raw=true)


### Conclusion for the ratio hm/ht SNP density plot

For small genomes like the ones shown in here (2 and 8 kb), for [the conditions used](https://github.com/pilarcormo/Lab_book_TSL/blob/master/14.10.14.md) and the fitness methods employed, the distribution plots for the ratio homozygous to heterozygous are different for each generation. 


