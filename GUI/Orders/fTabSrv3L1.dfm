inherited frTabSrv3L1: TfrTabSrv3L1
  Width = 806
  Height = 420
  object paPrint1: TPanel
    Left = 0
    Top = 0
    Width = 806
    Height = 127
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    ExplicitWidth = 451
    object Panel45: TPanel
      Left = 0
      Top = 0
      Width = 806
      Height = 21
      Align = alTop
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 0
      ExplicitWidth = 451
      object lbSrvName1: TJvGradientHeaderPanel
        Left = 0
        Top = 0
        Width = 806
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
        ExplicitWidth = 451
      end
    end
    object dg1: TMyDBGridEh
      Left = 0
      Top = 21
      Width = 806
      Height = 106
      Align = alClient
      AllowedSelections = [gstRecordBookmarks]
      Color = clBtnFace
      DefaultDrawing = False
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
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
      ParentFont = False
      RowHeight = 17
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = [fsStrikeOut]
      UseMultiTitle = True
      VTitleMargin = 4
    end
  end
  object splPrint1: TJvxSplitter
    Left = 0
    Top = 127
    Width = 806
    Height = 3
    ControlFirst = paPrint1
    Align = alTop
    BevelOuter = bvNone
    Color = clBtnShadow
    ExplicitWidth = 451
  end
  object paPrint2: TPanel
    Left = 0
    Top = 130
    Width = 481
    Height = 252
    Align = alLeft
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 2
    ExplicitHeight = 136
    object Panel49: TPanel
      Left = 0
      Top = 0
      Width = 481
      Height = 21
      Align = alTop
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 0
      object lbSrvName2: TJvGradientHeaderPanel
        Left = 0
        Top = 0
        Width = 481
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
    object dg2: TMyDBGridEh
      Left = 0
      Top = 21
      Width = 481
      Height = 231
      Align = alClient
      AllowedSelections = [gstRecordBookmarks]
      Color = clBtnFace
      DefaultDrawing = False
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
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
      ParentFont = False
      RowHeight = 17
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = [fsStrikeOut]
      UseMultiTitle = True
      VTitleMargin = 4
    end
  end
  object Panel50: TPanel
    Left = 484
    Top = 130
    Width = 322
    Height = 252
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 3
    ExplicitWidth = 352
    ExplicitHeight = 136
    object dg3: TMyDBGridEh
      Left = 0
      Top = 21
      Width = 322
      Height = 231
      Align = alClient
      AllowedSelections = [gstRecordBookmarks]
      Color = clBtnFace
      DefaultDrawing = False
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
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
      ParentFont = False
      RowHeight = 17
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = [fsStrikeOut]
      UseMultiTitle = True
      VTitleMargin = 4
    end
    object Panel51: TPanel
      Left = 0
      Top = 0
      Width = 322
      Height = 21
      Align = alTop
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 1
      ExplicitWidth = 352
      object lbSrvName3: TJvGradientHeaderPanel
        Left = 0
        Top = 0
        Width = 322
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
        ExplicitWidth = 352
      end
    end
  end
  object splPrint2: TJvxSplitter
    Left = 481
    Top = 130
    Width = 3
    Height = 252
    ControlFirst = paPrint2
    Align = alLeft
    BevelOuter = bvNone
    Color = clBtnShadow
    ExplicitHeight = 136
  end
  object Panel1: TPanel
    Left = 0
    Top = 382
    Width = 806
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 5
    ExplicitTop = 266
    ExplicitWidth = 451
    object sbAdd1: TBitBtn
      Tag = 1
      Left = 12
      Top = 7
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
    object sbDel1: TBitBtn
      Tag = 2
      Left = 108
      Top = 7
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
    object sbClear1: TBitBtn
      Tag = 3
      Left = 196
      Top = 7
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
    object paBotLeft: TPanel
      Left = 632
      Top = 0
      Width = 174
      Height = 38
      Align = alRight
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 0
      object lbTotal: TLabel
        Left = 8
        Top = 13
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
      object paTotal: TPanel
        Left = 50
        Top = 9
        Width = 113
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
        TabOrder = 0
      end
    end
  end
end
