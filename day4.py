def get_input():
    with open('data.txt', 'r') as f:
        return f.read().split('\n')


lines = get_input()

data = []

for line in lines:
    a, b = line.split(": ")
    l1, l2 = b.split(" | ")
    l1 = [int(x) for x in l1.split(" ") if x]
    l2 = [int(x) for x in l2.split(" ") if x]
    s1 = set(l1)
    data.append((s1, l2))

counts = [1] * len(lines)
anss = [0] * len(lines)

# Part 2, Part 1 was lost
for i, line in enumerate(lines):
    s1, l2 = data[i]
    c = 0
    for x in l2:
        if x in s1:
            c += 1
    anss[i] = c
    for j in range(i + 1, min(len(lines), i + c + 1)):
        counts[j] += counts[i]

ans = sum(counts)

print(ans)
