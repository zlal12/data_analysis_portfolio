-- # 1. Top Performing Products by Category
WITH RankedProducts AS (
    SELECT
        product_id,
        product_name,
        big_category AS category,
        rating,
        ROW_NUMBER() OVER (PARTITION BY big_category ORDER BY rating DESC) AS rank
    FROM public.amazon
)
SELECT
    product_id,
    product_name,
    category,
    rating
FROM RankedProducts
WHERE rank <= 3;

-- # 2. Price Analysis - products with a higher-than-average discount percentage within each category
WITH CategoryDiscountAvg AS (
    SELECT
        big_category AS category,
        AVG(discount_percentage) AS avg_discount
    FROM public.amazon
    GROUP BY category
)
SELECT
    p.product_id,
    p.product_name,
    p.big_category AS category,
    p.discount_percentage,
    cda.avg_discount
FROM public.amazon p
JOIN CategoryDiscountAvg cda
    ON p.big_category = cda.category
WHERE p.discount_percentage > cda.avg_discount;

-- # 3. Customer Segmentation by Review Activity - top 10% of reviews
WITH ReviewCounts AS (
    SELECT
        user_id,
        COUNT(review_id) AS review_count
    FROM public.amazon
    GROUP BY user_id
),
RankedReviews AS (
    SELECT
        user_id,
        review_count,
        NTILE(10) OVER (ORDER BY review_count DESC) AS review_segment
    FROM ReviewCounts
)
SELECT
    user_id,
    review_count,
    review_segment
FROM RankedReviews
WHERE review_segment = 1;

-- # 4. Price Fluctuation and Discount Trends
WITH CategoryAvgDiscount AS (
    SELECT
        big_category AS category,
        AVG(discount_percentage) AS avg_discount
    FROM public.amazon
    GROUP BY category
)
SELECT
    p.product_id,
    p.product_name,
    p.big_category AS category,
    p.discount_percentage,
    cad.avg_discount,
    RANK() OVER (PARTITION BY p.big_category ORDER BY p.discount_percentage DESC) AS discount_rank
FROM public.amazon p
JOIN CategoryAvgDiscount cad
    ON p.big_category = cad.category
WHERE p.discount_percentage > cad.avg_discount;


-- # 5. Outlier Products Based on Rating vs. Review Count
WITH ProductStats AS (
    SELECT
        product_id,
        rating,
        rating_count,
        AVG(rating) OVER () AS avg_rating,
        STDDEV(rating) OVER () AS stddev_rating
    FROM public.amazon
)
SELECT
    product_id,
    rating,
    rating_count,
    avg_rating,
    stddev_rating
FROM ProductStats
WHERE rating > avg_rating + 2 * stddev_rating 
   OR rating < avg_rating - 2 * stddev_rating;
