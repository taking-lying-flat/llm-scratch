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
