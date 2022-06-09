inherited DocItemEditForm: TDocItemEditForm
  Caption = #1055#1086#1079#1080#1094#1080#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  ClientHeight = 206
  ClientWidth = 561
  ExplicitWidth = 567
  ExplicitHeight = 238
  DesignSize = (
    561
    206)
  PixelsPerInch = 96
  TextHeight = 13
  object lbSource: TLabel [0]
    Left = 12
    Top = 8
    Width = 52
    Height = 13
    Caption = #1048#1089#1090#1086#1095#1085#1080#1082':'
  end
  object lbEditableName: TLabel [1]
    Left = 12
    Top = 60
    Width = 77
    Height = 13
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
  end
  object lbQuantity: TLabel [2]
    Left = 12
    Top = 112
    Width = 64
    Height = 13
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086':'
  end
  object lbItemCost: TLabel [3]
    Left = 156
    Top = 112
    Width = 58
    Height = 13
    Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100':'
  end
  object lbItemPrice: TLabel [4]
    Left = 295
    Top = 112
    Width = 64
    Height = 13
    Caption = #1062#1077#1085#1072' '#1079#1072' '#1077#1076'.:'
  end
  object dtPrice: TDBText [5]
    Left = 295
    Top = 132
    Width = 162
    Height = 17
    DataField = 'Price'
    Visible = False
  end
  inherited btOk: TButton
    Left = 385
    Top = 171
    ExplicitTop = 158
  end
  inherited btCancel: TButton
    Left = 474
    Top = 171
    ExplicitTop = 158
  end
  object comboSource: TDBLookupComboboxEh [8]
    Left = 12
    Top = 27
    Width = 537
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'InvoiceItemID'
    DropDownBox.AutoFitColWidths = False
    DropDownBox.Options = [dlgColumnResizeEh, dlgColLinesEh]
    DropDownBox.AutoDrop = True
    DropDownBox.Rows = 20
    DropDownBox.ShowTitles = True
    DropDownBox.Sizable = True
    EditButtons = <>
    KeyField = 'InvoiceItemID'
    ListField = 'ItemText'
    ListSource = dsItemSource
    TabOrder = 2
    Visible = True
    OnChange = comboSourceChange
    ExplicitWidth = 447
  end
  object edItemText: TDBEdit [9]
    Left = 12
    Top = 79
    Width = 535
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'ItemText'
    ReadOnly = True
    TabOrder = 3
    ExplicitWidth = 445
  end
  object edQuantity: TDBEdit [10]
    Left = 12
    Top = 130
    Width = 121
    Height = 21
    DataField = 'SaleQuantity'
    TabOrder = 4
  end
  object edItemCost: TDBEdit [11]
    Left = 156
    Top = 130
    Width = 121
    Height = 21
    DataField = 'ItemCost'
    ReadOnly = True
    TabOrder = 5
  end
  inherited FormStorage: TJvFormStorage
    AppStoragePath = 'SaleItemForm\'
  end
  object dsItemSource: TDataSource
    Left = 408
    Top = 12
  end
end
