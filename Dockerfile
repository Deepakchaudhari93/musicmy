FROM nikolaik/python-nodejs:python3.10-nodejs19

# GPG key fix for yarn repository (ignore errors)
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - 2>/dev/null || true

# Fix repositories and install ffmpeg (no aria2)
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
    sed -i '/security.debian.org/d' /etc/apt/sources.list && \
    apt-get update --allow-insecure-repositories || true && \
    apt-get install -y --no-install-recommends ffmpeg --allow-unauthenticated && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY . /app/
WORKDIR /app/

# Upgrade pip and install requirements
RUN python -m pip install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade --requirement requirements.txt

# Direct run - apne bot ke file name se replace karo!
CMD python main.py
