#!/usr/bin/python3
import sys
fileIn = sys.argv[1]
fileOut = sys.argv[2]

with open(fileIn) as f:
    lst = []
    for line in f:
            lst.append(line)
            if line.startswith("+"):
                break

sys.stdout = open(fileOut,"w")
print("".join(lst[:-1]).rstrip("\n").replace("@",">"))
