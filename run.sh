#!/bin/bash

# three types are selected in the following script (Rapt, Desc, Pred), Hum call is removed 
# from analysis
./compare_calls_byType.sh

# Analysis is done by sex and splitting by Hum and non-Hum calls
./compare_calls_bySex.sh
