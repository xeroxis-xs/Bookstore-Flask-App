### 1. Create Python Virtual Environment
```
python -m venv venv
```

### 2. Activate the environment
macOS / Linux:
```
. venv/bin/activate
```
Windows:
```
venv\Scripts\activate
```

### 3. Install Packages from requirements.txt
```
pip install -r requirements.txt
```

### 4. To run the project:
```
python run --application
```

Take note:
This project is running on **ODBC Driver 17 for SQL Server** driver

To make sure that you have the correct **pyodbc driver** installed:

https://learn.microsoft.com/th-th/sql/connect/odbc/linux-mac/install-microsoft-odbc-driver-sql-server-macos?view=sql-server-2017

Known issues for Apple Silocon machines:

If you face the following error, you need to uninstall pyodbc and reinstall again:
Error:
```
symbol not found in flat namespace '_SQLAllocHandle'
```
Fix:
```
pip uninstall pyodbc
pip install --no-binary :all: pyodbc
```

