-- 1. Rows and year coverage.
SELECT COUNT(*) AS row_count,
       MIN(year) AS earliest_year,
       MAX(year) AS latest_year
FROM climate;

-- 2. Missing primary categorization fields.
SELECT COUNT(*) FILTER (WHERE year IS NULL) AS missing_year,
       COUNT(*) FILTER (WHERE NULLIF(TRIM(country), '') IS NULL) AS missing_country,
       COUNT(*) FILTER (WHERE NULLIF(TRIM(region), '') IS NULL) AS missing_region,
       COUNT(*) FILTER (WHERE NULLIF(TRIM(crop_type), '') IS NULL) AS missing_crop,
       COUNT(*) FILTER (WHERE crop_yield_mt_per_ha IS NULL) AS missing_yield
FROM climate;

-- 3. Review implausible measurements, not automatically delete them.
SELECT * FROM climate
WHERE crop_yield_mt_per_ha < 0
   OR total_precipitation_mm < 0
   OR extreme_weather_events < 0
   OR irrigation_access_percentage NOT BETWEEN 0 AND 100
   OR soil_health_index NOT BETWEEN 0 AND 100
   OR pesticide_use_kg_per_ha < 0
   OR fertilizer_use_kg_per_ha < 0;

-- 4. Category / geographic coverage.
SELECT COUNT(DISTINCT country) AS countries,
       COUNT(DISTINCT region) AS regions,
       COUNT(DISTINCT crop_type) AS crop_types,
       COUNT(DISTINCT adaptation_strategies) AS strategies
FROM climate;

-- 5. Exact duplicate records (a diagnostic; some duplicate-looking records may be valid).
SELECT year, country, region, crop_type,
       average_temperature_c, total_precipitation_mm,
       crop_yield_mt_per_ha, COUNT(*) AS occurrences
FROM climate
GROUP BY year, country, region, crop_type,
         average_temperature_c, total_precipitation_mm, crop_yield_mt_per_ha
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;
