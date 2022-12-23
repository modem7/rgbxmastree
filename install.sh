#!/bin/sh

set -e

# Variables
PIUSER=${SUDO_USER:-$USER}
TREESCRIPT="randomsparkles.py"

# Check if script is being run as root
if [ "$(id -u)" -eq 0 ]; then
    echo "==> Running with sudo. Continuing..."
else
    echo "==> This script requires elevated priviledges."
    echo "==> Please run this script with sudo." >&2
    exit 1
fi

# Check if required packages are installed - install if they aren't.
package_check() {
    PKG_LIST='python3-gpiozero python3-pigpio git'
    # if input is a file, convert it to a string like:
    # PKG_LIST=$(cat ./packages.txt)
    # PKG_LIST=$1
    for package in $PKG_LIST; do
        CHECK_PACKAGE=$(sudo dpkg -l \
        | grep --max-count 1 "$package" \
        | awk '{print$ 2}')

        if [ -n "$CHECK_PACKAGE" ];
        then
            echo "$package" 'is installed...';
        else
            echo "$package" 'Is NOT installed, installing...';
            apt-get -y install --no-install-recommends "$package"
        fi
    done
}

# Check if Git repo already exists before continuing
if [ -d "/home/$PIUSER/rgbxmastree" ] 
then
    echo "======================================="
    echo "Git repo already exists."
    echo "Please delete \"/home/$PIUSER/rgbxmastree\" folder and re-run this script."
    echo "======================================="
    exit 1
fi

echo "==> Checking for prerequisite packages..."
apt update
package_check

# Cloning Git repo
echo "==> Cloning Git Repo..."
cd /home/$PIUSER
git clone https://github.com/modem7/rgbxmastree.git
cd rgbxmastree/

# Fixing permissions
echo "==> Fixing permissions..."
chown -R $PIUSER: /home/$PIUSER/rgbxmastree

# Copy Python scripts to working directory
cp examples/randomsparkles.py ./
chmod +x *.py

echo "==> Creating system service..."
tee /etc/systemd/system/rgbxmastree.service >/dev/null << EOF
# rgbxmastree.service
[Unit]
Description=PiHut RGB Christmas tree

[Service]
WorkingDirectory=/home/$PIUSER/rgbxmastree
Type=simple
User=$PIUSER

ExecStart=/usr/bin/python3 $TREESCRIPT

[Install]
WantedBy=multi-user.target
EOF

echo "==> Enabling system service..."
systemctl daemon-reload
systemctl enable --now rgbxmastree


# Final message for users
echo ""
echo "==================================================="
echo "Christmas Tree is now activated"
echo "==================================================="
exit 0
