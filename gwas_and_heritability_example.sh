#!/bin/bash

# In this study, we have a total of 12 LVRWT traits, namely ES_IS, ES_I, ES_IL, ES_AL, ES_A, ES_AS, ED_IS, ED_I, ED_IL, ED_AL, ED_A, and ED_AS. 
# Here, ES stands for end systole, ED stands for end diastole, IS represents inferoseptal, I represents inferior, IL represents inferolateral, AL represents anterolateral, A represents anterior, and AS represents anterospetal.
# In the following code, we will use ES_IS as an example for illustration


cd /home/ncb/heart/gwas

#quality control
plink \
  --bfile /home/ncb/data/UK/genotype/ukb_genotype \
  --geno 0.05 \
  --hwe 0.000001 \
  --keep ES_IS_ID.txt \
  --maf 0.01 \
  --make-bed \
  --mind 0.1 \
  --out ES_IS \

#modelSnps
plink \
  --bfile ES_IS \
  --indep-pairwise 500 50 0.9 \
  --maf 0.005 \
  --out ES_IS_maf_0.005

#bolt-lmm ( "Perform the GWAS for ES_IS)
#(https://www.nature.com/articles/s41588-018-0144-6)
#The specific meanings of BOLT-related parameters can be found at https://storage.googleapis.com/broad-alkesgroup-public/BOLT-LMM/BOLT-LMM_manual.html
bolt \
    --maxModelSnps=8463542 \
    --bfile=ES_IS \
    --geneticMapFile=/home/ncb/bolt-lmm/BOLT-LMM_v2.3.6/tables/genetic_map_hg19_withX.txt.gz \
    --modelSnps=ES_IS_maf_0.005.prune.in\
    --phenoFile=ES_IS_phenofile.txt \
    --phenoCol=ES_IS_INT \
    --covarFile=ES_IS_phenofile.txt \
    --covarCol=assessment \
    --covarCol=sex \
    --qCovarCol=age \
    --qCovarCol=bmi \
    --qCovarCol=pca{1:10} \
    --lmm \
    --lmmForceNonInf \
    --LDscoresFile=/home/ncb/bolt-lmm/BOLT-LMM_v2.3.6/tables/LDSCORE.1000G_EUR.tab.gz \
    --numThreads=8 \
    --statsFile=/home/ncb/heart/gwas/ES_IS_lmm.stats 

#bolt-relm (Calculate the heritability of ES_IS)
bolt \
    --maxModelSnps=8463542 \
    --bfile=ES_IS \
    --geneticMapFile=/home/ncb/bolt-lmm/BOLT-LMM_v2.3.6/tables/genetic_map_hg19_withX.txt.gz \
    --modelSnps=ES_IS_maf_0.005.prune.in\
    --phenoFile=ES_IS_phenofile.txt \
    --phenoCol=ES_IS_INT \
    --covarFile=ES_IS_phenofile.txt \
    --covarCol=assessment \
    --covarCol=sex \
    --qCovarCol=age \
    --qCovarCol=bmi \
    --qCovarCol=pca{1:10} \
    --relm \
    --numThreads=8 \