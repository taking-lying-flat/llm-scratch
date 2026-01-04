#!/bin/bash

# ╔══════════════════════════════════════╗
# ║  ⚙️  CPU 线程控制                    ║
# ╚══════════════════════════════════════╝
# 许多底层库如 MKL / OpenBLAS / oneDNN / 部分 C++ 扩展 会用 OpenMP 在 CPU 上开很多线程做矩阵运算、预处理、tokenizer、后处理
export OMP_NUM_THREADS=1




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
