# This Makefile can be used from each of the Part subdirectories
# For example:    'make s1'
INCL=/opt/Xilinx/Vivado_HLS/2016.3/include/
LINK=-Wl,-lopencv_shape,-lopencv_stitching,-lopencv_superres,-lopencv_videostab,-lopencv_aruco,-lopencv_bgsegm,-lopencv_bioinspired,-lopencv_ccalib,-lopencv_cvv,-lopencv_dnn,-lopencv_dpm,-lopencv_fuzzy,-lopencv_hdf,-lopencv_line_descriptor,-lopencv_optflow,-lopencv_plot,-lopencv_reg,-lopencv_saliency,-lopencv_stereo,-lopencv_structured_light,-lopencv_rgbd,-lopencv_surface_matching,-lopencv_tracking,-lopencv_datasets,-lopencv_text,-lopencv_face,-lopencv_video,-lopencv_ximgproc,-lopencv_calib3d,-lopencv_features2d,-lopencv_flann,-lopencv_xobjdetect,-lopencv_objdetect,-lopencv_ml,-lopencv_xphoto,-lopencv_highgui,-lopencv_videoio,-lopencv_imgcodecs,-lopencv_photo,-lopencv_imgproc,-lopencv_core
BSC=bsc

# ----------------------------------------------------------------
# Bluesim targets

.PHONY: vj

#vj:  
#	$(BSC)  -sim  -u -g  mkVJmain  -show-schedule -cpp  vj_main.bsv
#	$(BSC) -Xc++ -I$(INCL) -sim  -e  mkVJmain  -o vj  *.ba image-utilities.cpp
trial: TrialFixedPoint.bsv
	@echo "Compiling into verilog files"
	bsc -verilog -u TrialFixedPoint.bsv
	@echo "Generting the simulation object"
	bsc -verilog -e mkTrialFixedPoint -o TrialFixedPoint.bsim

sqrt: sqrt.bsv
	@echo "Compiling into verilog files"
	bsc -verilog -u sqrt.bsv
	@echo "Generting the simulation object"
	bsc -verilog -e mkSqrt -o sqrt.bsim


bf: 
	@echo "Compiling into verilog files"
	bsc -verilog -u tb.bsv
	@echo "Generting the simulation object"
	bsc -verilog -e mkTb -o tb.bsim


vj_pipe: 
	@echo "Compiling into verilog files"
	bsc -verilog -u vj_pipe_tb.bsv +RTS -show-range-conflict -k0.1G -RTS
	@echo "Generting the simulation object"
	bsc -verilog -e mkVJpipeTb -o vj_pipe_tb.bsim +RTS -k0.1G -RTS 


	

# -----------------------------------------------------------------

.PHONY: clean fullclean

# Clean all intermediate files
clean:
	rm -f  *~  *.bi  *.bo  *.ba  *.h  *.cxx  *.o *.v 

# Clean all intermediate files, plus Verilog files, executables, schedule outputs
fullclean:
	rm -f  *~  *.bi  *.bo  *.ba  *.h  *.cxx  *.o *.bsim
	rm -f  *.exe   *.so  *.sched  *.v  *.vcd

