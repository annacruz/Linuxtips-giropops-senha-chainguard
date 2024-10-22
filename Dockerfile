FROM cgr.dev/chainguard/python:latest-dev AS builder

WORKDIR /app

RUN python -m venv venv
ENV PATH="/app/venv/bin:$PATH"
COPY requirements.txt .
RUN pip install -r requirements.txt

FROM cgr.dev/chainguard/python:latest

WORKDIR /app

COPY --from=builder /app/venv /app/venv
COPY app.py .
COPY templates templates/
COPY static static/
ENV PATH="/app/venv/bin:$PATH"

ARG REDIS_HOST=127.0.0.1
ENV REDIS_HOST=$REDIS_HOST

EXPOSE 5000

ENTRYPOINT ["flask"]

CMD ["run", "--host=0.0.0"]
