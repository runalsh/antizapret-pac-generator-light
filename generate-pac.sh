#!/bin/bash
set -e

source config/config.sh
echo -n > "$PACFILE"

python3 scripts/topsequences.py result/hostlist_zones.txt temp/replace-common-sequences.awk temp/pacpatterns.js

# .pac header
echo "// ProstoVPN.AntiZapret PAC-host File
// Generated on $(date), by https://bitbucket.org/anticensority/antizapret-pac-generator-light/
// THIS FILE IS NEITHER OBFUSCATED NOR ENCRYPTED, IT'S COMPRESSED TO COMPLY WITH BROWSER PAC FILE SIZE LIMITS.
//
// NOTE 1: Proxy.pac file content varies on User-Agent HTTP header.
// NOTE 2: Some badly behaving User-Agents are banned, they get empty response.
// NOTE 3: Do not request PAC file faster than once a minute, rate limiting is applied.
// NOTE 4: Do not use the proxy servers outside of this file.
" >> "$PACFILE"

awk -f scripts/generate-pac-domains.awk result/hostlist_zones.txt >> "$PACFILE"
awk -v lzp=1 -f scripts/generate-pac-domains.awk result/hostlist_zones.txt > temp/domains-oneline.txt
python3 scripts/lzp.py temp/domains-oneline.txt temp/domains-oneline-data.txt temp/domains-oneline-mask.txt temp/domains-oneline-pac.js

# Collapse IP list
scripts/collapse_blockedbyip_noid2971.py

echo "// This variable now excludes IP addresses blocked by 33a-5536/2019 (since 17.05.2020) and 33-4/2018 (since 14.12.2020)" >> "$PACFILE"
sort -Vu temp/include-ips.txt result/iplist_blockedbyip_noid2971_collapsed.txt | \
    grep -v -F -x -f temp/exclude-ips.txt | awk -f scripts/generate-pac-ipaddrs.awk >> "$PACFILE"

SPECIAL="$(cat result/iplist_special_range.txt | xargs -n1 sipcalc | \
    awk 'BEGIN {notfirst=0} /Network address/ {n=$4} /Network mask \(bits\)/ {if (notfirst) {printf ","} printf "[\"%s\", %s]", n, $5; notfirst=1;}')"

PATTERNS=$(cat temp/pacpatterns.js)
PATTERNS_LZP=$(cat temp/domains-oneline-pac.js)
DOMAINS_LZP=$(cat temp/domains-oneline-data.txt)
MASK_LZP=$(cat temp/domains-oneline-mask.txt)

echo "var special = [
$SPECIAL
];

// domain name data encoded with LZP, without mask data
var domains_lzp = \"$DOMAINS_LZP\";

// LZP mask data, b64+patternreplace
var mask_lzp = \"$MASK_LZP\";

var az_initialized = 0;
// CIDR to netmask, for special
function nmfc(b) {var m=[];for(var i=0;i<4;i++) {var n=Math.min(b,8); m.push(256-Math.pow(2, 8-n)); b-=n;} return m.join('.');}
// replace repeating sequences in domain
function patternreplace(s, lzpmask) {
  var patterns = $PATTERNS;
  if (lzpmask)
   var patterns = $PATTERNS_LZP;
  for (pattern in patterns) {
    s = s.split(patterns[pattern]).join(pattern);
  }
  return s;
}
// LZP as in PPP, different hash func
var TABLE_LEN_BITS = 18;
var HASH_MASK = (1 << TABLE_LEN_BITS) - 1;
var table = Array(1 << TABLE_LEN_BITS);
var hash = 0;
function unlzp(d, m, lim) {
  var mask = 0, maskpos = 0, dpos = 0, out = Array(8), outpos = 0, outfinal = '';

  for (;;) {
    mask = m.charAt(maskpos++);
    if (!mask)
      break
    mask = mask.charCodeAt(0);
    outpos = 0;
    for (var i = 0; i < 8; i++) {
      if (mask & (1 << i)) {
        c = table[hash];
      } else {
        c = d.charAt(dpos++);
        if (!c)
          break
        c = c.charCodeAt(0);
        table[hash] = c;
      }
      out[outpos++] = String.fromCharCode(c);
      hash = ( (hash << 7) ^ c ) & HASH_MASK
    }
    if (outpos == 8)
      outfinal += out.join('');
    if (outfinal.length >= lim) break;
  }
  if (outpos < 8)
    outfinal += out.slice(0, outpos).join('');
  return [outfinal, dpos, maskpos];
}

function a2b(a) {
  var b, c, d, e = {}, f = 0, g = 0, h = \"\", i = String.fromCharCode, j = a.length;
  for (b = 0; 64 > b; b++) e[\"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/\".charAt(b)] = b;
  for (c = 0; j > c; c++) for (b = e[a.charAt(c)], f = (f << 6) + b, g += 6; g >= 8; ) ((d = 255 & f >>> (g -= 8)) || j - 2 > c) && (h += i(d));
  return h;
}

function FindProxyForURL(url, host) {" >> "$PACFILE"

echo "  if (domains.length < 10) return \"DIRECT\"; // list is broken

  if (!('indexOf' in Array.prototype)) {
    Array.prototype.indexOf= function(find, i /*opt*/) {
      if (i===undefined) i= 0;
      if (i<0) i+= this.length;
      if (i<0) i= 0;
      for (var n= this.length; i<n; i++)
        if (i in this && this[i]===find)
          return i;
      return -1;
    };
  }

  if (!az_initialized) {
    var prev_ipval = 0;
    var cur_ipval = 0;
    for (var i = 0; i < d_ipaddr.length; i++) {
     cur_ipval = parseInt(d_ipaddr[i], 36) + prev_ipval;
     d_ipaddr[i] = cur_ipval;
     prev_ipval = cur_ipval;
    }

    for (var i = 0; i < special.length; i++) {
     special[i][1] = nmfc(special[i][1]);
    }

    mask_lzp = a2b(patternreplace(mask_lzp, true));

    var leftover = '';
    for (dmn in domains) {
     for (dcnt in domains[dmn]) {
      dmnl = domains[dmn][dcnt];
      if (leftover.length < dmnl) {
       var reqd = (dmnl<=8192 ? 8192 : dmnl);
       var u = unlzp(domains_lzp, mask_lzp, reqd);
       domains_lzp = domains_lzp.slice(u[1]);
       mask_lzp = mask_lzp.slice(u[2]);
       leftover += u[0];
       u = 0;
       //if (reqd > leftover.length) alert('requested ' + reqd + ' got ' + leftover.length);
      }

      domains[dmn][dcnt] = leftover.slice(0, dmnl);
      leftover = leftover.slice(dmnl);
      //if (domains[dmn][dcnt].length != dmnl) alert('ERR 1');
     }
    }

    table = 0;
    az_initialized = 1;
  }

  var shost;
  if (/\.(ru|co|cu|com|info|net|org|gov|edu|int|mil|biz|pp|ne|msk|spb|nnov|od|in|ho|cc|dn|i|tut|v|dp|sl|ddns|dyndns|livejournal|herokuapp|azurewebsites|cloudfront|ucoz|3dn|nov|linode|sl-reverse|kiev|beget|kirov|akadns|scaleway|fastly|hldns|appspot|my1|hwcdn|deviantart|wixmp|wix|netdna-ssl|brightcove|berlogovo|edgecastcdn|trafficmanager|pximg|github|hopto|u-stream|google|keenetic|eu|googleusercontent|3nx|itch|notion|maryno|vercel|pythonanywhere|force|tilda|ggpht|iboards|mybb2|h1n|bdsmlr|narod|sb-cd|4chan)\.[^.]+$/.test(host))
    shost = host.replace(/(.+)\.([^.]+\.[^.]+\.[^.]+$)/, \"\$2\");
  else
    shost = host.replace(/(.+)\.([^.]+\.[^.]+$)/, \"\$2\");

  // remove leading www
  shost = shost.replace(/^www\.(.+)/, \"\$1\");" >> "$PACFILE"

cp "$PACFILE" "$PACFILE_NOSSL"

echo "
  fbtw = ['twitter.com', 'twimg.com', 't.co', 'x.com',
          'facebook.com', 'fbcdn.net',
          'instagram.com', 'cdninstagram.com',
          'fb.com', 'messenger.com',
          'yt3.ggpht.com'
          ];
  if (fbtw.indexOf(shost) !== -1) {
    return \"HTTPS ${PACFBTWHOST}; DIRECT\";
  }" >> "$PACFILE"

echo "
  var curdomain = shost.match(/(.*)\\.([^.]+\$)/);
  if (!curdomain || !curdomain[2]) {return \"DIRECT\";}
  var curhost = curdomain[1];
  var curzone = curdomain[2];
  curhost = patternreplace(curhost, false);
  var curarr = []; // dummy empty array
  if (domains.hasOwnProperty(curzone) && domains[curzone].hasOwnProperty(curhost.length)) {
    if (typeof domains[curzone][curhost.length] === 'string') {
      var regex = new RegExp('.{' + curhost.length.toString() + '}', 'g');
      domains[curzone][curhost.length] = domains[curzone][curhost.length].match(regex);
    }
    var curarr = domains[curzone][curhost.length];
  }

  var oip = false;
  if (! host.match(/^[0-9a-fA-F:.]*$/)) {
    // Do not resolve IPv4/v6 addresses to prevent slowdown
    oip = dnsResolve(host);
  }
  var iphex = \"\";
  if (oip) {
   iphex = oip.toString().split(\".\");
   iphex = parseInt(iphex[3]) + parseInt(iphex[2])*256 + parseInt(iphex[1])*65536 + parseInt(iphex[0])*16777216;
  }
  var yip = 0;
  var rip = 0;
  if (iphex && d_ipaddr.indexOf(iphex) !== -1) {yip = 1;}
  for (var i = 0; i < special.length; i++) {
    if (isInNet(oip, special[i][0], special[i][1])) {rip = 1; break;}
  }
  if (yip === 1 || rip === 1 || curarr.indexOf(curhost) !== -1) {

    // WARNING! WARNING! WARNING!
    // You should NOT use these proxy servers outside of PAC file!
    // DO NOT enter it manually in any program!
    // By doing this, you harm the service!" | tee -a "$PACFILE" "$PACFILE_NOSSL" >/dev/null

echo "    return \"HTTPS ${PACHTTPSHOST}; PROXY ${PACPROXYHOST}; DIRECT\";" >> "$PACFILE"
echo "    return \"PROXY ${PACPROXYHOST}; DIRECT\";" >> "$PACFILE_NOSSL"

echo "  }

  return \"DIRECT\";
}" | tee -a "$PACFILE" "$PACFILE_NOSSL" >/dev/null 
