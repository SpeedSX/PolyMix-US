object DocFrame: TDocFrame
  Left = 0
  Top = 0
  Width = 355
  Height = 304
  Align = alLeft
  TabOrder = 0
  object paDocInfo: TPanel
    Left = 0
    Top = 0
    Width = 355
    Height = 304
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    Visible = False
    ExplicitHeight = 277
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 355
      Height = 41
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = ' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object Label112: TLabel
        Left = 0
        Top = 26
        Width = 151
        Height = 13
        Caption = #1044#1086#1087#1086#1083#1085#1077#1085#1080#1103' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1091
      end
      object Label113: TLabel
        Left = 2
        Top = 6
        Width = 79
        Height = 13
        Caption = #1060#1072#1081#1083' '#1096#1072#1073#1083#1086#1085#1072':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object DBText1: TDBText
        Left = 86
        Top = 6
        Width = 42
        Height = 13
        AutoSize = True
        DataField = 'DocFileName'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
    end
    object dgAdd: TJvDBGrid
      Left = 0
      Top = 41
      Width = 355
      Height = 124
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      ParentFont = False
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = [fsBold]
      OnDrawColumnCell = dgAddDrawColumnCell
      OnDblClick = dgEditContrAddClick
      OnEnter = dgOrdersEnter
      OnKeyDown = dgKeyDown
      SelectColumnsDialogStrings.Caption = 'Select columns'
      SelectColumnsDialogStrings.OK = '&OK'
      SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
      EditControls = <>
      RowsHeight = 17
      TitleRowHeight = 17
      Columns = <
        item
          Expanded = False
          FieldName = 'State'
          Title.Caption = ' '
          Width = 19
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Name'
          Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = []
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DocFileName'
          Title.Caption = #1060#1072#1081#1083
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = []
          Width = 96
          Visible = True
        end>
    end
    object RxSplitter3: TJvxSplitter
      Left = 0
      Top = 165
      Width = 355
      Height = 3
      ControlFirst = dgAdd
      Align = alTop
      BevelOuter = bvNone
      Color = clInactiveCaption
    end
    object Panel28: TPanel
      Left = 0
      Top = 168
      Width = 355
      Height = 109
      Align = alClient
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 3
      object dgOrders: TJvDBGrid
        Left = 0
        Top = 19
        Width = 355
        Height = 55
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = [fsBold]
        OnDblClick = dgEditContrAddClick
        OnEnter = dgOrdersEnter
        OnKeyDown = dgKeyDown
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Title.Caption = #1064#1080#1092#1088
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = []
            Width = 81
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TotalCost'
            Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = []
            Width = 76
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CustName'
            Title.Caption = #1047#1072#1082#1072#1079#1095#1080#1082
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = []
            Width = 159
            Visible = True
          end>
      end
      object C: TPanel
        Left = 0
        Top = 0
        Width = 355
        Height = 19
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = #1047#1072#1082#1072#1079#1099' '#1076#1083#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
      object Panel48: TPanel
        Left = 0
        Top = 74
        Width = 355
        Height = 35
        Align = alBottom
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 2
        object sbAddContrOrder: TJvSpeedButton
          Tag = 1
          Left = 6
          Top = 6
          Width = 83
          Height = 25
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'MS Sans Serif'
          HotTrackFont.Style = []
          Layout = blGlyphLeft
          Spacing = 5
          OnClick = sbAddContrOrderClick
        end
        object sbDelContrOrder: TJvSpeedButton
          Tag = 2
          Left = 94
          Top = 6
          Width = 77
          Height = 25
          Caption = #1059#1076#1072#1083#1080#1090#1100
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'MS Sans Serif'
          HotTrackFont.Style = []
          Layout = blGlyphLeft
          Spacing = 5
          OnClick = sbDelContrOrderClick
        end
        object sbEditContrOrder: TJvSpeedButton
          Left = 206
          Top = 6
          Width = 135
          Height = 25
          Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1079#1072#1082#1072#1079#1072'...'
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'MS Sans Serif'
          HotTrackFont.Style = []
          OnClick = dgEditContrAddClick
        end
      end
    end
  end
  object ContrTimer: TTimer
    Enabled = False
    Interval = 10
    OnTimer = ContrTimerTimer
    Left = 156
    Top = 18
  end
end
