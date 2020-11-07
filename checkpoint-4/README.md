Given the number of complaints per year for each district, group the districts into buckets based on their region in Chicago: North, Central, West, and South. 
Using 4-fold cross validation, hold out on 1 region at a time, while learning a regression (with year as the independent variable) on the other three. 
We would then plot the learned regression against the actual data for the held-out region.

If the regression model consistently under-estimates compared to the true complaint numbers, we can say that the region might be over-policed. 
If the model consistently over-estimates, the region might be under-policed. 
By using CV, we can apply this analysis to each region to see how they compare to each other.

Considering that the number of TRRs filed ought to be closely linked to the number of complaints, we might also perform this analysis on TRR counts to explore the same types of relationships between regions.