# Main Hawaiian Islands Deep 7 2024 Assessment
This repository hosts the materials needed to run the base case model for the Deep 7 2024 stock assessment report. 

## Set up  
There are two recommended ways to run the code, locally on your personal computer or in the repository using the codespaces.  
#### Codespaces 
The Codespaces environment allows you to run all model code using a virtual machine and all necessary packages are pre-loaded in the environment. There is no setup involved with this method and is the recommended approach. 

To open an instance of codespaces, in the repository [main page](https://github.com/PIFSCstockassessments/Deep7-2024-WPSAR/tree/main) click the green `Code` dropdown button. Select the green `Create codespace on main` button. It will take a few minutes for a machine to load and you will see an instance of VS code open when it has loaded. At the bottom a terminal window will open and in the right corner you can click the `+` dropdown button and where will be an option to open an R terminal. Open the R terminal (you will see `r$>` in the terminal to indicate you in R) and in the left-hand menu click the Explorer button (top button with paper icon) and navigate to `Scripts/run_jabba_general.R`. Open the script by double-clicking on the file and you can run the code line by line using the `ctrl+enter` key shortcut. 

If you prefer to work in RStudio, in the bash terminal window (not R terminal), type `rserver` and when prompted open in the brower. This will open a session of RStudio Server. Code and files can be run and interacted with as in a regular RStudio workspace. 


#### Local Machine
To run locally, you will need to make sure you have the latest version of [JAGS](https://sourceforge.net/projects/mcmc-jags/) installed on your computer and clone the [Deep7-2024-WPSAR](https://github.com/PIFSCstockassessments/Deep7-2024-WPSAR) repository or download as [main.zip](https://github.com/PIFSCstockassessments/Deep7-2024-WPSAR/archive/refs/heads/main.zip). R code can be run locally using your preferred R IDE.

If you do not wish to install JAGS, you can run all the code in a virtual machine through the Github Codespaces. 

## Inputs  

### Data 
All necessary data files are stored in `./Data`: 
    
* CPUE.csv (annual values for FRS and BFISH indices: columns YEAR, FRS, BFISH)
* SE.csv (annual log SE values for FRS and BFISH indices respectively: columns YEAR, FRS, BFISH)
* Total_catch.csv (annul total catch in pounds)

### Model parameter inputs
Parameter values for model input (to specify `build_jabba()`) are stored in `./Data/JABBA_inputs.csv`. 

## Running the Model  
Use the R script `./Scripts/run_jabba_general.R` to read in all data, run the base case model, run a summary output report, and run projections. 

*Note* You need to have installed the [PIFSC-dev branch](https://github.com/PIFSCstockassessments/JABBA/tree/PIFSC-dev) of the JABBA package to run the model locally. This is already installed in the Codespaces. 

```
remotes::install_github("PIFSCstockassessments/JABBA", ref="PIFSC-dev")
```

Descriptions of all modifications and additions to the JABBA code can be found in the README of the [JABBA repository](https://github.com/PIFSCstockassessments/JABBA/tree/PIFSC-dev).


## Github Disclaimer

This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.
