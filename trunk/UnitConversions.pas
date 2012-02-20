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

unit UnitConversions;

interface

function KMH2MPH(Value: Extended): Extended;
function Celsius2Fahrenheit(Value: Extended): Extended;
function mmHg2Psi(Value: Extended): Extended;
function mmHg2Bar(Value: Extended): Extended;
function mmHg2inHg(Value: Extended): Extended;
function Bar2Psi(Value: Extended): Extended;
function Bar2mmHg(Value: Extended): Extended;
function Bar2inHg(Value: Extended): Extended;

implementation

function KMH2MPH(Value: Extended): Extended;
begin
  Result := Value * 0.6213712;
end;

function Celsius2Fahrenheit(Value: Extended): Extended;
begin
  Result := ((Value * 9.0)/5.0)+32.0;
end;

function mmHg2Psi(Value: Extended): Extended;
begin
  Result := Value * 0.01934;
end;

function mmHg2Bar(Value: Extended): Extended;
begin
  Result := Value * 0.0013328;
end;

function mmHg2inHg(Value: Extended): Extended;
begin
  Result := Value * 0.03937;
end;

function Bar2Psi(Value: Extended): Extended;
begin
  Result := Value * 14.503861;
end;

function Bar2mmHg(Value: Extended): Extended;
begin
  Result := Value * 750.2838;
end;

function Bar2inHg(Value: Extended): Extended;
begin
  Result := Value * 29.54;
end;

end.
