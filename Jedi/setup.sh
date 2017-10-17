sudo apt update
sudo apt install build-essential
sudo apt-get install cmake
sudo apt-get install libgtk2.0-dev
cd /var/OCV
tar -xvzf opencv-3.3.0.tar.gz
cd opencv-3.3.0
mkdir build && cd build
mkdir -p /usr/local
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..
make
sudo make install
