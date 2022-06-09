object JobOverlapForm: TJobOverlapForm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = #1055#1077#1088#1077#1082#1088#1099#1074#1072#1102#1097#1080#1077#1089#1103' '#1088#1072#1073#1086#1090#1099
  ClientHeight = 234
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    482
    234)
  PixelsPerInch = 96
  TextHeight = 13
  object lbJob: TLabel
    Left = 10
    Top = 10
    Width = 461
    Height = 13
    AutoSize = False
    Caption = 'lbJob'
  end
  object Label1: TLabel
    Left = 10
    Top = 30
    Width = 41
    Height = 13
    Caption = #1053#1072#1095#1072#1083#1086':'
  end
  object lbStart: TLabel
    Left = 58
    Top = 30
    Width = 31
    Height = 13
    Caption = #1044#1072#1090#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 140
    Top = 30
    Width = 66
    Height = 13
    Caption = #1047#1072#1074#1077#1088#1096#1077#1085#1080#1077':'
  end
  object lbFinish: TLabel
    Left = 212
    Top = 30
    Width = 31
    Height = 13
    Caption = #1044#1072#1090#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 10
    Top = 56
    Width = 461
    Height = 13
    AutoSize = False
    Caption = #1087#1077#1088#1077#1082#1088#1099#1074#1072#1077#1090#1089#1103' '#1089' '#1079#1072#1092#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1086#1081' '#1088#1072#1073#1086#1090#1086#1081':'
  end
  object lbLockedJob: TLabel
    Left = 10
    Top = 82
    Width = 461
    Height = 13
    AutoSize = False
    Caption = 'Locked'
  end
  object Label7: TLabel
    Left = 10
    Top = 102
    Width = 41
    Height = 13
    Caption = #1053#1072#1095#1072#1083#1086':'
  end
  object lbLockedStart: TLabel
    Left = 58
    Top = 102
    Width = 31
    Height = 13
    Caption = #1044#1072#1090#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label9: TLabel
    Left = 140
    Top = 102
    Width = 66
    Height = 13
    Caption = #1047#1072#1074#1077#1088#1096#1077#1085#1080#1077':'
  end
  object lbLockedFinish: TLabel
    Left = 212
    Top = 102
    Width = 31
    Height = 13
    Caption = #1044#1072#1090#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 126
    Width = 463
    Height = 65
    Caption = #1044#1077#1081#1089#1090#1074#1080#1077
    TabOrder = 0
    object rbAfter: TRadioButton
      Left = 10
      Top = 18
      Width = 439
      Height = 17
      Caption = #1056#1072#1079#1084#1077#1089#1090#1080#1090#1100' '#1087#1086#1089#1083#1077' '#1079#1072#1092#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1086#1081
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbSplit: TRadioButton
      Left = 10
      Top = 38
      Width = 439
      Height = 17
      Caption = #1056#1072#1079#1073#1080#1090#1100' '#1085#1072' '#1080#1085#1090#1077#1088#1074#1072#1083#1099
      TabOrder = 1
    end
  end
  object btOk: TButton
    Left = 394
    Top = 200
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
end
