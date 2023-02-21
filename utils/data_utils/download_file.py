"""
Script to download file from url.

Usage:
    python download_file.py --url <url> --save_dir <save_dir>
"""

import os
import sys
import requests
import argparse

WIKIART2_URL = "https://archive.org/download/wikiart-stylegan2-conditional-model/network-snapshot-012052.pkl"

def download_file(url, save_dir):
    """
    Download a file from url to file_path.
    """
    if not os.path.exists(save_dir):
        os.makedirs(save_dir)

    file_name = url.split('/')[-1]
    file_path = os.path.join(save_dir, file_name)

    if os.path.exists(file_path):
        print(f"File {file_path} already exists.")
        return

    print(f"Downloading {file_name} to {file_path}...")
    response = requests.get(url, stream=True)
    with open(file_path, 'wb') as f:
        for chunk in response.iter_content(chunk_size=1024):
            if chunk:
                f.write(chunk)


def main():
    """
    Main function.
    """
    parser = argparse.ArgumentParser()
    parser.add_argument("--url", type=str, default=WIKIART2_URL, help="URL of the file to download.")
    parser.add_argument("--save_dir", type=str, default='downloads', help="Path to save the downloaded file.")
    args = parser.parse_args()
    download_file(args.url, args.save_dir)

if __name__ == "__main__":
    main()



    






