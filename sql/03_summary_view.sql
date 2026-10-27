-- Reusable view for dashboarding or subsequent SQL analysis.
CREATE OR REPLACE VIEW climate_analysis_view AS
SELECT year, country, region, crop_type,
       COUNT(*) AS observation_count,
       ROUND(AVG(average_temperature_c), 2) AS avg_temperature_c,
       ROUND(AVG(total_precipitation_mm), 2) AS avg_precipitation_mm,
       ROUND(AVG(crop_yield_mt_per_ha), 3) AS avg_crop_yield_mt_per_ha,
       ROUND(AVG(irrigation_access_percentage), 2) AS avg_irrigation_access_pct,
       ROUND(AVG(economic_impact_million_usd), 2) AS avg_reported_economic_impact_musd
FROM climate
WHERE year IS NOT NULL AND country IS NOT NULL
  AND region IS NOT NULL AND crop_type IS NOT NULL
GROUP BY year, country, region, crop_type;

-- Query the view:
SELECT * FROM climate_analysis_view
ORDER BY year, country, crop_type
LIMIT 30;
