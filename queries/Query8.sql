/*
Query 8
Find publications that have never been purchased by any customer in July 2022, but are the top 3
most purchased publications in August 2022.
*/


WITH July_Purchased AS (
  SELECT DISTINCT PubID
  FROM ItemsInOrder, Orders, StocksInBookstore
  WHERE Orders.OrderID = ItemsInOrder.OrderID AND StocksInBookstore.StockID = ItemsInOrder.StockID AND (Orders.OrderDate BETWEEN '2022/07/01' AND '2022/07/31 23:59:59.999')
),


august_purchased_pub AS (
  SELECT TOP 3 PubID, SUM(ItemQty) AS TotalQty
  FROM ItemsInOrder, Orders, StocksInBookstore
  WHERE Orders.OrderID = ItemsInOrder.OrderID AND StocksInBookstore.StockID = ItemsInOrder.StockID AND (Orders.OrderDate BETWEEN '2022/08/01' AND '2022/08/31 23:59:59.999')
  GROUP BY pubID
  ORDER BY TotalQty DESC
),

BooksAndMagazine AS (
  SELECT PubID, BookTitle AS Title
  FROM Books
  UNION 
  SELECT PubID, MagazineTitle AS Title
  FROM Magazines
)


SELECT BooksAndMagazine.PubID, BooksAndMagazine.Title
FROM BooksAndMagazine
LEFT JOIN July_Purchased jp ON BooksAndMagazine.pubID = JP.pubID
WHERE JP.pubID IS NULL
AND BooksAndMagazine.pubID IN (SELECT pubID FROM august_purchased_pub);