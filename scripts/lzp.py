#!/usr/bin/env python3

import sys
import os
import base64
import textwrap

'''
This script implements LZP compression for PAC file.
'''

def encode(inputname):
    TABLE_LEN_BITS = 18
    HASH_MASK = (1 << TABLE_LEN_BITS) - 1

    ifile = open(sys.argv[1], "rb")
    table = bytearray(1 << TABLE_LEN_BITS)
    masks = bytearray()
    obytes = bytearray()
    hashed = 0

    while True:
        mask = 0
        buf = b""

        for i in range(8):
            cb = ifile.read(1)
            if not cb:
                break
            c = ord(cb)

            if c == table[hashed]:
                mask |= 1 << i;
            else:
                table[hashed] = c
                buf += cb

            hashed = ( (hashed << 7) ^ c ) & HASH_MASK

        masks += mask.to_bytes(1, 'big')
        obytes += buf

        if not cb:
            break

    ifile.close()
    return [obytes, masks]


def findsequence(inputstr):
    wordreplace=["!", "@", "#", "$", "%", "^", "*", "(", ")", "[", "]", "-", ",", ".", "?"]
    patternhit = {}
    pattern_found = {}
    input_len = len(inputstr)

    for patternlen in (2,):
        for round, _ in enumerate(wordreplace):
            position = 0
            while position <= input_len:
                cut = inputstr[position:position+patternlen]
                position += 1
                if len(cut) != patternlen:
                    continue
                if not patternhit.get(cut):
                    patternhit[cut] = 0
                patternhit[cut] += 1
            #print("Round", round, "patternhit", patternhit)
            patternhit = dict(sorted(patternhit.items(), key=lambda x: len(x[0]) * x[1])[-1:])
            inputstr = inputstr.replace(list(patternhit.keys())[0], '')
            pattern_found.update(patternhit)
            patternhit = {}
            print("Round", round, "pattern_found", pattern_found)

    pattern_ret = {}
    for i, p in enumerate(pattern_found.keys()):
        pattern_ret.update({p: wordreplace[i]})
    return pattern_ret

if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("{}: <input.txt> <output_data.txt> <output_mask.txt> <pac function.js>".format(sys.argv[0]))
        sys.exit(1)

    ofile = open(sys.argv[2], "wb")
    mfile = open(sys.argv[3], "wb")

    obytes, masks = encode(sys.argv[1])
    masks_b64 = base64.b64encode(masks).decode()
    masks_seqences = findsequence(masks_b64)
    masks_sequenced = masks_b64
    for k, v in masks_seqences.items():
        #print(k, v)
        masks_sequenced = masks_sequenced.replace(k, v)

    print("masks:", len(masks), " masks_b64:", len(masks_b64), " masks_sequenced:", len(masks_sequenced))
    print("obytes:", len(obytes))
    print("overall:", len(obytes) + len(masks_sequenced))

    os.write(ofile.fileno(), "\\\n".join(textwrap.wrap(obytes.decode(), 8192, expand_tabs=False, replace_whitespace=False, drop_whitespace=False, break_long_words=True, break_on_hyphens=False)).encode())
    os.write(mfile.fileno(), "\\\n".join(textwrap.wrap(masks_sequenced, 8192, expand_tabs=False, replace_whitespace=False, drop_whitespace=False, break_long_words=True, break_on_hyphens=False)).encode())
    ofile.close()
    mfile.close()

    with open(sys.argv[4], "w") as pacfile:
        print(masks_seqences, file=pacfile)
