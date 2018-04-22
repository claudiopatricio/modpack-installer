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

[Code]
var
  SelectServerCombo: TNewComboBox;
  SoftwareName: String;
  SoftwareProcessName: String;
  InstallFound: Boolean;
  InstallDirArray: TArrayOfString;
  ServersNamesArray: TArrayOfString;
  SelectServerComboDefault: Integer;

procedure AddElement(var A: TArrayOfString; const S: String);
begin
	SetArrayLength(A, GetArrayLength(A) + 1);
	A[High(A)] := S;
end;

function getInstallDir(Param: String): String;
begin
	Result := DirName;
end;

// Find where the software is installed and change the base install directory.
function FindSoftware(): Boolean;
var
	Names: TArrayOfString;
	aux: String;
	Reg: String;
	I: Integer;
begin
	Result := False;
	SelectServerComboDefault := -1;
	if RegKeyExists(HKEY_CURRENT_USER, 'Software\Microsoft\Windows\CurrentVersion\Uninstall') then
	begin
	 if RegGetSubkeyNames(HKEY_CURRENT_USER, 'Software\Microsoft\Windows\CurrentVersion\Uninstall', Names) then // Get all subkeys from Uninstall
	 begin
		 for I := 0 to GetArrayLength(Names)-1 do
		 begin
				Reg := 'Software\Microsoft\Windows\CurrentVersion\Uninstall\' + Names[I]; // Save the address for install registry
				RegQueryStringValue(HKEY_CURRENT_USER, Reg, 'DisplayName', aux);
				if Pos(SoftwareName, aux) > 0 then
				begin
					RegQueryStringValue(HKEY_CURRENT_USER, Reg, 'InstallLocation', aux); // Get installation directory
					if Pos('eu', Names[I]) > 0 then
					begin
						if DirName = '' then
						begin
							DirName := aux; // Change install directory
							SelectServerComboDefault := GetArrayLength(ServersNamesArray);
						end;
						Result := True;
						AddElement(ServersNamesArray, 'EU Server');
						AddElement(InstallDirArray, aux);
					end
					else if  Pos('na', Names[I]) > 0 then
					begin
						if DirName = '' then
						begin
							DirName := aux; // Change install directory
							SelectServerComboDefault := GetArrayLength(ServersNamesArray);
						end;
						Result := True;
						AddElement(ServersNamesArray, 'NA Server');
						AddElement(InstallDirArray, aux);
					end
					else if  Pos('ct', Names[I]) > 0 then
					begin
						Result := True;
						AddElement(ServersNamesArray, 'Common Test Server');
						AddElement(InstallDirArray, aux);
					end
					else if  Pos('sea', Names[I]) > 0 then
					begin
						if DirName = '' then
						begin
							DirName := aux; // Change install directory
							SelectServerComboDefault := GetArrayLength(ServersNamesArray);
						end;
						Result := True;
						AddElement(ServersNamesArray, 'SEA Server');
						AddElement(InstallDirArray, aux);
					end
					else if  Pos('kr', Names[I]) > 0 then
					begin
						if DirName = '' then
						begin
							DirName := aux; // Change install directory
							SelectServerComboDefault := GetArrayLength(ServersNamesArray);
						end;
						Result := True;
						AddElement(ServersNamesArray, 'Korean Server');
						AddElement(InstallDirArray, aux);
					end
					else if  Pos('ru', Names[I]) > 0 then
					begin
						if DirName = '' then
						begin
							DirName := aux; // Change install directory
							SelectServerComboDefault := GetArrayLength(ServersNamesArray);
						end;
						Result := True;
						AddElement(ServersNamesArray, 'Russian Server');
						AddElement(InstallDirArray, aux);
					end
					else if  Pos('cn', Names[I]) > 0 then
					begin
						if DirName = '' then
						begin
							DirName := aux; // Change install directory
							SelectServerComboDefault := GetArrayLength(ServersNamesArray);
						end;
						Result := True;
						AddElement(ServersNamesArray, 'Chinese Server');
						AddElement(InstallDirArray, aux);
					end
					else
					begin
						if DirName = '' then
						begin
							DirName := aux; // Change install directory
							SelectServerComboDefault := GetArrayLength(ServersNamesArray);
						end;
						Result := False;
						AddElement(ServersNamesArray, 'Default');
						AddElement(InstallDirArray, aux);
						Exit;
					end;
				end;
			end;
		end;
	end;
	if Result = True then
		Exit;

	if RegKeyExists(HKEY_CURRENT_USER, 'Software\Wow6432Node\Windows\CurrentVersion\Uninstall') then
	begin
		if RegGetSubkeyNames(HKEY_CURRENT_USER, 'Software\Wow6432Node\Windows\CurrentVersion\Uninstall', Names) then // Get all subkeys from Uninstall
		begin
			for I := 0 to GetArrayLength(Names)-1 do
			begin
				Reg := 'Software\Wow6432Node\Windows\CurrentVersion\Uninstall\' + Names[I]; // Save the address for install registry
				RegQueryStringValue(HKEY_CURRENT_USER, Reg, 'DisplayName', aux);
				if Pos(SoftwareName, aux) > 0 then
				begin
					RegQueryStringValue(HKEY_CURRENT_USER, Reg, 'InstallLocation', aux); // Get installation directory
					if Pos('eu', Names[I]) > 0 then
					begin
						if DirName = '' then
						begin
							DirName := aux; // Change install directory
							SelectServerComboDefault := GetArrayLength(ServersNamesArray);
						end;
						Result := True;
						AddElement(ServersNamesArray, 'EU Server');
						AddElement(InstallDirArray, aux);
					end
					else if  Pos('na', Names[I]) > 0 then
					begin
						if DirName = '' then
						begin
							DirName := aux; // Change install directory
							SelectServerComboDefault := GetArrayLength(ServersNamesArray);
						end;
						Result := True;
						AddElement(ServersNamesArray, 'NA Server');
						AddElement(InstallDirArray, aux);
					end
					else if  Pos('ct', Names[I]) > 0 then
					begin
						Result := True;
						AddElement(ServersNamesArray, 'Common Test Server');
						AddElement(InstallDirArray, aux);
					end
					else if  Pos('sea', Names[I]) > 0 then
					begin
						if DirName = '' then
						begin
							DirName := aux; // Change install directory
							SelectServerComboDefault := GetArrayLength(ServersNamesArray);
						end;
						Result := True;
						AddElement(ServersNamesArray, 'SEA Server');
						AddElement(InstallDirArray, aux);
					end
					else if  Pos('kr', Names[I]) > 0 then
					begin
						if DirName = '' then
						begin
							DirName := aux; // Change install directory
							SelectServerComboDefault := GetArrayLength(ServersNamesArray);
						end;
						Result := True;
						AddElement(ServersNamesArray, 'Korean Server');
						AddElement(InstallDirArray, aux);
					end
					else if  Pos('ru', Names[I]) > 0 then
					begin
						if DirName = '' then
						begin
							DirName := aux; // Change install directory
							SelectServerComboDefault := GetArrayLength(ServersNamesArray);
						end;
						Result := True;
						AddElement(ServersNamesArray, 'Russian Server');
						AddElement(InstallDirArray, aux);
					end
					else if  Pos('cn', Names[I]) > 0 then
					begin
						if DirName = '' then
						begin
							DirName := aux; // Change install directory
							SelectServerComboDefault := GetArrayLength(ServersNamesArray);
						end;
						Result := True;
						AddElement(ServersNamesArray, 'Chinese Server');
						AddElement(InstallDirArray, aux);
					end
					else
					begin
						if DirName = '' then
						begin
							DirName := aux; // Change install directory
							SelectServerComboDefault := GetArrayLength(ServersNamesArray);
						end;
						Result := False;
						AddElement(ServersNamesArray, 'Default');
						AddElement(InstallDirArray, aux);
						Exit;
					end;
				end;
			end;
		end;
	end;
	if Result = False then
		DirName := ExpandConstant('C:\Program Files\' + SoftwareName);
end;

// Check if process is running and creates a Warning window
function IsRunning(): Boolean;
begin
	Result := IsModuleLoaded(SoftwareProcessName);
	if Result = False then
		Result := IsModuleLoaded2(SoftwareProcessName);
	
	if Result = True then
	begin
	 Result := MsgBox(ExpandConstant('Caution: ' + SoftwareName + ' is running.' #13#13 'Do you really want to continue?'), mbConfirmation, MB_YESNO) = idYes; // Confirm to continue
	 if Result = False then
		MsgBox('See you soon.', mbInformation, MB_OK); // Not needed, just fo fun for now
	 exit;
	end;
	Result := True // If is not running, just go forward
end;

// Works as linux sed
// sed(file_to_edit, 'original_text', 'new_text');
function sed(fname: String; Orig: String; Moded: String): Boolean;
var
	fhandle: AnsiString;
	fhandle_uni: String;
begin;
	Result := LoadStringFromFile(WizardDirValue() + '\' + fname, fhandle);
	if Result = True then
	begin
	 fhandle_uni := String(fhandle);
	 StringChangeEx(fhandle_uni, Orig, Moded, True);
	 Result := SaveStringToFile(WizardDirValue() + '\' + fname, AnsiString(fhandle_uni), False);
	end;
end;

// Get Component Index
function getIndex(Index: String; CM: Boolean): Integer;
begin
	if CM then
	begin
	 Result := WizardForm.ComponentsList.Items.IndexOf(CustomMessage(Index));
	 Exit
	end;
	Result := WizardForm.ComponentsList.Items.IndexOf(Index);
end;

procedure ComponentChanged(Index: Integer);
begin
	if CompPageModified then
	begin
	 changeDescription(Index);
	 changeImage(Index);
	 //FixComponents // It's done after pressing next
	end;
end;