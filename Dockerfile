FROM python:3.9-slim
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
ENV FLASK_APP=app.py
CMD ["python3", "app.py"]
