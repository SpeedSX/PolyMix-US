inherited DictionaryRootEditorFrame: TDictionaryRootEditorFrame
  object pmDicFolder: TPopupMenu
    Left = 314
    Top = 10
    object miNewDic: TMenuItem
      Caption = #1053#1086#1074#1099#1081' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082'...'
      ImageIndex = 2
      OnClick = miNewDicClick
    end
    object miNewFolder: TMenuItem
      Caption = #1053#1086#1074#1072#1103' '#1087#1072#1087#1082#1072'...'
      ImageIndex = 0
      OnClick = miNewFolderClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miShowInternalName: TMenuItem
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077' '#1080#1084#1077#1085#1072
      OnClick = miShowInternalNameClick
    end
  end
end
