#!/usr/bin/env python3

cmudict = {}

with open('./cmudict_processed') as cmudict_file:
    for line in cmudict_file:
        word, *phonemes = line.split()
        cmudict[word.lower()] = phonemes

with open('./kilgarriff_processed') as kilgarriff_file:
    with open('./correlated_arpa', 'w') as correlated:
        with open('./uncorrelated', 'w') as uncorrelated:
            for line in kilgarriff_file:
                count_str, word = line.split()
                if word in cmudict:
                    items = [count_str, word] + cmudict[word]
                    correlated.write(' '.join(items) + '\n')
                else:
                    uncorrelated.write(count_str + ' ' + word + '\n')  # can i just write `line`? does it incl. '\n'?
