# Single Stage Build Dockerfile
# FROM nginx:latest
# COPY index.html /usr/share/nginx/html/index.html

#RUN is used to install rpm/software in the container. 
# It is used in the build stage of the image. 
# It is not used in the runtime stage of the image.
# RUN apt-get update && apt-get install -y vim

# ADD index.html /usr/share/nginx/html/index.html
# it is used to copy files from the host machine to the container.
# It is used in the build stage of the image. 





# # Multi Stage Build Dockerfile
# # # Stage 1 - Build Stage
FROM alpine:latest AS builder

WORKDIR /app

COPY index.html .

# Stage 2 - Runtime Stage

FROM nginx:latest

COPY --from=builder /app/index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]


