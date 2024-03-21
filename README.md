Antizapret PAC Generator from ValdikSS with some fixes and adds for selfusing

Changes/improvements:

    - requirements install

    - itdoginfo lists (https://github.com/itdoginfo/allow-domains)

    - antifilter CE list (https://community.antifilter.download/)

    - openai list (https://github.com/antonme/ipnames/blob/master/dns-openai.txt)

    - github action with for PAC update (daily at 01:00)

    - TOR and I2P integration (change servers in /config/config.sh)

    - proxys changed to 127.0.0.1:6666 - local shadowsocks (change in /config/config.sh)

    - small improvements

crontab -e

    - 0 1 */3 * * /root/antizapret-pac-generator-light/doall.sh && cp /root/antizapret-pac-generator-light/result/proxy-host-ssl.pac /var/www/pac

lighttpd server

    - lighttpd.conf to /etc/lighttpd/lighttpd.conf

Resulting PAC files is

    - https://raw.githubusercontent.com/runalsh/antizapret-pac-generator-light/main/result/proxy-host-nossl.pac

    - https://raw.githubusercontent.com/runalsh/antizapret-pac-generator-light/main/result/proxy-host-ssl.pac

Notes

    - may be this too https://github.com/svintuss/unblock/blob/main/unblock.txt


Original https://bitbucket.org/anticensority/antizapret-pac-generator-light
