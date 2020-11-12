# Checkpoint 4

In this checkpoint, we used the Python machine learning module, scikit-learn, in order to predict which districts of Chicago are overpoliced, if any. Our results can be found in the Jupyter notebook located at `src/checkpoint-4.ipynb`. The features we examined were year, number of officers with at least one complaint, ratio of use of force allegations to all allegations, and the same ratio for illegal search allegations. Our result variable was the number of use of force and illegal search allegations per year, for each district.

The csv data files used for this assignment can be found in the `src/data/` folder. The `src/python/` folder contains the SQL queries used to populate these files in `queries.sql` and the helper functions used in the Jupyter notebook in `helpers.py`.

## Prerequisites

If you would like to run the code cells, the following packages are required. Otherwise, to view the notebook, only Jupyter Notebook and/or Jupyter Lab is needed.

* Jupyter Notebook or Lab
* NumPy 1.19.4
* MatPlotLib 3.3.2
* Scikit-Learn 0.23.2

## Focus Questions
* How do the numbers of our chosen complaint types change over time for each region?
* Do regions with higher officer counts have more occurrences of moderate severity complaints?
* Do higher ratios of Use of Force and Illegal Search complaints have a direct relationship with the number of moderate severity complaints?
* Given the relationships gleaned from the data and the previous questions, which regions, if any, are overpoliced?

In the Jupyter notebook, the first half of the notebook is spent loading and processing data from the aforementioned csv files. 
Our results, including linear regression coefficients, intercepts, and data plots can be found at the end of the notebook.

Our motivations and conclusions regarding this analysis can be found in the `findings.pdf` in the root directory.