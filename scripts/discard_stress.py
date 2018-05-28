#!/usr/bin/env python3

import fileinput

for line in fileinput.input():
    parts = line.split()
    for i, p in enumerate(parts):
        if p[-1] in '012':
            parts[i] = p[:-1]
    parts[0] += ' '
    print(' '.join(parts))
