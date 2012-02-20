(*
  Copyright 1995-2012 Kevin Frank syncro@vwrx.com

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

unit SubyComm;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms;

type
  TSubyParams = (spBatteryVoltage, spVehicleSpeed, spEngineSpeed, spCoolantTemp,
    spIgnitionAdvance, spAirflowSensor, spEngineLoad, spThrottlePosition,
    spInjectorPulseWidth, spISUDutyValve, spO2Avg, spO2Min, spO2max, spKnockCorrection,
    spAFCorrection, spAtmosphericPressure, spManifoldPressure, spBoostSolenoidDutyCycle);
  TSubyAddresses = array[TSubyParams] of Word;
  TSubyData = array[TSubyParams] of Byte;
  TSubyValues = array[TSubyParams] of Extended;
(*
  TSubyMap = class(TObject)
    FSubyAddresses: TSubyAddresses;
  public
//    property FSubyAddresses: TSubyAddresses read FSubyAddresses;
    property BatteryVoltageAddress: Word read FSubyAddresses[spBatteryVoltage] write FSubyAddresses[spBatteryVoltage];
  end;
*)
  TSubyComm = class(TComponent)
  private
    FWinNT: Boolean;
    FHandle: THandle;
    FWriteEvent: THandle;
    FCT: TComStat;
    FDCB: TDCB;
    FCommConfig: TCommConfig;
    FErrors: dword;
    FWriteOS: TOverlapped;
    FDeviceName: String;
    FReadBufferSize: Integer;
    FWriteBufferSize: Integer;
    FPort: Integer;
    procedure Set_Port(Value: Integer);
  protected
    function InQueCount: Integer;
    function OutQueCount: Integer;
    procedure PurgeIn;
    procedure PurgeOut;
    procedure ClearErrors;
    function Write(const Buf; Count: Integer): Integer;
    function Read(var Buf; Count: Integer): Integer;
    //Reference to internal device handle
    property Handle: THandle read FHandle;
    property DeviceName: string read FDeviceName write FDeviceName;
    property ReadBufferSize: Integer read FReadBufferSize write FReadBufferSize default 4096;
    property WriteBufferSize: Integer read FWriteBufferSize write FWriteBufferSize default 2048;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Open;
    procedure Close;
    function Enabled: Boolean;
    function GetId: String;
    procedure Stop;
    function ReadAddress(Address: Word): Byte;
    procedure ReadAllParams(Addresses: TSubyAddresses; var Data: TSubyData; var Abort: Boolean);
    function DataToValue(Param: TSubyParams; Data: Byte): Extended;
    procedure ConvertAllParams(Data: TSubyData; var Values: TSubyValues);
    property Port: Integer read FPort write Set_Port;
  end;

implementation

const
  fBinary           = $00000001;
  fParity           = $00000002;
  fOutxCtsFlow      = $00000004;
  fOutxDsrFlow      = $00000008;
  fDtrControl       = $00000030;
  fDsrSensitivity   = $00000040;
  fTXContinueOnXoff = $00000080;
  fOutX             = $00000100;
  fInX              = $00000200;
  fErrorChar        = $00000400;
  fNull             = $00000800;
  fRtsControl       = $00003000;
  fAbortOnError     = $00004000;
  fDummy2           = $FFFF8000;

   
// *********************************
// TSubyComm
// *********************************

constructor TSubyComm.Create(AOwner: TComponent);
var
  OSVersionInfo: TOSVersionInfo;
begin
  Inherited Create(AOwner);
  FHandle := INVALID_HANDLE_VALUE;
  FDeviceName := 'COM1';
  FPort := 1;
  FReadBufferSize := 4096;
  FWriteBufferSize := 2048;
  FWriteEvent := CreateEvent(nil, False, False, nil);
  FillChar(FWriteOS, Sizeof(FWriteOS), 0);
  FWriteOS.hEvent := FWriteEvent;

  OSVersionInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  OSVersionInfo.dwPlatformId := VER_PLATFORM_WIN32s;
  GetVersionEx(OSVersionInfo);
  { Determine if we are running Windows NT }
  FWinNT := (OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT)
end;

destructor TSubyComm.Destroy;
begin
  Close;
  CloseHandle(FWriteEvent);
  Inherited Destroy;
end;

function TSubyComm.Enabled: Boolean;
begin
  Result := FHandle <> INVALID_HANDLE_VALUE;
end;

procedure TSubyComm.Open;
var
  CommTimeouts: TCommTimeouts;
  Size: DWORD;
begin
  Close;

  SetLastError(NO_ERROR); //remove any pending errors

  Fillchar(FCommConfig, Sizeof(FCommConfig), 0);

  { Windows NT REQUIRES?? using overlapped IO for communications IO? }
  //  Returns handle to communications resource
  FHandle := CreateFile(PChar('\\.\'+FDeviceName), GENERIC_READ or GENERIC_WRITE,
                        0, nil, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0);
  if Enabled then begin
    //  initializes the communications parameters for a specified
    //  communications device. 
    SetupComm(FHandle, FReadBufferSize, FWriteBufferSize);

    Size := Sizeof(TCommConfig);
    GetCommConfig(FHandle, FCommConfig, Size);
//    SetCommState(FHandle, FCommConfig.DCB);

    GetCommTimeOuts(FHandle, CommTimeOuts);
    CommTimeouts.ReadIntervalTimeout := MAXDWORD;
    CommTimeouts.ReadTotalTimeoutMultiplier := 0;
    CommTimeouts.ReadTotalTimeoutConstant := 0;
    CommTimeouts.WriteTotalTimeoutMultiplier := 1000;
    CommTimeouts.WriteTotalTimeoutConstant := 5000;
    SetCommTimeOuts(FHandle, CommTimeOuts);

    GetCommState(FHandle, FDCB);
    FDCB.BaudRate := 1954;
//    FDCB.BaudRate := 1755;
    FDCB.Parity := EVENPARITY;
//    FDCB.Parity := MARKPARITY;
    FDCB.Stopbits := ONESTOPBIT;
    FDCB.Bytesize := 8;

//    for OptIndex := osBinary to osAbortOnError do
//     if OptIndex in FOptions then
//       FDCB.Flags := FDCB.Flags or OPT[OptIndex]
//     else
//       FDCB.Flags := FDCB.Flags and not OPT[OptIndex];

    FDCB.Flags := fBinary or fParity;

    // Turn off Flow control
//    DCB.Flags := DCB.Flags and (not fOutxCtsFlow);
//    DCB.Flags := DCB.Flags and (not fRtsControl) {or (RTS_CONTROL_TOGGLE shl 12)};
//    DCB.Flags := DCB.Flags and (not fOutxDsrFlow);
//    DCB.Flags := DCB.Flags and (not fDtrControl) {or (DTR_CONTROL_ENABLE shl 4)};
//    DCB.Flags := DCB.Flags and (not fOutX) and (not fInX);


    SetCommState(FHandle, FDCB);

    PurgeIn;
    PurgeOut;
    ClearErrors;
  end;
end;

procedure TSubyComm.Close;
begin
  if Enabled then begin
    Stop;
    CloseHandle(FHandle);
    FHandle := INVALID_HANDLE_VALUE;
  end;
end;

function TSubyComm.Write(const Buf; Count: Integer): Integer;
var
  dwBytesTransfered: DWORD;
  ThisCount: Integer;
begin
  if Count > 0 then begin
    Result := 0;
    while (Count > Result) and (GetLastError <> ERROR_OPERATION_ABORTED) do begin
{ It is a mystery why only 1 byte at a time can be written using this Overlapped I/O method.  }
{ Magically when sending large blocks of data, bytes are lost?  The FWinNT conditional code }
{ should work in ALL conditinos since it would never allow the Tx buffer to overflow. }
{ NOTE: This work around is needed for Windows 95 only?  NT works fine with large blocks... }
{ Also NOTE: On faster Win95 machines this isn't a problem???  The lock-up seems to occur
{ in GetOverlappedResult and/or GetLastError is always returning ERROR_IO_INCOMPLETE.
{ WriteFile returns False and GetLastError returns ERROR_IO_PENDING, so GetOverlappedResult
{ with GetLastError is invoked, then deadlock occurs and only part of the block is transimtted... }
      FillChar(FWriteOS, Sizeof(FWriteOS), 0);
      if FWinNT then begin
        ThisCount := Count - Result;
        if ThisCount > FWriteBufferSize then
          ThisCount := FWriteBufferSize;
      end else
        ThisCount := 1;
      if (not WriteFile(FHandle, PChar(@PChar(@Buf)[Result])^, ThisCount, dwBytesTransfered, @FWriteOS))
        and (GetLastError = ERROR_IO_PENDING) then begin
        { Wait for Overlapped IO to complete!!  We cannot use bWait flag since it may
        { lock up and never return!!???  For some stupid Microsoft reason!!! }
        { NOTE: This problem only seems to happen when transferring large blocks of data... }
        while (not GetOverlappedResult(FHandle, FWriteOS, dwBytesTransfered, False))
          and (GetLastError = ERROR_IO_INCOMPLETE) do
          Sleep(0);
        ResetEvent(FWriteEvent);
      end;
      Result := Integer(dwBytesTransfered) + Result;
    end;
  end else
    Result := Count;
end;

function TSubyComm.Read(var Buf; Count: Integer): Integer;
var
  OS: TOverlapped;
  dwBytesTransfered: DWORD;
begin
  Fillchar(OS, Sizeof(OS), 0);
  if not ReadFile(FHandle, Buf, Count, DWORD(Result), @OS) then
    Result := -1
//    Result := GetLastError()
  else
    { Wait for Overlapped IO to complete }
    GetOverlappedResult(FHandle, OS, dwBytesTransfered, True);
end;

procedure TSubyComm.Set_Port(Value: Integer);
var
  OldOpened: Boolean;
begin
  OldOpened := Enabled;
  if OldOpened then
    Close;
  if Value > 255 then
    Value := 255;
  if Value < 1 then
    Value := 1;
  FPort := Value;
  DeviceName := 'COM'+IntToStr(FPort);
  if OldOpened then
    Open;
end;

procedure TSubyComm.ClearErrors;
begin
//  ClearCommBreak(FHandle);
  ClearCommError(FHandle, FErrors, @FCT);
end;

function TSubyComm.InQueCount: Integer;
var
  Errors: dword;
begin
  ClearCommError(FHandle, Errors, @FCT);
  Result := FCT.cbInQue;
end;

function TSubyComm.OutQueCount: Integer;
var
  Errors: dword;
begin
  ClearCommError(FHandle, Errors, @FCT);
  Result := FCT.cbOutQue;
end;

procedure TSubyComm.PurgeIn;
begin
  PurgeComm(FHandle, PURGE_RXABORT or PURGE_RXCLEAR);
end;

procedure TSubyComm.PurgeOut;
begin
  PurgeComm(FHandle, PURGE_TXABORT or PURGE_TXCLEAR);
end;


var
  read_STR: array [0..3] of Byte = ($78, $00, $00, $00);

const
  stop_STR: array [0..0] of Byte = ($12);
  readNull_STR: array [0..3] of Byte = ($78, $00, $00, $00);
  // Decoded at 1755bps from BCBFSCAN
//  getId_STR: array [0..7] of Byte = ($00, $00, $FF, $FF, $00, $38, $7F, $FE);
  getId_STR: array [0..3] of Byte = ($00, Byte('F'), Byte('H'), Byte('I'));
//  getId_STR: array [0..7] of Byte = ($00, $00, $FF, $FF, $00, Byte('F'), Byte('H'), Byte('I'));

function TSubyComm.GetId: String;
var
  v: array[0..3] of Char;
  r: array[0..8] of Char;
begin
  if Enabled then begin
    Stop;
    Write(readNull_STR, 4);
    Write(readNull_STR, 4);
    Write(getId_STR, 4);
    Write(getId_STR, 4);
    Write(getId_STR, 4);
    Write(getId_STR, 4);
    Sleep(100);
    Result := 'null';
    while Read(v, 3) = 3 do begin
      if (v[0] <> #0) and (v[1] <> #0) then begin
        BinToHex(v, r, 3);
        r[6] := Char($0);
        Result := StrPas(r);
        Break;
      end;
    end;
  end else begin
    Result := 'Port Closed!';
  end;
end;

procedure TSubyComm.Stop;
begin
  if Enabled then begin
    Write(stop_STR, 1);
    Write(stop_STR, 1);
    Sleep(50);
    PurgeIn;
  end;
end;

function TSubyComm.ReadAddress(Address: Word): Byte;
var
  Timeout: Cardinal;
  r: array[0..2] of Byte;
  Pending: Boolean;
begin
  Result := 0;
  if Enabled then begin
    read_STR[1] := $FF and (Address shr 8);
    read_STR[2] := $FF and Address;
    Pending := True;
    Timeout := GetTickCount + 400;
    while Pending and (Timeout > GetTickCount) do begin
      Write(read_STR, 4);
      while (InQueCount = 0) and Pending and (Timeout > GetTickCount) do
        Sleep(5);
      while (InQueCount > 1) and Pending and (Timeout > GetTickCount) do begin
        if (Read(r, 1) = 1) and (r[0] = read_STR[1]) then begin
          if (Read(r, 2) = 2) and (r[0] = read_STR[2]) then begin
            Result := r[1];
            Pending := False;
          end;
        end;
        if Pending then
          Sleep(5);
      end;
    end;
  end;
end;

procedure TSubyComm.ReadAllParams(Addresses: TSubyAddresses; var Data: TSubyData; var Abort: Boolean);
var
  i: TSubyParams;
begin
  for i := spBatteryVoltage to spBoostSolenoidDutyCycle do begin
    Data[i] := ReadAddress(Addresses[i]);
    if Abort then
      Break;
  end;
end;

function TSubyComm.DataToValue(Param: TSubyParams; Data: Byte): Extended;
begin
  case Param of
    spBatteryVoltage: Result := Data * 0.08;
    spVehicleSpeed: Result := Data * 2;
    spEngineSpeed: Result := Data * 25;
    spCoolantTemp: Result := (Data - 50);
    spIgnitionAdvance: Result := Data;
    spAirflowSensor: Result := Data * 5 / 256;
    spEngineLoad: Result := Data;
    spThrottlePosition: Result := Data * 5 / 256;
    spInjectorPulseWidth: Result := Data * 256 / 1000;
    spISUDutyValve: Result := Data * 100 / 256;
    spO2Avg: Result := Data * 5000 / 512;
    spO2Min: Result := Data * 5000 / 256;
    spO2max: Result := Data * 5000 / 256;
    spKnockCorrection: Result := Data;
    spAFCorrection: Result := (Data - 128);
    spAtmosphericPressure: Result := Data * 8;
    spManifoldPressure: Result := (Data - 128) / 85;
    spBoostSolenoidDutyCycle: Result := Data * 100 / 256;
  else
   Result := Data;
  end;
end;

procedure TSubyComm.ConvertAllParams(Data: TSubyData; var Values: TSubyValues);
var
  i: TSubyParams;
begin
  for i := spBatteryVoltage to spBoostSolenoidDutyCycle do
    Values[i] := DataToValue(i, Data[i]);
end;

end.
