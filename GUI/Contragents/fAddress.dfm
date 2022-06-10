inherited AddressForm: TAddressForm
  Left = 231
  Top = 45
  ActiveControl = edAddr
  Caption = #1040#1076#1088#1077#1089
  ClientHeight = 306
  ClientWidth = 477
  OnCreate = FormCreate
  ExplicitWidth = 483
  ExplicitHeight = 338
  DesignSize = (
    477
    306)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 14
    Top = 8
    Width = 35
    Height = 13
    Caption = #1040#1076#1088#1077#1089':'
  end
  object Label2: TLabel [1]
    Left = 14
    Top = 209
    Width = 65
    Height = 13
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103':'
  end
  object Label4: TLabel [2]
    Left = 260
    Top = 159
    Width = 118
    Height = 13
    Caption = #1052#1086#1073#1080#1083#1100#1085#1099#1081' '#1090#1077#1083#1077#1092#1086#1085' 2:'
  end
  object Label3: TLabel [3]
    Left = 14
    Top = 159
    Width = 118
    Height = 13
    Caption = #1052#1086#1073#1080#1083#1100#1085#1099#1081' '#1090#1077#1083#1077#1092#1086#1085' 1:'
  end
  object Label5: TLabel [4]
    Left = 14
    Top = 109
    Width = 61
    Height = 13
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel [5]
    Left = 14
    Top = 59
    Width = 23
    Height = 13
    Caption = #1048#1084#1103':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  inherited btOk: TButton
    Left = 305
    Top = 269
    TabOrder = 6
    ExplicitLeft = 305
    ExplicitTop = 269
  end
  inherited btCancel: TButton
    Left = 394
    Top = 269
    TabOrder = 7
    ExplicitLeft = 394
    ExplicitTop = 269
  end
  object edAddr: TDBEdit [8]
    Left = 14
    Top = 28
    Width = 456
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'Address'
    DataSource = AddressDataSource
    TabOrder = 0
  end
  object edNote: TDBEdit [9]
    Left = 14
    Top = 229
    Width = 455
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'Note'
    DataSource = AddressDataSource
    TabOrder = 5
  end
  object DBEdit3: TDBEdit [10]
    Left = 14
    Top = 178
    Width = 229
    Height = 21
    DataField = 'Phone1'
    DataSource = AddressDataSource
    TabOrder = 3
  end
  object DBEdit4: TDBEdit [11]
    Left = 260
    Top = 177
    Width = 211
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'Phone2'
    DataSource = AddressDataSource
    TabOrder = 4
  end
  object cbPersonType: TDBLookupComboboxEh [12]
    Left = 14
    Top = 128
    Width = 229
    Height = 21
    DataField = 'PersonType'
    DataSource = AddressDataSource
    DropDownBox.AutoDrop = True
    EditButtons = <>
    KeyField = 'Code'
    ListField = 'Name'
    ListSource = dsPersonType
    TabOrder = 2
    Visible = True
  end
  object DBEdit1: TDBEdit [13]
    Left = 14
    Top = 78
    Width = 455
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'Name'
    DataSource = AddressDataSource
    TabOrder = 1
  end
  inherited FormStorage: TJvFormStorage
    Left = 96
    Top = 264
  end
  object AddressDataSource: TDataSource
    Left = 12
    Top = 268
  end
  object dsPersonType: TDataSource
    Left = 52
    Top = 266
  end
end
