#!/bin/bash

# Loop through all .100bp.fa files
for files in *.100bp.fa; do
    echo "The $files is present"

    # Extract the gene name
    gene="${files%.backsplice.100bp.fa}"

    echo "The sgrna file will be called ${gene}.sgrna.fa"

    # Generate different sgrna files for each gene
    awk '/^>/ {print; next} {print substr($0, 30, 23)}' "$files" > "${gene}_1.sgrna.fa"
    awk '/^>/ {print; next} {print substr($0, 31, 23)}' "$files" > "${gene}_2.sgrna.fa"
    awk '/^>/ {print; next} {print substr($0, 32, 23)}' "$files" > "${gene}_3.sgrna.fa"
    awk '/^>/ {print; next} {print substr($0, 33, 23)}' "$files" > "${gene}_4.sgrna.fa"
    awk '/^>/ {print; next} {print substr($0, 34, 23)}' "$files" > "${gene}_5.sgrna.fa"
    awk '/^>/ {print; next} {print substr($0, 35, 23)}' "$files" > "${gene}_6.sgrna.fa"
    awk '/^>/ {print; next} {print substr($0, 36, 23)}' "$files" > "${gene}_7.sgrna.fa"
    awk '/^>/ {print; next} {print substr($0, 37, 23)}' "$files" > "${gene}_8.sgrna.fa"
    awk '/^>/ {print; next} {print substr($0, 38, 23)}' "$files" > "${gene}_9.sgrna.fa"
    awk '/^>/ {print; next} {print substr($0, 39, 23)}' "$files" > "${gene}_10.sgrna.fa"
    awk '/^>/ {print; next} {print substr($0, 40, 23)}' "$files" > "${gene}_11.sgrna.fa"
    awk '/^>/ {print; next} {print substr($0, 41, 23)}' "$files" > "${gene}_12.sgrna.fa"
    awk '/^>/ {print; next} {print substr($0, 42, 23)}' "$files" > "${gene}_13.sgrna.fa"
    awk '/^>/ {print; next} {print substr($0, 43, 23)}' "$files" > "${gene}_14.sgrna.fa"
    awk '/^>/ {print; next} {print substr($0, 44, 23)}' "$files" > "${gene}_15.sgrna.fa"
    awk '/^>/ {print; next} {print substr($0, 45, 23)}' "$files" > "${gene}_16.sgrna.fa"
    

    # Merge all sgrna files for the gene into a single file
    cat "${gene}"_*.sgrna.fa > "${gene}_sgrna.fa"

    # Remove temporary files
    sudo rm "${gene}"_*.sgrna.fa
done

# Function to generate the reverse complement
reverse_complement() {
    echo "$1" | tr 'ATCGatcg' 'TAGCtagc' | rev
}

# Loop through all .sgrna.fa files
for sgrna_file in *_sgrna.fa; do
    echo "Processing $sgrna_file"

    gene="${sgrna_file%_sgrna.fa}"
    comp_file="${gene}_comp.sgrna.fa"

    while read -r line; do
        if [[ $line == ">"* ]]; then
            echo "$line" >> "$comp_file"
        else
            comp_seq=$(reverse_complement "$line")
            echo "$comp_seq" >> "$comp_file"
        fi
    done < "$sgrna_file"
done
