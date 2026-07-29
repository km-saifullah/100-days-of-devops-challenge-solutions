# Switch to root
sudo su -

# Pull the nginx stable image
docker pull nginx:stable

# Create and run the container
docker run -d \
  --name beta \
  -p 3001:80 \
  nginx:stable

# Verify
docker ps
docker images

# Test
curl http://localhost:3001