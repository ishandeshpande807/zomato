select * from zomatosql;
select count(distinct(RestaurantID)) from zomatosql;
select * from cuisines;
select count(distinct(RestaurantID)) from cuisines;


/*KPI'S*/

select COUNT(DISTINCT CountryCode) AS total_countries from zomatosql;

select COUNT(DISTINCT City) AS total_citys from zomatosql;

select COUNT(DISTINCT RestaurantID) AS total_restaurants from zomatosql;

select COUNT(DISTINCT Cuisines) AS total_cuisines from cuisines;

select concat(sum(Votes)/1000000,'M') AS total_votes from zomatosql;

select left(avg(Rating),4) AS avgrating from zomatosql;



/*2. Build a Calendar Table using the Column Datekey
  Add all the below Columns in the Calendar Table using the Formulas.
   A.Year
   B.Monthno
   C.Monthfullname
   D.Quarter(Q1,Q2,Q3,Q4)
   E. YearMonth ( YYYY-MMM)
   F. Weekdayno
   G.Weekdayname
   H.FinancialMOnth ( April = FM1, May= FM2  …. March = FM12)
   I. Financial Quarter ( Quarters based on Financial Month)*/
   
   select year(Datekey_Opening) as year from zomatosql;
   
   select month(Datekey_Opening) monthno from zomatosql;
   
   select monthname(Datekey_Opening) as monthfullname from zomatosql;
   
   select concat('Q', quarter(Datekey_Opening)) as Quarter from zomatosql;
   
   select concat(year(Datekey_Opening) ,'-', left( monthname(Datekey_Opening),3)) 
   as yearmonth from zomatosql;
   
   select weekday(Datekey_Opening) as weekdayno from zomatosql;
   
   select date_format(Datekey_Opening,'%W') as weekdayname from zomatosql;
   
   SELECT 
    CASE 
        WHEN MONTH(Datekey_Opening) = 4 THEN 'FM1'
        WHEN MONTH(Datekey_Opening) = 5 THEN 'FM2'
        WHEN MONTH(Datekey_Opening) = 6 THEN 'FM3'
        WHEN MONTH(Datekey_Opening) = 7 THEN 'FM4'
        WHEN MONTH(Datekey_Opening) = 8 THEN 'FM5'
        WHEN MONTH(Datekey_Opening) = 9 THEN 'FM6'
        WHEN MONTH(Datekey_Opening) = 10 THEN 'FM7'
        WHEN MONTH(Datekey_Opening) = 11 THEN 'FM8'
        WHEN MONTH(Datekey_Opening) = 12 THEN 'FM9'
        WHEN MONTH(Datekey_Opening) = 1 THEN 'FM10'
        WHEN MONTH(Datekey_Opening) = 2 THEN 'FM11'
        WHEN MONTH(Datekey_Opening) = 3 THEN 'FM12'
    END AS financial_month
FROM zomatosql;

SELECT 
    CASE 
        WHEN MONTH(Datekey_Opening) IN (1, 2, 3) THEN 'FQ4'
        WHEN MONTH(Datekey_Opening) IN (4, 5, 6) THEN 'FQ2'
        WHEN MONTH(Datekey_Opening) IN (7, 8, 9) THEN 'FQ3'
        WHEN MONTH(Datekey_Opening) IN (10, 11, 12) THEN 'FQ1'
    END AS financial_quarter
FROM zomatosql;


/*3.Find the Numbers of Resturants based on City and Country.*/

SELECT Countryname, city , COUNT(RestaurantID) AS restaurant_count
FROM zomatosql
GROUP BY Countryname , city ;

SELECT Countryname, COUNT(RestaurantID) AS restaurant_count
FROM zomatosql
GROUP BY Countryname ;

SELECT city , COUNT(RestaurantID) AS restaurant_count
FROM zomatosql
GROUP BY city;


/*4.Numbers of Resturants opening based on Year , Quarter , Month*/

select year(Datekey_Opening) as 'year' , count(RestaurantID) as 'number of restaurant'
from zomatosql
group by year(Datekey_Opening);

select concat('Q', quarter(Datekey_Opening)) as 'Quarter' , count(RestaurantID) as 'number of restaurant'
from zomatosql
group by concat('Q', quarter(Datekey_Opening));

select monthname(Datekey_Opening) as 'month' , count(RestaurantID) as 'number of restaurant'
from zomatosql
group by monthname(Datekey_Opening);


/*Count of Resturants based on Average Ratings*/

select left(avg(Rating),4) as avgrating from zomatosql;

SELECT 
    CASE
        WHEN rating >= 4.5 THEN 'Excellent (>=4.5)'
        WHEN rating >= 4.0 THEN 'Very Good (>=4.0)'
        WHEN rating >= 3.0 THEN 'Good (>=3.0)'
        WHEN rating >= 2.0 THEN 'Fair (>=2.0)'
        ELSE 'Poor (<2.0)'
    END AS rating_category,
    COUNT(RestaurantID) AS restaurant_count
FROM zomatosql
GROUP BY rating_category;

/*6. Create buckets based on Average Price of reasonable size and
 find out how many resturants falls in each buckets*/
 
 select left(avg(Average_Cost_for_two),4) as avgprice from zomatosql;
 
 SELECT 
    CASE 
        WHEN Average_Cost_for_two BETWEEN 0 AND 600 THEN 'LOW (0-600)'
        WHEN Average_Cost_for_two BETWEEN 601 AND 1200 THEN 'AVG(601-1200)'
        WHEN Average_Cost_for_two BETWEEN 1201 AND 2000 THEN 'MEDIUM(1201-2000)'
        WHEN Average_Cost_for_two BETWEEN 2001 AND 4000 THEN 'HIGH(2001-4000)'
        ELSE 'EXPENSIVE(ABOVE 4000)'
    END AS price_bucket,
    COUNT(RestaurantID) AS restaurant_count
FROM zomatosql
GROUP BY price_bucket;


/*7.Percentage of Resturants based on "Has_Table_booking"*/

SELECT 
    Has_Table_booking,
    COUNT(RestaurantID) AS restaurant_count,
    CONCAT((COUNT(Has_Table_booking) / (SELECT COUNT(RestaurantID) FROM zomatosql)) * 100,'%') AS percentage
FROM zomatosql
GROUP BY Has_Table_booking;


/*8.Percentage of Resturants based on "Has_Online_delivery"*/

SELECT 
    Has_Online_delivery,
    COUNT(RestaurantID) AS restaurant_count,
    CONCAT((COUNT(Has_Online_delivery) / (SELECT COUNT(RestaurantID) FROM zomatosql)) * 100,'%') AS percentage
FROM zomatosql
GROUP BY Has_Online_delivery;


/*9. Develop Charts based on Cusines, City, Ratings*/

select city, left(avg(Rating),4) as  avgrating from zomatosql
group by City
order by avgrating desc;

select city,  left(avg(rating),4) as avgrating
from (select city, Rating , Countryname from zomatosql where Countryname='india' )
as indiaonly
group by city
order by avgrating desc;

select ifnull(Cuisines,'-') as cuisines, left(avg(Rating),4) as  avgrating
from cuisines as c join zomatosql as z on c.RestaurantID=z.RestaurantID
group by cuisines
order by avgrating desc;

SELECT z.City, ifnull(cu.Cuisines,'-') as cuisines, left(AVG(z.rating),4) AS avg_rating
FROM zomatosql as z JOIN cuisines as cu ON z.RestaurantID = cu.RestaurantID
GROUP BY z.City, cu.Cuisines
ORDER BY AVG_RATING desc;
















   