from flask import Flask, render_template, url_for, request
from sqlconn import SQL



app = Flask(__name__)

@app.route("/")
def index():
    return render_template('index.html')

@app.route("/query", methods = ['POST'])
def query():
    if request.method == 'POST':
        pass
        
    

if __name__ == "__main__":
    app.run(debug = True)