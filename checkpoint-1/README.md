# Checkpoint 1

## Prerequisites:
1. Installation of PostgreSQL or another SQL editor such as JetBrains Datagrip.
2. Connection to the CPDP database.

## Relational Analytics
* What is the number of assigned officers, complaints, and settlements across all of the Chicago area?
* What is the racial and gender breakdown of the policing force (aggregating across all of Chicago)? Which units have the highest male-to-female ratio of police officers?
* What does the distribution of race look like for every active beat (at least one assignment in a given year)?
* What is the city’s racial breakdown for its population? Which neighborhoods are predominantly White, Black, Asian, Hispanic (compared to the city average)?


## Queries

### 1. What is the number of assigned officers, complaints, and settlements across all of the Chicago area?
```
-- *** Allegations by Beat ***

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
```

```
-- *** Total Officers ***

-- 2000

SELECT count(id) FROM data_officer
WHERE resignation_date is null OR EXTRACT(year from resignation_date) >= 2000;

-- 2019

SELECT count(id) FROM data_officer
WHERE resignation_date is null OR EXTRACT(year from resignation_date) >= 2019;
```

```
-- *** Total Allegations ***

-- 2005

SELECT COUNT(*)
FROM data_allegation
WHERE EXTRACT(year FROM incident_date) = 2005

-- 2015

SELECT COUNT(*)
FROM data_allegation
WHERE EXTRACT(year FROM incident_date) = 2015
```

```
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

```

### 2. What is the racial and gender breakdown of the policing force (aggregating across all of Chicago)? 
```
-- *** 2000 race and gender across the entire CPD ***

SELECT race, count(race), gender, count(gender)
FROM data_officer
WHERE EXTRACT(year FROM appointed_date) <= 2000
AND EXTRACT(year FROM resignation_date) >= 2000 OR resignation_date is null
GROUP BY race, gender;


-- *** 2019 race and gender across the entire CPD ***

SELECT race, count(race), gender, count(gender)
FROM data_officer
WHERE EXTRACT(year FROM appointed_date) <= 2019
AND EXTRACT(year FROM resignation_date) >= 2019 OR resignation_date is null
GROUP BY race, gender;
```

### 2.a. Which units have the highest male-to-female ratio of police officers?
```
-- *** 2000 total gender distribution per unit ***

SELECT dpu.description, dof.gender, count(dof.gender)
FROM (SELECT * FROM data_officer WHERE EXTRACT(year FROM appointed_date) <= 2000
                                           AND (EXTRACT(year FROM resignation_date) >= 2000 OR resignation_date IS NULL))
    as dof,
     data_officerhistory doh, data_policeunit dpu
WHERE doh.officer_id = dof.id AND doh.unit_id = dpu.id AND dpu.description IS NOT NULL
GROUP BY dpu.description, dof.gender;


-- *** 2000 male-to-female ratio per unit *** 

SELECT dpu.description, round(cast((cast(sum(CASE WHEN dof.gender = 'M' THEN 1 ELSE 0 END) as float8) / count(dof.gender)) as numeric), 2) as male_ratio, count(dof.id) as num_employees
FROM (SELECT * FROM data_officer WHERE EXTRACT(year FROM appointed_date) <= 2000
                                           AND (EXTRACT(year FROM resignation_date) >= 2000 OR resignation_date IS NULL))
    as dof,
     data_officerhistory doh, data_policeunit dpu
WHERE doh.officer_id = dof.id AND doh.unit_id = dpu.id AND dpu.description IS NOT NULL AND dpu.description != 'Unknown'
GROUP BY dpu.description;
```

```
-- *** 2019 total gender distribution per unit ***

SELECT dpu.description, dof.gender, count(dof.gender)
FROM (SELECT * FROM data_officer WHERE EXTRACT(year FROM appointed_date) <= 2019
                                           AND (EXTRACT(year FROM resignation_date) >= 2019 OR resignation_date IS NULL))
    as dof,
     data_officerhistory doh, data_policeunit dpu
WHERE doh.officer_id = dof.id AND doh.unit_id = dpu.id AND dpu.description IS NOT NULL
GROUP BY dpu.description, dof.gender;


-- *** 2019 male-to-female ratio per unit ***

SELECT dpu.description, round(cast((cast(sum(CASE WHEN dof.gender = 'M' THEN 1 ELSE 0 END) as float8) / count(dof.gender)) as numeric), 2) as male_ratio, count(dof.id) as num_employees
FROM (SELECT * FROM data_officer WHERE EXTRACT(year FROM appointed_date) <= 2019
                                           AND (EXTRACT(year FROM resignation_date) >= 2019 OR resignation_date IS NULL))
    as dof,
     data_officerhistory doh, data_policeunit dpu
WHERE doh.officer_id = dof.id AND doh.unit_id = dpu.id AND dpu.description IS NOT NULL AND dpu.description != 'Unknown'
GROUP BY dpu.description;
```


### 3. What does the distribution of officer race look like for every district?
```
SELECT res.beat, res.race, count(distinct res.officer_id) FROM
(SELECT * FROM data_assignment_attendance
WHERE EXTRACT(year FROM shift_start) = 2019 AND beat SIMILAR TO '[0-9]%') as res
WHERE res.officer_id is not null AND res.beat is not null
GROUP BY res.beat, res.race;
```


### 4. What is the city’s racial breakdown for its population?
```
-- Total counts for each race
SELECT race, sum(count)
FROM data_racepopulation drp
GROUP BY race;

-- Average counts for each race per area
SELECT race, round(cast(avg(count) as numeric), 2)
FROM data_racepopulation drp
GROUP BY race;
```

### 4.a. Which neighborhoods are predominantly White, Black, Asian, Hispanic (compared to the city average)?
```
SELECT drp.race, drp.area_id, da.name, drp.count, avg_race.average_count
FROM (SELECT race, round(cast(avg(count) as numeric), 2) as average_count FROM data_racepopulation drp GROUP BY race) as avg_race,
     data_racepopulation drp,
     data_area da
WHERE drp.race = avg_race.race AND drp.count > (1.2 * avg_race.average_count) AND da.id = drp.area_id;
```
