inherited ProcessGridEditorFrame: TProcessGridEditorFrame
  inherited paHeaderPanel: TJvGradientHeaderPanel
    ExplicitWidth = 451
  end
  object btGridProps: TButton
    Left = 8
    Top = 36
    Width = 92
    Height = 25
    Caption = #1057#1074#1086#1081#1089#1090#1074#1072'...'
    TabOrder = 1
    OnClick = btGridPropsClick
  end
  object btCols: TButton
    Left = 112
    Top = 36
    Width = 92
    Height = 25
    Caption = #1057#1090#1086#1083#1073#1094#1099'...'
    TabOrder = 2
    OnClick = btColsClick
  end
  object btGridCode: TButton
    Left = 216
    Top = 36
    Width = 92
    Height = 25
    Caption = #1057#1094#1077#1085#1072#1088#1080#1080'...'
    TabOrder = 3
    OnClick = btGridCodeClick
  end
  object pmProcessGrid: TPopupMenu
    Left = 330
    Top = 52
    object N10: TMenuItem
      Caption = #1057#1074#1086#1081#1089#1090#1074#1072'...'
      OnClick = btGridPropsClick
    end
    object N8: TMenuItem
      Caption = #1057#1090#1086#1083#1073#1094#1099'...'
      OnClick = btColsClick
    end
    object N9: TMenuItem
      Caption = #1057#1094#1077#1085#1072#1088#1080#1080'...'
      OnClick = btGridCodeClick
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object miDelete: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = btDeleteGridClick
    end
  end
  object dsGrids: TDataSource
    Left = 366
    Top = 52
  end
end
