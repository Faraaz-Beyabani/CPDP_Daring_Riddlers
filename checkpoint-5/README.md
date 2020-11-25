# Checkpoint 5

In this checkpoint, we used a combination of scikit-learn and nltk to analyze the sentiment of allegation text summaries and, if possible, to find a connection between regional statistics and negative sentiment. Our results can be found in the Jupyter notebook located at `src/checkpoint-5.ipynb`. For this analysis, we examined demographics data such as the name of neighborhoods, the median income of a given area, as well as complainant data such as gender, race, and birth year.

The csv data files used for this assignment can be found in the `src/data/` folder. The `src/sql/` folder contains the SQL queries used to populate these files in `queries.sql`.

## Prerequisites

If you would like to run the code cells, the following packages are required. Otherwise, to view the notebook, only Jupyter Notebook and/or Jupyter Lab is needed.

* Jupyter Notebook or Lab (Required)
* NumPy
* MatPlotLib
* Scikit-Learn
* Pandas
* NLTK

## Focus Questions
* How is the sentiment of an allegation summary affected by the complainant's race or gender?
* Is there a correlation between the negativity of a sentiment and various geographic and complainant features?

Our results from completing this analysis can be found in the `findings.pdf` in the root directory.