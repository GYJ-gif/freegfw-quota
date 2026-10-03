# FreeGFW 单机配额版一键升级

此版本在 FreeGFW 基础上增加月度流量配额。面向已经按官方 Docker 脚本安装的单机服务器，不适用于 Systemd 安装、非 host 网络或互联节点。

## 使用

在服务器上以 root 执行：

```bash
curl -fsSL https://raw.githubusercontent.com/GYJ-gif/freegfw-quota/main/install-quota.sh | bash
```

安装完成后，打开原来的面板地址，使用原管理员账号和密码登录。用户、节点配置、证书和订阅标识从旧数据复制；无需建立空白面板。

第一次会在服务器本地构建镜像，需下载依赖并使用额外磁盘、内存和时间。构建期间旧服务继续运行，复制数据和切换容器时会短暂停机。服务器需已有 Docker、curl、tar、sha256sum、base64、mktemp 和 flock。实际服务器资源及安装兼容性待核验。

如果希望先检查脚本，可下载到服务器后运行 `bash install-quota.sh --help` 或 `bash install-quota.sh --verify-bundle`。后一个模式只解码并验证内嵌源码，不部署。

自定义面板端口可通过 `FREEGFW_PANEL_PORT` 传入；默认 8080。不读取或导出管理员密码、私钥、订阅内容或 Docker 私有环境变量。脚本不会自动安装 Docker、开放防火墙、重装系统或修改 SSH。

## 配额规则

- 每个用户独立设置额度，不按用户名区分；0 表示不限额。
- 尚未设置过配额的旧用户首次升级默认不限额；已设置的额度和当期用量保留。新增用户默认 150 GB/月，可自行修改。
- 上传和下载相加；1 GB = 1,000,000,000 字节。
- 每月 2 日北京时间 00:00 重置，首次启用从零计量。
- 用户行可修改配额，0 表示不限额；超额断开连接并拒绝新连接，下个周期自动恢复。
- 正常退出会保存用量；强杀或断电可能丢失最后约一秒的用量，并发进行中的数据可能造成少量超额。
- 本版仅支持本地用户，不支持互联或跨节点共享额度。

## 数据保留与回退

脚本先构建镜像，随后停止旧容器，把 `/data` 备份到 `/opt/freegfw-quota/backups/`。新版使用独立的新数据卷，保留旧容器和原数据卷，不让新版修改原数据库。

失败时尝试自动恢复旧容器。成功后会打印一个 `rollback.sh` 的完整路径，可手动执行它恢复升级前版本。回退使用升级前的数据，升级后的用户变动及流量统计不会自动合并。脚本不删除旧容器、备份或数据卷。

启动检查只确认面板服务可达且要求登录，不能替代实际代理连接验证。上线后先给独立测试用户一个小额度，验证上传＋下载计量、超额断连和恢复，再让朋友使用。

## 验证状态与人工复核

已完成：Bash 语法检查、内嵌源码校验、固定上游源码校验、源码重建一致性、配额单元测试、前端构建和模拟界面测试。

待核验：真实 Linux Docker 镜像构建、实际服务器切换及 SQLite 持久化。本地没有 Docker，此次没有执行服务器部署。

最需要人工复核：现有容器是否为 `freegfw` 且使用 host 网络、服务器编译资源是否足够、备份是否完整以及真实节点协议是否能超额断连。Docker 存储和容器行为需要官方确认，优先参考下方文档。

## 源码与来源

修改源码以 gzip/base64 形式包含在 `install-quota.sh` 中。脚本下载并校验上游固定提交 `1e8f78a445aa19060a504f33362245e3508044cb`，叠加内嵌修改后本地构建。源码位于服务器 `/opt/freegfw-quota/build-*/source/`。本修改版沿用上游 GPLv3 许可，不代表上游正式发布。

- [FreeGFW 作者仓库](https://github.com/haradakashiwa/freegfw)
- [Docker 官方：数据卷](https://docs.docker.com/engine/storage/volumes/)
- [Docker 官方：复制容器文件](https://docs.docker.com/reference/cli/docker/container/cp/)
- [Docker 官方：重命名容器](https://docs.docker.com/reference/cli/docker/container/rename/)
