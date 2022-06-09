object JobSplitShiftForm: TJobSplitShiftForm
  Left = 289
  Top = 744
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = #1056#1072#1079#1073#1080#1074#1082#1072' '#1088#1072#1073#1086#1090#1099
  ClientHeight = 239
  ClientWidth = 364
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    364
    239)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 10
    Width = 157
    Height = 13
    Caption = #1055#1077#1088#1077#1089#1077#1095#1077#1085#1080#1077' '#1089' '#1085#1072#1095#1072#1083#1086#1084' '#1089#1084#1077#1085#1099':'
  end
  object lbOrderNumber: TLabel
    Left = 64
    Top = 30
    Width = 293
    Height = 13
    AutoSize = False
    Caption = 'lbOrderNumber'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbJobComment: TLabel
    Left = 12
    Top = 50
    Width = 345
    Height = 29
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'lbJobComment'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 12
    Top = 30
    Width = 33
    Height = 13
    Caption = #1047#1072#1082#1072#1079':'
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 87
    Width = 347
    Height = 112
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1044#1077#1081#1089#1090#1074#1080#1077
    TabOrder = 0
    object rbN: TRadioButton
      Left = 8
      Top = 20
      Width = 137
      Height = 17
      Caption = #1056#1072#1079#1073#1080#1090#1100' '#1087#1086' '#1090#1080#1088#1072#1078#1091
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbMult: TRadioButton
      Left = 8
      Top = 42
      Width = 113
      Height = 17
      Caption = #1056#1072#1079#1073#1080#1090#1100' '#1087#1086' '#1083#1080#1089#1090#1072#1084
      TabOrder = 1
    end
    object rbColor: TRadioButton
      Left = 8
      Top = 64
      Width = 209
      Height = 17
      Caption = #1056#1072#1079#1073#1080#1090#1100' '#1087#1086' '#1089#1090#1086#1088#1086#1085#1072#1084'/'#1082#1088#1072#1089#1086#1095#1085#1086#1089#1090#1080
      TabOrder = 2
    end
    object rbAtShiftStart: TRadioButton
      Left = 8
      Top = 86
      Width = 209
      Height = 17
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1085#1072' '#1085#1072#1095#1072#1083#1086' '#1089#1084#1077#1085#1099
      TabOrder = 3
    end
  end
  object btOk: TButton
    Left = 198
    Top = 207
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 1
    ExplicitTop = 173
  end
  object btCancel: TButton
    Left = 282
    Top = 207
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
    ExplicitTop = 173
  end
end
