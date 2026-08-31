
# SQL Audit Toolkit (MySQL 8)

Reproducible MySQL performance audit proofs: baseline → fix → verify, with EXPLAIN evidence and rollback-safe changes.

![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Docker](https://img.shields.io/badge/Docker-ready-2496ED)
![Method](https://img.shields.io/badge/Method-Audit%20Workflow-black)

---

## Why this repo exists
This repository stores **evidence artifacts** (EXPLAIN before/after) so SQL performance work is:
- Measurable (verification outputs are committed)
- Repeatable (Docker + deterministic scripts)
- Safe (rollback + tradeoffs documented)

---

## Repository layout
```text
sql-audit-toolkit/
├─ case_01/                 # schema, seed, before/after queries, index fix
│  ├─ schema.sql
│  ├─ seed.sql
│  ├─ before.sql
│  ├─ indexes.sql
│  └─ after.sql
├─ results/                 # evidence artifacts (commit these)
│  ├─ explain_before.txt
│  └─ explain_after.txt
└─ docs/                    # optional: audit checklist / methodology
```

---

## Quickstart (Docker + MySQL 8)

### 1) Start MySQL in Docker
```bash
docker run -d --name sql_audit_mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=auditdb \
  -p 3307:3306 \
  mysql:8.0
```

### 2) Connect using MySQL Workbench (or any client)
- Host: 127.0.0.1
- Port: 3307
- User: root
- Password: root
- Schema: auditdb

### 3) Execute the audit flow (Case 01)
Run these scripts in order:

| Step | Goal | Run |
|---:|---|---|
| 1 | Create schema | `case_01/schema.sql` |
| 2 | Seed dataset (may take a few minutes) | `case_01/seed.sql` |
| 3 | Capture baseline plan | `case_01/before.sql` → save output to `results/explain_before.txt` |
| 4 | Apply optimization | `case_01/indexes.sql` |
| 5 | Verify new plan | `case_01/after.sql` → save output to `results/explain_after.txt` |

---

## Case Study 01: Composite Index for WHERE + ORDER BY + LIMIT
Query pattern: filter by `user_id` + `status`, sort by `created_at DESC`, `LIMIT 50`  
Fix: add a composite index aligned with the access path: `(user_id, status, created_at)`

### Evidence artifacts
- Before: `results/explain_before.txt`
- After: `results/explain_after.txt`

### Rollback (production safety)
```sql
DROP INDEX idx_user_status_created ON orders;
```

### Definition of Done (Acceptance Criteria)
- [ ] AFTER plan uses `idx_user_status_created`
- [ ] EXPLAIN `rows` estimate decreases meaningfully
- [ ] Broad scans are reduced/removed (plan no longer looks like full scanning)

Note: `Using filesort` / `Using temporary` may still appear depending on data distribution. The primary goal is index usage + reduced scan.

---

## Audit principles (how I work)
- Control: no change without baseline + verification artifact
- Governance: every fix ships with rollback + tradeoffs
- Production mindset: optimize for measurable outcomes (latency / rows scanned / load), not “SQL tricks”

---

## Common failure modes
- Index exists but query doesn’t use it (wrong column order, low selectivity, outdated stats)
- EXPLAIN improves but runtime doesn’t (cache effects, workload mismatch)
- Over-indexing increases write overhead and storage

---

## Roadmap
- [ ] Case 02: JOIN optimization + covering index strategy
- [ ] Case 03: GROUP BY / filesort / temp-table tuning
- [ ] Python CLI: auto-generate `report.md` + structured JSON logs (ELK-ready)

---

## Cleanup
```bash
docker rm -f sql_audit_mysql
```

## Contact
If you have slow MySQL endpoints/reports, DM me: "SQL AUDIT"  
Email: shivamshukla111111@gmail.com
```
