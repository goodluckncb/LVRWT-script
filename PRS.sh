#clump
plink \
    --bfile path/to/genotype/ES_IS  \
    --clump-p1 1e-5 \
    --clump-r2 0.1 \
    --clump-kb 250 \
    --clump path/to/gwas_summary_dir/ES_IS_lmm.stats \
    --clump-snp-field SNP \
    --threads 30 \
    --memory 100000 \
    --clump-field P_BOLT_LMM_INF \
    --out path/to/PRS/ES_IS_PRS_SNP
     awk 'NR!=1{print $3}' path/to/PRS/ES_IS_PRS_SNP.clumped > path/to/PRS/ES_IS_PRS_SNP.txt

#Please note that the 'clump-p1' parameter can be adjusted as needed based on the data, especially when the GWAS summary data does not have many significant lead SNPs

#calculate PRS
plink \
    --bfile /share/NCB/uk_genotype/UKB_filtered_sample  \
    --extract path/to/PRS/ES_IS_PRS_SNP.txt \
    --score path/to/gwas_summary_dir/ES_IS_lmm.stats 1 5 9   \
    --out path/to/PRS/ES_IS_UKB_filtered_sample

#The 'SCORE' column in the results represents the PRS (Polygenic Risk Score) score for each individua
#for example：
# FID       IID  PHENO    CNT   CNT2    SCORE
# X   X     -9    230     48 -0.00252416
