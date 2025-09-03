#!/bin/bash
set -e

export DISPLAY=:1

echo "[INFO] Starting Xvfb..."
Xvfb :1 -screen 0 1024x768x16 &
sleep 2

echo "[INFO] Starting Fluxbox..."
fluxbox &
sleep 2

echo "[INFO] Starting x11vnc..."
x11vnc \
  -display :1 \
  -ncache 10 \
  -ncache_cr \
  -shared \
  -forever \
  -nopw \
  -rfbport 5900 \
  -bg
sleep 2

echo "[INFO] Starting noVNC (HTTPS enabled)..."
cd /opt/novnc
./utils/novnc_proxy \
  --vnc localhost:5900 \
  --listen 6080 \
  --cert /opt/novnc/certs/self.pem &
sleep 2

echo "[INFO] Launching Chromium with sandbox enabled..."
chromium \
  --no-sandbox \
  --disable-gpu \
  --disable-software-rasterizer \
  --disable-dev-shm-usage \
  --disable-features=DialMediaRouteProvider,TranslateUI \
  --start-maximized \
  --enable-automation \
  --disable-popup-blocking \
  --disable-notifications \
  --disable-extensions \
  --disable-sync \
  --password-store=basic &
echo "[INFO] Virtual browser ready at https://localhost:6080"
tail -f /dev/null
