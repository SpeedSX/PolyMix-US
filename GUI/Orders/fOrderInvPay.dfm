object OrderInvPayFrame: TOrderInvPayFrame
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentColor = False
  ParentFont = False
  TabOrder = 0
  OnResize = FrameResize
  object spJobDay: TJvNetscapeSplitter
    Left = 0
    Top = 62
    Width = 451
    Height = 10
    Cursor = crVSplit
    Align = alBottom
    AutoSnap = False
    Maximized = False
    Minimized = False
    ButtonCursor = crDefault
    WindowsButtons = []
    ExplicitTop = 323
    ExplicitWidth = 610
  end
  object paPayments: TPanel
    Left = 0
    Top = 72
    Width = 451
    Height = 232
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    Constraints.MinHeight = 82
    ParentColor = True
    TabOrder = 0
    object dgOrderPayments: TMyDBGridEh
      Left = 0
      Top = 24
      Width = 451
      Height = 166
      Align = alClient
      AllowedOperations = [alopAppendEh]
      AllowedSelections = [gstNon]
      AutoFitColWidths = True
      ColumnDefValues.Layout = tlCenter
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
      OptionsEh = [dghFixed3D, dghResizeWholeRightPart, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
      ParentFont = False
      ReadOnly = True
      RowDetailPanel.Color = clBtnFace
      RowHeight = 17
      RowSizingAllowed = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      UseMultiTitle = True
      VTitleMargin = 4
      OnDblClick = btEditItemClick
      Columns = <
        item
          EditButtons = <>
          FieldName = 'PayTypeName'
          Footers = <>
          Title.Caption = #1042#1080#1076' '#1086#1087#1083#1072#1090#1099
          Width = 84
        end
        item
          EditButtons = <>
          FieldName = 'InvoiceNum'
          Footers = <>
          Title.Caption = #8470' '#1089#1095#1077#1090#1072
          Width = 62
        end
        item
          EditButtons = <>
          FieldName = 'PayDate'
          Footers = <>
          Title.Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
          Width = 73
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
          FieldName = 'ContragentName'
          Footers = <>
          Title.Caption = #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082
          Width = 156
        end
        item
          EditButtons = <>
          EndEllipsis = True
          FieldName = 'ItemText'
          Footers = <>
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Width = 131
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object paEditPayments: TPanel
      Left = 0
      Top = 190
      Width = 451
      Height = 42
      Align = alBottom
      BevelOuter = bvNone
      Caption = ' '
      ParentColor = True
      TabOrder = 1
      object btDelItem: TBitBtn
        Left = 22
        Top = 6
        Width = 88
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 1
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
        Left = 168
        Top = 6
        Width = 88
        Height = 25
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        TabOrder = 0
        Visible = False
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
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 451
      Height = 24
      Align = alTop
      BevelOuter = bvNone
      Caption = ' '
      ParentColor = True
      TabOrder = 2
      object Label2: TLabel
        Left = 8
        Top = 5
        Width = 46
        Height = 13
        Caption = #1054#1087#1083#1072#1090#1099
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
    end
  end
  object paInvoices: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 62
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    Constraints.MinHeight = 30
    TabOrder = 1
    object dgOrderInvoiceItems: TMyDBGridEh
      Left = 0
      Top = 24
      Width = 451
      Height = 6
      Align = alClient
      AllowedOperations = []
      AutoFitColWidths = True
      ColumnDefValues.Layout = tlCenter
      DataGrouping.GroupLevels = <>
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'Tahoma'
      FooterFont.Style = []
      Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghResizeWholeRightPart, dghHighlightFocus, dghClearSelection, dghIncSearch, dghPreferIncSearch, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
      PopupMenu = pmInvoices
      ReadOnly = True
      RowDetailPanel.Color = clBtnFace
      RowHeight = 17
      RowSizingAllowed = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      UseMultiTitle = True
      VTitleMargin = 4
      OnDrawColumnCell = dgOrderInvoiceItemsDrawColumnCell
      Columns = <
        item
          EditButtons = <>
          FieldName = 'SyncState'
          Footers = <>
          Title.Caption = ' '
          Width = 18
        end
        item
          EditButtons = <>
          FieldName = 'PayTypeName'
          Footers = <>
          Title.Caption = #1042#1080#1076' '#1086#1087#1083#1072#1090#1099
          Width = 66
        end
        item
          EditButtons = <>
          FieldName = 'InvoiceNum'
          Footers = <>
          Title.Caption = #8470' '#1089#1095#1077#1090#1072
          OnGetCellParams = dgOrderInvoiceItemsColumnsInvoiceNumGetCellParams
        end
        item
          EditButtons = <>
          FieldName = 'InvoiceDate'
          Footers = <>
          Title.Caption = #1044#1072#1090#1072
          Width = 69
        end
        item
          EditButtons = <>
          FieldName = 'ItemCost'
          Footers = <>
          Title.Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085
        end
        item
          EditButtons = <>
          FieldName = 'InvoicePayCost'
          Footers = <>
          Title.Caption = #1054#1087#1083#1072#1095#1077#1085#1086' '#1087#1086' '#1089#1095#1077#1090#1091', '#1075#1088#1085
          Width = 77
        end
        item
          EditButtons = <>
          FieldName = 'ItemDebt'
          Footers = <>
          Title.Caption = #1044#1086#1083#1075', '#1075#1088#1085
          Visible = False
          OnGetCellParams = dgInvoicesColumns4GetCellParams
        end
        item
          EditButtons = <>
          FieldName = 'ItemCredit'
          Footers = <>
          Title.Caption = #1055#1077#1088#1077#1087#1083#1072#1090#1072', '#1075#1088#1085
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'ItemText'
          Footers = <>
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Width = 110
        end
        item
          EditButtons = <>
          FieldName = 'ContragentName'
          Footers = <>
          Title.Caption = #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082
          Width = 166
        end
        item
          EditButtons = <>
          FieldName = 'Quantity'
          Footers = <>
          Title.Caption = #1050#1086#1083'-'#1074#1086
        end
        item
          EditButtons = <>
          FieldName = 'PayCost'
          Footers = <>
          Title.Caption = #1054#1087#1083#1072#1095#1077#1085#1086' '#1087#1086' '#1079#1072#1082#1072#1079#1091', '#1075#1088#1085
          Width = 79
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object paHdrOrder: TPanel
      Left = 0
      Top = 30
      Width = 451
      Height = 32
      Align = alBottom
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 1
      object btMakeInvoice: TBitBtn
        Left = 2
        Top = 5
        Width = 83
        Height = 25
        Caption = #1053#1086#1074#1099#1081
        TabOrder = 0
        OnClick = miOrderMakeInvoiceClick
        Glyph.Data = {
          2E020000424D2E020000000000002E0100002800000010000000100000000100
          08000000000000010000120B0000120B00003E0000003E00000000000000FFFF
          FF00FF00FF0090907A009F9F870085857100A3A38E00B4B49E00B2B29E00C6C6
          B100BCBCA800B7B7A300CACAB600C1C1AE00D4D4C000CECEBA00D6D6C200D0D0
          BD00F1F1DD00E5E5D300F8F8E500ECECDA00E0E0D000A3A39700F2F2E100E7E7
          D700A2A29700F3F3E300EBEBDD00F5F5E800F7F7EC00EEEEE300F3F3EB00F9F9
          F200FBFBF500F7F7F100FAFAF500FDFDF900FDFDFA00FEFEFD0054A93C004E9C
          38004FB13F0014990000119100001FAC0B001EA80B0048E733005AEB450057C1
          480051AC450017DC020018910A001A990B0016870A0018910B0030E21C004992
          42000E6D080001D90000E0E0E000FFFFFF000202020202020202020202020202
          0202020202020202020202020202020202021703031A3C1A030303031A3C1A03
          0317061412040507121212120705041214060818131518151313131315181513
          18080B1B1919191919191919191919191B0B0A1D1C1C1C1C1C1C1C1C1C1C1C1C
          1D0A0D1E1F1F1F1F1F1F1F1F1F1F1F1F1E0D0921202020202020202020202020
          21090C22232323232323232323393A39220C0F25242424242424242424363B36
          250F112726262626262626323434333437290E01010101010101013538383838
          382C161010101010101010282B2B2F2B2B2A02020202020202020202022E302E
          02020202020202020202020202312D310202}
        Spacing = 8
      end
      object btLocateInvoice: TBitBtn
        Left = 90
        Top = 5
        Width = 93
        Height = 25
        Caption = #1054#1090#1082#1088#1099#1090#1100
        TabOrder = 1
        OnClick = dgOrderEditInvoiceClick
        Glyph.Data = {
          6A020000424D6A020000000000006A0100002800000010000000100000000100
          08000000000000010000120B0000120B00004D0000004D00000000000000FFFF
          FF00FF00FF006969500076765B0089896C008E8E7400A2A28800A1A18800A7A7
          8E00ACAC9300B8B89F00BEBEA500B2B29B00C3C3AA00CDCDB400CACAB100C6C6
          AE00717163008E8E7F00DFDFC800EDEDD600E7E7D100F6F6DF008C8C7F00EFEF
          DA00E2E2CE00D9D9C600F0F0DD00E6E6D600F3F3E300F5F5E700EAEADD00F0F0
          E600F8F8EF00FBFBF300F5F5ED00F9F9F300FCFCF800FCFCF900FEFEFC0089B8
          A80096B2B20093C1C40090BEC000A1D9DD0098C6CA00C0DADC00A2DCE2009EC6
          CB000093AC000092AB000092AA000090A70039DAF300A4DDE60000708800006F
          8600006D830000708900004B60003C8CA200C7EFFF000000DD000000A8004444
          FF002B2B4B00A1A1EA008080B1006F6F9600BABADF00F3F3F300DCDCDC00D9D9
          D900C3C3C30060606000FFFFFF00020202020202020202020202020202020202
          0202020202020202020202020202130404184918040404041849180404130617
          150503071515151507030515170608191416191614141414161916141908091C
          1A1A1A1A1A1A1A1A1A1A1A1A1C090A1E1D1D1D1D1D1D1D1D1D1D1D1D1E0A0D1F
          2020202020003C2A202020201F0D0B2221212121213D3E3A2C212121220B0C23
          24242424242F3536392B2424230C0E262525252525252D3436382E25260E1128
          272727272727273033363B312811100101010101010101013732364B4A101B0F
          0F0F0F0F0F0F0F0F0F2912474244020202020202020202020202484541400202
          0202020202020202020202463F43}
        Spacing = 8
      end
      object btPayInvoice: TBitBtn
        Left = 188
        Top = 5
        Width = 97
        Height = 25
        Caption = #1054#1087#1083#1072#1090#1080#1090#1100
        TabOrder = 2
        OnClick = btPayInvoiceClick
        Glyph.Data = {
          A6020000424DA602000000000000A60100002800000010000000100000000100
          08000000000000010000120B0000120B00005C0000005C00000000000000FFFF
          FF00FF00FF00AFAF9B00A2A2900099998800B2B2A100C3C3B200BFBFAE00CFCF
          BE00C7C7B600D6D6C500D5D5C400D3D3C200D0D0BF00CBCBBB00DDDDCC00DBDB
          CA00D8D8C800F9F9E900F3F3E300EFEFE000E9E9DA00F4F4E600EBEBDE00E5E5
          D800B2B2A800F5F5E800B1B1A800F7F7EC00EEEEE300F8F8EF00F1F1E800F5F5
          EE00FAFAF400FCFCF700F8F8F300FBFBF700FDFDFA00FDFDFB00FEFEFD00B8B9
          9700748045008C9765006F9C6C003E7E4600287E38001F7C3C00037127001178
          3300127733002E874B004F98670003742A00068132001C7A3C003F8457004C8A
          6100047E3000067E320009883A0009893D000A8D4100099B49000A9A48000CA3
          50000C9448000BAE58000BA854000CA352000C9C4F000DB45E000CA657000FAE
          5D000FA85A0010BC680013C46E0013BF6B0014C16F0016D6820019DC8B001CDE
          8F001BED9A001EF5A30020FEAC001FF0A10028FFB30031FFB7003EFFC50048FF
          C900E5E5E500FFFFFF0002020202020202020230303002020202020202020202
          0230303A413630380202020202020202304044434343403B39021A04041C5A2E
          3D4B4B4848474B4B3D3706131403052935453B2930404C4C4930081716151715
          511616163F4C4F4F4532071B181818181818303F4E504C4030070A1D1E1E1E1E
          30484E524D3E2F1E1D0A0F1F2020202B3C51533C302020201F0F09222121212A
          425656554A304A5122090D23242424243055575757575757330E0B2625252525
          253046555854514A310D12282727272727272C3059463134270C110101010101
          0101012C302D0101010B19101010101010101010101010101010020202020202
          02020202020202020202}
        Spacing = 8
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 451
      Height = 24
      Align = alTop
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 2
      object Label3: TLabel
        Left = 8
        Top = 5
        Width = 126
        Height = 13
        Caption = #1042#1099#1089#1090#1072#1074#1083#1077#1085#1085#1099#1077' '#1089#1095#1077#1090#1072
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
    end
  end
  object pmInvoices: TPopupMenu
    Left = 488
    Top = 80
    object miOrderMakeInvoice: TMenuItem
      Caption = #1042#1099#1089#1090#1072#1074#1080#1090#1100' '#1085#1086#1074#1099#1081' '#1089#1095#1077#1090'...'
      OnClick = miOrderMakeInvoiceClick
    end
    object miOrderEditInvoice: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1089#1095#1077#1090'...'
      OnClick = dgOrderEditInvoiceClick
    end
    object miOrderPayInvoice: TMenuItem
      Caption = #1054#1087#1083#1072#1090#1080#1090#1100' '#1089#1095#1077#1090'...'
    end
    object miFind1C: TMenuItem
      Caption = #1053#1072#1081#1090#1080' '#1089#1095#1077#1090' '#1074' 1C'
      Enabled = False
    end
  end
end
