#!/usr/bin/env bash
# FreeGFW single-server quota edition. Source code is included in the overlay.
# Upstream GPLv3: https://github.com/haradakashiwa/freegfw
# Never use the upstream installer to upgrade this custom edition.
set -Eeuo pipefail
umask 077

UPSTREAM_COMMIT='1e8f78a445aa19060a504f33362245e3508044cb'
SOURCE_SHA256='23dfcb9965c8e431962f48e2ff3d77643b0d2f680d5d905ab2212bca986529f1'
OVERLAY_SHA256='ea2d9365f76bf87b0b91f682d7dde19931ec2f7cc09e7e32ff264956b37aea4d'
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
q41XXpe2QE1LVz9dOfVm/ftPQX71N66CzdR/f75++/by56cEJ/WLZxtXboG5uR0HtbvL99+qf/CH
pbe+Wb71/fKtU4s/fBah0MVU0FhufBrU1i6d/a5x8lRIW7t8/9LytfOLt29E6msbV/4sBUIa25XX
LtQv3QoqbBdvn3ULmwpbQOU+96lrG1cu1M9eq793vanCdunbW8s3r5m8oam+1l05jVMfEwG+dqf+
xiuyp8jKadz4RBgA1nnjm7cbv/9k5a2TBr6DOtr61TvYDMxdKayhDXDM1ipaaWr55v2VyzcjK5qq
sPqtV11m0lpFazZr1tKS5OL9D+s33o3U0dYv/GXlvT/Vz9+pX73aREkbxmZrTa23nD781ORYEbra
xbtvLN9/b+U1xWxlncua92+1TZW1shBApyYfi9TQYtXUT5+RYpZXdfHup2DwwJp0K0yR2P9nr7it
Nl657r5avH+tceoWGBptrT++v/zxF4237tfvXAEfwSpaufzt4p07S3/+DZiyx+WCulcPiOaKV5lH
WoAGypvqXYklCKFzNQwKc944+4kMqvH2V40LHtcN6lzNmm10rq4kVD/93eLdd9prXEWkWrz9hq8C
8XTeG6I1riJKmSVMjatsyVFvPa1rizKeKHO1cebSyisngTspiClcPnl6+ac3sVHVb/2A/caFc/n+
B2BgMvqm6lezxTa616VXfqi/djcMQljtKmVaKl3r338tpUj2A5Xz3kvC4cXfrZw8BeFQBhOtdFUz
Gi7hvYzQuUp5E+YItevS1+8uf/ttAJPNVK8+tPNoqEoINUGlqxIxrnxV//BktNJVxDopFynWqSa0
WOdXvjbeuYEaJh6i1a/e3sMVQPDYbKRll3X4xDef6lWxFr0LR2peVRuf/GX520+jlK5gFRAyonWu
jSsn65feqF867woGUWpXgzd2onN9CKw0wDhdLevKKzeXbv7FirO2NRGlblWHkW+u118974Od1vVb
3wmAy/dfa1y52rh4aeXV3wOuxrnT9fu/WXn/0hKEsMs3Vz5+F7BgECvvX2z89mL92hf1V9/zwxLa
eMF2mW6VnMpgmsQYoVld/v4bwCGIaquGBVkt3/zErOJtp1E6WLOki1iMHxw7vE013roLJkQTdOvH
5de+lelofPPbxo8XMWxfU1+9KiKTeQ6AgpWOAhcuLt/09pamelVpiARjPf3RSlVzxO2Vqkp25kUh
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
