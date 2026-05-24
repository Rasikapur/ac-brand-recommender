import os
from flask import Flask, render_template, request, jsonify
import joblib
import pandas as pd

app = Flask(__name__)

BASE_DIR = os.path.dirname(__file__)
MODEL_PATH = os.path.join(BASE_DIR, "ac_brand_model.joblib")
MODEL = None
FEATURES = ["temperature", "cost", "ac_type", "month"]


def load_model():
    global MODEL
    if MODEL is None:
        MODEL = joblib.load(MODEL_PATH)


@app.route("/", methods=["GET"])
def index():
    ac_types = ["Window", "Split", "Inverter", "Portable"]
    months = ["April", "May", "June"]
    return render_template("index.html", ac_types=ac_types, months=months)


@app.route("/predict", methods=["POST"])
def predict():
    if request.is_json:
        payload = request.get_json()
    else:
        payload = request.form.to_dict()

    try:
        temperature = float(payload.get("temperature", ""))
        cost = float(payload.get("cost", ""))
        ac_type = payload.get("ac_type", "Split")
        month = payload.get("month", "April")
    except ValueError:
        return jsonify({"error": "Temperature and cost must be numeric."}), 400

    df = pd.DataFrame([
        {
            "temperature": temperature,
            "cost": cost,
            "ac_type": ac_type,
            "month": month,
        }
    ])

    if MODEL is None:
        load_model()

    if MODEL is None:
        return jsonify({"error": "Model not loaded."}), 500

    prediction = MODEL.predict(df)[0]
    if hasattr(MODEL, "predict_proba"):
        scores = MODEL.predict_proba(df)[0]
        top_scores = sorted(
            zip(MODEL.classes_, scores), key=lambda x: x[1], reverse=True
        )[:3]
        top_brands = [f"{brand}: {score:.2%}" for brand, score in top_scores]
    else:
        top_brands = []

    result = {
        "recommended_brand": prediction,
        "top_brands": top_brands,
        "input": {
            "temperature": temperature,
            "cost": cost,
            "ac_type": ac_type,
            "month": month,
        },
    }

    if request.is_json:
        return jsonify(result)

    return render_template("index.html", result=result, ac_types=["Window", "Split", "Inverter", "Portable"], months=["April", "May", "June"])


if __name__ == "__main__":
    load_model()
    app.run(host="0.0.0.0", port=5000, debug=True)
