# EPCBUK Mobile App – Network Documentation

This document outlines the API contracts between the EPCBUK Mobile Application (Frontend) and the Unified Tree Cutting Management System (Backend).

## Base Configuration
- **Base URL**: `https://api.utcms.gov.in/v1`
- **Content-Type**: `application/json`
- **Auth Strategy**: Bearer Token (JWT)

---

## 1. Authentication

### Send OTP
Generates and sends an OTP to the user's registered mobile/email.
- **Endpoint**: `/auth/send-otp`
- **Method**: `POST`
- **Payload**:
```json
{
  "user_id": "string",
  "password": "string",
  "role": "string"
}
```
- **Success Response (200)**:
```json
{
  "message": "OTP sent successfully",
  "session_id": "string"
}
```

### Verify OTP
Verifies the OTP and returns the user profile and session token.
- **Endpoint**: `/auth/verify-otp`
- **Method**: `POST`
- **Payload**:
```json
{
  "user_id": "string",
  "otp": "string"
}
```
- **Success Response (200)**:
```json
{
  "id": "user_001",
  "name": "Arjun Singh",
  "email": "arjun@uttarakhand.gov.in",
  "role": "Forest Officer",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

## 2. Dashboard

### Get Metrics
Retrieves high-level performance indicators for the executive dashboard.
- **Endpoint**: `/dashboard/metrics`
- **Method**: `GET`
- **Success Response (200)**:
```json
{
  "total_applications": 12450,
  "trees_enumerated": 85600,
  "compensation_paid": 45000000.0,
  "pending_approvals": 128,
  "sla_breaches": 12,
  "active_districts": 13,
  "afforestation_progress": 78.5,
  "env_impact_index": "0.82",
  "fraud_detection_acc": 99.2,
  "comp_prediction_score": 94.5,
  "risk_scoring_acc": 91.0,
  "species_id_acc": 98.4,
  "doc_authenticity_scan": 99.8,
  "predicted_next_month_apps": "+12% Expected",
  "monthly_volume": [
    {"month": "Jan", "received": 180, "completed": 150},
    {"month": "Feb", "received": 210, "completed": 190}
  ],
  "district_compensation": [
    {"district": "Dehradun", "amount": 84.5},
    {"district": "Nainital", "amount": 62.0}
  ],
  "species_distribution": [
    {"species": "Teak", "percentage": 35.0},
    {"species": "Sal", "percentage": 25.0}
  ],
  "sla_performance": [
    {"department": "Forest Range", "percentage": 92.0, "sla_days": 7}
  ],
  "recent_activities": [
    {
      "case_id": "TC/2026/001",
      "district": "Dehradun",
      "activity": "Site Verification",
      "by": "Range Officer",
      "time": "2 hours ago",
      "status": "Done"
    }
  ]
}
```

---

## 3. Applications

### List Applications
Retrieves a list of tree cutting applications with optional filtering.
- **Endpoint**: `/applications`
- **Method**: `GET`
- **Query Parameters**: `status`, `district`, `page`, `limit`
- **Success Response (200)**:
```json
[
  {
    "id": "TC-8821",
    "applicant": "Rahul Verma",
    "district": "Dehradun",
    "tree_count": 12,
    "compensation": "₹45,000",
    "stage": "Verification",
    "stage_class": "warning",
    "date": "2026-04-05",
    "sla": "2 Days Left",
    "sla_class": "success"
  }
]
```

---

## 4. Valuation

### Calculate Compensation
Submits tree data to the valuation engine for compensation calculation.
- **Endpoint**: `/valuation/calculate`
- **Method**: `POST`
- **Payload**:
```json
{
  "application_id": "string",
  "trees": [
    {"species": "Teak", "girth": 120, "height": 15}
  ]
}
```
- **Success Response (200)**:
```json
{
  "application_id": "TC-8821",
  "land_value": 150000.0,
  "tree_value": 45000.0,
  "structure_value": 0.0,
  "solatium": 195000.0,
  "total_compensation": 390000.0,
  "calculated_at": "2026-04-09T13:00:00Z"
}
```

---

## 5. Error Handling
Global error format for all non-200 responses.
```json
{
  "error": "true",
  "code": "status_code",
  "message": "Human readable error message",
  "details": "Technical details (optional)"
}
```

---

## 6. Workflow & Approvals

### List Workflow Tasks
Retrieves a list of pending workflow tasks assigned to the current user.
- **Endpoint**: `/workflow`
- **Method**: `GET`
- **Success Response (200)**:
```json
[
  {
    "id": "WF-1092",
    "case_id": "TC-8821",
    "stage": "Range Officer Approval",
    "assigned_date": "2026-04-08",
    "priority": "High"
  }
]
```

---

## 7. GIS Mapping & Spatial Data

### Get Tree Markers
Retrieves geo-coordinates for trees within a specified application or region.
- **Endpoint**: `/gis/markers`
- **Method**: `GET`
- **Success Response (200)**:
```json
[
  {
    "id": "T-001",
    "species": "Teak",
    "latitude": 30.3165,
    "longitude": 78.0322,
    "capturedAt": "2026-04-09T10:00:00Z",
    "isFlagged": false
  }
]
```

### Submit Geo-Tag
Captures and submits high-precision location data for a verified tree.
- **Endpoint**: `/gis/submit-geotag`
- **Method**: `POST`
- **Payload**:
```json
{
  "id": "T-001",
  "species": "Teak",
  "latitude": 30.3165,
  "longitude": 78.0322,
  "capturedAt": "2026-04-09T10:00:00Z"
}
```

---

## 8. Verification Queue

### Get Pending Verifications
Retrieves the list of applications awaiting site verification or valuation approval.
- **Endpoint**: `/valuation-approvals-queue`
- **Method**: `GET`
- **Success Response (200)**:
```json
[
  {
    "id": "V-991",
    "applicant": "Sumit Negi",
    "district": "Haridwar",
    "status": "Pending",
    "date": "2026-04-09"
  }
]
```

### Process Verification
Submit an approval or rejection for a verification task.
- **Endpoint**: `/valuation-approvals-queue/reject-or-approve/{id}`
- **Method**: `POST`
- **Payload**:
```json
{
  "status": "approved"
}
```

---

## 9. Payments & Financials

### Get Payment Summary
Retrieves aggregate financial data for the treasury dashboard.
- **Endpoint**: `/payments/get-payment-details`
- **Method**: `GET`
- **Success Response (200)**:
```json
{
  "totalDisbursed": 4500000.0,
  "pendingAmount": 120000.0,
  "totalChallans": 85,
  "monthlyTrend": [10.2, 15.5, 12.1],
  "fundAllocation": {"CAMPA": 65.0, "State Revenue": 35.0}
}
```

### Get Payment History
Retrieves a list of all transactions and compensation payouts.
- **Endpoint**: `/payments/history`
- **Method**: `GET`
- **Success Response (200)**:
```json
[
  {
    "id": "PAY-882",
    "type": "Compensation",
    "amount": 45000.0,
    "status": "paid",
    "date": 1712664000000,
    "challanNo": "CH-10029"
  }
]
```

---

## 10. Document Management (DMS)

### Get Application Documents
Retrieves all files attached to a specific tree cutting application.
- **Endpoint**: `/dms/documents/{appId}`
- **Method**: `GET`
- **Success Response (200)**:
```json
[
  {
    "id": "DOC-101",
    "name": "Site Plan.pdf",
    "category": "Layouts",
    "date": "22 Mar 2025",
    "status": "Verified",
    "size": "4.2 MB"
  }
]
```

### Upload Document
Uploads a binary file with category metadata using `multipart/form-data`.
- **Endpoint**: `/dms/upload`
- **Method**: `POST`
- **Payload (FormData)**:
  - `file`: (binary)
  - `category`: "Layouts" | "ID Proof" | "Clearances" | "Survey"

---

## 11. Compliance & Enforcement

### List Compliance Cases
Retrieves cases flagged for environmental or legal compliance review.
- **Endpoint**: `/compliance-queue`
- **Method**: `GET`
- **Success Response (200)**:
```json
[
  {
    "id": "C-102",
    "project": "NH-74 Expansion",
    "district": "Dehradun",
    "risk": "High",
    "status": "In Progress"
  }
]
```

---

## 12. Reports & Analytics

### Get Generated Reports
Retrieves a list of available PDF/Excel reports.
- **Endpoint**: `/reports`
- **Method**: `GET`
- **Success Response (200)**:
```json
{
  "monthlyVolume": [{"label": "Jan", "value": 150}],
  "districtWise": [{"label": "Dehradun", "value": 45.0}],
  "slaPerformance": {"Forest Range": 92.0}
}
```

---

## 13. Citizen Grievance Portal

### List Grievances
Retrieves public grievances and issues assigned for resolution.
- **Endpoint**: `/citizen-grievance-portal`
- **Method**: `GET`
- **Success Response (200)**:
```json
[
  {
    "id": "G-404",
    "subject": "Delayed valuation",
    "category": "Delay",
    "status": "Open",
    "priority": "Urgent"
  }
]
```

---

## 14. Audit Logs

### Get System Audit
Retrieves the security audit trail of all administrative and field actions.
- **Endpoint**: `/audit`
- **Method**: `GET`
- **Success Response (200)**:
```json
[
  {
    "timestamp": "2026-04-09T14:00:00Z",
    "user": "arjun_singh",
    "role": "Forest Officer",
    "action": "Verified Application TC-8821",
    "status": "Success"
  }
]
```

---

## 15. Notifications

### List Notifications
Retrieves all alerts, reminders, and system messages.
- **Endpoint**: `/notifications`
- **Method**: `GET`
- **Success Response (200)**:
```json
[
  {
    "id": "N-001",
    "title": "SLA Alert",
    "message": "TC-8821 expires in 2 days",
    "type": "warning",
    "timestamp": "1h ago"
  }
]
```

---

## 16. AI Analysis & Insights

### Get Predicted Insights
Retrieves AI-driven risk scores, fraud detection indices, and volume predictions.
- **Endpoint**: `/ai/analysis`
- **Method**: `GET`
- **Success Response (200)**:
```json
{
  "fraud_accuracy": 99.2,
  "risk_score": 91.0,
  "prediction_trend": "+12.5%",
  "anomaly_detected": false
}
```

---

## 17. Settings & Configuration

### Get System Settings
Retrieves current system configuration, including SLA thresholds and notification flags.
- **Endpoint**: `/settings`
- **Method**: `GET`
- **Success Response (200)**:
```json
{
  "slaGuard": 3,
  "slaRO": 5,
  "enableSMS": true,
  "enableEmail": true
}
```
