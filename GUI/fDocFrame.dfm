inherited DocumentsFrame: TDocumentsFrame
  object dgContract: TMyDBGridEh
    Left = 0
    Top = 0
    Width = 281
    Height = 304
    Align = alClient
    AllowedOperations = []
    AllowedSelections = [gstColumns, gstAll, gstNon]
    DataGrouping.GroupLevels = <>
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = [fsBold]
    Options = [dgTitles, dgIndicator, dgColumnResize, dgRowLines, dgRowSelect, dgCancelOnExit]
    ParentFont = False
    PopupMenu = ContrMenu
    RowDetailPanel.Color = clBtnFace
    RowHeight = 15
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = dgContractDblClick
    OnDrawColumnCell = dgContractDrawColumnCell
    OnEnter = dgContractEnter
    Columns = <
      item
        EditButtons = <>
        FieldName = 'State'
        Footers = <>
        Title.Caption = ' '
        Width = 18
      end
      item
        EditButtons = <>
        FieldName = 'NDoc'
        Footers = <>
        Title.Caption = #8470
        Width = 36
      end
      item
        EditButtons = <>
        FieldName = 'Date'
        Footers = <>
        Title.Caption = #1044#1072#1090#1072
        Width = 68
      end
      item
        EditButtons = <>
        FieldName = 'Name'
        Footers = <>
        Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        Width = 87
      end
      item
        EditButtons = <>
        FieldName = 'CustName'
        Footers = <>
        Title.Caption = #1047#1072#1082#1072#1079#1095#1080#1082
        Width = 193
      end
      item
        EditButtons = <>
        FieldName = 'DocFileName'
        Footers = <>
        Title.Caption = #1060#1072#1081#1083
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object ContrMenu: TPopupMenu
    OnPopup = ContrMenuPopup
    Left = 136
    Top = 168
    object miOpen: TMenuItem
      Caption = #1042' '#1088#1072#1073#1086#1090#1077
      Checked = True
      OnClick = miStateClick
    end
    object miSigned: TMenuItem
      Tag = 1
      Caption = #1044#1086#1075#1086#1074#1086#1088' '#1087#1086#1076#1087#1080#1089#1072#1085
      OnClick = miStateClick
    end
    object miComplete: TMenuItem
      Tag = 2
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090' '#1079#1072#1082#1088#1099#1090
      OnClick = miStateClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miContrProp: TMenuItem
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099'...'
      OnClick = dgContractDblClick
    end
    object miMakeContrTempl: TMenuItem
      Caption = #1057#1076#1077#1083#1072#1090#1100' '#1096#1072#1073#1083#1086#1085#1086#1084'...'
      Enabled = False
    end
    object miDeleteDoc: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100'...'
      OnClick = miDeleteDocClick
    end
  end
end
