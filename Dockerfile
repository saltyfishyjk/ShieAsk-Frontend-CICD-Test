FROM node:16 AS builder
WORKDIR /app
COPY . .

RUN npm install -g npm@9.6.4 \
    && npm install \ 
    && cd node_modules ; cd tiptap-extensions ; mv node_modules node_modules_ ; cd .. ; cd .. \
    && npm run build:prod

#FROM nginx
#RUN mkdir /app
#COPY --from=0 /app/dist /app
#COPY nginx.conf /etc/nginx/nginx.conf

# nginx state for serving content
FROM nginx:alpine
# Set working directory to nginx asset directory
WORKDIR /usr/share/nginx/html
# Remove default nginx static assets
RUN rm -rf ./*
# Copy static assets from builder stage
COPY --from=builder /app/dist .
# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]