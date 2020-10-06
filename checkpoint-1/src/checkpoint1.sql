-- *** Which 5 counties have the highest crime rate, number of assigned police officers, complaints, ***
-- *** and settlements (for police misconduct) per 100,000 residents?                                ***


-- Officers by Unit

-- Allegations by Beat
SELECT
    beat_id as "Beat ID",
    COUNT(*) as "Allegations"
FROM data_allegation
WHERE
    beat_id is not NULL AND
    EXTRACT(year FROM incident_date) = 2000
GROUP BY beat_id
ORDER BY COUNT(*) DESC

SELECT
    beat_id as "Beat ID",
    COUNT(*) as "Allegations"
FROM data_allegation
WHERE
    beat_id is not NULL AND
    EXTRACT(year FROM incident_date) = 2015
GROUP BY beat_id
ORDER BY COUNT(*) DESC


-- What is the average for these 4 statistics across all neighborhoods in Chicago / the Chicago area?



-- Total Officers

-- Total Allegations
SELECT COUNT(*)
FROM data_allegation
WHERE EXTRACT(year FROM incident_date) = 2005

SELECT COUNT(*)
FROM data_allegation
WHERE EXTRACT(year FROM incident_date) = 2015

-- Total Settlements


-- *** What is the racial and gender breakdown of the policing force (aggregating across all neighborhoods)? ***

-- 2000

SELECT race, count(race), gender, count(gender)
FROM data_officer
WHERE EXTRACT(year FROM appointed_date) <= 2000
AND EXTRACT(year FROM resignation_date) >= 2000 OR resignation_date is null
GROUP BY race, gender

-- 2019

SELECT race, count(race), gender, count(gender)
FROM data_officer
WHERE EXTRACT(year FROM appointed_date) <= 2019
AND EXTRACT(year FROM resignation_date) >= 2019 OR resignation_date is null
GROUP BY race, gender

-- *** Which units have the highest male-to-female ratio of police officers? ***

-- 2000

SELECT dpu.description, dof.gender, count(dof.gender)
FROM (SELECT * FROM data_officer WHERE EXTRACT(year FROM appointed_date) <= 2000
                                           AND (EXTRACT(year FROM resignation_date) >= 2000 OR resignation_date IS NULL))
    as dof,
     data_officerhistory doh, data_policeunit dpu
WHERE doh.officer_id = dof.id AND doh.unit_id = dpu.id AND dpu.description IS NOT NULL
GROUP BY dpu.description, dof.gender;

SELECT dpu.description, round(cast((cast(sum(CASE WHEN dof.gender = 'M' THEN 1 ELSE 0 END) as float8) / count(dof.gender)) as numeric), 2) as male_ratio, count(dof.id) as num_employees
FROM (SELECT * FROM data_officer WHERE EXTRACT(year FROM appointed_date) <= 2000
                                           AND (EXTRACT(year FROM resignation_date) >= 2000 OR resignation_date IS NULL))
    as dof,
     data_officerhistory doh, data_policeunit dpu
WHERE doh.officer_id = dof.id AND doh.unit_id = dpu.id AND dpu.description IS NOT NULL AND dpu.description != 'Unknown'
GROUP BY dpu.description;

-- 2019

SELECT dpu.description, dof.gender, count(dof.gender)
FROM (SELECT * FROM data_officer WHERE EXTRACT(year FROM appointed_date) <= 2019
                                           AND (EXTRACT(year FROM resignation_date) >= 2019 OR resignation_date IS NULL))
    as dof,
     data_officerhistory doh, data_policeunit dpu
WHERE doh.officer_id = dof.id AND doh.unit_id = dpu.id AND dpu.description IS NOT NULL
GROUP BY dpu.description, dof.gender;

SELECT dpu.description, round(cast((cast(sum(CASE WHEN dof.gender = 'M' THEN 1 ELSE 0 END) as float8) / count(dof.gender)) as numeric), 2) as male_ratio, count(dof.id) as num_employees
FROM (SELECT * FROM data_officer WHERE EXTRACT(year FROM appointed_date) <= 2019
                                           AND (EXTRACT(year FROM resignation_date) >= 2019 OR resignation_date IS NULL))
    as dof,
     data_officerhistory doh, data_policeunit dpu
WHERE doh.officer_id = dof.id AND doh.unit_id = dpu.id AND dpu.description IS NOT NULL AND dpu.description != 'Unknown'
GROUP BY dpu.description;

-- *** What was Chicago’s income per capita? Which 3 - 5 neighborhoods have the highest and lowest income per capita? ***

-- *** Which neighborhoods have predominantly White, Black, Asian, or Hispanic police forces? ***
-- *** What is the race composition of every beat active in 2019?
                                                
SELECT res.beat, res.race, count(distinct res.officer_id) FROM
(SELECT * FROM data_assignment_attendance
WHERE EXTRACT(year FROM shift_start) = 2019 AND beat SIMILAR TO '[0-9]%') as res
WHERE res.officer_id is not null AND res.beat is not null
GROUP BY res.beat, res.race

-- *** What is the city’s racial breakdown for its population? ***
                                                
SELECT race, sum(count)
FROM data_racepopulation drp
GROUP BY race;

SELECT race, round(cast(avg(count) as numeric), 2)
FROM data_racepopulation drp
GROUP BY race;

-- *** Which neighborhoods are predominantly White, Black, Asian, Hispanic (compared to the city average)? ***

SELECT drp.race, drp.area_id, da.name, drp.count, avg_race.average_count
FROM (SELECT race, round(cast(avg(count) as numeric), 2) as average_count FROM data_racepopulation drp GROUP BY race) as avg_race,
     data_racepopulation drp,
     data_area da
WHERE drp.race = avg_race.race AND drp.count > (1.2 * avg_race.average_count) AND da.id = drp.area_id;