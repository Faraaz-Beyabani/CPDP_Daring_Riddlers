
----------------------------------
-- QUESTION 1                   --
----------------------------------

-- What is the number of assigned officers, complaints, and settlements across all of the Chicago area?

-- Allegations by Beat

-- 2000

SELECT
    b.name as "Beat ID",
    COUNT(*) as "Allegations"
FROM data_allegation a JOIN data_area b ON a.beat_id = b.id
WHERE
    beat_id is not NULL AND
    EXTRACT(year FROM incident_date) = 2000
GROUP BY b.name
ORDER BY COUNT(*) DESC;

-- 2015

SELECT
    b.name as "Beat ID",
    COUNT(*) as "Allegations"
FROM data_allegation a JOIN data_area b ON a.beat_id = b.id
WHERE
    beat_id is not NULL AND
    EXTRACT(year FROM incident_date) = 2015
GROUP BY b.name
ORDER BY COUNT(*) DESC;



-- Total Officers

-- 2000

SELECT count(id) FROM data_officer
WHERE resignation_date is null OR EXTRACT(year from resignation_date) >= 2000;

-- 2019

SELECT count(id) FROM data_officer
WHERE resignation_date is null OR EXTRACT(year from resignation_date) >= 2019;



-- Total Allegations

-- 2005

SELECT COUNT(*)
FROM data_allegation
WHERE EXTRACT(year FROM incident_date) = 2005

-- 2015

SELECT COUNT(*)
FROM data_allegation
WHERE EXTRACT(year FROM incident_date) = 2015



-- *** Total Settlements ***

-- 2011 total payments

SELECT sum(settlement)
FROM lawsuit_payment
WHERE EXTRACT(year from paid_date) = 2011;

-- 2011 average payment per settlement

SELECT avg(settlement)
FROM lawsuit_payment
WHERE EXTRACT(year from paid_date) = 2011;

-- 2019 total payments

SELECT sum(settlement)
FROM lawsuit_payment
WHERE EXTRACT(year from paid_date) = 2019;

-- 2019 average payment per settlement

SELECT avg(settlement)
FROM lawsuit_payment
WHERE EXTRACT(year from paid_date) = 2019;



----------------------------------
-- QUESTION 2                   --
----------------------------------

-- *** What is the racial and gender breakdown of the policing force (aggregating across all neighborhoods)? ***

-- 2000 race and gender across the entire CPD

CREATE TEMP TABLE beat_district_map AS (
SELECT beats.name beat_name, districts.name district_name
FROM data_area districts JOIN data_area beats ON st_intersects(districts.polygon, beats.polygon)
WHERE districts.area_type = 'police-district' AND beats.area_type = 'beat');

CREATE TEMP TABLE race_per_beat AS (
SELECT res.beat, res.race, count(distinct res.officer_id) as officer_count FROM
(SELECT * FROM data_assignment_attendance
WHERE EXTRACT(year FROM shift_start) = 2019 AND beat SIMILAR TO '[0-9]%') as res
WHERE res.officer_id is not null AND res.beat is not null
GROUP BY res.beat, res.race);

SELECT rpb1.beat, rpb1.race, rpb1.officer_count / sum(rpb2.officer_count) ratio
FROM race_per_beat rpb1, race_per_beat rpb2
WHERE rpb1.beat = rpb2.beat
GROUP BY rpb1.beat, rpb1.race, rpb1.officer_count
ORDER BY ratio DESC;


-- 2019 race and gender across the entire CPD

SELECT race, count(race), gender, count(gender)
FROM data_officer
WHERE EXTRACT(year FROM appointed_date) <= 2019
AND EXTRACT(year FROM resignation_date) >= 2019 OR resignation_date is null
GROUP BY race, gender



-- *** Which units have the highest male-to-female ratio of police officers? ***

-- 2000 total gender distribution per unit

SELECT dpu.description, dof.gender, count(dof.gender)
FROM (SELECT * FROM data_officer WHERE EXTRACT(year FROM appointed_date) <= 2000
                                           AND (EXTRACT(year FROM resignation_date) >= 2000 OR resignation_date IS NULL))
    as dof,
     data_officerhistory doh, data_policeunit dpu
WHERE doh.officer_id = dof.id AND doh.unit_id = dpu.id AND dpu.description IS NOT NULL
GROUP BY dpu.description, dof.gender;


-- 2000 male-to-female ratio per unit

SELECT dpu.description, round(cast((cast(sum(CASE WHEN dof.gender = 'M' THEN 1 ELSE 0 END) as float8) / count(dof.gender)) as numeric), 2) as male_ratio, count(dof.id) as num_employees
FROM (SELECT * FROM data_officer WHERE EXTRACT(year FROM appointed_date) <= 2000
                                           AND (EXTRACT(year FROM resignation_date) >= 2000 OR resignation_date IS NULL))
    as dof,
     data_officerhistory doh, data_policeunit dpu
WHERE doh.officer_id = dof.id AND doh.unit_id = dpu.id AND dpu.description IS NOT NULL AND dpu.description != 'Unknown'
GROUP BY dpu.description;


                                                

-- 2019 total gender distribution per unit

SELECT dpu.description, dof.gender, count(dof.gender)
FROM (SELECT * FROM data_officer WHERE EXTRACT(year FROM appointed_date) <= 2019
                                           AND (EXTRACT(year FROM resignation_date) >= 2019 OR resignation_date IS NULL))
    as dof,
     data_officerhistory doh, data_policeunit dpu
WHERE doh.officer_id = dof.id AND doh.unit_id = dpu.id AND dpu.description IS NOT NULL
GROUP BY dpu.description, dof.gender;


-- 2019 male-to-female ratio per unit

SELECT dpu.description, round(cast((cast(sum(CASE WHEN dof.gender = 'M' THEN 1 ELSE 0 END) as float8) / count(dof.gender)) as numeric), 2) as male_ratio, count(dof.id) as num_employees
FROM (SELECT * FROM data_officer WHERE EXTRACT(year FROM appointed_date) <= 2019
                                           AND (EXTRACT(year FROM resignation_date) >= 2019 OR resignation_date IS NULL))
    as dof,
     data_officerhistory doh, data_policeunit dpu
WHERE doh.officer_id = dof.id AND doh.unit_id = dpu.id AND dpu.description IS NOT NULL AND dpu.description != 'Unknown'
GROUP BY dpu.description;

----------------------------------
-- QUESTION 3                   --
----------------------------------

-- *** What is the race composition of every beat active in 2019?
-- Takes some time to resolve!

CREATE TEMP TABLE beat_district_map AS (
SELECT beats.name beat_name, districts.name district_name
FROM data_area districts JOIN data_area beats ON st_intersects(districts.polygon, beats.polygon)
WHERE districts.area_type = 'police-district' AND beats.area_type = 'beat')

CREATE TEMP TABLE race_per_beat AS (
SELECT res.beat, res.race, count(distinct res.officer_id) FROM
(SELECT * FROM data_assignment_attendance
WHERE EXTRACT(year FROM shift_start) = 2019 AND beat SIMILAR TO '[0-9]%') as res
WHERE res.officer_id is not null AND res.beat is not null
GROUP BY res.beat, res.race)

SELECT 
FROM

----------------------------------
-- QUESTION 4                   --
----------------------------------

-- *** What is the city’s racial breakdown for its population? ***

-- Total counts for each race
                                                
SELECT race, sum(count)
FROM data_racepopulation drp
GROUP BY race;

-- Average counts for each race per area
                                                
SELECT race, round(cast(avg(count) as numeric), 2)
FROM data_racepopulation drp
GROUP BY race;



-- *** Which areas are predominantly White, Black, Asian, Hispanic (compared to the city average)? ***

SELECT drp.race, drp.area_id, da.name, drp.count, avg_race.average_count
FROM (SELECT race, round(cast(avg(count) as numeric), 2) as average_count FROM data_racepopulation drp GROUP BY race) as avg_race,
     data_racepopulation drp,
     data_area da
WHERE drp.race = avg_race.race AND drp.count > (1.2 * avg_race.average_count) AND da.id = drp.area_id;
