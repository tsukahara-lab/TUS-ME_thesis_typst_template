#!/bin/bash

file=$1
hash1=$2
output="diff.pdf"

mkdir -p .diff
git archive "$hash1" | tar -x -C .diff

touch diff.typ
cat <<EOF > diff.typ
#import "style/diff-doc/lib.typ": *
#diff-content(
  include ".diff/$file",
  include "$file"
)
EOF

typst compile diff.typ "$output"

rm -r .diff
rm diff.typ
