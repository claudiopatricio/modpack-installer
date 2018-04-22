// Copyright (c) 2018 Cláudio Patrício
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// -----------------------------------------------------------------------

[Files]
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

; NOTE: ModPack base files
Source: "files\*"; DestDir: "{app}\mods\"; Flags: ignoreversion recursesubdirs createallsubdirs

; NOTE: Modpack Mod 'mymod' files
Source: "files\mymod\*"; DestDir: "{app}\mods\mymod"; Components: mods\mymod; CopyMode: alwaysoverwrite; Flags: ignoreversion

[Components]
; NOTE: Definition For Components
Name: "mods"; Description: "{cm:mods}"; Types: Normal Custom; Flags: disablenouninstallwarning

; NOTE:  Playera Panel Config
Name: "mods\mymod"; Description: "{cm:mods_mymod}"; Types: Custom; Flags: disablenouninstallwarning

[code]
procedure changeDescription(Index: Integer);
begin
  case Index of
    // CM for Mods
    getIndex('mods', False):   CompAddDescription.Caption := ExpandConstant('{cm:mods_description}');

    // CM for mymod
    getIndex('mods_mymod', True): CompAddDescription.Caption := ExpandConstant('{cm:mods_mymod_description}');
    
    // Template for more mods, usage getIndex(NameToSearch, NameIsCustomMessage)
    //getIndex('', True):             CompAddDescription.Caption := 'TODO';
  else
    CompAddDescription.Caption := '';
  end;
end;