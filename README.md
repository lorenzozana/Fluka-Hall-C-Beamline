 Fluka Hall-C Beam Accounting
===============================

This code helps to create and run the simulation for beam accounting in Hall-C. The Beamline info is given from the design group through a spreadsheet. Info are modified to reflect what is needed in FLUKA (cm). 

Create an input file for FLUKA
------------------------------

Info are modified from the spreadsheet in order to get the info needed in order to create the volumes in FLUKA. Values are written in a simple text file with Start Z(cm), Stop Z(cm), Outher Radius (cm), Thickness (cm), Inner Radius(cm), Weight (lbs), Length, Material. Different bodies are created and the region separated depending of the Material. The files used at this step are:
* create_beampipe.sh 
* beampipe_design.txt

Running the different configuration in the farm
-----------------------------------------------
Different input files are created thanks from the step before for different targets (An easy switch was not possible, since was changing all the target sizes and chamber). The beam accounting has different configuration running sequentially. In order to get an integrated dose for the experiment one will need to use the convolution of all the configuration with the right weight. Regarding the activation for the material, one will need to assess the activation of the materials over the full periods with all the different configurations. From the beam accounting, these information are kept in order to run the simulations: Target, hours, current(uA), Energy(GeV) . The correct full exposure is determined using the current and the expected hours of running: In order to take into account the fact that the beam does not run 100% of the time during data-taking,  for semplicity the full beam time for each configuration is divided into 5 equal time steps, that will be separated by another equal time step where the beam does not run. A Set of N number of simulations will be run for each configuration and the final activation window will be scaled considering the integrated time of all the configurations (For example, for the 1h activation, the last target run will be evaluated at 1h, the second last will be evaluated at 1h+(last target running time), the third last target will be evaluated at 1h+(last two target running time combined), and so on). The scripts create also the submission scripts, takes care of different seeds for the simulation and submit the scripts in the farm. The files used at this step are:
* submit_fluka.sh
* beam_time.txt

Create the final output files
-----------------------------
After all the simulation are finished, one will need to convolute the answer for all the possible configurations. 
* For the activation, the correct answer at a certain time after the full experiment finishes is a convolution of all the activation from different exposure from different targets calculated at the correct time from the time of observation. The activation is expressed for each card in PSv/sec. One will need to add the calculated Activation from each single target since the time of observation is already being shifted from the correct amount at each step. In order to do this, one could use the features that fluka uses to average results from different simulation. It will be important at this step to have the same number of files for each configurations. A mininum number of files common to all the configurations is found by the script and used for creating the final sample. The final answer will have the normalization factor multiplied by the number of configurations that we are adding.
* For the dose, the answer is calculated for each target in GeV/g per single incoming electron. In order to obtain the dose in rad, one will need to multiply GeV/g by 1.602176462E-5 . The integrated current for each configuration can be calculated again using the current at run time and the expected hours of beam exposure. The answer will be the full average of all the configurations considering the different beam exposure for each configuration. The final sample of files will have the number of files for each configuration proportional to the beam exposure (current x hours). The final answer is then given in dose/incident electron. The script will also give the integrated number of electrons of all the configurations to be used as normalization factor in the plots with the unit conversion factor. For the 1MeV equivalent neutron the card is written in fluence/cm2 per incident electron so one will need to use as normalization factor, just the integrated current for the experiment beamtime. 


The files used are:
* Data/create_output.sh
* Data/beam_time.txt

 

 
