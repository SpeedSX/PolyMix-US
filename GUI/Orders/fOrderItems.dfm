object fOrderItems: TfOrderItems
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  TabOrder = 0
  object paOrderState: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 304
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    object paHdr: TPanel
      Left = 0
      Top = 0
      Width = 451
      Height = 22
      Align = alTop
      BevelOuter = bvNone
      Caption = ' '
      Color = clGray
      ParentBackground = False
      TabOrder = 0
      Visible = False
      object lbHdr: TLabel
        Left = 12
        Top = 4
        Width = 84
        Height = 13
        Caption = #1057#1086#1089#1090#1072#1074' '#1079#1072#1082#1072#1079#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHighlightText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object imEmpty: TImage
        Left = 160
        Top = 1
        Width = 16
        Height = 16
        Picture.Data = {
          07544269746D6170C2000000424DC20000000000000042000000280000001000
          000010000000010004000000000080000000E50E0000E50E0000030000000300
          000000000000FFFFFF0000808000222222222222222222222222222222222222
          2222222222222222222222222222222222222222222222222222222222222222
          2222222222222222222222222222222222222222222222222222222222222222
          2222222222222222222222222222222222222222222222222222222222222222
          2222222222222222222222222222}
        Visible = False
      end
    end
    object pcOrderItems: TPageControl
      Left = 0
      Top = 22
      Width = 451
      Height = 282
      ActivePage = tsCost
      Align = alClient
      TabOrder = 1
      object tsCost: TTabSheet
        Caption = #1057#1086#1089#1090#1072#1074
        ImageIndex = 2
        object paCostBottom: TPanel
          Left = 0
          Top = 0
          Width = 443
          Height = 33
          Align = alTop
          BevelOuter = bvNone
          Caption = ' '
          ParentColor = True
          TabOrder = 0
          object BitBtn1: TBitBtn
            Left = 305
            Top = 2
            Width = 121
            Height = 25
            Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
            Enabled = False
            TabOrder = 2
            Visible = False
            Glyph.Data = {
              C2000000424DC200000000000000420000002800000010000000100000000100
              04000000000080000000430B0000430B0000030000000300000000000000FFFF
              FF005E5E5E001111111111111111111111111111111111111111111111111112
              2111111111111112222111111111111222222111111111122222222111111112
              2222222221111112222222222111111222222221111111122222211111111112
              2221111111111112211111111111111111111111111111111111111111111111
              111111111111}
            Layout = blGlyphRight
          end
          object btMakeContractor: TBitBtn
            Left = 133
            Top = 2
            Width = 161
            Height = 25
            Caption = #1057#1091#1073#1087#1086#1076#1088#1103#1076#1085#1072#1103' '#1088#1072#1073#1086#1090#1072
            TabOrder = 1
            OnClick = btMakeContractorClick
            Glyph.Data = {
              FA030000424DFA03000000000000FA0100002800000020000000100000000100
              08000000000000020000210B0000210B00007100000071000000FFFFFF0000FF
              FF00FF00FF000000FF00FFFF000000FF0000FF00000000000000F65B4000F763
              4A00F64F2E00F6513000F6523100F6533200F6533300F6573600F6583700F659
              3800F65C3B00F7603F00E4573B00F6624200F4644600F56D5200F8725800DB52
              3400C94D3000D8553600D8563700F7614000D8573800CA513500F8654400AF49
              3100F8674700F8694800F96E4D00F96F4F00F7755600FB836500FD846800FB7D
              5C00FA816100CB633700C96A3A008D563400B5632E00FEE0C200FA8100009463
              2100FFDEAD00FFEFD7003F8CBA0091D4FF002475B4003E9BEA00429AE10048A1
              ED0047A0EC0054A9EF0059ADF1003592E3003590E1003995E700449EEC00479E
              EA004E98D900F4F4F400ECECEC00E8E8E800D4D4D400D2D2D200CCCCCC00CBCB
              CB00C9C9C900C8C8C800C6C6C600C3C3C300C2C2C200BBBBBB00B9B9B900B6B6
              B600B4B4B400AFAFAF00ADADAD00ABABAB00AAAAAA00A7A7A700A5A5A500A4A4
              A400A2A2A200A1A1A100A0A0A0009F9F9F009E9E9E009D9D9D009C9C9C009B9B
              9B009A9A9A009999990098989800979797009696960095959500949494009292
              92008E8E8E008D8D8D008C8C8C008A8A8A006F6F6F005A5A5A00353535000202
              0202020202020202020202020202020202020202020202020202020202020202
              6F706F6F706F02020230300202020202696E69696E6902020259590202020202
              312D211F2D310202302F2F3002020202696B6D696B6902025944445902020202
              310919092C3102302F2F2F2F30020202695968595D6902594444444459020242
              3108080808314230303030303002024C695E5E5E5E694C595959595959020218
              1B110F0A0D1B1702020202020202025466616268656656020202020202020217
              1C201D0B101C1702026E026E0202025665595B67616556020259025902020217
              1E23200C121E17026E0202026E020256655759665F6556025902020259020217
              2724220E132A1702026E026E02020256505658655C5156020259025902020217
              29252632152817020202026C02020256525553455A5056020202025002020202
              1716333316170202020202020202020256594343595602020202020202020202
              0202363602020202020202020202020202025454020202020202020202020202
              0234383D340202020202020202020202024F4B4D4F0202020202020202020202
              02413C403E0202020202020202020202024946494E0202020202020202020202
              023B35393F0202020202020202020202024745484C0202020202020202020202
              020202020202020202020202020202020202020202020202020202020202}
            NumGlyphs = 2
            Spacing = 8
          end
          object btMakeOwnCost: TBitBtn
            Left = 0
            Top = 2
            Width = 121
            Height = 25
            Caption = #1057#1074#1086#1103' '#1088#1072#1073#1086#1090#1072
            TabOrder = 0
            OnClick = btMakeOwnCostClick
            Glyph.Data = {
              36060000424D3606000000000000360000002800000020000000100000000100
              18000000000000060000120B0000120B00000000000000000000FF00FFFF00FF
              FF00FFFF00FFFF00FF8684838684837B7B7AFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA1A1A1AFAFAFAF
              AFAFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FF868483ABAAAAE5E5E5C5C5C48684838684836E6D6CFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA3A3A3BCBCBCEBEBEBD1
              D1D1AFAFAFAFAFAFAFAFAFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FF868483B4B4B4FFFFFFF8F8F8E7E7E7EEE7E3749EB5074D7D2858756572
              76868483FF00FFFF00FFFF00FFFF00FFFF00FFA9A9A9C4C4C4FFFFFFFAFAFAED
              EDEDEEEEEEA9A9A9A2A2A2B5B5B59A9A9AAFAFAFFF00FFFF00FFFF00FFFF00FF
              868483C4C2C2FFFFFFFFFFFFFAFAFAEBEBEBF4EDE978A3BA0047800045806E98
              ACB7B2B08684835E5E5DFF00FFFF00FFABABABD0D0D0FFFFFFFFFFFFFBFBFBF0
              F0F0F2F2F2ADADAD9B9B9B9B9B9BA3A3A3C4C4C4AFAFAF8B8B8BFF00FF868483
              D7D7D7FFFFFFFFFFFFFFFFFFFCFCFCF3F3F3FCF4F07EA9C000488000467F789E
              B1D0CCCAB2B2B25C5C5BFF00FFAFAFAFE0E0E0FFFFFFFFFFFFFFFFFFFDFDFDF6
              F6F6F8F8F8B2B2B29B9B9B9A9A9AA9A9A9D8D8D8C3C3C3898989FF00FF868483
              FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBFFFEFA82ADC500488000457F7DA3
              B7D4D0CFB4B4B25C5C5BFF00FFAFAFAFFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFC
              FCFCFDFDFDB6B6B69B9B9B9A9A9AAEAEAEDCDCDCC3C3C3898989FF00FF868483
              FFFEFCFFFFFFA0B8C76790ABC4D4DEFFFFFFFFFFFF7FADC6003F790040797FA7
              BBDDD9D8B8BABA5F5C5AFF00FFAFAFAFFEFEFEFFFFFFBFBFBFAAAAAAD9D9D9FF
              FFFFFFFFFFB5B5B5989898989898B0B0B0E3E3E3C8C8C8898989FF00FF868483
              E6E9EB507F9C005C90005C950D547FBCCED9FFFFFFD8E6EE7BAAC53A7DA498B7
              C7E2E0DECBC4C03B515CFF00FFAFAFAFECECECC1C1C19393939696969C9C9CD2
              D2D2FFFFFFE9E9E9C6C6C6989898C0C0C0E7E7E7D4D4D4898989FF00FF868483
              1859820078B200BAFB00ACED00689F0D517DBDCED9FFFFFFFFFFFFF7F6F4E9EA
              EAEEEAE9C2C1C2174663FF00FFAFAFAFA5A5A59F9F9FB5B5B5B2B2B29E9E9E9B
              9B9BD3D3D3FFFFFFFFFFFFF8F8F8EEEEEEF0F0F0CFCFCF989898FF00FF095E8A
              009FE000C4FF00BAFB00B4F400A3E200659C0D4F78BCCED9FFFFFFFCFCFCFFFF
              FBB5C2CC1C5A80004E80FF00FF9B9B9BACACACB7B7B7B4B4B4B3B3B3AFAFAF9C
              9C9C989898D2D2D2FFFFFFFDFDFDFFFFFFCBCBCB9393938F8F8FFF00FF01679D
              00CAFF00BDFF00BAFB00B0F000ABEB009CDA00639A0D4F79C0D0DAFFFFFF81A1
              B6044570005589FF00FFFF00FFA0A0A0B8B8B8B5B5B5B4B4B4B2B2B2B1B1B1AE
              AEAE9B9B9B999999D5D5D5FFFFFFA8A8A88B8B8B959595FF00FFFF00FF01679D
              00ABEA00C2FF00BAFB00B1F200A9E900A0E10093D000639913557E416F8F0043
              72005E92FF00FFFF00FFFF00FFA0A0A0B0B0B0B6B6B6B4B4B4B2B2B2B0B0B0AF
              AFAFACACAC9C9C9C9F9F9FB0B0B08787879A9A9AFF00FFFF00FFFF00FFFF00FF
              01679D00B2F200BDFE00B1F200A9E70EB0E935CCF7008CCA00659A00497A015F
              93FF00FFFF00FFFF00FFFF00FFFF00FF9F9F9FB3B3B3B4B4B4B2B2B2B1B1B1B9
              B9B9CECECEABABAB9C9C9C8D8D8D9B9B9BFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FF01679D00AFEF00B4F602AAE702AAE735CCF7009FE001679DFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA3A3A3B1B1B1B3B3B3B2B2B2CD
              CDCDCECECEACACACA1A1A1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FF01679D00A9EA01ADEE01679D04A4D50089C401679DFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA2A2A2B0B0B0B4B4B4A2
              A2A2ADADADA8A8A8A2A2A2FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FF01679D01679DFF00FF01679D01679DFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA2A2A2A2A2A2FF
              00FFA2A2A2A2A2A2FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
            Margin = 8
            NumGlyphs = 2
            Spacing = 8
          end
        end
        object dgCost: TMyDBGridEh
          Left = 0
          Top = 33
          Width = 443
          Height = 191
          Align = alClient
          AllowedOperations = [alopUpdateEh]
          AllowedSelections = [gstNon]
          AutoFitColWidths = True
          ColumnDefValues.Layout = tlCenter
          Ctl3D = True
          DataGrouping.GroupLevels = <>
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'Tahoma'
          FooterFont.Style = []
          MinAutoFitWidth = 20
          Options = [dgTitles, dgColumnResize, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
          ParentCtl3D = False
          RowDetailPanel.Color = clBtnFace
          RowHeight = 16
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDrawColumnCell = dgEnabledDrawColumnCell
          OnGetCellParams = dgExecStateGetCellParams
          Columns = <
            item
              AutoFitColWidth = False
              Checkboxes = True
              EditButtons = <>
              FieldName = 'Enabled'
              Footers = <>
              ReadOnly = True
              Title.Caption = ' '
              Width = 16
            end
            item
              EditButtons = <>
              FieldName = 'ItemDesc'
              Footers = <>
              ReadOnly = True
              Title.Caption = #1055#1088#1086#1094#1077#1089#1089
              Title.Hint = 'erljkfhekljrtghl'
              Width = 196
            end
            item
              EditButtons = <>
              FieldName = 'ProductOut'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1050#1086#1083'-'#1074#1086
            end
            item
              EditButtons = <>
              FieldName = 'Cost'
              Footers = <>
              ReadOnly = True
              Title.Alignment = taCenter
              Title.Caption = #1056#1072#1089#1095#1077#1090'. '#1089#1090#1086#1080#1084'.'
              Width = 82
            end
            item
              EditButtons = <>
              FieldName = 'FinalProfitCost'
              Footers = <>
              MinWidth = 20
              ReadOnly = True
              Title.Alignment = taCenter
              Title.Caption = #1044#1083#1103' '#1079#1072#1082#1072#1079#1095#1080#1082#1072
              Width = 78
            end
            item
              AutoFitColWidth = False
              Checkboxes = True
              EditButtons = <>
              FieldName = 'IsItemInProfit'
              Footers = <>
              Title.Caption = ' '
              Width = 18
            end
            item
              EditButtons = <>
              FieldName = 'ItemProfit'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1053#1072#1094#1077#1085#1082#1072
              OnGetCellParams = dgCostProfitColumnsGetCellParams
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
        object paWorkMat: TPanel
          Left = 0
          Top = 224
          Width = 443
          Height = 30
          Align = alBottom
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 2
          object Label1: TLabel
            Left = 6
            Top = 10
            Width = 40
            Height = 13
            Caption = #1056#1072#1073#1086#1090#1072':'
            Transparent = True
          end
          object Label2: TLabel
            Left = 186
            Top = 10
            Width = 62
            Height = 13
            Caption = #1052#1072#1090#1077#1088#1080#1072#1083#1099':'
            Transparent = True
          end
          object Panel1: TPanel
            Left = 56
            Top = 6
            Width = 113
            Height = 21
            BevelOuter = bvLowered
            Caption = ' '
            Color = clCream
            TabOrder = 0
            object dtWorkCost: TDBText
              Left = 42
              Top = 4
              Width = 67
              Height = 13
              Alignment = taRightJustify
              AutoSize = True
              DataField = 'EnabledWorkCost'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              Transparent = True
            end
          end
          object Panel2: TPanel
            Left = 254
            Top = 6
            Width = 113
            Height = 21
            BevelOuter = bvLowered
            Caption = ' '
            Color = clCream
            TabOrder = 1
            object dtMatCost: TDBText
              Left = 50
              Top = 4
              Width = 59
              Height = 13
              Alignment = taRightJustify
              AutoSize = True
              DataField = 'EnabledMatCost'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              Transparent = True
            end
          end
          object cbShowChanges: TCheckBox
            Left = 388
            Top = 8
            Width = 213
            Height = 17
            Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1089#1090#1086#1080#1084#1086#1089#1090#1080
            TabOrder = 2
          end
        end
      end
      object tsMat: TTabSheet
        Caption = #1052#1072#1090#1077#1088#1080#1072#1083#1099
        ImageIndex = 1
        object dgMat: TMyDBGridEh
          Left = 0
          Top = 33
          Width = 443
          Height = 221
          Align = alClient
          AllowedOperations = [alopUpdateEh]
          AllowedSelections = [gstNon]
          AutoFitColWidths = True
          ColumnDefValues.Layout = tlCenter
          Ctl3D = True
          DataGrouping.GroupLevels = <>
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'Tahoma'
          FooterFont.Style = []
          Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
          ParentCtl3D = False
          RowDetailPanel.Color = clBtnFace
          RowHeight = 16
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          UseMultiTitle = True
          VTitleMargin = 5
          OnDblClick = btEditMatRequestClick
          OnDrawColumnCell = dgMatDrawColumnCell
          OnGetCellParams = dgMatGetCellParams
          Columns = <
            item
              EditButtons = <>
              FieldName = 'ExternalMatID'
              Footers = <>
              MaxWidth = 18
              MinWidth = 18
              Title.Caption = ' '
              Width = 18
            end
            item
              EditButtons = <>
              EndEllipsis = True
              FieldName = 'MatDesc'
              Footers = <>
              ReadOnly = True
              Title.Caption = #1052#1072#1090#1077#1088#1080#1072#1083
              Width = 318
            end
            item
              AlwaysShowEditButton = True
              EditButtons = <>
              FieldName = 'SupplierID'
              Footers = <>
              Title.Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
              Width = 78
            end
            item
              Alignment = taRightJustify
              EditButtons = <>
              FieldName = 'MatAmount'
              Footers = <>
              Title.Caption = #1050#1086#1083'-'#1074#1086
              Width = 69
            end
            item
              EditButtons = <>
              FieldName = 'MatUnitName'
              Footers = <>
              Title.Caption = #1077#1076'.'
              Width = 23
            end
            item
              Alignment = taRightJustify
              EditButtons = <>
              FieldName = 'MatCost'
              Footers = <>
              Title.Caption = #1056#1072#1089#1095#1077#1090#1085#1072#1103' '#1089#1090#1086#1080#1084#1086#1089#1090#1100
            end
            item
              EditButtons = <>
              FieldName = 'MatCostNative'
              Footers = <>
              Title.Caption = #1056#1072#1089#1095#1077#1090#1085#1072#1103' '#1089#1090#1086#1080#1084#1086#1089#1090#1100', '#1075#1088#1085'..'
            end
            item
              AlwaysShowEditButton = True
              EditButtons = <>
              FieldName = 'PlanReceiveDate'
              Footers = <>
              Title.Caption = #1044#1072#1090#1072' '#1087#1086#1089#1090#1072#1074#1082#1080'|'#1054#1078#1080#1076#1072#1077#1084#1072#1103
              OnUpdateData = dgMatColumnsPlanReceiveDateUpdateData
            end
            item
              AlwaysShowEditButton = True
              EditButtons = <>
              FieldName = 'FactReceiveDate'
              Footers = <>
              Title.Caption = #1044#1072#1090#1072' '#1087#1086#1089#1090#1072#1074#1082#1080'|'#1060#1072#1082#1090#1080#1095'.'
              OnUpdateData = dgMatColumnsFactReceiveDateUpdateData
            end
            item
              EditButtons = <>
              FieldName = 'FactMatAmount'
              Footers = <>
              Title.Caption = #1060#1072#1082#1090#1080#1095'. '#1082#1086#1083'-'#1074#1086
            end
            item
              EditButtons = <>
              FieldName = 'FactMatCost'
              Footers = <>
              Title.Caption = #1060#1072#1082#1090#1080#1095'. '#1089#1090#1086#1080#1084#1086#1089#1090#1100
            end
            item
              EditButtons = <>
              FieldName = 'PayDate'
              Footers = <>
              Title.Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
              Width = 66
              OnUpdateData = dgMatPayDateUpdateData
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
        object paMatTop: TPanel
          Left = 0
          Top = 0
          Width = 443
          Height = 33
          Align = alTop
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 1
          object btCancelRequest: TBitBtn
            Left = 107
            Top = 2
            Width = 94
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100'...'
            TabOrder = 0
            OnClick = btCancelRequestClick
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
            Spacing = 8
          end
          object btShowRequest: TBitBtn
            Left = 294
            Top = 2
            Width = 133
            Height = 25
            Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1079#1072#1103#1074#1082#1091
            Enabled = False
            TabOrder = 1
            Visible = False
            Glyph.Data = {
              2A030000424D2A030000000000002A0100002800000020000000100000000100
              08000000000000020000650F0000650F00003D0000003D000000FFFFFF0000FF
              FF00FF00FF000000FF00FFFF000000FF0000FF00000000000000F7BB9100FBA3
              6400806C560091EEFC0099F0FC009EF3FF00A0F3FF00A1F4FF007DE5F8008AEA
              FB0089EAFA008BEBFB0091EDFC0097EFFE0098EFFE0098F0FE0099F0FE006FDE
              F60070E0F60076E1F70076E2F70078E2F7007BE3F70083E7FA0086E7FA0037A9
              DD000E8CCA002C9DDC0005609600DADADA00D9D9D900D8D8D800D6D6D600D5D5
              D500D2D2D200D0D0D000CFCFCF00CECECE00CDCDCD00CCCCCC00CBCBCB00C7C7
              C700C6C6C600C5C5C500C4C4C400C1C1C100C0C0C000BDBDBD009B9B9B009494
              940084848400797979005C5C5C00020202020202020202020202020202020202
              020202020202020202020202020202222424242424242424242424242402023B
              3C3C3C3C3C3C3C3C3C3C3C3C3C0202220D1714111F101B1923240C0C2202023B
              27292A2D30313436393C29293B0202220E0D1514121F1E1B230C24162202023B
              2627292A2E30323439293C293B0202230F0F0D1714111F10230C0C2422020239
              252527292A2D30313929293C3B0202230F0F0E0D1514121F0A22222222020239
              25252627292A2E303A3B3B3B3B0202230F0F0F0F0D180B130A0A1C1A22020239
              2525252527282A2C3A3A34353B0202210F0F0F0F0F0A0A0A0A090A1D21020238
              25252525253A3A3A3A373A33380202210F0F0F0F0F0A08090909090A21020238
              25252525253A2B373737373A380202210F0F0F0F0F0A0A0A0A090A2021020238
              25252525253A3A3A3A373A2F3802022122222222222222220A0A222222020238
              3B3B3B3B3B3B3B3B3A3A3B3B3B02020202020202020202020A02020202020202
              02020202020202023A0202020202020202020202020202020202020202020202
              0202020202020202020202020202020202020202020202020202020202020202
              0202020202020202020202020202020202020202020202020202020202020202
              0202020202020202020202020202020202020202020202020202020202020202
              0202020202020202020202020202}
            NumGlyphs = 2
            Spacing = 8
          end
          object btExternalMat: TBitBtn
            Left = 0
            Top = 2
            Width = 101
            Height = 25
            Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
            TabOrder = 2
            OnClick = btEditMatRequestClick
            Glyph.Data = {
              2A030000424D2A030000000000002A0100002800000020000000100000000100
              08000000000000020000650F0000650F00003D0000003D000000FFFFFF0000FF
              FF00FF00FF000000FF00FFFF000000FF0000FF00000000000000F7BB9100FBA3
              6400806C560091EEFC0099F0FC009EF3FF00A0F3FF00A1F4FF007DE5F8008AEA
              FB0089EAFA008BEBFB0091EDFC0097EFFE0098EFFE0098F0FE0099F0FE006FDE
              F60070E0F60076E1F70076E2F70078E2F7007BE3F70083E7FA0086E7FA0037A9
              DD000E8CCA002C9DDC0005609600DADADA00D9D9D900D8D8D800D6D6D600D5D5
              D500D2D2D200D0D0D000CFCFCF00CECECE00CDCDCD00CCCCCC00CBCBCB00C7C7
              C700C6C6C600C5C5C500C4C4C400C1C1C100C0C0C000BDBDBD009B9B9B009494
              940084848400797979005C5C5C00020202020202020202020202020202020202
              020202020202020202020202020202222424242424242424242424242402023B
              3C3C3C3C3C3C3C3C3C3C3C3C3C0202220D1714111F101B1923240C0C2202023B
              27292A2D30313436393C29293B0202220E0D1514121F1E1B230C24162202023B
              2627292A2E30323439293C293B0202230F0F0D1714111F10230C0C2422020239
              252527292A2D30313929293C3B0202230F0F0E0D1514121F0A22222222020239
              25252627292A2E303A3B3B3B3B0202230F0F0F0F0D180B130A0A1C1A22020239
              2525252527282A2C3A3A34353B0202210F0F0F0F0F0A0A0A0A090A1D21020238
              25252525253A3A3A3A373A33380202210F0F0F0F0F0A08090909090A21020238
              25252525253A2B373737373A380202210F0F0F0F0F0A0A0A0A090A2021020238
              25252525253A3A3A3A373A2F3802022122222222222222220A0A222222020238
              3B3B3B3B3B3B3B3B3A3A3B3B3B02020202020202020202020A02020202020202
              02020202020202023A0202020202020202020202020202020202020202020202
              0202020202020202020202020202020202020202020202020202020202020202
              0202020202020202020202020202020202020202020202020202020202020202
              0202020202020202020202020202020202020202020202020202020202020202
              0202020202020202020202020202}
            NumGlyphs = 2
            Spacing = 8
          end
          object btApproveOrderMaterials: TBitBtn
            Left = 207
            Top = 2
            Width = 147
            Height = 25
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1079#1072#1082#1091#1087#1082#1091
            TabOrder = 3
            OnClick = btApproveOrderMaterialsClick
            Glyph.Data = {
              32060000424D3206000000000000420000002800000028000000130000000100
              100003000000F0050000120B0000120B00000000000000000000007C0000E003
              00001F0000001F7C1F7C1F7C1F7C1F7C1F7C903E4D2E85018501850185014D2E
              903E1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1863D65A524A
              524A524A524A734E39671F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CC811
              8501E605861EC62E273B4643C636862AC50D85014E361F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C734E524A734EB556D65AF75EF75ED65AB556734E524AD65A1F7C
              1F7C1F7C1F7C1F7C1F7C1F7CA6098501C71E081BE90AEA16E9260A2F09332837
              4743A62E85050B221F7C1F7C1F7C1F7C1F7C1F7C734E524AD65AD65AB556D65A
              F75EF75EF75EF75EF75EB556524AB5561F7C1F7C1F7C1F7C1F7CC70DC6052A2F
              CA06CA02C902EA12E926092F092F092F092F283BE63A85052D2E1F7C1F7C1F7C
              1F7C734E524A1863945294529452D65AF75EF75EF75EF75EF75EF75ED65A524A
              D65A1F7C1F7C1F7C4D2E8501EC1ACA06CA026602E511A80AEA1EE92A092F092F
              092F0A2F283BC636850192461F7C1F7CD65A524AD65AB5569452734E734EB556
              D65AF75EF75EF75EF75EF75EF75ED65A524A18631F7C1F7C85016A1A0C1BCA06
              4602D34E7B6B4A26A80EE922E92A092F092F092FEA2A27370516E9191F7C1F7C
              524AB556D65AB556734E39679C73B556B556D65AF75EF75EF75EF75EF75EF75E
              945294521F7C903E8401313B0C1F670ED34E9C737C6F9C736C2EA70EEA1EE922
              E926E922EA1EE91AE62EA601134AF75E524A3967D65A94525A6BBD77BD77BD77
              D65AB556D65AD65AF75EF75ED65AD65AD65A524AD9662B1E2912523BCC1E1453
              BD779D73BD779D73BD776D32A70AEA0EE912E912C90ACA062727CA02C709B556
              94523967D65A5A6BDE7BBD77DE7BBD77DE7BF75E9452B556B556B556B5569452
              F75E9452734E2A1AAD26523B323FDE7BDE7BDE7BBC6FDE7BDE7BDE7B8D326602
              CA02CA02CA02CA02E81EE81EE6059452D65A39673967FF7FFF7FFF7FBD77FF7F
              FF7FFF7FF75E94529452945294529452D65AD65A734E4A1AD032533F30337653
              FF7F5447C90E985BFF7FFF7FFF7F8D366602CA02CA02CA02E81AE81E4712B556
              F75E396718637B6FFF7F5A6BB5569C73FF7FFF7FFF7FF75E734E945294529452
              D65AD65A94526B1ACF2E754F323B323B5343323B3137C90E9857FF7FFF7FFF7F
              8D364602CA02C9020B27E81E670AB556F75E7B6F396718635A6B39671863B556
              7B6FFF7FFF7FFF7FF75E734E94529452F75ED65A734EAC1EAC1A9857533F533F
              533F533F533F54430E23BA63FF7FFF7FFF7F1453880E31337353CA028802D65A
              B5567B6F39673967396739675A6B5A6BF75EBD77FF7FFF7FFF7F5A6B94521863
              7B6F9452B556F13A8702995F5443544354435443544354435443533FBB6BFF7F
              FF7FFF7F995F54432F3B8802D13A186394529C735A6B5A6B5A6B5A6B5A6B5A6B
              5A6B3967BD77FF7FFF7FFF7F9C735A6B186394521F7C1F7CA9061033995F533F
              544354435443544354435443533FBB67FF7FBB6B533F7453A90EAD221F7C1F7C
              945218639C735A6B5A6B5A6B5A6B5A6B5A6B5A6B3967BD77FF7FBD7739677B6F
              B556D65A1F7C1F7CF036870277579857533F544354435443544354435443533F
              7753533F754BED268802165B1F7C1F7C186394527B6F7B6F5A6B5A6B5A6B5A6B
              5A6B5A6B5A6B39677B6F39675A6BF75E94521F7C1F7C1F7C1F7CAB12880A9857
              985B5443544354435443544354435443533F764F323B8802D23E1F7C1F7C1F7C
              1F7CB55694527B6F9C735A6B5A6B5A6B5A6B5A6B5A6B5A6B5A6B7B6F39679452
              18631F7C1F7C1F7C1F7C1F7CAB128806323BBA639757754B5443544375477653
              9757ED228802CF2A1F7C1F7C1F7C1F7C1F7C1F7CB55694523967BD777B6F5A6B
              5A6B5A6B5A6B7B6F7B6FD65A9452F75E1F7C1F7C1F7C1F7C1F7C1F7C1F7CCF2E
              8802A90E102F5547764F7653323BEE2687028906144F1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7CF75E9452B55618635A6B7B6F7B6F3967F75E945294525A6B1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CCF2EA90A8802880288028802AB1A
              F13E1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CF75EB5569452
              945294529452B55618631F7C1F7C1F7C1F7C1F7C1F7C}
            NumGlyphs = 2
            Spacing = 5
          end
        end
      end
      object tsContr: TTabSheet
        Caption = #1057#1091#1073#1087#1086#1076#1088#1103#1076
        ImageIndex = 3
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object dgContr: TMyDBGridEh
          Left = 0
          Top = 33
          Width = 443
          Height = 191
          Align = alClient
          AllowedOperations = [alopUpdateEh]
          AllowedSelections = [gstNon]
          AutoFitColWidths = True
          ColumnDefValues.Layout = tlCenter
          Ctl3D = True
          DataGrouping.GroupLevels = <>
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'Tahoma'
          FooterFont.Style = []
          Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
          ParentCtl3D = False
          RowDetailPanel.Color = clBtnFace
          RowHeight = 16
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          UseMultiTitle = True
          VTitleMargin = 4
          OnDrawColumnCell = dgEnabledDrawColumnCell
          OnGetCellParams = dgExecStateGetCellParams
          Columns = <
            item
              EditButtons = <>
              EndEllipsis = True
              FieldName = 'ItemDesc'
              Footers = <>
              ReadOnly = True
              Title.Caption = #1056#1072#1073#1086#1090#1072
              Width = 160
            end
            item
              AlwaysShowEditButton = True
              DropDownBox.Options = [dlgColLinesEh, dlgRowLinesEh]
              DropDownRows = 10
              DropDownSizing = True
              EditButtons = <>
              FieldName = 'Contractor'
              Footers = <>
              Title.Caption = #1057#1091#1073#1087#1086#1076#1088#1103#1076#1095#1080#1082
              Width = 114
              OnEditButtonDown = dgContrColumnsContractorEditButtonDown
              OnGetCellParams = dgContrColumnsContractorGetCellParams
            end
            item
              EditButtons = <>
              FieldName = 'ContractorPercent'
              Footers = <>
              Title.Caption = #1053#1072#1094#1077#1085#1082#1072', %'
            end
            item
              EditButtons = <>
              FieldName = 'ContractorCost'
              Footers = <>
              ReadOnly = True
              Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100'|'#1056#1072#1089#1095#1077#1090#1085#1072#1103
              Width = 75
            end
            item
              Alignment = taRightJustify
              EditButtons = <>
              FieldName = 'FinalProfitCost'
              Footers = <>
              ReadOnly = True
              Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100'|'#1044#1083#1103' '#1079#1072#1082#1072#1079#1095#1080#1082#1072
              Width = 81
              OnGetCellParams = dgContrColumnsFinalProfitCostGetCellParams
            end
            item
              Alignment = taRightJustify
              EditButtons = <>
              FieldName = 'ContractorCostNative'
              Footers = <>
              ReadOnly = True
              Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100'|'#1044#1083#1103' '#1079#1072#1082#1072#1079#1095#1080#1082#1072', '#1075#1088#1085
              Width = 81
              OnGetCellParams = dgContrContractorCostNativeGetCellParams
            end
            item
              EditButtons = <>
              FieldName = 'FactContractorCost'
              Footers = <>
              Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100'|'#1060#1072#1082#1090#1080#1095#1077#1089#1082#1072#1103', '#1075#1088#1085
              Width = 79
              OnGetCellParams = dgContrColumnsFactContractorCostGetCellParams
            end
            item
              EditButtons = <>
              FieldName = 'PlanStartDate'
              Footers = <>
              Title.Caption = #1044#1072#1090#1072' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1074' '#1088#1072#1073#1086#1090#1091'|'#1055#1083#1072#1085#1086#1074#1072#1103
              OnUpdateData = dgContrColumnsPlanStartDateUpdateData
            end
            item
              AlwaysShowEditButton = True
              EditButtons = <>
              FieldName = 'FactStartDate'
              Footers = <>
              Title.Caption = #1044#1072#1090#1072' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1074' '#1088#1072#1073#1086#1090#1091'|'#1060#1072#1082#1090#1080#1095#1077#1089#1082#1072#1103
              Width = 77
              OnUpdateData = dgContrColumnsFactStartDateUpdateData
            end
            item
              AlwaysShowEditButton = True
              EditButtons = <>
              FieldName = 'PlanFinishDate'
              Footers = <>
              Title.Caption = #1044#1072#1090#1072' '#1087#1086#1083#1091#1095#1077#1085#1080#1103'|'#1055#1083#1072#1085#1086#1074#1072#1103
              Width = 60
              OnUpdateData = dgContrColumnsPlanFinishDateUpdateData
            end
            item
              AlwaysShowEditButton = True
              EditButtons = <>
              FieldName = 'FactFinishDate'
              Footers = <>
              Title.Caption = #1044#1072#1090#1072' '#1087#1086#1083#1091#1095#1077#1085#1080#1103'|'#1060#1072#1082#1090#1080#1095#1077#1089#1082#1072#1103
              Width = 74
              OnUpdateData = dgContrColumnsFactFinishDateUpdateData
            end
            item
              AlwaysShowEditButton = True
              EditButtons = <>
              FieldName = 'ContractorPayDate'
              Footers = <>
              Title.Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
              Width = 74
              OnUpdateData = dgContrColumnsPayDateUpdateData
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
        object paContrBottom: TPanel
          Left = 0
          Top = 0
          Width = 443
          Height = 33
          Align = alTop
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 1
          object btMakeOwn: TBitBtn
            Left = 0
            Top = 2
            Width = 121
            Height = 25
            Caption = #1057#1074#1086#1103' '#1088#1072#1073#1086#1090#1072
            TabOrder = 0
            OnClick = btMakeOwnClick
            Glyph.Data = {
              36060000424D3606000000000000360000002800000020000000100000000100
              18000000000000060000120B0000120B00000000000000000000FF00FFFF00FF
              FF00FFFF00FFFF00FF8684838684837B7B7AFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA1A1A1AFAFAFAF
              AFAFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FF868483ABAAAAE5E5E5C5C5C48684838684836E6D6CFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA3A3A3BCBCBCEBEBEBD1
              D1D1AFAFAFAFAFAFAFAFAFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FF868483B4B4B4FFFFFFF8F8F8E7E7E7EEE7E3749EB5074D7D2858756572
              76868483FF00FFFF00FFFF00FFFF00FFFF00FFA9A9A9C4C4C4FFFFFFFAFAFAED
              EDEDEEEEEEA9A9A9A2A2A2B5B5B59A9A9AAFAFAFFF00FFFF00FFFF00FFFF00FF
              868483C4C2C2FFFFFFFFFFFFFAFAFAEBEBEBF4EDE978A3BA0047800045806E98
              ACB7B2B08684835E5E5DFF00FFFF00FFABABABD0D0D0FFFFFFFFFFFFFBFBFBF0
              F0F0F2F2F2ADADAD9B9B9B9B9B9BA3A3A3C4C4C4AFAFAF8B8B8BFF00FF868483
              D7D7D7FFFFFFFFFFFFFFFFFFFCFCFCF3F3F3FCF4F07EA9C000488000467F789E
              B1D0CCCAB2B2B25C5C5BFF00FFAFAFAFE0E0E0FFFFFFFFFFFFFFFFFFFDFDFDF6
              F6F6F8F8F8B2B2B29B9B9B9A9A9AA9A9A9D8D8D8C3C3C3898989FF00FF868483
              FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBFFFEFA82ADC500488000457F7DA3
              B7D4D0CFB4B4B25C5C5BFF00FFAFAFAFFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFC
              FCFCFDFDFDB6B6B69B9B9B9A9A9AAEAEAEDCDCDCC3C3C3898989FF00FF868483
              FFFEFCFFFFFFA0B8C76790ABC4D4DEFFFFFFFFFFFF7FADC6003F790040797FA7
              BBDDD9D8B8BABA5F5C5AFF00FFAFAFAFFEFEFEFFFFFFBFBFBFAAAAAAD9D9D9FF
              FFFFFFFFFFB5B5B5989898989898B0B0B0E3E3E3C8C8C8898989FF00FF868483
              E6E9EB507F9C005C90005C950D547FBCCED9FFFFFFD8E6EE7BAAC53A7DA498B7
              C7E2E0DECBC4C03B515CFF00FFAFAFAFECECECC1C1C19393939696969C9C9CD2
              D2D2FFFFFFE9E9E9C6C6C6989898C0C0C0E7E7E7D4D4D4898989FF00FF868483
              1859820078B200BAFB00ACED00689F0D517DBDCED9FFFFFFFFFFFFF7F6F4E9EA
              EAEEEAE9C2C1C2174663FF00FFAFAFAFA5A5A59F9F9FB5B5B5B2B2B29E9E9E9B
              9B9BD3D3D3FFFFFFFFFFFFF8F8F8EEEEEEF0F0F0CFCFCF989898FF00FF095E8A
              009FE000C4FF00BAFB00B4F400A3E200659C0D4F78BCCED9FFFFFFFCFCFCFFFF
              FBB5C2CC1C5A80004E80FF00FF9B9B9BACACACB7B7B7B4B4B4B3B3B3AFAFAF9C
              9C9C989898D2D2D2FFFFFFFDFDFDFFFFFFCBCBCB9393938F8F8FFF00FF01679D
              00CAFF00BDFF00BAFB00B0F000ABEB009CDA00639A0D4F79C0D0DAFFFFFF81A1
              B6044570005589FF00FFFF00FFA0A0A0B8B8B8B5B5B5B4B4B4B2B2B2B1B1B1AE
              AEAE9B9B9B999999D5D5D5FFFFFFA8A8A88B8B8B959595FF00FFFF00FF01679D
              00ABEA00C2FF00BAFB00B1F200A9E900A0E10093D000639913557E416F8F0043
              72005E92FF00FFFF00FFFF00FFA0A0A0B0B0B0B6B6B6B4B4B4B2B2B2B0B0B0AF
              AFAFACACAC9C9C9C9F9F9FB0B0B08787879A9A9AFF00FFFF00FFFF00FFFF00FF
              01679D00B2F200BDFE00B1F200A9E70EB0E935CCF7008CCA00659A00497A015F
              93FF00FFFF00FFFF00FFFF00FFFF00FF9F9F9FB3B3B3B4B4B4B2B2B2B1B1B1B9
              B9B9CECECEABABAB9C9C9C8D8D8D9B9B9BFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FF01679D00AFEF00B4F602AAE702AAE735CCF7009FE001679DFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA3A3A3B1B1B1B3B3B3B2B2B2CD
              CDCDCECECEACACACA1A1A1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FF01679D00A9EA01ADEE01679D04A4D50089C401679DFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA2A2A2B0B0B0B4B4B4A2
              A2A2ADADADA8A8A8A2A2A2FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FF01679D01679DFF00FF01679D01679DFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA2A2A2A2A2A2FF
              00FFA2A2A2A2A2A2FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
            Margin = 8
            NumGlyphs = 2
            Spacing = 8
          end
        end
        object paContrWorkMat: TPanel
          Left = 0
          Top = 224
          Width = 443
          Height = 30
          Align = alBottom
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 2
          object Label3: TLabel
            Left = 6
            Top = 10
            Width = 40
            Height = 13
            Caption = #1056#1072#1073#1086#1090#1072':'
          end
          object Label4: TLabel
            Left = 186
            Top = 10
            Width = 62
            Height = 13
            Caption = #1052#1072#1090#1077#1088#1080#1072#1083#1099':'
          end
          object Panel3: TPanel
            Left = 56
            Top = 6
            Width = 113
            Height = 21
            BevelOuter = bvLowered
            Caption = ' '
            Color = clCream
            TabOrder = 0
            object dtContrWorkCost: TDBText
              Left = 11
              Top = 4
              Width = 98
              Height = 13
              Alignment = taRightJustify
              AutoSize = True
              DataField = 'EnabledWorkCost'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
          end
          object Panel4: TPanel
            Left = 254
            Top = 6
            Width = 113
            Height = 21
            BevelOuter = bvLowered
            Caption = ' '
            Color = clCream
            TabOrder = 1
            object dtContrMatCost: TDBText
              Left = 19
              Top = 4
              Width = 90
              Height = 13
              Alignment = taRightJustify
              AutoSize = True
              DataField = 'EnabledMatCost'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
          end
        end
      end
      object tsFinance: TTabSheet
        Caption = #1054#1087#1083#1072#1090#1072
        ImageIndex = 4
      end
      object tsShipment: TTabSheet
        Caption = #1054#1090#1075#1088#1091#1079#1082#1072
        ImageIndex = 5
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 443
          Height = 33
          Align = alTop
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 0
          object btEditShipment: TBitBtn
            Left = 102
            Top = 2
            Width = 95
            Height = 25
            Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
            TabOrder = 0
            OnClick = btEditShipmentClick
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
            Spacing = 5
          end
          object btDeleteShipment: TBitBtn
            Left = 204
            Top = 2
            Width = 75
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100
            TabOrder = 1
            OnClick = btDeleteShipmentClick
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
            Spacing = 5
          end
          object btAddShipment: TBitBtn
            Left = 0
            Top = 2
            Width = 95
            Height = 25
            Caption = #1044#1086#1073#1072#1074#1080#1090#1100'...'
            TabOrder = 2
            OnClick = btAddShipmentClick
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
            Spacing = 5
          end
          object btApproveShipment: TBitBtn
            Left = 9
            Top = 2
            Width = 147
            Height = 25
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1086#1090#1075#1088#1091#1079#1082#1091
            TabOrder = 3
            OnClick = btApproveShipmentClick
            Glyph.Data = {
              32060000424D3206000000000000420000002800000028000000130000000100
              100003000000F0050000120B0000120B00000000000000000000007C0000E003
              00001F0000001F7C1F7C1F7C1F7C1F7C1F7C903E4D2E85018501850185014D2E
              903E1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1863D65A524A
              524A524A524A734E39671F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CC811
              8501E605861EC62E273B4643C636862AC50D85014E361F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C734E524A734EB556D65AF75EF75ED65AB556734E524AD65A1F7C
              1F7C1F7C1F7C1F7C1F7C1F7CA6098501C71E081BE90AEA16E9260A2F09332837
              4743A62E85050B221F7C1F7C1F7C1F7C1F7C1F7C734E524AD65AD65AB556D65A
              F75EF75EF75EF75EF75EB556524AB5561F7C1F7C1F7C1F7C1F7CC70DC6052A2F
              CA06CA02C902EA12E926092F092F092F092F283BE63A85052D2E1F7C1F7C1F7C
              1F7C734E524A1863945294529452D65AF75EF75EF75EF75EF75EF75ED65A524A
              D65A1F7C1F7C1F7C4D2E8501EC1ACA06CA026602E511A80AEA1EE92A092F092F
              092F0A2F283BC636850192461F7C1F7CD65A524AD65AB5569452734E734EB556
              D65AF75EF75EF75EF75EF75EF75ED65A524A18631F7C1F7C85016A1A0C1BCA06
              4602D34E7B6B4A26A80EE922E92A092F092F092FEA2A27370516E9191F7C1F7C
              524AB556D65AB556734E39679C73B556B556D65AF75EF75EF75EF75EF75EF75E
              945294521F7C903E8401313B0C1F670ED34E9C737C6F9C736C2EA70EEA1EE922
              E926E922EA1EE91AE62EA601134AF75E524A3967D65A94525A6BBD77BD77BD77
              D65AB556D65AD65AF75EF75ED65AD65AD65A524AD9662B1E2912523BCC1E1453
              BD779D73BD779D73BD776D32A70AEA0EE912E912C90ACA062727CA02C709B556
              94523967D65A5A6BDE7BBD77DE7BBD77DE7BF75E9452B556B556B556B5569452
              F75E9452734E2A1AAD26523B323FDE7BDE7BDE7BBC6FDE7BDE7BDE7B8D326602
              CA02CA02CA02CA02E81EE81EE6059452D65A39673967FF7FFF7FFF7FBD77FF7F
              FF7FFF7FF75E94529452945294529452D65AD65A734E4A1AD032533F30337653
              FF7F5447C90E985BFF7FFF7FFF7F8D366602CA02CA02CA02E81AE81E4712B556
              F75E396718637B6FFF7F5A6BB5569C73FF7FFF7FFF7FF75E734E945294529452
              D65AD65A94526B1ACF2E754F323B323B5343323B3137C90E9857FF7FFF7FFF7F
              8D364602CA02C9020B27E81E670AB556F75E7B6F396718635A6B39671863B556
              7B6FFF7FFF7FFF7FF75E734E94529452F75ED65A734EAC1EAC1A9857533F533F
              533F533F533F54430E23BA63FF7FFF7FFF7F1453880E31337353CA028802D65A
              B5567B6F39673967396739675A6B5A6BF75EBD77FF7FFF7FFF7F5A6B94521863
              7B6F9452B556F13A8702995F5443544354435443544354435443533FBB6BFF7F
              FF7FFF7F995F54432F3B8802D13A186394529C735A6B5A6B5A6B5A6B5A6B5A6B
              5A6B3967BD77FF7FFF7FFF7F9C735A6B186394521F7C1F7CA9061033995F533F
              544354435443544354435443533FBB67FF7FBB6B533F7453A90EAD221F7C1F7C
              945218639C735A6B5A6B5A6B5A6B5A6B5A6B5A6B3967BD77FF7FBD7739677B6F
              B556D65A1F7C1F7CF036870277579857533F544354435443544354435443533F
              7753533F754BED268802165B1F7C1F7C186394527B6F7B6F5A6B5A6B5A6B5A6B
              5A6B5A6B5A6B39677B6F39675A6BF75E94521F7C1F7C1F7C1F7CAB12880A9857
              985B5443544354435443544354435443533F764F323B8802D23E1F7C1F7C1F7C
              1F7CB55694527B6F9C735A6B5A6B5A6B5A6B5A6B5A6B5A6B5A6B7B6F39679452
              18631F7C1F7C1F7C1F7C1F7CAB128806323BBA639757754B5443544375477653
              9757ED228802CF2A1F7C1F7C1F7C1F7C1F7C1F7CB55694523967BD777B6F5A6B
              5A6B5A6B5A6B7B6F7B6FD65A9452F75E1F7C1F7C1F7C1F7C1F7C1F7C1F7CCF2E
              8802A90E102F5547764F7653323BEE2687028906144F1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7CF75E9452B55618635A6B7B6F7B6F3967F75E945294525A6B1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CCF2EA90A8802880288028802AB1A
              F13E1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CF75EB5569452
              945294529452B55618631F7C1F7C1F7C1F7C1F7C1F7C}
            NumGlyphs = 2
            Spacing = 5
          end
        end
        object dgShipment: TMyDBGridEh
          Left = 0
          Top = 33
          Width = 443
          Height = 221
          Align = alClient
          AllowedOperations = []
          AllowedSelections = [gstAll, gstNon]
          AutoFitColWidths = True
          DataGrouping.GroupLevels = <>
          Flat = True
          FooterColor = clInfoBk
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'Tahoma'
          FooterFont.Style = []
          FooterRowCount = 1
          FrozenCols = 1
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
          ReadOnly = True
          RowDetailPanel.Color = clBtnFace
          RowHeight = 16
          SumList.Active = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          UseMultiTitle = True
          VTitleMargin = 3
          OnDblClick = btEditShipmentClick
          Columns = <
            item
              EditButtons = <>
              FieldName = 'ShipmentDate'
              Footer.FieldName = 'DateOut'
              Footer.Value = #1042#1089#1077#1075#1086
              Footer.ValueType = fvtStaticText
              Footers = <>
              Title.Caption = #1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080
              Width = 81
            end
            item
              EditButtons = <>
              FieldName = 'Quantity'
              Footer.DisplayFormat = '#'
              Footer.FieldName = 'Quantity'
              Footer.Font.Charset = DEFAULT_CHARSET
              Footer.Font.Color = clWindowText
              Footer.Font.Height = -11
              Footer.Font.Name = 'Tahoma'
              Footer.Font.Style = [fsBold]
              Footer.ValueType = fvtSum
              Footers = <>
              Title.Caption = #1050#1086#1083'-'#1074#1086
              Width = 61
            end
            item
              EditButtons = <>
              FieldName = 'ItemText'
              Footers = <>
              Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Width = 133
            end
            item
              EditButtons = <>
              FieldName = 'WhoOut'
              Footers = <>
              Title.Caption = #1042#1099#1076#1072#1083
              Width = 86
            end
            item
              EditButtons = <>
              FieldName = 'WhoIn'
              Footers = <>
              Title.Caption = #1055#1088#1080#1085#1103#1083
              Width = 97
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
      object tsExecState: TTabSheet
        Caption = #1042#1099#1087#1086#1083#1085#1077#1085#1080#1077
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object dgExecState: TMyDBGridEh
          Left = 0
          Top = 0
          Width = 443
          Height = 254
          Align = alClient
          AllowedOperations = []
          AllowedSelections = [gstRecordBookmarks]
          AutoFitColWidths = True
          Ctl3D = True
          DataGrouping.GroupLevels = <>
          DrawMemoText = True
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
          Options = [dgTitles, dgColumnResize, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete]
          OptionsEh = [dghFixed3D, dghResizeWholeRightPart, dghHighlightFocus, dghClearSelection, dghEnterAsTab, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
          ParentCtl3D = False
          ParentFont = False
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
          VTitleMargin = 5
          OnGetCellParams = dgExecStateGetCellParams
          OnGetFooterParams = dgExecStateGetFooterParams
          Columns = <
            item
              AutoFitColWidth = False
              DblClickNextVal = True
              EditButtons = <>
              FieldName = 'ExecState'
              Footers = <>
              ImageList = imExecState
              NotInKeyListIndex = 0
              Title.Caption = ' '
              Width = 16
              OnGetCellParams = dgExecStateColumnsExecStateGetCellParams
            end
            item
              EditButtons = <>
              EndEllipsis = True
              FieldName = 'ItemDesc'
              Footers = <>
              ReadOnly = True
              Title.Caption = #1055#1088#1086#1094#1077#1089#1089
              Width = 157
            end
            item
              EditButtons = <>
              FieldName = 'ProductOut'
              Footers = <>
              Title.Caption = #1050#1086#1083'-'#1074#1086' '#1074#1099#1093'.'
              Width = 51
            end
            item
              Alignment = taCenter
              EditButtons = <>
              FieldName = 'PlanStartDate'
              Footers = <>
              Title.Caption = #1055#1083#1072#1085#1086#1074#1086#1077' '#1074#1088#1077#1084#1103
              Width = 147
              OnGetCellParams = dgExecStateColumnsPlanGetCellParams
            end
            item
              Alignment = taCenter
              EditButtons = <>
              FieldName = 'FactStartDate'
              Footers = <>
              Title.Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1086#1077' '#1074#1088#1077#1084#1103
              Width = 143
              OnGetCellParams = dgExecStateColumnsFactGetCellParams
            end
            item
              Alignment = taCenter
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'EstimatedDuration'
              Footer.FieldName = 'EstimatedDuration'
              Footer.ValueType = fvtSum
              Footers = <>
              Title.Caption = #1056#1072#1089#1095#1077#1090#1085#1086#1077' '#1074#1088#1077#1084#1103
              Width = 60
              OnGetCellParams = dgExecStateEstimatedDurationGetCellParams
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
      object tsStoreSipment: TTabSheet
        Caption = #1054#1090#1075#1088#1091#1079#1082#1072' '#1085#1072' '#1089#1082#1083#1072#1076
        ImageIndex = 6
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object dgProductToStore: TMyDBGridEh
          Left = 0
          Top = 33
          Width = 443
          Height = 221
          Align = alClient
          AllowedOperations = []
          AllowedSelections = [gstAll, gstNon]
          AutoFitColWidths = True
          DataGrouping.GroupLevels = <>
          Flat = True
          FooterColor = clInfoBk
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'Tahoma'
          FooterFont.Style = []
          FrozenCols = 1
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
          ReadOnly = True
          RowDetailPanel.Color = clBtnFace
          RowHeight = 16
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          UseMultiTitle = True
          VTitleMargin = 3
          Columns = <
            item
              EditButtons = <>
              FieldName = 'dateToStorage'
              Footers = <>
              Title.Caption = #1044#1072#1090#1072
            end
            item
              EditButtons = <>
              FieldName = 'Name'
              Footer.FieldName = 'DateOut'
              Footers = <>
              Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Width = 120
            end
            item
              EditButtons = <>
              FieldName = 'RCount'
              Footer.Font.Charset = DEFAULT_CHARSET
              Footer.Font.Color = clWindowText
              Footer.Font.Height = -11
              Footer.Font.Name = 'Tahoma'
              Footer.Font.Style = [fsBold]
              Footers = <>
              Title.Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1088#1091#1082#1072#1074#1077
              Width = 50
            end
            item
              EditButtons = <>
              FieldName = 'BCount'
              Footers = <>
              Title.Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1103#1097#1080#1082#1077
              Width = 50
            end
            item
              EditButtons = <>
              FieldName = 'BSize'
              Footers = <>
              Title.Caption = #1056#1072#1079#1084#1077#1088' '#1103#1097#1080#1082#1072
              Width = 68
            end
            item
              EditButtons = <>
              FieldName = 'NProduct'
              Footers = <>
              ReadOnly = False
              Title.Caption = #1050#1086#1083'-'#1074#1086
              Width = 60
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
        object Panel6: TPanel
          Left = 0
          Top = 0
          Width = 443
          Height = 33
          Align = alTop
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 1
          object btnDeleteFromStorage: TBitBtn
            Left = 202
            Top = 2
            Width = 75
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100
            TabOrder = 0
            OnClick = btnDeleteFromStorageClick
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
            Spacing = 5
          end
          object btnAddToStorage: TBitBtn
            Left = 0
            Top = 2
            Width = 95
            Height = 25
            Caption = #1044#1086#1073#1072#1074#1080#1090#1100'...'
            TabOrder = 1
            OnClick = btnAddToStorageClick
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
            Spacing = 5
          end
          object btnEditToStorage: TBitBtn
            Left = 101
            Top = 2
            Width = 95
            Height = 25
            Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
            TabOrder = 2
            OnClick = btnEditToStorageClick
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
            Spacing = 5
          end
        end
      end
    end
  end
  object imExecState: TImageList
    Left = 376
    Top = 44
  end
  object PopupMenu1: TPopupMenu
    Left = 332
    Top = 48
  end
end
