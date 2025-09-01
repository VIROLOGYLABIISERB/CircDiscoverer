#!/bin/bash



for fasta in *.fasta; do
   gene="${fasta%.fasta}"
        echo "$fasta files are found"

    # Convert to backsplice and append to backsplice.fa
    awk '{if(NR==1) {print $0} else {if($0 ~ /^>/) {print "\n"$0} else {printf $0}}}' "$fasta" | \
    awk -v OFS="\n" '/^>/ {getline seq}{L=length(seq); L2=int(L/2); print $0, substr(seq,L2+1) substr(seq,1,L2)}' >> ${gene}.backsplice.fa

    #################### Shorten the backsplice target sequence to 150bp library ########################################
    awk -v OFS="\n" '/^>/ {getline seq}{print $0,substr(seq,length(seq)/2-25,50)}' ${gene}.backsplice.fa  >> ${gene}.backsplice.50bp.fa
    sudo rm "${gene}.backsplice.fa"
done

