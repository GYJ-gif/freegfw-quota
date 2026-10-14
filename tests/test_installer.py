#!/usr/bin/env python3
"""Mock installer control flow without Docker, network, or host mutations."""
import os
from pathlib import Path
import subprocess
import tempfile

script = Path(__file__).resolve().parents[1] / 'install-quota.sh'
shell = os.environ.get('BASH', 'bash')
source = script.read_text(encoding='utf-8')
tail = source[source.index('case "${1:-}" in'):]
tail = tail.replace('[[ "${EUID}" -eq 0 ]]', '[[ 0 -eq 0 ]]')
prefix = r'''
set -Eeuo pipefail
CONTAINER=freegfw
PANEL_PORT=8080
IMAGE=test
UPSTREAM_COMMIT=test
SOURCE_SHA256=test
WORK_ROOT="$TEST_ROOT/work"
fail() { echo "ERROR: $*" >&2; if declare -F restore_old >/dev/null; then restore_old; else exit 1; fi; }
write_overlay() { :; }
uname() { if [[ "$1" == -s ]]; then echo Linux; else echo "${ARCH:-x86_64}"; fi; }
flock() { :; }
ss() { [[ "$SCENARIO" != occupied ]] || echo LISTEN; return 0; }
systemctl() { return 1; }
sha256sum() { cat >/dev/null; }
tar() { :; }
sleep() { :; }
curl() {
    if [[ "$*" == *write-out* ]]; then
        if [[ "$SCENARIO" == fresh || "$SCENARIO" == occupied ]]; then printf 200
        elif [[ "$SCENARIO" == health_failure ]]; then printf 500
        else printf 401; fi
    fi
}
docker() {
    echo "$*" >> "$TEST_ROOT/docker.log"
    case "$1 ${2:-}" in
        'container ls')
            [[ "$SCENARIO" != list_failure ]] || return 1
            case "$SCENARIO" in fresh|occupied|health_failure|build_failure) ;; *) echo freegfw ;; esac ;;
        'build --build-arg') [[ "$SCENARIO" != build_failure ]] ;;
        'inspect --format')
            case "$3" in
                *NetworkMode*) if [[ "$SCENARIO" == bad_network ]]; then echo bridge; else echo host; fi ;;
                *Running*) echo true ;;
                *Mounts*) echo volume ;;
            esac ;;
        'cp '*) mkdir -p "$3"; echo db > "$3/freegfw.db" ;;
    esac
    return 0
}
'''
# The mock build failure must propagate instead of falling through to return 0.
prefix = prefix.replace("[[ \"$SCENARIO\" != build_failure ]] ;;", "[[ \"$SCENARIO\" != build_failure ]] || return 1 ;;")
for scenario in ['fresh', 'upgrade', 'bad_network', 'occupied', 'list_failure', 'build_failure', 'health_failure']:
    with tempfile.TemporaryDirectory(prefix='quota-test-', dir=script.parent / 'tests') as tmp:
        root = Path(tmp).as_posix()
        if os.name == 'nt':
            root = '/' + root[0].lower() + root[2:]
        env = dict(os.environ, TEST_ROOT=root, SCENARIO=scenario, ARCH='aarch64')
        harness = Path(tmp) / 'harness.sh'
        harness.write_text(prefix + tail, encoding='utf-8', newline='\n')
        result = subprocess.run([shell, root + '/harness.sh'], env=env, capture_output=True, text=True, encoding='utf-8')
        logpath = Path(tmp) / 'docker.log'
        log = logpath.read_text() if logpath.exists() else ''
        success = scenario in ('fresh', 'upgrade')
        assert (result.returncode == 0) == success, (scenario, result.stdout, result.stderr)
        if scenario == 'fresh':
            assert '--build-arg TARGETARCH=arm64' in log
            assert 'run --detach --name freegfw' in log
            assert 'stop ' not in log and 'cp ' not in log
        if scenario == 'upgrade':
            assert 'stop --time 30 freegfw' in log and 'cp freegfw:/data/.' in log
            assert list((Path(tmp) / 'work' / 'backups').glob('*/rollback.sh'))
        if scenario in ('bad_network', 'occupied', 'list_failure', 'build_failure'):
            assert 'run ' not in log and 'stop ' not in log
        assert 'rm ' not in log
        print('PASS', scenario)
