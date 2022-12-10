FROM pytorch/pytorch:1.7.0-cuda11.0-cudnn8-devel

# Install basic apt packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y locales lsb-release
RUN dpkg-reconfigure locales

# Install ROS Noetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update \
 && apt-get install -y --no-install-recommends ros-noetic-desktop-full
RUN apt-get install -y --no-install-recommends python3-rosdep
RUN rosdep init \
 && rosdep fix-permissions \
 && rosdep update
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc

# Change the default shell to Bash
SHELL [ "/bin/bash" , "-c" ]

# Setup minimal
RUN apt-get update

RUN apt-get install -q -y --no-install-recommends \
  build-essential \
  apt-utils \
  cmake \
  g++ \
  git \
  libcanberra-gtk* \
  python3-catkin-tools \
  python3-pip \
  python3-tk \
  python3-yaml \
  python3-dev \
  python3-numpy \
  python3-rosinstall \
  python3-catkin-pkg \
  python3-rosdistro \
  python3-rospkg \
  wget \
  curl \
  Pillow

# Install dependencies
RUN apt-get update && apt-get install -y ros-noetic-ros-controllers \
  && apt-get install -y ros-noetic-cv-bridge \
  && apt-get install -y ros-noetic-vision-opencv \
  && apt-get install -y ros-geometry-msgs \
    && apt-get install -y ros-noetic-ros-control \