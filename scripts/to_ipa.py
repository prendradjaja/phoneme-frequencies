#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import fileinput


correspondences = {
    'AA': 'ɑ',   # odd     AA D
    'AE': 'æ',   # at      AE T
    'AH': 'ʌ',   # hut     HH AH T
    'AO': 'ɔ',   # ought   AO T
    'AW': 'aʊ',  # cow     K AW
    'AY': 'aɪ',  # hide    HH AY D
    'B' : 'b',   # be      B IY
    'CH': 'tʃ',  # cheese  CH IY Z
    'D' : 'd',   # dee     D IY
    'DH': 'ð',   # thee    DH IY
    'EH': 'ɛ',   # Ed      EH D
    'ER': 'ɝ',   # hurt    HH ER T
    'EY': 'eɪ',  # ate     EY T
    'F' : 'f',   # fee     F IY
    'G' : 'ɡ',   # green   G R IY N
    'HH': 'h',   # he      HH IY
    'IH': 'ɪ',   # it      IH T
    'IY': 'i',   # eat     IY T
    'JH': 'dʒ',  # gee     JH IY
    'K' : 'k',   # key     K IY
    'L' : 'l',   # lee     L IY
    'M' : 'm',   # me      M IY
    'N' : 'n',   # knee    N IY
    'NG': 'ŋ',   # ping    P IH NG
    'OW': 'oʊ',  # oat     OW T
    'OY': 'ɔɪ',  # toy     T OY
    'P' : 'p',   # pee     P IY
    'R' : 'ɹ',   # read    R IY D
    'S' : 's',   # sea     S IY
    'SH': 'ʃ',   # she     SH IY
    'T' : 't',   # tea     T IY
    'TH': 'θ',   # theta   TH EY T AH
    'UH': 'ʊ',   # hood    HH UH D
    'UW': 'u',   # two     T UW
    'V' : 'v',   # vee     V IY
    'W' : 'w',   # we      W IY
    'Y' : 'j',   # yield   Y IY L D
    'Z' : 'z',   # zee     Z IY
    'ZH': 'ʒ',   # seizure S IY ZH ER
}

for line in fileinput.input():
    counts, word, *arpas = line.split()
    ipas = [correspondences[arpa] for arpa in arpas]
    print(' '.join([counts, word] + ipas))
