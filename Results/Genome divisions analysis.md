Genome divisions
=====

<table>
  <tr><th>Size of the genome (bp)</th><th>From</th><th>Contig size</th><th>rnorm</th><th>runif</th><th>Name of the file</th></tr>
   <tr><th>2,000</th><th>arabidopsis_c4[-2000..-1]<th>25</th></th><th>rnorm(50, 1000, 100)</th><th>runif(50, 1, 2000)</th><th>dataset_small2kb</th></tr>
   <tr><th>8,000</th><th>arabidopsis_c4[-8000..-1]<th>50</th></th><th>rnorm(50, 4000, 200)</th><th>unif(50, 1, 8000)</th><th>8kbgenome2</th></tr>
    <tr><th>20,000</th><th>arabidopsis_c4[-20000..-1]</th><th>25-50</th><th>rnorm(200, 10000, 200)</th><th>runif(200, 1, 20000)</th><th>20kbgenome</th></tr>
     
     <tr><th>100,000</th><th>arabidopsis_c4[-100000..-1]</th><th>100</th><th>rnorm(100, 50000, 5000)</th><th>runif(100, 1, 100000)</th><th>100kbgenome</th></tr>
     
      <tr><th>1,000,000</th><th>arabidopsis_c4[-1000000..-1]</th><th>1000</th><th>rnorm(1000, 500000, 10000)</th><th>runif(1000, 1, 1000000)</th><th>1000kbgenome</th></tr>
  
 </table>
####__2 Kb genome using count ratio method__: 

Position in the correct ordered genome: <span style="color:red">997

<table>

  <tr><th>Number of generations</th><th>Population size</th><th>Select number</th><th>Chunk mutants</th><th>Swap mutants</th><th>Save</th><th>Random</th><th>Divisions (1000s)</th><th>Location SNP</th><th>Name of the file</th></tr>
  
  
  <tr>  <td>79</td> <td>10</td> <td>5</td> <td>7</td> <td>7</td> <td>5</td> <td>2</td> <td>10</td><td>1580</td><td>count_ratio</td> </tr>
  <tr>   <td>39</td> <td>100</td> <td>50</td> <td>35</td> <td>35</td> <td>25</td> <td>5</td> <td>5</td> <td><span style="color:red">1015</td><td>count_ratio4</td></tr>
    <tr>  <td>59</td> <td>100</td> <td>50</td> <td>35</td> <td>35</td> <td>25</td> <td>5</td> <td>10</td> <td>1421</td><td>count_ratio2</td></tr>
    <tr>   <td>79</td> <td>100</td> <td>50</td> <td>35</td> <td>35</td> <td>25</td> <td>5</td> <td>100</td> <td>687</td><td>count_ratio3</td></tr>
    
   </table>
   
   
####__8 Kb genome using count ratio method__: 

Position in the correct ordered genome: 3996
<table>

 <tr><th>Number of generations</th><th>Population size</th><th>Select number</th><th>Chunk mutants</th><th>Swap mutants</th><th>Save</th><th>Random</th><th>Divisions (1000s)</th><th>Location SNP</th><th>Name of the file</th></tr>

  <tr>   <td>39</td> <td>100</td> <td>50</td> <td>35</td> <td>35</td> <td>25</td> <td>5</td> <td>5</td> <td>5642</td><td>count_ratio</td></tr>
   <tr>   <td>59</td> <td>100</td> <td>50</td> <td>35</td> <td>35</td> <td>25</td> <td>5</td> <td>10</td> <td>4830</td><td>count_ratio2</td></tr>
   <tr>   <td>99</td> <td>100</td> <td>50</td> <td>35</td> <td>35</td> <td>25</td> <td>5</td> <td>100</td> <td><span style="color:red">2955</td><td>count_ratio3</td></tr>
  </table>
    
#### __20 Kb genome using count ratio method__: 

Position in the correct oredered genome: <span style="color:red">10028

<table>

 <tr><th>Number of generations</th><th>Population size</th><th>Select number</th><th>Chunk mutants</th><th>Swap mutants</th><th>Save</th><th>Random</th><th>Divisions (1000s)</th><th>Location SNP</th><th>Name of the file</th></tr>
 

  <tr>   <td>39</td> <td>100</td> <td>50</td> <td>35</td> <td>35</td> <td>25</td> <td>5</td> <td>5</td> <td><span style="color:red">10797</td><td>count_ratio2</td></tr>
    <tr>   <td>59</td> <td>100</td> <td>50</td> <td>35</td> <td>35</td> <td>25</td> <td>5</td> <td>10</td> <td>3530</td><td>count_ratio3</td></tr>    
 

  </table>
  
#### __100 Kb genome using count ratio method__: 
  
  Position in the correct oredered genome: <span style="color:red">49444
  
  <table>

 <tr><th>Number of generations</th><th>Population size</th><th>Select number</th><th>Chunk mutants</th><th>Swap mutants</th><th>Save</th><th>Random</th><th>Divisions (1000s)</th><th>Location SNP</th><th>Name of the file</th></tr>
 
  <tr>   <td>39</td> <td>100</td> <td>50</td> <td>35</td> <td>35</td> <td>25</td> <td>5</td> <td>5</td> <td><span style="color:red">50205</td><td>count_ratio</td></tr>
  <tr>   <td>59</td> <td>100</td> <td>50</td> <td>35</td> <td>35</td> <td>25</td> <td>5</td> <td>10</td> <td>60264</td><td>count_ratio2</td></tr>
  
  </table>
  
  The size of the genome is not that important as the number of fragments generated. In the 20 kb genome, we generated 528 fragments of 25-50 bp while in the 100 kb genome, we generated 670 fragments of 100-200 bp so the location of the SNP is more accurate when using the count ratio method. My next plan is to generate __fewer but larger contigs__ to see the effect of the genome divisions on that:
  
#### __1000 Kb genome using count ratio method__
663 fragments of sizes 1000-2000 bp (closer to reality)

Position in the correct oredered genome: <span style="color:red">500436

  <table>

 <tr><th>Number of generations</th><th>Population size</th><th>Select number</th><th>Chunk mutants</th><th>Swap mutants</th><th>Save</th><th>Random</th><th>Divisions (1000s)</th><th>Location SNP</th><th>Name of the file</th></tr>
 
  
  <tr>   <td>59</td> <td>100</td> <td>50</td> <td>35</td> <td>35</td> <td>25</td> <td>5</td> <td>10</td> <td><span style="color:red">409285</td><td>count_ratio2</td></tr>
  
  </table>
  