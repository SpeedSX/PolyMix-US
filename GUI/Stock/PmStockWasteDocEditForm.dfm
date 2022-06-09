inherited StockWasteDocEditForm: TStockWasteDocEditForm
  Caption = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
  PixelsPerInch = 96
  TextHeight = 13
  inherited Label2: TLabel
    Left = 134
    ExplicitLeft = 134
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
  inherited edDocNum: TDBEdit
    Width = 107
    DataField = 'DocNum'
    ExplicitWidth = 107
  end
  inherited deDate: TJvDBDatePickerEdit
    Left = 134
    DataField = 'WasteDate'
    ExplicitLeft = 134
  end
  inherited dgItems: TMyDBGridEh
    AutoFitColWidths = True
    Columns = <
      item
        EditButtons = <>
        FieldName = 'ID_Number'
        Footers = <>
        Title.Caption = #8470' '#1079#1072#1082#1072#1079#1072
      end
      item
        EditButtons = <>
        FieldName = 'MatName'
        Footers = <>
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1084#1072#1090#1077#1088#1080#1072#1083#1072
        Width = 276
      end
      item
        EditButtons = <>
        FieldName = 'WasteQuantity'
        Footers = <>
        Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
      end
      item
        EditButtons = <>
        FieldName = 'MatUnitName'
        Footers = <>
        Title.Caption = #1077#1076'.'
        Width = 30
      end>
  end
  inherited lkPayType: TJvDBLookupCombo
    Left = 242
    Width = 125
    ExplicitLeft = 242
    ExplicitWidth = 125
  end
  object cbWare: TDBLookupComboboxEh [21]
    Left = 380
    Top = 29
    Width = 93
    Height = 21
    DataField = 'WareCode'
    EditButtons = <>
    KeyField = 'Code'
    ListField = 'Name'
    ListSource = dsWare
    TabOrder = 12
    Visible = True
  end
  inherited FormStorage: TJvFormStorage
    AppStoragePath = 'StockWasteDocForm\'
    Top = 72
  end
  inherited dsContragent: TDataSource
    Left = 372
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
