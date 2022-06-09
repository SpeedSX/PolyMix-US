inherited InvoicesFrame: TInvoicesFrame
  Width = 650
  Height = 408
  inherited paFilter: TPanel
    Left = 480
    Height = 408
    ExplicitLeft = 281
    ExplicitHeight = 304
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 480
    Height = 408
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 1
    ExplicitWidth = 281
    ExplicitHeight = 304
    object spJobDay: TJvNetscapeSplitter
      Left = 0
      Top = 304
      Width = 480
      Height = 10
      Cursor = crVSplit
      Align = alBottom
      Visible = False
      Maximized = False
      Minimized = False
      ButtonCursor = crDefault
      WindowsButtons = [wbMin, wbMax]
      ExplicitTop = 323
      ExplicitWidth = 610
    end
    object paInvoiceItems: TPanel
      Left = 0
      Top = 314
      Width = 480
      Height = 94
      Align = alBottom
      BevelOuter = bvNone
      Caption = ' '
      Constraints.MinHeight = 82
      TabOrder = 0
      Visible = False
      ExplicitTop = 210
      ExplicitWidth = 281
      object dgInvoiceItems: TMyDBGridEh
        Left = 101
        Top = 0
        Width = 379
        Height = 94
        Align = alClient
        AllowedOperations = [alopInsertEh, alopAppendEh]
        AllowedSelections = [gstNon]
        DataGrouping.GroupLevels = <>
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
        ParentFont = False
        ReadOnly = True
        RowDetailPanel.Color = clBtnFace
        RowHeight = 16
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDblClick = btEditItemClick
        Columns = <
          item
            EditButtons = <>
            FieldName = 'ItemText'
            Footers = <>
            Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            Width = 187
          end
          item
            EditButtons = <>
            FieldName = 'OrderNum'
            Footers = <>
            Title.Caption = #8470' '#1079#1072#1082#1072#1079#1072
          end
          item
            EditButtons = <>
            FieldName = 'Quantity'
            Footers = <>
            Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            Width = 63
          end
          item
            EditButtons = <>
            FieldName = 'Price'
            Footers = <>
            Title.Caption = #1047#1072' '#1077#1076'., '#1075#1088#1085
            Width = 65
          end
          item
            EditButtons = <>
            FieldName = 'ItemCost'
            Footers = <>
            Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100', '#1075#1088#1085
            Width = 90
          end
          item
            EditButtons = <>
            FieldName = 'PayCost'
            Footers = <>
            Title.Caption = #1054#1087#1083#1072#1095#1077#1085#1086', '#1075#1088#1085
            Width = 80
          end
          item
            EditButtons = <>
            FieldName = 'ItemDebt'
            Footers = <>
            Title.Caption = #1044#1086#1083#1075', '#1075#1088#1085
            Visible = False
            OnGetCellParams = dgInvoiceItemsColumns6GetCellParams
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel9: TPanel
        Left = 0
        Top = 0
        Width = 101
        Height = 94
        Align = alLeft
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 1
        object btNewItem: TBitBtn
          Left = 6
          Top = 2
          Width = 88
          Height = 25
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 0
          OnClick = btNewItemClick
          Glyph.Data = {
            5A010000424D5A01000000000000CA000000280000000C0000000C0000000100
            08000000000090000000430B0000430B0000250000002500000000000000FFFF
            FF00E8E7E8005E373100D6CAC6001C080000A2502D00F1793D00DE9570003833
            3000B387640075695F00E4D9D000685A4D00CEC3B900C6BEB70055504B00E1E0
            DF009C908300AEA29500DAD2C900EBE3DA00A79A8B00B4A79800C6BBAE00988D
            7F00BCB1A300EBE9E500BABAB80000330F0016B36A00CCF4FD009CD4E400216A
            9A005EA3DB00EBEBEB00C0C0C000242424170A06060A17242424242408060606
            06060616242424080606060101060606161C18060606060101060606061A0806
            0606060101060606060806060101010101010101060607070101010101010101
            07070807070707010107070707081A070707070101070707070E240807070701
            01070707081C242408070707070707082424242424180807070818242424}
          Margin = 7
          Spacing = 6
        end
        object btDelItem: TBitBtn
          Left = 6
          Top = 64
          Width = 88
          Height = 25
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 2
          OnClick = btDelItemClick
          Glyph.Data = {
            1E010000424D1E01000000000000B2000000280000000A000000090000000100
            0800000000006C000000430B0000430B00001F0000001F00000000000000FFFF
            FF00E8E7E800D6CAC6001C08000075695F00E4D9D000685A4D00CEC3B900C6BE
            B70055504B009C908300AEA29500DAD2C900EBE3DA00A79A8B00988D7F00EBE9
            E50000330F0016B36A00CCF4FD009CD4E400216A9A005EA3DB00C9D5E7001415
            E3005F5FF4009091D700FAFAFA00EBEBEB00C0C0C0001B19191919191919191B
            000019191B191919191B19190000191B1C181919181C1A19000019191B1C1818
            1C1A191900001919191A1C1C1B191919000019191A021C1C021919190000191B
            021C1A1A1C021A190000191A021A19191A021A1900001B19191919191919191B
            0000}
          Margin = 7
          Spacing = 6
        end
        object btEditItem: TBitBtn
          Left = 6
          Top = 33
          Width = 88
          Height = 25
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          TabOrder = 1
          OnClick = btEditItemClick
          Glyph.Data = {
            E6010000424DE601000000000000E60000002800000010000000100000000100
            08000000000000010000210B0000210B00002C0000002C00000000000000FFFF
            FF0007035A007B645A003E3935002D2C2A00FEFEFC00F2F2F000EDEDEB00FBFB
            FA00F8F8F700F7F7F600E7E7E600E2E2E10006A11C00108E230006731C00118F
            2A0018AB440058CA840000808000374546003A5C600097E7FB008286870015C4
            FB000C84B10001A5E6000B3B5400165E8200909293001F92F20080A6CB003187
            E7002A407B006E88D8002D44B4006F7FD500111B8300D7D7D700D1D1D100C5C5
            C500BABABA001919190014141414141414141414141414141414141818181818
            181818181818181814141E0606060606090B07080C0D272918141E0606060606
            06090B07080C0D2718141E0606062B042806090B07080C0D18141E06282A0405
            152806090B07080C18141E06060606161A1C2206090B070818141E06282A2A16
            1D031A222A2A2A0718141E060606060620191B1A2206060A18141E0606060606
            2017191B1A22060618141E1010101010102017191B1A221018140E130E0E0E0E
            0E0E2017191B1A221414140E131212111414142017191F26021414140E0E0F14
            1414141420212424260214141414141414141414142423252414141414141414
            14141414141424241414}
          Margin = 7
          Spacing = 6
        end
      end
    end
    object paInvoices: TPanel
      Left = 0
      Top = 0
      Width = 480
      Height = 304
      Align = alClient
      BevelOuter = bvNone
      Caption = ' '
      Constraints.MinHeight = 30
      TabOrder = 1
      ExplicitWidth = 281
      ExplicitHeight = 200
      object dgInvoices: TMyDBGridEh
        Left = 0
        Top = 0
        Width = 480
        Height = 304
        Align = alClient
        AllowedOperations = []
        AllowedSelections = [gstAll, gstNon]
        ColumnDefValues.Title.TitleButton = True
        DataGrouping.GroupLevels = <>
        Flat = True
        FooterColor = clInfoBk
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        FooterRowCount = 1
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
        ReadOnly = True
        RowDetailPanel.Color = clBtnFace
        RowHeight = 16
        SumList.Active = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        UseMultiTitle = True
        VTitleMargin = 3
        OnDblClick = dgInvoicesDblClick
        OnDrawColumnCell = dgInvoicesDrawColumnCell
        OnTitleBtnClick = dgInvoicesTitleBtnClick
        Columns = <
          item
            EditButtons = <>
            FieldName = 'SyncState'
            Footers = <>
            Title.Caption = ' '
            Width = 17
            OnGetCellParams = dgInvoicesColumns0GetCellParams
          end
          item
            EditButtons = <>
            FieldName = 'PayState'
            Footers = <>
            Title.Caption = ' '
            Title.TitleButton = False
            Width = 17
            OnGetCellParams = dgInvoicesColumns0GetCellParams
          end
          item
            EditButtons = <>
            FieldName = 'PayTypeName'
            Footers = <>
            Title.Caption = #1042#1080#1076
          end
          item
            EditButtons = <>
            FieldName = 'InvoiceNum'
            Footers = <>
            Title.Caption = #8470' '#1089#1095#1077#1090#1072
          end
          item
            EditButtons = <>
            FieldName = 'InvoiceDate'
            Footers = <>
            Title.Caption = #1044#1072#1090#1072
            Width = 60
          end
          item
            EditButtons = <>
            FieldName = 'InvoiceCost'
            Footer.Alignment = taRightJustify
            Footer.FieldName = 'InvoiceCost'
            Footer.ValueType = fvtSum
            Footers = <>
            Title.Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085
            Title.TitleButton = False
          end
          item
            EditButtons = <>
            FieldName = 'InvoiceTotalPaid'
            Footer.Alignment = taRightJustify
            Footer.FieldName = 'InvoiceTotalPaid'
            Footer.ValueType = fvtSum
            Footers = <>
            Title.Caption = #1054#1087#1083#1072#1095#1077#1085#1086', '#1075#1088#1085
            Title.TitleButton = False
          end
          item
            EditButtons = <>
            FieldName = 'InvoiceDebt'
            Footer.Alignment = taRightJustify
            Footer.FieldName = 'InvoiceDebt'
            Footer.ValueType = fvtSum
            Footers = <>
            Title.Caption = #1044#1086#1083#1075', '#1075#1088#1085
            Title.TitleButton = False
            OnGetCellParams = dgInvoicesColumns4GetCellParams
          end
          item
            EditButtons = <>
            FieldName = 'InvoiceCredit'
            Footer.Alignment = taRightJustify
            Footer.FieldName = 'InvoiceCredit'
            Footer.ValueType = fvtSum
            Footers = <>
            Title.Caption = #1055#1077#1088#1077#1087#1083#1072#1090#1072', '#1075#1088#1085
            Title.TitleButton = False
          end
          item
            EditButtons = <>
            FieldName = 'CustomerName'
            Footers = <>
            Title.Caption = #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082
            Width = 129
          end
          item
            EditButtons = <>
            FieldName = 'OrderNumber'
            Footers = <>
            Title.Caption = #8470' '#1079#1072#1082#1072#1079#1072
            Title.TitleButton = False
          end
          item
            EditButtons = <>
            FieldName = 'ItemText'
            Footers = <>
            Title.Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072' '#1087#1088#1086#1076#1091#1082#1094#1080#1080
            Title.TitleButton = False
            Width = 165
          end
          item
            EditButtons = <>
            FieldName = 'Notes'
            Footers = <>
            Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103
          end
          item
            EditButtons = <>
            FieldName = 'UserName'
            Footers = <>
            Title.Caption = #1057#1086#1079#1076#1072#1090#1077#1083#1100
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
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
