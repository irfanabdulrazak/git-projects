# Use the official Node.js 18.14 image as the base image
FROM node:18.14 AS build-stage

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install the project dependencies
RUN npm install

# Copy the application code to the container
COPY . .

# Build the Angular application
RUN npm run build


# Use the official NGINX image as the base image for the production stage
FROM nginx:latest AS production-stage

# Remove the default NGINX configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy the built Angular app from the previous stage
COPY --from=build-stage /usr/src/app/dist/totom-web /usr/share/nginx/html

# Copy the custom NGINX configuration file
COPY app.conf /etc/nginx/conf.d/app.conf

# Expose the default NGINX port
EXPOSE 80

# Start NGINX when the container starts
CMD ["nginx", "-g", "daemon off;"]
