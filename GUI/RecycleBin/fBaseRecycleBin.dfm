inherited BaseRecycleBinFrame: TBaseRecycleBinFrame
  Constraints.MinWidth = 451
  inherited paFilter: TPanel
    Height = 267
    TabOrder = 2
    ExplicitLeft = 281
    ExplicitHeight = 267
  end
  object dgBin: TMyDBGridEh
    Left = 0
    Top = 0
    Width = 281
    Height = 267
    Align = alClient
    DataGrouping.GroupLevels = <>
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
    ReadOnly = True
    RowDetailPanel.Color = clBtnFace
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 267
    Width = 451
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    Visible = False
    object Label1: TLabel
      Left = 28
      Top = 14
      Width = 52
      Height = 13
      Caption = 'INVISIBLE!'
    end
    object Panel2: TPanel
      Left = 118
      Top = 0
      Width = 333
      Height = 37
      Align = alRight
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 0
      object btPurge: TBitBtn
        Left = 107
        Top = 8
        Width = 90
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100'...'
        TabOrder = 0
        OnClick = btPurgeClick
      end
      object btRestore: TBitBtn
        Left = 7
        Top = 8
        Width = 90
        Height = 25
        Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
        TabOrder = 1
        OnClick = btRestoreClick
      end
      object btPurgeAll: TBitBtn
        Left = 207
        Top = 8
        Width = 114
        Height = 25
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1082#1086#1088#1079#1080#1085#1091'...'
        TabOrder = 2
        OnClick = btPurgeAllClick
      end
    end
  end
  object pmRecycleBin: TPopupMenu
    Left = 188
    Top = 140
    object miRestore: TMenuItem
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      OnClick = btRestoreClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object miPurge: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = btPurgeClick
    end
    object miPurgeAll: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1082#1086#1088#1079#1080#1085#1091'...'
      OnClick = btPurgeAllClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miRefresh: TMenuItem
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      OnClick = miRefreshClick
    end
  end
end
