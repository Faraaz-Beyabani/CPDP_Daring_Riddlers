CREATE TEMP TABLE severe_per_year AS (
SELECT crid, EXTRACT(year from incident_date) as year, dac.category FROM data_allegation da, data_allegationcategory dac
WHERE da.most_common_category_id = dac.id and dac.category = 'Use Of Force' or dac.category = 'Illegal Search');


-- FEATURE
-- severe allegations per district per year
SELECT data_area.name, spy.year, count(spy.crid)
FROM data_area, data_allegation_areas daa, severe_per_year spy
where data_area.area_type = 'police-districts' and data_area.id = daa.area_id and spy.crid = daa.allegation_id
  and data_area.name != '31st' and spy.year is not null and spy.year > 2000
group by data_area.name, spy.year;

-- FEATURE
-- population per district
SELECT data_area.name, sum(drp.count) FROM data_area, data_racepopulation drp
WHERE data_area.area_type = 'police-districts' and data_area.id = drp.area_id
group by data_area.name;

-- FEATURE
-- officers per district
select da.name, da2.year, count(distinct officer_id)
from data_officerallegation doa, data_allegation_areas daa, data_area da,
        (SELECT *, extract(year from data_allegation.incident_date) as year FROM data_allegation) da2
WHERE doa.allegation_id = daa.allegation_id and daa.area_id = da.id and da.area_type = 'police-districts' and da2.crid = doa.allegation_id
    and extract(year from da2.incident_date) > 2000 and da.name != '31st'
group by da.name, da2.year;



-- FEATURE
-- allegation type proportions per unit per year
drop table if exists temp_unit_allegation_category_count;

create temp table temp_unit_allegation_category_count as
select unit, year, category, count(officer_id) from
(select cast(substr(da.name, 0, length(da.name) - 1) as int) as unit, da2.year, officer_id, allegation_category_id from data_officerallegation doa, data_allegation_areas daa, data_area da,
        (SELECT *, extract(year from data_allegation.incident_date) as year FROM data_allegation) da2
WHERE doa.allegation_id = daa.allegation_id and daa.area_id = da.id and da.area_type = 'police-districts' and da2.crid = doa.allegation_id
    and extract(year from da2.incident_date) > 2000 and da.name != '31st') as dou
left join data_allegationcategory
on dou.allegation_category_id = data_allegationcategory.id
group by unit, year, officer_id, category;

drop table if exists temp_unit_allegation_distribution;
create temp table temp_unit_allegation_distribution as
select unit, year,
       sum(case when category='Bribery / Official Corruption' then count else 0 end) as Bribery_Official_Corruption,
       sum(case when category='Racial Profiling' then count else 0 end) as Racial_Profiling,
       sum(case when category='Conduct Unbecoming (Off-Duty)' then count else 0 end) as Conduct_Unbecoming_Off_Duty,
       sum(case when category='Criminal Misconduct' then count else 0 end) as Criminal_Misconduct,
       sum(case when category='False Arrest' then count else 0 end) as False_Arrest,
       sum(case when category='Operation/Personnel Violations' then count else 0 end) as Operation_Personnel_Violations,
       sum(case when category='Excessive Force' then count else 0 end) as Excessive_Force,
       sum(case when category='Domestic' then count else 0 end) as Domestic,
       sum(case when category='Use Of Force' then count else 0 end) as Use_Of_Force,
       sum(case when category='Money / Property' then count else 0 end) as Money_Property,
       sum(case when category='Supervisory Responsibilities' then count else 0 end) as Supervisory_Responsibilities,
       sum(case when category='Traffic' then count else 0 end) as Traffic,
       sum(case when category='Incident' then count else 0 end) as Incident,
       sum(case when category='Illegal Search' then count else 0 end) as Illegal_Search,
       sum(case when category='Medical' then count else 0 end) as Medical,
       sum(case when category='Lockup Procedures' then count else 0 end) as Lockup_Procedures,
       sum(case when category='Unknown' then count else 0 end) as Unknown,
       sum(case when category='First Amendment' then count else 0 end) as First_Amendment,
       sum(case when category='Verbal Abuse' then count else 0 end) as Verbal_Abuse,
       sum(case when category='Drug / Alcohol Abuse' then count else 0 end) as Drug_Alcohol_Abuse
       from temp_unit_allegation_category_count group by unit, year;

drop table if exists temp_unit_allegation_distribution_total;
create temp table temp_unit_allegation_distribution_total as
select *, Bribery_Official_Corruption+Racial_Profiling+Conduct_Unbecoming_Off_Duty
                +Criminal_Misconduct+False_Arrest+Operation_Personnel_Violations
                +Excessive_Force+Domestic+Use_Of_Force+Money_Property
                +Supervisory_Responsibilities+Traffic+Incident+Illegal_Search
                +Medical+Lockup_Procedures+Unknown+First_Amendment+Verbal_Abuse+Drug_Alcohol_Abuse
                as total
from temp_unit_allegation_distribution;

-- Allegation proportions per unit
select unit, year, Bribery_Official_Corruption/total as Bribery_Official_Corruption,
        Racial_Profiling/total as Racial_Profiling,
        Conduct_Unbecoming_Off_Duty/total as Conduct_Unbecoming_Off_Duty,
        Criminal_Misconduct/total as Criminal_Misconduct,
        False_Arrest/total as False_Arrest,
        Operation_Personnel_Violations/total as Operation_Personnel_Violations,
        Excessive_Force/total as Excessive_Force,
        Domestic/total as Domestic,
        Use_Of_Force/total as Use_Of_Force,
        Money_Property/total as Money_Property,
        Supervisory_Responsibilities/total as Supervisory_Responsibilities,
        Traffic/total as Traffic,
        Incident/total as Incident,
        Illegal_Search/total as Illegal_Search,
        Medical/total as Medical,
        Lockup_Procedures/total as Lockup_Procedures,
        Unknown/total as Unknown,
        First_Amendment/total as First_Amendment,
        Verbal_Abuse/total as Verbal_Abuse,
        Drug_Alcohol_Abuse/total as Drug_Alcohol_Abuse
from temp_unit_allegation_distribution_total;
