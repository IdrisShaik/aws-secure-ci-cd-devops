FROM python:3.11-slim

WORKDIR /app

<<<<<<< HEAD
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 80
CMD ["python", "app.py"]
>>>>>>> faffb18 (Add Flask app and fix Dockerfile)

EXPOSE 80
CMD ["python", "app.py"]
