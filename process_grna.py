#!/home/aclab/miniconda3/bin/python3

import glob
import random
import re
from collections import defaultdict

# ---------- CHECK SAFE / DANGER ----------
def check_status(seq):
    if "T"*5 in seq:
        return "DANGER"
    for base in ["A", "C", "G"]:
        if base*6 in seq:
            return "DANGER"
    return "SAFE"

# ---------- GC FILTER ----------
def gc_percent(seq):
    seq = seq.upper()
    gc = seq.count("G") + seq.count("C")
    return (gc / len(seq)) * 100 if len(seq) > 0 else 0

# ---------- FIND HOMOPOLYMER ----------
def find_homopolymer_positions(seq):
    positions = set()
    patterns = {
        "T": r"T{5,}",
        "A": r"A{6,}",
        "C": r"C{6,}",
        "G": r"G{6,}",
    }
    for pat in patterns.values():
        for match in re.finditer(pat, seq):
            start, end = match.span()
            positions.update(range(start, end))
    return positions

# ---------- MUTATE DANGER (protect 14–20 inclusive) ----------
def mutate_in_homopolymer(seq, num_mutations=3, protect_start=14, protect_end=20):

    seq_list = list(seq)

    homopolymer_positions = find_homopolymer_positions(seq)

    # ✅ EXCLUDE protected region (14–20 inclusive)
    valid_positions = [
        i for i in homopolymer_positions
        if not (protect_start <= i <= protect_end)
    ]

    # nothing to mutate safely
    if not valid_positions:
        return seq

    if len(valid_positions) < num_mutations:
        num_mutations = len(valid_positions)

    positions = random.sample(valid_positions, num_mutations)

    bases = ["A", "C", "G", "T"]

    for pos in positions:
        original = seq_list[pos]
        choices = [b for b in bases if b != original]
        seq_list[pos] = random.choice(choices)

    return "".join(seq_list)

# ---------- MAIN ----------
fasta_files = glob.glob("*.fa")

for fasta in fasta_files:
    base = fasta.rsplit(".fa", 1)[0]

    safe_data = defaultdict(list)
    danger_data = defaultdict(list)

    with open(fasta) as f:
        header = None

        for line in f:
            line = line.strip()
            if not line:
                continue

            if line.startswith(">"):
                header = line[1:]
            else:
                seq = line
                status = check_status(seq)

                if status == "SAFE":
                    safe_data[header].append(seq)
                else:
                    danger_data[header].append(seq)

    # ---------- SAFE OUTPUT ----------
    with open(f"{base}_final_safe.txt", "w") as out:
        for header, seqs in safe_data.items():
            filtered = [s for s in seqs if 40 <= gc_percent(s) <= 60]
            for seq in filtered[:5]:
                out.write(f"{header}\t{seq}\tSAFE\n")

    # ---------- DANGER OUTPUT ----------
    with open(f"{base}_final_danger.txt", "w") as out:
        for header, seqs in danger_data.items():
            for seq in seqs[:5]:
                mutated = mutate_in_homopolymer(seq)
                out.write(f"{header}\t{mutated}\tDANGER_MUTATED\n")

    print(f"Processed: {fasta}")
