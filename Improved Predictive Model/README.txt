#Improved Predictive Model

This folder contains the code associated with Step #1 of the thesis. 

For the code to run, a folder named "Data" has to be saved in the same directory as this code. "Data" must contain the satellite data arranged by day and then by type. More days can be added, then the quantity "NDataFolder" in the ExtractData.m code has to be changed accordingly. The appendix of the thesis dissertation contains a figure showing how the data must be organized.

Once the data files are sorted in the right folders, the scripts have to be run in this order:
- ExtractData.m
- DataFusion.m
- Training_Validation_Performance.m
The remaining scripts are functions called by these 3 main scripts. The computed models for each band should be saved by the user in Matlab structures, in order to be reused in the Step #2 part. 


*Disclaimer: The ExtractData.m script was first written by Vu Ngo, and then rewritten and enhanced by Huguenin, Achour and Commun. It has been slightly modified from its last version for the purpose of this thesis. 
The DataFusion.m and Training_Validation_Performance.m scripts were first written by Huguenin, Achour and Commun. They have been modified from their last version and enhanced for the purpose of this thesis. 
