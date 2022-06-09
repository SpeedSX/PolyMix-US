inherited ProcessEditorFrame: TProcessEditorFrame
  inherited paHeaderPanel: TJvGradientHeaderPanel
    ExplicitWidth = 451
  end
  object paProcessParams: TPanel
    Left = 0
    Top = 25
    Width = 451
    Height = 279
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object Panel13: TPanel
      Left = 0
      Top = 0
      Width = 451
      Height = 99
      Align = alTop
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 0
      object btAddGrid: TSpeedButton
        Left = 6
        Top = 68
        Width = 124
        Height = 25
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1072#1073#1083#1080#1094#1091'...'
        OnClick = btAddGridClick
      end
      object btEditSrv: TButton
        Left = 6
        Top = 37
        Width = 124
        Height = 25
        Caption = #1057#1074#1086#1081#1089#1090#1074#1072'...'
        TabOrder = 0
        OnClick = btEditSrvClick
      end
      object btCode: TBitBtn
        Left = 145
        Top = 36
        Width = 130
        Height = 25
        Caption = #1057#1094#1077#1085#1072#1088#1080#1080'...'
        TabOrder = 1
        OnClick = btCodeClick
      end
      object btStruct: TBitBtn
        Left = 145
        Top = 68
        Width = 130
        Height = 25
        Caption = #1057#1090#1088#1091#1082#1090#1091#1088#1072' '#1076#1072#1085#1085#1099#1093'...'
        TabOrder = 2
        OnClick = btStructClick
      end
      object btCreateTriggers: TBitBtn
        Left = 291
        Top = 36
        Width = 118
        Height = 25
        Caption = #1057#1086#1079#1076#1072#1090#1100' '#1090#1088#1080#1075#1075#1077#1088#1099
        TabOrder = 3
        OnClick = btCreateTriggersClick
      end
    end
  end
  object pmProcess: TPopupMenu
    Left = 336
    Top = 62
    object N10: TMenuItem
      Caption = #1057#1074#1086#1081#1089#1090#1074#1072'...'
      OnClick = btEditSrvClick
    end
    object N8: TMenuItem
      Caption = #1057#1090#1088#1091#1082#1090#1091#1088#1072' '#1076#1072#1085#1085#1099#1093'...'
      OnClick = btStructClick
    end
    object N9: TMenuItem
      Caption = #1057#1094#1077#1085#1072#1088#1080#1080'...'
      OnClick = btCodeClick
    end
    object N1: TMenuItem
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1090#1088#1080#1075#1075#1077#1088#1099
      OnClick = btCreateTriggersClick
    end
    object N2: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1072#1073#1083#1080#1094#1091
      OnClick = btAddGridClick
    end
    object N11: TMenuItem
      Caption = '-'
    end
    object miExportProcess: TMenuItem
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1089#1094#1077#1085#1072#1088#1080#1077#1074' '#1087#1088#1086#1094#1077#1089#1089#1072'...'
      OnClick = miExportProcessClick
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object miDelete: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = miDeleteClick
    end
  end
end
