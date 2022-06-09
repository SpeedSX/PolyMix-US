object ExpenseForm: TExpenseForm
  Left = 388
  Top = 186
  BorderStyle = bsDialog
  Caption = #1059#1095#1077#1090' '#1088#1072#1089#1093#1086#1076#1086#1074
  ClientHeight = 458
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btNewComExp: TSpeedButton
    Left = 8
    Top = 428
    Width = 93
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    Glyph.Data = {
      42040000424D4204000000000000420000002800000020000000100000000100
      1000030000000004000000000000000000000000000000000000007C0000E003
      00001F0000000042004200420042004200420042004200420042004200420042
      0042004200420042004200420042FF7FFF7F0042004200420042004200420042
      0042FF7FFF7F004200420042007C007C00420042004200420042004200420042
      000000000000004200420042EF3DEF3DFF7F0042004200420042004200420042
      EF3DEF3DEF3D004200420042007C007C00420042004200420042004200420042
      00000000000000420042FF7FEF3DEF3DFF7FFF7FFF7F00420042004200420042
      EF3DEF3DEF3D0042007C007C007C007C007C007C004200420042004200420042
      0042004200420042EF3DEF3DEF3DEF3DEF3DEF3DFF7F00420042004200420042
      00420042FF7F0042007C007C007C007C007C007C004200420042004200420042
      0042000000000042EF3DEF3DEF3DEF3DEF3DEF3D004200420042004200420042
      0042EF3DEF3D004200420042007C007C00420042004200420042004200420042
      004200000000004200420042EF3DEF3DFF7F0042004200420042004200420042
      0042EF3DEF3D004200420042007C007C00420042004200420042004200420042
      004200420042004200420042EF3DEF3D00420042004200420042004200420042
      00420042FF7F0042004200420042004200420042004200420042004200420042
      00420000000000420042004200420042004200420042FF7F0042004200420042
      0042EF3DEF3D00420042004200420042004200421F0000420042004200420042
      0042000000000042004200420042004200420042EF3DFF7FFF7F004200420042
      0042EF3DEF3D00420042004200420042004200421F001F000042004200420042
      00420042004200420042FF7FFF7FFF7FFF7FFF7FEF3DEF3DFF7FFF7FFF7F0042
      FF7FFF7F004200421F001F001F001F001F001F001F001F001F001F000042007C
      007C004200420042EF3DEF3DEF3DEF3DEF3DEF3DEF3DEF3DEF3DEF3DFF7FEF3D
      EF3DFF7F004200421F001F001F001F001F001F001F001F001F001F000042007C
      007C004200420042EF3DEF3DEF3DEF3DEF3DEF3DEF3DEF3DEF3DEF3D0042EF3D
      EF3D0042004200420042004200420042004200421F001F000042004200420042
      0042004200420042004200420042004200420042EF3DEF3D0042004200420042
      0042FF7FFF7F00420042004200420042004200421F0000420042004200420042
      0000000000000042004200420042004200420042EF3D00420042004200420042
      EF3DEF3DEF3D0042004200420042004200420042004200420042004200420042
      0000000000000042004200420042004200420042004200420042004200420042
      EF3DEF3DEF3D0042004200420042004200420042004200420042004200420042
      0042004200420042004200420042004200420042004200420042004200420042
      004200420042}
    NumGlyphs = 2
    OnClick = btNewComExpClick
  end
  object btDelComExp: TSpeedButton
    Left = 108
    Top = 428
    Width = 91
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    Glyph.Data = {
      42040000424D4204000000000000420000002800000020000000100000000100
      1000030000000004000000000000000000000000000000000000007C0000E003
      00001F0000000042004200420042004200420042004200420042004200420042
      0042004200420042004200420042004200420042004200420042004200420042
      0042FF7FFF7F0042004200420042004200420042004200420042004200420042
      0000000000000042004200420042004200420042004200420042004200420042
      EF3DEF3DEF3D0042004200420042004200420042004200420042004200420042
      00000000000000420042FF7FFF7FFF7FFF7FFF7FFF7F00420042004200420042
      EF3DEF3DEF3D0042007C007C007C007C007C007C004200420042004200420042
      0042004200420042EF3DEF3DEF3DEF3DEF3DEF3DFF7F00420042004200420042
      00420042FF7F0042007C007C007C007C007C007C004200420042004200420042
      0042000000000042EF3DEF3DEF3DEF3DEF3DEF3D004200420042004200420042
      0042EF3DEF3D0042004200420042004200420042004200420042004200420042
      0042000000000042004200420042004200420042004200420042004200420042
      0042EF3DEF3D0042004200420042004200420042004200420042004200420042
      0042004200420042004200420042004200420042004200420042004200420042
      00420042FF7F0042004200420042004200420042004200420042004200420042
      00420000000000420042004200420042FF7F0042004200420042004200420042
      0042EF3DEF3D00420042004200421F0000420042004200420042004200420042
      0042000000000042004200420042EF3DFF7F0042004200420042004200420042
      0042EF3DEF3D0042004200421F001F0000420042004200420042004200420042
      00420042004200420042FF7FEF3DEF3DFF7FFF7FFF7FFF7FFF7FFF7FFF7F0042
      FF7FFF7F004200421F001F001F001F001F001F001F001F001F001F000042007C
      007C004200420042EF3DEF3DEF3DEF3DEF3DEF3DEF3DEF3DEF3DEF3DFF7FEF3D
      EF3DFF7F004200421F001F001F001F001F001F001F001F001F001F000042007C
      007C004200420042EF3DEF3DEF3DEF3DEF3DEF3DEF3DEF3DEF3DEF3D0042EF3D
      EF3D004200420042004200421F001F0000420042004200420042004200420042
      004200420042004200420042EF3DEF3DFF7F0042004200420042004200420042
      0042FF7FFF7F00420042004200421F0000420042004200420042004200420042
      0000000000000042004200420042EF3D00420042004200420042004200420042
      EF3DEF3DEF3D0042004200420042004200420042004200420042004200420042
      0000000000000042004200420042004200420042004200420042004200420042
      EF3DEF3DEF3D0042004200420042004200420042004200420042004200420042
      0042004200420042004200420042004200420042004200420042004200420042
      004200420042}
    NumGlyphs = 2
    OnClick = btDelComExpClick
  end
  object btToUSD: TSpeedButton
    Left = 204
    Top = 428
    Width = 131
    Height = 25
    Caption = #1055#1077#1088#1077#1074#1077#1089#1090#1080' '#1074' $ ...'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00337000000000
      73333337777777773F333308888888880333337F3F3F3FFF7F33330808089998
      0333337F737377737F333308888888880333337F3F3F3F3F7F33330808080808
      0333337F737373737F333308888888880333337F3F3F3F3F7F33330808080808
      0333337F737373737F333308888888880333337F3F3F3F3F7F33330808080808
      0333337F737373737F333308888888880333337F3FFFFFFF7F33330800000008
      0333337F7777777F7F333308000E0E080333337F7FFFFF7F7F33330800000008
      0333337F777777737F333308888888880333337F333333337F33330888888888
      03333373FFFFFFFF733333700000000073333337777777773333}
    NumGlyphs = 2
    OnClick = btToUSDClick
  end
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 69
    Height = 13
    Caption = #1042#1080#1076' '#1088#1072#1089#1093#1086#1076#1086#1074
    FocusControl = lkComExp
  end
  object Bevel3: TBevel
    Left = 8
    Top = 32
    Width = 613
    Height = 8
    Shape = bsBottomLine
  end
  object Label4: TLabel
    Left = 112
    Top = 0
    Width = 105
    Height = 13
    Caption = #1047#1076#1077#1089#1100' 2 '#1082#1086#1084#1073#1086#1073#1086#1082#1089#1072
    Visible = False
  end
  object btSaveComExp: TBitBtn
    Left = 468
    Top = 428
    Width = 155
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    ModalResult = 1
    TabOrder = 1
    OnClick = btSaveComExpClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
      03333377777777777F333301111111110333337F333333337F33330111111111
      0333337F333333337F333301111111110333337F333333337F33330111111111
      0333337F333333337F333301111111110333337F333333337F33330111111111
      0333337F3333333F7F333301111111B10333337F333333737F33330111111111
      0333337F333333337F333301111111110333337F33FFFFF37F3333011EEEEE11
      0333337F377777F37F3333011EEEEE110333337F37FFF7F37F3333011EEEEE11
      0333337F377777337F333301111111110333337F333333337F33330111111111
      0333337FFFFFFFFF7F3333000000000003333377777777777333}
    NumGlyphs = 2
  end
  object pcExp: TPageControl
    Left = 6
    Top = 48
    Width = 617
    Height = 371
    ActivePage = tsExp
    TabOrder = 0
    OnChange = pcExpChange
    object tsExp: TTabSheet
      Caption = #1056#1072#1089#1093#1086#1076#1099
      object Label68: TLabel
        Left = 373
        Top = 322
        Width = 68
        Height = 13
        Caption = #1048#1090#1086#1075#1086', '#1075#1088#1085'.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Bevel1: TBevel
        Left = 8
        Top = 304
        Width = 573
        Height = 8
        Shape = bsBottomLine
      end
      object Label2: TLabel
        Left = 8
        Top = 284
        Width = 80
        Height = 13
        Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086
      end
      object Label6: TLabel
        Left = 150
        Top = 322
        Width = 51
        Height = 13
        Caption = #1048#1090#1086#1075#1086', $'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 356
        Top = 322
        Width = 8
        Height = 13
        Caption = '+'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btMakeComCat: TJvSpeedButton
        Left = 8
        Top = 316
        Width = 119
        Height = 25
        Caption = #1057#1076#1077#1083#1072#1090#1100' '#1074#1080#1076#1086#1084
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'MS Sans Serif'
        HotTrackFont.Style = []
        Visible = False
      end
      object dgComExp: TMyDBGridEh
        Tag = 2
        Left = 4
        Top = 8
        Width = 601
        Height = 267
        AllowedSelections = [gstRecordBookmarks]
        DataSource = ExpDM.dsComExp
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete]
        OptionsEh = [dghHighlightFocus, dghClearSelection, dghDialogFind]
        RowHeight = 17
        SortLocal = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnColEnter = dgComExpColEnter
        OnColExit = dgComExpColExit
        OnEnter = dgComExpColEnter
        OnGetCellParams = dgComExpGetCellParams
        Columns = <
          item
            AlwaysShowEditButton = True
            DropDownBox.Columns = <
              item
                FieldName = 'Name'
              end>
            DropDownSizing = True
            EditButtons = <>
            FieldName = 'ExpKindLookup'
            Footers = <>
            PopupMenu = pmExp
            Title.Caption = #1053#1072' '#1095#1090#1086' '#1087#1086#1090#1088#1072#1095#1077#1085#1086
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 246
          end
          item
            AlwaysShowEditButton = True
            EditButtons = <>
            FieldName = 'ExpDate'
            Footers = <>
            Title.Caption = #1044#1072#1090#1072
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 101
          end
          item
            EditButtons = <>
            FieldName = 'CostUSD'
            Footers = <>
            Title.Caption = #1057#1091#1084#1084#1072', $'
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 96
          end
          item
            EditButtons = <>
            FieldName = 'CostGrn'
            Footers = <>
            Title.Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 110
          end>
      end
      object ComGrnItogo: TPanel
        Left = 448
        Top = 318
        Width = 133
        Height = 19
        Alignment = taRightJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = '0 '#1043#1088'. 00'#1082'.'
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
      object edOwnExpAdd: TDBEdit
        Left = 96
        Top = 282
        Width = 485
        Height = 21
        DataField = 'ExpAddOther'
        DataSource = ExpDM.dsComExp
        TabOrder = 2
        OnKeyPress = edOwnExpAddKeyPress
      end
      object ComUSDItogo: TPanel
        Left = 210
        Top = 318
        Width = 133
        Height = 19
        Alignment = taRightJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = '0 $ 00c'
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
    end
    object tsOwnExp: TTabSheet
      Caption = #1051#1080#1095#1085#1099#1077' '#1088#1072#1089#1093#1086#1076#1099
      ImageIndex = 1
      object Label3: TLabel
        Left = 8
        Top = 284
        Width = 80
        Height = 13
        Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086
      end
      object Bevel2: TBevel
        Left = 8
        Top = 304
        Width = 573
        Height = 8
        Shape = bsBottomLine
      end
      object Label5: TLabel
        Left = 150
        Top = 322
        Width = 51
        Height = 13
        Caption = #1048#1090#1086#1075#1086', $'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 356
        Top = 322
        Width = 8
        Height = 13
        Caption = '+'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 373
        Top = 322
        Width = 68
        Height = 13
        Caption = #1048#1090#1086#1075#1086', '#1075#1088#1085'.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btMakeOwnCat: TJvSpeedButton
        Left = 8
        Top = 316
        Width = 119
        Height = 25
        Caption = #1057#1076#1077#1083#1072#1090#1100' '#1074#1080#1076#1086#1084
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'MS Sans Serif'
        HotTrackFont.Style = []
        Visible = False
      end
      object dgOwnExp: TMyDBGridEh
        Tag = 3
        Left = 4
        Top = 8
        Width = 601
        Height = 267
        AllowedSelections = [gstRecordBookmarks]
        DataSource = ExpDM.dsOwnExp
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete]
        OptionsEh = [dghHighlightFocus, dghClearSelection, dghDialogFind]
        RowHeight = 17
        SortLocal = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnColEnter = dgComExpColEnter
        OnColExit = dgComExpColExit
        OnEnter = dgComExpColEnter
        OnGetCellParams = dgComExpGetCellParams
        Columns = <
          item
            AlwaysShowEditButton = True
            DropDownSizing = True
            EditButtons = <>
            FieldName = 'ExpKindLookup'
            Footers = <>
            PopupMenu = pmMyExp
            Title.Caption = #1053#1072' '#1095#1090#1086' '#1087#1086#1090#1088#1072#1095#1077#1085#1086
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 259
          end
          item
            AlwaysShowEditButton = True
            EditButtons = <>
            FieldName = 'ExpDate'
            Footers = <>
            Title.Caption = #1044#1072#1090#1072
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 100
          end
          item
            EditButtons = <>
            FieldName = 'CostUSD'
            Footers = <>
            Title.Caption = #1057#1091#1084#1084#1072', $'
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 94
          end
          item
            EditButtons = <>
            FieldName = 'CostGrn'
            Footers = <>
            Title.Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 92
          end>
      end
      object edComExpAdd: TDBEdit
        Left = 96
        Top = 282
        Width = 485
        Height = 21
        DataField = 'ExpAddOther'
        DataSource = ExpDM.dsOwnExp
        TabOrder = 1
      end
      object OwnUSDItogo: TPanel
        Left = 210
        Top = 318
        Width = 133
        Height = 19
        Alignment = taRightJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = '0 $ 00c'
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
      object OwnGrnItogo: TPanel
        Left = 448
        Top = 318
        Width = 133
        Height = 19
        Alignment = taRightJustify
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = '0 '#1043#1088'. 00'#1082'.'
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
    end
  end
  object lkComExp: TJvDBLookupCombo
    Left = 84
    Top = 12
    Width = 211
    Height = 21
    DropDownCount = 8
    DisplayEmpty = '<'#1042#1089#1077'>'
    IgnoreCase = False
    ItemHeight = 17
    LookupField = 'Code'
    LookupDisplay = 'Name'
    LookupSource = dsComExpKind
    TabOrder = 2
    OnChange = lkComExpChange
  end
  object cbRangeEn: TCheckBox
    Left = 517
    Top = 15
    Width = 17
    Height = 17
    TabOrder = 3
    OnClick = cbRangeEnClick
  end
  object btRange: TBitBtn
    Left = 538
    Top = 11
    Width = 83
    Height = 24
    Caption = #1055#1077#1088#1110#1086#1076'...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btRangeClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      0400000000000001000000000000000000001000000010000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      33333FFFFFFFFFFFFFFF000000000000000077777777777777770FF7FF7FF7FF
      7FF07FF7FF7FF7F37F3709F79F79F7FF7FF077F77F77F7FF7FF7077777777777
      777077777777777777770FF7FF7FF7FF7FF07FF7FF7FF7FF7FF709F79F79F79F
      79F077F77F77F77F77F7077777777777777077777777777777770FF7FF7FF7FF
      7FF07FF7FF7FF7FF7FF709F79F79F79F79F077F77F77F77F77F7077777777777
      777077777777777777770FFFFF7FF7FF7FF07F33337FF7FF7FF70FFFFF79F79F
      79F07FFFFF77F77F77F700000000000000007777777777777777CCCCCC8888CC
      CCCC777777FFFF777777CCCCCCCCCCCCCCCC7777777777777777}
    NumGlyphs = 2
  end
  object cbMonthEn: TCheckBox
    Left = 326
    Top = 15
    Width = 17
    Height = 17
    TabOrder = 5
    OnClick = cbMonthEnClick
  end
  object cbMonth: TComboBox
    Left = 346
    Top = 13
    Width = 81
    Height = 21
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 6
    OnChange = edYearChange
  end
  object cbYearEn: TCheckBox
    Left = 438
    Top = 15
    Width = 17
    Height = 17
    TabOrder = 7
    OnClick = cbYearEnClick
  end
  object edYear: TEdit
    Left = 458
    Top = 13
    Width = 37
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    Text = '2000'
    OnChange = edYearChange
  end
  object udYear: TUpDown
    Left = 495
    Top = 13
    Width = 15
    Height = 21
    Associate = edYear
    Min = 1900
    Max = 2099
    Position = 2000
    TabOrder = 9
    Thousands = False
  end
  object lkOwnExp: TJvDBLookupCombo
    Left = 84
    Top = 12
    Width = 211
    Height = 22
    DropDownCount = 8
    DisplayEmpty = '<'#1042#1089#1077'>'
    IgnoreCase = False
    ItemHeight = 17
    LookupField = 'Code'
    LookupDisplay = 'Name'
    LookupSource = dsOwnExpKind
    TabOrder = 10
    OnChange = lkOwnExpChange
  end
  object pmExp: TPopupMenu
    Left = 174
    Top = 182
  end
  object pmMyExp: TPopupMenu
    Left = 208
    Top = 184
  end
  object dsComExpKind: TDataSource
    Left = 422
    Top = 300
  end
  object dsOwnExpKind: TDataSource
    Left = 424
    Top = 266
  end
end
