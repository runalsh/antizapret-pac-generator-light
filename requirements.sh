set -e

apt update
apt install curl coreutils gawk sipcalc python3 python3-pip -y
python3 -m pip install --upgrade pip --break-system-packages
pip3 install --upgrade dnspython --break-system-packages