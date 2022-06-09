inherited InvoicesFilterFrame: TInvoicesFilterFrame
  Width = 186
  ExplicitWidth = 186
  inherited Bevel1: TBevel
    ExplicitHeight = 521
  end
  inherited ScrollBox1: TScrollBox
    Width = 182
    VertScrollBar.Position = 148
    ExplicitWidth = 182
    inherited paFilterHdr: TPanel
      Top = -148
      Width = 165
      ExplicitTop = -148
      ExplicitWidth = 165
    end
    inherited gbMonthYear: TJvgGroupBox
      Top = -130
      Width = 165
      ExplicitTop = -130
      ExplicitWidth = 165
      FullHeight = 251
    end
    inherited gbCust: TJvgGroupBox
      Top = 170
      Width = 165
      ExplicitTop = 170
      ExplicitWidth = 165
      FullHeight = 80
    end
    inherited gbComment: TJvgGroupBox
      Top = 592
      Width = 165
      ExplicitTop = 592
      ExplicitWidth = 165
      FullHeight = 68
    end
    inherited gbCreator: TJvgGroupBox
      Top = 541
      Width = 165
      Border.Sides = [fsdLeft, fsdTop, fsdRight]
      CaptionBorder.Sides = [fsdLeft, fsdTop, fsdRight]
      ExplicitTop = 541
      ExplicitWidth = 165
      FullHeight = 52
    end
    inherited gbNum: TJvgGroupBox
      Top = 524
      Width = 165
      ExplicitTop = 524
      ExplicitWidth = 165
      FullHeight = 17
    end
    inherited gbOrdState: TJvgGroupBox
      Top = 335
      Width = 165
      ExplicitTop = 335
      ExplicitWidth = 165
      FullHeight = 172
    end
    inherited gbPayState: TJvgGroupBox
      Top = 575
      Width = 165
      ExplicitTop = 575
      ExplicitWidth = 165
      FullHeight = 131
    end
    inherited gbOrderKind: TJvgGroupBox
      Top = 119
      Width = 165
      ExplicitTop = 119
      ExplicitWidth = 165
      FullHeight = 130
    end
    inherited gbProcess: TJvgGroupBox
      Top = 136
      Width = 165
      ExplicitTop = 136
      ExplicitWidth = 165
      FullHeight = 55
    end
    inherited gbProcessState: TJvgGroupBox
      Top = 187
      Width = 165
      ExplicitTop = 187
      ExplicitWidth = 165
      FullHeight = 119
      inherited boxProcessState: TJvxCheckListBox
        Width = 155
        ExplicitWidth = 155
      end
    end
    object gbPayType: TJvgGroupBox
      Left = 0
      Top = 558
      Width = 165
      Height = 17
      Align = alTop
      Caption = #1042#1080#1076' '#1086#1087#1083#1072#1090#1099
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
      OnCollapsed = cbPayTypeChange
      OnExpanded = cbPayTypeChange
      FullHeight = 52
      object cbPayType: TComboBox
        Left = 8
        Top = 23
        Width = 163
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
        OnChange = cbPayTypeChange
      end
    end
    object gbInvoiceNum: TJvgGroupBox
      Left = 0
      Top = 507
      Width = 165
      Height = 17
      Align = alTop
      Caption = #8470' '#1089#1095#1077#1090#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 12
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
      OnCollapsed = cbInvoiceNumClick
      OnExpanded = cbInvoiceNumClick
      FullHeight = 56
      object edInvoiceNum: TEdit
        Left = 6
        Top = 26
        Width = 151
        Height = 21
        TabOrder = 0
        Text = '1'
        OnChange = cbInvoiceNumClick
      end
    end
    object gbPayer: TJvgGroupBox
      Left = 0
      Top = 153
      Width = 165
      Height = 17
      Align = alTop
      Caption = #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 13
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
      OnCollapsed = gbPayerClick
      OnExpanded = gbPayerClick
      FullHeight = 78
      object btPayerSel: TSpeedButton
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
        OnClick = btPayerSelClick
      end
      object lcPayer: TJvDBLookupCombo
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
  end
  inherited imOrdState: TJvImageList
    Left = 78
    Top = 296
  end
end
