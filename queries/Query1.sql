/* Query 1: Find the average price of “Harry Porter Finale” on Ahamazon from 1 August 2022 to 31 August 2022.   

*/ 
 
SELECT AVG(Price) AS AveragePrice
FROM PriceHistory P
WHERE EXISTS
(
    SELECT StockID
    FROM StocksInBookstore S
    WHERE S.PubID =
    (
        SELECT PubID 
        FROM Books B 
        WHERE B.BookTitle = 'Harry Porter Finale'
    )
          AND P.StockID = S.StockID
          AND (
                  P.StartDate >= '2022-08-01 00:00:00'
                  AND P.EndDate <= '2022-08-31 23:59:59'
              )
);

