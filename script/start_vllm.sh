#!/bin/bash

MODEL_PATH="Qwen2.5-VL-72B-Instruct"

CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 \
python -m vllm.entrypoints.openai.api_server \
  --model "$MODEL_PATH" \
  --host 0.0.0.0 \
  --port 8000 \
  --trust-remote-code \
  --max-model-len 4096 \
  --tensor-parallel-size 8 \
  --gpu-memory-utilization 0.75 \
  --dtype bfloat16 \
  --max-num-seqs 32 \
  --disable-log-requests \
  --served-model-name qwen2.5-vl-72b-instruct \
