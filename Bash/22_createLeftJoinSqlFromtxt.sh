#!/bin/sh

source_dirs="./"

find $source_dirs -type f -name \*.txt | while read -r var; do

    # echo ${var}
    grep -E "^SELECT" ${var} | while read -r select_line ; do
        # echo "Select is $line"
        select_col=`echo ${select_line} | sed -e "s/\(SELECT\)\(.\+\)\(FROM \)\(.\+\)\(WHERE.\+\)/\2/g"`
        select_tbl=`echo ${select_line} | sed -e "s/\(SELECT\)\(.\+\)\(FROM \)\(.\+\)\(WHERE.\+\)/\4/g"`
        echo ${select_col}
        echo ${select_tbl}

    done

done
