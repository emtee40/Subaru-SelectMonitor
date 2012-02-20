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

unit MainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SubyComm, StdCtrls, ExtCtrls, ComCtrls, Mask, IniFiles,GraphicF,
  Menus, Math;

type
  TUpdaterThread = class(TThread)
  private
  protected
    procedure Execute; override;
  end;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    StartBtn: TButton;
    IDLabel: TLabel;
    Label1: TLabel;
    BatteryVoltagePanel: TPanel;
    VehicleSpeedPanel: TPanel;
    BatteryVoltageBox: TCheckBox;
    BatteryVoltageEdit: TEdit;
    Label19: TLabel;
    BatteryVoltageBar: TProgressBar;
    VehicleSpeedBox: TCheckBox;
    VehicleSpeedEdit: TEdit;
    SpeedLabel: TLabel;
    VehicleSpeedBar: TProgressBar;
    EngineSpeedPanel: TPanel;
    EngineSpeedBox: TCheckBox;
    EngineSpeedEdit: TEdit;
    Label21: TLabel;
    EngineSpeedBar: TProgressBar;
    CoolantTempPanel: TPanel;
    IgnitionAdvancePanel: TPanel;
    AirflowSensorPanel: TPanel;
    CoolantTempBox: TCheckBox;
    CoolantTempEdit: TEdit;
    DegLabel: TLabel;
    CoolantTempBar: TProgressBar;
    IgnitionAdvanceBox: TCheckBox;
    IgnitionAdvanceEdit: TEdit;
    Label23: TLabel;
    IgnitionAdvanceBar: TProgressBar;
    EngineLoadPanel: TPanel;
    ThrottlePositionPanel: TPanel;
    InjectorPulseWidthPanel: TPanel;
    ISUDutyValvePanel: TPanel;
    O2AvgPanel: TPanel;
    O2MinPanel: TPanel;
    AirflowSensorBox: TCheckBox;
    AirflowSensorEdit: TEdit;
    Label24: TLabel;
    AirflowSensorBar: TProgressBar;
    EngineLoadBox: TCheckBox;
    EngineLoadEdit: TEdit;
    EngineLoadBar: TProgressBar;
    ThrottlePositionBox: TCheckBox;
    ThrottlePositionEdit: TEdit;
    Label25: TLabel;
    ThrottlePositionBar: TProgressBar;
    InjectorPulseWidthBox: TCheckBox;
    InjectorPulseWidthEdit: TEdit;
    Label26: TLabel;
    InjectorPulseWidthBar: TProgressBar;
    ISUDutyValveBox: TCheckBox;
    ISUDutyValveEdit: TEdit;
    Label27: TLabel;
    ISUDutyValveBar: TProgressBar;
    O2AvgBox: TCheckBox;
    O2AvgEdit: TEdit;
    Label28: TLabel;
    O2AvgBar: TProgressBar;
    O2MaxPanel: TPanel;
    KnockCorrectionPanel: TPanel;
    AFCorrectionPanel: TPanel;
    O2MinBox: TCheckBox;
    O2MinEdit: TEdit;
    Label29: TLabel;
    O2MinBar: TProgressBar;
    O2MaxBox: TCheckBox;
    O2MaxEdit: TEdit;
    Label30: TLabel;
    O2MaxBar: TProgressBar;
    KnockCorrectionBox: TCheckBox;
    KnockCorrectionEdit: TEdit;
    Label31: TLabel;
    KnockCorrectionBar: TProgressBar;
    AFCorrectionBox: TCheckBox;
    AFCorrectionEdit: TEdit;
    AFCorrectionBar: TProgressBar;
    ManifoldPressurePanel: TPanel;
    BoostSolenoidDutyCyclePanel: TPanel;
    AtmosphericPressurePanel: TPanel;
    AtmosphericPressureBox: TCheckBox;
    AtmosphericPressureEdit: TEdit;
    AtmosphericPressureUnitsLabel: TLabel;
    AtmosphericPressureBar: TProgressBar;
    ManifoldPressureBox: TCheckBox;
    ManifoldPressureEdit: TEdit;
    ManifoldPressureUnitsLabel: TLabel;
    ManifoldPressureBar: TProgressBar;
    BoostSolenoidDutyCycleBox: TCheckBox;
    BoostSolenoidDutyCycleEdit: TEdit;
    Label35: TLabel;
    BoostSolenoidDutyCycleBar: TProgressBar;
    StatusBar1: TStatusBar;
    Label32: TLabel;
    GraphicBtn: TButton;
    ECULabel: TLabel;
    PopupMenu1: TPopupMenu;
    About1: TMenuItem;
    GraphicFrame1: TGraphicFrame;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartBtnClick(Sender: TObject);
    procedure BatteryVoltageBoxClick(Sender: TObject);
    procedure VehicleSpeedBoxClick(Sender: TObject);
    procedure EngineSpeedBoxClick(Sender: TObject);
    procedure CoolantTempBoxClick(Sender: TObject);
    procedure IgnitionAdvanceBoxClick(Sender: TObject);
    procedure AirflowSensorBoxClick(Sender: TObject);
    procedure EngineLoadBoxClick(Sender: TObject);
    procedure ThrottlePositionBoxClick(Sender: TObject);
    procedure InjectorPulseWidthBoxClick(Sender: TObject);
    procedure ISUDutyValveBoxClick(Sender: TObject);
    procedure O2AvgBoxClick(Sender: TObject);
    procedure O2MinBoxClick(Sender: TObject);
    procedure O2MaxBoxClick(Sender: TObject);
    procedure KnockCorrectionBoxClick(Sender: TObject);
    procedure AFCorrectionBoxClick(Sender: TObject);
    procedure AtmosphericPressureBoxClick(Sender: TObject);
    procedure ManifoldPressureBoxClick(Sender: TObject);
    procedure BoostSolenoidDutyCycleBoxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GraphicBtnClick(Sender: TObject);
    procedure StatusBar1DblClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure About1Click(Sender: TObject);
  private
    { Private declarations }
    SubyAddresses: TSubyAddresses;
    CurrentId: String;
    UpdaterThread: TUpdaterThread;
    ConfigFile: TIniFile;
    Fahrenheit: Boolean;
    MPH: Boolean;
    FirstPaint: Boolean;
    AtmosphericPressureUnits: Integer;
    ManifoldPressureUnits: Integer;
    Logging: Boolean;
    LogRawData: Boolean;
    LogFile: TFileStream;
    LogFieldSep: Char;
    LogOverwrite: Boolean;
    procedure WriteLogHeader;
    procedure LoadECUInfo;
    function HexToInt(Value: String): Integer;
  public
    { Public declarations }
    Aborted: Boolean;
    Suby: TSubyComm;
    procedure UpdateValues;
  end;

var
  MainForm: TMainForm;

const
  UNUSED_ADDR = $0FFFFFFF;
  EDITON_COLOR = clWhite;
  EDITREAD_COLOR = clYellow;
  EDITOFF_COLOR = clBtnFace;
  PRESSURE_UNITS: array[0..3] of String = ('PSI', 'Bar', 'mmHg', 'inHg');

implementation

uses AboutF, UnitConversions;

{$R *.dfm}

procedure TUpdaterThread.Execute;
begin
  while not Terminated do begin
    if (not MainForm.Aborted) and MainForm.Suby.Enabled then begin
      MainForm.UpdateValues;
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Logging := False;
  Aborted := True;
  UpdaterThread := TUpdaterThread.Create(False);
  Suby := TSubyComm.Create(Self);
  ConfigFile := TIniFile.Create(ChangeFileExt( Application.ExeName, '.ini' ) );
  FirstPaint := True;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  UpdaterThread.Free;
  UpdaterThread := nil;
  ConfigFile.Free;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Aborted then
    StartBtnClick(Sender);
  Suby.Stop;
end;

function TMainForm.HexToInt(Value: String): Integer;
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

procedure TMainForm.LoadECUInfo;
var
  m: Integer;
begin
  ECULabel.Caption := ConfigFile.ReadString(CurrentId, 'Name', '');

  m := ConfigFile.ReadInteger(CurrentId, 'BatteryVoltageMode', 1);
  BatteryVoltageBox.Enabled := (m > 0);
  BatteryVoltageBox.Checked := (m = 1);
  BatteryVoltagePanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'BatteryVoltageAddress', 'none'));
  if m = UNUSED_ADDR then begin
    BatteryVoltageBox.Enabled := False;
    BatteryVoltageBox.Checked := False;
    BatteryVoltagePanel.Visible := False;
    SubyAddresses[spBatteryVoltage] := 0;
  end else begin
    SubyAddresses[spBatteryVoltage] := m;
  end;

  m := ConfigFile.ReadInteger(CurrentId, 'VehicleSpeedMode', 1);
  VehicleSpeedBox.Enabled := (m > 0);
  VehicleSpeedBox.Checked := (m = 1);
  VehicleSpeedPanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'VehicleSpeedAddress', 'none'));
  if m = UNUSED_ADDR then begin
    VehicleSpeedBox.Enabled := False;
    VehicleSpeedBox.Checked := False;
    VehicleSpeedPanel.Visible := False;
    SubyAddresses[spVehicleSpeed] := 0;
  end else begin
    SubyAddresses[spVehicleSpeed] := m;
  end;

  m := ConfigFile.ReadInteger(CurrentId, 'EngineSpeedMode', 1);
  EngineSpeedBox.Enabled := (m > 0);
  EngineSpeedBox.Checked := (m = 1);
  EngineSpeedPanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'EngineSpeedAddress', 'none'));
  if m = UNUSED_ADDR then begin
    EngineSpeedBox.Enabled := False;
    EngineSpeedBox.Checked := False;
    EngineSpeedPanel.Visible := False;
    SubyAddresses[spEngineSpeed] := 0;
  end else begin
    SubyAddresses[spEngineSpeed] := m;
  end;

  m := ConfigFile.ReadInteger(CurrentId, 'CoolantTempMode', 1);
  CoolantTempBox.Enabled := (m > 0);
  CoolantTempBox.Checked := (m = 1);
  CoolantTempPanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'CoolantTempAddress', 'none'));
  if m = UNUSED_ADDR then begin
    CoolantTempBox.Enabled := False;
    CoolantTempBox.Checked := False;
    CoolantTempPanel.Visible := False;
    SubyAddresses[spCoolantTemp] := 0;
  end else begin
    SubyAddresses[spCoolantTemp] := m;
  end;

  m := ConfigFile.ReadInteger(CurrentId, 'IgnitionAdvanceMode', 1);
  IgnitionAdvanceBox.Enabled := (m > 0);
  IgnitionAdvanceBox.Checked := (m = 1);
  IgnitionAdvancePanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'IgnitionAdvanceAddress', 'none'));
  if m = UNUSED_ADDR then begin
    IgnitionAdvanceBox.Enabled := False;
    IgnitionAdvanceBox.Checked := False;
    IgnitionAdvancePanel.Visible := False;
    SubyAddresses[spIgnitionAdvance] := 0;
  end else begin
    SubyAddresses[spIgnitionAdvance] := m;
  end;

  m := ConfigFile.ReadInteger(CurrentId, 'AirflowSensorMode', 1);
  AirflowSensorBox.Enabled := (m > 0);
  AirflowSensorBox.Checked := (m = 1);
  AirflowSensorPanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'AirflowSensorAddress', 'none'));
  if m = UNUSED_ADDR then begin
    AirflowSensorBox.Enabled := False;
    AirflowSensorBox.Checked := False;
    AirflowSensorPanel.Visible := False;
    SubyAddresses[spAirflowSensor] := 0;
  end else begin
    SubyAddresses[spAirflowSensor] := m;
  end;

  m := ConfigFile.ReadInteger(CurrentId, 'EngineLoadMode', 1);
  EngineLoadBox.Enabled := (m > 0);
  EngineLoadBox.Checked := (m = 1);
  EngineLoadPanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'EngineLoadAddress', 'none'));
  if m = UNUSED_ADDR then begin
    EngineLoadBox.Enabled := False;
    EngineLoadBox.Checked := False;
    EngineLoadPanel.Visible := False;
    SubyAddresses[spEngineLoad] := 0;
  end else begin
    SubyAddresses[spEngineLoad] := m;
  end;

  m := ConfigFile.ReadInteger(CurrentId, 'ThrottlePositionMode', 1);
  ThrottlePositionBox.Enabled := (m > 0);
  ThrottlePositionBox.Checked := (m = 1);
  ThrottlePositionPanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'ThrottlePositionAddress', 'none'));
  if m = UNUSED_ADDR then begin
    ThrottlePositionBox.Enabled := False;
    ThrottlePositionBox.Checked := False;
    ThrottlePositionPanel.Visible := False;
    SubyAddresses[spThrottlePosition] := 0;
  end else begin
    SubyAddresses[spThrottlePosition] := m;
  end;

  m := ConfigFile.ReadInteger(CurrentId, 'InjectorPulseWidthMode', 1);
  InjectorPulseWidthBox.Enabled := (m > 0);
  InjectorPulseWidthBox.Checked := (m = 1);
  InjectorPulseWidthPanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'InjectorPulseWidthAddress', 'none'));
  if m = UNUSED_ADDR then begin
    InjectorPulseWidthBox.Enabled := False;
    InjectorPulseWidthBox.Checked := False;
    InjectorPulseWidthPanel.Visible := False;
    SubyAddresses[spInjectorPulseWidth] := 0;
  end else begin
    SubyAddresses[spInjectorPulseWidth] := m;
  end;

  m := ConfigFile.ReadInteger(CurrentId, 'ISUDutyValveMode', 1);
  ISUDutyValveBox.Enabled := (m > 0);
  ISUDutyValveBox.Checked := (m = 1);
  ISUDutyValvePanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'ISUDutyValveAddress', 'none'));
  if m = UNUSED_ADDR then begin
    ISUDutyValveBox.Enabled := False;
    ISUDutyValveBox.Checked := False;
    ISUDutyValvePanel.Visible := False;
    SubyAddresses[spISUDutyValve] := 0;
  end else begin
    SubyAddresses[spISUDutyValve] := m;
  end;

  m := ConfigFile.ReadInteger(CurrentId, 'O2AverageMode', 1);
  O2AvgBox.Enabled := (m > 0);
  O2AvgBox.Checked := (m = 1);
  O2AvgPanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'O2AverageAddress', 'none'));
  if m = UNUSED_ADDR then begin
    O2AvgBox.Enabled := False;
    O2AvgBox.Checked := False;
    O2AvgPanel.Visible := False;
    SubyAddresses[spO2Avg] := 0;
  end else begin
    SubyAddresses[spO2Avg] := m;
  end;

  m := ConfigFile.ReadInteger(CurrentId, 'O2MinimumMode', 1);
  O2MinBox.Enabled := (m > 0);
  O2MinBox.Checked := (m = 1);
  O2MinPanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'O2MinimumAddress', 'none'));
  if m = UNUSED_ADDR then begin
    O2MinBox.Enabled := False;
    O2MinBox.Checked := False;
    O2MinPanel.Visible := False;
    SubyAddresses[spO2Min] := 0;
  end else begin
    SubyAddresses[spO2Min] := m;
  end;

  m := ConfigFile.ReadInteger(CurrentId, 'O2MaximumMode', 1);
  O2MaxBox.Enabled := (m > 0);
  O2MaxBox.Checked := (m = 1);
  O2MaxPanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'O2MaximumAddress', 'none'));
  if m = UNUSED_ADDR then begin
    O2MaxBox.Enabled := False;
    O2MaxBox.Checked := False;
    O2MaxPanel.Visible := False;
    SubyAddresses[spO2Max] := 0;
  end else begin
    SubyAddresses[spO2Max] := m;
  end;

  m := ConfigFile.ReadInteger(CurrentId, 'KnockCorrectionMode', 1);
  KnockCorrectionBox.Enabled := (m > 0);
  KnockCorrectionBox.Checked := (m = 1);
  KnockCorrectionPanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'KnockCorrectionAddress', 'none'));
  if m = UNUSED_ADDR then begin
    KnockCorrectionBox.Enabled := False;
    KnockCorrectionBox.Checked := False;
    KnockCorrectionPanel.Visible := False;
    SubyAddresses[spKnockCorrection] := 0;
  end else begin
    SubyAddresses[spKnockCorrection] := m;
  end;

  m := ConfigFile.ReadInteger(CurrentId, 'AFCorrectionMode', 1);
  AFCorrectionBox.Enabled := (m > 0);
  AFCorrectionBox.Checked := (m = 1);
  AFCorrectionPanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'AFCorrectionAddress', 'none'));
  if m = UNUSED_ADDR then begin
    AFCorrectionBox.Enabled := False;
    AFCorrectionBox.Checked := False;
    AFCorrectionPanel.Visible := False;
    SubyAddresses[spAFCorrection] := 0;
  end else begin
    SubyAddresses[spAFCorrection] := m;
  end;

  m := ConfigFile.ReadInteger(CurrentId, 'AtmosphericPressureMode', 1);
  AtmosphericPressureBox.Enabled := (m > 0);
  AtmosphericPressureBox.Checked := (m = 1);
  AtmosphericPressurePanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'AtmosphericPressureAddress', 'none'));
  if m = UNUSED_ADDR then begin
    AtmosphericPressureBox.Enabled := False;
    AtmosphericPressureBox.Checked := False;
    AtmosphericPressurePanel.Visible := False;
    SubyAddresses[spAtmosphericPressure] := 0;
  end else begin
    SubyAddresses[spAtmosphericPressure] := m;
  end;

  m := ConfigFile.ReadInteger(CurrentId, 'ManifoldPressureMode', 1);
  ManifoldPressureBox.Enabled := (m > 0);
  ManifoldPressureBox.Checked := (m = 1);
  ManifoldPressurePanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'ManifoldPressureAddress', 'none'));
  if m = UNUSED_ADDR then begin
    ManifoldPressureBox.Enabled := False;
    ManifoldPressureBox.Checked := False;
    ManifoldPressurePanel.Visible := False;
    SubyAddresses[spManifoldPressure] := 0;
  end else begin
    SubyAddresses[spManifoldPressure] := m;
  end;

  m := ConfigFile.ReadInteger(CurrentId, 'BoostSolenoidDutyCycleMode', 1);
  BoostSolenoidDutyCycleBox.Enabled := (m > 0);
  BoostSolenoidDutyCycleBox.Checked := (m = 1);
  BoostSolenoidDutyCyclePanel.Visible := (m >= 0);
  m := HexToInt(ConfigFile.ReadString(CurrentId, 'BoostSolenoidDutyCycleAddress', 'none'));
  if m = UNUSED_ADDR then begin
    BoostSolenoidDutyCycleBox.Enabled := False;
    BoostSolenoidDutyCycleBox.Checked := False;
    BoostSolenoidDutyCyclePanel.Visible := False;
    SubyAddresses[spBoostSolenoidDutyCycle] := 0;
  end else begin
    SubyAddresses[spBoostSolenoidDutyCycle] := m;
  end;
end;

procedure TMainForm.WriteLogHeader;
var
  buf: array [0..200] of Char;
  LogCnt: Integer;
begin
  StrPCopy(buf, '<<<< SelectMonitor Started: '+DateTimeToStr(Now)+'  ROMID: '+CurrentId+' >>>>'+#13#10);
  LogFile.Write(buf, StrLen(buf));
  LogCnt := 0;
  if BatteryVoltageBox.Checked then begin
    StrPCopy(buf, 'BatteryVoltage'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if VehicleSpeedBox.Checked then begin
    StrPCopy(buf, 'VehicleSpeed'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if EngineSpeedBox.Checked then begin
    StrPCopy(buf, 'EngineSpeed'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if CoolantTempBox.Checked then begin
    StrPCopy(buf, 'CoolantTemp'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if IgnitionAdvanceBox.Checked then begin
    StrPCopy(buf, 'IgnitionAdvance'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if AirflowSensorBox.Checked then begin
    StrPCopy(buf, 'AirflowSensor'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if EngineLoadBox.Checked then begin
    StrPCopy(buf, 'EngineLoad'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if ThrottlePositionBox.Checked then begin
    StrPCopy(buf, 'ThrottlePosition'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if InjectorPulseWidthBox.Checked then begin
    StrPCopy(buf, 'InjectorPulseWidth'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if ISUDutyValveBox.Checked then begin
    StrPCopy(buf, 'ISUDutyValve'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if O2AvgBox.Checked then begin
    StrPCopy(buf, 'O2Avg'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if O2MinBox.Checked then begin
    StrPCopy(buf, 'O2Min'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if O2MaxBox.Checked then begin
    StrPCopy(buf, 'O2Max'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if KnockCorrectionBox.Checked then begin
    StrPCopy(buf, 'KnockCorrection'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if AFCorrectionBox.Checked then begin
    StrPCopy(buf, 'AFCorrection'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if AtmosphericPressureBox.Checked then begin
    StrPCopy(buf, 'AtmosphericPressure'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if ManifoldPressureBox.Checked then begin
    StrPCopy(buf, 'ManifoldPressure'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if BoostSolenoidDutyCycleBox.Checked then begin
    StrPCopy(buf, 'BoostSolenoidDutyCycle'+LogFieldSep);
    LogFile.Write(buf, StrLen(buf));
    Inc(LogCnt);
  end;
  if LogCnt > 0 then begin
    StrPCopy(buf, #13#10);
    LogFile.Write(buf, StrLen(buf));
  end;
end;

procedure TMainForm.StartBtnClick(Sender: TObject);
var
  Secs: TStringList;
  buf: array [0..200] of Char;
begin
  if Aborted then begin
    Suby.Close;
    Suby.Port := ConfigFile.ReadInteger('Options', 'CommPort', 1);
    Suby.Open;
    if not Suby.Enabled then begin
      ShowMessage('Unable to open CommPort #'+IntToStr(Suby.Port)+#13#13+'Close all other applications and try again.');
      Exit;
    end;
    Logging := False;
    FreeAndNil(LogFile);
    Logging := ConfigFile.ReadBool('Options', 'Logging', False);
    LogRawData := ConfigFile.ReadBool('Options', 'LogRawData', False);
    LogOverwrite := ConfigFile.ReadBool('Options', 'LogOverwrite', False);
    LogFieldSep := Char(ConfigFile.ReadInteger('Options', 'LogFieldSeparator', 9));
    CurrentId := Suby.GetId;
    IDLabel.Caption := CurrentId;
    Secs := TStringList.Create;
    ConfigFile.ReadSection(CurrentId, Secs);
    // No ROM ID section found
    if Secs.Count = 0 then begin
      CurrentId := Copy(CurrentId, 1, 4);   // Try only the first 16 bits of the ROM ID
    end;
    Secs.Free;
    LoadECUInfo;
    if Logging then begin
      if (not LogOverwrite) and FileExists('SelectMonitor.log') then
        LogFile := TFileStream.Create('SelectMonitor.log', fmOpenReadWrite or fmShareDenyWrite)
      else
        LogFile := TFileStream.Create('SelectMonitor.log', fmCreate or fmShareDenyWrite);
      LogFile.Position := LogFile.Size;
      WriteLogHeader;
    end;
    Aborted := False;
    StartBtn.Caption := 'Stop';
    Panel1.Color := clRed;
  end else begin
    Aborted := True;
    if Logging then begin
      Logging := False;
      StrPCopy(buf, #13#10+'<<<< SelectMonitor Stopped: '+DateTimeToStr(Now)+' >>>>'+#13#10);
      LogFile.Write(buf, StrLen(buf));
      FreeAndNil(LogFile);
    end;
    Panel1.Color := clBtnFace;
    Sleep(300);
    Suby.Stop;
    StartBtn.Caption := 'Start';
  end;
end;

procedure TMainForm.UpdateValues;
var
  Data: Byte;
  Value: Extended;
  buf: array [0..200] of Char;
  LogCnt: Integer;
begin
  if Aborted then Exit;

  LogCnt := 0;

  if BatteryVoltageBox.Checked then begin
    if GraphicFrame1.Visible then begin
      Data := Suby.ReadAddress(SubyAddresses[spBatteryVoltage]);
      Value := Suby.DataToValue(spBatteryVoltage, Data);
      GraphicFrame1.BatteryVoltageGauge.Position := Value;
    end else begin
      BatteryVoltageEdit.Color := EDITREAD_COLOR;
      BatteryVoltageEdit.Repaint;
      Data := Suby.ReadAddress(SubyAddresses[spBatteryVoltage]);
      Value := Suby.DataToValue(spBatteryVoltage, Data);
      BatteryVoltageEdit.Color := EDITON_COLOR;
      BatteryVoltageEdit.Text := Format('%5.2f', [Value]);
      BatteryVoltageEdit.Repaint;
      BatteryVoltageBar.Position := Data;
    end;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else
        StrPCopy(buf, Format('%5.2f', [Value])+LogFieldSep);
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    BatteryVoltageBoxClick(Self);
  end;

  if Aborted then Exit;

  if VehicleSpeedBox.Checked then begin
    if GraphicFrame1.Visible then begin
      Data := Suby.ReadAddress(SubyAddresses[spVehicleSpeed]);
      Value := Suby.DataToValue(spVehicleSpeed, Data);
      if MPH then
        Value := KMH2MPH(Value);
      GraphicFrame1.VehicleSpeedGauge.Position := Value;
    end else begin
      VehicleSpeedEdit.Color := EDITREAD_COLOR;
      VehicleSpeedEdit.Repaint;
      Data := Suby.ReadAddress(SubyAddresses[spVehicleSpeed]);
      Value := Suby.DataToValue(spVehicleSpeed, Data);
      if MPH then
        Value := KMH2MPH(Value);
      VehicleSpeedEdit.Color := EDITON_COLOR;
      VehicleSpeedEdit.Text := Format('%5.0f', [Value]);
      VehicleSpeedEdit.Repaint;
      VehicleSpeedBar.Position := Data;
    end;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else
        StrPCopy(buf, Format('%5.0f', [Value])+LogFieldSep);
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    VehicleSpeedBoxClick(Self);
  end;

  if Aborted then Exit;

  if EngineSpeedBox.Checked then begin
    if GraphicFrame1.Visible then begin
      Data := Suby.ReadAddress(SubyAddresses[spEngineSpeed]);
      Value := Suby.DataToValue(spEngineSpeed, Data);
      GraphicFrame1.EngineSpeedGauge.Position := Value / 1000;
    end else begin
      EngineSpeedEdit.Color := EDITREAD_COLOR;
      EngineSpeedEdit.Repaint;
      Data := Suby.ReadAddress(SubyAddresses[spEngineSpeed]);
      Value := Suby.DataToValue(spEngineSpeed, Data);
      EngineSpeedEdit.Color := EDITON_COLOR;
      EngineSpeedEdit.Text := Format('%5.0f', [Value]);
      EngineSpeedEdit.Repaint;
      EngineSpeedBar.Position := Data;
    end;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else
        StrPCopy(buf, Format('%5.0f', [Value])+LogFieldSep);
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    EngineSpeedBoxClick(Self);
  end;

  Application.ProcessMessages;
  if Aborted then Exit;

  if CoolantTempBox.Checked then begin
    if GraphicFrame1.Visible then begin
      Data := Suby.ReadAddress(SubyAddresses[spCoolantTemp]);
      Value := Suby.DataToValue(spCoolantTemp, Data);
      if Fahrenheit then
        Value := Celsius2Fahrenheit(Value);
      GraphicFrame1.CoolantTempGauge.Position := Max(0, Value);
    end else begin
      CoolantTempEdit.Color := EDITREAD_COLOR;
      CoolantTempEdit.Repaint;
      Data := Suby.ReadAddress(SubyAddresses[spCoolantTemp]);
      Value := Suby.DataToValue(spCoolantTemp, Data);
      if Fahrenheit then
        Value := Celsius2Fahrenheit(Value);
      CoolantTempEdit.Color := EDITON_COLOR;
      CoolantTempEdit.Text := Format('%5.2f', [Value]);
      CoolantTempEdit.Repaint;
      CoolantTempBar.Position := Data;
    end;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else
        StrPCopy(buf, Format('%5.2f', [Value])+LogFieldSep);
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    CoolantTempBoxClick(Self);
  end;

  if Aborted then Exit;

  if IgnitionAdvanceBox.Checked then begin
    IgnitionAdvanceEdit.Color := EDITREAD_COLOR;
    IgnitionAdvanceEdit.Repaint;
    Data := Suby.ReadAddress(SubyAddresses[spIgnitionAdvance]);
    Value := Suby.DataToValue(spIgnitionAdvance, Data);
    IgnitionAdvanceEdit.Color := EDITON_COLOR;
    IgnitionAdvanceEdit.Text := Format('%5.2f', [Value]);
    IgnitionAdvanceEdit.Repaint;
    IgnitionAdvanceBar.Position := Data;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else
        StrPCopy(buf, Format('%5.2f', [Value])+LogFieldSep);
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    IgnitionAdvanceBoxClick(Self);
  end;

  if Aborted then Exit;

  if AirflowSensorBox.Checked then begin
    if GraphicFrame1.Visible then begin
      Data := Suby.ReadAddress(SubyAddresses[spAirflowSensor]);
      Value := Suby.DataToValue(spAirflowSensor, Data);
      GraphicFrame1.AirflowSensorGauge.Position := Value;
    end else begin
      AirflowSensorEdit.Color := EDITREAD_COLOR;
      AirflowSensorEdit.Repaint;
      Data := Suby.ReadAddress(SubyAddresses[spAirflowSensor]);
      Value := Suby.DataToValue(spAirflowSensor, Data);
      AirflowSensorEdit.Color := EDITON_COLOR;
      AirflowSensorEdit.Text := Format('%5.3f', [Value]);
      AirflowSensorEdit.Repaint;
      AirflowSensorBar.Position := Data;
    end;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else
        StrPCopy(buf, Format('%5.3f', [Value])+LogFieldSep);
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    AirflowSensorBoxClick(Self);
  end;

  if Aborted then Exit;

  if EngineLoadBox.Checked then begin
    EngineLoadEdit.Color := EDITREAD_COLOR;
    EngineLoadEdit.Repaint;
    Data := Suby.ReadAddress(SubyAddresses[spEngineLoad]);
    Value := Suby.DataToValue(spEngineLoad, Data);
    EngineLoadEdit.Color := EDITON_COLOR;
    EngineLoadEdit.Text := Format('%5.2f', [Value]);
    EngineLoadEdit.Repaint;
    EngineLoadBar.Position := Data;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else
        StrPCopy(buf, Format('%5.2f', [Value])+LogFieldSep);
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    EngineLoadBoxClick(Self);
  end;

  if Aborted then Exit;

  if ThrottlePositionBox.Checked then begin
    if GraphicFrame1.Visible then begin
      Data := Suby.ReadAddress(SubyAddresses[spThrottlePosition]);
      Value := Suby.DataToValue(spThrottlePosition, Data);
      GraphicFrame1.ThrottlePositionGauge.Position := Value;
    end else begin
      ThrottlePositionEdit.Color := EDITREAD_COLOR;
      ThrottlePositionEdit.Repaint;
      Data := Suby.ReadAddress(SubyAddresses[spThrottlePosition]);
      Value := Suby.DataToValue(spThrottlePosition, Data);
      ThrottlePositionEdit.Color := EDITON_COLOR;
      ThrottlePositionEdit.Text := Format('%5.3f', [Value]);
      ThrottlePositionEdit.Repaint;
      ThrottlePositionBar.Position := Data;
    end;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else
        StrPCopy(buf, Format('%5.3f', [Value])+LogFieldSep);
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    ThrottlePositionBoxClick(Self);
  end;

  if Aborted then Exit;

  if InjectorPulseWidthBox.Checked then begin
    if GraphicFrame1.Visible then begin
      Data := Suby.ReadAddress(SubyAddresses[spInjectorPulseWidth]);
      Value := Suby.DataToValue(spInjectorPulseWidth, Data);
      GraphicFrame1.InjectorPulseWidthGauge.Position := Value;
    end else begin
      InjectorPulseWidthEdit.Color := EDITREAD_COLOR;
      InjectorPulseWidthEdit.Repaint;
      Data := Suby.ReadAddress(SubyAddresses[spInjectorPulseWidth]);
      Value := Suby.DataToValue(spInjectorPulseWidth, Data);
      InjectorPulseWidthEdit.Color := EDITON_COLOR;
      InjectorPulseWidthEdit.Text := Format('%5.2f', [Value]);
      InjectorPulseWidthEdit.Repaint;
      InjectorPulseWidthBar.Position := Data;
    end;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else
        StrPCopy(buf, Format('%5.2f', [Value])+LogFieldSep);
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    InjectorPulseWidthBoxClick(Self);
  end;

  if Aborted then Exit;

  if ISUDutyValveBox.Checked then begin
    ISUDutyValveEdit.Color := EDITREAD_COLOR;
    ISUDutyValveEdit.Repaint;
    Data := Suby.ReadAddress(SubyAddresses[spISUDutyValve]);
    Value := Suby.DataToValue(spISUDutyValve, Data);
    ISUDutyValveEdit.Color := EDITON_COLOR;
    ISUDutyValveEdit.Text := Format('%5.2f', [Value]);
    ISUDutyValveEdit.Repaint;
    ISUDutyValveBar.Position := Data;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else
        StrPCopy(buf, Format('%5.2f', [Value])+LogFieldSep);
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    ISUDutyValveBoxClick(Self);
  end;

  if Aborted then Exit;

  if O2AvgBox.Checked then begin
    if GraphicFrame1.Visible then begin
      Data := Suby.ReadAddress(SubyAddresses[spO2Avg]);
      Value := Suby.DataToValue(spO2Avg, Data);
      GraphicFrame1.O2AvgGauge.Position := Value;
    end else begin
      O2AvgEdit.Color := EDITREAD_COLOR;
      O2AvgEdit.Repaint;
      Data := Suby.ReadAddress(SubyAddresses[spO2Avg]);
      Value := Suby.DataToValue(spO2Avg, Data);
      O2AvgEdit.Color := EDITON_COLOR;
      O2AvgEdit.Text := Format('%5.2f', [Value]);
      O2AvgEdit.Repaint;
      O2AvgBar.Position := Data;
    end;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else
        StrPCopy(buf, Format('%5.2f', [Value])+LogFieldSep);
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    O2AvgBoxClick(Self);
  end;

  if Aborted then Exit;

  if O2MinBox.Checked then begin
    O2MinEdit.Color := EDITREAD_COLOR;
    O2MinEdit.Repaint;
    Data := Suby.ReadAddress(SubyAddresses[spO2Min]);
    Value := Suby.DataToValue(spO2Min, Data);
    O2MinEdit.Color := EDITON_COLOR;
    O2MinEdit.Text := Format('%5.2f', [Value]);
    O2MinEdit.Repaint;
    O2MinBar.Position := Data;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else
        StrPCopy(buf, Format('%5.2f', [Value])+LogFieldSep);
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    O2MinBoxClick(Self);
  end;

  if Aborted then Exit;

  if O2MaxBox.Checked then begin
    O2MaxEdit.Color := EDITREAD_COLOR;
    O2MaxEdit.Repaint;
    Data := Suby.ReadAddress(SubyAddresses[spO2Max]);
    Value := Suby.DataToValue(spO2Max, Data);
    O2MaxEdit.Color := EDITON_COLOR;
    O2MaxEdit.Text := Format('%5.2f', [Value]);
    O2MaxEdit.Repaint;
    O2MaxBar.Position := Data;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else
        StrPCopy(buf, Format('%5.2f', [Value])+LogFieldSep);
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    O2MaxBoxClick(Self);
  end;

  if Aborted then Exit;

  if KnockCorrectionBox.Checked then begin
    KnockCorrectionEdit.Color := EDITREAD_COLOR;
    KnockCorrectionEdit.Repaint;
    Data := Suby.ReadAddress(SubyAddresses[spKnockCorrection]);
    Value := Suby.DataToValue(spKnockCorrection, Data);
    KnockCorrectionEdit.Color := EDITON_COLOR;
    KnockCorrectionEdit.Text := Format('%5.2f', [Value]);
    KnockCorrectionEdit.Repaint;
    KnockCorrectionBar.Position := Data;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else
        StrPCopy(buf, Format('%5.2f', [Value])+LogFieldSep);
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    KnockCorrectionBoxClick(Self);
  end;

  if Aborted then Exit;

  if AFCorrectionBox.Checked then begin
    AFCorrectionEdit.Color := EDITREAD_COLOR;
    AFCorrectionEdit.Repaint;
    Data := Suby.ReadAddress(SubyAddresses[spAFCorrection]);
    Value := Suby.DataToValue(spAFCorrection, Data);
    AFCorrectionEdit.Color := EDITON_COLOR;
    AFCorrectionEdit.Text := Format('%5.2f', [Value]);
    AFCorrectionEdit.Repaint;
    AFCorrectionBar.Position := Data;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else
        StrPCopy(buf, Format('%5.2f', [Value])+LogFieldSep);
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    AFCorrectionBoxClick(Self);
  end;

  if Aborted then Exit;

  if AtmosphericPressureBox.Checked then begin
    if GraphicFrame1.Visible then begin
      Data := Suby.ReadAddress(SubyAddresses[spAtmosphericPressure]);
      // Always show AtmosphericPressure in mmHg since these shitty gauges don't go negative...
      Value := Suby.DataToValue(spAtmosphericPressure, Data);
      GraphicFrame1.AtmosphericPressureGauge.Position := Value;
    end else begin
      AtmosphericPressureEdit.Color := EDITREAD_COLOR;
      AtmosphericPressureEdit.Repaint;
      Data := Suby.ReadAddress(SubyAddresses[spAtmosphericPressure]);
      Value := Suby.DataToValue(spAtmosphericPressure, Data);
      if AtmosphericPressureUnits = 0 then
        Value := mmHg2Psi(Value);
      if AtmosphericPressureUnits = 1 then
        Value := mmHg2Bar(Value);
      if AtmosphericPressureUnits = 3 then
        Value := mmHg2inHg(Value);
      AtmosphericPressureEdit.Color := EDITON_COLOR;
      AtmosphericPressureEdit.Text := Format('%5.2f', [Value]);
      AtmosphericPressureEdit.Repaint;
      AtmosphericPressureBar.Position := Data;
    end;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else begin
        Value := Suby.DataToValue(spAtmosphericPressure, Data);
        if AtmosphericPressureUnits = 0 then
          Value := mmHg2Psi(Value);
        if AtmosphericPressureUnits = 1 then
          Value := mmHg2Bar(Value);
        if AtmosphericPressureUnits = 3 then
          Value := mmHg2inHg(Value);
        StrPCopy(buf, Format('%5.2f', [Value])+LogFieldSep);
      end;
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    AtmosphericPressureBoxClick(Self);
  end;

  if Aborted then Exit;

  if ManifoldPressureBox.Checked then begin
    if GraphicFrame1.Visible then begin
      Data := Suby.ReadAddress(SubyAddresses[spManifoldPressure]);
      // Always show ManifoldPressure in mmHg since these shitty gauges don't go negative...
      Value := Bar2mmHg(Suby.DataToValue(spManifoldPressure, Data));
      GraphicFrame1.ManifoldPressureGauge.Position := Max(0, Value);
    end else begin
      ManifoldPressureEdit.Color := EDITREAD_COLOR;
      ManifoldPressureEdit.Repaint;
      Data := Suby.ReadAddress(SubyAddresses[spManifoldPressure]);
      Value := Suby.DataToValue(spManifoldPressure, Data);
      if ManifoldPressureUnits = 0 then
        Value := Bar2Psi(Value);
      if ManifoldPressureUnits = 2 then
        Value := Bar2mmHg(Value);
      if ManifoldPressureUnits = 3 then
        Value := Bar2inHg(Value);
      ManifoldPressureEdit.Color := EDITON_COLOR;
      ManifoldPressureEdit.Text := Format('%5.2f', [Value]);
      ManifoldPressureEdit.Repaint;
      ManifoldPressureBar.Position := Data;
    end;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else begin
        Value := Suby.DataToValue(spManifoldPressure, Data);
        if ManifoldPressureUnits = 0 then
          Value := Bar2Psi(Value);
        if ManifoldPressureUnits = 2 then
          Value := Bar2mmHg(Value);
        if ManifoldPressureUnits = 3 then
          Value := Bar2inHg(Value);
        StrPCopy(buf, Format('%5.2f', [Value])+LogFieldSep);
      end;
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    ManifoldPressureBoxClick(Self);
  end;

  if Aborted then Exit;

  if BoostSolenoidDutyCycleBox.Checked then begin
    BoostSolenoidDutyCycleEdit.Color := EDITREAD_COLOR;
    BoostSolenoidDutyCycleEdit.Repaint;
    Data := Suby.ReadAddress(SubyAddresses[spBoostSolenoidDutyCycle]);
    Value := Suby.DataToValue(spBoostSolenoidDutyCycle, Data);
    BoostSolenoidDutyCycleEdit.Color := EDITON_COLOR;
    BoostSolenoidDutyCycleEdit.Text := Format('%5.2f', [Value]);
    BoostSolenoidDutyCycleEdit.Repaint;
    BoostSolenoidDutyCycleBar.Position := Data;
    if Logging then begin
      if LogRawData then
        StrPCopy(buf, IntToStr(Data)+LogFieldSep)
      else
        StrPCopy(buf, Format('%5.2f', [Value])+LogFieldSep);
      LogFile.Write(buf, StrLen(buf));
      Inc(LogCnt);
    end;
  end else begin
    BoostSolenoidDutyCycleBoxClick(Self);
  end;

  if Logging and (LogCnt > 0) then begin
    StrPCopy(buf, #13#10);
    LogFile.Write(buf, StrLen(buf));
  end;
end;

procedure TMainForm.BatteryVoltageBoxClick(Sender: TObject);
begin
  BatteryVoltageEdit.Text := '';
  BatteryVoltageBar.Position := 0;
  if BatteryVoltageBox.Checked then begin
    BatteryVoltageEdit.Color := EDITON_COLOR;
  end else begin
    BatteryVoltageEdit.Color := EDITOFF_COLOR;
  end;
  BatteryVoltageEdit.Update;
  GraphicFrame1.BatteryVoltageGauge.Visible := BatteryVoltageBox.Checked;
  GraphicFrame1.BatteryVoltageLabel.Visible := BatteryVoltageBox.Checked;
end;

procedure TMainForm.VehicleSpeedBoxClick(Sender: TObject);
begin
  VehicleSpeedEdit.Text := '';
  VehicleSpeedBar.Position := 0;
  if VehicleSpeedBox.Checked then begin
    VehicleSpeedEdit.Color := EDITON_COLOR;
  end else begin
    VehicleSpeedEdit.Color := EDITOFF_COLOR;
  end;
  VehicleSpeedEdit.Update;
  GraphicFrame1.VehicleSpeedGauge.Visible := VehicleSpeedBox.Checked;
end;

procedure TMainForm.EngineSpeedBoxClick(Sender: TObject);
begin
  EngineSpeedEdit.Text := '';
  EngineSpeedBar.Position := 0;
  if EngineSpeedBox.Checked then begin
    EngineSpeedEdit.Color := EDITON_COLOR;
  end else begin
    EngineSpeedEdit.Color := EDITOFF_COLOR;
  end;
  EngineSpeedEdit.Update;
  GraphicFrame1.EngineSpeedGauge.Visible := EngineSpeedBox.Checked;
end;

procedure TMainForm.CoolantTempBoxClick(Sender: TObject);
begin
  CoolantTempEdit.Text := '';
  CoolantTempBar.Position := 0;
  if CoolantTempBox.Checked then begin
    CoolantTempEdit.Color := EDITON_COLOR;
  end else begin
    CoolantTempEdit.Color := EDITOFF_COLOR;
  end;
  CoolantTempEdit.Update;
  GraphicFrame1.CoolantTempGauge.Visible := CoolantTempBox.Checked;
  GraphicFrame1.CoolantTempLabel.Visible := CoolantTempBox.Checked;
end;

procedure TMainForm.IgnitionAdvanceBoxClick(Sender: TObject);
begin
  IgnitionAdvanceEdit.Text := '';
  IgnitionAdvanceBar.Position := 0;
  if IgnitionAdvanceBox.Checked then begin
    IgnitionAdvanceEdit.Color := EDITON_COLOR;
  end else begin
    IgnitionAdvanceEdit.Color := EDITOFF_COLOR;
  end;
  IgnitionAdvanceEdit.Update;
end;

procedure TMainForm.AirflowSensorBoxClick(Sender: TObject);
begin
  AirflowSensorEdit.Text := '';
  AirflowSensorBar.Position := 0;
  if AirflowSensorBox.Checked then begin
    AirflowSensorEdit.Color := EDITON_COLOR;
  end else begin
    AirflowSensorEdit.Color := EDITOFF_COLOR;
  end;
  AirflowSensorEdit.Update;
  GraphicFrame1.AirflowSensorGauge.Visible := AirflowSensorBox.Checked;
  GraphicFrame1.AirflowSensorLabel.Visible := AirflowSensorBox.Checked;
end;

procedure TMainForm.EngineLoadBoxClick(Sender: TObject);
begin
  EngineLoadEdit.Text := '';
  EngineLoadBar.Position := 0;
  if EngineLoadBox.Checked then begin
    EngineLoadEdit.Color := EDITON_COLOR;
  end else begin
    EngineLoadEdit.Color := EDITOFF_COLOR;
  end;
  EngineLoadEdit.Update;
end;

procedure TMainForm.ThrottlePositionBoxClick(Sender: TObject);
begin
  ThrottlePositionEdit.Text := '';
  ThrottlePositionBar.Position := 0;
  if ThrottlePositionBox.Checked then begin
    ThrottlePositionEdit.Color := EDITON_COLOR;
  end else begin
    ThrottlePositionEdit.Color := EDITOFF_COLOR;
  end;
  ThrottlePositionEdit.Update;
  GraphicFrame1.ThrottlePositionGauge.Visible := ThrottlePositionBox.Checked;
  GraphicFrame1.ThrottlePositionLabel.Visible := ThrottlePositionBox.Checked;
end;

procedure TMainForm.InjectorPulseWidthBoxClick(Sender: TObject);
begin
  InjectorPulseWidthEdit.Text := '';
  InjectorPulseWidthBar.Position := 0;
  if InjectorPulseWidthBox.Checked then begin
    InjectorPulseWidthEdit.Color := EDITON_COLOR;
  end else begin
    InjectorPulseWidthEdit.Color := EDITOFF_COLOR;
  end;
  InjectorPulseWidthEdit.Update;
  GraphicFrame1.InjectorPulseWidthGauge.Visible := InjectorPulseWidthBox.Checked;
  GraphicFrame1.InjectorPulseWidthLabel.Visible := InjectorPulseWidthBox.Checked;
end;

procedure TMainForm.ISUDutyValveBoxClick(Sender: TObject);
begin
  ISUDutyValveEdit.Text := '';
  ISUDutyValveBar.Position := 0;
  if ISUDutyValveBox.Checked then begin
    ISUDutyValveEdit.Color := EDITON_COLOR;
  end else begin
    ISUDutyValveEdit.Color := EDITOFF_COLOR;
  end;
  ISUDutyValveEdit.Update;
end;

procedure TMainForm.O2AvgBoxClick(Sender: TObject);
begin
  O2AvgEdit.Text := '';
  O2AvgBar.Position := 0;
  if O2AvgBox.Checked then begin
    O2AvgEdit.Color := EDITON_COLOR;
  end else begin
    O2AvgEdit.Color := EDITOFF_COLOR;
  end;
  O2AvgEdit.Update;
  GraphicFrame1.O2AvgGauge.Visible := O2AvgBox.Checked;
  GraphicFrame1.O2AvgLabel.Visible := O2AvgBox.Checked;
end;

procedure TMainForm.O2MinBoxClick(Sender: TObject);
begin
  O2MinEdit.Text := '';
  O2MinBar.Position := 0;
  if O2MinBox.Checked then begin
    O2MinEdit.Color := EDITON_COLOR;
  end else begin
    O2MinEdit.Color := EDITOFF_COLOR;
  end;
  O2MinEdit.Update;
end;

procedure TMainForm.O2MaxBoxClick(Sender: TObject);
begin
  O2MaxEdit.Text := '';
  O2MaxBar.Position := 0;
  if O2MaxBox.Checked then begin
    O2MaxEdit.Color := EDITON_COLOR;
  end else begin
    O2MaxEdit.Color := EDITOFF_COLOR;
  end;
end;

procedure TMainForm.KnockCorrectionBoxClick(Sender: TObject);
begin
  KnockCorrectionEdit.Text := '';
  KnockCorrectionBar.Position := 0;
  if KnockCorrectionBox.Checked then begin
    KnockCorrectionEdit.Color := EDITON_COLOR;
  end else begin
    KnockCorrectionEdit.Color := EDITOFF_COLOR;
  end;
  KnockCorrectionEdit.Update;
end;

procedure TMainForm.AFCorrectionBoxClick(Sender: TObject);
begin
  AFCorrectionEdit.Text := '';
  AFCorrectionBar.Position := 0;
  if AFCorrectionBox.Checked then begin
    AFCorrectionEdit.Color := EDITON_COLOR;
  end else begin
    AFCorrectionEdit.Color := EDITOFF_COLOR;
  end;
  AFCorrectionEdit.Update;
end;

procedure TMainForm.AtmosphericPressureBoxClick(Sender: TObject);
begin
  AtmosphericPressureEdit.Text := '';
  AtmosphericPressureBar.Position := 0;
  if AtmosphericPressureBox.Checked then begin
    AtmosphericPressureEdit.Color := EDITON_COLOR;
  end else begin
    AtmosphericPressureEdit.Color := EDITOFF_COLOR;
  end;
  AtmosphericPressureEdit.Update;
  GraphicFrame1.AtmosphericPressureGauge.Visible := AtmosphericPressureBox.Checked;
  GraphicFrame1.AtmosphericPressureLabel.Visible := AtmosphericPressureBox.Checked;
end;

procedure TMainForm.ManifoldPressureBoxClick(Sender: TObject);
begin
  ManifoldPressureEdit.Text := '';
  ManifoldPressureBar.Position := 0;
  if ManifoldPressureBox.Checked then begin
    ManifoldPressureEdit.Color := EDITON_COLOR;
  end else begin
    ManifoldPressureEdit.Color := EDITOFF_COLOR;
  end;
  ManifoldPressureEdit.Update;
  GraphicFrame1.ManifoldPressureGauge.Visible := ManifoldPressureBox.Checked;
  GraphicFrame1.ManifoldPressureLabel.Visible := ManifoldPressureBox.Checked;
end;

procedure TMainForm.BoostSolenoidDutyCycleBoxClick(Sender: TObject);
begin
  BoostSolenoidDutyCycleEdit.Text := '';
  BoostSolenoidDutyCycleBar.Position := 0;
  if BoostSolenoidDutyCycleBox.Checked then begin
    BoostSolenoidDutyCycleEdit.Color := EDITON_COLOR;
  end else begin
    BoostSolenoidDutyCycleEdit.Color := EDITOFF_COLOR;
  end;
  BoostSolenoidDutyCycleEdit.Update;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  ClientWidth := 640;
  ClientHeight := 480+StatusBar1.Height;
  Fahrenheit := ConfigFile.ReadBool('Options', 'Fahrenheit', True);
  if Fahrenheit then begin
    DegLabel.Caption := 'Deg F';
    GraphicFrame1.CoolantTempGauge.Caption := 'F';
    GraphicFrame1.CoolantTempGauge.Scale := 275;
    GraphicFrame1.CoolantTempGauge.IndMaximum := 220;
  end else begin
    DegLabel.Caption := 'Deg C';
    GraphicFrame1.CoolantTempGauge.Caption := 'C';
    GraphicFrame1.CoolantTempGauge.Scale := 150;
    GraphicFrame1.CoolantTempGauge.IndMaximum := 102;
  end;
  MPH := ConfigFile.ReadBool('Options', 'MPH', True);
  if MPH then begin
    SpeedLabel.Caption := 'MPH';
    GraphicFrame1.VehicleSpeedGauge.Caption := 'MPH';
    GraphicFrame1.VehicleSpeedGauge.Scale := 120;
    GraphicFrame1.VehicleSpeedGauge.IndMaximum := 80;
    GraphicFrame1.VehicleSpeedGauge.NumberMainTicks := 12;
  end else begin
    SpeedLabel.Caption := 'KMH';
    GraphicFrame1.VehicleSpeedGauge.Caption := 'KMH';
    GraphicFrame1.VehicleSpeedGauge.Scale := 200;
    GraphicFrame1.VehicleSpeedGauge.IndMaximum := 130;
    GraphicFrame1.VehicleSpeedGauge.NumberMainTicks := 10;
  end;
  AtmosphericPressureUnits := ConfigFile.ReadInteger('Options', 'AtmosphericPressureUnits', 0);
  AtmosphericPressureUnits := Min(Length(PRESSURE_UNITS)-1, AtmosphericPressureUnits);
  AtmosphericPressureUnits := Max(0, AtmosphericPressureUnits);
  AtmosphericPressureUnitsLabel.Caption := PRESSURE_UNITS[AtmosphericPressureUnits];
  ManifoldPressureUnits := ConfigFile.ReadInteger('Options', 'ManifoldPressureUnits', 0);
  ManifoldPressureUnits := Min(Length(PRESSURE_UNITS)-1, ManifoldPressureUnits);
  ManifoldPressureUnits := Max(0, ManifoldPressureUnits);
  ManifoldPressureUnitsLabel.Caption := PRESSURE_UNITS[ManifoldPressureUnits];
end;

procedure TMainForm.GraphicBtnClick(Sender: TObject);
begin
  AutoScroll := False;
  BorderStyle := bsSingle;
  ClientWidth := 640;
  ClientHeight := 480+StatusBar1.Height;
  GraphicFrame1.Top := 0;
  GraphicFrame1.Left := 0;
  GraphicFrame1.Width := 640;
  GraphicFrame1.Height := 480;
  GraphicFrame1.Visible := True;
  GraphicFrame1.BringToFront;
end;

procedure TMainForm.StatusBar1DblClick(Sender: TObject);
begin
  GraphicFrame1.Visible := False;
  AutoScroll := True;
  BorderStyle := bsSizeable;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  if FirstPaint then begin
    FirstPaint := False;
    if ConfigFile.ReadBool('Options', 'GraphicMode', False) then begin
      GraphicBtnClick(Sender);
      StartBtnClick(Sender);    // Assumes autostart
    end else begin
      if ConfigFile.ReadBool('Options', 'AutoStart', False) then
        StartBtnClick(Sender);
    end;
  end;
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Char(VK_ESCAPE) then begin
    GraphicFrame1.Visible := False;
    AutoScroll := True;
    BorderStyle := bsSizeable;
  end;
end;

procedure TMainForm.About1Click(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

end.
