set -e

sudo apt update
sudo apt install curl coreutils gawk sipcalc python3 python3-pip -y
python3 -m pip install --upgrade pip
pip3 install --upgrade dnspython