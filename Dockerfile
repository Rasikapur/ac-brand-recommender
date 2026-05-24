FROM python:3.12-slim

WORKDIR /app
COPY requirements.txt /app
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app
RUN python data_fetch.py && python train.py
EXPOSE 5000
CMD ["python", "app.py"]
