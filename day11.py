import sys


def get_input():
    with open('data.txt', 'r') as f:
        return f.read().split('\n')


lines = get_input()

no_hash_cols = set()
no_hash_rows = set()
for i, line in enumerate(lines):
    if '#' not in line:
        no_hash_rows.add(i)

for i in range(len(lines[0])):
    if '#' not in [line[i] for line in lines]:
        no_hash_cols.add(i)


grid_hash_locs = []
for i, line in enumerate(lines):
    for j, char in enumerate(line):
        if char == '#':
            grid_hash_locs.append((i, j))

# Part 1: FACTOR = 2
FACTOR = 1_000_000
s = 0
for i in range(len(grid_hash_locs)):
    for j in range(i+1, len(grid_hash_locs)):
        x1, y1 = grid_hash_locs[i]
        x2, y2 = grid_hash_locs[j]
        # number of no-hash rows between the two points
        n = 0
        for k in range(min(y1, y2), max(y1, y2)):
            if k in no_hash_cols:
                n += 1
        # number of no-hash cols between the two points
        m = 0
        for k in range(min(x1, x2), max(x1, x2)):
            if k in no_hash_rows:
                m += 1
        s += abs(y2 - y1) + (FACTOR - 1) * n + \
            abs(x2 - x1) + (FACTOR - 1) * m

print(s)
