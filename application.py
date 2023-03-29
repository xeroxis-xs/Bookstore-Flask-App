from flask import Flask, render_template, url_for, request, redirect
from sqlconn import SQL



application = Flask(__name__)
app = application

@app.route("/")
def index():
    return render_template('index.html')


@app.route("/query", methods = ["POST", "GET"])
def query():
    if request.method == "POST":
        query_string =  request.form["query"] 
        return redirect(url_for("result", query = query_string))
    else:
        return render_template('query.html')
    

@app.route("/result/<query>")
def result(query):
    if query.startswith("Query"):
        # Preset Query
        file_string = f"queries/{query}.sql"
        fd = open(file_string, encoding='utf8')
        SQLQuery = fd.read()
        fd.close()
        sqlServer = SQL()
        result = sqlServer.connect_run(SQLQuery)
        return render_template('result.html', columns = result[0], query_result = result[1], sql_string = SQLQuery)

    elif query.startswith("View"):
        table = query[4:]
        SQLQuery = f"SELECT * FROM {table}"
        sqlServer = SQL()
        result = sqlServer.connect_run(SQLQuery)
        return render_template('result.html', columns = result[0], query_result = result[1], sql_string = SQLQuery)
    else:
        # Custom Query
        sqlServer = SQL()
        result = sqlServer.connect_run(query)
        return render_template('result.html', columns = result[0], query_result = result[1], sql_string = query)

@app.route("/explore")
def explore():
        return render_template('explore.html')


if __name__ == "__main__":
    app.run(debug = False)