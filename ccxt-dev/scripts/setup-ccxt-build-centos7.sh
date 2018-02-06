#!/bin/sh -ex

# These steps have been validated in centos/7 vagrant box:
# https://app.vagrantup.com/centos/boxes/7/versions/1801.02

# Fetch the nodejs repository setup script
# https://github.com/nodesource/distributions
# Note: curl pipe sudo bash is suicide, check the file first!
# If the checksum changes, manually inspect the file.
curl -OL https://rpm.nodesource.com/setup_8.x 
sha256sum -c <<EOF
63f1e0954f8c332c9f33ef71ce7ee5f71b5f5f2b8663dee699048607986b3dcc  setup_8.x
EOF

# Install the nodejs repository
# Note: do not use bash -e, the script has unchecked errors
sudo bash -x setup_8.x 

# Install nodejs
sudo yum install -y nodejs

# Install epel-release repository
sudo yum install -y epel-release

# Install SCL repository
sudo yum install -y centos-release-scl

# Install python 3.6 from SCL
sudo yum install -y rh-python36

# Install php 5.6 and php-mbstring
sudo yum install -y rh-php56-php rh-php56-php-mbstring

# Fetch pandoc static binary
# https://github.com/jgm/pandoc/releases/latest
curl -OL https://github.com/jgm/pandoc/releases/download/2.1.1/pandoc-2.1.1-linux.tar.gz
sha256sum -c <<EOF
cc2a88e6ec5e85819b2e12a944cbeb498cf908176973b6066fc678c2ad95a571  pandoc-2.1.1-linux.tar.gz
EOF

# Install pandoc
sudo tar xvzf pandoc-2.1.1-linux.tar.gz --strip-components 1 -C /usr/local/

# Install git
sudo yum install -y git

# Install tox in our python 3.6 environment
sudo /bin/sh -c 'source /opt/rh/rh-python36/enable && pip install tox'

cat <<EOF

Usage:

# Switch to python 3.6 and PHP 5.6 environment
source /opt/rh/rh-python36/enable
source /opt/rh/rh-php55/enable

# Clone the git repository
# If you are contributing, you will need to clone your own fork
git clone https://github.com/ccxt/ccxt.git

# Switch into the source tree
cd ccxt

# Do the build
npm install
npm run build

EOF
