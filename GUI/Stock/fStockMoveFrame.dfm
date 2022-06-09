inherited StockMoveFrame: TStockMoveFrame
  inherited paFilter: TPanel
    TabOrder = 1
    ExplicitLeft = 281
    ExplicitHeight = 304
  end
  object dgStockMove: TMyDBGridEh
    Left = 0
    Top = 0
    Width = 281
    Height = 304
    Align = alClient
    AllowedOperations = []
    AllowedSelections = [gstRecordBookmarks]
    AutoFitColWidths = True
    DataGrouping.GroupLevels = <>
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghEnterAsTab, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
    RowDetailPanel.Color = clBtnFace
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
        FieldName = 'MoveDate'
        Footers = <>
        Title.Caption = #1044#1072#1090#1072
      end
      item
        EditButtons = <>
        FieldName = 'Name'
        Footers = <>
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1084#1072#1090#1077#1088#1080#1072#1083#1072
        Width = 207
      end
      item
        EditButtons = <>
        FieldName = 'MatUnitName'
        Footers = <>
        Title.Caption = #1077#1076'.'
        Width = 50
      end
      item
        EditButtons = <>
        FieldName = 'IncomeQuantity'
        Footers = <>
        Title.Caption = #1055#1088#1080#1093#1086#1076'|'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        Width = 91
      end
      item
        EditButtons = <>
        FieldName = 'IncomeCost'
        Footers = <>
        Title.Caption = #1055#1088#1080#1093#1086#1076'|'#1057#1090#1086#1080#1084#1086#1089#1090#1100
        Width = 97
      end
      item
        EditButtons = <>
        FieldName = 'WasteQuantity'
        Footers = <>
        Title.Caption = #1056#1072#1089#1093#1086#1076'|'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        Width = 94
      end
      item
        EditButtons = <>
        FieldName = 'WasteCost'
        Footers = <>
        Title.Caption = #1056#1072#1089#1093#1086#1076'|'#1057#1090#1086#1080#1084#1086#1089#1090#1100
        Width = 87
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
end
