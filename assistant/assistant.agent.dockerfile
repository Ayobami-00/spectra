FROM python:3.11

COPY . agent/
WORKDIR /agent


ENV PYTHONUNBUFFERED True
ENV ENVIRONMENT PRODUCTION

RUN export PYTHONPATH="."

RUN pip install -r requirements.txt

RUN echo '#!/bin/sh\n\
python src/agent_main.py dev & \n\
wait' > /agent/start.sh && chmod +x /agent/start.sh

EXPOSE 5005

CMD ["/agent/start.sh"]
