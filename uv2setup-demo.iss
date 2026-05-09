; Essential
#define AppId "5849D3FC-0FAF-4C9C-9EC0-CCF5724AB5E4"
#define AppName "Demo App"
#define AppVersion "0.1.0"
#define AppPublisher "Demo App Publisher"
#define AppExeName "demo-app.exe"
#define UvEntryPoint "uv2setup_entrypoint" ; either 'path/to/main.py' or recommended 'gui-script' in pyproject.toml

; Extras
#define LicenseFile "app/LICENSE"
#define ReadmeFile "app/README.md"

; Advanced
#define UvExecutable AppExeName; uv.exe for console app. uvw.exe or AppExeName for pure GUI app
#define UvSyncArgs "--config-file=./.uv2setup/uv.toml --frozen --verbose"
#define UvRunArgs  "--config-file=./.uv2setup/uv.toml --frozen"
#define Excludes ".venv\*,__pycache__\*,*.pyc,.pytest_cache\*,.mypy_cache\*,.ruff_cache\*,.git\*"
#define Compression "lzma2/fast"     ; see https://documentation.help/Inno-Setup/topic_setup_compression.htm

; DO NOT EDIT CONTENTS BELOW UNLESS YOU'RE HACKING
#if !FileExists(LicenseFile)
  #define LicenseFile ''
#endif
#if !FileExists(ReadmeFile)
  #define ReadmeFile ''
#endif

[Setup]
AppId={#AppId}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
DefaultDirName={localappdata}\Programs\{#RemoveFileExt(AppExeName)}
OutputDir=dist
OutputBaseFilename={#RemoveFileExt(AppExeName)}-setup
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
Compression={#Compression}
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayName={#AppName}
; DO NOT CLOSE SetupLogging
SetupLogging=yes
CloseApplications=yes
RestartApplications=no
InfoBeforeFile={#ReadmeFile}
LicenseFile={#LicenseFile}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "chinesesimplified"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: dontinheritcheck
Name: "customuv"; Description: "Advanced: customize uv config"; Flags: unchecked

[Files]
Source: ".\app\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: {#Excludes}
Source: ".\.uv2setup\*"; DestDir: "{app}\.uv2setup"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: ".\.uv2setup\uvw.exe"; DestDir: "{app}\.uv2setup"; DestName: "{#AppExeName}"; Flags: ignoreversion

[Run]
; Launch application after installation completes
Filename: "{app}\.uv2setup\{#UvExecutable}"; \
    Parameters: "run {#UvRunArgs} {#UvEntryPoint}"; \
    WorkingDir: "{app}"; \
    Description: "{cm:LaunchProgram,{#AppName}}"; \
    Flags: nowait postinstall skipifsilent;

[Icons]
Name: "{autoprograms}\{#AppName}"; \
    Filename: "{app}\.uv2setup\{#UvExecutable}"; \
    WorkingDir: "{app}"; \
    Parameters: "run {#UvRunArgs} {#UvEntryPoint}"; \
    IconFilename: "{app}\.uv2setup\icon.ico"

Name: "{autodesktop}\{#AppName}"; \
    Filename: "{app}\.uv2setup\{#UvExecutable}"; \
    WorkingDir: "{app}"; \
    Parameters: "run {#UvRunArgs} {#UvEntryPoint}"; \
    IconFilename: "{app}\.uv2setup\icon.ico"; \
    Tasks: desktopicon

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

[Code]

procedure UvSync();
var
    ResultCode: Integer;
    UvSyncArgsRuntime: String;
begin
    UvSyncArgsRuntime := ExpandConstant('{#UvSyncArgs}')
    Log('uv sync begins' );
    Log('Command: ' + ExpandConstant('{app}\.uv2setup\uv.exe') + ' ' + UvSyncArgsRuntime );
    Log('Work Dir: ' +  ExpandConstant('{app}'));
    if not ExecAndLogOutput(
        ExpandConstant('{app}\.uv2setup\uv.exe'),
        'sync ' + UvSyncArgsRuntime,
        ExpandConstant('{app}'),
        SW_SHOWNORMAL,
        ewWaitUntilTerminated,
        ResultCode,
        nil
    ) then
    begin
        MsgBox(
        'Failed to start uv sync.',
        mbCriticalError,
        MB_OK
        );
        Abort;
    end;
    Log('uv sync ends');

    if ResultCode <> 0 then begin
        MsgBox(
            'Failed to prepare the Python environment.' + #13#10 +
            'Please send the installation log to the developer.',
            mbCriticalError,
            MB_OK
        );
        Exec(ExpandConstant('{sys}\notepad.exe'), ExpandConstant('{log}'),'',SW_SHOWNORMAL,ewNoWait,ResultCode);
        Abort;
    end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
    ResultCode: Integer;
begin
    if CurStep = ssPostInstall then begin
        if WizardIsTaskSelected('customuv') then begin
            WizardForm.StatusLabel.Caption := 'Editing uv.toml';
            Exec(ExpandConstant('{sys}\notepad.exe'), ExpandConstant('{app}/.uv2setup/uv.toml'),'',SW_SHOWNORMAL,ewWaitUntilTerminated,ResultCode);
        end;
        WizardForm.StatusLabel.Caption := 'Downloading and Configuring Python environment (please wait)...';
        UvSync();
    end;
end;