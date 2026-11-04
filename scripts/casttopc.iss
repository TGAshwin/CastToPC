; Cast to PC installer (Inno Setup 6). Run scripts\package.ps1 to stage files.
#define MyAppName "Cast to PC"
#ifndef MyAppVersion
  #define MyAppVersion "1.0.0"
#endif
#define MyAppPublisher "Cast to PC contributors"

#define MyAppExeName "CastToPC.exe"
#define PackageDir "..\out\package"

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
Source: "{#PackageDir}\CastToPC.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#PackageDir}\*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\LICENSE"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\NOTICE"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\Cast to PC"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\Cast to PC"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional icons:"
Name: "firewall"; Description: "Allow connections on private Wi-Fi networks (recommended)"; GroupDescription: "Network:"

[Run]
Filename: "netsh"; Parameters: "advfirewall firewall delete rule name=""Cast to PC"""; Flags: runhidden; Tasks: firewall
Filename: "netsh"; Parameters: "advfirewall firewall add rule name=""Cast to PC"" dir=in action=allow program=""{app}\{#MyAppExeName}"" enable=yes profile=private"; Flags: runhidden; Tasks: firewall
Filename: "{app}\{#MyAppExeName}"; Description: "Launch Cast to PC"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "taskkill"; Parameters: "/f /im {#MyAppExeName}"; Flags: runhidden; RunOnceId: "KillApp"
Filename: "netsh"; Parameters: "advfirewall firewall delete rule name=""Cast to PC"""; Flags: runhidden; RunOnceId: "DelFirewall"
