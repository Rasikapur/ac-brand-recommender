# AC Brand Recommender

A local Flask application that predicts which AC brand is a good fit based on temperature, cost, AC type, and season month.

## Files
- `data_fetch.py` – generate or refresh synthetic April/May/June AC sales data.
- `train.py` – train the AC brand recommendation model and save it to `ac_brand_model.joblib`.
- `app.py` – Flask web app with a UI form and prediction endpoint.
- `templates/index.html` – UI for selecting temperature, cost, AC type, and month.
- `static/style.css` – simple styling.
- `Dockerfile` – package the app into a Docker container.

## Local setup
1. Change into the project directory:
```bash
cd ~/ac-brand-recommender
```
2. Create a venv and install dependencies:
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```
3. Generate the dataset and train the model:
```bash
python data_fetch.py
python train.py
```
4. Run the app:
```bash
python app.py
```
5. Open the app in your browser:
`http://127.0.0.1:5000`

## Docker deployment
1. Build the image from the project root:
```bash
docker build -t ac-brand-recommender .
```
2. Run the container from the same directory:
```bash
docker run -p 5000:5000 ac-brand-recommender
```
3. Open the app in your browser:
`http://127.0.0.1:5000`

## Notes
- This example currently uses synthetic training data to simulate April/May/June AC sales.
- If you want actual Google-related sales volume data, extend `data_fetch.py` with a real API or scraping pipeline and update the training dataset accordingly.
- The app is built for local and Docker deployment. For production, use a WSGI server such as Gunicorn.
