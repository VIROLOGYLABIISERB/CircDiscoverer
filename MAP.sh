#!/bin/bash

INPUT_DIR="/media/aclab/Sreeram/"
OUT_DIR="/media/aclab/Sreeram/"
STAR_INDEX_DIR="/media/aclab/Sreeram/udemy/index/hg19/"

# Loop to process paired-end files
for files in ${INPUT_DIR}/*_1_cleaned.fastq; do
    file2="${files/_1_cleaned.fastq/_2_cleaned.fastq}"

    # Check if the paired-end file exists
    if [[ -f "$file2" ]]; then
        basename=$(basename "${files%_1_cleaned.fastq}")
        echo "BAM file will be ${OUT_DIR}${basename}.bam"
        echo "The PE files $files and $file2 are present"

        # Run STAR for paired-end files
        STAR --runThreadN 8 \
        --readFilesIn "$files" "$file2" \
        --genomeDir "$STAR_INDEX_DIR" \
        --outSAMtype BAM SortedByCoordinate \
        --chimOutType Junctions \
        --chimSegmentMin 10 \
        --chimJunctionOverhangMin 10 \
        --outFileNamePrefix "${OUT_DIR}${basename}_"


        # Rename the output BAM file
        mv "${OUT_DIR}${basename}_Aligned.sortedByCoord.out.bam" "${OUT_DIR}${basename}.bam"
        echo "The bam file now is ${OUT_DIR}${basename}.bam"
        mv "${OUT_DIR}${basename}_Chimeric.out.junction" "${OUT_DIR}${basename}_chimeric.junction"
        echo "Chimeric junctions saved as ${OUT_DIR}${basename}_chimeric.junction"

    fi
done

# Loop to process single-end files
for single_file in ${INPUT_DIR}/*.fastq; do
    if [[ "$single_file" != *_1_cleaned.fastq && "$single_file" != *_2_cleaned.fastq ]]; then
        basename=$(basename "${single_file%.fastq}")
        echo "BAM file will be ${OUT_DIR}${basename}.bam"
        echo "The SE file $single_file is present"

        # Run STAR for single-end files
        STAR --runThreadN 8 \
        --readFilesIn "$single_file" \
        --genomeDir "$STAR_INDEX_DIR" \
        --outSAMtype BAM SortedByCoordinate \
        --chimOutType Junctions \
        --chimSegmentMin 10 \
        --chimJunctionOverhangMin 10 \
        --outFileNamePrefix "${OUT_DIR}${basename}_"

        # Rename the output BAM file
        mv "${OUT_DIR}${basename}_Aligned.sortedByCoord.out.bam" "${OUT_DIR}${basename}.bam"
        echo "The bam file now is ${OUT_DIR}${basename}.bam"
        mv "${OUT_DIR}${basename}_Chimeric.out.junction" "${OUT_DIR}${basename}_chimeric.junction"
        echo "Chimeric junctions saved as ${OUT_DIR}${basename}_chimeric.junction"

    fi
done
