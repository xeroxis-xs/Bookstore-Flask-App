/* Query 6: Find bookstores that made the most revenue in August 2022 */

SELECT StocksInBookstore.CompanyID, SUM(ItemQty * ItemPrice) AS TotalRevenueInAugust
FROM ItemsInOrder, Orders, StocksInBookstore
WHERE ItemsInOrder.OrderID = Orders.OrderID
      AND (Orders.OrderDate >= '2022-08-01' AND Orders.OrderDate <= '2022-08-31 23:59:59') 
      AND StocksInBookstore.StockID = ItemsInOrder.StockID 
      AND ItemsInOrder.ItemID NOT IN 
      (
        SELECT StatusForOrderItems.ItemID
        FROM StatusForOrderItems
        WHERE StatusForOrderItems.CurrentState = 'Returned'
      )
GROUP BY StocksInBookstore.CompanyID
ORDER BY TotalRevenueInAugust DESC