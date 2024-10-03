FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y
RUN apt install -y --no-install-recommends
RUN apt install -y git make g++ libgsl-dev \
	build-essential \
	libcurl4-openssl-dev \
	libxml2-dev \
	software-properties-common \
	libreadline-dev \
	libpcre++-dev \
	libblas-dev \
	liblapack-dev \
	libatlas-base-dev \
	gfortran \
	liblzma-dev \
	libbz2-dev \
	locales \
	zlib1g-dev \
	xserver-xorg \
	xdm \
	xfonts-base \
	xfonts-100dpi \
	xfonts-75dpi \
	libqt5x11extras5
RUN apt-get -y install apt-transport-https
RUN export QT_DEBUG_PLUGINS=1
RUN export DISPLAY=0.0 
#RUN export QT_QPA_PLATFORM=offscreen
RUN apt clean
#RUN apt-get install '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev

# Locales
RUN locale-gen en_GB.UTF-8
ENV LANG=en_GB.UTF-8
ENV LANGUAGE=en_GB:en
ENV LC_ALL=en_GB.UTF-8

# Python 3.6
RUN add-apt-repository -y ppa:deadsnakes/ppa && \
	apt remove -y python3-apt && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		python3.6 python3.6-dev python3-pip python3-apt python3-tk \
		python3-setuptools \
		software-properties-common python3-software-properties && \
	rm /usr/bin/python3 && \
	ln -s /usr/bin/python3.6 /usr/bin/python3 && \
	ln -s /usr/lib/python3/dist-packages/apt_pkg.cpython-{35m,34m}-x86_64-linux-gnu.so /usr/lib/python3/dist-packages/apt_pkg.so

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

RUN apt-get install python3-distutils
RUN apt-get install python3-apt

RUN pip3 install --upgrade pip
RUN pip3 install wheel
RUN pip3 install numpy scipy docutils six pytest matplotlib lxml PyQt5 ete3

COPY . /app

WORKDIR /usr/src

RUN git clone https://github.com/zhangjiajie/PTP.git

WORKDIR /usr/src/PTP

RUN python3 setup.py install

WORKDIR /usr/src/PTP/bin

ENV PATH=${PATH}:/usr/src/PTP/bin
