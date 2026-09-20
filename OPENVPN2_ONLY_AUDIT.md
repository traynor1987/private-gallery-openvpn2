# OpenVPN2-only provenance and reproducible build

This branch deliberately contains the **OpenVPN2** engine boundary used by Private Gallery. It is GPL-2.0-only. It was cut from upstream ics-openvpn v0.7.65 commit `ee574f6ff65703e09c1a1f6c2d9243d7940f3f8d`.

## Locked inputs

| Component | Revision | Licence / retained notice |
|---|---|---|
| ics-openvpn integration | `ee574f6ff65703e09c1a1f6c2d9243d7940f3f8d` | GPL-2.0-only with upstream additional linking clarification in `doc/LICENSE.txt` |
| OpenVPN 2 native engine | `566ebc9f23259f5d55a8cc763c761073090f0595` | GPL-2.0-only; retain its OpenSSL and Apache-2.0 linking exceptions |
| OpenSSL Android source | `19a1b558a09892381199b2d1484fe1c0ba6d76cf` | Apache-2.0; retain notices |
| LZO | `4bac163027dc61c7ee15679e53a71d83326eccce` | LZO 2.10, GPL-2.0-or-later; its COPYING remains in-tree |

## Explicit exclusion

The upstream OpenVPN3 submodule at `c4f61851e119dbe4cd57521a7ff4b0e5805fa65e` and all associated AGPL-3.0-or-later/MPL-2.0 source, SWIG bindings, Gradle flavours and CMake targets are removed from this branch. Its unused mbedTLS, ASIO and fmt support submodules are removed too. They must not be restored. LZ4 remains because OpenVPN2's configured compression source and native target use it.

## Reproduce and audit

```bash
git clone --branch openvpn2-gpl2-only --recurse-submodules https://github.com/traynor1987/private-gallery-openvpn2.git
cd private-gallery-openvpn2
./scripts/verify_openvpn2_only.sh
./gradlew :main:assembleOvpn2UiDebug
```

The audit script verifies the exact OpenVPN2, OpenSSL and LZO pins, rejects an OpenVPN3 submodule/path, and rejects OpenVPN3 or AGPL references from active build files. It is a required CI gate for every consuming Private Gallery build.

This repository contains source and build instructions only. It must never contain Android signing material, VPN profiles/credentials, user media, cookies, browsing data, PINs, recovery keys or any other private user data.
