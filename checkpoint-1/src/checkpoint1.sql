-- Which 5 counties have the highest crime rate, number of assigned police officers, complaints, 
-- and settlements (for police misconduct) per 100,000 residents?

-- What is the average for these 4 statistics across all neighborhoods in Chicago / the Chicago area?

-- What is the racial and gender breakdown of the policing force (aggregating across all neighborhoods)? 
SELECT race, count(race), gender, count(gender)
FROM data_officer
WHERE EXTRACT(year FROM appointed_date) <= 2000
AND EXTRACT(year FROM resignation_date) >= 2000 OR resignation_date is null
GROUP BY race, gender

SELECT race, count(race), gender, count(gender)
FROM data_officer
WHERE EXTRACT(year FROM appointed_date) <= 2015
AND EXTRACT(year FROM resignation_date) >= 2015 OR resignation_date is null
GROUP BY race, gender

-- Which units have the highest male-to-female ratio of police officers?

SELECT dpu.description, dof.gender, count(dof.gender)
FROM data_officer dof, data_officerhistory doh, data_policeunit dpu
WHERE doh.officer_id = dof.id AND doh.unit_id = dpu.id AND dpu.description IS NOT NULL
GROUP BY dpu.description, dof.gender;

SELECT dpu.description, round(cast((cast(sum(CASE WHEN dof.gender = 'M' THEN 1 ELSE 0 END) as float8) / count(dof.gender)) as numeric), 2) as male_ratio
FROM data_officer dof, data_officerhistory doh, data_policeunit dpu
WHERE doh.officer_id = dof.id AND doh.unit_id = dpu.id AND dpu.description IS NOT NULL AND dpu.description != 'Unknown'
GROUP BY dpu.description;

-- What was Chicago’s income per capita? Which 3 - 5 neighborhoods have the highest and lowest income per capita?

-- Which neighborhoods have predominantly White, Black, Asian, or Hispanic police forces? 

-- What is the city’s racial breakdown for its population? 
-- Which neighborhoods are predominantly White, Black, Asian, Hispanic (compared to the city average)?