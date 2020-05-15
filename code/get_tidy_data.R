#covis
#Data current as of May 22, 2019
#All information is confidential
############################################################

#Run if  not as part of the driver script: rm(list = ls())
library(tidyverse)
library(readxl)
library(lubridate)
library(qwraps2)


#1 Import and format metadata file

#Step 1> Read in and modify taxonomy data
data <- read_csv(file='Matherne_LSU_COVIS_1998_2017_working.csv') 

%>%
  rename_all(tolower) %>%
  mutate(taxon=str_replace_all(string=taxon, pattern="\\D_\\d*\\__", replacement="")) %>%
  mutate(taxon=str_replace_all(string=taxon, pattern=";$", replacement="")) %>%
  #mutate(taxon=str_replace_all(string=taxon, pattern="", replacement="NA")) %>%
  separate(taxon, into=c("kingdom", "phylum", "class", "order", "family", "genus", "species"), sep=";") %>%
  select(-confidence) %>%
  mutate_if(is.character, list(~na_if(.,""))) %>% #Replaces several positions that only had "" with NA
  glimpse()

#Step 2> Read in and modify feature table

SVs <- read_qza('data/qiime/table.qza')

otu_data <- as_tibble(SVs$data, rownames='feature id') %>% #rownames needs to match the variable in taxonomy file
  gather(-'feature id',key='sample',value='count')

# Review OTU abundance data and calculate relative abundance based on max count
otu_data %>% group_by(sample) %>% summarize(n=sum(count)) %>% summary()
otu_data <- otu_data %>% mutate(rel_abund=count/222543)


#Step 3> Read in metadata file
long <- read_tsv('data/references/long-metadata.tsv') %>%
  slice(-1) 
  
write_tsv(long,'data/references/sample-metadata')
metadata <- read_tsv('data/references/sample-metadata',col_types = cols(
  `#SampleID` = col_character(),
  BarcodeSequence = col_character(),
  LinkerPrimerSequence = col_character(),
  Site = col_character(),
  Year = col_integer(),
  Month = col_integer(),
  Station = col_character(),
  Avg_Sal = col_character(),
  Temp = col_double(),
  Salinity = col_double(),
  CHLA = col_double(),
  TSS = col_double(),
  Event = col_character(),
  Time = col_integer(),
  studyid = col_character(),
  Description = col_character()
)) %>% rename_all(tolower) %>% rename(sample=`#sampleid`) %>%
  select(-barcodesequence, -linkerprimersequence, -description)
metadata$time <- if_else(metadata$time <= 1, 'before', 'after')

