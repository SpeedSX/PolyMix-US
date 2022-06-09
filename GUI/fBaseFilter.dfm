object BaseFilterFrame: TBaseFilterFrame
  Left = 0
  Top = 0
  Width = 184
  Height = 300
  HorzScrollBar.Visible = False
  Align = alRight
  TabOrder = 0
  ExplicitHeight = 304
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 4
    Height = 300
    Align = alLeft
    Shape = bsLeftLine
    Visible = False
    ExplicitTop = 5
    ExplicitHeight = 272
  end
  object ScrollBox1: TScrollBox
    Left = 4
    Top = 0
    Width = 180
    Height = 300
    HorzScrollBar.Visible = False
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 0
    ExplicitHeight = 304
    object paFilterHdr: TPanel
      Left = 0
      Top = 0
      Width = 163
      Height = 18
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = ' '
      Color = clGray
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      object Image1: TImage
        Left = 4
        Top = 2
        Width = 16
        Height = 16
        Picture.Data = {
          07544269746D617042040000424D420400000000000042000000280000002000
          000010000000010010000300000000040000430B0000430B0000000000000000
          0000007C0000E00300001F0000001F7C1F7C1F7C1F7C1F7C1F7C084E1F7C1F7C
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C734E1F7C1F7C
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CA441084E1F7C
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C524A734E1F7C
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CA441126B084E
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C524A5A6B734E
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CA441126BA441
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C524A5A6B524A
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CA441126BA441
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C524A5A6B524A
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CA441126B084E
          A4411F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C524A5A6BB556
          524A1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CA441126B6B562952
          074EA4411F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C524A5A6BD65AB556
          9452524A1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CA441126B6C5A4A562952
          074EC545A4411F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C524A5A6BF75ED65AB556
          9452734E524A1F7C1F7C1F7C1F7C1F7C1F7C1F7CA441126BAE5E4B56084A074A
          074EE549C445A4411F7C1F7C1F7C1F7C1F7C1F7C524A5A6B3967F75E524A524A
          9452734E524A524A1F7C1F7C1F7C1F7C1F7CA441126BAE5EC745094ECD66E24D
          843D8439A441A441A4411F7C1F7C1F7C1F7C524A9C735A6B524A524A734E524A
          524A524A524A3146524A1F7C1F7C1F7C1F7CA441C545895EF47F287F517F8872
          80548354C749A54163391F7C1F7C1F7C1F7C524A524A1042396794521863524A
          4A298C318C31524A524A1F7C1F7C1F7C1F7C8D5AC5458666B47FD17F087B805C
          005C006483542B4E8D5A1F7C1F7C1F7C1F7C1F7C524AEF3D39671863734E8C31
          8C318C318C31EF3D1F7C1F7C1F7C1F7C1F7C1F7C5509AB2DC8410D7B24698364
          0068006C0060316A1F7C1F7C1F7C1F7C1F7C1F7C6B2D8C318C31B556EF3DCE39
          AD35AD358C31B5561F7C1F7C1F7C1F7C1F7C1F7CD719150136018F25C84C0E72
          83640064CE651F7C1F7C1F7C1F7C1F7C1F7C1F7CEF3D4A296B2D8C316C35B556
          CE39AD35734E1F7C1F7C1F7C1F7C1F7C1F7C1F7C2E259B3A9D22B509D329E760
          E760316E1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C6B2D9452524A8C31EF3DEF3D
          EF3DD65A1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C764A9229F95E1F7C1F7C
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C9452CE3918631F7C1F7C
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C}
        Transparent = True
      end
      object lbFilterHdr: TLabel
        Left = 28
        Top = 2
        Width = 55
        Height = 13
        Caption = #1042#1099#1073#1086#1088#1082#1072':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clCaptionText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object sbCloseFilter: TSpeedButton
        Left = 147
        Top = 1
        Width = 16
        Height = 16
        Flat = True
        Glyph.Data = {
          DE000000424DDE0000000000000076000000280000000D0000000D0000000100
          04000000000068000000120B0000120B00001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          300033F33333333F300033FF333333FF3000333FF3333FF33000333FFF33FFF3
          30003333FFFFFF33300033333FFFF33330003333FFFFF3333000333FFFFFFF33
          30003FFFF33FFFF330003FFF3333FFFF30003FF333333FFF3000333333333333
          3000}
        Spacing = 1
        Visible = False
        OnClick = sbCloseFilterClick
      end
    end
    object gbMonthYear: TJvgGroupBox
      Left = 0
      Top = 18
      Width = 163
      Height = 249
      Align = alTop
      Caption = #1044#1072#1090#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Border.Inner = bvSpace
      Border.Outer = bvNone
      Border.Sides = [fsdLeft, fsdTop, fsdRight]
      Border.Bold = False
      CaptionAlignment = fcaWidth
      CaptionBorder.Inner = bvNone
      CaptionBorder.Outer = bvSpace
      CaptionBorder.Sides = [fsdLeft, fsdTop, fsdRight]
      CaptionBorder.Bold = True
      CaptionGradient.Active = False
      CaptionGradient.Orientation = fgdHorizontal
      CaptionShift.X = 5
      CaptionShift.Y = 0
      Colors.Text = clBtnText
      Colors.TextActive = clWhite
      Colors.Caption = 14741744
      Colors.CaptionActive = clActiveCaption
      Colors.Client = clBtnFace
      Colors.ClientActive = clBtnFace
      Gradient.FromColor = clBlack
      Gradient.ToColor = clGray
      Gradient.Active = False
      Gradient.Orientation = fgdHorizontal
      Options = [fgoCanCollapse, fgoFilledCaption, fgoSaveChildFocus]
      GlyphCollapsed.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      GlyphExpanded.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFF2FFFFF8300038FF222FFFF8
        300038F22222FFF8300038F22F222FF8300038F2FFF222F8300038FFFFFF22F8
        300038FFFFFFF2F8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      OnCollapsed = cbMonthYearClick
      OnExpanded = cbMonthYearClick
      FullHeight = 251
      object sbMonthDn: TSpeedButton
        Left = 20
        Top = 90
        Width = 19
        Height = 20
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Glyph.Data = {
          12010000424D12010000000000007600000028000000140000000D0000000100
          0400000000009C00000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333335AAA33333333333333333333E11133333333333333333FFF5AAA3333
          33370333333FF33FF0003333370003333FF3333FD22233370000033FF333333F
          F0003700000003733333333FD2223337000003377333333F3000333337000333
          3773333FD2223333333703333337733FF00033333333333333333773D2223333
          3333333333333333F00033333333333333333333D222}
        Layout = blGlyphRight
        NumGlyphs = 2
        ParentFont = False
        OnClick = sbMonthDnClick
      end
      object sbMonthUp: TSpeedButton
        Left = 136
        Top = 90
        Width = 19
        Height = 20
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Glyph.Data = {
          12010000424D12010000000000007600000028000000140000000D0000000100
          0400000000009C00000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          33333333FFFF33333333333333333333CEEC33333333333FF3333333CDFC3073
          333333733FF33333CDFC300073333373333FF333CDFC30000073337333333FF3
          CCEC3000000073733333333FCFFD30000073337333333773EFFF300073333373
          33377333EFFE30733333337337733333EEEE33333333337773333333FFFF3333
          3333333333333333FFFF33333333333333333333FFFF}
        NumGlyphs = 2
        ParentFont = False
        OnClick = sbMonthUpClick
      end
      object sbYearUp: TSpeedButton
        Left = 104
        Top = 48
        Width = 19
        Height = 20
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Glyph.Data = {
          12010000424D12010000000000007600000028000000140000000D0000000100
          0400000000009C00000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          33333333FFFF33333333333333333333CEEC33333333333FF3333333CDFC3073
          333333733FF33333CDFC300073333373333FF333CDFC30000073337333333FF3
          CCEC3000000073733333333FCFFD30000073337333333773EFFF300073333373
          33377333EFFE30733333337337733333EEEE33333333337773333333FFFF3333
          3333333333333333FFFF33333333333333333333FFFF}
        NumGlyphs = 2
        ParentFont = False
        OnClick = sbYearUpClick
      end
      object sbYearDn: TSpeedButton
        Left = 48
        Top = 48
        Width = 19
        Height = 20
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Glyph.Data = {
          12010000424D12010000000000007600000028000000140000000D0000000100
          0400000000009C00000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333335AAA33333333333333333333E11133333333333333333FFF5AAA3333
          33370333333FF33FF0003333370003333FF3333FD22233370000033FF333333F
          F0003700000003733333333FD2223337000003377333333F3000333337000333
          3773333FD2223333333703333337733FF00033333333333333333773D2223333
          3333333333333333F00033333333333333333333D222}
        Layout = blGlyphRight
        NumGlyphs = 2
        ParentFont = False
        OnClick = sbYearDnClick
      end
      object btIncDate: TSpeedButton
        Left = 140
        Top = 224
        Width = 23
        Height = 20
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Glyph.Data = {
          12010000424D12010000000000007600000028000000140000000D0000000100
          0400000000009C00000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          33333333FFFF33333333333333333333CEEC33333333333FF3333333CDFC3073
          333333733FF33333CDFC300073333373333FF333CDFC30000073337333333FF3
          CCEC3000000073733333333FCFFD30000073337333333773EFFF300073333373
          33377333EFFE30733333337337733333EEEE33333333337773333333FFFF3333
          3333333333333333FFFF33333333333333333333FFFF}
        NumGlyphs = 2
        ParentFont = False
        OnClick = btIncDateClick
      end
      object btDecDate: TSpeedButton
        Left = 47
        Top = 224
        Width = 23
        Height = 20
        Flat = True
        Glyph.Data = {
          12010000424D12010000000000007600000028000000140000000D0000000100
          0400000000009C00000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333335AAA33333333333333333333E11133333333333333333FFF5AAA3333
          33370333333FF33FF0003333370003333FF3333FD22233370000033FF333333F
          F0003700000003733333333FD2223337000003377333333F3000333337000333
          3773333FD2223333333703333337733FF00033333333333333333773D2223333
          3333333333333333F00033333333333333333333D222}
        Layout = blGlyphRight
        NumGlyphs = 2
        Spacing = 0
        OnClick = btDecDateClick
      end
      object rbOneDay: TRadioButton
        Left = 4
        Top = 225
        Width = 47
        Height = 17
        Caption = #1044#1077#1085#1100
        TabOrder = 9
        OnClick = cbMonthYearClick
      end
      object cbMonth: TComboBox
        Left = 40
        Top = 90
        Width = 97
        Height = 19
        AutoDropDown = True
        Style = csOwnerDrawVariable
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 0
        OnChange = cbMonthYearClick
      end
      object ceYear: TJvValidateEdit
        Left = 68
        Top = 48
        Width = 37
        Height = 21
        AutoSize = False
        CriticalPoints.MaxValueIncluded = False
        CriticalPoints.MinValueIncluded = False
        EditText = '2000'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        MaxValue = 3000.000000000000000000
        MinValue = 1900.000000000000000000
        ParentFont = False
        TabOrder = 1
        OnChange = cbMonthYearClick
      end
      object rbYear: TRadioButton
        Left = 4
        Top = 50
        Width = 41
        Height = 17
        Caption = #1043#1086#1076
        TabOrder = 2
        OnClick = cbMonthYearClick
      end
      object rbCurMonth: TRadioButton
        Left = 4
        Top = 112
        Width = 113
        Height = 17
        Caption = #1058#1077#1082#1091#1097#1080#1081' '#1084#1077#1089#1103#1094
        TabOrder = 3
        OnClick = cbMonthYearClick
      end
      object rbCurYear: TRadioButton
        Left = 4
        Top = 132
        Width = 145
        Height = 17
        Caption = #1058#1077#1082#1091#1097#1080#1081' '#1075#1086#1076
        TabOrder = 4
        OnClick = cbMonthYearClick
      end
      object chbMonth: TCheckBox
        Left = 20
        Top = 71
        Width = 97
        Height = 17
        Caption = #1052#1077#1089#1103#1094
        TabOrder = 5
        OnClick = cbMonthYearClick
      end
      object Panel1: TPanel
        Left = 10
        Top = 160
        Width = 149
        Height = 61
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Caption = ' '
        TabOrder = 6
        object Label2: TLabel
          Left = 28
          Top = 14
          Width = 7
          Height = 13
          Caption = #1057
        end
        object cbRangeEnd: TCheckBox
          Left = 8
          Top = 36
          Width = 36
          Height = 17
          Caption = #1087#1086
          TabOrder = 0
          OnClick = cbMonthYearClick
        end
      end
      object rbDateRange: TRadioButton
        Left = 4
        Top = 152
        Width = 61
        Height = 17
        Caption = #1055#1077#1088#1080#1086#1076
        TabOrder = 7
        OnClick = cbMonthYearClick
      end
      object cbDateType: TComboBox
        Left = 4
        Top = 21
        Width = 161
        Height = 21
        AutoDropDown = True
        BevelEdges = []
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 8
        OnChange = cbDateTypeChange
      end
      object deRangeStart: TDBDateTimeEditEh
        Left = 54
        Top = 170
        Width = 98
        Height = 21
        EditButtons = <>
        Kind = dtkDateEh
        TabOrder = 10
        Visible = True
        OnChange = cbMonthYearClick
      end
      object deRangeEnd: TDBDateTimeEditEh
        Left = 54
        Top = 195
        Width = 98
        Height = 21
        EditButtons = <>
        Kind = dtkDateEh
        TabOrder = 11
        Visible = True
        OnChange = cbMonthYearClick
      end
      object deOneDay: TDBDateTimeEditEh
        Left = 66
        Top = 224
        Width = 79
        Height = 21
        EditButtons = <>
        Kind = dtkDateEh
        TabOrder = 12
        Visible = True
        OnChange = cbMonthYearClick
      end
    end
    object gbCust: TJvgGroupBox
      Left = 0
      Top = 301
      Width = 163
      Height = 17
      Align = alTop
      Caption = #1047#1072#1082#1072#1079#1095#1080#1082
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Border.Inner = bvSpace
      Border.Outer = bvNone
      Border.Sides = [fsdLeft, fsdTop, fsdRight]
      Border.Bold = False
      CaptionAlignment = fcaWidth
      CaptionBorder.Inner = bvNone
      CaptionBorder.Outer = bvSpace
      CaptionBorder.Sides = [fsdLeft, fsdTop, fsdRight]
      CaptionBorder.Bold = True
      CaptionGradient.Active = False
      CaptionGradient.Orientation = fgdHorizontal
      CaptionShift.X = 5
      CaptionShift.Y = 0
      Collapsed = True
      Colors.Text = clBtnText
      Colors.TextActive = clWhite
      Colors.Caption = 14741744
      Colors.CaptionActive = clActiveCaption
      Colors.Client = clBtnFace
      Colors.ClientActive = clBtnFace
      Gradient.FromColor = clBlack
      Gradient.ToColor = clGray
      Gradient.Active = False
      Gradient.Orientation = fgdHorizontal
      Options = [fgoCanCollapse, fgoFilledCaption, fgoSaveChildFocus]
      GroupIndex = 1
      GlyphCollapsed.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      GlyphExpanded.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFF2FFFFF8300038FF222FFFF8
        300038F22222FFF8300038F22F222FF8300038F2FFF222F8300038FFFFFF22F8
        300038FFFFFFF2F8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      OnCollapsed = cbCustClick
      OnExpanded = cbCustClick
      FullHeight = 77
      object btCustSel: TSpeedButton
        Left = 32
        Top = 48
        Width = 122
        Height = 25
        Caption = #1047#1072#1082#1072#1079#1095#1080#1082#1080'...'
        Enabled = False
        Glyph.Data = {
          AA010000424DAA010000000000008A000000280000000E000000120000000100
          08000000000020010000430B0000430B0000150000001500000000000000FFFF
          FF000D0C0C00251B160014121100160F0B0038333000E4D9D000685A4D009A85
          7100AEA29500DAD2C90051473B00A79A8B0083766500BCB1A300928169009B8D
          7300EBE9E500F3F3F200C0C0C000141414141414141414020214141400001414
          140202141414020908021414000014140209080214020D090802141400001402
          0D09080210020D080C0C0914000014020D080C0C0C02100C080C021400001402
          100C080C0C020C08080C0214000003020C08080C020C11100E08021400000C0C
          11100E0802110D0D110E0214000002110D111008020A0D0C0D0E02080000020A
          0D0D110E020F0C0F0C020C080000020F0D0C0D0E0202070F0F0208080000020F
          0C0F0C02030212070F020E0800001402070F0F050D02131207060C1400001402
          12070F02100E0404050F041400001402131207050D0414041212041400001414
          0504040B12041414020214140000141414141402021414141414141400001414
          1414141414141414141414140000}
        OnClick = btCustSelClick
      end
      object lcCust: TJvDBLookupCombo
        Left = 4
        Top = 22
        Width = 150
        Height = 21
        DropDownWidth = 200
        DisplayEmpty = '<'#1085#1077' '#1091#1082#1072#1079#1072#1085'>'
        ItemHeight = 17
        LookupField = 'N'
        LookupDisplay = 'Name'
        LookupSource = dsCust
        TabOrder = 0
        OnChange = lcCustChange
        OnGetImage = lcCustGetImage
      end
    end
    object gbComment: TJvgGroupBox
      Left = 0
      Top = 655
      Width = 163
      Height = 16
      Align = alTop
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      Border.Inner = bvSpace
      Border.Outer = bvNone
      Border.Sides = [fsdLeft, fsdTop, fsdRight]
      Border.Bold = False
      CaptionAlignment = fcaWidth
      CaptionBorder.Inner = bvNone
      CaptionBorder.Outer = bvSpace
      CaptionBorder.Sides = [fsdLeft, fsdTop, fsdRight]
      CaptionBorder.Bold = True
      CaptionGradient.Active = False
      CaptionGradient.Orientation = fgdHorizontal
      CaptionShift.X = 5
      CaptionShift.Y = 0
      Collapsed = True
      Colors.Text = clBtnText
      Colors.TextActive = clWhite
      Colors.Caption = 14741744
      Colors.CaptionActive = clActiveCaption
      Colors.Client = clBtnFace
      Colors.ClientActive = clBtnFace
      Gradient.FromColor = clBlack
      Gradient.ToColor = clGray
      Gradient.Active = False
      Gradient.Orientation = fgdHorizontal
      Options = [fgoCanCollapse, fgoFilledCaption, fgoSaveChildFocus]
      GroupIndex = 1
      GlyphCollapsed.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      GlyphExpanded.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFF2FFFFF8300038FF222FFFF8
        300038F22222FFF8300038F22F222FF8300038F2FFF222F8300038FFFFFF22F8
        300038FFFFFFF2F8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      OnCollapsed = cbCommentClick
      OnExpanded = cbCommentClick
      FullHeight = 68
      object Label1: TLabel
        Left = 4
        Top = 20
        Width = 82
        Height = 13
        Caption = #1089#1086#1076#1077#1088#1078#1080#1090' '#1089#1083#1086#1074#1086
      end
      object edComment: TEdit
        Left = 4
        Top = 36
        Width = 153
        Height = 21
        TabOrder = 0
        OnChange = edCommentChange
      end
    end
    object gbCreator: TJvgGroupBox
      Left = 0
      Top = 705
      Width = 163
      Height = 17
      Align = alTop
      Caption = #1057#1086#1079#1076#1072#1090#1077#1083#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      Border.Inner = bvSpace
      Border.Outer = bvNone
      Border.Sides = [fsdLeft, fsdTop, fsdRight]
      Border.Bold = False
      CaptionAlignment = fcaWidth
      CaptionBorder.Inner = bvNone
      CaptionBorder.Outer = bvSpace
      CaptionBorder.Sides = [fsdLeft, fsdTop, fsdRight]
      CaptionBorder.Bold = True
      CaptionGradient.Active = False
      CaptionGradient.Orientation = fgdHorizontal
      CaptionShift.X = 5
      CaptionShift.Y = 0
      Collapsed = True
      Colors.Text = clBtnText
      Colors.TextActive = clWhite
      Colors.Caption = 14741744
      Colors.CaptionActive = clActiveCaption
      Colors.Client = clBtnFace
      Colors.ClientActive = clBtnFace
      Gradient.FromColor = clBlack
      Gradient.ToColor = clGray
      Gradient.Active = False
      Gradient.Orientation = fgdHorizontal
      Options = [fgoCanCollapse, fgoFilledCaption, fgoSaveChildFocus]
      GroupIndex = 1
      GlyphCollapsed.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      GlyphExpanded.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFF2FFFFF8300038FF222FFFF8
        300038F22222FFF8300038F22F222FF8300038F2FFF222F8300038FFFFFF22F8
        300038FFFFFFF2F8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      OnCollapsed = cbCreatorClick
      OnExpanded = cbCreatorClick
      FullHeight = 52
      object cbCreatorName: TComboBox
        Left = 8
        Top = 23
        Width = 163
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = cbCreatorClick
      end
    end
    object gbEvent: TJvgGroupBox
      Left = 0
      Top = 722
      Width = 163
      Height = 17
      Align = alTop
      Caption = #1057#1086#1073#1099#1090#1080#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 12
      Border.Inner = bvSpace
      Border.Outer = bvNone
      Border.Bold = False
      CaptionAlignment = fcaWidth
      CaptionBorder.Inner = bvNone
      CaptionBorder.Outer = bvSpace
      CaptionBorder.Bold = True
      CaptionGradient.Active = False
      CaptionGradient.Orientation = fgdHorizontal
      CaptionShift.X = 5
      CaptionShift.Y = 0
      Collapsed = True
      Colors.Text = clBtnText
      Colors.TextActive = clWhite
      Colors.Caption = 14741744
      Colors.CaptionActive = clActiveCaption
      Colors.Client = clBtnFace
      Colors.ClientActive = clBtnFace
      Gradient.FromColor = clBlack
      Gradient.ToColor = clGray
      Gradient.Active = False
      Gradient.Orientation = fgdHorizontal
      Options = [fgoCanCollapse, fgoFilledCaption, fgoSaveChildFocus]
      GroupIndex = 1
      GlyphCollapsed.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      GlyphExpanded.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFF2FFFFF8300038FF222FFFF8
        300038F22222FFF8300038F22F222FF8300038F2FFF222F8300038FFFFFF22F8
        300038FFFFFFF2F8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      OnCollapsed = cbEventClick
      OnExpanded = cbEventClick
      DesignSize = (
        163
        17)
      FullHeight = 155
      object lbEventText: TLabel
        Left = 8
        Top = 50
        Width = 29
        Height = 13
        Caption = #1058#1077#1082#1089#1090
      end
      object cbEventUser: TComboBox
        Left = 8
        Top = 23
        Width = 163
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        OnChange = cbEventClick
      end
      object edEventText: TEdit
        Left = 8
        Top = 68
        Width = 139
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnChange = cbEventClick
      end
      object deEventStart: TDBDateTimeEditEh
        Left = 54
        Top = 98
        Width = 98
        Height = 21
        EditButtons = <>
        Kind = dtkDateEh
        TabOrder = 2
        Visible = True
        OnChange = cbEventClick
      end
      object deEventEnd: TDBDateTimeEditEh
        Left = 54
        Top = 128
        Width = 98
        Height = 21
        EditButtons = <>
        Kind = dtkDateEh
        TabOrder = 3
        Visible = True
        OnChange = cbEventClick
      end
    end
    object gbNum: TJvgGroupBox
      Left = 0
      Top = 671
      Width = 163
      Height = 17
      Align = alTop
      Caption = #8470' '#1079#1072#1082#1072#1079#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      Border.Inner = bvSpace
      Border.Outer = bvNone
      Border.Sides = [fsdLeft, fsdTop, fsdRight]
      Border.Bold = False
      CaptionAlignment = fcaWidth
      CaptionBorder.Inner = bvNone
      CaptionBorder.Outer = bvSpace
      CaptionBorder.Sides = [fsdLeft, fsdTop, fsdRight]
      CaptionBorder.Bold = True
      CaptionGradient.Active = False
      CaptionGradient.Orientation = fgdHorizontal
      CaptionShift.X = 5
      CaptionShift.Y = 0
      Collapsed = True
      Colors.Text = clBtnText
      Colors.TextActive = clWhite
      Colors.Caption = 14741744
      Colors.CaptionActive = clActiveCaption
      Colors.Client = clBtnFace
      Colors.ClientActive = clBtnFace
      Gradient.FromColor = clBlack
      Gradient.ToColor = clGray
      Gradient.Active = False
      Gradient.Orientation = fgdHorizontal
      Options = [fgoCanCollapse, fgoFilledCaption, fgoSaveChildFocus]
      GroupIndex = 1
      GlyphCollapsed.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      GlyphExpanded.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFF2FFFFF8300038FF222FFFF8
        300038F22222FFF8300038F22F222FF8300038F2FFF222F8300038FFFFFF22F8
        300038FFFFFFF2F8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      OnCollapsed = cbNumClick
      OnExpanded = cbNumClick
      FullHeight = 100
      object lbNum: TLabel
        Left = 63
        Top = 75
        Width = 13
        Height = 13
        Caption = #1076#1086
      end
      object rbNumEQ: TRadioButton
        Left = 8
        Top = 24
        Width = 69
        Height = 17
        Caption = #1053#1086#1084#1077#1088' '
        TabOrder = 1
        TabStop = True
        OnClick = rbNumEQClick
      end
      object rbNumBounds: TRadioButton
        Left = 8
        Top = 51
        Width = 73
        Height = 17
        Caption = #1053#1086#1084#1077#1088' '#1086#1090
        TabOrder = 2
        TabStop = True
        OnClick = rbNumEQClick
      end
      object Panel3: TPanel
        Left = 79
        Top = 20
        Width = 71
        Height = 25
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 0
        object edNumEQ: TEdit
          Left = 2
          Top = 2
          Width = 50
          Height = 21
          TabOrder = 0
          Text = '1'
          OnChange = rbNumEQClick
        end
      end
      object edNumGT: TEdit
        Left = 81
        Top = 48
        Width = 50
        Height = 21
        TabOrder = 3
        Text = '1'
        OnChange = rbNumEQClick
      end
      object edNumLT: TEdit
        Left = 81
        Top = 72
        Width = 50
        Height = 21
        TabOrder = 4
        Text = '1'
        OnChange = rbNumEQClick
      end
    end
    object gbOrdState: TJvgGroupBox
      Left = 0
      Top = 466
      Width = 163
      Height = 172
      Align = alTop
      Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1079#1072#1082#1072#1079#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Border.Inner = bvSpace
      Border.Outer = bvNone
      Border.Sides = [fsdLeft, fsdTop, fsdRight]
      Border.Bold = False
      CaptionAlignment = fcaWidth
      CaptionBorder.Inner = bvNone
      CaptionBorder.Outer = bvSpace
      CaptionBorder.Sides = [fsdLeft, fsdTop, fsdRight]
      CaptionBorder.Bold = True
      CaptionGradient.Active = False
      CaptionGradient.Orientation = fgdHorizontal
      CaptionShift.X = 5
      CaptionShift.Y = 0
      Colors.Text = clBtnText
      Colors.TextActive = clCaptionText
      Colors.Caption = 14741744
      Colors.CaptionActive = clActiveCaption
      Colors.Client = clBtnFace
      Colors.ClientActive = clBtnFace
      Gradient.FromColor = clBlack
      Gradient.ToColor = clGray
      Gradient.Active = False
      Gradient.Orientation = fgdHorizontal
      Options = [fgoCanCollapse, fgoFilledCaption, fgoSaveChildFocus]
      GroupIndex = 1
      GlyphCollapsed.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      GlyphExpanded.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFF2FFFFF8300038FF222FFFF8
        300038F22222FFF8300038F22F222FF8300038F2FFF222F8300038FFFFFF22F8
        300038FFFFFFF2F8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      OnCollapsed = cbOrdStateClick
      OnExpanded = cbOrdStateClick
      FullHeight = 172
      object boxOrdState: TJvxCheckListBox
        Left = 4
        Top = 22
        Width = 153
        Height = 149
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 16
        MultiSelect = True
        ParentFont = False
        Style = lbOwnerDrawFixed
        TabOrder = 0
        OnClickCheck = cbOrdStateClick
        OnDrawItem = boxPayStateDrawItem
        InternalVersion = 202
      end
    end
    object gbPayState: TJvgGroupBox
      Left = 0
      Top = 638
      Width = 163
      Height = 17
      Align = alTop
      Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1086#1087#1083#1072#1090#1099
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Border.Inner = bvSpace
      Border.Outer = bvNone
      Border.Sides = [fsdLeft, fsdTop, fsdRight]
      Border.Bold = False
      CaptionAlignment = fcaWidth
      CaptionBorder.Inner = bvNone
      CaptionBorder.Outer = bvSpace
      CaptionBorder.Sides = [fsdLeft, fsdTop, fsdRight]
      CaptionBorder.Bold = True
      CaptionGradient.Active = False
      CaptionGradient.Orientation = fgdHorizontal
      CaptionShift.X = 5
      CaptionShift.Y = 0
      Collapsed = True
      Colors.Text = clBtnText
      Colors.TextActive = clWhite
      Colors.Caption = 14741744
      Colors.CaptionActive = clActiveCaption
      Colors.Client = clBtnFace
      Colors.ClientActive = clBtnFace
      Gradient.FromColor = clBlack
      Gradient.ToColor = clGray
      Gradient.Active = False
      Gradient.Orientation = fgdHorizontal
      Options = [fgoCanCollapse, fgoFilledCaption, fgoSaveChildFocus]
      GroupIndex = 1
      GlyphCollapsed.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      GlyphExpanded.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFF2FFFFF8300038FF222FFFF8
        300038F22222FFF8300038F22F222FF8300038F2FFF222F8300038FFFFFF22F8
        300038FFFFFFF2F8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      OnCollapsed = cbPayStateClick
      OnExpanded = cbPayStateClick
      FullHeight = 131
      object boxPayState: TJvxCheckListBox
        Left = 4
        Top = 22
        Width = 153
        Height = 105
        BorderStyle = bsNone
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 16
        MultiSelect = True
        ParentFont = False
        Style = lbOwnerDrawFixed
        TabOrder = 0
        OnClickCheck = cbPayStateClick
        OnDrawItem = boxPayStateDrawItem
        InternalVersion = 202
      end
    end
    object gbOrderKind: TJvgGroupBox
      Left = 0
      Top = 267
      Width = 163
      Height = 17
      Align = alTop
      Caption = #1042#1080#1076' '#1079#1072#1082#1072#1079#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Border.Inner = bvSpace
      Border.Outer = bvNone
      Border.Sides = [fsdLeft, fsdTop, fsdRight]
      Border.Bold = False
      CaptionAlignment = fcaWidth
      CaptionBorder.Inner = bvNone
      CaptionBorder.Outer = bvSpace
      CaptionBorder.Sides = [fsdLeft, fsdTop, fsdRight]
      CaptionBorder.Bold = True
      CaptionGradient.Active = False
      CaptionGradient.Orientation = fgdHorizontal
      CaptionShift.X = 5
      CaptionShift.Y = 0
      Collapsed = True
      Colors.Text = clBtnText
      Colors.TextActive = clCaptionText
      Colors.Caption = 14741744
      Colors.CaptionActive = clActiveCaption
      Colors.Client = clBtnFace
      Colors.ClientActive = clBtnFace
      Gradient.FromColor = clBlack
      Gradient.ToColor = clGray
      Gradient.Active = False
      Gradient.Orientation = fgdHorizontal
      Options = [fgoCanCollapse, fgoFilledCaption, fgoSaveChildFocus]
      GroupIndex = 1
      GlyphCollapsed.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      GlyphExpanded.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFF2FFFFF8300038FF222FFFF8
        300038F22222FFF8300038F22F222FF8300038F2FFF222F8300038FFFFFF22F8
        300038FFFFFFF2F8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      OnCollapsed = gbOrderKindClick
      OnExpanded = gbOrderKindClick
      FullHeight = 130
      object boxOrderKind: TJvxCheckListBox
        Left = 4
        Top = 22
        Width = 153
        Height = 105
        BorderStyle = bsNone
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 16
        MultiSelect = True
        ParentFont = False
        Style = lbOwnerDrawFixed
        TabOrder = 0
        OnClickCheck = gbOrderKindClick
        OnDrawItem = boxOrderKindDrawItem
        InternalVersion = 202
      end
    end
    object gbProcess: TJvgGroupBox
      Left = 0
      Top = 284
      Width = 163
      Height = 17
      Align = alTop
      Caption = #1055#1088#1086#1094#1077#1089#1089
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      Border.Inner = bvSpace
      Border.Outer = bvNone
      Border.Sides = [fsdLeft, fsdTop, fsdRight]
      Border.Bold = False
      CaptionAlignment = fcaWidth
      CaptionBorder.Inner = bvNone
      CaptionBorder.Outer = bvSpace
      CaptionBorder.Sides = [fsdLeft, fsdTop, fsdRight]
      CaptionBorder.Bold = True
      CaptionGradient.Active = False
      CaptionGradient.Orientation = fgdHorizontal
      CaptionShift.X = 5
      CaptionShift.Y = 0
      Collapsed = True
      Colors.Text = clBtnText
      Colors.TextActive = clCaptionText
      Colors.Caption = 14741744
      Colors.CaptionActive = clActiveCaption
      Colors.Client = clBtnFace
      Colors.ClientActive = clBtnFace
      Gradient.FromColor = clBlack
      Gradient.ToColor = clGray
      Gradient.Active = False
      Gradient.Orientation = fgdHorizontal
      Options = [fgoCanCollapse, fgoFilledCaption, fgoSaveChildFocus]
      GroupIndex = 1
      GlyphCollapsed.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      GlyphExpanded.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFF2FFFFF8300038FF222FFFF8
        300038F22222FFF8300038F22F222FF8300038F2FFF222F8300038FFFFFF22F8
        300038FFFFFFF2F8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      OnCollapsed = gbProcessClick
      OnExpanded = gbProcessClick
      FullHeight = 66
      object boxProcessList: TComboBox
        Left = 4
        Top = 24
        Width = 157
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = boxProcessListChange
        OnCloseUp = boxProcessListCloseUp
      end
      object cbProcessInvert: TCheckBox
        Left = 14
        Top = 46
        Width = 97
        Height = 17
        Caption = #1053#1077' '#1089#1086#1076#1077#1088#1078#1072#1097#1080#1077' '
        TabOrder = 1
        OnClick = boxProcessListChange
      end
    end
    object gbProcessState: TJvgGroupBox
      Left = 0
      Top = 318
      Width = 163
      Height = 148
      Align = alTop
      Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1087#1088#1086#1094#1077#1089#1089#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      Border.Inner = bvSpace
      Border.Outer = bvNone
      Border.Sides = [fsdLeft, fsdTop, fsdRight]
      Border.Bold = False
      CaptionAlignment = fcaWidth
      CaptionBorder.Inner = bvNone
      CaptionBorder.Outer = bvSpace
      CaptionBorder.Sides = [fsdLeft, fsdTop, fsdRight]
      CaptionBorder.Bold = True
      CaptionGradient.Active = False
      CaptionGradient.Orientation = fgdHorizontal
      CaptionShift.X = 5
      CaptionShift.Y = 0
      Colors.Text = clBtnText
      Colors.TextActive = clCaptionText
      Colors.Caption = 14741744
      Colors.CaptionActive = clActiveCaption
      Colors.Client = clBtnFace
      Colors.ClientActive = clBtnFace
      Gradient.FromColor = clBlack
      Gradient.ToColor = clGray
      Gradient.Active = False
      Gradient.Orientation = fgdHorizontal
      Options = [fgoCanCollapse, fgoFilledCaption, fgoSaveChildFocus]
      GroupIndex = 1
      GlyphCollapsed.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      GlyphExpanded.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFF2FFFFF8300038FF222FFFF8
        300038F22222FFF8300038F22F222FF8300038F2FFF222F8300038FFFFFF22F8
        300038FFFFFFF2F8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      OnCollapsed = cbProcessStateClick
      OnExpanded = cbProcessStateClick
      DesignSize = (
        163
        148)
      FullHeight = 119
      object boxProcessState: TJvxCheckListBox
        Left = 4
        Top = 22
        Width = 153
        Height = 123
        AutoScroll = False
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 16
        MultiSelect = True
        ParentFont = False
        Style = lbOwnerDrawFixed
        TabOrder = 0
        OnClickCheck = cbProcessStateClick
        OnDrawItem = boxPayStateDrawItem
        InternalVersion = 202
      end
    end
    object gbExternalId: TJvgGroupBox
      Left = 0
      Top = 688
      Width = 163
      Height = 17
      Align = alTop
      Caption = #1042#1085#1077#1096#1085#1080#1081' '#8470' '#1079#1072#1082#1072#1079#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
      Border.Inner = bvSpace
      Border.Outer = bvNone
      Border.Sides = [fsdLeft, fsdTop, fsdRight]
      Border.Bold = False
      CaptionAlignment = fcaWidth
      CaptionBorder.Inner = bvNone
      CaptionBorder.Outer = bvSpace
      CaptionBorder.Sides = [fsdLeft, fsdTop, fsdRight]
      CaptionBorder.Bold = True
      CaptionGradient.Active = False
      CaptionGradient.Orientation = fgdHorizontal
      CaptionShift.X = 5
      CaptionShift.Y = 0
      Collapsed = True
      Colors.Text = clBtnText
      Colors.TextActive = clWhite
      Colors.Caption = 14741744
      Colors.CaptionActive = clActiveCaption
      Colors.Client = clBtnFace
      Colors.ClientActive = clBtnFace
      Gradient.FromColor = clBlack
      Gradient.ToColor = clGray
      Gradient.Active = False
      Gradient.Orientation = fgdHorizontal
      Options = [fgoCanCollapse, fgoFilledCaption, fgoSaveChildFocus]
      GroupIndex = 1
      GlyphCollapsed.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8300038FFFFFFFFF8
        300038FFFFFFFFF8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      GlyphExpanded.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3000388888888888300038FFFFFFFFF8300038FFF2FFFFF8300038FF222FFFF8
        300038F22222FFF8300038F22F222FF8300038F2FFF222F8300038FFFFFF22F8
        300038FFFFFFF2F8300038FFFFFFFFF830003888888888883000333333333333
        3000}
      OnCollapsed = gbExternalIdClick
      OnExpanded = gbExternalIdClick
      DesignSize = (
        163
        17)
      FullHeight = 52
      object edExternalId: TEdit
        Left = 13
        Top = 23
        Width = 139
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Text = '1'
        OnChange = edExternalIdChange
      end
    end
  end
  object imOrdState: TJvImageList
    TransparentColor = clOlive
    Items = <>
    Left = 80
    Top = 280
  end
  object imPayState: TJvImageList
    TransparentColor = clOlive
    Picture.Data = {
      07544269746D617036050000424D360500000000000036040000280000001000
      0000100000000100080000000000000100000000000000000000000100000000
      000000000000FFFFFF000085100000B8290000FF5A0000808000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000050505050505050505050505050505050505050505060305060305050505
      0505050505020202030202030205050505050505020303030303030303030205
      0505050503050506030506030503030505050505050505060305060305020305
      0505050505050506030506030502030505050505050502020202020202030305
      0505050505020203030303030303050505050505020303030303030303050505
      0505050503020505030506030505050505050505030205050305060305050205
      0505050503030202030202030203030505050505050303040303040303030505
      0505050505050606030506030505050505050505050505050505050505050505
      0505}
    Items = <>
    Left = 120
    Top = 280
  end
  object imDisOrdState: TJvImageList
    TransparentColor = clOlive
    Items = <>
    Left = 92
    Top = 146
  end
  object imDisPayState: TJvImageList
    TransparentColor = clOlive
    Items = <>
    Left = 128
    Top = 146
  end
  object imDisProcessState: TJvImageList
    TransparentColor = clOlive
    Items = <>
    Left = 52
    Top = 146
  end
  object imProcessState: TJvImageList
    TransparentColor = clOlive
    Items = <>
    Left = 40
    Top = 280
  end
  object dsCust: TDataSource
    Left = 84
    Top = 4
  end
end
