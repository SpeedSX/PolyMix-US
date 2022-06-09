inherited StockIncomeDocEditForm: TStockIncomeDocEditForm
  Caption = #1055#1088#1080#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
  PixelsPerInch = 96
  TextHeight = 13
  inherited Label2: TLabel
    Left = 134
    ExplicitLeft = 134
  end
  inherited lbContragent: TLabel
    Width = 68
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
    ExplicitWidth = 68
  end
  inherited Label5: TLabel
    Left = 242
    ExplicitLeft = 242
  end
  object lbWare: TLabel [8]
    Left = 380
    Top = 12
    Width = 40
    Height = 13
    Caption = #1057#1082#1083#1072#1076':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  inherited memoNotes: TDBMemo
    TabOrder = 6
  end
  inherited btOk: TButton
    TabOrder = 11
  end
  inherited btCancel: TButton
    TabOrder = 12
  end
  inherited edDocNum: TDBEdit
    Width = 107
    DataField = 'DocNum'
    ExplicitWidth = 107
  end
  inherited deDate: TJvDBDatePickerEdit
    Left = 134
    DataField = 'IncomeDate'
    ExplicitLeft = 134
  end
  inherited lkContragent: TJvDBLookupCombo
    DataField = 'SupplierID'
    TabOrder = 5
  end
  inherited dgItems: TMyDBGridEh
    AutoFitColWidths = True
    TabOrder = 7
    Columns = <
      item
        EditButtons = <>
        FieldName = 'MatName'
        Footers = <>
        Title.Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072' '#1084#1072#1090#1077#1088#1080#1072#1083#1072
        Width = 255
      end
      item
        EditButtons = <>
        FieldName = 'IncomeQuantity'
        Footers = <>
        Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        Width = 70
      end
      item
        EditButtons = <>
        FieldName = 'MatUnitName'
        Footers = <>
        Title.Caption = #1077#1076'.'
        Width = 42
      end
      item
        EditButtons = <>
        FieldName = 'ItemPrice'
        Footers = <>
        Title.Caption = #1062#1077#1085#1072' '#1079#1072' 1'
        Width = 81
      end
      item
        EditButtons = <>
        FieldName = 'ItemCost'
        Footers = <>
        Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
        Width = 80
      end>
  end
  inherited btNewItem: TBitBtn
    TabOrder = 8
  end
  inherited btEditItem: TBitBtn
    TabOrder = 9
  end
  inherited btDelItem: TBitBtn
    TabOrder = 10
  end
  inherited edUserName: TDBEdit
    TabOrder = 4
  end
  inherited lkPayType: TJvDBLookupCombo
    Left = 242
    Width = 125
    TabOrder = 2
    ExplicitLeft = 242
    ExplicitWidth = 125
  end
  object cbWare: TDBLookupComboboxEh [21]
    Left = 380
    Top = 29
    Width = 93
    Height = 21
    DataField = 'WareCode'
    DropDownBox.ListSource = dsWare
    EditButtons = <>
    KeyField = 'Code'
    ListField = 'Name'
    ListSource = dsWare
    TabOrder = 3
    Visible = True
  end
  inherited FormStorage: TJvFormStorage
    AppStoragePath = 'StockIncomeDocForm\'
    Left = 372
    Top = 70
  end
  inherited dsContragent: TDataSource
    Left = 406
    Top = 70
  end
  inherited dsPayType: TDataSource
    Left = 340
    Top = 70
  end
  object dsWare: TDataSource
    Left = 308
    Top = 70
  end
end
