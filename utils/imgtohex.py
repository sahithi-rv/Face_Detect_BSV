from PIL import Image
import numpy as np
import sys
image1 = sys.argv[1];
fileout = sys.argv[2];

img1 = Image.open(image1).convert('L');

arr1 = np.asarray(img1, dtype = np.int32);
R = arr1.shape[0]
C = arr1.shape[1]
out = [];


fd = open(fileout,'w')
out1=[]
for i in range(0,R):
 #   print >> fd, "{",	
    out1 = []
    for j in range(0,C):
		num = arr1[i][j]
		#k = format(num if num >= 0 else (1 << bits) + num, '032b')
		k = hex(num);
    #            print >> fd, i,
    #            print >> fd, ", ",
                out1.append(k)
    out.append(out1)
#    print >> fd, "}"	
#print >> fd, "}"	


print >> fd, "{"	
for i in range(R):
    print >> fd, "{",	
    for j in range(C):
	print >> fd, out[i][j],",",
    print >> fd, "},"
print >> fd,"}"
