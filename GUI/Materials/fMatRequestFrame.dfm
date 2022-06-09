inherited MatRequestFrame: TMatRequestFrame
  inherited paFilter: TPanel
    Height = 270
    TabOrder = 2
    ExplicitLeft = 281
    ExplicitHeight = 270
  end
  object dgMatRequests: TMyDBGridEh
    Left = 0
    Top = 0
    Width = 281
    Height = 270
    Align = alClient
    AllowedOperations = []
    AllowedSelections = [gstRecordBookmarks]
    DataGrouping.GroupLevels = <>
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
    RowDetailPanel.Color = clBtnFace
    RowHeight = 16
    RowSizingAllowed = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    TitleLines = 1
    UseMultiTitle = True
    VTitleMargin = 5
    OnDblClick = dgMatRequestsDblClick
    OnDrawColumnCell = dgMatRequestsDrawColumnCell
    OnGetCellParams = dgMatRequestsGetCellParams
    OnTitleBtnClick = dgMatRequestsTitleBtnClick
    Columns = <
      item
        Color = clInfoBk
        EditButtons = <>
        FieldName = 'RequestState'
        Footers = <>
        MaxWidth = 18
        MinWidth = 18
        Title.Caption = ' '
        Visible = False
        Width = 18
      end
      item
        Color = clInfoBk
        EditButtons = <>
        FieldName = 'OrderState'
        Footers = <>
        MaxWidth = 18
        MinWidth = 18
        Title.Caption = ' '
        Title.TitleButton = True
        Width = 18
      end
      item
        Alignment = taRightJustify
        Color = clInfoBk
        EditButtons = <>
        FieldName = 'ID_Number'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Footers = <>
        Title.Caption = #8470' '#1079#1072#1082#1072#1079#1072
        Title.TitleButton = True
        Width = 50
      end
      item
        Color = clInfoBk
        EditButtons = <>
        FieldName = 'Comment'
        Footers = <>
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1079#1072#1082#1072#1079#1072
        Title.TitleButton = True
        Width = 135
      end
      item
        Color = clInfoBk
        EditButtons = <>
        FieldName = 'CustomerName'
        Footers = <>
        Title.Caption = #1047#1072#1082#1072#1079#1095#1080#1082
        Title.TitleButton = True
        Width = 135
      end
      item
        Color = clInfoBk
        EditButtons = <>
        FieldName = 'MatDesc'
        Footers = <>
        Title.Caption = #1052#1072#1090#1077#1088#1080#1072#1083
        Title.TitleButton = True
        Visible = False
        Width = 134
      end
      item
        Color = clInfoBk
        EditButtons = <>
        FieldName = 'Param1'
        Footers = <>
        Title.Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099'|'#1055#1072#1088#1072#1084'.1'
        Title.TitleButton = True
      end
      item
        Color = clInfoBk
        EditButtons = <>
        FieldName = 'Param2'
        Footers = <>
        Title.Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099'|'#1055#1072#1088#1072#1084'.2'
        Title.TitleButton = True
        Width = 58
      end
      item
        Color = clInfoBk
        EditButtons = <>
        FieldName = 'Param3'
        Footers = <>
        Title.Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099'|'#1055#1072#1088#1072#1084'.3'
        Title.TitleButton = True
        Width = 57
      end
      item
        Color = clInfoBk
        EditButtons = <>
        FieldName = 'MatAmount'
        Footer.ValueType = fvtSum
        Footers = <>
        Title.Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099'|'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
      end
      item
        Color = clInfoBk
        EditButtons = <>
        FieldName = 'MatCostNative'
        Footer.ValueType = fvtSum
        Footers = <>
        Title.Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099'|'#1057#1090#1086#1080#1084#1086#1089#1090#1100
      end
      item
        Color = clInfoBk
        EditButtons = <>
        FieldName = 'MatCost1'
        Footers = <>
        Title.Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099'|'#1079#1072' '#1077#1076'.'
        Width = 45
      end
      item
        Color = clInfoBk
        EditButtons = <>
        FieldName = 'MatUnitName'
        Footers = <>
        Title.Caption = #1077#1076'.'
        Width = 33
      end
      item
        AlwaysShowEditButton = True
        DropDownRows = 8
        DropDownSizing = True
        EditButtons = <>
        FieldName = 'FactParam1'
        Footers = <>
        PopupMenu = pmDic
        Title.Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099'|'#1055#1072#1088#1072#1084'.1'
        Title.TitleButton = True
        OnUpdateData = dgMatRequestsAllUpdateData
      end
      item
        AlwaysShowEditButton = True
        DropDownRows = 8
        DropDownSizing = True
        EditButtons = <>
        FieldName = 'FactParam2'
        Footers = <>
        PopupMenu = pmDic
        Title.Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099'|'#1055#1072#1088#1072#1084'.2'
        Title.TitleButton = True
        Width = 54
        OnUpdateData = dgMatRequestsAllUpdateData
      end
      item
        AlwaysShowEditButton = True
        DropDownRows = 8
        DropDownSizing = True
        EditButtons = <>
        FieldName = 'FactParam3'
        Footers = <>
        PopupMenu = pmDic
        Title.Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099'|'#1055#1072#1088#1072#1084'.3'
        Title.TitleButton = True
        Width = 56
        OnUpdateData = dgMatRequestsAllUpdateData
      end
      item
        EditButtons = <>
        FieldName = 'FactMatAmount'
        Footer.ValueType = fvtSum
        Footers = <>
        Title.Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099'|'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        OnUpdateData = dgMatRequestsAllUpdateData
      end
      item
        EditButtons = <>
        FieldName = 'FactMatCost'
        Footer.ValueType = fvtSum
        Footers = <>
        Title.Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099'|'#1057#1090#1086#1080#1084#1086#1089#1090#1100
        OnUpdateData = dgMatRequestsAllUpdateData
      end
      item
        EditButtons = <>
        FieldName = 'FactMatCost1'
        Footers = <>
        Title.Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099'|'#1079#1072' '#1077#1076'.'
        Width = 55
      end
      item
        EditButtons = <>
        FieldName = 'MarginCost'
        Footer.ValueType = fvtSum
        Footers = <>
        Title.Caption = #1052#1072#1088#1078#1072
      end
      item
        EditButtons = <>
        FieldName = 'PlanReceiveDate'
        Footers = <>
        Title.Caption = #1044#1072#1090#1072' '#1087#1086#1089#1090#1072#1074#1082#1080'|'#1055#1083#1072#1085#1086#1074#1072#1103
        Title.TitleButton = True
        Width = 72
        OnUpdateData = dgMatRequestsPlanReceiveDateUpdateData
      end
      item
        EditButtons = <>
        FieldName = 'FactReceiveDate'
        Footers = <>
        Title.Caption = #1044#1072#1090#1072' '#1087#1086#1089#1090#1072#1074#1082#1080'|'#1060#1072#1082#1090#1080#1095#1077#1089#1082#1072#1103
        Title.TitleButton = True
        Width = 80
        OnUpdateData = dgMatRequestsFactReceiveDateUpdateData
      end
      item
        DropDownSizing = True
        EditButtons = <>
        FieldName = 'SupplierName'
        Footers = <>
        Title.Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
        Title.TitleButton = True
        Width = 85
        OnUpdateData = dgMatRequestsAllUpdateData
      end
      item
        EditButtons = <>
        FieldName = 'InvoiceNum'
        Footers = <>
        Title.Caption = #8470' '#1089#1095#1077#1090#1072
        Title.TitleButton = True
        OnUpdateData = dgMatRequestsAllUpdateData
      end
      item
        EditButtons = <>
        FieldName = 'MatNote'
        Footers = <>
        Title.Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
        Title.TitleButton = True
        Width = 93
        OnUpdateData = dgMatRequestsAllUpdateData
      end
      item
        EditButtons = <>
        FieldName = 'PayDate'
        Footers = <>
        Title.Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
        OnUpdateData = dgMatRequestsColumns25UpdateData
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Panel7: TPanel
    Left = 0
    Top = 270
    Width = 451
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    Visible = False
    object Label5: TLabel
      Left = 8
      Top = 12
      Width = 66
      Height = 13
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1103':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Panel8: TPanel
      Left = 181
      Top = 0
      Width = 270
      Height = 34
      Align = alRight
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 0
      object sbLocateOrder: TSpeedButton
        Left = 8
        Top = 5
        Width = 114
        Height = 25
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1079#1072#1082#1072#1079
      end
      object btXLMaterials: TBitBtn
        Left = 128
        Top = 5
        Width = 133
        Height = 25
        Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' Excel'
        TabOrder = 0
        Glyph.Data = {
          76010000424D7601000000000000760000002800000010000000100000000100
          08000000000000010000120B0000120B00001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000A0802080208
          020802080208020802080802080208020802080208020802080202080F0F0F0F
          0F0F0F0F0F0F0F0F020808020F0F0F0F0F0F0F0802080208080202080F020802
          080208020F020802020808020F0802080208020F0208020F080202080F020802
          08020F020802080F020808020F0F0208020F02080208020F080202080F0F0F02
          0F020802080F0F0F020808020F0F020F0208020802080F0F080202080F020F02
          080208020802080F020808020F08020802080F080208020F080202080F020802
          080F0F0F0802080F020808020F0F0F0F0F0F0F0F0F0F0F0F0802020802080208
          020802080208020802080A02080208020802080208020802080A}
        Spacing = 8
      end
    end
    object btEditMaterial: TBitBtn
      Left = 4
      Top = 5
      Width = 97
      Height = 25
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
      TabOrder = 1
      NumGlyphs = 2
    end
  end
  object dsParam1: TDataSource
    Left = 102
    Top = 444
  end
  object dsParam2: TDataSource
    Left = 138
    Top = 444
  end
  object dsParam3: TDataSource
    Left = 172
    Top = 442
  end
  object pmDic: TPopupMenu
    OnPopup = pmDicPopup
    Left = 230
    Top = 482
  end
end
