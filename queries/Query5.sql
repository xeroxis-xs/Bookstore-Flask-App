/* Query 5 
Produce a list that contains (i) all publications published by Nanyang Publisher Company, 
and (ii) for each of them, the number of bookstores on Ahamazon that sell them. 
*/

-- Finding the Magazine Title that Each Publication ID Relates to
WITH PubAndMag AS (
    SELECT  Publication.PubID, Publication.Publisher, Publication.YearOfPub, 
            Magazines.IssueNumber, Magazines.MagazineTitle
    FROM Publication
    INNER JOIN Magazines ON Publication.PubID = Magazines.PubID
),

-- Finding the Book Title that Each Publication ID Relates to
PubAndBook AS (
    SELECT  Publication.PubID, Publication.Publisher,
            Publication.YearOfPub, Books.BookTitle
    FROM Publication
    INNER JOIN Books ON Publication.PubID = Books.PubID
),

-- Union of the previous 2 tables to relate PubId to a particular title
PublicationWithTitle AS (
    SELECT PubID, Publisher, YearOfPub, NULL AS IssueNumber, BookTitle AS Title
    FROM PubAndBook
    UNION ALL
    SELECT PubID, Publisher, YearOfPub, IssueNumber, MagazineTitle AS Title
    From PubAndMag
)
-- Finding number of companies that sell each publication for the "Nanyang Publisher Company"

SELECT  PublicationWithTitle.PubID, PublicationWithTitle.Publisher, 
        PublicationWithTitle.Title, COUNT(DISTINCT sb.companyID) AS num_bookstores
FROM PublicationWithTitle 
JOIN StocksInBookstore sb ON PublicationWithTitle.pubID = sb.pubID
WHERE PublicationWithTitle.publisher = 'Nanyang Publisher Company'
GROUP BY PublicationWithTitle.pubID,
         PublicationWithTitle.publisher,
         PublicationWithTitle.Title;