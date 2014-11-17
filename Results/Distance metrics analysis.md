Distance metrics
======

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/Results/Rplot.%20Comparison%20between%20distance%20metrics%20maxdensity.png?raw=true)

![Image](https://github.com/pilarcormo/small_genomes_SNPs/blob/master/Results/Rplot.Comparison%20between%20distance%20metrics.%20countratio2.png?raw=true)


The 2 kb genome is used in this example. As we move forward 1 unit in the x axis, the first and last contigs of the permutation (the last permutation of the run) are removed from the array. The same values are removed from the correctly ordered array and then we measure the distance between both arrays using all the distance metrics. 

As we can see here, all the metrics follow aproximately the same trend. However, as expected, some of them assign a value close to 1 to the random permutation (first one) while others assign a value of 0.5. 

When using the count ratio method, we see a decrease in the distance once we have removed 14 contigs at each end. This means that when we only have half of the contigs in the middle, the distance is closer to 0 than any other time. Also, we can see that the count ratio method is more effective in arranging the contigs. It even gets to 0 when there are only 2 fragments left. 

The hamming distance and the R distance seem to be the less useful, while the rest metrics are more or less accurate for the purpuse