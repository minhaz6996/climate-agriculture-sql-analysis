-- OPTIONAL DEMONSTRATION ONLY.
-- All values below are FICTIONAL and must never be presented as thesis findings.
-- Use in a fresh EMPTY table only; don't mix with research data.
INSERT INTO climate (
  year, country, region, crop_type, average_temperature_c,
  total_precipitation_mm, co2_emissions_mt, crop_yield_mt_per_ha,
  extreme_weather_events, irrigation_access_percentage,
  pesticide_use_kg_per_ha, fertilizer_use_kg_per_ha,
  soil_health_index, adaptation_strategies, economic_impact_million_usd
) VALUES
(2021,'Demo Country A','North','Rice',27.40,1400,10.20,3.110,2,61,2.30,45.10,72,'Drought-resistant crops',11.40),
(2022,'Demo Country A','North','Rice',27.90,1300,10.70,3.020,3,63,2.40,46.20,71,'Drought-resistant crops',11.80),
(2023,'Demo Country A','North','Rice',28.10,1360,10.90,3.180,2,65,2.35,47.20,73,'Improved irrigation',12.00),
(2024,'Demo Country A','North','Rice',28.40,1250,11.10,3.060,3,66,2.45,48.10,72,'Improved irrigation',12.20),
(2021,'Demo Country A','South','Wheat',24.40,760,10.20,2.400,1,55,1.90,38.30,68,'Crop rotation',8.20),
(2022,'Demo Country A','South','Wheat',24.70,790,10.70,2.510,1,58,1.95,39.00,70,'Crop rotation',8.40),
(2023,'Demo Country A','South','Wheat',25.10,720,10.90,2.440,2,59,2.05,40.20,69,'Crop rotation',8.50),
(2024,'Demo Country A','South','Wheat',25.50,740,11.10,2.480,2,60,2.10,40.90,69,'Improved irrigation',8.80),
(2021,'Demo Country B','East','Maize',23.30,1090,8.20,4.210,1,47,2.10,35.00,74,'Soil conservation',9.10),
(2022,'Demo Country B','East','Maize',23.60,1120,8.50,4.340,2,48,2.15,35.90,74,'Soil conservation',9.20),
(2023,'Demo Country B','East','Maize',24.00,1080,8.70,4.180,2,50,2.20,36.50,73,'Soil conservation',9.40),
(2024,'Demo Country B','East','Maize',24.20,1110,8.90,4.390,1,52,2.25,37.20,75,'Improved irrigation',9.50);
