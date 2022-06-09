object frDimDic: TfrDimDic
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  TabOrder = 0
  object dgDic: TMyDBGridEh
    Left = 0
    Top = 0
    Width = 451
    Height = 149
    Align = alTop
    AllowedSelections = [gstRecordBookmarks]
    DataSource = dsDic
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    FrozenCols = 1
    OptionsEh = [dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind]
    RowHeight = 16
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Color = clMenu
        EditButtons = <>
        FieldName = 'Code'
        Footers = <>
        Title.Caption = '#'
        Width = 24
      end
      item
        Color = clInfoBk
        EditButtons = <>
        FieldName = 'Name'
        Footers = <>
        Title.Caption = #1048#1084#1103
        Width = 133
      end
      item
        EditButtons = <>
        FieldName = 'A1'
        Footers = <>
        Title.Caption = #1042#1085#1091#1090#1088#1077#1085#1085#1077#1077' '#1080#1084#1103
        Width = 100
      end>
  end
  object dgDimDic: TMyDBGridEh
    Left = 0
    Top = 152
    Width = 451
    Height = 112
    Align = alClient
    AllowedSelections = [gstRecordBookmarks]
    DataSource = dsDimDic
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    FrozenCols = 1
    OptionsEh = [dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind]
    RowHeight = 16
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnGetCellParams = dgDimDicGetCellParams
    Columns = <
      item
        Color = clMenu
        EditButtons = <>
        FieldName = 'Code'
        Footers = <>
        Title.Caption = '#'
        Width = 24
      end
      item
        Color = clInfoBk
        EditButtons = <>
        FieldName = 'Name'
        Footers = <>
        Title.Caption = #1048#1084#1103
        Width = 133
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
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 264
    Width = 451
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 2
    object sbValues: TSpeedButton
      Left = 88
      Top = 7
      Width = 89
      Height = 25
      Caption = #1047#1085#1072#1095#1077#1085#1080#1103'...'
      OnClick = sbValuesClick
    end
    object btAdd: TSpeedButton
      Left = 182
      Top = 7
      Width = 85
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777777777777777777777777777777777777000777777777777700077
        7777777777700077777777770000000007777777000000000777777700000000
        0777777777700077777777777770007777777777777000777777777777777777
        7777777777777777777777777777777777777777777777777777}
      OnClick = btAddClick
    end
    object sbDelValue: TSpeedButton
      Left = 274
      Top = 7
      Width = 81
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
    object DBCheckBox1: TDBCheckBox
      Left = 8
      Top = 11
      Width = 77
      Height = 17
      Caption = #1040#1082#1090#1080#1074#1077#1085
      DataField = 'Visible'
      DataSource = dsDimDic
      TabOrder = 0
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
  end
  object JvxSplitter1: TJvxSplitter
    Left = 0
    Top = 149
    Width = 451
    Height = 3
    ControlFirst = dgDic
    Align = alTop
    BevelOuter = bvNone
    Color = clBtnShadow
  end
  object dsDic: TDataSource
    Left = 240
    Top = 64
  end
  object dsDimDic: TDataSource
    Left = 272
    Top = 64
  end
end
