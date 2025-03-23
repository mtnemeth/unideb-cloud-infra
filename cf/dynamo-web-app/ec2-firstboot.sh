#!/usr/bin/env bash

set -e

echo "Install OS packages"
yum install -y nginx git

webapp_user="webapp"


echo "Add Group"
groupadd "${webapp_user}"


echo "Add User"
useradd \
--create-home \
--shell /usr/bin/bash \
-g "${webapp_user}" \
"${webapp_user}"


echo "Set up the web app"
su - "${webapp_user}" <<EOF

cd $HOME
git clone https://github.com/mtnemeth/unideb-cloud-infra.git
cd unideb-cloud-infra
git checkout main
cd cf/dynamo-web-app/www

python3 -m venv ./venv
. ./venv/bin/activate
pip install -r requirements.txt

EOF


echo "Configure service for the Demo Web App"

cat > /etc/systemd/system/demo-app.service << EOF
[Unit]
Description=Demo Web App

[Service]
Type=simple
Environment="AWS_DEFAULT_REGION=us-east-1"
WorkingDirectory=/home/${webapp_user}/unideb-cloud-infra/cf/dynamo-web-app/www/
#ExecStart=/home/${webapp_user}/unideb-cloud-infra/cf/dynamo-web-app/www/venv/bin/flask run --host=0.0.0.0 -p 8080
ExecStart=/home/${webapp_user}/unideb-cloud-infra/cf/dynamo-web-app/www/venv/bin/gunicorn -w 4 --bind :8000 'app:app'
PIDFile=/tmp/demo-app.pid

[Install]
WantedBy=multi-user.target

EOF

echo "Enable and start the service for the Web App"
systemctl daemon-reload
systemctl enable demo-app.service
systemctl start demo-app.service


echo "Configure nginx"
cat > /etc/nginx/conf.d/demo-app.conf << EOF
server {
    listen *:80;
    listen [::]:80;
    server_name localhost;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

systemctl enable nginx
systemctl start nginx
nginx -s reload
