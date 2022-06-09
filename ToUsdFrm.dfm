object ToUSDForm: TToUSDForm
  Left = 363
  Top = 249
  Width = 269
  Height = 225
  Caption = #1055#1077#1088#1077#1089#1095#1077#1090' '#1075#1088#1080#1074#1077#1085' '#1074' $ (USD)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 132
    Width = 69
    Height = 13
    Caption = #1050#1091#1088#1089' '#1076#1086#1083#1083#1072#1088#1072
  end
  object btOk: TBitBtn
    Left = 98
    Top = 166
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    NumGlyphs = 2
  end
  object btCancel: TBitBtn
    Left = 180
    Top = 166
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = btCancelClick
    NumGlyphs = 2
  end
  object GroupBox1: TGroupBox
    Left = 4
    Top = 6
    Width = 249
    Height = 113
    Caption = ' '#1044#1080#1072#1087#1072#1079#1086#1085' '#1087#1077#1088#1077#1089#1095#1077#1090#1072' '
    TabOrder = 2
    object rbAll: TRadioButton
      Left = 10
      Top = 20
      Width = 221
      Height = 17
      Caption = #1042#1089#1077' '#1079#1072#1087#1080#1089#1080' '#1074' '#1090#1072#1073#1083#1080#1094#1077
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbCurSel: TRadioButton
      Left = 10
      Top = 42
      Width = 227
      Height = 17
      Caption = #1058#1086#1083#1100#1082#1086' '#1090#1077#1082#1091#1097#1072#1103' '#1074#1099#1073#1086#1088#1082#1072
      TabOrder = 1
    end
    object rbCurKind: TRadioButton
      Left = 10
      Top = 64
      Width = 225
      Height = 17
      Caption = #1042#1089#1077' '#1079#1072#1087#1080#1089#1080' '#1089' '#1090#1077#1082#1091#1097#1080#1084' '#1074#1080#1076#1086#1084' '#1088#1072#1089#1093#1086#1076#1072
      TabOrder = 2
    end
    object rbCurRec: TRadioButton
      Left = 10
      Top = 86
      Width = 225
      Height = 17
      Caption = #1058#1077#1082#1091#1097#1072#1103' '#1079#1072#1087#1080#1089#1100
      TabOrder = 3
    end
  end
  object ceDollar: TJvValidateEdit
    Left = 82
    Top = 128
    Width = 107
    Height = 21
    AutoSize = False
    CheckChars = '01234567890'
    CriticalPoints.CheckPoints = cpNone
    CriticalPoints.ColorAbove = clBlue
    CriticalPoints.ColorBelow = clRed
    EditText = '6'
    PasswordChar = #0
    TabOrder = 3
    Text = '6'
    Value = 6
  end
end
