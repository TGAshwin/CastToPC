# Cast to PC

Cast to PC turns a Windows 10/11 PC into a receiver for iPhone and iPad screen mirroring on your local Wi-Fi network. Start the receiver on the PC, then choose **Control Center → Screen Mirroring → Cast to PC** on the Apple device. The PC should be connected to the same network.

The receiver displays mirrored video and receives AirPlay audio through Windows audio playback. For streaming, capture the Cast to PC window in OBS; configure OBS audio capture for the Windows output/application as needed. Wi-Fi quality and device load affect latency, so this cannot promise zero delay.

## Install on Windows

Download [CastToPC-Setup-1.0.0.exe](downloads/CastToPC-Setup-1.0.0.exe) and double-click it. The setup wizard installs the app and required runtime files, adds Start menu and desktop shortcuts, and offers a private-network firewall rule (selected by default). Approve the Windows administrator prompt so setup can install the app and add that rule. Keep the PC and iPhone/iPad on the same trusted Wi-Fi network; the firewall rule is limited to Windows networks marked **Private**. You can remove Cast to PC later from **Settings → Apps → Installed apps**. Future versions will be available from the repository's [Releases](https://github.com/TGAshwin/CastToPC/releases) page.

Each successful GitHub Actions build also stores a downloadable installer artifact for contributors. Open the workflow run and download the `CastToPC-Setup-...` artifact.

## Build on Windows

Requirements: Visual Studio 2022 with the Desktop development with C++ workload, CMake, PowerShell, and OpenSSL development files. The build script fetches FFmpeg binaries on first run and builds the Windows x64 application:

```powershell
.\scripts\build.ps1
```

The executable is created at `build\Release\CastToPC.exe`. Start it, then right-click the receiver window or tray icon and choose **Allow through firewall** if the iPhone cannot find it. Approve the Windows administrator prompt. Set your trusted Wi-Fi network profile to **Private** in Windows Settings before adding the firewall rule; Cast to PC opens only the Private profile.

To build the same setup `.exe` locally, install Inno Setup 6, build the app, then run:

```powershell
.\scripts\package.ps1
```

The installer is written to `out\installer\CastToPC-Setup-1.0.0.exe`.

## Contributing

Bug reports and feature proposals are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for the build steps and pull request guidelines. Please open an issue before starting a larger protocol or feature change.

## Notes

- This project is a Windows AirPlay receiver fork based on [AirScreen](https://github.com/donerfolk/airscreen), which incorporates [UxPlay](https://github.com/FDH2/UxPlay). The user-provided [open-airplay](https://github.com/openairplay/open-airplay) project is a sender/client library, so it is not the receiver implementation used here.
- AirPlay compatibility varies by iOS/iPadOS version, network, and hardware. The upstream receiver documentation reports iPhone testing; iPad compatibility may vary.
- The project is licensed under GPL-3.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE), including third-party notices. Preserve these when redistributing.
- “AirPlay”, iPhone, and iPad are Apple trademarks. Cast to PC is not affiliated with Apple.
