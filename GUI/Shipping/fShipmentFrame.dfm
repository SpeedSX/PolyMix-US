inherited ShipmentFrame: TShipmentFrame
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
      Width = 644
      Height = 426
      Align = alClient
      BevelOuter = bvNone
      Caption = ' '
      Constraints.MinHeight = 30
      TabOrder = 0
      ExplicitWidth = 281
      ExplicitHeight = 304
      object dgShipment: TMyDBGridEh
        Left = 0
        Top = 0
        Width = 644
        Height = 426
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
        OnDblClick = dgShipmentDblClick
        OnDrawColumnCell = dgShipmentDrawColumnCell
        OnGetCellParams = dgShipmentGetCellParams
        Columns = <
          item
            EditButtons = <>
            FieldName = 'ShipmentState'
            Footers = <>
            MaxWidth = 20
            MinWidth = 20
            Title.Caption = ' '
            Width = 20
          end
          item
            EditButtons = <>
            FieldName = 'ID_Number'
            Footers = <>
            Title.Caption = #8470' '#1079#1072#1082#1072#1079#1072
            Width = 57
            OnGetCellParams = dgShipmentColumns1GetCellParams
          end
          item
            EditButtons = <>
            FieldName = 'CustomerName'
            Footers = <>
            Title.Caption = #1047#1072#1082#1072#1079#1095#1080#1082
            Width = 129
            OnGetCellParams = dgShipmentColumns1GetCellParams
          end
          item
            EditButtons = <>
            FieldName = 'Comment'
            Footers = <>
            Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            Width = 143
            OnGetCellParams = dgShipmentColumns1GetCellParams
          end
          item
            EditButtons = <>
            FieldName = 'Tirazz'
            Footers = <>
            Title.Caption = #1058#1080#1088#1072#1078
            OnGetCellParams = dgShipmentColumns1GetCellParams
          end
          item
            EditButtons = <>
            FieldName = 'Quantity'
            Footers = <>
            Title.Caption = #1054#1090#1075#1088#1091#1078#1077#1085#1086
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = 'ShipmentDate'
            Footers = <>
            Title.Caption = #1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080
            Width = 60
          end
          item
            EditButtons = <>
            FieldName = 'WhoOut'
            Footers = <>
            Title.Caption = #1042#1099#1076#1072#1083
          end
          item
            EditButtons = <>
            FieldName = 'WhoIn'
            Footers = <>
            Title.Caption = #1055#1088#1080#1085#1103#1083
          end>
      end
    end
  end
  object InvoiceTimer: TTimer
    Enabled = False
    Interval = 200
    Left = 56
    Top = 452
  end
end
