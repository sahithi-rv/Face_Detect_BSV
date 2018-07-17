# python filetohex.py  <input_file> output_

import numpy as np
import sys

filein = sys.argv[1];
fileout = sys.argv[2];
R = int(sys.argv[3]);
C = int(sys.argv[4]);
l = []
out = []
with open(filein,'r') as f:
	s = f.readline();

l = s.split(',');
a = np.array(l).reshape(R,C)

out1=[]
for i in range(0,R):
    out1 = []
    for j in range(0,C):
        num = int(a[i][j])
        k = hex(num);
        out1.append(k)
    out.append(out1)


fd = open(fileout,'w')
print >> fd, "{"
for i in range(R):
    print >> fd, "{",
    for j in range(C):
        if j == (C-1):
            print >> fd, out[i][j],
        else:
            print >> fd, out[i][j], ",",
    print >> fd, "},"
print >> fd,"}"
