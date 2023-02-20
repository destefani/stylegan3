"""
Script to convert RAW images to JPEG.

Usage:
    python convert_images.py --input_dir <input_dir> --output_dir <output_dir> --ext <ext>
"""
# TODO: Dockerize this script.

import os
import sys
import argparse
import glob
import cv2
from tqdm import tqdm

def convert_images(input_dir, output_dir, ext):
    """Convert RAW images to JPEG."""
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    files = glob.glob(os.path.join(input_dir, '*.' + ext))
    for f in tqdm(files):
        img = cv2.imread(f)
        cv2.imwrite(os.path.join(output_dir, os.path.basename(f).split('.')[0] + '.jpg'), img)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Convert RAW images to JPEG.')
    parser.add_argument('--input_dir', type=str, help='Input directory.')
    parser.add_argument('--output_dir', type=str, help='Output directory.')
    parser.add_argument('--ext', type=str, default='raw', help='Extension of the input images.')
    args = parser.parse_args()

    convert_images(args.input_dir, args.output_dir, args.ext)