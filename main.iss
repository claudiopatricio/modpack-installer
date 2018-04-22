; Copyright (c) 2018 Cláudio Patrício
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
; -----------------------------------------------------------------------

; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
#define AppId "6DC93CC2-1DD7-4319-82DD-F3786A8FC6B5"

#define AppName "Modpack Installer"
#define AppVersion "1.0"
#define AppPublisher "N/A"
#define AppURL "http://www.anjo2.com"
#define DonateURL "http://www.anjo2.com/donate"

#define LicenseFile "docs\license.rtf"
#define InfoFile "docs\changelog.rtf"

#define SoftwareName "Discord"
#define SoftwareProcessName "Discord.exe"
#define SoftwareExecutableDir "app-0.0.300\"  ; Example: "bin\"

#define InstallCheckRunning True
#define InstallCheckRegion False ; Set True if you want to restrict installation to allowed servers in FindSoftware function

; Language files
#include "languages/en.iss"
;#include "languages/pt.iss"

#include "botva2.ish"

[Setup]
AppId={#AppId}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
DefaultDirName={code:getInstallDir}
AppendDefaultDirName=no
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
DisableDirPage=no
OutputDir=.
DirExistsWarning=no
UsePreviousAppDir=yes
Uninstallable=yes
//(Maybe not required for modpacks, best to remove all files in mods, anyway it wont replace the software uninstall files, just create with another number)
OutputBaseFilename={#AppName}_{#AppVersion}
SetupIconFile=default.ico
compression=lzma2/ultra64
InternalCompressLevel=ultra64
SolidCompression=yes
LicenseFile={#LicenseFile}
; Default Changelog
InfoBeforeFile={#InfoFile}
ShowLanguageDialog=auto
SetupLogging=True
VersionInfoCompany={#AppPublisher}
;InfoAfterFile=extrainfo.rtf
ShowTasksTreeLines=True
AlwaysShowGroupOnReadyPage=True
AlwaysShowDirOnReadyPage=True
VersionInfoVersion={#AppVersion}
TimeStampsInUTC=True

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "pt"; MessagesFile: "compiler:Languages\Portuguese.isl"

[Files]
; NOTE: For code only
Source: "psvince.dll"; Flags: dontcopy
Source: "callback.dll"; Flags: dontcopy
;Source: "fonts\*"; DestDir: "{fonts}"; Flags: onlyifdoesntexist uninsneveruninstall

[Types]
Name: "Normal"; Description: "Base config"
Name: "Custom"; Description: "Custom config"; Flags: iscustom

[Tasks]
Name: "cleaninstall"; Description: "{cm:cleaninstall}"; GroupDescription: "Installation type"; Flags: exclusive
Name: "advanceinstall"; Description: "{cm:normalinstall}"; GroupDescription: "Installation type"; Flags: exclusive unchecked

[ThirdParty]
CompileLogMethod=append

[Code]
// Vars and types
type
  TPositionStorage = array of Integer;
  TTimerProc = procedure(H: LongWord; Msg: LongWord; IdEvent: LongWord; Time: LongWord);
var
  CompPageModified: Boolean;
  ScreenWidth, ScreenHeight: Integer;
  DirName: String;
// Declarations
function IsModuleLoaded(modulename: AnsiString ):  Boolean;
external 'IsModuleLoaded@files:psvince.dll stdcall delayload setuponly';

function IsModuleLoaded2(modulename: AnsiString ):  Boolean;
external 'IsModuleLoaded2@files:psvince.dll stdcall delayload setuponly';

function WrapTimerProc(callback:TTimerProc; paramcount:integer):longword;
external 'wrapcallback@files:callback.dll stdcall delayload setuponly';

function SetTimer(hWnd: longword; nIDEvent, uElapse: longword; lpTimerFunc: longword): longword;
external 'SetTimer@user32.dll stdcall delayload setuponly';

function GetCursorPos(var lpPoint: TPoint): Boolean;
external 'GetCursorPos@user32.dll stdcall delayload setuponly';

function ScreenToClient(hWnd: HWND; var lpPoint: TPoint): BOOL;
external 'ScreenToClient@user32.dll stdcall delayload setuponly';

function ClientToScreen(hWnd: HWND; var lpPoint: TPoint): BOOL;
external 'ClientToScreen@user32.dll stdcall delayload setuponly';

function ListBox_GetItemRect(const hWnd: HWND; const Msg: Integer; Index: LongInt; var Rect: TRect): LongInt;
external 'SendMessageW@user32.dll stdcall delayload setuponly';

function GetSystemMetrics(nIndex: Integer): Integer;
external 'GetSystemMetrics@user32.dll stdcall delayload setuponly';

procedure ComponentChanged(Index: Integer); forward;
procedure setImage(fname: String; title: String; CM: Boolean); forward;
procedure changeImage(Index: Integer); forward;
procedure changeDescription(Index: Integer); forward;
procedure AddElement(var A: TArrayOfString; const S: string); forward;

// Includes
#include "include/functions.iss"
#include "include/design.iss"
#include "include/images.iss"
#include "include/updateconfig.iss"
#include "include/onclick.iss"
#include "include/hover.iss"
#include "include/components.iss"

// ------------------- CODE TO SETUP INSTALLATION TYPE -------------------
//
// Clean Install - Delete all files from res_mods folder
//
// -----------------------------------------------------------------------
// Check Installation Type (Clean/Normal)
procedure CheckInstallType(CurPageID: Integer);
var
  location: String;
begin
  if CurPageID = wpReady then
  begin
    if IsTaskSelected('cleaninstall') then
    begin
      location := WizardDirValue();
      if DirExists(location) then
      begin
        // Uncomment to delete a mods directory before the install, you may delete multiple directories to make sure old files won't mess with your installation.
        //DelTree(ExpandConstant(location + '\mods\*'), False, True, True); // Check documentation for DelTree: http://www.jrsoftware.org/ishelp/index.php?topic=isxfunc_deltree
      end;
    end;
  end;
end;

procedure CheckComponents(CurPageID: Integer);
begin
// Not required anymore! Just for reference
//if CurpageID = wpSelectComponents then // When page is "Components"
  //begin;
  //FixComponents;
  //end;
end;

procedure UpdateConfigAfterInstall(CurPageID: Integer);
begin
  if CurpageID = wpFinished then // When page is "Components"
  begin
    UpdateConfig(); // In 'include/updateconfig.pas'
  end;
end;


// ------------------- INNO SETUP PRE-DEFINED FUNCTIONS -------------------
//
// ------------------------------------------------------------------------
// Function called when Setup is opened
function InitializeSetup(): Boolean;
begin
  Result := True
  //Log('InitializeSetup called');   // Just for debug
  SoftwareName := '{#SoftwareName}'
  SoftwareProcessName := '{#SoftwareProcessName}'
#if InstallCheckRunning == True
  Result := IsRunning(); // Check if process is running
#endif
  ScreenWidth := GetSystemMetrics(0);
  ScreenHeight := GetSystemMetrics(1);
  PDir('{# Botva2_Dll }');
  //ExtractTemporaryFile('{# Botva2_Dll }');
  InstallFound := FindSoftware();

#if InstallCheckRegion == True
  if FindSoftware() = False then
  begin
    MsgBox(ExpandConstant('{cm:softwareWrongServer}'), mbError, MB_OK);
    Result := False;
  end;
#endif
end;

// Function called when Wizard is opened.
procedure InitializeWizard;
var
  HoverTimerCallback: LongWord;
begin
  ExtractImages();
  RedesignMain(); // Buttons and labels added to wizard
  RedesignLocationPage();
  CompPageModified := False; // Flag to check if window size was changed is set to False
  // Show additional information when Component is clicked
  WizardForm.ComponentsList.OnClick := @ComponentsListClickCheck;
  // Uncomment to show additional comments when hover (no need to click)
  HoverTimerCallback := WrapTimerProc(@HoverTimerProc, 4);
  SetTimer(0, 0, 750, HoverTimerCallback);
end;

// Function called after setup ends
procedure DeinitializeSetup;
begin
  gdipShutdown; // Clean all images cache
end;

// Function called when page is changed
procedure CurPageChanged(CurPageID: Integer);
begin
  //CheckLocationPage(CurPageID); // DEPRECATED: Now functions will check the page by themselves
  CheckComponentsPage(CurPageID); // Check if we are in the components and change height
  UpdateConfigAfterInstall(CurPageID); // Update configs in files installed based on options chosen
end;

// Function called when next button is clicked
function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  // TODO: This probably should be done in a separate function with a return
  if (CurPageID = wpSelectDir) and not FileExists(ExpandConstant('{app}\{#SoftwareExecutableDir}{#softwareProcessName}')) then
  begin
    MsgBox(ExpandConstant('{cm:softwareNotFound, {#SoftwareProcessName}}'), mbError, MB_OK);
    Result := False;
    exit;
  end;
  CheckComponents(curPageID); // Check for components dependencies
  CheckInstallType(curPageID);
 end;