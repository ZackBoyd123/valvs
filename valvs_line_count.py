import sys
with open(sys.argv[1], "r") as f:
    count = 0
    for i in f:
        count += 1
    f.close()
print(count / 4)
