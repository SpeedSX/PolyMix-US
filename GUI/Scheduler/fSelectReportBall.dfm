object SelectReportBallForm: TSelectReportBallForm
  Left = 0
  Top = 0
  ActiveControl = cbDepartment
  BorderStyle = bsDialog
  Caption = #1056#1086#1079#1088#1072#1093#1091#1085#1086#1082' '#1073#1072#1083#1110#1074
  ClientHeight = 170
  ClientWidth = 315
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 9
    Width = 48
    Height = 13
    Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083
  end
  object Label2: TLabel
    Left = 16
    Top = 61
    Width = 85
    Height = 13
    Caption = #1055#1086#1095#1072#1090#1086#1082' '#1087#1077#1088#1110#1086#1076#1072
  end
  object Label3: TLabel
    Left = 180
    Top = 61
    Width = 75
    Height = 13
    Caption = #1050#1110#1085#1077#1094#1100' '#1087#1077#1088#1110#1086#1076#1072
  end
  object cbDepartment: TComboBox
    Left = 16
    Top = 28
    Width = 285
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object deStart: TJvDateEdit
    Left = 16
    Top = 80
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object deEnd: TJvDateEdit
    Left = 180
    Top = 80
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object btOk: TButton
    Left = 141
    Top = 128
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btCancel: TButton
    Left = 226
    Top = 128
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1057#1082#1072#1089#1091#1074#1072#1090#1080
    ModalResult = 2
    TabOrder = 4
  end
end
