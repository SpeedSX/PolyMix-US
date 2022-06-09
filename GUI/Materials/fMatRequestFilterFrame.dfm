inherited MatRequestFilterFrame: TMatRequestFilterFrame
  Width = 197
  ExplicitWidth = 197
  inherited Bevel1: TBevel
    ExplicitHeight = 475
  end
  inherited ScrollBox1: TScrollBox
    Width = 193
    VertScrollBar.Position = 0
    ExplicitWidth = 193
    inherited paFilterHdr: TPanel
      Top = 0
      Width = 176
      ExplicitTop = 0
      ExplicitWidth = 176
    end
    inherited gbMonthYear: TJvgGroupBox
      Top = 18
      Width = 176
      ExplicitTop = 18
      ExplicitWidth = 176
      FullHeight = 251
    end
    inherited gbCust: TJvgGroupBox
      Top = 413
      Width = 176
      ExplicitTop = 413
      ExplicitWidth = 176
      FullHeight = 77
    end
    inherited gbComment: TJvgGroupBox
      Top = 767
      Width = 176
      ExplicitTop = 767
      ExplicitWidth = 176
      FullHeight = 68
    end
    inherited gbCreator: TJvgGroupBox
      Top = 800
      Width = 176
      ExplicitTop = 800
      ExplicitWidth = 176
      FullHeight = 52
    end
    inherited gbNum: TJvgGroupBox
      Top = 783
      Width = 176
      ExplicitTop = 783
      ExplicitWidth = 176
      FullHeight = 100
    end
    inherited gbOrdState: TJvgGroupBox
      Top = 578
      Width = 176
      ExplicitTop = 578
      ExplicitWidth = 176
      FullHeight = 172
    end
    inherited gbPayState: TJvgGroupBox
      Top = 750
      Width = 176
      ExplicitTop = 750
      ExplicitWidth = 176
      FullHeight = 131
    end
    inherited gbOrderKind: TJvgGroupBox
      Top = 267
      Width = 176
      ExplicitTop = 267
      ExplicitWidth = 176
      FullHeight = 130
    end
    inherited gbProcess: TJvgGroupBox
      Top = 284
      Width = 176
      ExplicitTop = 284
      ExplicitWidth = 176
      FullHeight = 66
    end
    inherited gbProcessState: TJvgGroupBox
      Top = 430
      Width = 176
      ExplicitTop = 430
      ExplicitWidth = 176
      FullHeight = 119
      inherited boxProcessState: TJvxCheckListBox
        Width = 183
        ExplicitWidth = 183
      end
    end
    inherited gbExternalId: TJvgGroupBox
      Top = 301
      Width = 176
      TabOrder = 14
      ExplicitLeft = 0
      ExplicitTop = 301
      ExplicitWidth = 176
      FullHeight = 52
    end
    object gbSupplier: TJvgGroupBox
      Left = 0
      Top = 318
      Width = 176
      Height = 17
      Align = alTop
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
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
      OnCollapsed = gbSupplierClick
      OnExpanded = gbSupplierClick
      FullHeight = 101
      object btSupplierSelect: TSpeedButton
        Left = 33
        Top = 72
        Width = 122
        Height = 25
        Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082#1080'...'
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
        OnClick = btSupplierSelectClick
      end
      object lkSupplier: TJvDBLookupCombo
        Left = 4
        Top = 22
        Width = 150
        Height = 21
        DropDownWidth = 200
        DisplayEmpty = '<'#1085#1077' '#1091#1082#1072#1079#1072#1085'>'
        ItemHeight = 17
        LookupField = 'N'
        LookupDisplay = 'Name'
        LookupSource = dsSupplier
        TabOrder = 0
        OnChange = lkSupplierChange
        OnGetImage = lkSupplierGetImage
      end
      object cbSupplierInvert: TCheckBox
        Left = 14
        Top = 49
        Width = 97
        Height = 17
        Caption = #1053#1077' '#1089#1086#1076#1077#1088#1078#1072#1097#1080#1077
        TabOrder = 1
        OnClick = lkSupplierChange
      end
    end
    object gbMatCat: TJvgGroupBox
      Left = 0
      Top = 396
      Width = 176
      Height = 17
      Align = alTop
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1084#1072#1090#1077#1088#1080#1072#1083#1072
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
      OnCollapsed = cbMatCatClick
      OnExpanded = cbMatCatClick
      FullHeight = 52
      object cbMatCat: TComboBox
        Left = 8
        Top = 23
        Width = 163
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = cbMatCatClick
      end
    end
    object gbMatGroup: TJvgGroupBox
      Left = 0
      Top = 335
      Width = 176
      Height = 61
      Align = alTop
      Caption = #1043#1088#1091#1087#1087#1072' '#1084#1072#1090#1077#1088#1080#1072#1083#1072
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
      OnCollapsed = gbMatGroupClick
      OnExpanded = gbMatGroupClick
      DesignSize = (
        176
        61)
      FullHeight = 61
      object boxMatGroup: TJvxCheckListBox
        Left = 4
        Top = 21
        Width = 183
        Height = 36
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
        ParentColor = True
        ParentFont = False
        Style = lbOwnerDrawFixed
        TabOrder = 0
        OnClickCheck = gbMatGroupClick
        InternalVersion = 202
      end
    end
  end
  inherited imOrdState: TJvImageList
    Left = 98
    Top = 242
  end
  inherited imPayState: TJvImageList
    Left = 126
    Top = 238
  end
  inherited imDisOrdState: TJvImageList
    Left = 90
    Top = 66
  end
  inherited imDisPayState: TJvImageList
    Left = 126
    Top = 66
  end
  inherited imDisProcessState: TJvImageList
    Left = 50
    Top = 66
  end
  inherited imProcessState: TJvImageList
    Left = 144
    Top = 212
  end
  object dsSupplier: TDataSource
    Left = 86
    Top = 8
  end
end
