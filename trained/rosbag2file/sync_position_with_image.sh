#!/bin/bash

DEFAULT_FROM_FRAME_ID=map
DEFAULT_TO_FRAME_ID=base_footprint
DEFAULT_IMAGE_TOPIC=/kinect2/qhd/image_color_rect
DEFAULT_ROSBAG=~/rosbag2file/2019-03-20-15-00-00.bag
DEFAULT_OUTPUT_DIR=~/rosbag2file
DEFAULT_SEQUENCE_NAME=2019-03-20-15-00-00
DEFAULT_DATA_MODE=train

ROSBAG_RATE=1

from_frame_id=${DEFAULT_FROM_FRAME_ID}
to_frame_id=${DEFAULT_TO_FRAME_ID}
image_topic=${DEFAULT_IMAGE_TOPIC}
rosbag=${DEFAULT_ROSBAG}
output_dir=${DEFAULT_OUTPUT_DIR}
sequence_name=${DEFAULT_SEQUENCE_NAME}

all_transforms_dir=${output_dir}/${sequence_name}/numpy
mkdir -p ${all_transforms_dir}

numpy_file=${all_transforms_dir}/poses.npy
python3 tf_extractor.py -f ${from_frame_id} -t ${to_frame_id} -o ${numpy_file} -v &

rosbag play -d 3 --clock -r ${ROSBAG_RATE} ${rosbag}

kill -INT %1

python3 extract_and_sync.py -m ${data_mode} -b ${rosbag} -a ${numpy_file} -t ${image_topic} ${output_dir}/${sequence_name}

sleep 10

