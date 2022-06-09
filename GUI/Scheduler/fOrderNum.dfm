object OrderNumForm: TOrderNumForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#8470' '#1079#1072#1082#1072#1079#1072
  ClientHeight = 86
  ClientWidth = 203
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 16
    Width = 50
    Height = 13
    Caption = #8470' '#1079#1072#1082#1072#1079#1072
  end
  object JvCalcEdit1: TJvCalcEdit
    Left = 76
    Top = 13
    Width = 113
    Height = 21
    DecimalPlaces = 0
    DisplayFormat = '0'
    ShowButton = False
    TabOrder = 0
    DecimalPlacesAlwaysShown = False
  end
  object btOk: TButton
    Left = 12
    Top = 48
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btCancel: TButton
    Left = 114
    Top = 48
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
end
