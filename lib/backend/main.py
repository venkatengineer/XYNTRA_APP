from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from datetime import datetime

app = FastAPI(
    title="Xyntra Backend",
    version="1.0.0"
)

# -------------------------------------------------
# MOCK DATABASES
# -------------------------------------------------

JUDGES_DB = {
    "judge1": {
        "judge_id": "JUDGE_01",
        "name": "summa",
        "password": "1234"
    },
    "judge2": {
        "judge_id": "JUDGE_02",
        "name": "Ms. Ananya",
        "password": "5678"
    }
}

TEAMS_DB = {
    "TEAM_XYNTRA_01": {
        "team_id": "TEAM_XYNTRA_01",
        "team_name": "Xyntra",
        "team_leader": "Venkat",
        "team_members": [
            "Venkat",
            "Arjun",
            "Sathish"
        ],
        "problem_statement": "Smart hackathon judging system",
        "logo_url": "https://via.placeholder.com/150"
    }
}

MARKS_DB = []

# -------------------------------------------------
# MODELS
# -------------------------------------------------

class QRScanRequest(BaseModel):
    team_id: str


class JudgeLoginRequest(BaseModel):
    username: str
    password: str


class SubmitMarksRequest(BaseModel):
    team_id: str
    judge_id: str
    scores: dict   # { "Communication": 8, "UI / UX": 9, ... }


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
# 2️⃣ JUDGE LOGIN
# -------------------------------------------------

@app.post("/judge-login")
def judge_login(payload: JudgeLoginRequest):
    judge = JUDGES_DB.get(payload.username)

    if not judge or judge["password"] != payload.password:
        raise HTTPException(status_code=401, detail="Invalid credentials")

    return {
        "success": True,
        "judge_id": judge["judge_id"],
        "judge_name": judge["name"]
    }


# -------------------------------------------------
# 3️⃣ SUBMIT MARKS (PER JUDGE)
# -------------------------------------------------

@app.post("/submit-marks")
def submit_marks(payload: SubmitMarksRequest):
    if payload.team_id not in TEAMS_DB:
        raise HTTPException(status_code=404, detail="Team not found")

    record = {
        "team_id": payload.team_id,
        "judge_id": payload.judge_id,
        "scores": payload.scores,
        "total_score": sum(payload.scores.values()),
        "submitted_at": datetime.utcnow()
    }

    MARKS_DB.append(record)

    return {
        "success": True,
        "message": "Marks submitted successfully",
        "data": record
    }


# -------------------------------------------------
# 4️⃣ VIEW ALL RAW SUBMISSIONS (ADMIN)
# -------------------------------------------------

@app.get("/all-marks")
def get_all_marks():
    return {
        "count": len(MARKS_DB),
        "submissions": MARKS_DB
    }


# -------------------------------------------------
# 5️⃣ VIEW ALL TEAMS
# -------------------------------------------------

@app.get("/all-teams")
def get_all_teams():
    return {
        "count": len(TEAMS_DB),
        "teams": list(TEAMS_DB.values())
    }


# -------------------------------------------------
# 6️⃣ AGGREGATED LEADERBOARD (MULTI-JUDGE)
# -------------------------------------------------

@app.get("/leaderboard")
def leaderboard():
    team_scores = {}

    for record in MARKS_DB:
        team_id = record["team_id"]
        team_scores.setdefault(team_id, []).append(record["total_score"])

    leaderboard = []

    for team_id, scores in team_scores.items():
        leaderboard.append({
            "team_id": team_id,
            "average_score": round(sum(scores) / len(scores), 2),
            "judges_count": len(scores)
        })

    leaderboard.sort(
        key=lambda x: x["average_score"], reverse=True
    )

    return leaderboard
