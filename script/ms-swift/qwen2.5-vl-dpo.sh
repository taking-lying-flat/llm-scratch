# 4 * 50GiB
# You can refer to `https://github.com/QwenLM/Qwen2.5-VL` for the meaning of the `MAX_PIXELS` parameter.
# --rlhf_type cpo/orpo/simpo/rm are also supported

#!/usr/bin/env bash
set -euo pipefail

nproc_per_node=2
export CUDA_VISIBLE_DEVICES=0,1
export NPROC_PER_NODE=$nproc_per_node
export MAX_PIXELS=1003520

OUTDIR="output"
mkdir -p "${OUTDIR}"

LOG="${OUTDIR}/rlhf_dpo_$(date +%Y%m%d_%H%M%S).log"

nohup bash -c '
swift rlhf \
    --rlhf_type dpo \
    --model Qwen/Qwen2.5-VL-7B-Instruct \
    --dataset "swift/RLAIF-V-Dataset#20000" \
    --load_from_cache_file true \
    --split_dataset_ratio 0.01 \
    --train_type lora \
    --torch_dtype bfloat16 \
    --num_train_epochs 1 \
    --per_device_train_batch_size 1 \
    --per_device_eval_batch_size 1 \
    --learning_rate 1e-4 \
    --lora_rank 8 \
    --lora_alpha 32 \
    --target_modules all-linear \
    --freeze_vit true \
    --gradient_accumulation_steps $(expr 16 / '"$nproc_per_node"') \
    --eval_steps 100 \
    --save_steps 100 \
    --save_total_limit 2 \
    --deepspeed zero2 \
    --logging_steps 5 \
    --max_length 4096 \
    --output_dir "'"${OUTDIR}"'" \
    --warmup_ratio 0.05 \
    --dataloader_num_workers 4 \
    --rpo_alpha 0.1 \
    --dataset_num_proc 4
' 2>&1 | tee -a "${LOG}" &

echo "Started. PID=$!"
echo "Log: ${LOG}"
