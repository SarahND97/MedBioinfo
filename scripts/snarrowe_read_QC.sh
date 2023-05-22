#!/bin/bash

echo "script start: download and initial sequencing read quality control"
date

sqlite3 -batch -noheader -csv  /shared/projects/2314_medbioinfo/pascal/central_database/sample_collab.db "select run_accession from sample_annot spl left join sample2bioinformatician s2b using(patient_code) where username='snarrowe'" >> snarrowe_run_accessions.txt

# Test fastq-dump command
fastq-dump -X 10 --readids --gzip --outdir . --disable-multithreading --split-e ERR6913103

# Combine srun and xargs to fastq-dump all accession-ids
cat snarrowe_run_accessions.txt | srun --cpus-per-task=1 --time=00:40:00 xargs fastq-dump -X 10 --gzip --outdir /shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq --disable-multithreading --readids  --split-e

# Count the number of reads in a fastq.gz file without unzipping it, can also use zcat
echo $(gzip -d -c ERR6913103_1.fastq.gz | wc -l)/4|bc
# This command should also work
zgrep "@" ERR6913103_1.fastq.gz | wc -l

# The sequences are in the  Sanger standard format since fastq-dump converts all data to this format according to the linked wikipedia article

# Check if module is available
module avail | grep "seqkit" 
module load seqkit

# Print stats on each file 
cd /shared/home/snarrowe/medbioinfo_folder/sarah/MedBioinfo/data/sra_fastq
ls |  srun --cpus-per-task=1 --time=00:01:00 xargs seqkit --threads 1 stats
# Compared that with 
# sqlite3 -batch /shared/projects/2314_medbioinfo/pascal/central_database/sample_collab.db "select * from sample_annot spl left join sample2bioinformatician s2b using(patient_code) where username='snarrowe'" seems to be a huge difference in the number of reads

# I ran this command to see if any duplicated would be removed and none were, this suggest that duplicates have already been removed
ls |  srun --cpus-per-task=1 --time=00:01:00 xargs seqkit --threads 1 rmdup >> test.txt

# My guess is that we want to keep duplicates since this could mean having multiple pathogens

# Look for whole adapter 1 
sra_fastq]$ ls |  srun --cpus-per-task=1 --time=00:01:00 xargs seqkit --threads 1 grep -s -i -p AGATCGGAAGAGCACACGTCTGAACTCCAGTCA >> adapter1.txt
# Look for whole adapter 2
ls |  srun --cpus-per-task=1 --time=00:01:00 xargs seqkit --threads 1 grep -s -i -p AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT >> adapter2.txt

# Had to trim the adapter a lot before I got any hits, but I got hits for adapter 2 with this short of an adapter
ls |  srun --cpus-per-task=1 --time=00:01:00 xargs seqkit --threads 1 grep -s -i -p AGATCG >> adapter2_tiny.txt
# But when something is trimmed down this much it could also be coincidence
#Checked how many with the following command 
cat adapter2_tiny.txt | grep "@" | wc -l # output: 28
# Doing the same thing for adapter2 gave output 8

# My guess is that they have already been trimmed

# Part 4

date
echo "script end."


