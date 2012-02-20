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

unit SelectMonitor;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, SelectMonitorX_TLB, StdVcl, SubyComm,
  SysUtils, IniFiles, Forms, Math;

type
  TString = String;
  TThreadEvent = procedure of object;
  TUpdaterThread = class(TThread)
  protected
    procedure Execute; override;
  public
    OnRun: TThreadEvent;
  end;
  PTParameter = ^TParameter;
  PTParameters = ^TParameters;
  TParametersArray = array [piBatteryVoltage..piBoostSolenoidDutyCycle] of TParameter;
  PTParametersArray = ^TParametersArray;

type
  TSelectMonitor = class(TAutoObject, ISelectMonitor)
  protected
    FSubyComm: TSubyComm;
    FConfigFile: TIniFile;
//    FParameters: array [piBatteryVoltage..piBoostSolenoidDutyCycle] of TParameter;
    FParameters: TParameters;
    FROMAddress: TString;
    Fid: TString;
    FECUName: TString;
    FFahrenheit: Boolean;
    FMPH: Boolean;
    FAtmosphericPressureUnits: Integer;
    FManifoldPressureUnits: Integer;
    FGraphicMode: Boolean;
    FAutoStart: Boolean;
    FUpdaterThread: TUpdaterThread;
    FIndex: Integer;
    FEvents: ISelectMonitorEvents;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    function HexToInt(Value: TString): Integer;
    procedure LoadParameter(var Parameter: TParameter; Name: TString; Index: ParameterIndex);
    procedure DataToValue(var Parameter: TParameter);
    procedure Run;
    function Open: WordBool; stdcall;
    function Close: WordBool; stdcall;
    function CheckOpen: WordBool;
    procedure Get_Port(out Value: Integer); stdcall;
    procedure Set_Port(var Value: Integer); stdcall;
    function ReadConfigFile: WordBool; stdcall;
    function GetROMAddress: Integer; stdcall;
    function Start: WordBool; stdcall;
    function Stop: WordBool; stdcall;
    procedure GetParameters(var Parameters: TParameters); stdcall;
  public
    constructor Create;
    destructor Destroy; override;
  end;

const
  UNUSED_ADDR = $0FFFFFFF;
  PRESSURE_UNITS: array[0..3] of String = ('PSI', 'Bar', 'mmHg', 'inHg');


implementation

uses ComServ, UnitConversions;

procedure TUpdaterThread.Execute;
begin
  while not Terminated do begin
    if Assigned(OnRun) then begin
      OnRun;
    end;
  end;
end;

constructor TSelectMonitor.Create;
begin
  inherited;
  FSubyComm := TSubyComm.Create(nil);
  FUpdaterThread := TUpdaterThread.Create(False);
  FROMAddress := '';
end;

destructor TSelectMonitor.Destroy;
begin
  Stop;
  Close;
  FUpdaterThread.OnRun := nil;
  FUpdaterThread.Free;
  FUpdaterThread := nil;
  FSubyComm.Free;
  FSubyComm := nil;
  inherited;
end;

procedure TSelectMonitor.EventSinkChanged(const EventSink: IUnknown);
begin
  { Here is a bit of a trick.  When windows destroys the control if first
    changes it's event sink map.  So if we want fo fire events before destruction
    we need to do it here...  }
  Stop;
  FEvents := EventSink as ISelectMonitorEvents;
end;

procedure TSelectMonitor.Get_Port(out Value: Integer);
begin
  Value := FSubyComm.Port;
end;

procedure TSelectMonitor.Set_Port(var Value: Integer);
begin
  FUpdaterThread.OnRun := nil;
  FSubyComm.Port := Value;
end;

function TSelectMonitor.Open: WordBool;
begin
  FSubyComm.Open;
  Result := FSubyComm.Enabled;
end;

function TSelectMonitor.Close: WordBool;
begin
  FUpdaterThread.OnRun := nil;
  FSubyComm.Stop;
  FSubyComm.Close;
  Result := not FSubyComm.Enabled;
end;

function TSelectMonitor.HexToInt(Value: TString): Integer;
var
  i, m: Integer;
begin
  Result := 0;
  m := 1;
  for i := Length(Value) downto 1 do begin
    if Value[i] in ['0'..'9'] then begin
      Result := Result + ((Byte(Value[i]) - 48) * m);
    end else if Value[i] in ['A'..'F'] then begin
      Result := Result + (((Byte(Value[i]) - 65) + 10) * m);
    end else if Value[i] in ['a'..'f'] then begin
      Result := Result + (((Byte(Value[i]) - 97) + 10) * m);
    end else begin
      // Return if invalid Hex string
      Result := UNUSED_ADDR;
      Break;
    end;
    m := m * 16;
  end;
end;

procedure TSelectMonitor.LoadParameter(var Parameter: TParameter; Name: TString; Index: ParameterIndex);
var
  m: Integer;
begin
  m := HexToInt(FConfigFile.ReadString(Fid, Name+'Address', 'none'));
  if m = UNUSED_ADDR then begin
    Parameter.Address := 0;
    Parameter.Enabled := False;
    Parameter.Scanned := False;
    Parameter.Visible := False;
  end else begin
    Parameter.Address := m;
    m := FConfigFile.ReadInteger(Fid, Name+'Mode', 1);
    Parameter.Enabled := (m > 0);
    Parameter.Scanned := (m = 1);
    Parameter.Visible := (m >= 0);
  end;
  Parameter.Data := 0;
  Parameter.Value := 0.0;
  Parameter.Name := PChar(Name);
  Parameter.Index := Index;
end;

procedure TSelectMonitor.DataToValue(var Parameter: TParameter);
begin
  case Parameter.Index of
    piBatteryVoltage: Parameter.Value := Parameter.Data * 0.08;
    piVehicleSpeed: begin
        Parameter.Value := Parameter.Data * 2;
        if FMPH then
          Parameter.Value := KMH2MPH(Parameter.Value);
      end;
    piEngineSpeed: Parameter.Value := Parameter.Data * 25;
    piCoolantTemp: begin
        Parameter.Value := (Parameter.Data - 50);
        if FFahrenheit then
          Parameter.Value := Celsius2Fahrenheit(Parameter.Value);
      end;
    piIgnitionAdvance: Parameter.Value := Parameter.Data;
    piAirflowSensor: Parameter.Value := Parameter.Data * 5 / 256;
    piEngineLoad: Parameter.Value := Parameter.Data;
    piThrottlePosition: Parameter.Value := Parameter.Data * 5 / 256;
    piInjectorPulseWidth: Parameter.Value := Parameter.Data * 256 / 1000;
    piISUDutyValve: Parameter.Value := Parameter.Data * 100 / 256;
    piO2Average: Parameter.Value := Parameter.Data * 5000 / 512;
    piO2Minimum: Parameter.Value := Parameter.Data * 5000 / 256;
    piO2Maximum: Parameter.Value := Parameter.Data * 5000 / 256;
    piKnockCorrection: Parameter.Value := Parameter.Data;
    piAFCorrection: Parameter.Value := (Parameter.Data - 128);
    piAtmosphericPressure: begin
        Parameter.Value := Parameter.Data * 8;
        if FAtmosphericPressureUnits = 0 then
          Parameter.Value := mmHg2Psi(Parameter.Value);
        if FAtmosphericPressureUnits = 1 then
          Parameter.Value := mmHg2Bar(Parameter.Value);
        if FAtmosphericPressureUnits = 3 then
          Parameter.Value := mmHg2inHg(Parameter.Value);
      end;
    piManifoldPressure: begin
        Parameter.Value := (Parameter.Data - 128) / 85;
        if FManifoldPressureUnits = 0 then
          Parameter.Value := Bar2Psi(Parameter.Value);
        if FManifoldPressureUnits = 2 then
          Parameter.Value := Bar2mmHg(Parameter.Value);
        if FManifoldPressureUnits = 3 then
          Parameter.Value := Bar2inHg(Parameter.Value);
      end;
    piBoostSolenoidDutyCycle: Parameter.Value := Parameter.Data * 100 / 256;
  end;
end;

function TSelectMonitor.ReadConfigFile: WordBool;
var
  Secs: TStringList;
begin
  FConfigFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+'SelectMonitor.ini');
  FSubyComm.Port := FConfigFile.ReadInteger('Options', 'CommPort', 1);
  FFahrenheit := FConfigFile.ReadBool('Options', 'Fahrenheit', True);
  FMPH := FConfigFile.ReadBool('Options', 'MPH', True);
  FAtmosphericPressureUnits := FConfigFile.ReadInteger('Options', 'AtmosphericPressureUnits', 0);
  FAtmosphericPressureUnits := Min(Length(PRESSURE_UNITS)-1, FAtmosphericPressureUnits);
  FAtmosphericPressureUnits := Max(0, FAtmosphericPressureUnits);
//  AtmosphericPressureUnitsLabel.Caption := PRESSURE_UNITS[AtmosphericPressureUnits];
  FManifoldPressureUnits := FConfigFile.ReadInteger('Options', 'ManifoldPressureUnits', 0);
  FManifoldPressureUnits := Min(Length(PRESSURE_UNITS)-1, FManifoldPressureUnits);
  FManifoldPressureUnits := Max(0, FManifoldPressureUnits);
//  ManifoldPressureUnitsLabel.Caption := PRESSURE_UNITS[ManifoldPressureUnits];
  FGraphicMode := FConfigFile.ReadBool('Options', 'GraphicMode', False);
  FAutoStart := FConfigFile.ReadBool('Options', 'AutoStart', False);

  Result := True;
  Fid := FROMAddress;
  Secs := TStringList.Create;
  FConfigFile.ReadSection(Fid, Secs);
  // No ROM ID section found?
  if Secs.Count = 0 then begin
    Fid := Copy(Fid, 1, 4);   // Try only the first 16 bits of the ROM ID
    Secs.Clear;
    FConfigFile.ReadSection(Fid, Secs);
    if Secs.Count = 0 then begin
      Result := False;
    end;
  end;
  Secs.Free;
  if Result then begin
    FECUName := FConfigFile.ReadString(Fid, 'Name', '');
    LoadParameter(FParameters.BatteryVoltage, 'BatteryVoltage', piBatteryVoltage);
    LoadParameter(FParameters.VehicleSpeed, 'VehicleSpeed', piVehicleSpeed);
    LoadParameter(FParameters.EngineSpeed, 'EngineSpeed', piEngineSpeed);
    LoadParameter(FParameters.CoolantTemp, 'CoolantTemp', piCoolantTemp);
    LoadParameter(FParameters.IgnitionAdvance, 'IgnitionAdvance', piIgnitionAdvance);
    LoadParameter(FParameters.AirflowSensor, 'AirflowSensor', piAirflowSensor);
    LoadParameter(FParameters.EngineLoad, 'EngineLoad', piEngineLoad);
    LoadParameter(FParameters.ThrottlePosition, 'ThrottlePosition', piThrottlePosition);
    LoadParameter(FParameters.InjectorPulseWidth, 'InjectorPulseWidth', piInjectorPulseWidth);
    LoadParameter(FParameters.ISUDutyValve, 'ISUDutyValve', piISUDutyValve);
    LoadParameter(FParameters.O2Average, 'O2Average', piO2Average);
    LoadParameter(FParameters.O2Minimum, 'O2Minimum', piO2Minimum);
    LoadParameter(FParameters.O2Maximum, 'O2Maximum', piO2Maximum);
    LoadParameter(FParameters.KnockCorrection, 'KnockCorrection', piKnockCorrection);
    LoadParameter(FParameters.AFCorrection, 'AFCorrection', piAFCorrection);
    LoadParameter(FParameters.AtmosphericPressure, 'AtmosphericPressure', piAtmosphericPressure);
    LoadParameter(FParameters.ManifoldPressure, 'ManifoldPressure', piManifoldPressure);
    LoadParameter(FParameters.BoostSolenoidDutyCycle, 'BoostSolenoidDutyCycle', piBoostSolenoidDutyCycle);
(*
    LoadParameter(PTParametersArray(@FParameters)[piBatteryVoltage], 'BatteryVoltage', piBatteryVoltage);
    LoadParameter(FParameters[piBatteryVoltage], 'BatteryVoltage', piBatteryVoltage);
    LoadParameter(FParameters[piVehicleSpeed], 'VehicleSpeed', piVehicleSpeed);
    LoadParameter(FParameters[piEngineSpeed], 'EngineSpeed', piEngineSpeed);
    LoadParameter(FParameters[piCoolantTemp], 'CoolantTemp', piCoolantTemp);
    LoadParameter(FParameters[piIgnitionAdvance], 'IgnitionAdvance', piIgnitionAdvance);
    LoadParameter(FParameters[piAirflowSensor], 'AirflowSensor', piAirflowSensor);
    LoadParameter(FParameters[piEngineLoad], 'EngineLoad', piEngineLoad);
    LoadParameter(FParameters[piThrottlePosition], 'ThrottlePosition', piThrottlePosition);
    LoadParameter(FParameters[piInjectorPulseWidth], 'InjectorPulseWidth', piInjectorPulseWidth);
    LoadParameter(FParameters[piISUDutyValve], 'ISUDutyValve', piISUDutyValve);
    LoadParameter(FParameters[piO2Average], 'O2Average', piO2Average);
    LoadParameter(FParameters[piO2Minimum], 'O2Minimum', piO2Minimum);
    LoadParameter(FParameters[piO2Maximum], 'O2Maximum', piO2Maximum);
    LoadParameter(FParameters[piKnockCorrection], 'KnockCorrection', piKnockCorrection);
    LoadParameter(FParameters[piAFCorrection], 'AFCorrection', piAFCorrection);
    LoadParameter(FParameters[piAtmosphericPressure], 'AtmosphericPressure', piAtmosphericPressure);
    LoadParameter(FParameters[piManifoldPressure], 'ManifoldPressure', piManifoldPressure);
    LoadParameter(FParameters[piBoostSolenoidDutyCycle], 'BoostSolenoidDutyCycle', piBoostSolenoidDutyCycle);
*)
  end;
  FConfigFile.Free;
end;

function TSelectMonitor.CheckOpen: WordBool;
begin
  Result := FSubyComm.Enabled;
  if not Result then
    Result := Open;
end;

function TSelectMonitor.GetROMAddress: Integer;
begin
  if CheckOpen then begin
    FROMAddress := FSubyComm.GetId;
    ReadConfigFile;
  end else begin
    FROMAddress := '';
  end;
  Result := HexToInt(FROMAddress);
end;

function TSelectMonitor.Start: WordBool;
begin
  Result := CheckOpen;
  if Result then begin
    if Length(FROMAddress) = 0 then
      GetROMAddress;
    Result := Length(FROMAddress) <> 0;
    if Result then begin
      FIndex := piBatteryVoltage;
      FUpdaterThread.OnRun := Run;
    end;
  end;
end;

function TSelectMonitor.Stop: WordBool;
begin
  Result := Close;
end;

procedure TSelectMonitor.Run;
var
  Parameter: PTParameter;
begin
  Parameter := @PTParametersArray(@FParameters)[FIndex];
  if Parameter.Scanned then begin
    Parameter.Data := FSubyComm.ReadAddress(Parameter.Address);
    DataToValue(Parameter^);
    // Execute the event
    if Assigned(FEvents) then
      FEvents.OnParameterRead(Parameter^);
  end else begin
    Parameter.Data := 0;
    Parameter.Value := 0.0;
  end;
  Inc(FIndex);
  if FIndex > piBoostSolenoidDutyCycle then
    FIndex := piBatteryVoltage;
end;

procedure TSelectMonitor.GetParameters(var Parameters: TParameters);
begin
  Parameters := FParameters;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSelectMonitor, Class_SelectMonitor,
    ciSingleInstance, tmApartment);
end.
