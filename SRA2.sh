#!/bin/bash

file="sra.text"
gtf="/media/aclab/Sreeram/data/CLIP/BULKSEQ/Homo_sapiens.GRCh38.112.gtf"
ref="/media/aclab/Sreeram/CLIP/BULKSEQ/Homo_sapiens.GRCh38.dna.primary_assembly.fa"

while IFS=$'\t' read -r SRR GENE; do
    echo "Processing: $SRR, GENE: $GENE"

    # Prefetch the SRA file first
    prefetch $SRR
    if [ $? -ne 0 ]; then
        echo "Error: prefetch failed for $SRR"
        continue
    fi

    # Determine whether the accession is SE or PE
    numLines=$(fastq-dump -X 1 -Z --split-spot $SRR | wc -l)

    if [ $numLines -eq 4 ]; then
        echo "$SRR is single-ended"
        single_end=true
    else
        echo "$SRR is paired-ended"
        single_end=false
    fi

    # Download and clean FASTQ files
    if [ "$single_end" = true ]; then
        fasterq-dump --progress $SRR
        Input_file="${SRR}.fastq"
        Output_file="${GENE}_cleaned.fastq"

        # Run fastp for single-end reads
        fastp -i "$Input_file" -o "$Output_file"

    else
        fasterq-dump --progress $SRR --split-files
        Input_file_R1="${SRR}_1.fastq"
        Input_file_R2="${SRR}_2.fastq"
        Output_file_R1="${GENE}_1_cleaned.fastq"
        Output_file_R2="${GENE}_2_cleaned.fastq"

        # Run fastp for paired-end reads
        fastp -i "$Input_file_R1" -I "$Input_file_R2" -o "$Output_file_R1" -O "$Output_file_R2"
    fi

    # Remove the original FASTQ files
    if [ "$single_end" = true ]; then
        rm "$Input_file"
    else
        rm "$Input_file_R1" "$Input_file_R2"
    fi

     rm -rf "$SRR"

    echo "Finished processing $SRR for gene $GENE"

done < "$file"

