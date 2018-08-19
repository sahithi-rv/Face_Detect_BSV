# VIOLA JONES FACE DETECTION IMPLEMENTATION USING BLUESPEC SYSTEM VERILOG

### Compile
make vj_pipe

### Execute
./vj_pipe_tb.bsim

### Hex Files

The hex_files/.hex files have the following set of data:

* 1 haar feature = 3 rectangles x 4 coordinates -- 12 rect files
* 1 threshold per haar feature -- 1 thresh file
* 3 weights for 3 rectangles of each haar feature -- 3 weight files
* 1 input image pixels file
* 2 files for banking - bank map, offset map 

### Test Bench

The test bench, src/vj_pipe_tb.bsv,
 * initializes the brams using initbram method
 * sends a pixel whenever the module is ready for input
 * receives the output, coordinates where the face is detected.


### Top Module

* initializes brams for a initial set of clock cycles.
* Follows the viola jones face detection algorithm to detect faces
* when a face is detected, the coordinates of the window are output.

### Results

Sample Input | Output
-------------|----------
![sample input](/utils/input.png) | ![output](/utils/output.png)

