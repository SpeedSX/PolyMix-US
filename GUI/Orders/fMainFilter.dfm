inherited FilterFrame: TFilterFrame
  inherited Bevel1: TBevel
    ExplicitHeight = 615
  end
  inherited ScrollBox1: TScrollBox
    VertScrollBar.Position = 166
    inherited paFilterHdr: TPanel
      Top = -166
      ExplicitTop = -166
    end
    inherited gbMonthYear: TJvgGroupBox
      Top = -148
      ExplicitTop = -148
      FullHeight = 251
      inherited cbDateType: TComboBox
        DropDownCount = 9
      end
    end
    inherited gbCust: TJvgGroupBox
      Top = 135
      ExplicitTop = 135
      FullHeight = 84
    end
    inherited gbComment: TJvgGroupBox
      Top = 203
      ExplicitTop = 203
      FullHeight = 68
    end
    inherited gbCreator: TJvgGroupBox
      Top = 253
      Caption = #1057#1086#1079#1076#1072#1090#1077#1083#1100' '#1079#1072#1082#1072#1079#1072
      ExplicitTop = 253
      FullHeight = 52
    end
    inherited gbEvent: TJvgGroupBox
      Top = 287
      TabOrder = 13
      ExplicitLeft = 0
      FullHeight = 155
    end
    inherited gbNum: TJvgGroupBox
      Top = 219
      ExplicitTop = 219
      FullHeight = 100
    end
    inherited gbOrdState: TJvgGroupBox
      Top = 186
      Height = 17
      Collapsed = True
      ExplicitTop = 186
      ExplicitHeight = 17
      FullHeight = 172
    end
    inherited gbPayState: TJvgGroupBox
      Top = 169
      ExplicitTop = 169
      FullHeight = 131
    end
    inherited gbOrderKind: TJvgGroupBox
      Top = 101
      ExplicitTop = 101
      FullHeight = 130
    end
    inherited gbProcess: TJvgGroupBox
      Top = 152
      ExplicitTop = 152
      FullHeight = 66
    end
    object gbCustomerCreator: TJvgGroupBox [11]
      Left = 0
      Top = 270
      Width = 163
      Height = 17
      Align = alTop
      Caption = #1057#1086#1079#1076#1072#1090#1077#1083#1100' '#1079#1072#1082#1072#1079#1095#1080#1082#1072
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
      OnCollapsed = cbCustomerCreatorClick
      OnExpanded = cbCustomerCreatorClick
      FullHeight = 52
      object cbCustomerCreatorName: TComboBox
        Left = 8
        Top = 23
        Width = 163
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = cbCustomerCreatorClick
      end
    end
    inherited gbProcessState: TJvgGroupBox
      Top = 118
      Height = 17
      Collapsed = True
      ExplicitTop = 118
      ExplicitHeight = 17
      FullHeight = 115
      inherited boxProcessState: TJvxCheckListBox
        Width = 186
        ExplicitWidth = 186
      end
    end
    inherited gbExternalId: TJvgGroupBox
      Top = 236
      ExplicitTop = 236
      FullHeight = 52
    end
  end
  inherited imOrdState: TJvImageList
    Left = 84
    Top = 292
  end
  inherited imPayState: TJvImageList
    Left = 124
    Top = 292
  end
  inherited imDisOrdState: TJvImageList
    Left = 96
    Top = 260
  end
  inherited imDisPayState: TJvImageList
    Left = 132
    Top = 260
  end
end
