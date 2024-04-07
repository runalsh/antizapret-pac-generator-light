#!/usr/bin/env python3

import sys

'''
This script finds the most common two-character sequences
and replace them with a single uppercase character or
special character, to compression purposes.
'''

if len(sys.argv) != 4:
    print("{}: <host list.txt> <awk output.awk> <pac function.js>".format(sys.argv[0]))
    sys.exit(1)

#patternhit = {"cloudfront": 999999999}
patternhit = {}
# "&" character should be prepended with two backslashes for awk's gsub.
wordreplace=["A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
             "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
             "U", "V", "W", "X", "Y", "Z",
             "@", "#", "$", "%", "^", "\\\\&", "*", "(", ")",
             "=", "+", "/", ",", "<", ">", "~", "[", "]", "{", "}",
             "`", ":", ";", "?"]
wordreplace_big = ["!" + x for x in wordreplace]

with open(sys.argv[1], "r") as dfile:
    domains = dfile.read().split("\n")

    new_domains = []
    for domain in domains:
        #print('.'.join(domain.split(".")[:-1]))
        #sys.exit(1)
        new_domains.append('.'.join(domain.split(".")[:-1]))
    domains = ''.join(new_domains)

    domain_len = len(domains)
    position = 0

    pattern_found = {}

    for patternlen in (4,):
        for round, _ in enumerate(wordreplace_big):
            position = 0
            while position <= domain_len:
                cut = domains[position:position+patternlen]
                position += 1
                if len(cut) != patternlen:
                    continue
                if not patternhit.get(cut):
                    patternhit[cut] = 0
                patternhit[cut] += 1
            #print("Round", round, "patternhit", patternhit)
            patternhit = dict(sorted(patternhit.items(), key=lambda x: len(x[0]) * x[1])[-1:])
            domains = domains.replace(list(patternhit.keys())[0], '')
            pattern_found.update(patternhit)
            patternhit = {}
            print("Big round", round, "pattern_found", pattern_found)

    for patternlen in (2,):
        for round, _ in enumerate(wordreplace):
            position = 0
            while position <= domain_len:
                cut = domains[position:position+patternlen]
                position += 1
                if len(cut) != patternlen:
                    continue
                if not patternhit.get(cut):
                    patternhit[cut] = 0
                patternhit[cut] += 1
            #print("Round", round, "patternhit", patternhit)
            patternhit = dict(sorted(patternhit.items(), key=lambda x: len(x[0]) * x[1])[-1:])
            domains = domains.replace(list(patternhit.keys())[0], '')
            pattern_found.update(patternhit)
            patternhit = {}
            print("Round", round, "pattern_found", pattern_found)

#patternhit = dict(sorted(patternhit.items(), key=lambda x: len(x[0]) * x[1]))
patternhit = pattern_found
print(patternhit)

#print(patternhit, file=sys.stderr)
#finallist = list(patternhit)[:len(wordreplace)]
finallist = list(patternhit)
#finallist.reverse()
print(finallist, file=sys.stderr)
wordreplace = wordreplace_big + wordreplace

with open(sys.argv[2], "w") as awkfile:
    print("{", file=awkfile)
    for i, w in enumerate(finallist):
        print('gsub(/{}/, "{}", domainname)'.format(w.replace(".", "\\."), wordreplace[i]), file=awkfile)
    print("}", file=awkfile)

with open(sys.argv[3], "w") as pacfile:
    pacdict = {}
    for i, w in enumerate(finallist):
        pacdict[wordreplace[i].strip('\\')] = w
    print(pacdict, file=pacfile)
