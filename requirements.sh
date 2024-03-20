set -e

sudo apt update
sudo apt install curl coreutils gawk sipcalc python3 python3-pip idn -y
python3 -m pip install --upgrade pip
pip3 install --upgrade dnspython
# python3 -m pip install --upgrade pip --break-system-packages
# pip3 install --upgrade dnspython --break-system-packages
# sudo mv /usr/lib/python3.11/EXTERNALLY-MANAGED /usr/lib/python3.11/EXTERNALLY-MANAGED.old
# python3 -m pip config set global.break-system-packages true
# or
# mkdir -p ~/.config/pip
# touch ~/.config/pip/pip.conf
# echo '[global]
# break-system-packages = true' >> ~/.config/pip/pip.conf