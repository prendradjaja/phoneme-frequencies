#!/usr/bin/env python3

import fileinput

for line in fileinput.input():
    count, word, *phonemes = line.split()
    transcription = ''.join(phonemes)
    print(count, word, transcription)
