/* Query 3: For all publications purchased in June 2022 that have been delivered, find the average time from ordering date to delivery date. */

SELECT  StocksInBookstore.PubID, 
        AVG(CAST(DATEDIFF(hour, OrderDate, DeliveryDate) AS float)/ 24.00) AS NoOfDaysFromOrderToDelivery
FROM    ItemsInOrder, Orders, StocksInBookstore
WHERE   ItemsInOrder.OrderID = Orders.OrderID 
        AND DeliveryDate is Not NULL 
        AND (Orders.OrderDate >= '2022/06/01' AND Orders.OrderDate <= '2022/06/30 23:59:59')
        AND StocksInBookstore.StockID = ItemsInOrder.StockID
GROUP BY StocksInBookstore.PubID



