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

unit GraphicF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, A3nalogGauge, StdCtrls;

type
  TGraphicFrame = class(TFrame)
    EngineSpeedGauge: TA3nalogGauge;
    VehicleSpeedGauge: TA3nalogGauge;
    CoolantTempGauge: TA3nalogGauge;
    BatteryVoltageGauge: TA3nalogGauge;
    AirflowSensorGauge: TA3nalogGauge;
    ThrottlePositionGauge: TA3nalogGauge;
    ManifoldPressureGauge: TA3nalogGauge;
    InjectorPulseWidthGauge: TA3nalogGauge;
    AtmosphericPressureGauge: TA3nalogGauge;
    O2AvgGauge: TA3nalogGauge;
    CoolantTempLabel: TLabel;
    BatteryVoltageLabel: TLabel;
    AirflowSensorLabel: TLabel;
    ThrottlePositionLabel: TLabel;
    ManifoldPressureLabel: TLabel;
    InjectorPulseWidthLabel: TLabel;
    AtmosphericPressureLabel: TLabel;
    O2AvgLabel: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
