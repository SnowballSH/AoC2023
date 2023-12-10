import sys
sys.setrecursionlimit(1000000)


def get_input():
    with open('data.txt', 'r') as f:
        return f.read().split('\n')


lines = get_input()

start = None
for i, row in enumerate(lines):
    for j, col in enumerate(row):
        if col == 'S':
            start = (i, j)
            break
    if start is not None:
        break

new_map = [['.'] * (len(lines[0])*2) for _ in range(len(lines)*2)]

cnt = 0
cur = start
prev = start
new_map[cur[0]*2][cur[1]*2] = '#'
for (x, y) in [(1, 0), (0, -1), (-1, 0), (0, 1)]:
    new = (cur[0] + x, cur[1] + y)
    if lines[new[0]][new[1]] != '.':
        new_map[cur[0]*2 + x][cur[1]*2 + y] = '#'
        cur = new
        cnt += 1
        break
while cur != start:
    new_map[cur[0]*2][cur[1]*2] = '#'
    old_cur = cur
    if lines[cur[0]][cur[1]] == '|':
        if prev[0] == cur[0] - 1:
            new_map[cur[0]*2 - 1][cur[1]*2] = '#'
            cur = (cur[0] + 1, cur[1])
        elif prev[0] == cur[0] + 1:
            new_map[cur[0]*2 + 1][cur[1]*2] = '#'
            cur = (cur[0] - 1, cur[1])
    elif lines[cur[0]][cur[1]] == '-':
        if prev[1] == cur[1] - 1:
            new_map[cur[0]*2][cur[1]*2 - 1] = '#'
            cur = (cur[0], cur[1] + 1)
        elif prev[1] == cur[1] + 1:
            new_map[cur[0]*2][cur[1]*2 + 1] = '#'
            cur = (cur[0], cur[1] - 1)
    elif lines[cur[0]][cur[1]] == 'L':
        if prev[0] == cur[0] - 1:
            new_map[cur[0]*2 - 1][cur[1]*2] = '#'
            cur = (cur[0], cur[1] + 1)
        elif prev[1] == cur[1] + 1:
            new_map[cur[0]*2][cur[1]*2 + 1] = '#'
            cur = (cur[0] - 1, cur[1])
    elif lines[cur[0]][cur[1]] == 'F':
        if prev[0] == cur[0] + 1:
            new_map[cur[0]*2 + 1][cur[1]*2] = '#'
            cur = (cur[0], cur[1] + 1)
        elif prev[1] == cur[1] + 1:
            new_map[cur[0]*2][cur[1]*2 + 1] = '#'
            cur = (cur[0] + 1, cur[1])
    elif lines[cur[0]][cur[1]] == '7':
        if prev[0] == cur[0] + 1:
            new_map[cur[0]*2 + 1][cur[1]*2] = '#'
            cur = (cur[0], cur[1] - 1)
        elif prev[1] == cur[1] - 1:
            new_map[cur[0]*2][cur[1]*2 - 1] = '#'
            cur = (cur[0] + 1, cur[1])
    elif lines[cur[0]][cur[1]] == 'J':
        if prev[0] == cur[0] - 1:
            new_map[cur[0]*2 - 1][cur[1]*2] = '#'
            cur = (cur[0], cur[1] - 1)
        elif prev[1] == cur[1] - 1:
            new_map[cur[0]*2][cur[1]*2 - 1] = '#'
            cur = (cur[0] - 1, cur[1])
    prev = old_cur
    cnt += 1

new_map[(prev[0] + cur[0])][(prev[1] + cur[1])] = '#'

# Part 1
print(cnt // 2)

visited = set()
components = 0
component_count = []


def floodfill(x, y, cnt):
    if x < 0 or x >= len(new_map) or y < 0 or y >= len(new_map[0]):
        return False
    if new_map[x][y] == '#':
        return True
    if (x, y) in visited:
        return True
    visited.add((x, y))
    if x % 2 == 0 and y % 2 == 0:
        component_count[cnt] += 1
    res = True
    for (i, j) in [(1, 0), (0, -1), (-1, 0), (0, 1)]:
        if not floodfill(x + i, y + j, cnt):
            res = False
    return res


res = 0

for i in range(len(new_map)):
    for j in range(len(new_map[0])):
        if i % 2 != 0 or j % 2 != 0:
            continue
        if new_map[i][j] == '.' and (i*2, j*2) not in visited:
            components += 1
            component_count.append(0)
            r = floodfill(i, j, components - 1)
            if r:
                res += component_count[components - 1]

# Part 2
print(res)
