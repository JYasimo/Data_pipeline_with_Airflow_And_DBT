
  
    

  create  table "postgres"."datamart"."dm_host_neighbourhod__dbt_tmp"
  
  
    as
  
  (
    -- Set the configuration for the materialized view


-- Create a Common Table Expression (CTE) called host_neighbourhood_lga_transform
-- This CTE retrieves data from the dim_host and dim_suburb tables and transforms it.
-- It includes host data, host neighborhood's local government area, and month_year.

WITH host_neighbourhood_lga_transform AS (
    SELECT 
        host.*,
        suburb.Local_Government_Area AS host_neighbourhood_lga,
        TO_CHAR(host.scraped_date, 'MM/YYYY') AS month_year
    FROM warehouse.dim_host host
    LEFT JOIN warehouse.dim_suburb suburb ON host.host_neighbourhood = suburb.Local_Government_Area_SUBURB
),
-- Create a CTE called distinct_host_count
-- This CTE calculates the number of distinct hosts for each host_neighbourhood_lga and month_year.
distinct_host_count AS (
    SELECT
        TO_CHAR(ht.scraped_date, 'MM/YYYY') AS month_year,
        ht.host_neighbourhood_lga,
        COUNT(DISTINCT ht.host_id) AS num_distinct_hosts
    FROM host_neighbourhood_lga_transform ht
    GROUP BY TO_CHAR(ht.scraped_date, 'MM/YYYY'),ht.host_neighbourhood_lga
),
-- Create a CTE called estimated_revenue
-- This CTE calculates the total estimated revenue for each host_neighbourhood_lga and month_year.
estimated_revenue AS (
    SELECT
        TO_CHAR(list.scraped_date, 'MM/YYYY') AS month_year,
        ht.host_neighbourhood_lga,
        SUM((30 - list.availability_30) * list.price) AS total_estimated_revenue
    FROM warehouse.fact_listing list
    LEFT JOIN host_neighbourhood_lga_transform ht ON list.surrogate_key_host = ht.surrogate_key_host
    WHERE list.has_availability = 't'
    GROUP BY
        TO_CHAR(list.scraped_date, 'MM/YYYY'),
        ht.host_neighbourhood_lga
)
-- Select the aggregated metrics including month_year, host_neighbourhood_lga, number of distinct hosts, total estimated revenue, and estimated revenue per host.
SELECT
    dh.host_neighbourhood_lga,
    dh.month_year,
    dh.num_distinct_hosts,
    er.total_estimated_revenue,
    CASE 
        WHEN dh.num_distinct_hosts > 0 THEN ROUND(er.total_estimated_revenue / dh.num_distinct_hosts, 2)
        ELSE 0
    END AS estimated_revenue_per_host
FROM distinct_host_count dh
LEFT JOIN estimated_revenue er ON dh.month_year = er.month_year AND dh.host_neighbourhood_lga = er.host_neighbourhood_lga
ORDER BY dh.host_neighbourhood_lga, dh.month_year
  );
  