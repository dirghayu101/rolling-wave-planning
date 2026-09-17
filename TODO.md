# TODO

Open work that is deliberately parked. Each entry names what is missing, why it was parked, and what closes it.

## PowerShell installer tests on Apple silicon (parked 2026-09-17)

`tests/setup/run.sh` skips its PowerShell cases (P1, P2, P4, P5, P7) when the Docker daemon is not amd64, because the `mcr.microsoft.com/powershell` image is amd64-only and crashes under Docker Desktop's emulation on Apple silicon (exit 134 or 139). The cases passed under colima, so `setup.ps1` itself is not known to be broken. `RUN_PWSH=1` forces the cases to run.

Closes it: build a local arm64 test image from `ubuntu:24.04` plus the PowerShell linux-arm64 tarball when `docker version --format '{{.Server.Arch}}'` is not amd64, use it in place of the pulled image, remove the skip, and re-run to a full pass. Then update README § Tests.
