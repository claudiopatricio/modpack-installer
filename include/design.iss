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
procedure ChangeLocationDir(Sender: TObject);
begin
	WizardForm.DirEdit.Text := InstallDirArray[SelectServerCombo.ItemIndex];
end;

procedure RedesignLocationPage();
var
  SelectServerLabel: TLabel;
  I: Integer;
begin
  if InstallFound = True then
  begin;
		SelectServerLabel := TLabel.Create(WizardForm);
		SelectServerLabel.Parent := WizardForm.SelectDirPage;
		SelectServerLabel.Left := 0;
		SelectServerLabel.Top := 120;
		SelectServerLabel.Caption := 'Select Server: ';

		SelectServerCombo := TNewComboBox.Create(WizardForm);
		SelectServerCombo.Parent := WizardForm.SelectDirPage;
		SelectServerCombo.Left := SelectServerLabel.Left + SelectServerLabel.Width + 2;
		SelectServerCombo.Top := SelectServerLabel.Top - 1;
		SelectServerCombo.Width := 250;
		//SelectServerCombo.Height := 200;
		SelectServerCombo.Style := csDropDownList;
		SelectServerCombo.OnChange := @ChangeLocationDir;
		for I := 0 to GetArrayLength(ServersNamesArray)-1 do
		begin
			SelectServerCombo.Items.Add(ServersNamesArray[I]);
		end;
		if SelectServerComboDefault <> -1 then
		begin;
			SelectServerCombo.ItemIndex := SelectServerComboDefault;
		end;
	end
end;

procedure CheckLocationPage(CurPageID: Integer);
begin
  if CurpageID = wpSelectDir then
  begin;
    //MsgBox('TEST', mbError, MB_OK);
  end
end;

// ------------------- CODE TO CHANGE COMPONENTS WINDOW HEIGHT -------------------
//
// There is another way to do this, without saving all original values, we can simple
// change the current value with +offset and then go to original with -offset...
// It would be less code, but possible worst for future additional implementations.
//
// --------------------------------------------------------------------------------
var
  CompPagePositions: TPositionStorage;
  CompAddDescription: TLabel;
  ImageShow: TForm;
  ImageId: Longint;
  ImageName: String;
  DonateButton: TNewButton;
  URLLabel: TNewStaticText;
  VersionLabel: TNewStaticText;

// Save Form positions and height (Any button or label added, needs to be added here)
procedure SaveComponentsPage(out Storage: TPositionStorage);
begin
  SetArrayLength(Storage, 14);

  Storage[0] := WizardForm.Height;
  Storage[1] := WizardForm.NextButton.Top;
  Storage[2] := WizardForm.BackButton.Top;
  Storage[3] := WizardForm.CancelButton.Top;
  Storage[4] := WizardForm.ComponentsList.Height;
  Storage[5] := WizardForm.OuterNotebook.Height;
  Storage[6] := WizardForm.InnerNotebook.Height;
  Storage[7] := WizardForm.Bevel.Top;
  Storage[8] := WizardForm.BeveledLabel.Top;
  Storage[9] := WizardForm.ComponentsDiskSpaceLabel.Top;
  Storage[10] := WizardForm.Top;
  Storage[11] := DonateButton.Top;
  Storage[12] := URLLabel.Top;
  Storage[13] := VersionLabel.Top;
end;

// Change the height of the Form and
procedure LoadComponentsPage(const Storage: TPositionStorage; HeightOffset: Integer);
begin
  if GetArrayLength(Storage) <> 14 then // Just to be sure is not fucked up
    RaiseException('Invalid storage array length.');

  WizardForm.Height := Storage[0] + HeightOffset;
  WizardForm.NextButton.Top := Storage[1] + HeightOffset;
  WizardForm.BackButton.Top := Storage[2] + HeightOffset;
  WizardForm.CancelButton.Top := Storage[3] + HeightOffset;
  WizardForm.ComponentsList.Height := Storage[4] + HeightOffset;
  WizardForm.OuterNotebook.Height := Storage[5] + HeightOffset;
  WizardForm.InnerNotebook.Height := Storage[6] + HeightOffset;
  WizardForm.Bevel.Top := Storage[7] + HeightOffset;
  WizardForm.BeveledLabel.Top := Storage[8] + HeightOffset;
  WizardForm.ComponentsDiskSpaceLabel.Top := Storage[9] + HeightOffset;
  WizardForm.Top := Storage[10] - (HeightOffset / 2);
  DonateButton.Top := Storage[11] + HeightOffset;
  URLLabel.Top := Storage[12] + HeightOffset;
  VersionLabel.Top := Storage[13] + HeightOffset;
end;

// Check if we are in the Components Page and change it
procedure CheckComponentsPage(CurPageID: Integer);
begin
  if CurpageID = wpSelectComponents then // When page is "Components"
  begin;
    SaveComponentsPage(CompPagePositions); // Save old settings
    LoadComponentsPage(CompPagePositions, ScaleY(250)); // New height offset
    CompPageModified := True; // Set flag the page settings were modified

    // Add additional description
    CompAddDescription := TLabel.Create(WizardForm);
    CompAddDescription.Parent := WizardForm.SelectComponentsPage;
    CompAddDescription.Left := WizardForm.ComponentsList.Left;
    CompAddDescription.Width := WizardForm.ComponentsList.Width;
    CompAddDescription.Height := ScaleY(80);
    CompAddDescription.Top := WizardForm.ComponentsList.Top + WizardForm.ComponentsList.Height - CompAddDescription.Height;
    CompAddDescription.AutoSize := False;
    CompAddDescription.WordWrap := True;
    WizardForm.ComponentsList.Height := WizardForm.ComponentsList.Height - CompAddDescription.Height - ScaleY(5);
    CompAddDescription.Caption := '';

    // Add Form to show image
    ImageShow := TForm.Create(WizardForm);
    ImageShow.BorderIcons := [biSystemMenu]; // Only show close button
    //ImageShow.BorderStyle := bsSingle;
    //ImageShow.Parent := WizardForm.SelectComponentsPage;
    ImageShow.Width := 450;
    ImageShow.Height := 450;

    (* Only works for bitmaps (.bmp)
    Image:=TBitmapImage.Create(ImageShow)
    Image.Autosize:=True
    Image.Enabled:=False
    Image.Bitmap.LoadFromFile(ExpandConstant('{tmp}\OTM.jpg'))
    Image.Parent:=ImageShow
    *)

    setImage('no-image-available.png', '', false); // Default image
    ImageShow.Show();

  end
  else
    if CompPageModified then // When page isn't "Components"
    begin
      LoadComponentsPage(CompPagePositions, 0); // Load page with height offset 0
      CompPageModified := False; // Set flag the page settings are the original ones
      ImageShow.Hide; // Hide ImageShow
    end;
end;  

procedure Donate(Sender: TObject);
var
  ErrorCode: Integer;
begin
  ShellExecAsOriginalUser('open', '{#DonateURL}', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

procedure OpenWebsite(Sender: TObject);
var
  ErrorCode: Integer;
begin
  ShellExecAsOriginalUser('open', '{#SetupSetting("AppPublisherURL")}', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

procedure RedesignMain;
begin
  DonateButton := TNewButton.Create(MainForm);
  with DonateButton do
  begin
    Parent := WizardForm; 
    Left := ScaleX(8);
    Top := ScaleY(327);
    Width := ScaleX(75);
    Height := ScaleY(23);
    Caption := 'Donate';
    OnClick := @Donate
  end;

  DonateButton.TabOrder := 5;

  URLLabel := TNewStaticText.Create(WizardForm);
  with URLLabel do
  begin
    Parent := WizardForm;
    Caption := 'Homepage';
    Cursor := crHand;
    OnClick := @OpenWebsite;
    Font.Style := Font.Style + [fsUnderline];
    if GetWindowsVersion >= $040A0000 then   { Windows 98 or later? }
      Font.Color := clHotLight
    else
      Font.Color := clBlue;
    Top := DonateButton.Top + DonateButton.Height - Height - 2;
    Left := DonateButton.Left + DonateButton.Width + ScaleX(14);
  end;

  VersionLabel := TNewStaticText.Create(WizardForm);
  with VersionLabel do
  begin
    Parent := WizardForm;
    Left := ScaleX(0);
    Top := ScaleY(306);
    Width := ScaleX(75);
    Height := ScaleY(23);
    Caption := '{#SetupSetting("AppVersion")}';
  end;
end;