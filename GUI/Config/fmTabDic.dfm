object frTabDic: TfrTabDic
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 304
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    object dgDic: TMyDBGridEh
      Left = 0
      Top = 0
      Width = 621
      Height = 263
      Align = alClient
      AllowedSelections = [gstNon]
      DataGrouping.GroupLevels = <>
      DataSource = dsDic
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'Tahoma'
      FooterFont.Style = []
      FrozenCols = 1
      Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
      RowDetailPanel.Color = clBtnFace
      RowHeight = 16
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnCellClick = dgDicCellClick
      OnContextPopup = dgDicContextPopup
      OnDrawColumnCell = dgDicDrawColumnCell
      OnGetCellParams = dgDicGetCellParams
      Columns = <
        item
          EditButtons = <>
          FieldName = 'Visible'
          Footers = <>
          MinWidth = 17
          ReadOnly = True
          Title.Caption = ' '
          Width = 17
        end
        item
          Color = clMenu
          EditButtons = <>
          FieldName = 'Code'
          Footers = <>
          Title.Caption = #1050#1086#1076
          Width = 26
        end
        item
          Color = clInfoBk
          EditButtons = <>
          FieldName = 'Name'
          Footers = <>
          Title.Caption = #1048#1084#1103
          Width = 114
        end
        item
          EditButtons = <>
          FieldName = 'A1'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A2'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A3'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A4'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A5'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A6'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A7'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A8'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A9'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A10'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A11'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A12'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A13'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A14'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A15'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A16'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A17'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A18'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A19'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A20'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A21'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A22'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A23'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A24'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A25'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A26'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A27'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A28'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A29'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A30'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'A31'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 263
      Width = 621
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 1
      ExplicitWidth = 451
      object DBCheckBox1: TDBCheckBox
        Left = 12
        Top = 12
        Width = 93
        Height = 17
        Caption = #1050#1086#1076' '#1072#1082#1090#1080#1074#1077#1085
        DataField = 'Visible'
        DataSource = dsDic
        TabOrder = 0
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        Visible = False
      end
      object Panel3: TPanel
        Left = 212
        Top = 0
        Width = 409
        Height = 41
        Align = alRight
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 1
        object sbDelValue: TSpeedButton
          Left = 318
          Top = 8
          Width = 83
          Height = 25
          Caption = #1059#1076#1072#1083#1080#1090#1100
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000120B0000120B00001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777777777777777777777777777777777777777777777777777777777777
            7777777777777777777777700000000007777770000000000777777000000000
            0777777777777777777777777777777777777777777777777777777777777777
            7777777777777777777777777777777777777777777777777777}
          OnClick = sbDelValueClick
        end
        object sbNewSubValue: TSpeedButton
          Left = 89
          Top = 8
          Width = 104
          Height = 25
          Caption = #1059#1088#1086#1074#1077#1085#1100' '#1085#1080#1078#1077
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000120B0000120B00001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777777777777777777777777777777777777777000777777777777700077
            7777777777700077777777770000000007777777000000000777777700000000
            0777777777700077777777777770007777777777777000777777777777777777
            7777777777777777777777777777777777777777777777777777}
          OnClick = sbNewSubValueClick
        end
        object sbNewValue: TSpeedButton
          Left = 2
          Top = 8
          Width = 79
          Height = 25
          Caption = #1057#1090#1088#1086#1082#1072
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000120B0000120B00001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777777777777777777777777777777777777777000777777777777700077
            7777777777700077777777770000000007777777000000000777777700000000
            0777777777700077777777777770007777777777777000777777777777777777
            7777777777777777777777777777777777777777777777777777}
          OnClick = sbNewValueClick
        end
        object sbNewUpValue: TSpeedButton
          Left = 202
          Top = 8
          Width = 107
          Height = 25
          Caption = #1059#1088#1086#1074#1077#1085#1100' '#1074#1099#1096#1077
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000120B0000120B00001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777777777777777777777777777777777777777000777777777777700077
            7777777777700077777777770000000007777777000000000777777700000000
            0777777777700077777777777770007777777777777000777777777777777777
            7777777777777777777777777777777777777777777777777777}
          OnClick = sbNewUpValueClick
        end
      end
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '*.bmp'
    Filter = #1060#1072#1081#1083#1099' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1081' (*.bmp)|*.bmp|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Left = 148
    Top = 152
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '*.bmp'
    Filter = #1060#1072#1081#1083#1099' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1081' (*.bmp)|*.bmp|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Left = 104
    Top = 152
  end
  object pmGraphic: TPopupMenu
    Left = 72
    Top = 160
    object miOpenBmp: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077'...'
      OnClick = miOpenBmpClick
    end
    object miSaveBmp: TMenuItem
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077'...'
      OnClick = miSaveBmpClick
    end
    object miClearBmp: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      OnClick = miClearBmpClick
    end
  end
  object dsDic: TDataSource
    Left = 160
    Top = 112
  end
end
