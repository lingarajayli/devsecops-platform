import ipaddress
import sqlite3
import subprocess

from flask import Flask, request

app = Flask(__name__)


@app.route("/ping")
def ping():
    host = request.args.get("host", "127.0.0.1")

    try:
        ipaddress.ip_address(host)
    except ValueError:
        return {"error": "invalid IP address"}, 400

    subprocess.run(
        ["ping", "-c", "1", host],
        check=False,
        shell=False,
    )

    return "ping completed"


@app.route("/user")
def get_user():
    user_id = request.args.get("id", "")

    if not user_id.isdigit():
        return {"error": "invalid user id"}, 400

    connection = sqlite3.connect("users.db")
    cursor = connection.cursor()

    cursor.execute(
        "SELECT * FROM users WHERE id = ?",
        (user_id,),
    )

    result = cursor.fetchall()
    connection.close()

    return {"result": result}