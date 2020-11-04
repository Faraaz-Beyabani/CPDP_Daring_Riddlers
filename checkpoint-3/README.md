# Checkpoint 3

In this checkpoint, we used D3.js, a JavaScript visualization library, to visualize the number of TRRs filed per district for each year from 2004 to 2016. Our results can be found in the ObservableHQ notebook located at [this link](https://observablehq.com/@afv22/cpd-complaints-by-district) or by opening the browser shorcut in the `src/` folder.

Additionally, intermediate steps and data files can be found in the `src/misc/` folder. This includes files such as JSON, GeoJSON, and SQL queries that were used to construct the final visualization.

## Focus Questions
* Are TRR percentages for each district relatively stable over time?
* How do TRR percentages relate to the median income of each district?
* Are there higher TRR percentages in districts where the population is predominantly a specific race?

In the ObservableHQ notebook, the map displayed cycles through each year from 2004 to 2016. At any time, the user can click the 'Pause' button to stop cycling through the years or use the slider to select a specific year. Each district is colored blue, and the intensity of the district provides a measure of what percent of all Chicago TRRs originated from that district. The user can also hover over a specific district to see its name and its TRR contribution.

Our motivations and conclusions regarding this map can be found in the `findings.pdf` in the root directory.