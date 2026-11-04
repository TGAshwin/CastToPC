; Cast to PC installer (Inno Setup 6)
; iscc /DCrtDir=<VS>\VC\Redist\MSVC\<ver>\x64\Microsoft.VC143.CRT scripts\casttopc.iss
#define MyAppName "Cast to PC"
#ifndef MyAppVersion
  #define MyAppVersion "1.0.0"
#endif
#define MyAppPublisher "Cast to PC contributors"

#define MyAppExeName "CastToPC.exe"
#ifndef BuildDir
  #define BuildDir "..\build\Release"
#endif
#ifndef CrtDir
  #error Pass /DCrtDir=<VS>\VC\Redist\MSVC\<ver>\x64\Microsoft.VC143.CRT
#endif

[Setup]
AppId={{CBE6DA65-1292-4348-AE42-EBC00FF7CDF1}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
VersionInfoVersion={#MyAppVersion}
DefaultDirName={autopf}\Cast to PC
DefaultGroupName=Cast to PC
OutputDir=..\out\installer
OutputBaseFilename=CastToPC-Setup-{#MyAppVersion}
Compression=lzma2
SolidCompression=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0
PrivilegesRequired=admin
WizardStyle=modern
LicenseFile=..\LICENSE
SetupIconFile=..\src\app\app.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
SetupLogging=yes
CloseApplications=yes

[Files]
; Only the DLLs CastToPC.exe imports, plus the app-local Visual C++ runtime
Source: "{#BuildDir}\CastToPC.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BuildDir}\avcodec-*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BuildDir}\avutil-*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BuildDir}\swresample-*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BuildDir}\libcrypto-*-x64.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#CrtDir}\msvcp140.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#CrtDir}\vcruntime140.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#CrtDir}\vcruntime140_1.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\LICENSE"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\NOTICE"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\Cast to PC"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\Cast to PC"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional icons:"
Name: "firewall"; Description: "Allow Cast to PC through Windows Firewall"; GroupDescription: "Network:"

[Run]
Filename: "netsh"; Parameters: "advfirewall firewall delete rule name=""Cast to PC"""; Flags: runhidden; Tasks: firewall
Filename: "netsh"; Parameters: "advfirewall firewall add rule name=""Cast to PC"" dir=in action=allow program=""{app}\{#MyAppExeName}"" enable=yes profile=private"; Flags: runhidden; Tasks: firewall
Filename: "{app}\{#MyAppExeName}"; Description: "Launch Cast to PC"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "taskkill"; Parameters: "/f /im {#MyAppExeName}"; Flags: runhidden; RunOnceId: "KillApp"
Filename: "netsh"; Parameters: "advfirewall firewall delete rule name=""Cast to PC"""; Flags: runhidden; RunOnceId: "DelFirewall"
