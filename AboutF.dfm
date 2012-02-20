object AboutForm: TAboutForm
  Left = 603
  Top = 319
  BorderStyle = bsToolWindow
  Caption = 'About'
  ClientHeight = 134
  ClientWidth = 267
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 249
    Height = 89
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 0
    object NameLabel: TLabel
      Left = 8
      Top = 16
      Width = 235
      Height = 16
      Caption = 'VWRX Select Monitor Dump Utility'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      IsControl = True
    end
    object VersionLabel: TLabel
      Left = 8
      Top = 40
      Width = 76
      Height = 16
      Caption = 'Version 1.0.0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IsControl = True
    end
    object URLLabel: TLabel
      Left = 8
      Top = 64
      Width = 103
      Height = 13
      Cursor = crHandPoint
      Caption = 'http://www.vwrx.com'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = URLLabelClick
    end
  end
  object OKButton: TButton
    Left = 96
    Top = 104
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
end
