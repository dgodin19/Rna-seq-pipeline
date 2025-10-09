#!/usr/bin/env python
import pandas as pd
import argparse
from pathlib import Path

parser = argparse.ArgumentParser(description='This script concatenates all the exon.txt files')
parser.add_argument('-i', dest='input', help='Input should be a exon.txt file', required=True)
parser.add_argument('-o', dest='concatenated', help='Name of output file containing the concatenated counts', required=True)
args = parser.parse_args()

input_dir = Path(args.input)
count_files = list(input_dir.glob("*.exon.txt"))
if not count_files:
    raise FileNotFoundError(f"No .exon.txt files found in {input_dir}")

merged_df = None

for f in count_files:
    sample_name = f.stem  
    df = pd.read_csv(f, sep="\t")
    if "gene" not in df.columns or "count" not in df.columns:
        raise ValueError(f"File {f} does not contain required columns: gene, count")
    df = df.set_index("gene")
    df.rename(columns={"count": sample_name}, inplace=True)
    if merged_df is None:
        merged_df = df
    else:
        merged_df = merged_df.join(df, how="outer")  

merged_df.fillna(0, inplace=True)
merged_df = merged_df.astype(int)

merged_df.to_csv(args.concatenated)
print(f"Concatenated counts matrix saved to {args.concatenated}")