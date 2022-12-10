#!/bin/bash

# create data folder
mkdir -p pose/data/deepslam_data
cd pose/data/deepslam_data
ln -s pose/data/deepslam_data/ Env

# create trained folder
cd ~/pose/trained/rosbag2file
sudo ./sync_position_with_image.sh

# start training
cd ~/pose/trained
python3 dataset_mean.py & \
python3 train.py --reduce 2 & \
python3 train.py