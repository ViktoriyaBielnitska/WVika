from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return "Hello from AWS + Nginx + Flask!"


import os
from flask import Flask
import psycopg2

app = Flask(__name__)

DATABASE_URL = os.environ.get('DATABASE_URL')

@app.route("/")
def index():
    conn = psycopg2.connect(DATABASE_URL)
    cur = conn.cursor()
    cur.execute("SELECT NOW();")
    now = cur.fetchone()
    cur.close()
    conn.close()
    return f"PostgreSQL time: {now}"

