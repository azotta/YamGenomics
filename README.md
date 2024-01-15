# YamGenomics

Methods used on the paper entitled: ["Whole-genome sequencing and comparative genomics reveal candidate genes associated with quality traits in Dioscorea alata"](https://www.biorxiv.org/content/10.1101/2023.03.17.532727v2.abstract)


## Combine keyword search and Comparative Genomics

- To be able to retrieve the genes from each pathway, we first retrieved all the ec number to the three kegg pathways. For each specific pathway, we used the following link: 
```
http://rest.kegg.jp/link/enzyme/pathway:map00040
```
The map00040 corresponds to pentose and glucuronate interconversions pathway, the map00500 to starch and sucrose metabolism and the map00941 to flavonoid biosynthesis metabolism. 

We then saved the EC numbers to a file and searched against the functional annotation file:
```
To print the gene models: 
grep -Fwif list_ec_map00500_right.txt funcional_annotation_Dalatav2.txt|awk -F"\t" '{print $2}' |sort -u > unique_gene_model_map00500.txt
```
```
To print the EC number: 
grep -Fwif list_ec_map00500_right.txt funcional_annotation_Dalatav2.txt|awk -F"\t" '{print $7}' |sort -u > unique_ec_map00500.txt
```

- In parallel, we performed an orthology analysis to determine the orthologous genes among 45 different species, comprising several monocotyledons plants and also tuber species, in addition to other plant-models. We used the default parameters of OrthoFinder software, and we obtained 58,916 orthologous groups (OG), from 1,706,645 proteins.
- Combining both the results, from the search of EC numbers from kegg pathways on the functional annotation of D. alata, and the orthologous groups, we obtained a list of OG and also all the genes belonging to these OG.
```
grep --color=always -f unique_gene_model_map00500.txt /work/zottamota/OrthoFinder/fasta/OrthoFinder/Results_Sep24_1/Orthogroups/Orthogroups.txt |awk -F":" '{print $1}' > orthogroups_map00500.txt
```
```
grep -f unique_genes_alata_map00040.txt ../OrthoFinder/OrthoFinder_Apr/Results_Apr14/Orthogroups/Orthogroups.txt > pectin_OG.txt
```
- Finally we retrieved only the D. alata from each OG, to obtain a final list of genes
```
grep -o 'Dala|[^ ]*' pectin_OG.txt > all_genes_pectin_OG.txt
```
- We retrieved also the number of genes per OG and produced a binary matrix, to use on UpSetR graph (fromGeneCount_to_Binary.ipynb)


## Admixture and Fst Analyses

To determine the genetic structure of our collection, we selected 107 diploid genotypes from the 127 sequenced. 
Plink to convert vcf to bed
```
plink2 --vcf thin_filter_all_geno.vcf.gz --make-bed --out out_genotypes_diploid_thin
```
Use bed to obtain admixture for k from 1 to 15
```
for K in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15;
do admixture --cv out_genotypes_diploid_thin.bed $K --method=block | tee log${K}.out; done
```
To calculate the Fst, from the file diploidGeno.3.Q (3 is the number chosen from the result of admixture) 

- Merge the file with the names from all the genotypes within the table
```
awk -f merge.awk list_diploids.txt diploidGeno.3.Q > result_admixture_diploid_reviewed.txt
```
- Filter the columns for the minimum value (this case 0.75)
```
awk '{if ($2+0>0.75) print $0 "\t" "Cluster_1"; else if ($3+0>0.75) print $0 "\t" "Cluster_2"; else if ($4+0>0.75) print $0 "\t" "Cluster_3"; else print $0 "\t" "Admixture"}' result_admixture_diploid_reviewed.txt > result_with_clusters_075.txt
```

- From the file "result_with_cluster_075.txt" prepare one file per cluster, to run the Fst

- Run vcftools to calculate the Fst of each pair of clusters (3 in total) 

```
vcftools --gzvcf thin_filter_all_geno.vcf.gz --weir-fst-pop cluster1.txt --weir-fst-pop cluster2.txt --fst-window-size 50000 --fst-window-step 10000 --out cluster1_x_cluster2
```

- To define the cut-off value for each cluster comparison we used the R script (Fst_analysis.r). After analysis the same model showed the best results for all the three cluster comparisons (Weibull).



