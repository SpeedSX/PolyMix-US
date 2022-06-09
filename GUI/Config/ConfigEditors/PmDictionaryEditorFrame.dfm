inherited DictionaryEditorFrame: TDictionaryEditorFrame
  inherited paHeaderPanel: TJvGradientHeaderPanel
    ExplicitWidth = 451
  end
  object paDicBut: TPanel
    Left = 0
    Top = 263
    Width = 451
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    Visible = False
    object sbNewDic: TSpeedButton
      Left = 6
      Top = 8
      Width = 83
      Height = 25
      Caption = #1053#1086#1074#1099#1081'...'
    end
    object sbEditDic: TSpeedButton
      Left = 96
      Top = 8
      Width = 83
      Height = 25
      Caption = #1057#1074#1086#1081#1089#1090#1074#1072'...'
    end
    object sbDelDic: TSpeedButton
      Left = 186
      Top = 8
      Width = 83
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100'...'
    end
  end
  object paDicFrame: TPanel
    Left = 0
    Top = 25
    Width = 451
    Height = 238
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 2
  end
  object pmDic: TPopupMenu
    Left = 188
    Top = 12
    object miProperties: TMenuItem
      Caption = #1057#1074#1086#1081#1089#1090#1074#1072'...'
      OnClick = miPropertiesClick
    end
    object miDelete: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = miDeleteClick
    end
  end
end
