# Use the latest stable Node.js LTS version
FROM node:20-slim

# Create professional app directory
WORKDIR /usr/src/app

# Install dependencies first (Optimization: Layer Caching)
COPY package*.json ./
RUN npm install --production

# Copy source code
COPY . .

# Expose the port for the AI Voice API
EXPOSE 3000

# Run the app with performance-tuned settings
CMD [ "node", "server.js" ]
