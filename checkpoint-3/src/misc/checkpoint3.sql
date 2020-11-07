DROP TABLE IF EXISTS district_areas;

CREATE TEMP TABLE district_areas AS (
SELECT district.name, district.polygon
FROM data_area district
WHERE district.area_type = 'police-districts');

DROP TABLE IF EXISTS trrs_per_year;

CREATE TEMP TABLE trrs_per_year AS (
SELECT trr_counts.date_part as year, sum(count) as trr_total
FROM (SELECT EXTRACT(year from trr_datetime) as date_part, count(*) as count
     FROM trr_trr
     GROUP BY trr_datetime) as trr_counts
GROUP BY trr_counts.date_part);

DROP TABLE IF EXISTS district_yearly_trrs;

CREATE TEMP TABLE district_yearly_trrs AS (
SELECT name, district_trrs.year, ROUND(sum(count)/trr_total,4)*100 as trr_count
FROM (SELECT district.name, EXTRACT(year from trrs.trr_datetime) as year, count(trrs.*) as count
     FROM district_areas district, trr_trr trrs
     WHERE ST_Intersects(district.polygon, trrs.point)
     GROUP BY district.name, trrs.trr_datetime) as district_trrs, trrs_per_year
WHERE district_trrs.year = trrs_per_year.year
GROUP BY name, district_trrs.year, trrs_per_year.trr_total);

-- These are the percent of TRRs filed per district per year.
SELECT dyt.*, ST_AsGeoJSON(dra.polygon) as polygon FROM district_yearly_trrs dyt
INNER JOIN district_areas dra ON dyt.name = dra.name
WHERE dyt.name != '31st';

-- Our totals above are lower than the total number of TRRs per year due to some TRRs being located outside the district bounds given.