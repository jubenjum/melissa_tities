#!/bin/bash

set -e 
#set -o xtrace

# read the configuration variables
source config.sh


function rmc() {
    rm -rf .cache
}
export -f rmc;


#others
awk -F, '{if($2 == "NA"){print $0}}' $info_input_file > female.csv

awk -F, '{if($2 == "F" && $3 != "Hum"){print $0}}' $info_input_file > female.csv
awk -F, '{if($2 == "M" && $3 != "Hum"){print $0}}' $info_input_file > male.csv

awk -F, '{if($2 == "F" && $3 == "Hum"){print $0}}' $info_input_file > female_hum.csv
awk -F, '{if($2 == "M" && $3 == "Hum"){print $0}}' $info_input_file > male_hum.csv

cat female.csv male.csv > bothSex.csv
cat female_hum.csv male_hum.csv > bothSex_hum.csv

# extract info for lstm-autoencoder
export h="filename,start,end,label"

function do_all() {
    export t=$1

    rmc
    echo $h > ${t}_annot.csv
    awk -F, '{printf("%s/%s,%f,%f,%s\n", d, $1, $4, $5, $3)}' d=$wav_dir ${t}.csv >> ${t}_annot.csv

    echo $h > ${t}_annot_hum.csv
    awk -F, '{printf("%s/%s,%f,%f,%s\n", d, $1, $4, $5, $3)}' d=$wav_dir ${t}_hum.csv >> ${t}_annot_hum.csv
    
    extract_features -o ${t}_rawfeat.csv ${t}_annot.csv $algorithm_conf
    extract_features -o ${t}_rawfeat_hum.csv ${t}_annot_hum.csv $algorithm_conf
    
    rawfeat=$(awk -F, '{print NF-1}' ${t}_rawfeat.csv | sort -un | tail -n 1)
    rawfeat_hum=$(awk -F, '{print NF-1}' ${t}_rawfeat_hum.csv | sort -un | tail -n 1)
    max_frame=$(echo -e $rawfeat'\n'$rawfeat_hum | sort | tail -n 1)
    
    reduce_features ${t}_rawfeat.csv $algorithm_conf -r tripletloss --standard_scaler \
        --save_model -m $max_frame -o ${t}_tripletloss.csv
    
    reduce_features ${t}_rawfeat_hum.csv $algorithm_conf -r tripletloss --standard_scaler \
        --pretrained ${t}_tripletloss.csv.hdf5 -m $max_frame -o ${t}_tripletloss_hum.csv

    feature_size=`head -n 1 ${t}_tripletloss.csv | awk -F',' '{print NF}'`
        
    cat ${t}_tripletloss.csv ${t}_tripletloss_hum.csv > ${t}_tripletloss_both.csv

}
export -f do_all;

do_all female
do_all male
do_all bothSex

