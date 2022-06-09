inherited SaleFrame: TSaleFrame
  inherited paFilter: TPanel
    ExplicitLeft = 281
    ExplicitHeight = 304
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 281
    Height = 304
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 1
    object paInvoices: TPanel
      Left = 0
      Top = 0
      Width = 281
      Height = 304
      Align = alClient
      BevelOuter = bvNone
      Caption = ' '
      Constraints.MinHeight = 30
      TabOrder = 0
      object dgSale: TMyDBGridEh
        Left = 0
        Top = 0
        Width = 281
        Height = 304
        Align = alClient
        AllowedOperations = []
        AllowedSelections = [gstNon, gstAll]
        AutoFitColWidths = True
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghIncSearch, dghPreferIncSearch, dghRowHighlight, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
        ReadOnly = True
        RowHeight = 16
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        UseMultiTitle = True
        VTitleMargin = 3
        OnDblClick = dgSaleDblClick
        OnDrawColumnCell = dgSaleDrawColumnCell
        Columns = <
          item
            EditButtons = <>
            FieldName = 'SyncState'
            Footers = <>
            MaxWidth = 18
            MinWidth = 18
            Title.Caption = ' '
            Width = 18
          end
          item
            EditButtons = <>
            FieldName = 'SaleDate'
            Footers = <>
            Title.Alignment = taLeftJustify
            Title.Caption = #1044#1072#1090#1072
            Width = 70
          end
          item
            Alignment = taRightJustify
            EditButtons = <>
            FieldName = 'SaleDocNum'
            Footers = <>
            Title.Alignment = taRightJustify
            Title.Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Width = 76
          end
          item
            EditButtons = <>
            FieldName = 'CustomerName'
            Footers = <>
            Title.Alignment = taLeftJustify
            Title.Caption = #1047#1072#1082#1072#1079#1095#1080#1082
            Width = 191
          end
          item
            Alignment = taRightJustify
            EditButtons = <>
            FieldName = 'OrderNumber'
            Footers = <>
            Title.Alignment = taRightJustify
            Title.Caption = #8470' '#1079#1072#1082#1072#1079#1072
            Width = 73
          end
          item
            EditButtons = <>
            FieldName = 'ItemText'
            Footers = <>
            Title.Caption = #1055#1088#1086#1076#1091#1082#1094#1080#1103
            Width = 143
          end
          item
            Alignment = taRightJustify
            EditButtons = <>
            FieldName = 'SaleQuantity'
            Footers = <>
            Title.Alignment = taRightJustify
            Title.Caption = #1050#1086#1083'-'#1074#1086
            Width = 71
          end
          item
            EditButtons = <>
            FieldName = 'SaleCost'
            Footers = <>
            Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
            Width = 68
          end
          item
            EditButtons = <>
            FieldName = 'WhoOut'
            Footers = <>
            Title.Alignment = taLeftJustify
            Title.Caption = #1042#1099#1076#1072#1083
          end
          item
            EditButtons = <>
            FieldName = 'WhoIn'
            Footers = <>
            Title.Alignment = taLeftJustify
            Title.Caption = #1055#1088#1080#1085#1103#1083
          end>
      end
    end
  end
  object InvoiceTimer: TTimer
    Enabled = False
    Interval = 200
    Left = 626
    Top = 78
  end
end
