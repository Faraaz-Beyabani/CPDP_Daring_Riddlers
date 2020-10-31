# Checkpoint 2

## Prerequisites:
1. Tableau Desktop

In this checkpoint, we examined many of the questions we has asked previously, this time visualizing the results for exploration of trends. The Tableau workbook containing all visualizations can be found in the checkpoint-2 folder.

When the `src/checkpoint-2.twb` workbook is opened, Tableau will give a warning about SQL queries; it is necessary to approve these queries as we invoke Tableau's Initial SQL Query feature to create a list of temporary tables to be used later.

## Data Visualization Tasks
* Which police districts have the lowest income per capita?
* Which police districts have the highest number of aggregate complaints? 
* What is the predominant race of the officers who patrol this area?
* What is the predominant race of the citizens in every district?

## Visualization Questions

For this checkpoint, we had two main relationships that we wanted to inspect. First, we believed that district income and allegation count were inversely proportional. In other words, districts with lower income values would have higher allegation counts. The other relationship we wished to explore was that between officer race and citizen race for each district. More detailed findings and conclusions can be found in `findings.pdf`.

### 1. Which police districts have the lowest income per capita?

The visualization for this question can be found in the `Income Per District` worksheet. The map depicts average median income (it was necessary to average the community median incomes across police districts), with districts with larger income values colored a darker shade of green. 

### 2. Which police districts have the highest number of aggregate complaints?

The visualization for this question can be found in the `Allegations Per District` worksheet. This map shows the total number of allegations for each police district, linked by using a custom SQL query over data_area and data_allegation. The darker the shade of red of the district, the more allegations associated there.

## Comparison

The above two visualizations were greatly linked to our goal, as aforementioned. The dashboard containing a direct comparison for these two metrics can be found in the `Income vs Allegations` dashboard. The average income and allegation count values are similarly binned in 4 groups.

### 3. What is the predominant race of the officers who patrol this area?

The visualization for this metric can be found in the `Majority Officer Race Per District`. For this question, and the next, we looked purely at the race which was present the most for both officers and citizens for each district. Each race has been assigned its own color: districts with a majority Hispanic officer population are blue, majority White officer districts are orange, and majority Black officer districts, if there existed any, would be red. Furthermore, we are missing data in the bottom-right hand side of the map, which is not ideal.

### 4. What is the predominant race of the citizens in every district?

This final visualization can be found in the `Citizen Race Per District` worksheet. It explores each district's majority race, with the same color assignment as previously stated. All of the district data is present for this map.

## Comparison

These last two visualizations can be compared in a dashboard named `Officer vs Citizen Race`. Using this dashboard, we can directly compare each district's majority racial population to officer race population for almost every district. This gives us a way to examine if non-White citizen populations are policed more frequently and/or more harshly than White citizen populations by comparing to the allegation map, which is also included. 