#!/usr/bin/env bash
set -e

BATCH=32
HOSTS="hosts"

usage() {
    echo $1
    echo
	echo "Usage: ./run_exp.sh [-b <batch_size>]
	            [-h <path to hosts file>]
	            -m (resnet|incep|vgg|sockeye)"
	exit 1
}

while [[ $# -gt 0 ]]
do
	key="$1"
	
	case $key in
	-m|--model)
	    MODEL="$2"
	    shift # past argument
	    shift # past value
	    ;;
	-b|--batch)
	    BATCH="$2"
	    shift # past argument
	    shift # past value
	    ;;
	-h|--hosts)
	    HOSTS="$2"
	    shift # past argument
	    shift # past value
	    ;;
	*)  # unknown option
        usage
	    ;;
	esac
done

if [ ! -f $HOSTS ]; then
    usage "hosts file not found"
fi

N=$(wc -l $HOSTS|awk '{print $1}')
echo "Launching training on $N machine(s)"

case $MODEL in
resnet)
    python3 tools/launch.py -n ${N} -H $HOSTS python3 example/image-classification/train_imagenet.py --gpus 0 --network resnet --num-layers 50 --batch-size $BATCH --image-shape 3,224,224 --num-epochs 1 --kv-store dist_device_sync --data-train imagenet1k_train.rec --data-val imagenet1k_val.rec
    ;;
incep)
    python3 tools/launch.py -n ${N} -H $HOSTS python3 example/image-classification/train_imagenet.py --gpus 0 --network inception-v3 --batch-size $BATCH --image-shape 3,299,299 --num-epochs 1 --kv-store dist_device_sync --data-train imagenet1k_train.rec --data-val imagenet1k_val.rec
    ;;
vgg)
    python3 tools/launch.py -n ${N} -H $HOSTS python3 example/image-classification/train_imagenet.py --gpus 0 --network vgg --num-layers 19 --batch-size $BATCH --image-shape 3,224,224 --num-epochs 1 --kv-store dist_device_sync --data-train imagenet1k_train.rec --data-val imagenet1k_val.rec
    ;;
sockeye)
    cd example/sockeye/source
    python3 ../../../tools/launch.py -n ${N} -H ../../../$HOSTS python3 -m sockeye.train --source ../dataset/iwslt15_en-vi/train-preproc.en --target ../dataset/iwslt15_en-vi/train-preproc.vi --validation-source ../dataset/iwslt15_en-vi/tst2012.en --validation-target ../dataset/iwslt15_en-vi/tst2012.vi --source-vocab ../dataset/iwslt15_en-vi/vocab.en --target-vocab ../dataset/iwslt15_en-vi/vocab.vi --output ../models/sockeye_1.5-iwslt15_en-vi.sh --overwrite-output --encoder rnn --decoder rnn --num-layers 2:2 --rnn-cell-type lstm --rnn-num-hidden 512 --rnn-encoder-reverse-input --num-embed 512:512 --attention-type mlp --attention-num-hidden 512 --batch-size $BATCH --bucket-width 10 --metrics perplexity --optimized-metric bleu --checkpoint-frequency 10000000000 --max-num-checkpoint-not-improved -1 --weight-init uniform --weight-init-scale 0.1 --learning-rate-reduce-factor 1.0 --monitor-bleu -1 --kv-store dist_device_sync
    ;;
*)
    usage
    ;;
esac
