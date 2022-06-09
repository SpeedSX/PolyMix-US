object JobSplitForm: TJobSplitForm
  Left = 289
  Top = 744
  BorderStyle = bsDialog
  Caption = #1056#1072#1079#1073#1080#1074#1082#1072' '#1088#1072#1073#1086#1090#1099
  ClientHeight = 155
  ClientWidth = 200
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
    Width = 185
    Height = 101
    Caption = ' '#1056#1072#1079#1073#1080#1090#1100' '#1088#1072#1073#1086#1090#1091'... '
    TabOrder = 0
    object rbN: TRadioButton
      Left = 8
      Top = 24
      Width = 137
      Height = 17
      Caption = #1055#1086' '#1090#1080#1088#1072#1078#1091
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbMult: TRadioButton
      Left = 8
      Top = 48
      Width = 113
      Height = 17
      Caption = #1055#1086' '#1083#1080#1089#1090#1072#1084
      TabOrder = 1
    end
    object rbColor: TRadioButton
      Left = 8
      Top = 72
      Width = 169
      Height = 17
      Caption = #1055#1086' '#1089#1090#1086#1088#1086#1085#1072#1084'/'#1082#1088#1072#1089#1086#1095#1085#1086#1089#1090#1080
      TabOrder = 2
    end
  end
  object btOk: TButton
    Left = 36
    Top = 124
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btCancel: TButton
    Left = 120
    Top = 124
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
end
