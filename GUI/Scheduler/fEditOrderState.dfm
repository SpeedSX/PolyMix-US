object EditOrderStateForm: TEditOrderStateForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1086#1089#1090#1086#1103#1085#1080#1103' '#1079#1072#1082#1072#1079#1072
  ClientHeight = 192
  ClientWidth = 245
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label10: TLabel
    Left = 8
    Top = 40
    Width = 165
    Height = 13
    Caption = #1058#1077#1082#1091#1097#1077#1077' '#1089#1086#1089#1090#1086#1103#1085#1080#1077' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103
  end
  object Label1: TLabel
    Left = 8
    Top = 96
    Width = 174
    Height = 13
    Caption = #1053#1086#1074#1086#1077' '#1089#1086#1089#1090#1086#1103#1085#1080#1077' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbOrderNumPrompt: TLabel
    Left = 8
    Top = 8
    Width = 34
    Height = 13
    Caption = #1047#1072#1082#1072#1079
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbOrderNum: TLabel
    Left = 56
    Top = 8
    Width = 57
    Height = 13
    Caption = 'lbOrderNum'
  end
  object cbOrderState: TJvDBLookupCombo
    Left = 8
    Top = 60
    Width = 225
    Height = 21
    DropDownCount = 10
    DataField = 'OrderState'
    DisplayEmpty = '<'#1085#1077' '#1091#1082#1072#1079#1072#1085#1086'>'
    EmptyItemColor = clMenu
    ItemHeight = 16
    LookupField = 'Code'
    LookupDisplay = 'Name'
    ReadOnly = True
    TabOrder = 0
    OnChange = cbOrderStateChange
    OnGetImage = cbOrderStateGetImage
  end
  object cbNewOrderState: TJvDBLookupCombo
    Left = 8
    Top = 116
    Width = 225
    Height = 21
    DropDownCount = 10
    DataField = 'OrderState'
    DisplayEmpty = '<'#1085#1077' '#1091#1082#1072#1079#1072#1085#1086'>'
    EmptyItemColor = clMenu
    ItemHeight = 16
    LookupField = 'Code'
    LookupDisplay = 'Name'
    TabOrder = 1
    OnChange = cbOrderStateChange
    OnGetImage = cbOrderStateGetImage
  end
  object btOk: TButton
    Left = 64
    Top = 156
    Width = 75
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btCancel: TButton
    Left = 149
    Top = 156
    Width = 84
    Height = 25
    Cancel = True
    Caption = #1053#1077' '#1080#1079#1084#1077#1085#1103#1090#1100
    ModalResult = 2
    TabOrder = 3
  end
end
