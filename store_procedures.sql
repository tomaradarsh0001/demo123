-- property_count_and_area

CREATE DEFINER=`admin`@`%` PROCEDURE `property_count_and_area`()
BEGIN
select count(pm.id) as total_count, sum(plot_area_in_sqm) as total_area
from property_masters pm
join property_lease_details pld
on pm.id = pld.property_master_id;
END










-- get_property_area_details

CREATE DEFINER=`admin`@`%` PROCEDURE `get_property_area_details`()
BEGIN
WITH property_data AS (
    SELECT
        pm.id,
        plot_area_in_sqm
    FROM
        property_masters pm
    JOIN
        property_lease_details pld ON pld.property_master_id = pm.id
)
SELECT
    'count' AS type,
    SUM(CASE WHEN plot_area_in_sqm <= 50 THEN 1 ELSE 0 END) AS '<50',
    SUM(CASE WHEN plot_area_in_sqm > 50 AND plot_area_in_sqm <= 100 THEN 1 ELSE 0 END) AS '51-100',
    SUM(CASE WHEN plot_area_in_sqm > 100 AND plot_area_in_sqm <= 250 THEN 1 ELSE 0 END) AS '101-250',
    SUM(CASE WHEN plot_area_in_sqm > 250 AND plot_area_in_sqm <= 350 THEN 1 ELSE 0 END) AS '251-350',
    SUM(CASE WHEN plot_area_in_sqm > 350 AND plot_area_in_sqm <= 500 THEN 1 ELSE 0 END) AS '351-500',
    SUM(CASE WHEN plot_area_in_sqm >500  AND plot_area_in_sqm <= 750 THEN 1 ELSE 0 END) AS '500-750',
    SUM(CASE WHEN plot_area_in_sqm > 751 AND plot_area_in_sqm <= 1000 THEN 1 ELSE 0 END) AS '751-1000',
    SUM(CASE WHEN plot_area_in_sqm > 1000 AND plot_area_in_sqm <= 2000 THEN 1 ELSE 0 END) AS '1001-2000',
    SUM(CASE WHEN plot_area_in_sqm > 2000 THEN 1 ELSE 0 END) AS '>2000'
FROM
    property_data
UNION
SELECT
    'area' AS type,
    Round(SUM(CASE WHEN plot_area_in_sqm <= 50 THEN plot_area_in_sqm ELSE 0 END)) AS '<50',
    Round(SUM(CASE WHEN plot_area_in_sqm > 50 AND plot_area_in_sqm <= 100 THEN plot_area_in_sqm ELSE 0 END))AS '51-100',
    Round(SUM(CASE WHEN plot_area_in_sqm > 100 AND plot_area_in_sqm <= 250 THEN plot_area_in_sqm ELSE 0 END)) AS '101-250',
    Round(SUM(CASE WHEN plot_area_in_sqm > 250 AND plot_area_in_sqm <= 350 THEN plot_area_in_sqm ELSE 0 END))AS '251-350',
    Round(SUM(CASE WHEN plot_area_in_sqm > 350 AND plot_area_in_sqm <= 500 THEN plot_area_in_sqm ELSE 0 END)) AS '351-500',
    Round(SUM(CASE WHEN plot_area_in_sqm > 500 AND plot_area_in_sqm <= 750 THEN plot_area_in_sqm ELSE 0 END)) AS '500-750',
    Round(SUM(CASE WHEN plot_area_in_sqm > 751 AND plot_area_in_sqm <= 1000 THEN plot_area_in_sqm ELSE 0 END))AS '751-1000',
    Round(SUM(CASE WHEN plot_area_in_sqm > 1000 AND plot_area_in_sqm <= 2000 THEN plot_area_in_sqm ELSE 0 END)) AS '1001-2000',
    Round(SUM(CASE WHEN plot_area_in_sqm > 2000 THEN plot_area_in_sqm ELSE 0 END) )AS '>2000'
FROM
    property_data;
END








-- count_status

CREATE DEFINER=`admin`@`%` PROCEDURE `count_status`()
BEGIN
SELECT 
    i.item_name, (case when ptc.counter is null then 0 else ptc.counter end) as counter
FROM
    (SELECT 
        status, COUNT(status) AS counter
    FROM
        property_masters group by status) ptc
      Right  JOIN
    (SELECT 
    *
FROM
    items
WHERE
    group_id = 109
        AND is_active = 1 and item_order < 1000)i ON ptc.status = i.id;
END







-- count-property-type 

CREATE DEFINER=`admin`@`%` PROCEDURE `count_property_type`()
BEGIN
 SELECT 
    i.item_name, (case when ptc.counter is null then 0 else ptc.counter end) as counter
FROM
    (SELECT 
        property_type, COUNT(property_type) AS counter
    FROM
        property_masters group by property_type) ptc
      Right  JOIN
    (SELECT 
    *
FROM
    items
WHERE
    group_id = 1052
        AND is_active = 1 and item_order < 1000)i ON ptc.property_type = i.id;
END








-- count_land 

CREATE DEFINER=`admin`@`%` PROCEDURE `count_land`()
BEGIN
SELECT 
    i.item_name,
    (CASE
        WHEN pm.counter IS NULL THEN 0
        ELSE pm.counter
    END) AS counter
FROM
    (SELECT 
        *
    FROM
        items
    WHERE
        group_id = 1051
            AND is_active = 1
            AND item_order < 1000) i
        LEFT JOIN
    (SELECT 
        land_type, COUNT(land_type) AS counter
    FROM
        property_masters group by land_type) pm ON pm.land_type = i.id;
END









-- bar_chart_data 

CREATE DEFINER=`admin`@`%` PROCEDURE `bar_chart_data`()
BEGIN
SELECT 
    i.item_name AS land,
    SUM(CASE WHEN plot_area_in_sqm <= 50 THEN 1 ELSE 0 END) AS '<50',
    SUM(CASE WHEN plot_area_in_sqm > 50 AND plot_area_in_sqm <= 100 THEN 1 ELSE 0 END) AS '51-100',
    SUM(CASE WHEN plot_area_in_sqm > 100 AND plot_area_in_sqm <= 250 THEN 1 ELSE 0 END) AS '101-250',
    SUM(CASE WHEN plot_area_in_sqm > 250 AND plot_area_in_sqm <= 350 THEN 1 ELSE 0 END) AS '251-350',
    SUM(CASE WHEN plot_area_in_sqm > 350 AND plot_area_in_sqm <= 500 THEN 1 ELSE 0 END) AS '351-500',
    SUM(CASE WHEN plot_area_in_sqm > 500 AND plot_area_in_sqm <= 750 THEN 1 ELSE 0 END) AS '501-750',
    SUM(CASE WHEN plot_area_in_sqm > 750 AND plot_area_in_sqm <= 1000 THEN 1 ELSE 0 END) AS '751-1000',
    SUM(CASE WHEN plot_area_in_sqm > 1000 AND plot_area_in_sqm <= 2000 THEN 1 ELSE 0 END) AS '1001-2000',
    SUM(CASE WHEN plot_area_in_sqm > 2000 THEN 1 ELSE 0 END) AS '>2000'
FROM
    property_masters pm
JOIN
    property_lease_details pld ON pld.property_master_id = pm.id
Right  JOIN
    (SELECT 
    *
FROM
    items
WHERE
    group_id = 1051
        AND is_active = 1 and item_order < 1000)i ON pm.land_type = i.id
GROUP BY 
    i.item_name;
END