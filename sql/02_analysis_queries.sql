-- EXPLORATORY ANALYSIS: The queries produce results only once data is loaded.
-- Do not describe the outputs as factual findings before checking source quality.

-- Q1. Dataset-level descriptive indicators.
SELECT COUNT(*) AS records,
       ROUND(AVG(average_temperature_c), 2) AS avg_temperature_c,
       ROUND(AVG(total_precipitation_mm), 2) AS avg_precipitation_mm,
       ROUND(AVG(crop_yield_mt_per_ha), 3) AS avg_yield_mt_per_ha,
       ROUND(AVG(irrigation_access_percentage), 2) AS avg_irrigation_pct
FROM climate;

-- Q2. Year-over-year descriptive trends.
SELECT year, COUNT(*) AS observations,
       ROUND(AVG(average_temperature_c), 2) AS avg_temperature_c,
       ROUND(AVG(total_precipitation_mm), 2) AS avg_precipitation_mm,
       ROUND(AVG(crop_yield_mt_per_ha), 3) AS avg_yield_mt_per_ha
FROM climate
WHERE year IS NOT NULL
GROUP BY year
ORDER BY year;

-- Q3. Crop type average yield and mean reported economic impact.
SELECT crop_type, COUNT(*) AS observations,
       ROUND(AVG(crop_yield_mt_per_ha), 3) AS avg_yield_mt_per_ha,
       ROUND(AVG(economic_impact_million_usd), 2) AS avg_economic_impact_musd
FROM climate
WHERE crop_type IS NOT NULL
GROUP BY crop_type
ORDER BY avg_yield_mt_per_ha DESC NULLS LAST;

-- Q4. Regional profile.
SELECT region, COUNT(*) AS observations,
       ROUND(AVG(crop_yield_mt_per_ha), 3) AS avg_yield_mt_per_ha,
       ROUND(AVG(average_temperature_c), 2) AS avg_temperature_c,
       ROUND(AVG(soil_health_index), 2) AS avg_soil_health_index
FROM climate
WHERE region IS NOT NULL
GROUP BY region
ORDER BY observations DESC;

-- Q5. Country / crop combinations with sufficient samples.
SELECT country, crop_type, COUNT(*) AS observations,
       ROUND(AVG(crop_yield_mt_per_ha), 3) AS avg_yield_mt_per_ha
FROM climate
WHERE country IS NOT NULL AND crop_type IS NOT NULL
GROUP BY country, crop_type
HAVING COUNT(*) >= 2
ORDER BY country, avg_yield_mt_per_ha DESC NULLS LAST;

-- Q6. Weather event frequency and observed average yield.
SELECT extreme_weather_events, COUNT(*) AS observations,
       ROUND(AVG(crop_yield_mt_per_ha), 3) AS avg_yield_mt_per_ha
FROM climate
WHERE extreme_weather_events IS NOT NULL
GROUP BY extreme_weather_events
ORDER BY extreme_weather_events;

-- Q7. Average yield by recorded adaptation strategy.
SELECT COALESCE(NULLIF(TRIM(adaptation_strategies), ''), 'Unspecified') AS strategy,
       COUNT(*) AS observations,
       ROUND(AVG(crop_yield_mt_per_ha), 3) AS avg_yield_mt_per_ha
FROM climate
GROUP BY 1
ORDER BY observations DESC;

-- Q8. Yield by irrigation-access bracket.
WITH irrigation_bands AS (
    SELECT crop_yield_mt_per_ha,
           CASE WHEN irrigation_access_percentage IS NULL THEN 'Unknown'
                WHEN irrigation_access_percentage < 25 THEN '0–24%'
                WHEN irrigation_access_percentage < 50 THEN '25–49%'
                WHEN irrigation_access_percentage < 75 THEN '50–74%'
                WHEN irrigation_access_percentage <= 100 THEN '75–100%'
                ELSE 'Out of range' END AS irrigation_bracket
    FROM climate
)
SELECT irrigation_bracket, COUNT(*) AS observations,
       ROUND(AVG(crop_yield_mt_per_ha), 3) AS avg_yield_mt_per_ha
FROM irrigation_bands
GROUP BY irrigation_bracket
ORDER BY irrigation_bracket;

-- Q9. Exploratory Pearson correlation only (non-causal).
SELECT COUNT(*) AS observations,
       ROUND(CORR(average_temperature_c::double precision,
                  crop_yield_mt_per_ha::double precision)::numeric, 3) AS temp_yield_r,
       ROUND(CORR(total_precipitation_mm::double precision,
                  crop_yield_mt_per_ha::double precision)::numeric, 3) AS rain_yield_r,
       ROUND(CORR(irrigation_access_percentage::double precision,
                  crop_yield_mt_per_ha::double precision)::numeric, 3) AS irrigation_yield_r
FROM climate;

-- Q10. Country–crop year-over-year average yield changes (window LAG).
WITH annual AS (
    SELECT country, crop_type, year,
           AVG(crop_yield_mt_per_ha) AS avg_yield
    FROM climate
    WHERE country IS NOT NULL AND crop_type IS NOT NULL AND year IS NOT NULL
    GROUP BY country, crop_type, year
),
changes AS (
    SELECT country, crop_type, year, avg_yield,
           LAG(avg_yield) OVER
             (PARTITION BY country, crop_type ORDER BY year) AS prior_observed_year_yield
    FROM annual
)
SELECT country, crop_type, year,
       ROUND(avg_yield, 3) AS avg_yield_mt_per_ha,
       ROUND(avg_yield - prior_observed_year_yield, 3) AS change_from_prior_observation
FROM changes
ORDER BY country, crop_type, year;

-- Q11. Review highest reported economic impact observations (not aggregate impact).
SELECT year, country, region, crop_type,
       economic_impact_million_usd,
       crop_yield_mt_per_ha
FROM climate
WHERE economic_impact_million_usd IS NOT NULL
ORDER BY economic_impact_million_usd DESC
LIMIT 10;

-- Q12. Crop yield distribution by crop, including robust median.
SELECT crop_type, COUNT(*) AS observations,
       ROUND(AVG(crop_yield_mt_per_ha), 3) AS mean_yield,
       ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP
           (ORDER BY crop_yield_mt_per_ha))::numeric, 3) AS median_yield
FROM climate
WHERE crop_type IS NOT NULL
GROUP BY crop_type
ORDER BY crop_type;
