# ---------------------------Q1------------------------------------------

select p.product_name, e.base_price from dim_products p 
join fact_events e  on p.product_code = e.product_code 
where base_price > 500 and promo_type = 'BOGOF'
group by product_name;

 ---------------------------OR------------------------------------------
SELECT 
    dim_products.product_name,
    COUNT(fact_events.product_code) AS quantity_sold
FROM
    fact_events
        JOIN
    dim_products ON dim_products.product_code = fact_events.product_code
WHERE
    fact_events.base_price > 500
        AND fact_events.promo_type = 'BOGOF'
GROUP BY dim_products.product_name;

 #---------------------------------Q2------------------------------------------
 
 SELECT  city,COUNT(store_id) as No_Of_Stores from dim_stores
 group by city 
 order by No_Of_Stores desc;
 
 #---------------------------------Q3------------------------------------------
 
 select campaign_name,
		sum(base_price * `quantity_sold(before_promo)`) as revenuebeforepromo, 
        sum(base_price * `quantity_sold(after_promo)`) as revenueafterpromo
        from fact_events join dim_campaigns
        on dim_campaigns.campaign_id = fact_events.campaign_id
        group by campaign_name;
        
 #---------------------------------Q4------------------------------------------    
 
 select dim_products.category,
		round(((sum(`quantity_sold(after_promo)`) - sum(`quantity_sold(before_promo)`))/
		sum(`quantity_sold(before_promo)`)),2) *100 as isuPercentage,
        
        rank() over(order by round(((sum(`quantity_sold(after_promo)`) - sum(`quantity_sold(before_promo)`))/
		sum(`quantity_sold(before_promo)`)),2) *100 DESC) as RankOrder
		from fact_events 
        join dim_products 
        on fact_events.product_code = dim_products.product_code
        where campaign_id = 'CAMP_DIW_01'
        group by category;
 
 
  #---------------------------------Q5------------------------------------------
  
  #Product name , category , IR% across all campaign. Ranking by IR%

select dim_products.product_name, dim_products.category,
		round(((sum(base_price * `quantity_sold(after_promo)`) - sum(base_price * `quantity_sold(before_promo)`))/
		sum(base_price * `quantity_sold(before_promo)`)),2) *100 as irPercentage
        from fact_events 
        join dim_products 
        on fact_events.product_code = dim_products.product_code
        group by product_name,category
        order by irPercentage desc