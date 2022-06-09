inherited StockWasteDocItemEditForm: TStockWasteDocItemEditForm
  Caption = #1054#1090#1087#1091#1089#1082' '#1084#1072#1090#1077#1088#1080#1072#1083#1072' '#1089#1086' '#1089#1082#1083#1072#1076#1072
  OnCreate = FormCreate
  DesignSize = (
    561
    206)
  PixelsPerInch = 96
  TextHeight = 13
  inherited lbSource: TLabel
    Left = 154
    Width = 100
    Caption = #1052#1072#1090#1077#1088#1080#1072#1083' '#1074' '#1079#1072#1082#1072#1079#1077':'
    ExplicitLeft = 154
    ExplicitWidth = 100
  end
  inherited lbEditableName: TLabel
    Top = 8
    Width = 54
    Caption = #8470' '#1079#1072#1082#1072#1079#1072':'
    ExplicitTop = 8
    ExplicitWidth = 54
  end
  object Label1: TLabel [6]
    Left = 12
    Top = 60
    Width = 77
    Height = 13
    Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072':'
  end
  inherited btOk: TButton
    TabOrder = 6
  end
  inherited btCancel: TButton
    TabOrder = 7
  end
  inherited comboSource: TDBLookupComboboxEh
    Left = 154
    Width = 393
    DataField = 'MatID'
    DropDownBox.AutoFitColWidths = True
    DropDownBox.ShowTitles = False
    KeyField = 'MatID'
    ListField = 'MatDesc;MatAmount;MatUnitName'
    ExplicitLeft = 154
    ExplicitWidth = 303
  end
  inherited edItemText: TDBEdit
    Top = 27
    Width = 57
    DataField = 'ID_Number'
    ReadOnly = False
    TabOrder = 0
    ExplicitTop = 27
    ExplicitWidth = 57
  end
  inherited edQuantity: TDBEdit
    DataField = 'WasteQuantity'
  end
  object btSelect: TBitBtn [13]
    Left = 76
    Top = 24
    Width = 69
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100
    TabOrder = 1
    OnClick = btSelectClick
  end
  object comboStock: TDBLookupComboboxEh [14]
    Left = 12
    Top = 79
    Width = 535
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'MatCode'
    DropDownBox.Options = [dlgColumnResizeEh, dlgColLinesEh]
    DropDownBox.AutoDrop = True
    DropDownBox.Rows = 20
    DropDownBox.Sizable = True
    EditButtons = <>
    KeyField = 'Code'
    ListField = 'Name'
    ListSource = dsStockItems
    TabOrder = 3
    Visible = True
    OnChange = comboSourceChange
    ExplicitWidth = 445
  end
  object dsStockItems: TDataSource
    Left = 408
    Top = 48
  end
end
