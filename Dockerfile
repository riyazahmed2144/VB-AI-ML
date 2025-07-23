# Start from a lightweight Debian base
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt update && apt install -y \
    chromium \
    fluxbox \
    x11vnc \
    xvfb \
    curl \
    git \
    supervisor \
    net-tools \
    wget \
    unzip \
    xterm \
    openssl \
    python3 \
    python3-pip \
    python3-setuptools \
    && apt clean

# Set correct permissions on chromium-sandbox for security
RUN chmod 4755 /usr/lib/chromium/chromium-sandbox || true && \
    chown root:root /usr/lib/chromium/chromium-sandbox || true

# Install Python packages
RUN pip3 install --break-system-packages \
    selenium \
    joblib \
    scikit-learn \
    numpy \
    beautifulsoup4 \
    pandas \
    flask

# Install noVNC and websockify
RUN rm -rf /opt/novnc && \
    git clone https://github.com/novnc/noVNC.git /opt/novnc && \
    git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

# Create working directory
WORKDIR /opt/app

# Add non-root user
RUN useradd -m chromeuser

# Copy app code
COPY automation/ ./automation/
COPY ml/ ./ml/
COPY file_scanner/ ./file_scanner/
COPY output/ ./output/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown -R chromeuser:chromeuser /opt /entrypoint.sh

# Create HTTPS certificate for noVNC (optional)
RUN mkdir -p /opt/novnc/certs && \
    openssl req -x509 -nodes -days 365 \
      -subj "/C=IN/ST=TN/L=Chennai/O=Browser/CN=localhost" \
      -newkey rsa:2048 \
      -keyout /opt/novnc/certs/self.pem \
      -out /opt/novnc/certs/self.pem && \
    chown -R chromeuser:chromeuser /opt/novnc/certs

# Switch to non-root user
USER chromeuser

# Expose noVNC port
EXPOSE 6080

# Entrypoint
CMD ["/entrypoint.sh"]
