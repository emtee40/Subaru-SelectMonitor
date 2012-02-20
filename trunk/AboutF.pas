(*
  Copyright 2006-2012 Kevin Frank syncro@vwrx.com

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)

unit AboutF;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, VersionInfo, ShellAPI;

type
  TAboutForm = class(TForm)
    Panel1: TPanel;
    NameLabel: TLabel;
    VersionLabel: TLabel;
    OKButton: TButton;
    URLLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure URLLabelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.dfm}

procedure TAboutForm.FormCreate(Sender: TObject);
var
  VerStr: String;
begin
  if Pos('dump', LowerCase(Application.ExeName)) <> 0 then begin
    NameLabel.Caption := 'VWRX Select Monitor Dump Utility';
  end else begin
    NameLabel.Caption := 'VWRX Select Monitor Utility';
  end;
  GetVersionString(VerStr);
  VersionLabel.Caption := 'Version '+VerStr;
end;

procedure TAboutForm.URLLabelClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.vwrx.com', nil, nil, SW_RESTORE);
end;

end.
 
