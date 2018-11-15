#Off-track prediction

This folder contains the code associated with Step #2 of the thesis. 

For the code to run, a folder named "Data" has to be saved in the same directory as this code. "Data" must contain the satellite data arranged by type. The appendix of the thesis dissertation contains a figure showing how the data must be organized.

Once the data files are sorted in the right folders, the scripts have to be run in this order:
- ExtractDataOfftrack.m
- ExtractDataMOD35.m
- DataFusionOfftrack.m
- Offtrackprediction.m
- results_analysis.m
The remaining scripts are functions called by these 5 main scripts.

