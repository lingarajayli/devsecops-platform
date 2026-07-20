from flask import Flask, jsonify
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)
metrics = PrometheusMetrics(app)

@app.route("/")
def home():
    return jsonify(
        {
            "service": "flask-health-api",
            "status": "running",
            "message": "DevSecOps CI/CD pipeline demo app",
        }
    )


@app.route("/health")
def health():
    return jsonify(
        {
            "status": "healthy",
        }
    )


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000)
