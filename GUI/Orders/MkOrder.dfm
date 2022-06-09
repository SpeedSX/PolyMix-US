object MakeOrderForm: TMakeOrderForm
  Left = 109
  Top = 717
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1090#1072#1090#1091#1089#1072' '#1079#1072#1082#1072#1079#1072': '#1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1079#1072#1082#1072#1079#1072' '#1074' '#1088#1072#1073#1086#1090#1091
  ClientHeight = 233
  ClientWidth = 367
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
  DesignSize = (
    367
    233)
  PixelsPerInch = 96
  TextHeight = 13
  object btOk: TBitBtn
    Left = 157
    Top = 200
    Width = 103
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1057#1086#1079#1076#1072#1090#1100' '#1079#1072#1082#1072#1079
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = btOkClick
    NumGlyphs = 2
    Spacing = 7
  end
  object btCancel: TBitBtn
    Left = 266
    Top = 200
    Width = 93
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
    NumGlyphs = 2
    Spacing = 7
  end
  object Panel1: TPanel
    Left = 4
    Top = 4
    Width = 358
    Height = 183
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 218
      Top = 132
      Width = 68
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1079#1072#1082#1072#1079#1072
      Visible = False
    end
    object Label9: TLabel
      Left = 14
      Top = 48
      Width = 113
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1083#1072#1085#1086#1074#1086#1077' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1077
    end
    object Label10: TLabel
      Left = 8
      Top = 84
      Width = 119
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103
    end
    object Label11: TLabel
      Left = 32
      Top = 118
      Width = 95
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1086#1087#1083#1072#1090#1099
    end
    object Label2: TLabel
      Left = 63
      Top = 15
      Width = 64
      Height = 13
      Alignment = taRightJustify
      Caption = #1062#1074#1077#1090' '#1089#1090#1088#1086#1082#1080
    end
    object udNum: TUpDown
      Left = 279
      Top = 150
      Width = 16
      Height = 21
      Associate = edNum
      Min = 1
      Max = 30000
      Position = 1
      TabOrder = 1
      Thousands = False
      Visible = False
    end
    object edNum: TEdit
      Left = 218
      Top = 150
      Width = 61
      Height = 21
      TabOrder = 0
      Text = '1'
      Visible = False
    end
    object cbMakeCopy: TCheckBox
      Left = 8
      Top = 152
      Width = 189
      Height = 17
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1089#1093#1086#1076#1085#1099#1081' '#1087#1088#1086#1089#1095#1077#1090
      TabOrder = 2
    end
    object acColorBox: TAnyColorCombo
      Left = 137
      Top = 12
      Width = 109
      Height = 20
      ColorValue = clWhite
      DisplayNames = False
      TabOrder = 4
    end
    object deFinishDate: TJvDateEdit
      Left = 137
      Top = 45
      Width = 109
      Height = 21
      ImageKind = ikDropDown
      ButtonWidth = 17
      TabOrder = 3
      OnChange = deFinishDateChange
    end
    object cbOrderState: TJvDBLookupCombo
      Left = 137
      Top = 80
      Width = 171
      Height = 21
      DropDownCount = 10
      DataField = 'OrderState'
      DisplayEmpty = '<'#1085#1077' '#1091#1082#1072#1079#1072#1085#1086'>'
      EmptyItemColor = clMenu
      ItemHeight = 16
      LookupField = 'Code'
      LookupDisplay = 'Name'
      TabOrder = 5
      OnGetImage = cbOrderStateGetImage
    end
    object cbPayState: TJvDBLookupCombo
      Left = 137
      Top = 115
      Width = 171
      Height = 21
      DropDownCount = 10
      DataField = 'PayState'
      DisplayEmpty = '<'#1085#1077' '#1091#1082#1072#1079#1072#1085#1086'>'
      EmptyItemColor = clMenu
      ItemHeight = 16
      LookupField = 'Code'
      LookupDisplay = 'Name'
      TabOrder = 6
      OnGetImage = cbPayStateGetImage
    end
    object tmFinish: TMaskEdit
      Left = 258
      Top = 45
      Width = 50
      Height = 21
      EditMask = '!90:00;1; '
      MaxLength = 5
      TabOrder = 7
      Text = '  :  '
    end
  end
end
