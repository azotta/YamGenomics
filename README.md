# YamGenomics

Methods used on the paper entitled: ["Whole-genome sequencing and comparative genomics reveal candidate genes associated with quality traits in Dioscorea alata"](https://www.biorxiv.org/content/10.1101/2023.03.17.532727v2.abstract)


## Combine keyword search and Comparative Genomics

to retrieve the ec numbers from specific maps: 
http://rest.kegg.jp/link/enzyme/pathway:map00040
http://rest.kegg.jp/link/enzyme/pathway:map00500
http://rest.kegg.jp/link/enzyme/pathway:map00941

With the number of EC for each map, retrieve the gene models annotated for each ec number from the GFF file: 

To print the gene models: 
grep -Fwif list_ec_map00500_right.txt funcional_annotation_Dalatav2.txt|awk -F"\t" '{print $2}' |sort -u > unique_gene_model_map00500.txt
To print the EC number: 
grep -Fwif list_ec_map00500_right.txt funcional_annotation_Dalatav2.txt|awk -F"\t" '{print $7}' |sort -u > unique_ec_map00500.txt

