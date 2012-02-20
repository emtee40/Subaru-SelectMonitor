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

unit VersionInfo;

interface

uses Windows, SysUtils, Forms;

procedure GetVersionString(var Version: String);
procedure GetVersionStringMin(var Version: String);
procedure GetVersionStringEx(var Version: String);

implementation

{ Get Version string NOT including build # }
procedure GetVersionString(var Version: String);
var
  InfoSize: Integer;
  Tmp: THandle;
  StrBuf, InfoBuf, VerBuf: Pointer;
  P: PChar;
begin
  Version := '';
  { get the version # from the exe }
  GetMem(StrBuf, 255);
  StrPCopy(StrBuf, Application.ExeName);
  InfoSize := GetFileVersionInfoSize(StrBuf, Tmp);
  GetMem(InfoBuf, InfoSize);
  GetFileVersionInfo(StrBuf, 0, InfoSize, InfoBuf);
  VerQueryValue(InfoBuf, '\\StringFileInfo\\040904E4\\FileVersion', VerBuf, Tmp);
  P := StrRScan(VerBuf, '.');       { don't show the build # }
  if P <> nil then begin
    P[0] := #0;
    Version := StrPas(VerBuf);  { save version # to string }
  end;
  FreeMem(InfoBuf);
  FreeMem(StrBuf);
end;

{ Get Version string NOT including build # or release # }
procedure GetVersionStringMin(var Version: String);
var
  InfoSize: Integer;
  Tmp: THandle;
  StrBuf, InfoBuf, VerBuf: Pointer;
  P: PChar;
begin
  Version := '';
  { get the version # from the exe }
  GetMem(StrBuf, 255);
  StrPCopy(StrBuf, Application.ExeName);
  InfoSize := GetFileVersionInfoSize(StrBuf, Tmp);
  GetMem(InfoBuf, InfoSize);
  GetFileVersionInfo(StrBuf, 0, InfoSize, InfoBuf);
  VerQueryValue(InfoBuf, '\\StringFileInfo\\040904E4\\FileVersion', VerBuf, Tmp);
  P := StrRScan(VerBuf, '.');       { don't show the build # }
  if P <> nil then begin
    P[0] := #0;
    P := StrRScan(VerBuf, '.');       { don't show the release # }
    if P <> nil then begin
      P[0] := #0;
      Version := StrPas(VerBuf);  { save version # to string }
    end;
  end;
  FreeMem(InfoBuf);
  FreeMem(StrBuf);
end;

{ Get full Version string including build # }
procedure GetVersionStringEx(var Version: String);
var
  InfoSize: Integer;
  Tmp: THandle;
  StrBuf, InfoBuf, VerBuf: Pointer;
begin
  { get the version # from the exe }
  GetMem(StrBuf, 255);
  StrPCopy(StrBuf, Application.ExeName);
  InfoSize := GetFileVersionInfoSize(StrBuf, Tmp);
  GetMem(InfoBuf, InfoSize);
  GetFileVersionInfo(StrBuf, 0, InfoSize, InfoBuf);
  VerQueryValue(InfoBuf, '\\StringFileInfo\\040904E4\\FileVersion', VerBuf, Tmp);
  Version := StrPas(VerBuf);  { save version # to string }
  FreeMem(InfoBuf);
  FreeMem(StrBuf);
end;

end.
