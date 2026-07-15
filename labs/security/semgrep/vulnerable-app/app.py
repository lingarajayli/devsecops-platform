import os
import sqlite3
from flask import Flask, request

app = Flask(__name__)


@app.route("/ping")
def ping():
    host = request.args.get("host", "127.0.0.1")
    os.system("ping -c 1 " + host)
    return "ping completed"


@app.route("/user")
def get_user():
    user_id = request.args.get("id")

    connection = sqlite3.connect("users.db")
    cursor = connection.cursor()

    query = "SELECT * FROM users WHERE id = " + user_id
    cursor.execute(query)

    result = cursor.fetchall()
    connection.close()

    return {"result": result}