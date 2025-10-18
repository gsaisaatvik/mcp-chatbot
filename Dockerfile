# Use Python 3.11 slim image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (required for MCP servers)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install uv (Python package manager for MCP servers)
RUN pip install uv

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy package.json and install Node.js dependencies
COPY package.json package-lock.json* ./
RUN npm install

# Copy application code
COPY . .

# Create necessary directories
RUN mkdir -p /app/images /app/logs

# Set environment variables
ENV PYTHONPATH=/app
ENV DISPLAY=:1

# Expose port
EXPOSE 8001

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8001/health || exit 1

# Start the application
CMD ["python", "mcp_api_server.py"]
