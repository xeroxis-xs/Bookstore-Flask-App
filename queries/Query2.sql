/* Query 2: Find publications that received at least 10 ratings of "5" in August 2022, and rank them by their average ratings 
*/

WITH BooksAndMagazine AS (
    (SELECT PubID, BookTitle AS Title
    FROM Books)
    UNION 
    (SELECT PubID, MagazineTitle AS Title
    FROM Magazines)
)

SELECT BooksAndMagazine.PubID, BooksAndMagazine.Title, AverageRating
FROM StocksInBookstore, BooksAndMagazine, 
    (
        SELECT StockID, AVG(CAST(Rating AS float)) AS AverageRating
    	FROM Feedback
    	WHERE StockID IN 
    		(
        		SELECT StockID
        		FROM Feedback
        		WHERE Rating = 5 
        		AND FeedbackDateTime >= '2022-08-01' 
        		AND FeedbackDateTime <= '2022-08-31 23:59:59'
        		GROUP BY StockID
        		HAVING COUNT(Rating) >= 10
    		)
    	GROUP BY StockID
	) AS AverageRatingTable
WHERE StocksInBookstore.StockID = AverageRatingTable.StockID AND StocksInBookstore.PubID = BooksAndMagazine.PubID
ORDER BY AverageRating