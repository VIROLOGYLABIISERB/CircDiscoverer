#!/bin/bash

# Paths to reference genome and annotation
ref="/media/aclab/Sreeram/data/CLIP/mito/mitochondria_genome.fa"
gtf="/media/aclab/Sreeram/data/CLIP/mito/Homo_sapiens.GRCh38.104.chr.gtf"
CIRI_path="/home/aclab/CIRI_v2.0.6/CIRI2.pl"

# Check if the reference genome is indexed
if [ -f "${ref}.bwt" ]; then
    echo "The $ref file is indexed."
else
    echo "The $ref file is not indexed."
    exit 1
fi

# Process FASTQ files
for file in *_cleaned.fastq; do
    echo "Processing $file"

    # Check minimum and maximum read length
    read min max <<< $(awk 'NR%4==2 {len=length($0); if(min=="" || len<min) min=len; if(len>max) max=len} END {print min, max}' "$file")
    echo "File: $file - Min length: $min, Max length: $max"

    # Only proceed if max length >= 50
    if [ $max -lt 50 ]; then
        echo "File $file is not eligible for CIRI analysis. Max length is less than 50. Skipping."
        continue
    fi

    # Check if paired-end file exists
    if [[ "$file" == *_1_cleaned.fastq ]]; then
        gene_name="${file%_1_cleaned.fastq}"
        file2="${gene_name}_2_cleaned.fastq"

        if [ -f "$file2" ]; then
            echo "Paired-end files detected: $file and $file2"
            sam_file="${gene_name}.pe.sam"
            echo "Generating SAM file: $sam_file"
            bwa mem -T 19 "$ref" "$file" "$file2" > "$sam_file"

            echo "Running CIRI2 for $sam_file"
            perl $CIRI_path -I "$sam_file" -O "${gene_name}.Outfile" -F "$ref"
        else
            echo "Paired-end file not found for $file. Skipping paired-end processing."
        fi
    fi

    # Single-end processing
    if [[ "$file" != *"_1_cleaned.fastq" && "$file" != *"_2_cleaned.fastq" ]]; then
        gene="${file%_cleaned.fastq}"
        sam_file="${gene}.se.sam"
        echo "Generating SAM file: $sam_file"
        bwa mem -T 19 "$ref" "$file" > "$sam_file"

        echo "Running CIRI2 for $sam_file"
        perl $CIRI_path -I "$sam_file" -O "${gene}.Outfile" -F "$ref"
    fi

    # Process CIRI2 output files (excluding new_*.Outfile)
    for Outfile in $(find . -maxdepth 1 -name "*.Outfile" ! -name "new_*"); do
        Outfile=${Outfile#./}
        if [ -f "$Outfile" ]; then
            echo "Processing $Outfile"
            gene="${Outfile%.Outfile}"
            new_outfile="new_${gene}.Outfile"
            cut -f1 "$Outfile" > "$new_outfile"
        else
            echo "No .Outfile found for $file. Skipping."
        fi
    done

done

