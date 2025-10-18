#!/bin/bash

# MCP Chatbot Server Production Startup Script
# This script ensures proper environment setup and starts the server

set -e  # Exit on any error

echo "🚀 Starting MCP Chatbot Server in Production Mode..."

# Check if required environment variables are set
check_env_var() {
    if [ -z "${!1}" ]; then
        echo "❌ Error: Environment variable $1 is not set"
        echo "Please set $1 in your environment or .env file"
        exit 1
    else
        echo "✅ $1 is set"
    fi
}

# Check for at least one LLM API key
if [ -z "$GROQ_API_KEY" ] && [ -z "$GEMINI_API_KEY" ]; then
    echo "❌ Error: At least one LLM API key must be set (GROQ_API_KEY or GEMINI_API_KEY)"
    exit 1
fi

# Check other required variables
echo "🔍 Checking environment variables..."
[ -n "$GROQ_API_KEY" ] && echo "✅ GROQ_API_KEY is set" || echo "⚠️  GROQ_API_KEY not set (optional)"
[ -n "$GEMINI_API_KEY" ] && echo "✅ GEMINI_API_KEY is set" || echo "⚠️  GEMINI_API_KEY not set (optional)"
[ -n "$NOTION_TOKEN" ] && echo "✅ NOTION_TOKEN is set" || echo "⚠️  NOTION_TOKEN not set (optional)"
[ -n "$OPENWEATHER_API_KEY" ] && echo "✅ OPENWEATHER_API_KEY is set" || echo "⚠️  OPENWEATHER_API_KEY not set (optional)"
[ -n "$GNEWS_API_KEY" ] && echo "✅ GNEWS_API_KEY is set" || echo "⚠️  GNEWS_API_KEY not set (optional)"

# Set default values if not provided
export PORT=${PORT:-8001}
export PYTHONPATH=${PYTHONPATH:-/app}
export DISPLAY=${DISPLAY:-:1}
export ALLOWED_ORIGINS=${ALLOWED_ORIGINS:-"http://localhost:4173,http://localhost:3000"}

echo "📋 Configuration:"
echo "   Port: $PORT"
echo "   Python Path: $PYTHONPATH"
echo "   Display: $DISPLAY"
echo "   Allowed Origins: $ALLOWED_ORIGINS"

# Create necessary directories
echo "📁 Creating necessary directories..."
mkdir -p /app/images /app/logs

# Install dependencies if requirements.txt exists
if [ -f "requirements.txt" ]; then
    echo "📦 Installing Python dependencies..."
    pip install --no-cache-dir -r requirements.txt
fi

# Install Node.js dependencies if package.json exists
if [ -f "package.json" ]; then
    echo "📦 Installing Node.js dependencies..."
    npm install
fi

# Check if the main server file exists
if [ ! -f "mcp_api_server.py" ]; then
    echo "❌ Error: mcp_api_server.py not found"
    exit 1
fi

# Start the server
echo "🎯 Starting FastAPI server..."
echo "   Server will be available at: http://0.0.0.0:$PORT"
echo "   Health check: http://0.0.0.0:$PORT/health"
echo "   API docs: http://0.0.0.0:$PORT/docs"
echo ""

# Use gunicorn for production if available, otherwise use uvicorn
if command -v gunicorn &> /dev/null; then
    echo "🚀 Starting with Gunicorn (Production WSGI Server)..."
    exec gunicorn mcp_api_server:app \
        --bind 0.0.0.0:$PORT \
        --workers 1 \
        --worker-class uvicorn.workers.UvicornWorker \
        --timeout 120 \
        --keep-alive 2 \
        --max-requests 1000 \
        --max-requests-jitter 100 \
        --access-logfile - \
        --error-logfile - \
        --log-level info
else
    echo "🚀 Starting with Uvicorn (Development Server)..."
    exec python mcp_api_server.py
fi
