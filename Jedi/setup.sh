#!/bin/bash


red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
cian='\033[0;36m'
white='\e[0m'


packages=(
	build-essential 
	cmake 
	pkg-config 
	unzip
	git
	libgtk2.0-dev

	libjpeg-dev libpng-dev libtiff5-dev libjasper-dev libdc1394-22-dev libeigen3-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev sphinx-common libtbb-dev yasm libfaac-dev libopencore-amrnb-dev libopencore-amrwb-dev libopenexr-dev libgstreamer-plugins-base1.0-dev libavutil-dev libavfilter-dev libavresample-dev

	libgstreamer0.10-0 
	libgstreamer0.10-dev 
	gstreamer0.10-tools 
	gstreamer0.10-plugins-base 
	libgstreamer-plugins-base0.10-dev 
	gstreamer0.10-plugins-good 
	gstreamer0.10-plugins-ugly 
	gstreamer0.10-plugins-bad 
	gstreamer0.10-ffmpeg

	python-numpy
 	python-matplotlib
	python-pandas 
	python-sympy
	python-nose
	python-scipy
       
	pkg-config 
	unzip 
	ffmpeg

	python-dev 
	python3-dev
	python3.5-dev 
	python-numpy 
	python3-numpy

	libtbb2 
	libtbb-dev

	libopencv-dev 
	libgtk-3-dev 
	libdc1394-22 
	libdc1394-22-dev 
	libjpeg-dev 
	libpng12-dev 

	libavcodec-dev 
	libavformat-dev 
	libswscale-dev
	libxine2-dev 
	
	
	libv4l-dev 
	libtbb-dev 
	libfaac-dev 
	libmp3lame-dev 
	libtheora-dev 


	libvorbis-dev 
	libxvidcore-dev 
	v4l-utils 
	libopencore-amrnb-dev 
	libopencore-amrwb-dev

	libjasper-dev 
	

	libjpeg8-dev
	libx264-dev 
	libatlas-base-dev 
	gfortran

	default-jdk 
	ant

)


report="Report.log"


 sudo apt-get -y update > $report
 sudo apt-get -y upgrade >> $report 

if [[ "$1" = "--full" ]]; then
for pckg in ${packages[@]}
do
	echo "installing package $pckg"
	echo "installing package $pckg" >> $report

	sudo apt-get install -y $pckg >> $report 

	echo "" >> $report 
	echo "" >> $report 
	echo "" >> $report 

done

fi

echo -e "${green} All packages should be installed${white}"

flags=(
	"CMAKE_BUILD_TYPE=RELEASE"
	"INSTALL_C_EXAMPLES=ON"
	"INSTALL_PYTHON_EXAMPLES=ON"
	"BUILD_EXAMPLES=ON"
	#"WITH_QT=ON"
	"CMAKE_INSTALL_PREFIX=/usr/local"
	"WITH_OPENGL=ON"
	"WITH_V4L=ON"
	"WITH_CUDA=ON"
	"BUILD_NEW_PYTHON_SUPPORT=ON"
	"WITH_TBB=ON"
)

cmake_command="cmake "

for flag in "${flags[@]}"
do
	cmake_command="${cmake_command} -D ${flag}"
done

cmake_command="${cmake_command} .."

cd /dev
sudo git clone https://github.com/Itseez/opencv.git
sudo git clone https://github.com/Itseez/opencv_contrib.git
cd opencv
sudo mkdir release
cd release
sudo cmake -D BUILD_TIFF=ON -D WITH_CUDA=OFF -D ENABLE_AVX=OFF -D WITH_OPENGL=OFF -D WITH_OPENCL=OFF -D WITH_IPP=OFF -D WITH_TBB=ON -D BUILD_TBB=ON -D WITH_EIGEN=OFF -D WITH_V4L=OFF -D WITH_VTK=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_EXTRA_MODULES_PATH=/dev/opencv_contrib/modules /dev/opencv/
sudo make --jobs=10
sudo make install
sudo ldconfig
