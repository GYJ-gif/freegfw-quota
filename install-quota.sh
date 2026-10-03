#!/usr/bin/env bash
# FreeGFW single-server quota edition. Source code is included in the overlay.
# Upstream GPLv3: https://github.com/haradakashiwa/freegfw
# Never use the upstream installer to upgrade this custom edition.
set -Eeuo pipefail
umask 077

UPSTREAM_COMMIT='1e8f78a445aa19060a504f33362245e3508044cb'
SOURCE_SHA256='23dfcb9965c8e431962f48e2ff3d77643b0d2f680d5d905ab2212bca986529f1'
OVERLAY_SHA256='dcf4e895ca3e6dc9765349df6f6aa7e1fbad4ad0259fa8cd5201f0d0ed64d4f6'
IMAGE="freegfw-quota:local-${OVERLAY_SHA256:0:12}"
CONTAINER='freegfw'
PANEL_PORT="${FREEGFW_PANEL_PORT:-8080}"
WORK_ROOT='/opt/freegfw-quota'

fail() {
    printf '错误：%s\n' "$*" >&2
    if declare -F restore_old >/dev/null; then restore_old; else exit 1; fi
}

write_overlay() {
    base64 --decode > "$1" <<'FREEGFW_QUOTA_SOURCE'
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
+/z/KQS52wCQAQA=
FREEGFW_QUOTA_SOURCE
    printf '%s  %s\n' "$OVERLAY_SHA256" "$1" | sha256sum --check --status
}

case "${1:-}" in
    --help)
        printf '%s\n' 'FreeGFW 单机月度配额升级脚本' \
            '仅适用于已运行的 freegfw Docker 容器、host 网络及持久化 /data。' \
            '运行：sudo bash install-quota.sh' \
            '只验证内嵌源码：bash install-quota.sh --verify-bundle' \
            '默认面板端口 8080；自定义端口需设置 FREEGFW_PANEL_PORT。' \
            '先构建新版，再停机备份；新版使用数据副本，原容器和原数据卷保留。'
        exit 0 ;;
    --verify-bundle)
        VERIFY_DIR=$(mktemp -d)
        write_overlay "$VERIFY_DIR/source-overlay.tar.gz"
        tar -tzf "$VERIFY_DIR/source-overlay.tar.gz" >/dev/null
        printf '内嵌源码校验通过；校验包保留在 %s\n' "$VERIFY_DIR"
        exit 0 ;;
    '') ;;
    *) fail '未知参数。请使用 --help 查看说明。' ;;
esac

[[ "$(uname -s)" == 'Linux' ]] || fail '此脚本仅在 Linux 服务器上运行。'
[[ "${EUID}" -eq 0 ]] || fail '请使用 root，或 sudo bash 运行。'
[[ "$PANEL_PORT" =~ ^[0-9]+$ ]] || fail '面板端口必须是整数。'
(( 10#$PANEL_PORT >= 1 && 10#$PANEL_PORT <= 65535 )) || fail '端口必须在 1 至 65535 之间。'
case "$(uname -m)" in x86_64|aarch64|arm64) ;; *) fail '仅支持 amd64 或 arm64。' ;; esac

for cmd in docker curl tar sha256sum base64 mktemp flock; do
    command -v "$cmd" >/dev/null || fail "缺少工具 $cmd，请安装后重试。"
done
docker info >/dev/null 2>&1 || fail 'Docker 服务不可用。'
docker inspect "$CONTAINER" >/dev/null 2>&1 || fail '未找到现有 freegfw 容器；本脚本用于升级，不会创建空白面板。'
[[ "$(docker inspect --format '{{.HostConfig.NetworkMode}}' "$CONTAINER")" == 'host' ]] || fail '现有容器不是 host 网络，请先核对安装方式。'
[[ "$(docker inspect --format '{{.State.Running}}' "$CONTAINER")" == 'true' ]] || fail '现有容器没有运行，请先确认旧服务正常。'
MOUNT_TYPE=$(docker inspect --format '{{range .Mounts}}{{if eq .Destination "/data"}}{{.Type}}{{end}}{{end}}' "$CONTAINER")
case "$MOUNT_TYPE" in volume|bind) ;; *) fail '未找到 /data 持久化挂载，已停止升级。' ;; esac

# Only test local availability; existing IP certificates need not match loopback.
# No administrator password or subscription token is read or sent.
SCHEME=''
for candidate in https http; do
    status=$(curl --silent --insecure --max-time 3 --output /dev/null --write-out '%{http_code}' "$candidate://127.0.0.1:$PANEL_PORT/" || true)
    if [[ "$status" == '401' ]]; then SCHEME="$candidate"; break; fi
done
[[ -n "$SCHEME" ]] || fail '旧面板没有返回登录认证要求（401），请核对端口和密码设置。'

mkdir -p "$WORK_ROOT"
chmod 700 "$WORK_ROOT"
exec 9>"$WORK_ROOT/upgrade.lock"
flock -n 9 || fail '另一个升级任务正在运行。'
BUILD_DIR=$(mktemp -d "$WORK_ROOT/build-XXXXXXXX")
SOURCE_DIR="$BUILD_DIR/source"
mkdir "$SOURCE_DIR"
printf '%s\n' '下载固定版本源码并校验；此阶段不会停止旧服务。'
curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 --connect-timeout 15 --max-time 600 --retry 3 \
    "https://codeload.github.com/haradakashiwa/freegfw/tar.gz/$UPSTREAM_COMMIT" \
    --output "$BUILD_DIR/upstream.tar.gz"
printf '%s  %s\n' "$SOURCE_SHA256" "$BUILD_DIR/upstream.tar.gz" | sha256sum --check --status
tar -xzf "$BUILD_DIR/upstream.tar.gz" --strip-components=1 -C "$SOURCE_DIR"
write_overlay "$BUILD_DIR/source-overlay.tar.gz"
tar -xzf "$BUILD_DIR/source-overlay.tar.gz" -C "$SOURCE_DIR"

printf '%s\n' '正在本机编译新版，首次需要下载依赖并占用额外磁盘和内存；旧服务保持运行。'
DOCKER_BUILDKIT=1 docker build --tag "$IMAGE" "$SOURCE_DIR"

STAMP="$(date -u +%Y%m%dT%H%M%SZ)-${BUILD_DIR##*-}"
BACKUP="$WORK_ROOT/backups/$STAMP"
OLD_CONTAINER="freegfw-before-quota-$STAMP"
FAILED_CONTAINER="freegfw-quota-replaced-$STAMP"
NEW_VOLUME="freegfw-quota-data-$STAMP"
SEED_CONTAINER="freegfw-quota-copy-$STAMP"
mkdir -p "$BACKUP/data"

restore_old() {
    local result=$?
    trap - ERR INT TERM
    set +e
    printf '%s\n' '升级未完成，正在恢复旧容器；原数据卷没有被新版修改。' >&2
    if docker inspect "$OLD_CONTAINER" >/dev/null 2>&1; then
        if docker inspect "$CONTAINER" >/dev/null 2>&1; then
            docker stop --time 30 "$CONTAINER" >/dev/null
            if ! docker rename "$CONTAINER" "$FAILED_CONTAINER"; then
                printf '自动恢复未完成，请检查容器名称；旧容器：%s\n' "$OLD_CONTAINER" >&2
                exit 1
            fi
        fi
        if docker rename "$OLD_CONTAINER" "$CONTAINER"; then
            if ! docker start "$CONTAINER" >/dev/null; then
                printf '旧容器恢复启动失败，请在控制台检查 %s。\n' "$CONTAINER" >&2
                exit 1
            fi
        else
            printf '旧容器恢复名称失败：%s\n' "$OLD_CONTAINER" >&2
            exit 1
        fi
    elif docker inspect "$CONTAINER" >/dev/null 2>&1; then
        docker start "$CONTAINER" >/dev/null || printf '请检查旧容器：%s\n' "$CONTAINER" >&2
    fi
    printf '备份和构建文件保留在 %s；没有删除容器或数据卷。\n' "$WORK_ROOT" >&2
    (( result != 0 )) || result=1
    exit "$result"
}
trap restore_old ERR INT TERM

printf '%s\n' '新版构建完成，现在暂停旧服务并制作一致性备份。'
docker stop --time 30 "$CONTAINER" >/dev/null
docker cp "$CONTAINER:/data/." "$BACKUP/data/"
[[ -s "$BACKUP/data/freegfw.db" ]] || fail '备份中没有数据库，不能继续升级。'
docker volume create "$NEW_VOLUME" >/dev/null
docker run --name "$SEED_CONTAINER" --network none \
    --mount "type=volume,src=$NEW_VOLUME,dst=/data" \
    --mount "type=bind,src=$BACKUP/data,dst=/backup,readonly" \
    --entrypoint /bin/sh "$IMAGE" -c 'cp -a /backup/. /data/'
docker rename "$CONTAINER" "$OLD_CONTAINER"
docker run --detach --name "$CONTAINER" --network host --restart unless-stopped \
    --env "PORT=$PANEL_PORT" --mount "type=volume,src=$NEW_VOLUME,dst=/data" "$IMAGE" >/dev/null

healthy=false
for attempt in {1..30}; do
    status=$(curl --silent --insecure --max-time 3 --output /dev/null --write-out '%{http_code}' "$SCHEME://127.0.0.1:$PANEL_PORT/" || true)
    if [[ "$status" == '401' ]] && [[ "$(docker inspect --format '{{.State.Running}}' "$CONTAINER")" == 'true' ]]; then
        healthy=true
        break
    fi
    sleep 2
done
[[ "$healthy" == true ]]

printf '%s\n' '#!/usr/bin/env bash' 'set -euo pipefail' \
    "docker stop --time 30 '$CONTAINER'" \
    "docker rename '$CONTAINER' '$FAILED_CONTAINER'" \
    "docker rename '$OLD_CONTAINER' '$CONTAINER'" \
    "docker start '$CONTAINER'" > "$BACKUP/rollback.sh"
chmod 700 "$BACKUP/rollback.sh"
trap - ERR INT TERM
printf '\n%s\n' '配额版已启动。使用原来的面板地址、管理员账号和密码登录。'
printf '%s\n' 'GYJ、TLN 不限额；其他用户默认每月 150 GB；每月 2 日北京时间 00:00 重置。'
printf '%s\n' '请先用独立测试用户的小额度验证超额断连，再让朋友继续使用。'
printf '备份：%s\n手动恢复旧版：bash %s/rollback.sh\n' "$BACKUP" "$BACKUP"
printf '%s\n' '回退会恢复升级前的数据；升级后新建用户或新用量不会合并回旧版。'
