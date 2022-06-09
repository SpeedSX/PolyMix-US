object MakeCalcForm: TMakeCalcForm
  Left = 161
  Top = 764
  BorderStyle = bsDialog
  Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077' '#1079#1072#1082#1072#1079#1072' '#1074' '#1088#1072#1089#1095#1077#1090
  ClientHeight = 213
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    347
    213)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 10
    Top = 14
    Width = 64
    Height = 13
    Caption = #1062#1074#1077#1090' '#1089#1090#1088#1086#1082#1080
  end
  object btOk: TBitBtn
    Left = 146
    Top = 181
    Width = 93
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    TabOrder = 0
    OnClick = btOkClick
    NumGlyphs = 2
    Spacing = 7
    ExplicitTop = 198
  end
  object btCancel: TBitBtn
    Left = 246
    Top = 181
    Width = 93
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
    NumGlyphs = 2
    Spacing = 7
    ExplicitTop = 198
  end
  object acColorBox: TAnyColorCombo
    Left = 92
    Top = 11
    Width = 117
    Height = 20
    ColorValue = clWhite
    DisplayNames = False
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 8
    Top = 42
    Width = 331
    Height = 130
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = ' '
    TabOrder = 3
    ExplicitHeight = 147
    object lbWarning: TJvHTLabel
      Left = 10
      Top = 6
      Width = 29
      Height = 14
      Caption = #1058#1077#1082#1089#1090
    end
  end
end
