#!/home/aclab/miniconda3/bin/python3

import re
import csv
import sys

# File paths
fasta_file = "human_sequence.backsplice.100bp.fa"  # Update with actual file path
motif_file = "motif.text"  # Update with actual file path
output_file = "RBP.txt"

# Dictionary to store motifs and their associated HGNC symbols
motifs_dict = {}

# Read the motif file
with open(motif_file, "r") as file:
    next(file)  # Skip header line
    for line in file:
        parts = line.strip().split("\t")  # Assuming tab-separated
        if len(parts) == 2:
            motif, hgnc_symbol = parts
            motifs_dict[motif] = hgnc_symbol

# Open the output file and write the header
with open(output_file, "w") as out:
    header_line = f"{'Sequence Header':<20} {'Motif':<10} {'HGNC Symbol':<10} {'Occurrences':<10}\n"
    separator_line = "=" * 60 + "\n"
    out.write(header_line)
    out.write(separator_line)

    # Print the header immediately
    print(header_line, end="")
    print(separator_line, end="")
    sys.stdout.flush()  # Ensure immediate printing

    # Read and process the FASTA file
    with open(fasta_file, "r") as file:
        header = None
        sequence = []

        for line in file:
            line = line.strip()
            if line.startswith(">"):  # New sequence header
                if header and sequence:  # Process previous sequence
                    seq_str = "".join(sequence)
                    for motif, hgnc_symbol in motifs_dict.items():
                        count = len(re.findall(f"(?={motif})", seq_str))
                        if count > 0:
                            result_line = f"{header:<20} {motif:<10} {hgnc_symbol:<10} {count:<10}\n"
                            out.write(result_line)
                            print(result_line, end="")
                            sys.stdout.flush()  # Print immediately
                header = line[1:]  # Store new header (remove ">")
                sequence = []  # Reset sequence storage
            else:
                sequence.append(line)  # Collect sequence lines

        # Process the last sequence in the file
        if header and sequence:
            seq_str = "".join(sequence)
            for motif, hgnc_symbol in motifs_dict.items():
                count = len(re.findall(f"(?={motif})", seq_str))
                if count > 0:
                    result_line = f"{header:<20} {motif:<10} {hgnc_symbol:<10} {count:<10}\n"
                    out.write(result_line)
                    print(result_line, end="")
                    sys.stdout.flush()  # Print immediately

# Print completion message
print(f"\nResults saved in {output_file}")

