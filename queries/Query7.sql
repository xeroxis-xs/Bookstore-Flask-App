/* Query 7: For customers that made the most number of complaints, find the most expensive publication he/she has ever purchased. */


WITH CustomerAndComplaintCounts AS 
(
    SELECT Complaints.CustomerID, Count(*) AS NumberOfComplaints
    FROM Complaints
    GROUP BY CustomerID
),
CustomersWithMostComplaints AS 
(
    SELECT Complaints.CustomerID,  Count(*) AS NumberOfComplaints
    FROM Complaints
    GROUP BY Complaints.CustomerID
    HAVING Count(*) = 
        (
            SELECT Max(NumberOfComplaints) AS MaximumComplaintCount
			FROM CustomerAndComplaintCounts
        )
),
BooksAndMagazine AS (
    (SELECT PubID, BookTitle AS Title
    FROM Books)
    UNION 
    (SELECT PubID, MagazineTitle AS Title
    FROM Magazines)
)


SELECT  Customers.CustomerID, CustName, NumberOfComplaints as TotalComplaintsForCustomer,
		BooksAndMagazine.PubID,  Title, ItemPrice
FROM BooksAndMagazine,  Customers,	
    (
        SELECT DISTINCT C.CustomerID, PubID, ItemPrice, C.NumberOfComplaints
		FROM CustomersWithMostComplaints AS C, Orders AS O, ItemsInOrder AS I, StocksInBookstore AS S
		WHERE C.CustomerID = O.CustomerID AND O.OrderID = I.OrderID AND S.StockID = I.StockID
		AND EXISTS 
            (
                SELECT CustomersWithMostComplaints.CustomerID, MAX(ItemPrice) AS MaxItemPrice
				FROM CustomersWithMostComplaints, Orders, ItemsInOrder
				WHERE 
                    CustomersWithMostComplaints.CustomerID = Orders.CustomerID 
					AND Orders.OrderID = ItemsInOrder.OrderID
				    AND C.CustomerID = CustomersWithMostComplaints.CustomerID
				GROUP BY CustomersWithMostComplaints.CustomerID
				HAVING I.ItemPrice = MAX(ItemsInOrder.ItemPrice)
            )
    ) AS Customers_PubID_MostExpensive
WHERE BooksAndMagazine.PubID = Customers_PubID_MostExpensive.PubID AND Customers.CustomerID = Customers_PubID_MostExpensive.CustomerID

