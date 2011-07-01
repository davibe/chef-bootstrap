#!/bin/bash

# create the admin client in user ubuntu's .chef directory
ADMIN_USER=ubuntu
CHEF_DIR=/home/${ADMIN_USER}/.chef

# copy the bootstrapping keys to the .chef directory and make ADMIN_USER the owner
mkdir -p $CHEF_DIR
cp /etc/chef/validation.pem /etc/chef/webui.pem $CHEF_DIR
chown -R $ADMIN_USER $CHEF_DIR

# run knife to create chef-admin API client
sudo -u $ADMIN_USER knife configure -i <<-EOF
${CHEF_DIR}/knife.rb
http://chef:4000
chef-admin
chef-webui
${CHEF_DIR}/webui.pem
chef-validator
${CHEF_DIR}/validation.pem

EOF

# output the resulting config file and the current list of clients
cat ${CHEF_DIR}/knife.rb
sudo -u $ADMIN_USER knife client list
