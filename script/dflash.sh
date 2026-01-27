set -euo pipefail

python -m sglang.launch_server \
  --model-path Qwen/Qwen3-Coder-30B-A3B-Instruct \
  --speculative-algorithm DFLASH \
  --speculative-draft-model-path z-lab/Qwen3-Coder-30B-A3B-DFlash \
  --host 0.0.0.0 \
  --port 8000 \
  --served-model-name qwen3-4b-instruct-2507 \
  --tp-size 1 \
  --dtype bfloat16 \
  --attention-backend fa3 \
  --mem-fraction-static 0.75 \
  --trust-remote-code \
  --context-length 40960 \
  --max-running-requests 32
