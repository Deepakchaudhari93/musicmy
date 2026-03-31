FROM nikolaik/python-nodejs:python3.10-nodejs19

# GPG key fix for yarn repository
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - || true

# Fix repositories and install ffmpeg
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
    sed -i '/security.debian.org/d' /etc/apt/sources.list && \
    apt-get update --allow-insecure-repositories || true && \
    apt-get install -y --no-install-recommends ffmpeg --allow-unauthenticated && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY . /app/
WORKDIR /app/

RUN python -m pip install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade --requirement requirements.txt

CMD bash start
