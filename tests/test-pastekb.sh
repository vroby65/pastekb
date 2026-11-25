#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
test_dir=$(mktemp -d)
trap 'rm -rf -- "$test_dir"' EXIT

printf '%s\n' '  Caffè, già!' "\$(testo letterale)" '' > "$test_dir/clipboard"
export TEST_CLIPBOARD="$test_dir/clipboard"
export TEST_KEY_PRESSED="$test_dir/pressed"
export TEST_KEY_RELEASED="$test_dir/released"

cat > "$test_dir/xinput" <<'EOF'
#!/usr/bin/env bash
case "$*" in
    'list --short') printf 'Test keyboard\tid=7\t[slave  keyboard (3)]\n' ;;
    'query-state 7')
        if [[ -e $TEST_KEY_PRESSED && ! ${TEST_KEY_STUCK:-} ]]; then
            touch "$TEST_KEY_RELEASED"
            printf 'key[37]=up\n'
        else
            touch "$TEST_KEY_PRESSED"
            printf 'key[37]=down\n'
        fi
        ;;
    *) exit 1 ;;
esac
EOF

cat > "$test_dir/xclip" <<'EOF'
#!/usr/bin/env bash
[[ $# -eq 3 && $1 == -selection && $2 == clipboard && $3 == -out ]] || exit 1
cat -- "$TEST_CLIPBOARD"
EOF

cat > "$test_dir/xdotool" <<'EOF'
#!/usr/bin/env bash
[[ $# -eq 4 && $1 == type && $2 == --clearmodifiers && $3 == --file && $4 == - ]] || exit 1
[[ -e $TEST_KEY_RELEASED ]] || exit 1
cat
EOF

chmod +x "$test_dir/xinput" "$test_dir/xclip" "$test_dir/xdotool"
PATH="$test_dir:$PATH" "$project_dir/pastekb" > "$test_dir/typed"
cmp "$test_dir/clipboard" "$test_dir/typed"

rm -- "$TEST_KEY_RELEASED"
status=0
TEST_KEY_STUCK=1 PATH="$test_dir:$PATH" timeout 4 "$project_dir/pastekb" \
    > "$test_dir/typed" 2> "$test_dir/error" || status=$?
[[ $status == 1 && ! -s $test_dir/typed ]]
grep -q 'timed out waiting for key release' "$test_dir/error"
