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
date
echo "script end."


