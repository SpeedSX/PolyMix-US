inherited frTabSrv: TfrTabSrv
  object paBot: TPanel
    Left = 0
    Top = 256
    Width = 451
    Height = 48
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object sbAdd: TBitBtn
      Tag = 1
      Left = 4
      Top = 13
      Width = 95
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777777777777777777777777777777777777000777777777777700077
        7777777777700077777777770000000007777777000000000777777700000000
        0777777777700077777777777770007777777777777000777777777777777777
        7777777777777777777777777777777777777777777777777777}
      Spacing = 5
    end
    object sbDel: TBitBtn
      Tag = 2
      Left = 100
      Top = 13
      Width = 87
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 2
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777777777777777777777777777777777777777777777777777777777
        7777777777777777777777700000000007777770000000000777777000000000
        0777777777777777777777777777777777777777777777777777777777777777
        7777777777777777777777777777777777777777777777777777}
      Spacing = 5
    end
    object sbClear: TBitBtn
      Tag = 3
      Left = 188
      Top = 13
      Width = 89
      Height = 25
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 3
      Visible = False
      Glyph.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000333333333333300033003333300330003300033300033000333000300033
        3000333300000333300033333000333330003333000003333000333000300033
        3000330003330003300033003333300330003333333333333000333333333333
        3000}
    end
    object paItogoL: TPanel
      Left = 116
      Top = 0
      Width = 335
      Height = 48
      Align = alRight
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 0
      object lbWorkTotal: TLabel
        Left = 4
        Top = 4
        Width = 36
        Height = 13
        Caption = #1056#1072#1073#1086#1090#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lbMatTotal: TLabel
        Left = 112
        Top = 4
        Width = 58
        Height = 13
        Caption = #1052#1072#1090#1077#1088#1080#1072#1083#1099
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lbItogo: TLabel
        Left = 228
        Top = 4
        Width = 35
        Height = 13
        Caption = #1048#1090#1086#1075#1086
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object paWorkTotal: TPanel
        Left = 4
        Top = 22
        Width = 100
        Height = 21
        Alignment = taRightJustify
        BevelOuter = bvLowered
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object paMatTotal: TPanel
        Left = 112
        Top = 22
        Width = 100
        Height = 21
        Alignment = taRightJustify
        BevelOuter = bvLowered
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object paItogo: TPanel
        Left = 228
        Top = 22
        Width = 100
        Height = 21
        Alignment = taRightJustify
        BevelOuter = bvLowered
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
      end
    end
  end
  object dgCommon: TMyDBGridEh
    Left = 0
    Top = 21
    Width = 451
    Height = 235
    Align = alClient
    AllowedSelections = []
    ColumnDefValues.Layout = tlCenter
    DataGrouping.GroupLevels = <>
    Flat = True
    FooterColor = clBtnFace
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
    ParentColor = True
    RowDetailPanel.Color = clBtnFace
    RowHeight = 17
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    TitleHeight = 16
    UseMultiTitle = True
    VTitleMargin = 5
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object paTop: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 21
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 2
    object lbSrvName: TJvGradientHeaderPanel
      Left = 0
      Top = 0
      Width = 451
      Height = 21
      GradientStartColor = clBtnFace
      GradientSteps = 20
      GradientStyle = grVertical
      LabelTop = 2
      LabelCaption = #1048#1084#1103' '#1087#1088#1086#1094#1077#1089#1089#1072
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clBlack
      LabelFont.Height = -13
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = [fsBold]
      LabelAlignment = taLeftJustify
      Align = alClient
      DoubleBuffered = False
      TabOrder = 0
    end
  end
end
