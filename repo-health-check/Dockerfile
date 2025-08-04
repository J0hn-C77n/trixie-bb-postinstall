FROM debian:trixie
WORKDIR /app
RUN apt-get update && apt-get install -y     curl     gnupg     && rm -rf /var/lib/apt/lists/*
COPY test-zap-install.sh .
RUN chmod +x test-zap-install.sh

CMD ["./test-zap-install.sh"]
