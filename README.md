## circDiscoverer
circDiscoverer is a comprehensive database for exploring circRNA-Protein interactions.

## Downloading Accession from NCBI-SRA
The script used for downloading the accession of any sequencing runs from the NCBI-SRA using the sra-toolkit is SRA2.sh.
Briefly, to download the accessions using this script, users need to make a tab-separated text file called sra.text. E.g. if i want to download the run accessions of the CLIP data of a protein called FUS, the sra.text will contain as follows:

SRR11539497     FUS

More importantly, the sra-toolkit will automatically download the cleaned paired or single ended fastq file with low quality reads and adaptors trimmed using fastp.

## Running CIRI2 on the fastq file obtained

BWA2
