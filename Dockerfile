FROM python:3-alpine

RUN pip install pipenv

COPY requirements.txt /app/
WORKDIR /app
RUN pip install -r requirements.txt

COPY app.py /app/

#HEALTHCHECK --interval=10s --timeout=3s CMD ["/healthcheck"]
EXPOSE 5000
ARG SOURCE_COMMIT
ENV SOURCE_COMMIT=$SOURCE_COMMIT
ENTRYPOINT [ "flask","run","--host=0.0.0.0"] 
