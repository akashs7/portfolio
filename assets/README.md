# Assets

Drop your real files here (these are referenced by `index.html` and `nginx.conf`).

## Résumé (download tracking)

Place your compiled résumé as:

```
assets/resume.pdf
```

- The site serves it at **`/api/resume`** (the "Résumé" / "Download Résumé" buttons).
- Every download is logged by nginx to stdout with a `RESUME_DOWNLOAD` prefix, so
  on the home server you can see who downloaded it with:

  ```bash
  docker logs portfolio 2>&1 | grep RESUME_DOWNLOAD
  # e.g. RESUME_DOWNLOAD ts=2026-09-21T12:00:00+00:00 ip=1.2.3.4 ua="..." ref="https://..."
  ```

  To keep a running tally:

  ```bash
  docker logs portfolio 2>&1 | grep -c RESUME_DOWNLOAD
  ```

- `assets/resume.pdf` is explicitly un-ignored in `.gitignore`/`.dockerignore`
  (other `*.pdf`/`*.tex` sources stay private). If you'd rather NOT commit it,
  copy it onto the server manually before running `./deploy.sh`.

> Note: behind Cloudflare, `ip=` will be Cloudflare's edge IP unless you forward
> the real client IP (e.g. via `CF-Connecting-IP`). Add a `real_ip` / header
> mapping later if you want the true visitor IP.

## Screenshots

Optional project screenshots (referenced with graceful fallback if missing):

```
assets/screenshots/daily-one.png
assets/screenshots/athena.png
```
