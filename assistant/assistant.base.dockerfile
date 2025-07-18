FROM python:3.11

COPY . app/
WORKDIR /app


ENV PYTHONUNBUFFERED True
ENV ENVIRONMENT PRODUCTION

RUN export PYTHONPATH="."

RUN pip install -r requirements.txt

RUN echo '#!/bin/sh\n\
uvicorn src.main:app --workers 4 --host 0.0.0.0 --port 8085' > /app/start.sh && chmod +x /app/start.sh

EXPOSE 8085

CMD ["/app/start.sh"]
