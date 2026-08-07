# 📊 SANCHALA OS - Monitoring & Alerting

## Overview

Infrastructure monitoring using Prometheus, Grafana, and alerting.

## Components

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  Exporters  │───▶│ Prometheus  │───▶│  Grafana    │
└─────────────┘    └─────────────┘    └─────────────┘
                          │
                          ▼
                   ┌─────────────┐
                   │ Alertmanager│───▶ Slack/Email
                   └─────────────┘
```

## Metrics to Monitor

### Repository Server
- Disk usage (alert at 80%)
- HTTP response time
- Package count
- Sync status
- SSL certificate expiry

### Mirror Network
- Sync freshness
- Availability (uptime)
- Response time by region
- Bandwidth usage

### CI/CD
- Build duration
- Success/failure rate
- Queue time
- Runner availability

## Prometheus Setup

```yaml
# /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

alerting:
  alertmanagers:
    - static_configs:
        - targets: ['localhost:9093']

rule_files:
  - '/etc/prometheus/rules/*.yml'

scrape_configs:
  - job_name: 'repo-server'
    static_configs:
      - targets: ['repo.sanchala.id:9100']

  - job_name: 'mirrors'
    static_configs:
      - targets:
        - 'eu.mirror.sanchala.id:9100'
        - 'us.mirror.sanchala.id:9100'
        - 'ap.mirror.sanchala.id:9100'

  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]
    static_configs:
      - targets:
        - https://repo.sanchala.id
        - https://sanchala.id
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - target_label: __address__
        replacement: localhost:9115
```

## Alert Rules

```yaml
# /etc/prometheus/rules/sanchala.yml
groups:
  - name: sanchala
    rules:
      - alert: DiskSpaceLow
        expr: node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"} < 0.2
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Disk space low on {{ $labels.instance }}"

      - alert: MirrorOutOfSync
        expr: time() - sanchala_mirror_last_sync_timestamp > 43200
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Mirror {{ $labels.instance }} out of sync"

      - alert: ServiceDown
        expr: probe_success == 0
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "{{ $labels.instance }} is down"

      - alert: SSLExpiringSoon
        expr: probe_ssl_earliest_cert_expiry - time() < 604800
        for: 1h
        labels:
          severity: warning
        annotations:
          summary: "SSL certificate expiring soon on {{ $labels.instance }}"
```

## Grafana Dashboards

Import these dashboards:
- Node Exporter Full (ID: 1860)
- Blackbox Exporter (ID: 7587)

Custom Sanchala dashboard JSON available at:
`/docs/infrastructure/grafana/sanchala-dashboard.json`

## Status Page

Public status page at https://status.sanchala.id showing:
- Service availability
- Recent incidents
- Planned maintenance

Consider: Atlassian Statuspage, Cachet, or Upptime (GitHub-based)

## Alerting Channels

| Severity | Channel | Response Time |
|----------|---------|---------------|
| Critical | PagerDuty/Phone | 15 min |
| Warning | Slack #infra-alerts | 1 hour |
| Info | Email digest | Daily |

## Quick Health Check

```bash
#!/bin/bash
# /usr/local/bin/sanchala-health-check

echo "=== Sanchala Infrastructure Health ==="

# Check repo
curl -sf https://repo.sanchala.id/status.json && echo "✓ Repo OK" || echo "✗ Repo DOWN"

# Check mirrors
for mirror in eu us ap; do
  curl -sf "https://${mirror}.mirror.sanchala.id/status.json" \
    && echo "✓ Mirror $mirror OK" || echo "✗ Mirror $mirror DOWN"
done

# Check website
curl -sf https://sanchala.id > /dev/null && echo "✓ Website OK" || echo "✗ Website DOWN"
```
