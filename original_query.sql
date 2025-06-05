SELECT 
    c.CategoryName,
    COUNT(p.ProductID) AS TotalProducts,
    AVG(CASE WHEN p.Resistant = 'durable' THEN p.Price ELSE NULL END) AS AvgResistantPrice,
    SUM(CASE WHEN p.IsAllergic = 'false' THEN 1 ELSE 0 END) AS NonAllergicCount,
    MAX(v.MaxVitality) AS MaxVitalityInCategory,
    DATEDIFF(CURDATE(), MAX(p.ModifyDate)) AS DaysSinceModify
FROM products p
LEFT JOIN categories c ON c.CategoryID = p.CategoryID
LEFT JOIN (
    SELECT CategoryID, MAX(VitalityDays) AS MaxVitality
    FROM products
    GROUP BY CategoryID
) v ON v.CategoryID = p.CategoryID
WHERE 
    LOWER(c.CategoryName) LIKE '%e%'
    AND YEAR(p.ModifyDate) = 2024
GROUP BY c.CategoryName
HAVING TotalProducts > 5
ORDER BY AvgResistantPrice DESC;
