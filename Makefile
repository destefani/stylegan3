dataset:
	docker run --gpus all -it --rm --user $(id -u):$(id -g) \
		-v `pwd`:/scratch --workdir /scratch -e HOME=/scratch \
		stylegan3 \
		python dataset_tool.py --source datasets/jpeg --dest datasets/muros.zip --resolution 1024x1024

train:
	docker run --gpus all -it --rm --user $(id -u):$(id -g) \
		-v `pwd`:/scratch --workdir /scratch -e HOME=/scratch --shm-size 50G\
		stylegan3 \
		python train.py --outdir=results --cfg=stylegan2 --data=datasets/prints.zip \
			--gpus=2 --batch=32 --batch-gpu=4 --gamma=32 --mirror=True --snap=1 --metrics=None

resume:
	docker run --gpus all -it --rm --user $(id -u):$(id -g) \
		-v `pwd`:/scratch --workdir /scratch -e HOME=/scratch --shm-size 50G\
		stylegan3 \
		python train.py --outdir=results --cfg=stylegan2 --data=datasets/prints.zip \
			--gpus=2 --batch=32 --batch-gpu=4 --gamma=32 --mirror=1 --snap=1 --metrics=None --resume=latest

build-docker:
	sudo usermod -aG docker $USER
	newgrp docker
	docker build --tag stylegan3 .


wiki2:
	docker run --gpus all -it --rm --user $(id -u):$(id -g) \
		-v `pwd`:/scratch --workdir /scratch -e HOME=/scratch --shm-size 50G\
		stylegan3 \
		python train.py --outdir=./results/wiki2 --cfg=stylegan2 --data=datasets/muros.zip \
			--gpus=1 --batch=32 --batch-gpu=4 --gamma=32 --mirror=True --snap=10 --metrics=None --resume=pretrained/wikiart.pkl

resume-wiki:
	docker run --gpus all -it --rm --user $(id -u):$(id -g) \
		-v `pwd`:/scratch --workdir /scratch -e HOME=/scratch --shm-size 50G\
		stylegan3 \
		python train.py --outdir=./results/wiki2  --cfg=stylegan2 --data=datasets/muros.zip \
			--gpus=1 --batch=36 --batch-gpu=12 --gamma=32 --mirror=False --snap=20 --metrics=None --resume=latest 

video:
	docker run --gpus all -it --rm --user $(id -u):$(id -g) \
		-v `pwd`:/scratch --workdir /scratch -e HOME=/scratch --shm-size 50G\
		stylegan3 \
		python gen_video.py --output=videos/t1_s0-31_pkl92.mp4 --trunc=1 --seeds=0-31 --w-frames=360 \
			--network=results/wiki2/00001-stylegan2-prints-gpus2-batch32-gamma32/network-snapshot-000208.pkl


download-wikiart:
	gdown --id 1-5xZkD8ajXw1DdopTkH_rAoCsD72LhKU -O pretrained/wikiart.pkl


# setup
# 1. copy images
# 2. download pretrained weights
# 3 build docker
# 4. trian
