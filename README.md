# Antizapret PAC Generator from ValdikSS #

## with some fixes and adds for selfusing ##

### Just change config in config/config.sh and run ./doall.sh 

Resulting PAC files is

| NOSSL  | SSL  |
|---|---|
| [proxy-host-nossl.pac](https://raw.githubusercontent.com/runalsh/antizapret-pac-generator-light/main/result/proxy-host-nossl.pac)  | [proxy-host-ssl.pac](https://raw.githubusercontent.com/runalsh/antizapret-pac-generator-light/main/result/proxy-host-ssl.pac)  |
| [proxy-host-nossl-pattern.pac](https://raw.githubusercontent.com/runalsh/antizapret-pac-generator-light/main/result/proxy-host-nossl-pattern.pac) | [proxy-host-ssl-pattern.pac](https://raw.githubusercontent.com/runalsh/antizapret-pac-generator-light/main/result/proxy-host-ssl-pattern.pac)  |
| [proxy-host-nossl-original.pac](https://raw.githubusercontent.com/runalsh/antizapret-pac-generator-light/main/result/proxy-host-nossl-original.pac) |  [proxy-host-ssl-original.pac](https://raw.githubusercontent.com/runalsh/antizapret-pac-generator-light/main/result/proxy-host-ssl-original.pac) |
| [proxy-host-nossl-original-myproxy.pac](https://raw.githubusercontent.com/runalsh/antizapret-pac-generator-light/main/result/proxy-host-nossl-original-myproxy.pac)  |  [proxy-host-ssl-original-myproxy.pac](https://raw.githubusercontent.com/runalsh/antizapret-pac-generator-light/main/result/proxy-host-ssl-original-myproxy.pac) |


Changes/improvements:

    - requirements install
    - itdoginfo lists (https://github.com/itdoginfo/allow-domains)
    - antifilter CE list (https://community.antifilter.download/)
    - openai list (https://github.com/antonme/ipnames/blob/master/dns-openai.txt)
    - svintuss list (https://raw.githubusercontent.com/svintuss/unblock/main/unblock.txt)
    - github action for PAC update (daily at 01:00)
    - TOR and I2P integration (change servers in /config/config.sh)
    - proxies changed to 127.0.0.1:6666 - local shadowsocks (change in /config/config.sh)
    - option EXCLUDE_PATTERN_PAC in config/config.sh to enable skipping some frequent patterns (list - excludepattern.sh) for reduce resulting PAC files
    - added build original pac file and original with my proxy
    - small improvements

Bug (fck windows): new scripts doesnt have exec bit, git add --chmod=+x -- *.sh *.py or git add --chmod=+x -- *. *

crontab -e

    - 0 1 */3 * * /root/antizapret-pac-generator-light/doall.sh && cp /root/antizapret-pac-generator-light/result/proxy-host-ssl.pac /var/www/pac

lighttpd server

    - lighttpd.conf to /etc/lighttpd/lighttpd.conf

Notes

    - may be add https://github.com/bol-van/rulist resolved ip and domains instead of z-i


Original https://bitbucket.org/anticensority/antizapret-pac-generator-light (commit 2d79814 from 2024-04-03)
