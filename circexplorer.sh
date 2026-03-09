CIRCexplorer2 parse -t STAR Chimeric.out.junction > CIRCexplorer2_parse.log
CIRCexplorer2 annotate -r hg19_ref_all.txt -g hg19.fa -b back_spliced_junction.bed -o circularRNA_known.txt > CIRCexplorer2_annotate.log
awk '{print $1 "\t" $2+1 "\t" $3 "\t" $6 "\t" $13}' circularRNA_known.txt > ram.bed
liftOver ram.bed hg19ToHg38.over.chain ram_hg38.bed ram_unmapped.bed
awk 'NR==FNR {
        key=$1"-"$2"-"$3"-"$4;     
        id[key]=$5;               
        next
     }
     {
        key=$1"-"$2"-"$3"-"$4;
        if (key in id)
            print $0, id[key];
     }' human_bed_v3.0.txt ram_hg38.bed

rm *.bed Chimeric.out.junction circularRNA_known.txt *.log
