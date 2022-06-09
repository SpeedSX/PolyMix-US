object CancelRepForm: TCancelRepForm
  Left = 325
  Top = 245
  BorderStyle = bsNone
  Caption = 'CancelRepForm'
  ClientHeight = 81
  ClientWidth = 241
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 241
    Height = 81
    Align = alClient
    Caption = ' '
    Color = clWindow
    TabOrder = 0
    object Label1: TLabel
      Left = 52
      Top = 6
      Width = 139
      Height = 13
      Alignment = taCenter
      Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1086#1090#1095#1077#1090#1072'...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btCancel: TButton
      Left = 82
      Top = 50
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 0
      OnClick = btCancelClick
    end
    object pbProgress: TJvProgressBar
      Left = 10
      Top = 27
      Width = 223
      Height = 18
      Smooth = True
      Step = 1
      TabOrder = 1
      Color = clInfoBk
    end
  end
  object CloseTimer: TTimer
    Enabled = False
    Interval = 20
    OnTimer = CloseTimerTimer
    Left = 202
    Top = 54
  end
end
