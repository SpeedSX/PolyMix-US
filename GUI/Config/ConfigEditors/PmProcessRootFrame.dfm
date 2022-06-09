inherited ProcessRootEditorFrame: TProcessRootEditorFrame
  inherited paHeaderPanel: TJvGradientHeaderPanel
    ExplicitWidth = 451
  end
  object pmProcessRoot: TPopupMenu
    Left = 338
    Top = 130
    object miAddProcess: TMenuItem
      Caption = #1053#1086#1074#1099#1081' '#1087#1088#1086#1094#1077#1089#1089'...'
      OnClick = miAddProcessClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object miExportScripts: TMenuItem
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1089#1094#1077#1085#1072#1088#1080#1077#1074'...'
      OnClick = miExportScriptsClick
    end
    object miImportScripts: TMenuItem
      Caption = #1048#1084#1087#1086#1088#1090' '#1089#1094#1077#1085#1072#1088#1080#1077#1074'...'
      OnClick = miImportScriptsClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object miCreateAllTriggers: TMenuItem
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1090#1088#1080#1075#1075#1077#1088#1099
      OnClick = miCreateAllTriggersClick
    end
  end
end
