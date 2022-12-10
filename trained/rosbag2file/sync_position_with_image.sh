#!/bin/bash

DEFAULT_FROM_FRAME_ID=map
DEFAULT_TO_FRAME_ID=base_footprint
DEFAULT_IMAGE_TOPIC=/usb_cam/image_color_rect
DEFAULT_ROSBAG=~/pose/trained/rosbag2file/"file.bag"
DEFAULT_OUTPUT_DIR=~/pose/trained/rosbag2file
DEFAULT_SEQUENCE_NAME="file"
DEFAULT_DATA_MODE=train

ROSBAG_RATE=1

echo "Extracting transform from ${from_frame_id} to ${to_frame_id}"
echo "Syncing the transform with ${image_topic}"

from_frame_id=${DEFAULT_FROM_FRAME_ID}
to_frame_id=${DEFAULT_TO_FRAME_ID}
image_topic=${DEFAULT_IMAGE_TOPIC}
rosbag=${DEFAULT_ROSBAG}
output_dir=${DEFAULT_OUTPUT_DIR}
sequence_name=${DEFAULT_SEQUENCE_NAME}

all_transforms_dir=${output_dir}/${sequence_name}/numpy
mkdir -p ${all_transforms_dir}

echo "Saving all extracted transformations in numpy file"
numpy_file=${all_transforms_dir}/poses.npy
python3 tf_extractor.py -f ${from_frame_id} -t ${to_frame_id} -o ${numpy_file} -v &

echo 'TF extraction node started!'
rosbag play -d 3 --clock -r ${ROSBAG_RATE} ${rosbag}

echo 'Finished extracting TF transforms'
kill -INT %1

echo 'Starting image extract and sync'
python3 extract_and_sync.py -m ${data_mode} -b ${rosbag} -a ${numpy_file} -t ${image_topic} ${output_dir}/${sequence_name}

sleep 10
echo 'Done'

