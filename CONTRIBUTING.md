# Contributing to Cast to PC

Bug reports, documentation fixes, and code contributions are welcome.

## Before you start

- Search open and closed issues for related reports or proposals.
- For a new feature or a change to AirPlay behavior, open an issue first so the approach can be discussed before implementation.
- For a bug report, include the Cast to PC version or commit, Windows version, iPhone/iPad model and OS version, connection type, and relevant log lines. Remove personal information from logs.

## Build

Use Windows 10 or 11 x64 with Visual Studio 2022 and its **Desktop development with C++** workload, CMake, PowerShell, and OpenSSL development files. From the repository root run:

```powershell
.\scripts\build.ps1
```

The script downloads the FFmpeg runtime on its first run and creates `build\Release\CastToPC.exe`. Pull requests also run the Windows build workflow.

## Pull requests

- Branch from `main` and keep the change focused.
- Describe the problem, the change, and how you checked it in the pull request description.
- Include screenshots or short recordings for visible UI changes when useful.
- Do not commit build output, downloaded dependencies, pairing keys, crash dumps, or logs.
- Keep existing third-party license notices intact. If you change a third-party component, identify that change and retain its license files.

By submitting a contribution, you confirm you have the right to submit it and agree that it may be distributed under this project's GPL-3.0 license. No separate CLA is required.

## Scope

Cast to PC is a Windows AirPlay receiver. iPhone and iPad use the built-in Control Center **Screen Mirroring** flow; this project does not require an iOS companion app. Please keep changes aligned with that goal and avoid promising zero latency, since network and device conditions affect delay.
