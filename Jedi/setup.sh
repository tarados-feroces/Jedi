#!/bin/bash


red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
cian='\033[0;36m'
white='\e[0m'


packages=(
		ant
	build-essential 
	cmake 
	default-jdk 
	ffmpeg
	gfortran
	git
	gstreamer0.10-ffmpeg
	gstreamer0.10-plugins-bad 
	gstreamer0.10-plugins-base 
	gstreamer0.10-plugins-good 
	gstreamer0.10-plugins-ugly 
	gstreamer0.10-tools 
	libatlas-base-dev 
	libavcodec-dev 
	libavfilter-dev 
	libavformat-dev 
	libavresample-dev
	libavutil-dev 
	libdc1394-22 
	libdc1394-22-dev 
	libeigen3-dev 
	libfaac-dev 
	libgstreamer0.10-0 
	libgstreamer0.10-dev 
	libgstreamer1.0-dev 
	libgstreamer-plugins-base0.10-dev  
	libgstreamer-plugins-base1.0-dev 
	libgtk2.0-dev
	libgtk-3-dev
	libjasper-dev 
	libjpeg8-dev
	libjpeg-dev
	libmp3lame-dev 
	libopencore-amrnb-dev 
	libopencv-dev 
	libopenexr-dev
	libpng12-dev 
	libpng-dev 
	libswscale-dev
	libtbb2 
	libtbb-dev
	libtheora-dev 
	libtiff5-dev 
	libv4l-dev 
	libvorbis-dev 
	libx264-dev 
	libxine2-dev 
	libxvidcore-dev 
	pkg-config 
	python3.5-dev 
	python3-dev
	python3-numpy
	python-dev 
 	python-matplotlib
	python-nose
	python-numpy
	python-pandas 
	python-scipy
	python-sympy
	sphinx-common 
	unzip
	v4l-utils 
	yasm
)



if [[ "$1" = "--full" ]]; then
	
	report="Report.log"
	sudo apt-get -y update > $report
    sudo apt-get -y upgrade >> $report 

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
	"CMAKE_INSTALL_PREFIX=/usr/local"
	"BUILD_TIFF=ON"
	"WITH_CUDA=OFF"
	"ENABLE_AVX=OFF"
	"WITH_OPENGL=OFF"
	"WITH_OPENCL=OFF"
	"WITH_IPP=OFF"
	"WITH_TBB=ON"
	"BUILD_TBB=ON"
	"WITH_EIGEN=OFF" 
	"WITH_V4L=OFF"
	"WITH_VTK=OFF"
	"BUILD_TESTS=OFF"
	"BUILD_PERF_TESTS=OFF"
	"OPENCV_EXTRA_MODULES_PATH=/opencv/opencv_contrib/modules" 
)

cmake_command="sudo cmake "

for flag in "${flags[@]}"
do
	cmake_command="${cmake_command} -D ${flag}"
done

cmake_command="${cmake_command} /opencv/opencv/"

[[ ! -d /opencv ]] && sudo mkdir /opencv
cd /opencv

sudo git clone https://github.com/Itseez/opencv.git
sudo git clone https://github.com/Itseez/opencv_contrib.git

cd /opencv
sudo mkdir release
cd release

echo "CMAKE command : $cmake_command"

eval "$cmake_command"


sudo make --jobs=10
sudo make install
sudo ldconfig
