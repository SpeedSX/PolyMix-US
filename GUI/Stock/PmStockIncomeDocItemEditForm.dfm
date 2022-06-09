inherited StockIncomeDocItemEditForm: TStockIncomeDocItemEditForm
  Caption = #1052#1072#1090#1077#1088#1080#1072#1083
  ClientHeight = 203
  OnCreate = FormCreate
  ExplicitWidth = 320
  ExplicitHeight = 235
  DesignSize = (
    561
    203)
  PixelsPerInch = 96
  TextHeight = 13
  inherited lbSource: TLabel
    Width = 134
    Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072' '#1084#1072#1090#1077#1088#1080#1072#1083#1072':'
    ExplicitWidth = 134
  end
  inherited lbEditableName: TLabel
    Width = 134
    Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072' '#1084#1072#1090#1077#1088#1080#1072#1083#1072':'
    ExplicitWidth = 134
  end
  inherited lbItemCost: TLabel
    Left = 197
    ExplicitLeft = 197
  end
  inherited lbItemPrice: TLabel
    Left = 325
    ExplicitLeft = 325
  end
  inherited dtPrice: TDBText
    Left = 15
    Top = 160
    DataField = 'ItemPrice'
    ExplicitLeft = 15
    ExplicitTop = 160
  end
  object Label6: TLabel [6]
    Left = 116
    Top = 111
    Width = 21
    Height = 13
    Caption = #1045#1076'.:'
  end
  inherited btOk: TButton
    Top = 168
    TabOrder = 7
    ExplicitTop = 162
  end
  inherited btCancel: TButton
    Top = 168
    TabOrder = 8
    ExplicitTop = 162
  end
  inherited comboSource: TDBLookupComboboxEh
    DataField = 'MatCode'
    DropDownBox.AutoFitColWidths = True
    DropDownBox.Columns = <
      item
        FieldName = 'Name'
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 50
      end>
    DropDownBox.Options = [dlgColLinesEh]
    DropDownBox.ShowTitles = False
    KeyField = 'Code'
    ListField = 'Name'
    TabOrder = 0
  end
  inherited edItemText: TDBEdit
    DataField = 'MatName'
    TabOrder = 1
  end
  inherited edQuantity: TDBEdit
    Width = 91
    DataField = 'IncomeQuantity'
    TabOrder = 2
    ExplicitWidth = 91
  end
  inherited edItemCost: TDBEdit
    Left = 196
    Width = 109
    ReadOnly = False
    TabOrder = 4
    ExplicitLeft = 196
    ExplicitWidth = 109
  end
  object edMatUnit: TDBEdit [13]
    Left = 116
    Top = 130
    Width = 61
    Height = 21
    DataField = 'MatUnitName'
    Enabled = False
    ReadOnly = True
    TabOrder = 3
  end
  object edItemPrice: TDBEdit [14]
    Left = 324
    Top = 130
    Width = 87
    Height = 21
    DataField = 'ItemPrice'
    TabOrder = 5
  end
  object cbManualFix: TDBCheckBox [15]
    Left = 428
    Top = 132
    Width = 83
    Height = 17
    Caption = #1050#1086#1088#1088#1077#1082#1094#1080#1103
    DataField = 'ManualFix'
    TabOrder = 6
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
end
