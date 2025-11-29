#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y docker.io

sudo systemctl start docker
sudo systemctl enable docker

# Remove existing strapi container if any, avoid conflicts
sudo docker rm -f strapi || true

# Create systemd service file for Strapi container
cat <<EOF | sudo tee /etc/systemd/system/strapi.service
[Unit]
Description=Strapi CMS Docker Container
After=docker.service
Requires=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --rm --name strapi -p 1337:1337 -v /srv/strapi:/srv/app \\
    -e NODE_ENV=production -e HOST=0.0.0.0 \\
    -e APP_KEYS="someRandomKey1,someRandomKey2" \\
    -e API_TOKEN_SALT="someRandomSalt" \\
    -e ADMIN_JWT_SECRET="someAdminJwtSecret" \\
    -e JWT_SECRET="someJwtSecret" \\
    -e DATABASE_CLIENT=sqlite \\
    strapi/strapi
ExecStop=/usr/bin/docker stop strapi

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd daemons and enable/start service
sudo systemctl daemon-reload
sudo systemctl enable strapi.service
sudo systemctl start strapi.service
