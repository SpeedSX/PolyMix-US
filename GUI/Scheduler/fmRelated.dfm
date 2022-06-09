object RelatedProcessGridFrame: TRelatedProcessGridFrame
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  TabOrder = 0
  object dgProcess: TMyDBGridEh
    Left = 0
    Top = 0
    Width = 451
    Height = 304
    Align = alClient
    AutoFitColWidths = True
    DataGrouping.GroupLevels = <>
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghHighlightFocus, dghClearSelection, dghDialogFind, dghColumnResize, dghColumnMove]
    ReadOnly = True
    RowDetailPanel.Color = clBtnFace
    RowHeight = 16
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    TitleHeight = 12
    UseMultiTitle = True
    VTitleMargin = 3
    OnDrawColumnCell = dgProcessDrawColumnCell
    Columns = <
      item
        EditButtons = <>
        FieldName = 'ExecState'
        Footers = <>
        MaxWidth = 18
        MinWidth = 18
        Title.Caption = '*'
        Width = 18
      end
      item
        Alignment = taCenter
        EditButtons = <>
        FieldName = 'ContractorProcess'
        Footers = <>
        MaxWidth = 18
        MinWidth = 18
        Title.Caption = #1057
        Width = 18
      end
      item
        EditButtons = <>
        FieldName = 'CreationDate'
        Footers = <>
        Title.Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1079#1072#1082#1072#1079#1072
        Width = 90
      end
      item
        EditButtons = <>
        FieldName = 'ItemDesc'
        Footers = <>
        Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        Width = 265
      end
      item
        EditButtons = <>
        FieldName = 'PartName'
        Footers = <>
        Title.Caption = #1063#1072#1089#1090#1100
        Width = 62
      end
      item
        Alignment = taCenter
        EditButtons = <>
        FieldName = 'ProductOut'
        Footers = <>
        Title.Caption = #1050#1086#1083'-'#1074#1086
      end
      item
        DisplayFormat = 'dd.mm.yyyy hh:nn'
        EditButtons = <>
        FieldName = 'AnyStartDate'
        Footers = <>
        Title.Caption = #1053#1072#1095#1072#1083#1086
        Width = 94
      end
      item
        DisplayFormat = 'dd.mm.yyyy hh:nn'
        EditButtons = <>
        FieldName = 'AnyFinishDate'
        Footers = <>
        Title.Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077
        Width = 105
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object imStates: TImageList
    Left = 76
    Top = 44
  end
end
