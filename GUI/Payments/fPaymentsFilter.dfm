inherited PaymentsFilterFrame: TPaymentsFilterFrame
  inherited Bevel1: TBevel
    ExplicitHeight = 685
  end
  inherited ScrollBox1: TScrollBox
    VertScrollBar.Position = 418
    inherited paFilterHdr: TPanel
      Top = -418
      ExplicitTop = -418
    end
    inherited gbMonthYear: TJvgGroupBox
      Top = -400
      ExplicitTop = -400
      FullHeight = 251
    end
    inherited gbCust: TJvgGroupBox
      Top = -117
      ExplicitTop = -117
      FullHeight = 17
    end
    inherited gbComment: TJvgGroupBox
      Top = 237
      ExplicitTop = 237
      FullHeight = 68
    end
    inherited gbCreator: TJvgGroupBox
      Top = 270
      Border.Sides = [fsdLeft, fsdTop, fsdRight]
      CaptionBorder.Sides = [fsdLeft, fsdTop, fsdRight]
      ExplicitTop = 270
      FullHeight = 52
    end
    inherited gbNum: TJvgGroupBox
      Top = 253
      ExplicitTop = 253
      FullHeight = 100
    end
    inherited gbOrdState: TJvgGroupBox
      Top = 48
      ExplicitTop = 48
      FullHeight = 172
    end
    inherited gbPayState: TJvgGroupBox
      Top = 220
      ExplicitTop = 220
      FullHeight = 131
    end
    inherited gbOrderKind: TJvgGroupBox
      Top = -151
      ExplicitTop = -151
      FullHeight = 130
    end
    inherited gbProcess: TJvgGroupBox
      Top = -134
      ExplicitTop = -134
      FullHeight = 66
    end
    inherited gbProcessState: TJvgGroupBox
      Top = -100
      ExplicitTop = -100
      FullHeight = 119
    end
    object gbPayType: TJvgGroupBox
      Left = 0
      Top = 287
      Width = 163
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
        ItemHeight = 13
        TabOrder = 0
        OnChange = cbPayTypeChange
      end
    end
  end
end
