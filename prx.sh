#!/usr/bin/bash

for f in *.txt
do
awk 'BEGIN{OFS="\t"}
function revcomp(seq,  i, rev, base) {
    rev=""
    for(i=length(seq); i>0; i--) {
        base=substr(seq,i,1)
        if(base=="A") base="T"
        else if(base=="T") base="A"
        else if(base=="G") base="C"
        else if(base=="C") base="G"
        rev=rev base
    }
    return rev
}
{
    new_col2="AAAC"$2
    rc=revcomp($2)
    new_col3="CTTG"rc
    print $1, new_col2, new_col3
}' "$f" > "${f}.modified"

rm "$f"
mv "${f}.modified" "$f"
done
