#!/bin/bash
sleep 2
echo "



 __  __     __         __         ______     __   __  
/\ \_\ \   /\ \       /\ \       /\  ___\   /\ \ / /  
\ \  __ \  \ \ \____  \ \ \____  \ \ \____  \ \ \'/   
 \ \_\ \_\  \ \_____\  \ \_____\  \ \_____\  \ \__|   
  \/_/\/_/   \/_____/   \/_____/   \/_____/   \/_/    
                                                      



"
sleep 3
echo "Please choose the opencv version you want to install(default version: $OpenCV_version) "
OpenCV_version=4.5.2
temp=$OpenCV_version
if [ ! $OpenCV_version ];
then
	OpenCV_version=$temp
fi

echo "The version of OpenCV to be installed:" $OpenCV_version
read -p "Enter OpenCV version or enter key 'Enter' to choose default version: " OpenCV_version

if [ ! -e "/etc/apt/sources.list.old" ];
then
	codeName=$(echo `lsb_release -c` | cut -d " " -f 2)
	imageSourcePath="/etc/apt/sources.list"

	sudo cp /etc/apt/sources.list /etc/apt/sources.list.old

	echo "# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释" | sudo tee $imageSourcePath
	echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $codeName main restricted universe multiverse" | sudo tee -a $imageSourcePath
	echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $codeName main restricted universe multiverse" | sudo tee -a $imageSourcePath
	echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $codeName-updates main restricted universe multiverse" | sudo tee -a $imageSourcePath
	echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $codeName-updates main restricted universe multiverse" | sudo tee -a $imageSourcePath
	echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $codeName-backports main restricted universe multiverse" | sudo tee -a $imageSourcePath
	echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $codeName-backports main restricted universe multiverse" | sudo tee -a $imageSourcePath
	echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $codeName-security main restricted universe multiverse" | sudo tee -a $imageSourcePath
	echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $codeName-security main restricted universe multiverse" | sudo tee -a $imageSourcePath
	echo | sudo tee -a $imageSourcePath
	echo "# 预发布软件源，不建议启用" | sudo tee -a $imageSourcePath
	echo "# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $codeName-proposed main restricted universe multiverse" | sudo tee -a $imageSourcePath
	echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $codeName-proposed main restricted universe multiverse" | sudo tee -a $imageSourcePath
fi

add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
apt update
apt install libjasper1 libjasper-dev -y
apt-get install build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev -y
apt-get install libjpeg-dev libpng-dev libtiff5-dev libjasper-dev libdc1394-22-dev libeigen3-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev sphinx-common libtbb-dev yasm libfaac-dev libopencore-amrnb-dev libopencore-amrwb-dev libopenexr-dev libgstreamer-plugins-base1.0-dev libavutil-dev libavfilter-dev libavresample-dev -y

cd /opt
git clone https://gitee.com/wangzihang_02/opencv.git
cd opencv
git checkout $OpenCV_version
cd ..
git clone https://gitee.com/wangzihang_02/opencv_contrib.git
cd opencv_contrib
git checkout $OpenCV_version
cd ..
git clone https://gitee.com/wangzihang_02/OpenCV-xfeatures2d.git
mv OpenCV-xfeatures2d/* opencv_contrib/modules/xfeatures2d/src

cd opencv
mkdir release
cd release
cmake -D BUILD_TIFF=ON -D WITH_CUDA=OFF -D ENABLE_AVX=OFF -D WITH_OPENGL=OFF -D WITH_OPENCL=OFF -D WITH_IPP=OFF -D WITH_TBB=ON -D BUILD_TBB=ON -D WITH_EIGEN=OFF -D WITH_V4L=OFF -D WITH_VTK=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules /opt/opencv/
make -j4
make install 
ldconfig
cd ~

