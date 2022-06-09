inherited CustomerPaymentsFrame: TCustomerPaymentsFrame
  Width = 909
  Height = 426
  inherited paFilter: TPanel
    Left = 739
    Top = 41
    Height = 385
    TabOrder = 1
    ExplicitLeft = 281
    ExplicitTop = 41
    ExplicitHeight = 263
  end
  object paCustomerFilter: TPanel
    Left = 0
    Top = 0
    Width = 909
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    ExplicitWidth = 451
    DesignSize = (
      909
      41)
    object comboCustomer: TDBLookupComboboxEh
      Left = 80
      Top = 10
      Width = 458
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      DropDownBox.AutoFitColWidths = False
      DropDownBox.Columns = <
        item
          FieldName = 'Name'
          Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077'/'#1048#1084#1103
          Width = 303
        end
        item
          FieldName = 'InvoiceTotal'
          Title.Caption = #1042#1099#1089#1090#1072#1074#1083#1077#1085#1086' '#1089#1095#1077#1090#1086#1074
        end
        item
          FieldName = 'ToPayGrn'
          Title.Caption = #1041#1072#1083#1072#1085#1089
        end
        item
          Alignment = taCenter
          FieldName = 'CreationDate'
          Title.Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
          Width = 92
        end
        item
          FieldName = 'CreatorName'
          Title.Caption = #1052#1077#1085#1077#1076#1078#1077#1088
          Width = 94
        end>
      DropDownBox.Options = [dlgColumnResizeEh, dlgColLinesEh]
      DropDownBox.AutoDrop = True
      DropDownBox.Rows = 20
      DropDownBox.ShowTitles = True
      DropDownBox.Sizable = True
      EditButtons = <>
      KeyField = 'N'
      ListField = 'Name'
      TabOrder = 0
      Visible = True
      OnCloseUp = comboCustomerCloseUp
      OnKeyValueChanged = comboCustomerKeyValueChanged
      ExplicitWidth = 0
    end
    object paInvoiceTotal: TPanel
      Left = 557
      Top = 0
      Width = 234
      Height = 41
      Align = alRight
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      ExplicitLeft = 99
      object Label3: TLabel
        Left = 12
        Top = 4
        Width = 118
        Height = 13
        Caption = #1042#1099#1089#1090#1072#1074#1083#1077#1085#1086' '#1089#1095#1077#1090#1086#1074' '#1085#1072':'
      end
      object dtInvoiceTotal: TDBText
        Left = 132
        Top = 4
        Width = 98
        Height = 17
        Alignment = taRightJustify
        DataField = 'InvoiceTotal'
      end
      object dtToPayGrn: TDBText
        Left = 132
        Top = 22
        Width = 98
        Height = 17
        Alignment = taRightJustify
        DataField = 'ToPayGrn'
      end
      object Label4: TLabel
        Left = 43
        Top = 22
        Width = 87
        Height = 13
        Alignment = taRightJustify
        Caption = #1044#1086#1083#1075' '#1087#1086' '#1079#1072#1082#1072#1079#1072#1084':'
      end
    end
    object paRestIncomeText: TPanel
      Left = 791
      Top = 0
      Width = 118
      Height = 41
      Align = alRight
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      ExplicitLeft = 333
      DesignSize = (
        118
        41)
      object Label5: TLabel
        Left = 50
        Top = 4
        Width = 59
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight, akBottom]
        Caption = #1055#1077#1088#1077#1087#1083#1072#1090#1072':'
        ExplicitLeft = 68
      end
      object Bevel1: TBevel
        Left = 3
        Top = 3
        Width = 2
        Height = 35
        Align = alLeft
        ExplicitLeft = 5
      end
      object dtRestIncome: TDBText
        Left = 14
        Top = 22
        Width = 95
        Height = 17
        Alignment = taRightJustify
        DataField = 'Sum_RestIncome'
      end
    end
    object cbCustomer: TCheckBox
      Left = 6
      Top = 12
      Width = 73
      Height = 17
      Caption = #1047#1072#1082#1072#1079#1095#1080#1082':'
      TabOrder = 3
      OnClick = cbCustomerClick
    end
  end
  object MyDBGridEh1: TMyDBGridEh
    Left = 0
    Top = 41
    Width = 739
    Height = 385
    Align = alClient
    DataGrouping.GroupLevels = <>
    Flat = False
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    RowDetailPanel.Color = clBtnFace
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 41
    Width = 739
    Height = 385
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 3
    ExplicitWidth = 281
    ExplicitHeight = 263
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 739
      Height = 385
      Align = alClient
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 0
      ExplicitWidth = 281
      ExplicitHeight = 263
      object spOrders: TJvNetscapeSplitter
        Left = 525
        Top = 0
        Height = 385
        Align = alLeft
        AutoSnap = False
        ResizeStyle = rsUpdate
        Maximized = False
        Minimized = False
        ButtonCursor = crDefault
        WindowsButtons = []
        ButtonWidthKind = btwPercentage
        ButtonWidth = 30
        ExplicitLeft = 429
        ExplicitTop = -4
        ExplicitHeight = 486
      end
      object paOrders: TPanel
        Left = 0
        Top = 0
        Width = 525
        Height = 385
        Align = alLeft
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 0
        ExplicitHeight = 263
        object splitterInvoiceItems: TJvNetscapeSplitter
          Left = 0
          Top = 297
          Width = 525
          Height = 10
          Cursor = crVSplit
          Align = alBottom
          AutoSnap = False
          ResizeStyle = rsUpdate
          Maximized = False
          Minimized = False
          ButtonCursor = crDefault
          WindowsButtons = []
          ButtonWidthKind = btwPercentage
          ButtonWidth = 30
          ExplicitTop = 31
          ExplicitWidth = 485
        end
        object dgOrders: TMyDBGridEh
          Left = 0
          Top = 31
          Width = 525
          Height = 266
          Align = alClient
          AllowedOperations = []
          AllowedSelections = [gstAll, gstNon]
          DataGrouping.GroupLevels = <>
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          FooterColor = clInfoBk
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'Tahoma'
          FooterFont.Style = []
          FooterRowCount = 1
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghPreferIncSearch, dghRowHighlight, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
          ParentFont = False
          ReadOnly = True
          RowDetailPanel.Color = clBtnFace
          RowHeight = 16
          RowSizingAllowed = True
          SumList.Active = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          UseMultiTitle = True
          VTitleMargin = 4
          OnDblClick = dgOrdersDblClick
          Columns = <
            item
              DisplayFormat = '00000'
              EditButtons = <>
              FieldName = 'ID_Number'
              Footers = <>
              Title.Caption = #8470
              Width = 48
            end
            item
              EditButtons = <>
              FieldName = 'CreationDate'
              Footers = <>
              Title.Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
              Width = 58
            end
            item
              EditButtons = <>
              FieldName = 'Comment'
              Footers = <>
              Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Width = 163
            end
            item
              EditButtons = <>
              FieldName = 'CustomerName'
              Footers = <>
              Title.Caption = #1047#1072#1082#1072#1079#1095#1080#1082
              Width = 117
            end
            item
              EditButtons = <>
              FieldName = 'ClientTotalGrn'
              Footer.Alignment = taRightJustify
              Footer.ValueType = fvtSum
              Footers = <>
              Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1095#1080#1082#1072
              Width = 83
            end
            item
              EditButtons = <>
              FieldName = 'TotalPaidGrn'
              Footer.Alignment = taRightJustify
              Footer.ValueType = fvtSum
              Footers = <>
              Title.Caption = #1054#1087#1083#1072#1095#1077#1085#1086' '#1087#1086' '#1079#1072#1082#1072#1079#1091
              Width = 74
            end
            item
              EditButtons = <>
              FieldName = 'ToPayGrn'
              Footer.Alignment = taRightJustify
              Footer.ValueType = fvtSum
              Footers = <>
              Title.Caption = #1044#1086#1083#1075' '#1087#1086' '#1079#1072#1082#1072#1079#1091
              Width = 66
              OnGetCellParams = dgOrdersColumnsOrdersToPayGetCellParams
            end
            item
              Alignment = taCenter
              EditButtons = <>
              FieldName = 'InvoiceNum'
              Footers = <>
              Title.Caption = #8470' '#1089#1095#1077#1090#1072
            end
            item
              EditButtons = <>
              FieldName = 'InvoiceTotal'
              Footer.Alignment = taRightJustify
              Footer.ValueType = fvtSum
              Footers = <>
              Title.Caption = #1057#1091#1084#1084#1072' '#1089#1095#1077#1090#1086#1074
            end
            item
              EditButtons = <>
              FieldName = 'InvoiceTotalPaid'
              Footer.Alignment = taRightJustify
              Footer.ValueType = fvtSum
              Footers = <>
              Title.Caption = #1054#1087#1083#1072#1095#1077#1085#1086' '#1087#1086' '#1089#1095#1077#1090#1072#1084
            end
            item
              EditButtons = <>
              FieldName = 'OtherOrdersPaid'
              Footer.Alignment = taRightJustify
              Footer.ValueType = fvtSum
              Footers = <>
              Title.Caption = #1054#1090#1085#1077#1089#1077#1085#1086' '#1085#1072' '#1076#1088#1091#1075#1080#1077' '#1079#1072#1082#1072#1079#1099
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
        object paHdrOrder: TPanel
          Left = 0
          Top = 0
          Width = 525
          Height = 31
          Align = alTop
          BevelOuter = bvNone
          Caption = ' '
          Color = clGray
          ParentBackground = False
          TabOrder = 1
          object Label1: TLabel
            Left = 8
            Top = 10
            Width = 47
            Height = 13
            Caption = #1047#1072#1082#1072#1079#1099':'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label6: TLabel
            Left = 423
            Top = 10
            Width = 31
            Height = 13
            Caption = #1057#1095#1077#1090':'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object btPayAll: TBitBtn
            Left = 66
            Top = 4
            Width = 89
            Height = 25
            Caption = #1054#1087#1083#1072#1090#1080#1090#1100
            TabOrder = 0
            OnClick = btPayAllClick
            Glyph.Data = {
              42020000424D4202000000000000420000002800000010000000100000000100
              10000300000000020000110B0000110B00000000000000000000007C0000E003
              00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7CAA7B656E05662A6F1F7C1F7C1F7C1F7C8C39B145
              8C391F7C1F7C1F7C1F7CAA7B897EEF7F20730056A46E006FE06EAA5E3A63BD77
              B5568C391F7C1F7C0677A359C05560620056A051EF7F0563294A2A46D85AB852
              754E754EFF7F1F7C005A005A205E205E205EE05500561D5F9D73764EE6412073
              C06AC06A1F7C1F7CA66140626166626A61664062E0596B5E7056D1510E76CF7F
              877E1F7C1F7C1F7CA665826AC86EEA72C972846A005AE055A04DA04D1F7C1F7C
              1F7C1F7C1F7C1F7C6366C66E0E77527F307BC9726166005AC051A04D1F7C1F7C
              1F7C1F7C1F7C1F7C277BA66E307B757F527FEA7262662062A15160661F7C1F7C
              1F7C1F7C1F7C1F7C1F7C047BEA72307B0E77C76E6066A15540661F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C257B856EA56A4066A45960661F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C717F697F8B7F5B7D1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C2C72005AA04D65621F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C4972626A005AC0518049E1551F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C40622162A04DC359E05580491F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C}
          end
          object btPayPart: TBitBtn
            Left = 160
            Top = 4
            Width = 135
            Height = 25
            Caption = #1054#1087#1083#1072#1090#1080#1090#1100' '#1095#1072#1089#1090#1080#1095#1085#1086
            TabOrder = 1
            OnClick = btPayPartClick
            Glyph.Data = {
              42020000424D4202000000000000420000002800000010000000100000000100
              10000300000000020000110B0000110B00000000000000000000007C0000E003
              00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7CAA7B656E05662A6F1F7C1F7C1F7C1F7C8C39B145
              8C391F7C1F7C1F7C1F7CAA7B897EEF7F20730056A46E006FE06EAA5E3A63BD77
              B5568C391F7C1F7C0677A359C05560620056A051EF7F0563294A2A46D85AB852
              754E754EFF7F1F7C005A005A205E205E205EE05500561D5F9D73764EE6412073
              C06AC06A1F7C1F7CA66140626166626A61664062E0596B5E7056D1510E76CF7F
              877E1F7C1F7C1F7CA665826AC86EEA72C972846A005AE055A04DA04D1F7C1F7C
              1F7C1F7C1F7C1F7C6366C66E0E77527F307BC9726166005AC051A04D1F7C1F7C
              1F7C1F7C1F7C1F7C277BA66E307B757F527FEA7262662062A15160661F7C1F7C
              1F7C1F7C1F7C1F7C1F7C047BEA72307B0E77C76E6066A15540661F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C257B856EA56A4066A45960661F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C717F697F8B7F5B7D1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C2C72005AA04D65621F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C4972626A005AC0518049E1551F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C40622162A04DC359E05580491F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C}
          end
          object btGoToOrder: TBitBtn
            Left = 300
            Top = 4
            Width = 117
            Height = 25
            Caption = #1055#1077#1088#1077#1081#1090#1080' '#1074' '#1079#1072#1082#1072#1079
            TabOrder = 2
            OnClick = btGoToOrderClick
            Glyph.Data = {
              36090000424D3609000000000000360000002800000030000000100000000100
              18000000000000090000120B0000120B00000000000000000000FF00FF078DBE
              078DBE078DBE078DBE078DBE078DBE078DBE078DBE078DBE078DBE078DBE078D
              BE078DBEFF00FFFF00FFFF00FF91919191919191919191919191919191919191
              9191919191919191919191919191919191919191FF00FFFF00FFFF00FF0274AC
              0274AC0274AC0274AC0274AC0274AC0274AC0274AC0274AC0274AC0274AC0274
              AC0274ACFF00FFFF00FF078DBE25A1D172C7E785D7FA66CDF965CDF965CDF965
              CDF965CDF865CDF965CDF866CEF939ADD8078DBEFF00FFFF00FF9191919D9D9D
              C4C4C4D4D4D4C7C7C7C7C7C7C7C7C7C7C7C7C6C6C6C7C7C7C6C6C6C7C7C7A8A8
              A8919191FF00FFFF00FF0274AC138AC457B7E06BCBF84BBFF74ABFF74ABFF74A
              BFF74ABFF64ABFF74ABFF64BC0F72398CC0274ACFF00FFFF00FF078DBE4CBCE7
              39A8D1A0E2FB6FD4FA6FD4F96ED4FA6FD4F96FD4FA6FD4FA6FD4FA6ED4F93EB1
              D984D7EB078DBEFF00FF919191B5B5B5A5A5A5DFDFDFCBCBCBCBCBCBCBCBCBCB
              CBCBCBCBCBCBCBCBCBCBCBCACACAAAAAAACDCDCD919191FF00FF0274AC33AAE0
              2392C489D9FA54C7F854C7F753C7F854C7F754C7F854C7F854C7F853C7F7279D
              CE6ACBE50274ACFF00FF078DBE72D6FA078DBEAEEAFC79DCFB79DCFB79DCFB79
              DCFB79DCFB7ADCFB79DCFA79DCFA44B5D9AEF1F9078DBEFF00FF919191CCCCCC
              898989E5E5E5D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0CFCFCFCFCFCFACAC
              ACE4E4E4919191FF00FF0274AC57CAF80274AC99E3FB5ED1FA5ED1FA5ED1FA5E
              D1FA5ED1FA5FD1FA5ED1F85ED1F82CA1CE99EDF70274ACFF00FF078DBE79DDFB
              1899C79ADFF392E7FB84E4FB83E4FC83E4FC84E4FC83E4FC83E4FB84E5FC48B9
              DAB3F4F9078DBEFF00FF919191D0D0D0949494D9D9D9D9D9D9D4D4D4D4D4D4D4
              D4D4D4D4D4D4D4D4D4D4D4D4D4D4AFAFAFE6E6E6919191FF00FF0274AC5ED3FA
              0B81B782D5EF79E0FA6ADCFA69DCFB69DCFB6ADCFB69DCFB69DCFA6ADDFB2FA6
              CF9FF0F70274ACFF00FF078DBE82E3FC43B7DC65C3E0ACF0FD8DEBFC8DEBFC8D
              EBFD8DEBFD8DEBFC8DEBFD0C85184CBBDAB6F7F96DCAE0078DBE919191D4D4D4
              ADADADBCBCBCE4E4E4D8D8D8D8D8D8D8D8D8D8D8D8D8D8D8D8D8D8888888B0B0
              B0E7E7E7C0C0C09191910274AC68DAFB2BA4D14AB2D797EBFC74E5FB74E5FB74
              E5FC74E5FC74E5FB74E5FC046B0B33A9CFA3F4F752BBD70274AC078DBE8AEAFC
              77DCF3229CC6FDFFFFC8F7FEC9F7FEC9F7FEC9F7FEC8F7FE0C85183CBC5D0C85
              18DEF9FBD6F6F9078DBE919191D7D7D7CCCCCC989898FFFFFFF0F0F0F0F0F0F0
              F0F0F0F0F0F0F0F0888888B2B2B2888888F8F8F8F4F4F49191910274AC70E3FB
              5CD1EF1184B6FCFFFFB8F4FEBAF4FEBAF4FEBAF4FEB8F4FE046B0B25AA42046B
              0BD4F7FACAF3F70274AC078DBE93F0FE93F0FD1697C5078DBE078DBE078DBE07
              8DBE078DBE0C851852D97F62ED9741C4650C8518078DBE078DBE919191DBDBDB
              DBDBDB929292898989898989898989898989898989888888C6C6C6D4D4D4B7B7
              B78888888989899191910274AC7AEBFE7AEBFC0A7FB50274AC0274AC0274AC02
              74AC0274AC046B0B38CE6547E77F29B44A046B0B0274AC0274AC078DBE9BF5FE
              9AF6FE9AF6FE9BF5FD9BF6FE9AF6FE9BF5FE0C851846CE6C59E48858E18861EB
              9440C1650C8518FF00FF919191DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE
              DEDE888888BDBDBDCDCDCDCCCCCCD4D4D4B5B5B5888888FF00FF0274AC83F2FE
              82F3FE82F3FE83F2FC83F3FE82F3FE83F2FE046B0B2DC0513FDC6E3ED86E46E5
              7B28B04A046B0BFF00FF078DBEFEFEFEA0FBFFA0FBFEA0FBFEA1FAFEA1FBFE0C
              85180C85180C85180C851856E18447CD6E0C85180C85180C8518919191FFFFFF
              E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0888888888888888888888888CBCBCBBDBD
              BD8888888888888888880274ACFEFEFE89FAFF89FAFE89FAFE8AF8FE8AFAFE04
              6B0B046B0B046B0B046B0B3CD86A2EBF53046B0B046B0B046B0BFF00FF078DBE
              FEFEFEA5FEFFA5FEFFA5FEFF078CB643B7DC43B7DC43B7DC0C85184EDD7936BA
              540C8518FF00FFFF00FFFF00FF919191FFFFFFE3E3E3E3E3E3E3E3E3919191AD
              ADADADADADADADAD888888C6C6C6AFAFAF888888FF00FFFF00FFFF00FF0274AC
              FEFEFE8FFEFF8FFEFF8FFEFF0273A32BA4D12BA4D12BA4D1046B0B35D35E20A7
              3A046B0BFF00FFFF00FFFF00FFFF00FF078DBE078DBE078DBE078DBEFF00FFFF
              00FFFF00FFFF00FF0C851840D0650C8518FF00FFFF00FFFF00FFFF00FFFF00FF
              919191919191919191919191FF00FFFF00FFFF00FFFF00FF888888BCBCBC8888
              88FF00FFFF00FFFF00FFFF00FFFF00FF0274AC0274AC0274AC0274ACFF00FFFF
              00FFFF00FFFF00FF046B0B28C24A046B0BFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0C85182AB7432DBA490C85
              18FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FF888888A8A8A8ABABAB888888FF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF046B0B17A42B19A730046B
              0BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FF0C851821B5380C8518FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF888888A4A4A4888888FF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FF046B0B11A122046B0BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FF0C85180C85180C85180C8518FF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF88
              8888888888888888888888FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FF046B0B046B0B046B0B046B0BFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0C85180C85180C
              85180C8518FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FF888888888888888888888888FF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF046B0B046B0B04
              6B0B046B0BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
            NumGlyphs = 3
          end
          object edInvoice: TEdit
            Left = 460
            Top = 6
            Width = 63
            Height = 21
            BevelEdges = []
            BevelInner = bvNone
            BevelOuter = bvNone
            TabOrder = 3
            OnChange = edInvoiceChange
          end
        end
        object paInvoiceItems: TPanel
          Left = 0
          Top = 307
          Width = 525
          Height = 78
          Align = alBottom
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 2
          ExplicitTop = 185
          object dgOrderInvoiceItems: TMyDBGridEh
            Left = 0
            Top = 0
            Width = 525
            Height = 78
            Align = alClient
            DataGrouping.GroupLevels = <>
            Flat = True
            FooterColor = clWindow
            FooterFont.Charset = DEFAULT_CHARSET
            FooterFont.Color = clWindowText
            FooterFont.Height = -11
            FooterFont.Name = 'Tahoma'
            FooterFont.Style = []
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
            OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
            RowDetailPanel.Color = clBtnFace
            RowHeight = 16
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            Columns = <
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
                Title.Caption = #1044#1072#1090#1072' '#1089#1095#1077#1090#1072
                Width = 63
              end
              item
                EditButtons = <>
                FieldName = 'PayTypeName'
                Footers = <>
                Title.Caption = #1042#1080#1076
              end
              item
                EditButtons = <>
                FieldName = 'ItemText'
                Footers = <>
                Title.Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
                Width = 98
              end
              item
                EditButtons = <>
                FieldName = 'ItemCost'
                Footers = <>
                Title.Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1089#1095#1077#1090#1091
                Width = 84
              end
              item
                EditButtons = <>
                FieldName = 'PayCost'
                Footers = <>
                Title.Caption = #1054#1087#1083#1072#1095#1077#1085#1086
                Width = 78
              end
              item
                EditButtons = <>
                FieldName = 'ItemDebt'
                Footers = <>
                Title.Caption = #1044#1086#1083#1075', '#1075#1088#1085
                Visible = False
                OnGetCellParams = dgOrderInvoiceItemsColumns5GetCellParams
              end
              item
                EditButtons = <>
                FieldName = 'ContragentFullName'
                Footers = <>
                Title.Caption = #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082
                Width = 181
              end>
            object RowDetailData: TRowDetailPanelControlEh
            end
          end
        end
      end
      object Panel4: TPanel
        Left = 535
        Top = 0
        Width = 204
        Height = 385
        Align = alClient
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 1
        ExplicitWidth = 182
        ExplicitHeight = 263
        object dgIncomes: TMyDBGridEh
          Left = 0
          Top = 31
          Width = 204
          Height = 354
          Align = alClient
          AllowedOperations = []
          DataGrouping.GroupLevels = <>
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          FooterColor = clInfoBk
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'Tahoma'
          FooterFont.Style = []
          FooterRowCount = 1
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
          ParentFont = False
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
          OnDblClick = siEditIncomeClick
          OnDrawColumnCell = dgIncomesDrawColumnCell
          Columns = <
            item
              EditButtons = <>
              FieldName = 'SyncState'
              Footers = <>
              MaxWidth = 16
              MinWidth = 16
              Title.Caption = ' '
              Width = 16
              OnGetCellParams = dgIncomesColumns0GetCellParams
            end
            item
              EditButtons = <>
              FieldName = 'IncomeDate'
              Footers = <>
              Title.Caption = #1044#1072#1090#1072
              Width = 60
            end
            item
              EditButtons = <>
              FieldName = 'PayTypeName'
              Footers = <>
              Title.Caption = #1042#1080#1076' '#1086#1087#1083#1072#1090#1099
              Width = 91
            end
            item
              EditButtons = <>
              FieldName = 'IncomeGrn'
              Footer.Alignment = taRightJustify
              Footer.ValueType = fvtSum
              Footers = <>
              Title.Caption = #1057#1091#1084#1084#1072
              Width = 66
            end
            item
              EditButtons = <>
              FieldName = 'ReturnCost'
              Footer.ValueType = fvtSum
              Footers = <>
              Title.Caption = #1050#1086#1088#1088#1077#1082#1094#1080#1103
              Width = 62
            end
            item
              Alignment = taRightJustify
              EditButtons = <>
              FieldName = 'RestIncome'
              Footer.ValueType = fvtSum
              Footers = <>
              Title.Caption = #1055#1077#1088#1077#1087#1083#1072#1090#1072
              Width = 66
              OnGetCellParams = dgIncomesRestIncomeGetCellParams
            end
            item
              EditButtons = <>
              FieldName = 'IncomeInvoiceNum'
              Footers = <>
              Title.Caption = #8470' '#1089#1095#1077#1090#1072
            end
            item
              EditButtons = <>
              FieldName = 'CustomerName'
              Footers = <>
              Title.Caption = #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082
              Width = 79
            end
            item
              EditButtons = <>
              FieldName = 'GetterName'
              Footers = <>
              Title.Caption = #1055#1088#1080#1085#1103#1083
              Width = 77
            end
            item
              EditButtons = <>
              FieldName = 'GetterComment'
              Footers = <>
              Title.Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
              Width = 178
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 204
          Height = 31
          Align = alTop
          BevelOuter = bvNone
          Caption = ' '
          Color = clGray
          ParentBackground = False
          TabOrder = 1
          ExplicitWidth = 182
          object Label2: TLabel
            Left = 8
            Top = 10
            Width = 79
            Height = 13
            Caption = #1055#1086#1089#1090#1091#1087#1083#1077#1085#1080#1103':'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object btAdd: TBitBtn
            Left = 97
            Top = 4
            Width = 92
            Height = 25
            Caption = #1042#1085#1077#1089#1090#1080'...'
            TabOrder = 0
            OnClick = siAddIncomeClick
            Glyph.Data = {
              42020000424D4202000000000000420000002800000010000000100000000100
              10000300000000020000120B0000120B00000000000000000000007C0000E003
              00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7CC355C355C355C355C355C355C355C355C355C355C355
              C3551F7C1F7C1F7CC355DE7FDD7FDD7FDC7BBC7BBB7BBB7BBA7B9A7B997B997B
              997BC3551F7C1F7CC355FE7F876A666A666A656A646A446A4366426622662166
              997BC3551F7C1F7CC355FF7F886A876A666A666AFF7F1177446A436642662266
              997BC3551F7C1F7CC355FF7F886E886A876A666AFF7F1177646A446A43664266
              9A7BC3551F7C1F7CC355FF7FA96E896E886A876AFF7F1177656A656A446A4366
              BA7BC3551F7C1F7CC355FF7FAA6EFF7FFF7FFF7FFF7FFF7FFF7FFF7F656A446A
              BB7BC3551F7C1F7CC355FF7FCB6E117711771177FF7F117711771177656A656A
              BC7BC3551F7C1F7CC355FF7FCC6ECB6EAA6EA96EFF7F1177876A876A666A656A
              DC7BC3551F7C1F7CC355FF7FCD72CC6ECB6EAA6EFF7F1177886A876A876A666A
              DC7FC3551F7C1F7CC355FF7FEF72EE72CD6ECB6EAA6EA96E896E886A876A876A
              DD7FC3551F7C1F7CC355FF7F1073EF72EE72CD6ECC6EAA6EA96EA96E886E886A
              DD7FC3551F7C1F7CC355FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFE7F
              FE7FC3551F7C1F7C1F7CC355C355C355C355C355C355C355C355C355C355C355
              C3551F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C}
          end
          object btDelete: TBitBtn
            Left = 195
            Top = 4
            Width = 93
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100
            TabOrder = 1
            OnClick = siDeleteIncomeClick
            Glyph.Data = {
              42020000424D4202000000000000420000002800000010000000100000000100
              10000300000000020000430B0000430B00000000000000000000007C0000E003
              00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C80588058805880588058805880588058805880588058
              80581F7C1F7C1F7CA0687A7F7A7F597F597F597F387F387F377F177FF57E927E
              4F7E80581F7C1F7CA0687B7F037DE378E278C278E278E278E278A078A078A078
              927E80581F7C1F7CA0687B7F047D037DE378E278E278E278E278A078A078A078
              F57E80581F7C1F7CA0689B7F247D047D037DE378E278E278E278C178A078A078
              177F80581F7C1F7CA0689C7F257D887D887D887D887D887D887D887D887D887D
              377F80581F7C1F7CA068BC7F467DF67AFE7FFE7FFE7FFE7FFE7FFE7FFE7F887D
              387F80581F7C1F7CA068BD7F687DF67AF67AF67AF67AF67AF67AF67AF67A887D
              387F80581F7C1F7CA068BD7FA97D887D677D677D257D037D037DE378E278C278
              597F80581F7C1F7CA068DE7FEB7DCB7DA97D677D677D257D037D037DE378E278
              597F80581F7C1F7CA068DE7F0D7EEC7DCB7D897D677D677D257D047D037DE378
              5A7F80581F7C1F7CA068FF7F2E7E0D7EEC7DA97D887D677D677D257D047D037D
              7A7F80581F7C1F7CA068FF7FFF7FDE7FDE7FDD7FBD7FBD7FBC7F9C7F9B7F7B7F
              7A7F80581F7C1F7C1F7CA068A068A068A068A068A068A068A068A068A068A068
              A0681F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C}
          end
          object btEdit: TBitBtn
            Left = 294
            Top = 4
            Width = 93
            Height = 25
            Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
            TabOrder = 2
            OnClick = siEditIncomeClick
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
          end
        end
      end
    end
  end
  object OrderTimer: TTimer
    Enabled = False
    Interval = 200
    Left = 8
    Top = 108
  end
end
