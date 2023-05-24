#!/bin/bash

echo "script start: download and initial sequencing read quality control"
date
common=/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo
data=$common/data
seq1=$data/sra_fastq/ERR6913211_1.fastq.gz
seq2=$data/sra_fastq/ERR6913211_2.fastq.gz
seqs_path=$data/sra_fastq
analyses=$common/analyses
scripts=$common/scripts
start=`date +%s`
# Part 2 
#sqlite3 -batch -noheader -csv  /shared/projects/2314_medbioinfo/pascal/central_database/sample_collab.db "select run_accession from sample_annot spl left join sample2bioinformatician s2b using(patient_code) where username='snarrowe'" > $common/scripts/snarrowe_run_accessions.txt

#mkdir $seqs_path

#module avail -C sra
#module load sra-tools

# Test fastq-dump command
#fastq-dump  -X 10 --readids --gzip --outdir $seqs_path --disable-multithreading --split-e ERR6913103

# Run for all accession ids
#cat $scripts/snarrowe_run_accessions.txt | srun --cpus-per-task=1 --time=00:10:00 xargs fastq-dump --gzip --outdir /shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq --disable-multithreading --readids  --split-e

# OUTPUT: 
#Read 192870 spots for ERR6913103
#Written 192870 spots for ERR6913103
#Read 1067560 spots for ERR6913128
#Written 1067560 spots for ERR6913128
#Read 31198 spots for ERR6913199
#Written 31198 spots for ERR6913199
#Read 1127307 spots for ERR6913224
#Written 1127307 spots for ERR6913224
#Read 16627 spots for ERR6913115
#Written 16627 spots for ERR6913115
#Read 19781 spots for ERR6913211
#Written 19781 spots for ERR6913211
#Read 198593 spots for ERR6913117
#Written 198593 spots for ERR6913117
#Read 15934 spots for ERR6913213
#Written 15934 spots for ERR6913213
#Read 16620 spots for ERR6913111
#Written 16620 spots for ERR6913111
#Read 4620 spots for ERR6913207
#Written 4620 spots for ERR6913207

#sacct --format=JobID,JobName%20,ReqCPUS,ReqMem,Timelimit,State,ExitCode,Start,elapsed,MaxRSS,NodeList,Account%15 
# 6:40 minutes required

# Count the number of files in sra_fastq/
#ls $seqs_path | wc -l
# Output 20
 
#Count the number of reads in each file 
#zgrep -c '^@' $seqs_path/*.gz #xargs (zgrep "@" | wc -l)   

# The sequences are in the  Sanger standard format since fastq-dump converts all data to this format according to the linked wikipedia article

# Part 3 
# Check if the module is available
# module avail | grep seqkit
# module load seqkit

# Print stats on each read
# srun --cpus-per-task=1 --time=00:01:00 seqkit --threads 1 stats $seqs_path/*.gz
# Compared that with 
# sqlite3 -batch /shared/projects/2314_medbioinfo/pascal/central_database/sample_collab.db "select * from sample_annot spl left join sample2bioinformatician s2b using(patient_code) where username='snarrowe'" 

# OUTPUT, If you sum the sum_len from both files in the stat-command you get the same number as the base_count and the num_seqs add up to the read_count 
#file                                                                                           format  type   num_seqs      sum_len  min_len  avg_len  max_len
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913103_1.fastq.gz  FASTQ   DNA     192,870   24,531,781       35    127.2      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913103_2.fastq.gz  FASTQ   DNA     192,870   24,529,064       35    127.2      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913111_1.fastq.gz  FASTQ   DNA      16,620    2,198,653       35    132.3      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913111_2.fastq.gz  FASTQ   DNA      16,620    2,198,959       35    132.3      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913115_1.fastq.gz  FASTQ   DNA      16,627    2,129,700       35    128.1      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913115_2.fastq.gz  FASTQ   DNA      16,627    2,129,470       35    128.1      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913117_1.fastq.gz  FASTQ   DNA     198,593   25,277,579       35    127.3      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913117_2.fastq.gz  FASTQ   DNA     198,593   25,279,157       35    127.3      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913128_1.fastq.gz  FASTQ   DNA   1,067,560  152,953,415       35    143.3      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913128_2.fastq.gz  FASTQ   DNA   1,067,560  152,947,802       35    143.3      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913199_1.fastq.gz  FASTQ   DNA      31,198    3,336,874       35      107      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913199_2.fastq.gz  FASTQ   DNA      31,198    3,336,493       35    106.9      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913207_1.fastq.gz  FASTQ   DNA       4,620      575,747       35    124.6      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913207_2.fastq.gz  FASTQ   DNA       4,620      575,539       35    124.6      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913211_1.fastq.gz  FASTQ   DNA      19,781    2,251,531       35    113.8      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913211_2.fastq.gz  FASTQ   DNA      19,781    2,252,009       35    113.8      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913213_1.fastq.gz  FASTQ   DNA      15,934    1,686,477       35    105.8      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913213_2.fastq.gz  FASTQ   DNA      15,934    1,686,869       35    105.9      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913224_1.fastq.gz  FASTQ   DNA   1,127,307  149,000,016       35    132.2      151
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq/ERR6913224_2.fastq.gz  FASTQ   DNA   1,127,307  148,988,061       35    132.2      151
#run_accession  host_subject_id    patient_code  nuc  host_body_site  host_disease_status  miscellaneous_parameter      Ct     total_reads  read_count  base_count  username
#-------------  -----------------  ------------  ---  --------------  -------------------  ---------------------------  -----  -----------  ----------  ----------  --------
#ERR6913103     P019_DNA_S74_L001  P19           DNA  Nasopharyngeal  SARS-CoV-2 positive  Symptomatic-DNA-sequenced    18.81  21364260     385740      49060845    snarrowe
#ERR6913128     P19_DNA_L001_2     P19           DNA  Nasopharyngeal  SARS-CoV-2 positive  Asymptomatic-DNA-sequenced   18.81  20197672     2135120     305901217   snarrowe
#ERR6913199     P019_RNA_S78_L001  P19           RNA  Nasopharyngeal  SARS-CoV-2 positive  Symptomatic-cDNA-sequenced   18.81  20758064     62396       6673367     snarrowe
#ERR6913224     P19_CDNA_L001_2    P19           RNA  Nasopharyngeal  SARS-CoV-2 positive  Asymptomatic-cDNA-sequenced  18.81  22008998     2254614     297988077   snarrowe
#ERR6913115     P267_DNA_S9_L001   P267          DNA  Nasopharyngeal  SARS-CoV-2 positive  Symptomatic-DNA-sequenced    19.63  18306476     33254       4259170     snarrowe
#ERR6913211     P267_RNA_S57_L001  P267          RNA  Nasopharyngeal  SARS-CoV-2 positive  Symptomatic-cDNA-sequenced   19.63  17691576     39562       4503540     snarrowe
#ERR6913117     P272_DNA_S40_L001  P272          DNA  Nasopharyngeal  SARS-CoV-2 positive  Symptomatic-DNA-sequenced    21.34  24205196     397186      50556736    snarrowe
#ERR6913213     P272_RNA_S75_L001  P272          RNA  Nasopharyngeal  SARS-CoV-2 positive  Symptomatic-cDNA-sequenced   21.34  26128248     31868       3373346     snarrowe
#ERR6913111     P090_DNA_S25_L001  P90           DNA  Nasopharyngeal  SARS-CoV-2 positive  Symptomatic-DNA-sequenced    26.98  27646936     33240       4397612     snarrowe
#ERR6913207     P090_RNA_S29_L001  P90           RNA  Nasopharyngeal  SARS-CoV-2 positive  Symptomatic-cDNA-sequenced   26.98  25216066     9240        1151286     snarrowe


# It looks like the reads are untrimmed since they add up to the samples taken from the ncbi database

# I ran this command to see if any duplicates would be removed, none were found 
# srun --cpus-per-task=1 --time=24:00:00 xargs seqkit --threads 1 rmdup $seqs_path/*.gz >> $analyses/duplicates.txt

# My guess is that we want to keep duplicates since this could mean having multiple pathogens
#module load seqkit

# Look for whole adapter 1 
#srun --cpus-per-task=1 --time=00:10:00 seqkit --threads 1 grep $seqs_path/*.gz -s -i -p AGATCGGAAGAGCACACGTCTGAACTCCAGTCA >> $analyses/adapter1.txt
# Look for whole adapter 2
#srun --cpus-per-task=1 --time=00:10:00 seqkit --threads 1 grep $seqs_path/*.gz -s -i -p AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT >> $analyses/adapter2.txt

# I was able to find hits with the following trimmed adapter 1
#srun --cpus-per-task=1 --time=00:10:00 seqkit --threads 1 grep $seqs_path/*.gz -s -i -p AGATCGGAAGAGCACACGTCTG | wc -l
# I was able to find hits with the following trimmed adapter 2
#srun --cpus-per-task=1 --time=00:10:00 seqkit --threads 1 grep $seqs_path/*.gz -s -i -p AGATCGGAAGAGCGTCGTGTAGGG | wc -l

# I'm not how this can be interpreted but it seems likely that they might not have been trimmed of the adapters. At the same time the whole adapters were not found so they could also have been trimmed of the adapters

# Part 4
# mkdir $analyses/fastqc
fastqc=$analyses/fastqc

# Load the fastqc module and run the command with the required constraints
#module load fastqc
#srun --cpus-per-task=2 --time=00:10:00 fastqc --outdir $fastqc --threads 2 --noextract $seq1 $seq2
#sacct --format=JobID,JobName%20,ReqCPUS,ReqMem,Timelimit,State,ExitCode,Start,elapsed,MaxRSS,NodeList,Account%15
# would have been enough with one minute
#srun --cpus-per-task=2 --time=00:10:00 xargs -I{} -a $analyses/snarrowe_run_accessions.txt fastqc --outdir $fastqc --threads 2 --noextract $seqs_path/{}_1.fastq.gz $seqs_path/{}_2.fastq.gz 

# Part 5 

# They seem to have been trimmed of bases with low quality since all of the base pairs are in the green zone (also here we can see that
# the coding for the base quality is indeed in Sanger encoding), they have also been trimmed of adapter content according to the fastqc
# report
# used the following command on my computer
# scp snarrowe@core.cluster.france-bioinformatique.fr:/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/analyses/fastqc/*.html .
# Skip part 6 - might try oyr some other time

# Part 7 
module load flash2
#mkdir $data/merged_pairs
m_pairs=$data/merged_pairs

#srun --cpus-per-task=2 flash2 --threads=2 -z --output-directory=$m_pairs --output-prefix=test.flash \
#$seq1 $seq2 2>&1 | tee -a $analyses/snarrowe_flash2_test.log

# Percent combined:  94.35%
# [FLASH] WARNING: An unexpectedly high proportion of combined pairs (82.39%)
# overlapped by more than 65 bp, the --max-overlap (-M) parameter.  Consider
# increasing this parameter.  (As-is, FLASH is penalizing overlaps longer than
# 65 bp when considering them for possible combining!)

module load seqkit
#seqkit stat $m_pairs/test.flash.extendedFrags.fastq.gz
# Output: 
#file                                                                                                          format  type  num_seqs    sum_len  min_len  avg_len  max_len
#/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/merged_pairs/test.flash.extendedFrags.fastq.gz  FASTQ   DNA     18,664  2,308,617       35    123.7      292

# I'm not sure how to interpret the histogram-plot but ut seems that most of DNA library sizes were between 80-151 

#srun --cpus-per-task=2 --time=00:30:00 xargs -a $analyses/snarrowe_run_accessions.txt -n 1 -I{} flash2 --threads=2 -z \
#--output-directory=$m_pairs --output-prefix={}.flash $seqs_path/{}_1.fastq.gz $seqs_path/{}_2.fastq.gz 2>&1 | tee -a snarrowe_flash2.log 
#sk_fl_out=$m_pairs/seqkit_flash_output.log
#srun --time=00:10:00 xargs -a $cripts/snarrowe_run_accessions.txt -n 1 -I{} seqkit stat  $seqs_path/{}_1.fastq.gz >> $sk_fl_out 
#srun --time=00:10:00 xargs -a $scripts/snarrowe_run_accessions.txt -n 1 -I{} seqkit stat  $seqs_path/{}_2.fastq.gz >> $sk_fl_out
#srun --time=00:10:00 xargs -a $scripts/snarrowe_run_accessions.txt -n 1 -I{} seqkit stat $m_pairs/{}.flash.extendedFrags.fastq.gz >> $sk_fl_out
# There seems to be some redundant information since the lengths seem to be about the same for the individual sequences and the merged flash sequences

# Part 8
#mkdir $data/reference_seqs
ref_seqs=$data/reference_seqs

# installed this in my home_dir sh -c "$(wget -q ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh -O -)"

# Fetch the Phix genome
#efetch -db nuccore -id NC_001422 -format fasta > $ref_seqs/PhiX_NC_001422.fna
module load bowtie2

#mkdir $data/bowtie2_DBs
bt2_DB=$data/bowtie2_DBs
#srun bowtie2-build -f $ref_seqs/PhiX_NC_001422.fna $bt2_DB/PhiX_bowtie2_DB

#mkdir $analyses/bowtie
ana_bt=$analyses/bowtie
# Run bowtie2 with file-globbing
#srun --cpus-per-task=8 --time=00:30:00 bowtie2 -x $data/bowtie2_DBs/PhiX_bowtie2_DB \
#-S $ana_bt/snarrowe_merged2PHIX.sam --threads 8 --no-unal 2>&1 \
#-U $m_pairs/*.extendedFrags* | tee $ana_bt/snarrowe_bowtie_merged2PhiX.log 
# I got no hits to PhiX

# Check covid hits
# Fetch the covid genome
#efetch -db nuccore -id NC_045512 -format fasta > $ref_seqs/SC2_NC_045512.fna

# Build database
#srun bowtie2-build -f $ref_seqs/SC2_NC_045512.fna $bt2_DB/SC2_bowtie2_DB

# Check for hits with file globbing 
#srun --cpus-per-task=8 --time=00:10:00 bowtie2 -x $data/bowtie2_DBs/SC2_bowtie2_DB \
#-S $ana_bt/snarrowe_merged2SC2.sam --threads 8 --no-unal 2>&1 \
#-U $m_pairs/*.extendedFrags* | tee $ana_bt/snarrowe_bowtie_merged2SC2.log
# Output: 
#2063234 reads; of these:
#  2063234 (100.00%) were unpaired; of these:
#    2057326 (99.71%) aligned 0 times
#    5908 (0.29%) aligned exactly 1 time
#    0 (0.00%) aligned >1 times
#0.29% overall alignment rate
# Seems like there was a hit between some sample and the covid genome! 
# was hard to read output

# Part 9 
module load multiqc

srun multiqc --force --title "snarrowe sample sub-set" $m_pairs $fastqc $m_pairs/snarrowe_flash2.log $ana_bt

#Used the following command on my computer
#scp snarrowe@core.cluster.france-bioinformatique.fr:/shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/snarrowe-sample-sub-set_multiqc_report.html .
# works really well!! 

end=`date +%s.%N`
echo "$start $end" | awk '{print $2 - $1}'
echo "script end"







 


