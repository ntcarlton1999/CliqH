# CliqH

A deployable, responsive healthcare access app for symptom guidance and nearby facility discovery.

**This app provides general information, not a diagnosis.** For severe or life-threatening symptoms, contact local emergency services immediately.

## Run locally

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

Open **http://localhost:8000**. API documentation is at **http://localhost:8000/docs**.

## Docker

```bash
export SECRET_KEY="$(python -c 'import secrets; print(secrets.token_urlsafe(48))')"
docker compose up --build
```

## Tests

```bash
pytest -q
```

## Production

- Set `SECRET_KEY` to a strong unique value.
- Set `ALLOWED_ORIGINS` to the deployed HTTPS origin.
- Serve only over HTTPS.
- Replace demo facilities with verified, authorized facility data before launch.
