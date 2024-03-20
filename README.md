with some fixes and adds for selfusing

crontab -e

 0 1 */3 * * /root/antizapret-pac-generator-light/doall.sh && cp /root/antizapret-pac-generator-light/result/proxy-host-ssl.pac /var/www/pac

lighttpd.conf /etc/lighttpd/lighttpd.conf

original https://bitbucket.org/anticensority/antizapret-pac-generator-light