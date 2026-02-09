# Stage 1: Build
FROM node:20-alpine AS build
WORKDIR /app

# Install dependencies first to leverage Docker cache
COPY package*.json ./
RUN npm install

# Copy the rest of the code
COPY . .

# Argument to define which environment to build (dev, test, or prod)
ARG ENV_CONFIGURATION=production

# dev  -> development
# test -> test 
# prod -> production
RUN if [ "$ENV_CONFIGURATION" = "dev" ]; then \
        npm run build -- --configuration=development; \
    elif [ "$ENV_CONFIGURATION" = "test" ]; then \
        npm run build -- --configuration=test; \
    else \
        npm run build -- --configuration=production; \
    fi

# Stage 2: Server (Nginx)
FROM nginx:alpine
# Copy our custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy compiled files from the build stage
COPY --from=build /app/dist/zamadev/browser /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]