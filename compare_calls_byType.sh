#!/bin/bash

set -e 
#set -o xtrace

# read the configuration variables
source config.sh

function rmc() {
    rm -rf .cache
}
export -f rmc;


# get all calls except Hum ... then Pred, Rapt, Desc can be compared
awk -F, '{if($3 != "Hum"){print $0}}' $info_input_file > all.csv

# extract info for lstm-autoencoder
export h="filename,start,end,label"

function do_all() {
    export t=$1

    rmc
    echo $h > ${t}_annot.csv
    awk -F, '{printf("%s/%s,%f,%f,%s\n", d, $1, $4, $5, $3)}' d=$wav_dir ${t}.csv >> ${t}_annot.csv
    extract_features -o ${t}_rawfeat.csv ${t}_annot.csv $algorithm_conf
    max_frame=$(awk -F, '{print NF-1}' ${t}_rawfeat.csv | sort -un | tail -n 1)
    reduce_features ${t}_rawfeat.csv $algorithm_conf -r tripletloss --standard_scaler \
        --save_model -m $max_frame -o ${t}_tripletloss.csv
}
export -f do_all;

do_all all

compute_abx all_tripletloss.csv --col_on 1 --col_features 2-11 > all_tripletloss_abx.csv

