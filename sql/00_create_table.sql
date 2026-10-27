-- PostgreSQL 17 compatible. Execute once in a new portfolio database.
-- Schema follows the prior climate–agriculture SQL exercise; no raw data is included.
CREATE TABLE IF NOT EXISTS climate (
    year INTEGER,
    country VARCHAR(100),
    region VARCHAR(100),
    crop_type VARCHAR(100),
    average_temperature_c NUMERIC(6, 2),
    total_precipitation_mm NUMERIC(10, 2),
    co2_emissions_mt NUMERIC(10, 2),
    crop_yield_mt_per_ha NUMERIC(10, 3),
    extreme_weather_events INTEGER,
    irrigation_access_percentage NUMERIC(6, 2),
    pesticide_use_kg_per_ha NUMERIC(10, 2),
    fertilizer_use_kg_per_ha NUMERIC(10, 2),
    soil_health_index NUMERIC(6, 2),
    adaptation_strategies VARCHAR(100),
    economic_impact_million_usd NUMERIC(12, 2)
);
