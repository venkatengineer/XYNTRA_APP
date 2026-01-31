from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from datetime import datetime

app = FastAPI(
    title="Xyntra Backend",
    version="1.0.0"
)

# -------------------------------------------------
# MOCK DATABASE (REPLACE WITH REAL DB LATER)
# -------------------------------------------------

TEAMS_DB = {
    "TEAM_XYNTRA_01": {
        "team_id": "TEAM_XYNTRA_01",
        "team_name": "Xyntra",
        "team_leader": "Venkat",
        "problem_statement": "Smart hackathon judging system",
        "logo_url": "https://www.bing.com/ck/a?!&&p=59330900cddb0b90dd572523fd0c612480d617d4370e2812e59b39858dd81228JmltdHM9MTc2OTgxNzYwMA&ptn=3&ver=2&hsh=4&fclid=2e34782e-5890-611e-08f3-6e8259ef6081&u=a1L2ltYWdlcy9zZWFyY2g_cT1jb2RpbmcrbG9nbyZpZD0zMTZCRkJBQzQ3QUZBRDQwQTdDMjczRDMzOEM1QTYwNzdDNDM3N0M4JkZPUk09SVFGUkJB"
    },
    "TEAM_ALPHA_02": {
        "team_id": "TEAM_ALPHA_02",
        "team_name": "Alpha Coders",
        "team_leader": "Rahul",
        "problem_statement": "AI based waste management",
        "logo_url": "https://via.placeholder.com/150"
    }
}

MARKS_DB = []


# -------------------------------------------------
# MODELS
# -------------------------------------------------

class QRScanRequest(BaseModel):
    team_id: str


class SubmitMarksRequest(BaseModel):
    team_id: str
    scores: dict   # { "Communication": 8, "UI/UX": 9, ... }


# -------------------------------------------------
# HEALTH CHECK
# -------------------------------------------------

@app.get("/")
def root():
    return {
        "status": "Backend running",
        "time": datetime.utcnow()
    }


# -------------------------------------------------
# 1️⃣ QR SCAN → FETCH TEAM DETAILS
# -------------------------------------------------

@app.post("/get-team-details")
def get_team_details(payload: QRScanRequest):
    team_id = payload.team_id

    if team_id not in TEAMS_DB:
        raise HTTPException(status_code=404, detail="Team not found")

    return {
        "success": True,
        "team": TEAMS_DB[team_id]
    }


# -------------------------------------------------
# 2️⃣ SUBMIT MARKS
# -------------------------------------------------

@app.post("/submit-marks")
def submit_marks(payload: SubmitMarksRequest):
    team_id = payload.team_id
    scores = payload.scores

    if team_id not in TEAMS_DB:
        raise HTTPException(status_code=404, detail="Team not found")

    total_score = sum(scores.values())

    record = {
        "team_id": team_id,
        "scores": scores,
        "total_score": total_score,
        "submitted_at": datetime.utcnow()
    }

    MARKS_DB.append(record)

    return {
        "success": True,
        "message": "Marks submitted successfully",
        "data": record
    }


# -------------------------------------------------
# 3️⃣ (OPTIONAL) VIEW ALL SUBMISSIONS (ADMIN)
# -------------------------------------------------

@app.get("/all-marks")
def get_all_marks():
    return {
        "count": len(MARKS_DB),
        "submissions": MARKS_DB
    }
