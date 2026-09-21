# ============================================================
# Static portfolio served by nginx (public Docker Hub image)
# ============================================================
FROM nginxinc/nginx-unprivileged:1.27-alpine

# Copy site
COPY index.html /usr/share/nginx/html/index.html
COPY styles/ /usr/share/nginx/html/styles/
COPY scripts/ /usr/share/nginx/html/scripts/
COPY assets/ /usr/share/nginx/html/assets/

# Custom nginx config (gzip + caching + SPA-safe fallback)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080
