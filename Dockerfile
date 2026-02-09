# Stage 1: Build
FROM node:20-alpine AS build
WORKDIR /app

# Install dependencies first to leverage Docker cache
COPY package*.json ./
RUN npm install

# Copy the rest of the code
COPY . .

# Argument to define which environment to build (dev, test, or prod)
# Defaults to production if nothing is passed
ARG ENV_CONFIGURATION=production
RUN npm run build -- --configuration=$ENV_CONFIGURATION

# Stage 2: Server (Nginx)
FROM nginx:alpine
# Copy our custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy compiled files from the build stage
# Note: The exact path depends on your angular.json (zamadev)
COPY --from=build /app/dist/zamadev/browser /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]