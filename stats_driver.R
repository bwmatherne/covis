################################################################################
#
# stats_driver.R
#
# R script for taking QIIME2 output and conducting indepth statistics
#
# Dependencies:   metadata, taxonomy, and feature table files from qiime2
#									
#									
# Produces:       results/figures/?????
#
################################################################################

# Clear the Environment
rm(list = ls())
# Load R Dependencies
library(BiocManager)
BiocManager::install() #The install() command ensures that the latest version of each package are used

library(tidyverse)
library(biomformat)
library(vegan)
library(devtools)
library(qiime2R)

# Put lipstick on a pig (tidy up the data)
source('code/get_tidy_data.R')
source('code/get_subset_data.R')

# Join tidy data and investigate differences in top phyla between BB and BS
source('code/get_phylum_data.R')

# Deeper analyses of phyla data between BB and BS
source('code/phyla_test.R')

# Salinity based at deepest taxonomic position
source('code/deep_taxa.R')

# Taxonomy of individual events
source('code/subset_deep_taxa.R')
#Freshwater diversion
source('code/deep_cfwd.R') # Left off trying to convert to BACI -----> Need to retry with get_baci


# Qiime2 to R: Exploratory Stats and creation of phyloseq object
## This script will clear the Global Env before running
source('code/qiime_2_r.R')

# BACI Script
## This script uses otu data and shannon values from QIIME2
## First pass did not separate data between BS & BB or by salinity 
## > Did not find significant difference for any event by OTU or shannon
source('code/get_baci.R')

# Relationship of Vibrio and BALO
# Dependent upon output from XXX script
source('code/BALOvVibrio.R')





