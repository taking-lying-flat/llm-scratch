# 容器：镜像固化 / 推送拉取 / HPC 多卡训练容器启动

## 1. 镜像管理

### 固化当前容器为本地镜像
```bash
docker commit <CONTAINER_NAME_OR_ID> <LOCAL_IMAGE_NAME>:<TAG>
```

### 给本地镜像打远端仓库标签
```bash
docker tag <LOCAL_IMAGE_NAME>:<TAG> <REGISTRY>/<NAMESPACE>/<IMAGE_NAME>:<TAG>
```

### 推送到远端仓库
```bash
docker push <REGISTRY>/<NAMESPACE>/<IMAGE_NAME>:<TAG>
```

### 从远端仓库拉取
```bash
docker pull <REGISTRY>/<NAMESPACE>/<IMAGE_NAME>:<TAG>
```

---

## 2. HPC / 多卡训练容器启动

此配置开启了 GPU、RDMA、Host IPC/Net、挂载及无限栈内存（ulimit）。

```bash
docker run -it --name <CONTAINER_NAME> \
  --gpus all \
  --ipc=host \
  --net=host \
  -v /data/ossfs2-bucket:/data \
  -v /tmp:/tmp \
  -v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro \
  -e TZ=Asia/Shanghai \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \
  -e NCCL_SOCKET_IFNAME=eth0 \
  --device=/dev/infiniband/uverbs0 \
  --device=/dev/infiniband/uverbs1 \
  --device=/dev/infiniband/rdma_cm \
  <IMAGE_NAME>
```
