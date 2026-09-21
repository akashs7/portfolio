# Akash Singh — Portfolio

A lightweight, dependency-free static portfolio site (HTML + CSS + vanilla JS),
built to be self-hosted on a home server behind a Cloudflare Tunnel.

## Structure

```
Portfolio/
├── index.html          # Single-page content (edit your copy here)
├── styles/main.css     # Theme + layout (dark/light via CSS variables)
├── scripts/main.js     # Theme toggle, mobile menu, scroll reveal, résumé note
├── assets/             # résumé.pdf + project screenshots (see assets/README.md)
├── Dockerfile          # nginx-unprivileged static server (port 8080)
├── nginx.conf          # gzip, caching, security headers, résumé tracking
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
  (Hero, Featured Projects, Experience, Case Studies, S7 Labs, Tech Stack,
  Certifications, About, Contact). Project cards use `<details>` for the
  expandable engineering story; look for `TODO:` markers to fill in real
  stack/auth details and links.
- **Screenshots:** drop `daily-one.png` / `athena.png` in `assets/screenshots/`
  (missing images fall back to a "coming soon" placeholder).
- **Colors:** tweak the CSS variables at the top of `styles/main.css`
  (`--accent`, `--bg`, etc.). Light theme values live under `[data-theme="light"]`.
- **Links:** GitHub, LinkedIn and email are set in the Contact section and nav.

## Résumé download tracking

The "Résumé" / "Download Résumé" buttons point at **`/api/resume`**, which nginx
serves from `assets/resume.pdf` and logs on every hit.

1. Put your compiled résumé at `assets/resume.pdf` (see `assets/README.md`).
2. On the server, view downloads from the container logs:

   ```bash
   docker logs portfolio 2>&1 | grep RESUME_DOWNLOAD   # each download
   docker logs portfolio 2>&1 | grep -c RESUME_DOWNLOAD # running count
   ```

Behind Cloudflare the logged IP is the edge IP unless you forward
`CF-Connecting-IP`; add a `real_ip` mapping in `nginx.conf` if you want the
true visitor IP.

## Next ideas

- Add real screenshots and fill in the `TODO:` project details (stack, auth, repos).
- Give the biggest projects their own `/projects/...` pages if the single-page
  cards start feeling cramped.
- Add a favicon and an Open Graph image for nicer link previews.
- Forward `CF-Connecting-IP` so résumé-download logs show the real visitor IP.
