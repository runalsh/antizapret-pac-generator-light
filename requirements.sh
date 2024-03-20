set -e

sudo apt update
sudo apt install curl coreutils gawk sipcalc python3 python3-pip -y
sudo python3 -m pip install --upgrade pip --break-system-packages
sudo pip3 install --upgrade dnspython --break-system-packages