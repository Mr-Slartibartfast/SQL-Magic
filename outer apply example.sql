SELECT
    c.CustomerID,
    c.Name,
    o.OrderID,
    o.OrderDate
FROM Customers c
OUTER APPLY
(
    SELECT TOP 1
        OrderID,
        OrderDate
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
    ORDER BY OrderDate DESC
) o