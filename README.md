# YamGenomics

Methods used on the paper entitled: ["Whole-genome sequencing and comparative genomics reveal candidate genes associated with quality traits in Dioscorea alata"](https://www.biorxiv.org/content/10.1101/2023.03.17.532727v2.abstract)


## Combine keyword search and Comparative Genomics

1- To be able to retrieve the genes from each pathway, we first retrieved all the ec number to the three kegg pathways. For each specific pathway, we used the following link: 
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

