from PIL import Image
import numpy as np
import sys
image1 = sys.argv[1];
fileout2 = sys.argv[2];

img1 = Image.open(image1).convert('L');

arr1 = np.asarray(img1, dtype = np.int32);
R = arr1.shape[0]
C = arr1.shape[1]
Data = np.zeros((R,C), dtype = np.int32)

for i in range(R):
	for j in range(C):
		Data[i][j] = arr1[i][j];

y = 53;
x = 61;
h = 25;
w = 25;

for i in range(w):
	Data[y][x+i] = 255;
for i in range(h):
	Data[y+i][x+w] = 255;
for i in range(w):
	Data[y+h][x+w-i] = 255;
for i in range(h):
	Data[y+h-1][x] = 255;

result = Image.fromarray((Data).astype(np.uint8))
result.save(fileout2);
