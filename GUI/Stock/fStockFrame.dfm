inherited StockFrame: TStockFrame
  inherited paFilter: TPanel
    TabOrder = 1
    ExplicitLeft = 281
    ExplicitHeight = 304
  end
  object dgStock: TMyDBGridEh
    Left = 0
    Top = 0
    Width = 281
    Height = 304
    Align = alClient
    AllowedOperations = []
    AllowedSelections = [gstRecordBookmarks]
    AutoFitColWidths = True
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghEnterAsTab, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
    RowHeight = 16
    RowSizingAllowed = True
    SortLocal = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    TitleLines = 1
    UseMultiTitle = True
    VTitleMargin = 5
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Name'
        Footers = <>
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 263
      end
      item
        EditButtons = <>
        FieldName = 'RemainsQuantity'
        Footers = <>
        Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        Width = 91
      end
      item
        EditButtons = <>
        FieldName = 'RemainsCost'
        Footers = <>
        Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
        Width = 99
      end>
  end
end
