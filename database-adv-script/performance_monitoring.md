## Performance Monitoring
- Used `EXPLAIN (ANALYZE, BUFFERS)` on frequent queries.
- Identified seq scans and heavy sorts; added targeted indexes.
- Re-ran `ANALYZE` and verified improved plans/timings.
See `performance_monitoring.sql`, `performance_changes.sql`, and `PERFORMANCE_REPORT.md`.
