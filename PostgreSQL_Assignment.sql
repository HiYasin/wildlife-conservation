-- Active: 1748239997772@@127.0.0.1@5432@conservation_db
CREATE DATABASE conservation_db;

CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region TEXT NOT NULL
);

CREATE TABLE species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) NOT NULL
);

CREATE TABLE sightings(
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT NOT NULL REFERENCES rangers(ranger_id),
    species_id INT NOT NULL REFERENCES species(species_id),
    sighting_time TIMESTAMP NOT NULL ,
    location TEXT NOT NULL,
    notes TEXT
);

INSERT INTO rangers (ranger_id, name, region) VALUES
  (1, 'Alice Green', 'Northern Hills'),
  (2, 'Bob White', 'River Delta'),
  (3, 'Carol King', 'Mountain Range');

INSERT INTO species (species_id, common_name, scientific_name, discovery_date, conservation_status) VALUES
  (1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
  (2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
  (3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
  (4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

INSERT INTO sightings (sighting_id, species_id, ranger_id, location, sighting_time, notes) VALUES
  (1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
  (2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
  (3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
  (4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);



-- Problem 1
INSERT INTO rangers (ranger_id,name, region) VALUES
  (4, 'Derek Fox', 'Coastal Plains');


-- Problem 2
SELECT count(DISTINCT species_id) as unique_species_count FROM sightings;


-- Problem 3
SELECT * FROM sightings WHERE location ILIKE '%Pass%';


-- Problem 4
SELECT name, count(*) AS total_sightings FROM sightings JOIN rangers USING(ranger_id)
GROUP BY name ORDER BY name;


-- Problem 5
SELECT common_name FROM species
WHERE species_id NOT IN(SELECT DISTINCT species_id FROM sightings);


-- Problem 6
SELECT common_name, sighting_time, name
FROM (SELECT * FROM sightings JOIN rangers USING(ranger_id)) JOIN species USING (species_id)
ORDER BY sighting_time DESC
LIMIT 2;


-- Problem 7
UPDATE species
SET conservation_status = 'Historic'
WHERE extract(year from discovery_date::date) < 1800;



-- Problem 8
SELECT sighting_id,
CASE 
    WHEN EXTRACT(hour from sighting_time) < 12 THEN 'Morning'
    WHEN EXTRACT(hour from sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ElSE 'Evening'
END AS time_of_day
FROM sightings



-- Problem 9
DELETE FROM rangers
WHERE ranger_id NOT IN (SELECT ranger_id FROM sightings GROUP BY ranger_id);
