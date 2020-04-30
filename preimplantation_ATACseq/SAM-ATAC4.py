#Usage: python SAM-ATAC.py min max SAM-INPUT-FILE SAM-OUTPUT-FILE
# -*- coding: utf-8 -*-
import sys


min = int(sys.argv[1])
max = int(sys.argv[2])
sam = open(sys.argv[3],'r')
out = open(sys.argv[4],'w')

for line in sam:
    if line.startswith('@'):
        #it was part of the header
        out.write(line)
        continue
    li = line.split('\t')
    if int(li[8]) == 0:
        continue

    if int(li[1]) & 16:
        #line mapped to - strand so subtract 5
        li[3] = str(int(li[3])-5)
        li[7] = str(int(li[7])+4)
    else:
        #line mapped to + strand so add 4
        li[3] = str(int(li[3]) + 4)
        li[7] = str(int(li[7]) - 5)
    if int(li[8]) < 0:
    	li[8] = str(int(li[8])+9)
    else:
    	li[8] = str(int(li[8])-9)
    	
    	
    	
    if abs(int(li[8])) < min or abs(int(li[8])) > max or li[2]=='chrM' :
    	continue
    
    newline = "\t".join(li)
    out.write(newline)
