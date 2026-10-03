#!/usr/bin/env bash
# FreeGFW single-server quota edition. Source code is included in the overlay.
# Upstream GPLv3: https://github.com/haradakashiwa/freegfw
# Never use the upstream installer to upgrade this custom edition.
set -Eeuo pipefail
umask 077

UPSTREAM_COMMIT='1e8f78a445aa19060a504f33362245e3508044cb'
SOURCE_SHA256='23dfcb9965c8e431962f48e2ff3d77643b0d2f680d5d905ab2212bca986529f1'
OVERLAY_SHA256='1e53990177af24b1ba6a69f4d8da71478f6a0c2bf41d1d5c132610e152437dc4'
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
printf '%s\n' '每个用户独立设置配额，0 为不限额；新用户默认 150 GB；每月 2 日北京时间 00:00 重置。'
printf '%s\n' '已有配额和用量保留；未设置配额的旧用户默认不限额，请在面板中逐个设置。'
printf '%s\n' '请先用独立测试用户的小额度验证超额断连，再让朋友继续使用。'
printf '备份：%s\n手动恢复旧版：bash %s/rollback.sh\n' "$BACKUP" "$BACKUP"
printf '%s\n' '回退会恢复升级前的数据；升级后新建用户或新用量不会合并回旧版。'
