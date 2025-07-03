
for pop in 'Hainan1' 'Hainan2' 'Hainan3'
do
burdenr -f polu_27_GATK_vcftoolsfilter.recode.anno.vcf.gz -w work_dir -A $pop -B Cam -G groups.list
done
