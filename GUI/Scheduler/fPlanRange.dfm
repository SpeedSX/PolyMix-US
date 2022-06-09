object PlanRangeForm: TPlanRangeForm
  Left = 192
  Top = 591
  BorderStyle = bsDialog
  Caption = #1069#1082#1089#1087#1086#1088#1090' '#1087#1083#1072#1085#1072' '#1074' Excel'
  ClientHeight = 140
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 265
    Height = 89
    Caption = ' '#1044#1080#1072#1087#1072#1079#1086#1085' '
    TabOrder = 0
    object Label1: TLabel
      Left = 140
      Top = 56
      Width = 12
      Height = 13
      Caption = #1087#1086
    end
    object rbDay: TRadioButton
      Left = 12
      Top = 24
      Width = 113
      Height = 17
      Caption = #1058#1077#1082#1091#1097#1080#1081' '#1076#1077#1085#1100
      TabOrder = 0
    end
    object rbDateRange: TRadioButton
      Left = 12
      Top = 54
      Width = 113
      Height = 17
      Caption = #1057
      TabOrder = 1
    end
    object deFrom: TJvDateEdit
      Left = 48
      Top = 52
      Width = 85
      Height = 21
      TabOrder = 2
    end
    object deTo: TJvDateEdit
      Left = 160
      Top = 52
      Width = 85
      Height = 21
      TabOrder = 3
    end
  end
  object btOk: TButton
    Left = 112
    Top = 108
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btCancel: TButton
    Left = 196
    Top = 108
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
end
