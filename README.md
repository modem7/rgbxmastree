# rgbxmastree

Raspberry Pi RGB Xmas Tree

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/modem7)

## Automated install script
```bash
curl -s https://raw.githubusercontent.com/modem7/rgbxmastree/master/install.sh | sudo bash
```

## Manual installation

Install required packages:

```bash
sudo apt update && \
sudo apt install -y python3-gpiozero python3-pigpio git
```

## Clone the Repo
```bash
cd /home/pi
git clone https://github.com/modem7/rgbxmastree.git
```

Copy across any scripts (`.py`) from the `examples` directory you wish, into the `/home/pi/rgbxmastree` directory and make them executable.

E.g.

```bash
cd /home/pi/rgbxmastree
cp examples/randomsparkles.py ./
sudo chmod +x *.py
```

## Create and enable the systemd service

Edit as required.

```bash
sudo tee /etc/systemd/system/rgbxmastree.service << EOF
# rgbxmastree.service
[Unit]
Description=PiHut RGB Christmas tree

[Service]
WorkingDirectory=/home/pi/rgbxmastree
Type=simple
User=pi

ExecStart=/usr/bin/python3 randomsparkles.py

[Install]
WantedBy=multi-user.target
EOF
```

Enable the service:

```bash
sudo systemctl daemon-reload && \
sudo systemctl enable --now rgbxmastree
```

## Editing the service

If you wish to edit the service (to change the script for example):

```bash
sudo nano /etc/systemd/system/rgbxmastree.service
```

Make your modifications, then restart the service with:

```bash
sudo systemctl restart rgbxmastree.service
```

