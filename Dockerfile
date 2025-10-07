# ✅ Use newer Debian Bullseye-based image (buster repos are broken)
FROM nikolaik/python-nodejs:python3.10-nodejs18-bullseye

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       curl \
       ffmpeg \
       ca-certificates \
       gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up Node Version Manager (NVM) and install Node.js v18
ENV NVM_DIR=/root/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install v18 && \
    nvm alias default v18 && \
    nvm use v18 && \
    npm install -g npm && \
    echo ". $NVM_DIR/nvm.sh" >> /root/.bashrc

# Set working directory
WORKDIR /app

# Copy all project files
COPY . /app/

# Install Python dependencies
RUN pip3 install --no-cache-dir -U -r requirements.txt

# Make start file executable
RUN chmod +x /app/start

# Start the app
CMD ["bash", "-c", "source ~/.bashrc && bash start"]
