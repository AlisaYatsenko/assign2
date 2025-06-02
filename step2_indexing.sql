CREATE INDEX idx_categories ON categories(CategoryName);
CREATE INDEX idx_products1 ON products(CategoryID, ModifyDate);
CREATE INDEX idx_products2 ON products(Resistant, Price);
explain (SELECT 
    c.CategoryName,
    COUNT(p.ProductID) AS TotalProducts,
    AVG(if(p.Resistant = 'durable', p.Price, null)) AS AvgResistantPrice,
    SUM(if(p.IsAllergic = 'false', 1, 0)) AS NonAllergicCount,
    MAX(p.VitalityDays) AS MaxVitalityInCategory,
    DATEDIFF(CURDATE(), 
    MAX(p.ModifyDate)) AS DaysSinceModify
FROM products p
LEFT JOIN categories c ON c.CategoryID = p.CategoryID
WHERE 
    c.CategoryName LIKE '%e%'
    AND p.ModifyDate >= '2017-01-01' and p.ModifyDate <= '2017-12-31'
GROUP BY c.CategoryName
HAVING TotalProducts > 5
ORDER BY AvgResistantPrice DESC)
