## circDiscoverer
circDiscoverer is a Comprehensive Resource for exploring circRNA-Protein interactions.

## Required Softwares and tools
- sra-toolkit (https://github.com/ncbi/sra-tools)  
- bedtools (v2.26.0)  
- CIRI2 (https://ciri-cookbook.readthedocs.io/en/latest/index.html)  
- seqkit (v0.15.0)  


## Downloading Accession from NCBI-SRA (SRA2.sh)
The script used for downloading the accession of any sequencing runs from the NCBI-SRA using the sra-toolkit is SRA2.sh.
Briefly, to download the accessions using this script, users need to make a tab-separated text file called sra.text. E.g. if we want to download the run accessions of the CLIP data of a protein called FUS, the sra.text will contain as follows:

SRR11539497     FUS

More importantly, the sra-toolkit will automatically download the cleaned paired or single-ended fastq file with low-quality reads and adaptors trimmed using fastp.

## Running CIRI2 on the fastq file obtained (BWA2.sh)

After the fastq files are obtained, they can be subjected to running CIRI2 to determine the circRNA using the script called BWA2.sh. Briefly, this script automatically analyzes the obtained single and paired-end reads to determine the length range within them. If the minimum length range of the reads in the files is less than 50nt, then this script can't run CIRI2 on it, if the length of reads is more than 50, then CIRI2 is executed on it, giving the respective output.

## Script to obtain shortened backsplice junction (backsplice.sh)

The script, i.e., backsplice.sh, is used to obtain shortened backsplice junction. Briefly, any circRNA of any length, eg, 1000, 2000 or 10,000nt length range, when passed into the backsplice.sh script in the final produces a uniform shortened equal length of the circRNA, in which the middle or half of the shortened length contains the backsplice junction.

The part in the script, i.e., "(seq,length(seq)/2-25,50)}" can be varied according to the users. In this e.g., if we pass any length of circRNA in this script, in final, we will get 50 nt length of all the circRNAs with the middle portion, i.e., 25th position containing the backsplice junction.


## Script to design guide RNAs (gRNA.sh)

Once the shortened backsplice junction of all the circRNAs is obtained, with the users knowing where the backsplice junction is present, then the users can design guide RNAs of various lengths covering the backsplice junction.

E.g., in the code in the script, i.e., awk '/^>/ {print; next} {print substr($0, 30, 23)}' "$files" > "${gene}_1.sgrna.fa", it means starting from 30th position in the shortened backsplice junction read, we need 23nt guide RNA. Likewise, the script can be adjusted according to the users.


## Script to scan RNA motifs of proteins in the circRNA (find.py)

To scan the RNA motifs in the circRNA sequences, the script is find.py. Briefly, users first need to make tab tab-separated file called motif.text. The column 1 of the file will be Motif, where we take the repective motif sequences and column 2 will be hgnc_symbol, where ahead of the motif sequences will be the name of the proteins corresponding to the motifs


Here, the Motif column represents the RNA motifs, and the hgnc_symbol represents the name of the Protein.


## Script to find circRNAs using circExplorer2 after running the STAR through MAP.sh
After running the script MAP.sh, whatever chimeric junction file we will obtain, just rename each of the chimeric junction file to Chimeric.out.junction and run the circexplorer.sh, which will list all the circRNAs detected by circExplorer2




