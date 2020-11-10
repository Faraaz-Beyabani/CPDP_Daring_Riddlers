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
group by da.name, da2.year