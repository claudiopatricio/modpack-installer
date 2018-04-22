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
Source: "bin\7z.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall dontcopy
Source: "bin\7z.dll"; DestDir: "{tmp}"; Flags: deleteafterinstall dontcopy
Source: "images.7z"; DestDir: "{tmp}"; Flags: deleteafterinstall dontcopy

[Code]
// Extract Images for Component Preview
procedure ExtractImages();
var
  ResultCode: integer;
begin
  ExtractTemporaryFile('7z.exe');
  ExtractTemporaryFile('7z.dll');
  ExtractTemporaryFile('images.7z');
  ExecAsOriginalUser(ExpandConstant('{tmp}\7z.exe'), 'e images.7z', ExpandConstant('{tmp}'), SW_HIDE, ewNoWait, ResultCode);
end;

// Here you set the image for each mod
procedure changeImage(Index: Integer);
begin
  case Index of
    getIndex('mods', True): setImage('no-image-available.png', 'mods', True);

    // Note CM For XVM PP
    getIndex('mods_mymod', True): setImage('no-image-available.png', 'mods_mymod', True);
  else
    setImage('no-image-available.png', '', false);
  end;

end;


// Change the image in component preview
procedure setImage(fname: String; title: String; CM: Boolean);
begin
  if ImageName <> fname then // Check if image changes
  begin
    if ImageId <> 0 then
    ImgRelease(ImageId);
    ImageId:=ImgLoad(ImageShow.Handle, ExpandConstant('{tmp}')+'\'+fname, 0, 0, 450, 405, True, False);
    ImgApplyChanges(ImageShow.Handle);
    ImageName := fname;
  end;

  if CM then
    ImageShow.Caption := CustomMessage(title)
  else
    ImageShow.Caption := title;


  ImageShow.Top := WizardForm.Top - 5;

  if WizardForm.Left + WizardForm.Width + ImageShow.Width + 6 < ScreenWidth then
    ImageShow.Left := WizardForm.Left + WizardForm.Width + 6
  else if WizardForm.Left - ImageShow.Width - 6 > 0 then
    ImageShow.Left := WizardForm.Left - ImageShow.Width - 6
  else
    ImageShow.Left := (ScreenWidth - ImageShow.Width) div 2;
end;
