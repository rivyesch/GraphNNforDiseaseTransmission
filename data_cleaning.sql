SELECT COUNT(*) FROM pairwise_distance;  
-- 463,833,330 rows

CREATE TABLE distinct_records AS
SELECT
    LEAST(person_id_1, person_id_2) AS min_person_id,
    GREATEST(person_id_1, person_id_2) AS max_person_id,
    distance,
    timestep,
    COUNT(*) AS duplicate_count
FROM
    pairwise_distance
GROUP BY
    distance, timestep, min_person_id, max_person_id
HAVING
    COUNT(*) > 1;

SELECT COUNT(*) FROM distinct_records;
-- 231,916,665 rows

CREATE INDEX idx_timestep ON distinct_records (timestep);

CREATE TABLE distinct_records_sorted
SELECT *
FROM distinct_records
ORDER BY timestep;

ALTER TABLE distinct_records_sorted
DROP COLUMN duplicate_count;

UPDATE distinct_records_sorted
SET distance = 0.1
WHERE distance = 0;
-- 167 rows changed from 0 to 0.1

SELECT * FROM distinct_records_sorted;

SELECT COUNT(*) FROM distinct_records_sorted;
-- 231,916,665 rows

SELECT COUNT(*) AS record_count
FROM distinct_records_sorted
WHERE distance > 1000;
-- 17,550,166 rows

CREATE INDEX idx_distance ON distinct_records_sorted (distance);
CREATE INDEX idx_min_id ON distinct_records_sorted (min_person_id);
CREATE INDEX idx_max_id ON distinct_records_sorted (max_person_id);
CREATE INDEX idx_timestep ON distinct_records_sorted (timestep);


CREATE TABLE filtered_records_10m AS
SELECT *
FROM distinct_records_sorted
WHERE distance <= 1000;

SELECT COUNT(*) FROM filtered_records_10m;
-- 214,366,499 rows

CREATE TABLE filtered_records_5m AS
SELECT *
FROM distinct_records_sorted
WHERE distance <= 500;
-- 100,245,863 rows
