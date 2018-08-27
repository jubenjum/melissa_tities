To run the scripts you need to have installed python, I found that 
the simplest way to get all running is to install
[anaconda](https://www.anaconda.com/download/) as it manages all 
packages dependencies. After installing anconda you can do the following steps
to get the all requirements[1]:

1. Create an environment to run the packages:

    $ conda create -n monkeys
    $ source activate monkeys

2. Install the packages

    $ conda install -c primatelang easy_abx mcr

If succeed, now you should be able to run the script `run.sh`, that does all
the job of feature extraction, transforming and shrinking the features, etc.

/!\ You may need to change the `config.sh` file with your wav file directory paths
and input files.

The main input file is `input.csv`, that file contains all data 
that you gave me in the excel file, to include new or update your data you 
can modify/rebuild that file. 

Other files that are important for running the script are

- algorithms.json: configuration file of the data reduction algorithms,
  from this file you may need to change the parameters: "epochs" and "batch_size", 
  in  'KR_TripletLoss' in case of heavily increase the number of samples.

- SPECTRAL_STACKFREE_NFILT40_c74e01.cfg: configuration of feature extraction, 
  here you can change the dimension reduction size and the spectral features
  that you will extract.


The results are from the script `compare_calls_bySex.sh`:

- {female,male,bothSex}_rawfeat.csv: are the raw features split by sex.

- {female,male,bothSex}_tripletloss.csv: the reduced dimension features. 

- {female,male,bothSex}_tripletloss_abx.csv: the results of ABX scores for Desc and Pred 
  and split by sex.


From the script `compare_calls_byType.sh`:

- all_rawfeat.csv: raw features 

- all_tripletloss.csv: reduced dimension features build to separate Desc, Pred and Rapt calls 

- all_tripletloss_abx.csv: ABX scores for the calls Desc, Pred and Rapt


plot_comp_hum.ipynb and plot_features.ipynb are jupyter notebook that I made
to generate the figures. The other files are intermediary.

[1] Note that all requirements are build for recent versions of Linux and OSX
