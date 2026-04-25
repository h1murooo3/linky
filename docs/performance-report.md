# Performance Test Report (k6)

## Goal

Validate API stability under concurrent load (100+ virtual users), and capture latency and error rate for submission.

## Test Environment

- Application: `linky` (FastAPI + PostgreSQL + Redis + Celery)
- Load tool: `k6`
- Script: `k6/load_test.js`
- Target endpoint: `http://localhost:8000`

## Scenario

Stages from the k6 script:

1. 30s -> 10 VUs (warmup)
2. 1m -> 50 VUs
3. 30s -> 100 VUs
4. 1m -> 100 VUs (peak hold)
5. 30s -> 50 VUs (cooldown)
6. 30s -> 0 VUs

Thresholds:

- `p(95) http_req_duration < 500ms`
- `http_req_failed < 1%`
- `errors < 1%`

## How To Reproduce

```bash
docker-compose up -d --build
k6 run --out json=./k6/results.json ./k6/load_test.js
```

Optional export to CSV:

```bash
k6 run --summary-export=./k6/summary.json ./k6/load_test.js
```

## Submission Artifacts

Store these files in repository before demo:

- `k6/results.json` (raw time-series data)
- `k6/summary.json` (aggregated metrics)
- Screenshots from Grafana with:
  - RPS over time
  - Latency (p50/p95/p99)
  - Error rate

## Report Template (fill after run)

- Test date:
- Commit SHA:
- Avg RPS:
- p95 latency:
- p99 latency:
- Error rate:
- Bottlenecks identified:
- Applied optimizations:
- Result after optimization:

## Acceptance Criteria Mapping

- Requirement 9 (Performance Testing): covered by `k6/load_test.js` + this report + artifacts
- Week 13 criteria: include charts and final interpretation based on RPS/Latency
