# CliqH — AI Healthcare Facility Matcher

**Ready-to-use** cross-platform healthcare app connecting patients with facilities via AI symptom triage, geolocation matching, and cost estimation.

## Quick start (one command)

```powershell
.\start.bat
```

Or manually:

```powershell
# Terminal 1 — API
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python scripts\seed_data.py --seed
uvicorn src.backend.main:app --reload --port 8000

# Terminal 2 — Web app
cd src\frontend
npm install
npm run dev
```

Open **http://localhost:5173** in your browser.

## What's included

| Component | Status | URL |
|-----------|--------|-----|
| **Web app** (React) | Ready | http://localhost:5173 |
| **API** (FastAPI) | Ready | http://localhost:8000/docs |
| **Mobile** (Flutter) | Code ready — needs Flutter SDK | See `mobile/README.md` |

## User flows

1. **Home** → Browse features and stats
2. **Register / Login** → Create patient account
3. **Symptom checker** → Enter symptoms → AI triage with urgency levels
4. **Find facilities** → GPS-based nearby list (falls back to Nairobi demo coords)
5. **Facility detail** → Cost estimate breakdown
6. **Register facility** → Providers can submit facilities (requires login)

## Demo data

3 verified Nairobi facilities are seeded automatically:
- Nairobi General Clinic
- Westlands Care Center
- Karen Community Hospital

## Configuration

Copy `.env.example` to `.env`:

```env
SECRET_KEY=your-secret-key
OPENAI_API_KEY=sk-...   # Optional — enables LLM triage
DATABASE_URL=sqlite:///./cliqh.db
```

Without `OPENAI_API_KEY`, rule-based triage is used (still fully functional).

## Mobile app

Install [Flutter SDK](https://docs.flutter.dev/get-started/install), then:

```powershell
cd mobile
flutter create . --project-name cliqh_mobile
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

## API examples

```powershell
# Triage
curl -X POST http://localhost:8000/v1/triage/diagnose -H "Content-Type: application/json" -d "{\"symptoms\":[\"fever\",\"cough\"]}"

# Nearby facilities
curl "http://localhost:8000/v1/facilities/nearby?lat=-1.2921&lon=36.8219"

# Cost estimate
curl "http://localhost:8000/v1/facilities/1/cost-estimate?condition=influenza"
```

## Tech stack

- **Backend:** FastAPI, SQLAlchemy, SQLite (Postgres via Docker)
- **Web:** React, Vite, Tailwind CSS, TanStack Query
- **Mobile:** Flutter, Riverpod, Dio
- **AI:** OpenAI GPT-4o-mini (optional) + rule-based fallback
