inherited AddressForm: TAddressForm
  Left = 231
  Top = 45
  ActiveControl = edAddr
  Caption = #1040#1076#1088#1077#1089
  ClientHeight = 153
  ClientWidth = 459
  ExplicitWidth = 465
  ExplicitHeight = 185
  DesignSize = (
    459
    153)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 12
    Top = 12
    Width = 35
    Height = 13
    Caption = #1040#1076#1088#1077#1089':'
  end
  object Label2: TLabel [1]
    Left = 12
    Top = 64
    Width = 65
    Height = 13
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103':'
  end
  inherited btOk: TButton
    Left = 287
    Top = 120
    TabOrder = 2
    ExplicitLeft = 287
    ExplicitTop = 120
  end
  inherited btCancel: TButton
    Left = 376
    Top = 120
    TabOrder = 3
    ExplicitLeft = 376
    ExplicitTop = 120
  end
  object edAddr: TDBEdit [4]
    Left = 12
    Top = 32
    Width = 438
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'Address'
    DataSource = AddressDataSource
    TabOrder = 0
  end
  object edNote: TDBEdit [5]
    Left = 12
    Top = 84
    Width = 437
    Height = 21
    DataField = 'Note'
    DataSource = AddressDataSource
    TabOrder = 1
  end
  object AddressDataSource: TDataSource
    Left = 136
    Top = 8
  end
end
