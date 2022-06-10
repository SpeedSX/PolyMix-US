object PersonForm: TPersonForm
  Left = 231
  Top = 631
  ActiveControl = DBEdit1
  BorderStyle = bsDialog
  Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1086#1077' '#1083#1080#1094#1086
  ClientHeight = 289
  ClientWidth = 458
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    458
    289)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 12
    Width = 37
    Height = 13
    Caption = #1060'.'#1048'.'#1054'.:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 12
    Top = 60
    Width = 84
    Height = 13
    Caption = #1042#1080#1076' '#1082#1086#1085#1090#1072#1082#1090#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 12
    Top = 108
    Width = 91
    Height = 13
    Caption = #1058#1077#1083#1077#1092#1086#1085' '#1074' '#1086#1092#1080#1089#1077':'
  end
  object Label4: TLabel
    Left = 256
    Top = 108
    Width = 109
    Height = 13
    Caption = #1052#1086#1073#1080#1083#1100#1085#1099#1081' '#1090#1077#1083#1077#1092#1086#1085':'
  end
  object Label5: TLabel
    Left = 12
    Top = 156
    Width = 32
    Height = 13
    Caption = 'E-mail:'
  end
  object Label6: TLabel
    Left = 256
    Top = 156
    Width = 84
    Height = 13
    Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103':'
  end
  object Label7: TLabel
    Left = 12
    Top = 204
    Width = 65
    Height = 13
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103':'
  end
  object btOk: TButton
    Left = 286
    Top = 255
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 7
  end
  object btCancel: TButton
    Left = 374
    Top = 255
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 8
  end
  object DBEdit1: TDBEdit
    Left = 12
    Top = 30
    Width = 437
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'Name'
    DataSource = PersonDataSource
    TabOrder = 0
  end
  object DBEdit2: TDBEdit
    Left = 12
    Top = 222
    Width = 435
    Height = 21
    DataField = 'PersonNote'
    DataSource = PersonDataSource
    TabOrder = 2
  end
  object DBEdit3: TDBEdit
    Left = 12
    Top = 127
    Width = 229
    Height = 21
    DataField = 'Phone'
    DataSource = PersonDataSource
    TabOrder = 3
  end
  object DBEdit4: TDBEdit
    Left = 256
    Top = 126
    Width = 193
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'PhoneCell'
    DataSource = PersonDataSource
    TabOrder = 4
  end
  object DBEdit5: TDBEdit
    Left = 12
    Top = 174
    Width = 229
    Height = 21
    DataField = 'Email'
    DataSource = PersonDataSource
    TabOrder = 5
  end
  object dtBirthday: TJvDateEdit
    Left = 256
    Top = 174
    Width = 113
    Height = 21
    DialogTitle = #1042#1099#1073#1086#1088' '#1076#1072#1090#1099
    ImageKind = ikDropDown
    Weekends = [Sun, Sat]
    TabOrder = 6
  end
  object cbPersonType: TDBLookupComboboxEh
    Left = 12
    Top = 78
    Width = 229
    Height = 21
    DataField = 'PersonType'
    DataSource = PersonDataSource
    DropDownBox.AutoDrop = True
    EditButtons = <>
    KeyField = 'Code'
    ListField = 'Name'
    ListSource = dsPersonType
    TabOrder = 1
    Visible = True
    OnClick = cbPersonTypeClick
  end
  object PersonDataSource: TDataSource
    Left = 12
    Top = 260
  end
  object dsPersonType: TDataSource
    Left = 52
    Top = 258
  end
end
