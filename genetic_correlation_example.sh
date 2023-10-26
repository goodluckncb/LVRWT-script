# In this study, we have a total of 12 LVRWT traits, namely ES_IS, ES_I, ES_IL, ES_AL, ES_A, ES_AS, ED_IS, ED_I, ED_IL, ED_AL, ED_A, and ED_AS. 
# Here, ES stands for end systole, ED stands for end diastole, IS represents inferoseptal, I represents inferior, IL represents inferolateral, AL represents anterolateral, A represents anterior, and AS represents anterospetal.
# In the following code, we will use ES_IS as an example for illustration

#To calculate genetic correlations, we utilized the ldsc software (https://www.nature.com/articles/ng.3211) (https://github.com/bulik/ldsc)
#prepare summary file [ES_IS_summary.txt]
#must have these column 
# .snpid rs number
# .chr chromosome
# .bp physical (base pair) position
# .al  first allele , used as the effect allele
# .a2  second allele in bim file, used as the reference allele
# .beta Effect size (OR or BETA)
# .pval p value

#step1
path/to/ldsc/munge_sumstats.py --sumstats /home/ncb/heart/gwas/ES_IS_summary.txt  --N 41984 --out ES_IS_summary
#This step will generate a file named ES_IS_summary.sumstats.gz

#step2
/share/NCB/software/ldsc/ldsc.py  \
--ref-ld-chr /share/NCB/software/ldsc/eur_w_ld_chr/  \
--out ES_IS.sumstats.corr  \
--rg ES_IS.sumstats.gz,ES_IS.sumstats.gz,ES_I.sumstats.gz,ES_IL.sumstats.gz,ES_AL.sumstats.gz,ES_A.sumstats.gz,ES_AS.sumstats.gz,ED_IS.sumstats.gz,ED_I.sumstats.gz,ED_IL.sumstats.gz,ED_AL.sumstats.gz,ED_A.sumstats.gz,ED_AS.sumstats.gz \
--w-ld-chr /share/NCB/software/ldsc/eur_w_ld_chr/ 
