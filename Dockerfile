FROM python:3.6-alpine

WORKDIR /
COPY build/ /

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000
CMD [ "python", "main.py" ] 