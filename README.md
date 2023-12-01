# Main Hawaiian Islands Deep 7 2024 Assessment
This repository hosts the materials needed to run the base case model for the Deep 7 2024 stock assessment report. 

To start, clone the [Deep7-2024-WPSAR](https://github.com/PIFSCstockassessments/Deep7-2024-WPSAR) repository or download as [main.zip](https://github.com/PIFSCstockassessments/Deep7-2024-WPSAR/archive/refs/heads/main.zip). 

## Inputs  

### Data 
All necessary data files are stored in `./Data`: 
    
* CPUE.csv (annual values for FRS and BFISH indices: columns YEAR, FRS, BFISH)
* SE.csv (annual SE and CV values for FRS and BFISH indices respectively: columns YEAR, FRS, BFISH)
* Total_catch.csv (annul total catch in pounds)

### Model parameter inputs
Parameter values for model input (to specify `build_jabba()`) are stored in `./Data/JABBA_inputs.csv`. 

## Running the Model  
Use the R script `./Scripts/run_jabba_general.R` to read in all data, prepare the data for JABBA, run the base case model, run a summary output report, and run projections. 
*Note* You need to have installed the [PIFSC-dev branch](https://github.com/PIFSCstockassessments/JABBA/tree/PIFSC-dev) to run the model. Descriptions of all modifications and additions to the JABBA code can be found in the README of the [JABBA repository](https://github.com/PIFSCstockassessments/JABBA).

## Github Disclaimer

This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.
