# In this study, we have a total of 12 LVRWT traits, namely ES_IS, ES_I, ES_IL, ES_AL, ES_A, ES_AS, ED_IS, ED_I, ED_IL, ED_AL, ED_A, and ED_AS. 
# Here, ES stands for end systole, ED stands for end diastole, IS represents inferoseptal, I represents inferior, IL represents inferolateral, AL represents anterolateral, A represents anterior, and AS represents anterospetal.
# At the same time, we have a total of 11 cardiovascular diseases (CVDs), including hypertrophic cardiomyopathy, myocardial infarction, hypertension, angina pectoris, chronic ischaemic heart disease, cardiomyopathy, atrial fibrillation, heart failure, all ischaemic stroke, dilated cardiomyopathies, and pulmonary hypertension. 
#Therefore, in the following code, we will use ES_IS and hypertrophic cardiomyopathy as examples for illustration


##-------------------------------------This section uses plink to obtain independent significant instrument variables------------
plink \
    --bfile /home/ncb/heart/gwas/ES_IS  \
    --clump-p1 5e-8 \
    --clump-r2 0.001 \
    --clump-kb 10 \
    --clump /home/ncb/heart/gwas/ES_IS_lmm.stats \
    --clump-snp-field SNP \
    --threads 30 \
    --clump-field P_BOLT_LMM_INF \
    --memory 100000 \
    --out /home/ncb/heart/MR/ES_IS_MR

awk 'NR!=1{print $3}' /home/ncb/heart/MR/ES_IS_MR.clumped > /home/ncb/heart/MR/ES_IS_MR.txt 
##--------------------------------------------------------------------------------------

setwd("/home/ncb/heart/MR")
library(TwoSampleMR)
library(tidyr)
library(data.table)
library(dplyr)
library(readxl)


#exposure--Read and process instrument variables
instrument <- fread("ES_IS_MR.txt",header = F) %>% rename(SNP=V1)
exp_dat <- fread("/home/ncb/heart/gwas/ES_IS_lmm.stats")
exp_dat <- left_join(instrument,exp_dat,by=c("SNP"))

exp_dat <- format_data(
  exp_dat,
  type='exposure',
  snp_col = "SNP",
  beta_col = "BETA",
  se_col = "SE",
  effect_allele_col ="ALLELE1",
  other_allele_col = "ALLELE0",
  pval_col = "P_BOLT_LMM_INF",
  eaf_col = "A1FREQ",
)


#outcome----hypertrophic cardiomyopathy
id_outcome <- "finn-b-I9_HYPERTROCARDMYOP"  #https://gwas.mrcieu.ac.uk/datasets/?gwas_id__icontains=finn-b-I9_HYPERTROCARDMYOP&year__iexact=&trait__icontains=&consortium__icontains=
outcome_dat <- extract_outcome_data(snps = exp_dat$SNP,
                                    outcomes =id_outcome,
                                    proxies = FALSE,
                                    maf_threshold = 0.01,
                                    access_token = NULL)

#do MR
dat <- harmonise_data(
  exposure_dat = exp_dat, 
  outcome_dat = outcome_dat)

result_dat <- mr(dat)


#Pleiotropic analysis
library(MRPRESSO)
mr_presso <- mr_presso(BetaOutcome = "beta.outcome",BetaExposure = "beta.exposure",SdOutcome = "se.outcome",
                    SdExposure = "se.exposure",OUTLIERtest = TRUE,DISTORTIONtest = TRUE, data = dat,
                    NbDistribution = 2000,SignifThreshold = 0.05)

Main_result <- as.data.frame(mr_presso$`Main MR results`)  
