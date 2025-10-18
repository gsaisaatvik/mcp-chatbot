# 🚀 MCP Chatbot Server Deployment Guide

This guide will help you deploy the MCP Chatbot Server to Railway for production use.

## 📋 Prerequisites

- GitHub account with your MCP chatbot repository
- Railway account (free tier available)
- API keys for the services you want to use:
  - Groq API key (recommended)
  - Google Gemini API key (optional)
  - Notion token (optional)
  - OpenWeatherMap API key (optional)
  - GNews API key (optional)

## 🚀 Quick Deploy to Railway

### Step 1: Prepare Your Repository

1. **Fork or clone this repository**
2. **Ensure you have all deployment files:**
   - `railway.json` - Railway configuration
   - `Procfile` - Process definition
   - `Dockerfile` - Container configuration
   - `env.example` - Environment variables template
   - `start_production.sh` - Production startup script

### Step 2: Set Up Railway Account

1. Go to [railway.app](https://railway.app)
2. Sign up with your GitHub account
3. Authorize Railway to access your repositories

### Step 3: Deploy Your Project

1. **Create a new project:**
   - Click "New Project" in Railway dashboard
   - Select "Deploy from GitHub repo"
   - Choose your MCP chatbot repository
   - Select the branch you want to deploy (recommended: `deap18`)

2. **Configure the deployment:**
   - Railway will automatically detect Python and Node.js
   - The build process will install dependencies from `requirements.txt` and `package.json`

### Step 4: Set Environment Variables

In your Railway project dashboard:

1. Go to the "Variables" tab
2. Add the following environment variables:

#### Required Variables:
```bash
# At least one LLM API key is required
GROQ_API_KEY=your_groq_api_key_here
# OR
GEMINI_API_KEY=your_gemini_api_key_here
```

#### Optional Variables:
```bash
# External service integrations
NOTION_TOKEN=your_notion_token_here
OPENWEATHER_API_KEY=your_openweather_api_key_here
GNEWS_API_KEY=your_gnews_api_key_here

# Server configuration
PORT=8001
PYTHONPATH=/app
DISPLAY=:1

# CORS configuration (add your frontend URLs)
ALLOWED_ORIGINS=https://your-app.vercel.app,https://your-app-preview.vercel.app
```

### Step 5: Deploy and Test

1. **Deploy:**
   - Railway will automatically deploy when you push to your repository
   - Monitor the deployment logs in the Railway dashboard

2. **Test your deployment:**
   - Health check: `https://your-app.railway.app/health`
   - API documentation: `https://your-app.railway.app/docs`
   - List tools: `https://your-app.railway.app/tools`

## 🔧 Configuration Options

### MCP Servers Configuration

The server uses `servers_config.json` to configure MCP servers. You can customize this file to:

- Add or remove MCP servers
- Configure server-specific environment variables
- Modify server arguments

See `CONFIGURATION.md` for detailed configuration options.

### CORS Configuration

To allow your frontend to connect to the API:

1. Set the `ALLOWED_ORIGINS` environment variable in Railway
2. Include your Vercel frontend URLs:
   ```bash
   ALLOWED_ORIGINS=https://your-app.vercel.app,https://your-app-preview.vercel.app
   ```

## 🌐 Frontend Integration

### For Vercel Frontend Deployment

1. **Update your frontend API endpoint:**
   ```javascript
   // Replace localhost with your Railway URL
   const API_BASE_URL = "https://your-app.railway.app"
   ```

2. **Test the connection:**
   ```javascript
   // Test API connectivity
   fetch(`${API_BASE_URL}/health`)
     .then(response => response.json())
     .then(data => console.log('API Status:', data))
   ```

## 📊 Monitoring and Logs

### Railway Dashboard
- View deployment logs in real-time
- Monitor resource usage
- Check deployment status

### Health Checks
- The server includes a health check endpoint at `/health`
- Railway will automatically monitor this endpoint
- Failed health checks will trigger automatic restarts

### API Endpoints
- `/health` - Health check
- `/status` - Detailed server status
- `/tools` - List available MCP tools
- `/docs` - Interactive API documentation
- `/query` - Process queries (POST)

## 🔄 Updating Your Deployment

1. **Push changes to your repository**
2. **Railway will automatically redeploy**
3. **Monitor the deployment logs**
4. **Test the updated deployment**

## 🛠️ Troubleshooting

### Common Issues

1. **Build Failures:**
   - Check that all dependencies are in `requirements.txt`
   - Ensure Node.js dependencies are in `package.json`
   - Review build logs in Railway dashboard

2. **Runtime Errors:**
   - Verify all required environment variables are set
   - Check application logs in Railway dashboard
   - Ensure API keys are valid

3. **CORS Issues:**
   - Verify `ALLOWED_ORIGINS` includes your frontend URL
   - Check that frontend is using HTTPS in production

4. **MCP Server Initialization Failures:**
   - Some MCP servers may fail to initialize (this is normal)
   - Check the `/status` endpoint to see which servers are working
   - The application will continue with available servers

### Getting Help

1. Check the Railway deployment logs
2. Test individual endpoints using the API documentation
3. Verify environment variables are correctly set
4. Review the server status at `/status`

## 💰 Cost Considerations

- Railway offers a free tier with limited usage
- Monitor your usage in the Railway dashboard
- Consider upgrading if you need more resources

## 🔒 Security Best Practices

1. **Never commit API keys to your repository**
2. **Use environment variables for all sensitive data**
3. **Regularly rotate your API keys**
4. **Monitor your deployment logs for suspicious activity**
5. **Use HTTPS in production (Railway provides this automatically)**

## 📈 Scaling

As your application grows:

1. **Monitor resource usage in Railway dashboard**
2. **Consider upgrading your Railway plan**
3. **Implement caching for frequently used data**
4. **Monitor API rate limits for external services**

---

## 🎉 You're Ready!

Your MCP Chatbot Server is now deployed and ready to serve your frontend application. Share the Railway URL with your frontend team and start building amazing AI-powered applications!

For more advanced configuration options, see `CONFIGURATION.md`.
