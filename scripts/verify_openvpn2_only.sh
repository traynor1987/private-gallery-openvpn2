#!/usr/bin/env bash
set -euo pipefail

fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
root="$(git rev-parse --show-toplevel)"
cd "$root"

test "$(git rev-parse HEAD:main/src/main/cpp/openvpn)" = "566ebc9f23259f5d55a8cc763c761073090f0595" || fail "OpenVPN2 pin changed"
test "$(git rev-parse HEAD:main/src/main/cpp/openssl)" = "19a1b558a09892381199b2d1484fe1c0ba6d76cf" || fail "OpenSSL pin changed"
test "$(git rev-parse HEAD:main/src/main/cpp/lzo)" = "4bac163027dc61c7ee15679e53a71d83326eccce" || fail "LZO tree pin changed"

if git ls-tree -r --name-only HEAD | grep -Eqi '(^|/)(openvpn3|ovpn3)(/|$)'; then
  fail "OpenVPN3 path present"
fi
if git ls-tree -r --name-only HEAD | grep -Eqi '(^|/)(mbedtls|asio|fmt)(/|$)'; then
  fail "OpenVPN3-only support path present"
fi
if grep -Eqi 'openvpn3|ovpn3|agpl' .gitmodules main/build.gradle.kts main/src/main/cpp/CMakeLists.txt; then
  fail "OpenVPN3 or AGPL active-build reference present"
fi
if grep -Eqi 'mbedtls|asio|fmt' .gitmodules main/build.gradle.kts main/src/main/cpp/CMakeLists.txt; then
  fail "OpenVPN3-only support reference present"
fi
test -f doc/LICENSE.txt || fail "upstream licence clarification missing"
test -f main/src/main/cpp/lzo/COPYING || fail "LZO notice missing"
printf 'PASS: OpenVPN2-only source audit\n'
