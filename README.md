# Akash Singh — Portfolio

A lightweight, dependency-free static portfolio site (HTML + CSS + vanilla JS),
built to be self-hosted on a home server behind a Cloudflare Tunnel.

## Structure

```
Portfolio/
├── index.html          # Single-page content (edit your copy here)
├── styles/main.css     # Theme + layout (dark/light via CSS variables)
├── scripts/main.js     # Theme toggle, mobile menu, scroll reveal
├── Dockerfile          # nginx-unprivileged static server (port 8080)
├── nginx.conf          # gzip, caching, security headers
├── docker-compose.yml  # host 8088 -> container 8080
└── .dockerignore
```

## Run locally (no Docker)

Open `index.html` directly, or serve it:

```bash
python3 -m http.server 8080
# then visit http://localhost:8080
```

## Run with Docker

```bash
docker compose up -d --build
# visit http://localhost:8088
```

## Expose via Cloudflare Tunnel

Point your tunnel's public hostname at the local container:

```
service: http://localhost:8088
```

No inbound ports need to be opened — the tunnel handles ingress (zero-trust).

## Customize

- **Content:** edit `index.html` — sections are clearly commented
  (Hero, About, Experience, Skills, Achievements, Beyond Work, Contact).
- **Colors:** tweak the CSS variables at the top of `styles/main.css`
  (`--accent`, `--bg`, etc.). Light theme values live under `[data-theme="light"]`.
- **Links:** email and LinkedIn are set in the Contact section and nav.

## Next ideas (skeleton is intentionally minimal)

- Add a `/projects` section with homelab/data projects and repo links.
- Add a downloadable résumé PDF (drop it in and link from the hero).
- Add Open Graph / favicon meta for nicer link previews.
