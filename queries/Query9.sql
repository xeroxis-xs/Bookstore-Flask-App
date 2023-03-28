/* Query 9: Find publications that are increasingly being purchased over at least 3 months */

WITH SALES AS (
	SELECT  StocksInBookstore.PubID, Year(Orders.OrderDate) as YearOfOrder,
            Month(Orders.OrderDate) AS MonthOfYear, SUM(ItemQty) as StockSoldQty
	FROM StocksInBookstore, Orders, ItemsInOrder
	WHERE   StocksInBookstore.StockID = ItemsInOrder.StockID
            AND Orders.OrderID = ItemsInOrder.OrderID 
	GROUP BY StocksInBookstore.PubID, Year(Orders.OrderDate), Month(Orders.OrderDate)
),

BooksAndMagazine AS (
	SELECT PubID, BookTitle AS Title
	FROM Books
	UNION 
	SELECT PubID, MagazineTitle AS Title
	FROM Magazines
)

SELECT BooksAndMagazine.PubID,  Title, Month1, Month1_Sales,Month2, Month2_Sales,Month3, Month3_Sales
FROM BooksAndMagazine, 
    (
        SELECT DISTINCT s1.PubID,  Convert(varchar,s1.MonthOfYear)  + '/'+ Convert(varchar,s1.YearOfOrder) AS Month1,
                        s1.StockSoldQty as Month1_Sales, 
                        Convert(varchar,s2.MonthOfYear)  + '/'+ Convert(varchar,s2.YearOfOrder) AS Month2,  
                        s2.StockSoldQty as Month2_Sales, Convert(varchar,s3.MonthOfYear)  + '/'+ Convert(varchar,s3.YearOfOrder) AS Month3, 
                        s3.StockSoldQty as Month3_Sales
        FROM SALES s1, SALES s2, SALES s3
        WHERE  	(s3.MonthOfYear - s2.MonthOfYear = 1 OR s3.MonthOfYear - s2.MonthOfYear = -11) AND s3.YearOfOrder >= s2.YearOfOrder 
				AND (s2.MonthOfYear - s1.MonthOfYear = 1 OR s2.MonthOfYear - s1.MonthOfYear = -11) 
                AND s2.YearOfOrder >= s1.YearOfOrder AND s3.MonthOfYear != s2.MonthOfYear AND s2.MonthOfYear != s1.MonthOfYear 
                AND s3.MonthOfYear != s1.MonthOfYear AND s3.StockSoldQty > s2.StockSoldQty AND S2.MonthOfYear > s1.StockSoldQty
                AND s1.PubID = s2.PubID AND s2.PubID = s3.PubID
	) AS IncreasingPubIDSales
WHERE BooksAndMagazine.PubID = IncreasingPubIDSales.PubID