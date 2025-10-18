# ⚙️ MCP Chatbot Server Configuration Guide

This guide explains how to configure and customize your MCP Chatbot Server for different use cases.

## 📁 Configuration Files Overview

### Core Configuration Files
- `servers_config.json` - MCP server configurations
- `env.example` - Environment variables template
- `railway.json` - Railway deployment settings
- `requirements.txt` - Python dependencies
- `package.json` - Node.js dependencies

## 🔧 MCP Servers Configuration

The `servers_config.json` file defines which MCP servers to initialize and how to configure them.

### Current Configuration

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"],
      "env": { "DISPLAY": ":1" }
    },
    "airbnb": {
      "command": "npx",
      "args": ["-y", "@openbnb/mcp-server-airbnb"]
    },
    "sqlite": {
      "command": "uvx",
      "args": ["mcp-server-sqlite", "--db-path", "./test.db"]
    },
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
    },
    "notionApi": {
      "command": "npx",
      "args": ["-y", "@notionhq/notion-mcp-server"],
      "env": {
        "NOTION_TOKEN": "YOUR_NOTION_TOKEN_HERE"
      }
    },
    "windowsClock": {
      "command": "python",
      "args": ["mcp-windows-clock.py"]
    },
    "windowsScheduler": {
      "command": "python",
      "args": ["mcp-windows-scheduler.py"]
    }
  }
}
```

### Adding New MCP Servers

To add a new MCP server:

1. **Find the MCP server package** (usually on npm or PyPI)
2. **Add configuration to `servers_config.json`:**

```json
{
  "mcpServers": {
    "yourNewServer": {
      "command": "npx",  // or "python", "uvx", etc.
      "args": ["-y", "@package/name"],
      "env": {
        "API_KEY": "your_api_key_here"
      }
    }
  }
}
```

### Popular MCP Servers to Add

#### File System Operations
```json
"filesystem": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed/directory"]
}
```

#### Git Operations
```json
"git": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-git", "--repository", "/path/to/repo"]
}
```

#### Memory/Vector Database
```json
"memory": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-memory"]
}
```

#### Web Search
```json
"brave-search": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-brave-search"],
  "env": {
    "BRAVE_API_KEY": "your_brave_api_key"
  }
}
```

### Removing Servers

To disable a server, simply remove its configuration from `servers_config.json` or comment it out:

```json
{
  "mcpServers": {
    // "windowsClock": {
    //   "command": "python",
    //   "args": ["mcp-windows-clock.py"]
    // }
  }
}
```

## 🌍 Environment Variables Configuration

### Required Variables

At least one LLM API key is required:

```bash
# Primary LLM provider (recommended)
GROQ_API_KEY=your_groq_api_key_here

# Alternative LLM provider
GEMINI_API_KEY=your_gemini_api_key_here
```

### Optional Variables

```bash
# External service integrations
NOTION_TOKEN=your_notion_token_here
OPENWEATHER_API_KEY=your_openweather_api_key_here
GNEWS_API_KEY=your_gnews_api_key_here

# Server configuration
PORT=8001
PYTHONPATH=/app
DISPLAY=:1

# CORS configuration
ALLOWED_ORIGINS=https://your-app.vercel.app,https://your-app-preview.vercel.app
```

### Environment-Specific Configurations

#### Development
```bash
# .env file for local development
GROQ_API_KEY=your_dev_key
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:4173
LOG_LEVEL=DEBUG
```

#### Production
```bash
# Railway environment variables
GROQ_API_KEY=your_prod_key
ALLOWED_ORIGINS=https://your-app.vercel.app
LOG_LEVEL=INFO
PORT=8001
```

## 🎯 Customizing Server Behavior

### LLM Provider Selection

The server automatically selects the best available LLM provider:

1. **Groq** (if `GROQ_API_KEY` is set)
2. **Gemini** (if `GEMINI_API_KEY` is set)
3. **Fallback** to available provider

### CORS Configuration

Configure allowed origins for your frontend:

```bash
# Single origin
ALLOWED_ORIGINS=https://your-app.vercel.app

# Multiple origins (comma-separated)
ALLOWED_ORIGINS=https://your-app.vercel.app,https://staging.vercel.app,http://localhost:3000
```

### Database Configuration

For SQLite server:

```json
"sqlite": {
  "command": "uvx",
  "args": ["mcp-server-sqlite", "--db-path", "/app/data/production.db"]
}
```

## 🔒 Security Configuration

### API Key Management

1. **Never commit API keys to your repository**
2. **Use environment variables for all sensitive data**
3. **Rotate keys regularly**
4. **Use different keys for development and production**

### CORS Security

```bash
# Restrict to specific domains
ALLOWED_ORIGINS=https://yourdomain.com,https://www.yourdomain.com

# Allow all origins (not recommended for production)
ALLOWED_ORIGINS=*
```

### Server Access Control

Some MCP servers support access control:

```json
"filesystem": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-filesystem", "/safe/directory"]
}
```

## 📊 Performance Configuration

### Resource Limits

In `railway.json`:

```json
{
  "deploy": {
    "healthcheckTimeout": 100,
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

### Gunicorn Configuration

In `start_production.sh`:

```bash
exec gunicorn mcp_api_server:app \
  --bind 0.0.0.0:$PORT \
  --workers 4 \
  --worker-class uvicorn.workers.UvicornWorker \
  --timeout 120 \
  --max-requests 1000
```

## 🧪 Testing Configuration

### Local Testing

1. **Copy `env.example` to `.env`**
2. **Fill in your API keys**
3. **Run locally:**
   ```bash
   python mcp_api_server.py
   ```

### Production Testing

1. **Deploy to Railway**
2. **Test endpoints:**
   - Health: `https://your-app.railway.app/health`
   - Status: `https://your-app.railway.app/status`
   - Tools: `https://your-app.railway.app/tools`

## 🔄 Configuration Updates

### Updating MCP Servers

1. **Modify `servers_config.json`**
2. **Push changes to your repository**
3. **Railway will automatically redeploy**
4. **Check `/status` endpoint for server status**

### Updating Environment Variables

1. **Update variables in Railway dashboard**
2. **Redeploy the application**
3. **Test the changes**

## 🐛 Troubleshooting Configuration

### Common Issues

1. **Server Initialization Failures:**
   - Check server command and arguments
   - Verify required environment variables
   - Review deployment logs

2. **API Key Issues:**
   - Verify keys are correctly set
   - Check key permissions and quotas
   - Test keys independently

3. **CORS Issues:**
   - Verify `ALLOWED_ORIGINS` format
   - Check frontend URL matches exactly
   - Test with browser developer tools

### Debug Mode

Enable debug logging:

```bash
LOG_LEVEL=DEBUG
```

This will provide detailed information about server initialization and tool loading.

## 📚 Advanced Configuration

### Custom MCP Server

Create your own MCP server:

1. **Follow MCP server development guidelines**
2. **Add to `servers_config.json`**
3. **Include in your deployment**

### Load Balancing

For high-traffic applications:

1. **Use multiple Railway instances**
2. **Implement load balancer**
3. **Configure shared database**

### Monitoring

Add monitoring tools:

```json
"monitoring": {
  "command": "npx",
  "args": ["-y", "@your-org/mcp-monitoring"]
}
```

---

## 🎉 Configuration Complete!

Your MCP Chatbot Server is now configured for your specific needs. Remember to:

- Test all configurations in development first
- Keep API keys secure
- Monitor your deployment logs
- Update configurations as your needs evolve

For deployment instructions, see `DEPLOYMENT.md`.
