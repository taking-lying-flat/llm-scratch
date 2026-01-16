# 看版本/安装路径/依赖
pip show <pkg>                    
# 配置清华源
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip install <package-name> -i https://pypi.tuna.tsinghua.edu.cn/simple

# 安装 flash-attn 2
pip install packaging ninja
pip install flash-attn --no-build-isolation

# 源码安装
git clone --recursive https://github.com/Dao-AILab/flash-attention.git
cd flash-attention
git submodule update --init --recursive
pip install -U pip setuptools wheel
pip install -U packaging ninja
export MAX_JOBS=4 pip install -v . --no-build-isolation

# 安装 ms-swift
pip install ms-swift -U
# 源码安装
pip install -e .
pip install "qwen_vl_utils>=0.0.14" "decord" -U -i https://mirrors.aliyun.com/pypi/simple/


# ------------------------------------------------------------------------------
# (1) DeepSpeed: reduce_bucket_size
# ------------------------------------------------------------------------------
# 参数：zero_optimization.reduce_bucket_size = 5e8
# 定义：
#   - DeepSpeed 文档定义为每次做 reduce/allreduce 的元素个数（numel）
#   - bucket 达到阈值后触发一次 collective（具体可能是 reduce / allreduce / reduce-scatter）
# ------------------------------------------------------------------------------
# (2) NCCL 环境变量: NCCL_IB_TC
# ------------------------------------------------------------------------------
# 参数：export NCCL_IB_TC=106
# 定义：
#   - 设置 IB/RDMA 包的 Traffic Class（8-bit 字段，默认 0）
#   - 是否带来收益取决于集群 QoS/PFC/ECN/DCQCN 等策略是否对该 TC/DSCP 有匹配配置
# 常见编码（RoCE v2 / IP ToS 语境）：
#   - TC(ToS)= DSCP<<2 | ECN
#   - 106 = 26<<2 | 2 => DSCP=26, ECN=2（不少 RoCE 集群用它映射到特定优先级队列）


# 将容器保存为本地镜像
docker commit <CONTAINER_NAME_OR_ID> <LOCAL_IMAGE_NAME>:<TAG>
# 给本地镜像打上远端仓库标签
docker tag <LOCAL_IMAGE_NAME>:<TAG> <REGISTRY>/<NAMESPACE>/<IMAGE_NAME>:<TAG>
# 推送镜像到远端仓库
docker push <REGISTRY>/<NAMESPACE>/<IMAGE_NAME>:<TAG>
# 从远端仓库拉取镜像
docker pull <REGISTRY>/<NAMESPACE>/<IMAGE_NAME>:<TAG>
# HPC/多卡训练容器启动脚本（GPU + RDMA + Host 网络/IPC + 数据挂载 + 北京时间）
docker run -it --name <CONTAINER_NAME> --gpus all --ipc=host --net=host \
  -v /data/ossfs2-bucket:/data -v /tmp:/tmp \
  -v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro \
  -e TZ=Asia/Shanghai \
  --ulimit memlock=-1 --ulimit stack=67108864 \
  -e NCCL_SOCKET_IFNAME=eth0 \
  --device=/dev/infiniband/uverbs0 --device=/dev/infiniband/uverbs1 --device=/dev/infiniband/rdma_cm \
  <IMAGE_NAME>
