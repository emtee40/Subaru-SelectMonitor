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

program SelectMonitor;

uses
  Forms,
  SubyComm in 'SubyComm.pas',
  MainF in 'MainF.pas' {MainForm},
  GraphicF in 'GraphicF.pas' {GraphicFrame: TFrame},
  AboutF in 'AboutF.pas' {AboutForm},
  UnitConversions in 'UnitConversions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Select Monitor';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
