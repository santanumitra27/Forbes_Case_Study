Create Database Forbes_CaseStudy_Dataset;

Use Forbes_CaseStudy_Dataset;

create table Forbes_data(
company	char (100),
sector char (100),	
industry char (100),
continent char (100),
country char (100),	
marketvalue int,	
sales int,	
profits	int,
assets	int,
rank_id int
);

select * from Forbes_data;

LOAD DATA LOCAL INFILE 'D:\\IVY\\SQL\\Final Project\\Forbes_CaseStudy_Dataset.csv'
INTO TABLE Forbes_data FIELDS TERMINATED BY ','ENCLOSED BY '"'LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

-- To avoid non-aggregated Coloumn Issue

SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- Retrieve the top 10 companies based on their market value, including their company name, sector, industry, and market value.

select marketvalue, company, sector, industry
from Forbes_data
order by marketvalue desc
limit 10;

-- Retrieve the top 10 companies based on their market value, including their company name, sector, industry, and market value. also give them a rank.

SELECT
    @rank := @rank + 1 AS rank_wise, company, sector, industry, marketvalue
FROM
    (SELECT @rank := 0) r,
    Forbes_data
ORDER BY
    marketvalue DESC
LIMIT 10;

-- Calculate the average sales, profits, and assets across all companies.

select company, Round(avg(sales)) as avg_sales, Round(avg(profits)) as avg_profits, Round(avg(assets)) as avg_assets
from Forbes_data
group by company;

-- Identify the sector with the highest average market value. 

select sector, avg(marketvalue) as avg_marketvalue
from forbes_data
group by sector
order by avg_marketvalue desc
limit 1;

-- Find the total number of companies for each continent.

select continent, count(*) as total_continent
from forbes_data
group by continent;

-- Determine the top 5 countries with the highest total sales.

select sum(sales) as total_sales, country
from forbes_data
group by country
order by total_sales desc
limit 5;

-- Calculate the average profit margin (profits as a percentage of sales) for each sector, sorted in descending order.

select avg((profits/sales)*100) as avg_profit_margin, sector
from forbes_data
group by sector
order by avg_profit_margin desc;

-- Find the company with the highest rank in each country.

select max(rank_id) as Highest_Rank, company
from forbes_data
group by company;

-- Identify the companies with profits greater than 1 billion and assets greater than 10 billion.

SELECT company, profits, assets
FROM forbes_data
WHERE profits > 10 AND assets > 1000;

-- Calculate the total market value for each industry, sorted in descending order.

select sum(marketvalue) as total_market_value, industry
from forbes_data
group by industry
order by total_market_value desc;

-- Identify the top 5 sectors with the highest total sales, considering only the companies with a market value greater than 1 billion.

SELECT
    sector,
    SUM(sales) AS total_sales
FROM
    forbes_data
WHERE
    marketvalue > 100
GROUP BY
    sector
ORDER BY
    total_sales DESC
LIMIT 5;

-- Calculate the market concentration ratio for each industry, defined as the percentage of market value contributed by the top 5 companies in that industry.
 
SELECT
    industry,
    (SUM(marketvalue) / (SELECT SUM(marketvalue) FROM forbes_data)) * 100 AS concentration_ratio
FROM
    forbes_data
WHERE rank_id <= '5'
GROUP BY
    industry;
    
-- Find the top 5 companies with the highest profit-to-sales ratio (profits divided by sales) in the technology sector.

select company, sector, (profits/sales) as Profit_to_sales_ratio
from forbes_data
where sector = "Information Technology"
order by Profit_to_sales_ratio desc
limit 5;

-- Calculate the average market value per employee for each sector. Sort the results in descending order.

select avg(marketvalue) as avg_mv, sector
from forbes_data
group by sector
order by avg_mv; 






































