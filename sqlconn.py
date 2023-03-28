import pyodbc as odbc

DRIVER_NAME = 'SQL SERVER'
SERVER_NAME = 'database-1.ctfix6axgfer.ap-southeast-2.rds.amazonaws.com'
DATABASE_NAME = 'Bookstore'
UID = 'txsheng0609'
PWD = 'txsheng0609'

class SQL:
    def __init__(self):
        self.conn = None
        self.cursor = None

    def connect_run(self, query):
        connection_string = f"""
            DRIVER={{{DRIVER_NAME}}};
            SERVER={SERVER_NAME};
            DATABASE={DATABASE_NAME};
            UID={UID};
            PWD={PWD};
        """
        self.conn = odbc.connect(connection_string)
        self.cursor = self.conn.cursor()
        
        with self.conn:
            result = self.cursor.execute(query)
            result_arr = []
            for row in result:
                result_arr.append(row)
            return result_arr

if __name__ == "__main__":
    SQLServer = SQL()
    string = """
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
    """
    print(SQLServer.connect_run(string))

