# Modpack Installer Template

This is a **Inno Setup** template to create a modpack installer for games or software.

Inno Setup is very popular in modpack installers for World of Tanks game, with this template you can create your own very easily.

Don't forget to check the Inno Setup documentation: http://www.jrsoftware.org/ishelp/

**Note**: Read the comments in code carefully, there are some important notes!!!

## How to create executable

* 1. Install Inno Setup from **[KngStr repository](https://github.com/KngStr/Inno-All-in-One-Setup/releases)** (otherwise you will need to download some additional libraries)
* 2. Open the file 'main.iss' with Inno Setup
* 3. Compile (Ctrl+F9)
* **Note:** Remember to create your own AppId, otherwise you may have problems with other software created with this AppId.

## What files to edit

Most code files are in the **include** folder, only "**Main.iss**" is in root folder, but you should also check the **languages** directory to edit custom messages for english or to add another languages to your installer.

### Main.iss

Contains the basic settings for you modpack, such as guid, name, version, languages, etc.

Below there is an example for modpack for Discord
**IMPORTANT**: Create a new AppId for you software!
```
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
#define SoftwareExecutableDir "app-0.0.300\"

#define InstallCheckRunning True
#define InstallCheckRegion False
```

In this file you should also set the directories you want to remove contents (from old modpacks) in a clean install, you should edit **CheckInstallType** procedure.
You can also add more options to clean or normal install if you need.

```
DelTree(ExpandConstant(location + '\mods\*'), False, True, True);
```

### Components.iss

Contains the list of mods

```
[Components]
; NOTE: Definition For Components
Name: "mods"; Description: "{cm:mods}"; Types: Normal Custom; Flags: disablenouninstallwarning

; NOTE:  Playera Panel Config
Name: "mods\mymod"; Description: "{cm:mods_mymod}"; Types: Custom; Flags: disablenouninstallwarning
```

Also the files required for each mod

```
[Files]
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

; NOTE: ModPack base files
Source: "files\*"; DestDir: "{app}\mods\"; Flags: ignoreversion recursesubdirs createallsubdirs

; NOTE: Modpack Mod 'mymod' files
Source: "files\mymod\*"; DestDir: "{app}\mods\mymod"; Components: mods\mymod; CopyMode: alwaysoverwrite; Flags: ignoreversion
```

And the description for each mod in **changeDescription** procedure

```
getIndex('mods', False):   CompAddDescription.Caption := ExpandConstant('{cm:mods_description}');
```

### Images.iss

This file includes the code for each mod preview image, you should add a preview for each mod in the **changeImage** procedure

```
getIndex('mods', True): setImage('no-image-available.png', 'mods', True);
```

Copy the images to "**images**" directory and compress them with 7zip to a filename called "**images.7z**", or run "**7zimages**" in git bash, otherwise it won't work.

### Functions.iss

You may don't need to edit this file, the only section that may require an edit is in the **FindSoftware** function where it searches in regedit where the software is installed and you can define in what servers are allowed to install if you set the "**InstallCheckRegion**" as True.

### Updateconfig.iss

This contains the changes to the configs after the installation, where you can edit the files after installation according to the users choices.

```
if IsComponentSelected('mods\mymod') then
  begin
    sed('mods\configs\mouse.cfg', 'false', 'true');
  end;
```

### en.iss

This files contains all custom messages for english translation, you may add more files like this for other languages, don't forget to include them.

```
[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "pt"; MessagesFile: "compiler:Languages\Portuguese.isl"
```

For example, for English you need to set the start with the name set in languages, for English (default one) is "**en.**"

```
en.softwareNotFound=%1 not found!
```

For Portuguese would be "**pt.**"

```
pt.softwareNotFound=%1 não encontrado!
```

# Donate

If you like my work and want to contribute by donating money, check my [Donation page](http://anjo2.com/donate/)

# License
Copyright (c) 2018 Cláudio Patrício

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.