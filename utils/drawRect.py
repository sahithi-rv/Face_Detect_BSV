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
ly = [77, 74, 74, 74, 74, 74, 74, 74, 74, 75, 75, 75, 75, 75, 75, 76];
lx = [85, 78, 79, 80, 81, 134, 153, 154, 155, 78, 79, 80, 81, 106, 107, 106];
h = 25;
w = 25;

for x, y in zip(lx, ly):
	for i in range(w):
		Data[y-24][x-50+i] = 255;
	for i in range(h):
		Data[y-24+i][x-50+w] = 255;
	for i in range(w):
		Data[y-24+h][x-50+w-i] = 255;
	for i in range(h):
		Data[y-24+h-1][x-50] = 255;

result = Image.fromarray((Data).astype(np.uint8))
result.save(fileout2);
