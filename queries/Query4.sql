/*Query 4 Let us define the latencyof an employee by the average that he/she takes to process a complaint.
Find the employee with the smallest latency. 
*/


WITH EmpLat AS 
(
    SELECT EmployeeID, AVG(DATEDIFF(Minute, c1.DateUpdated, c2.DateUpdated)/60.0) 
    AS LatencyInHours
    FROM Complaints, StatusForComplaints AS c1, StatusForComplaints AS c2
    WHERE c1.ComplaintState = 'Being Handled' AND c2.ComplaintState = 'Addressed' 
    AND
    c1.ComplaintID=c2.ComplaintID AND Complaints.ComplaintID=c1.ComplaintID
    GROUP BY EmployeeID
)

/*To show the employee with the smallest latency*/
SELECT EmpLat.EmployeeID, EmpName, LatencyInHours
FROM Employees, EmpLat
WHERE LatencyInHours = (SELECT MIN(LatencyInHours)FROM EmpLat) AND Employees.EmployeeID = EmpLat.EmployeeID; 