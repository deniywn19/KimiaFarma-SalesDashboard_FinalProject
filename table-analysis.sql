WITH 
-- CTE untuk menghitung persentase laba berdasarkan harga produk
profit_calculation AS (
    SELECT 
        product_id,
        price,
        CASE
            WHEN price <= 50000 THEN 0.10
            WHEN price <= 100000 THEN 0.15
            WHEN price <= 300000 THEN 0.20
            WHEN price <= 500000 THEN 0.25
            ELSE 0.30
        END AS persentase_gross_laba
    FROM `dataset_kimiafarma.product`
),

-- CTE untuk menggabungkan semua data transaksi dengan informasi terkait
transaction_base AS (
    SELECT 
        t.*,
        b.branch_name,
        b.kota,
        b.provinsi,
        b.rating as rating_cabang,
        p.product_name,
        p.price as actual_price,
        pm.persentase_gross_laba
    FROM `dataset_kimiafarma.transaction` t
    LEFT JOIN `dataset_kimiafarma.branch` b ON t.branch_id = b.branch_id
    LEFT JOIN `dataset_kimiafarma.product` p ON t.product_id = p.product_id
    LEFT JOIN profit_calculation pm ON t.product_id = pm.product_id
)

-- Query utama untuk menampilkan hasil analisis
SELECT 
    transaction_id,
    CAST(date AS DATE) as date,
    branch_id,
    branch_name,
    kota,
    provinsi,
    rating_cabang,
    customer_name,
    product_id,
    product_name,
    actual_price,
    discount_percentage,
    persentase_gross_laba,
    ROUND(actual_price * (1 - discount_percentage), 2) as nett_sales,
    ROUND(actual_price * (1 - discount_percentage) * persentase_gross_laba, 2) as nett_profit,
    rating as rating_transaksi
FROM transaction_base
ORDER BY date;