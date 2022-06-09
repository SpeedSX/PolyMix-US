object frPageCost: TfrPageCost
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  AutoSize = True
  TabOrder = 0
  Visible = False
  object Panel1: TPanel
    Left = 0
    Top = 265
    Width = 451
    Height = 39
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    Visible = False
    object btAddProcess: TBitBtn
      Left = 8
      Top = 8
      Width = 97
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 0
    end
    object btDeleteProcess: TBitBtn
      Left = 120
      Top = 8
      Width = 93
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100'...'
      TabOrder = 1
    end
  end
  object paPageCost: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 265
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    OnResize = paPageCostResize
    object dgPageCost: TMyDBGridEh
      Left = 5
      Top = 27
      Width = 446
      Height = 238
      Align = alClient
      AllowedOperations = []
      AllowedSelections = [gstRecordBookmarks]
      AutoFitColWidths = True
      BorderStyle = bsNone
      DataGrouping.GroupLevels = <>
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'Tahoma'
      FooterFont.Style = []
      Options = [dgTitles, dgColumnResize, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghResizeWholeRightPart, dghHighlightFocus, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
      ReadOnly = True
      RowDetailPanel.Color = clBtnFace
      RowHeight = 15
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      TitleHeight = 14
      OnGetCellParams = dgPageCostGetCellParams
      Columns = <
        item
          EditButtons = <>
          EndEllipsis = True
          FieldName = 'PageCaption'
          Footers = <>
          Layout = tlCenter
          Title.Caption = #1055#1088#1086#1094#1077#1089#1089#1099
          Width = 117
        end
        item
          EditButtons = <>
          EndEllipsis = True
          FieldName = 'PageCost'
          Footers = <>
          Layout = tlCenter
          Title.Alignment = taRightJustify
          Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
          Width = 68
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 27
      Width = 5
      Height = 238
      Align = alLeft
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 1
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 451
      Height = 27
      Align = alTop
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 2
      Visible = False
      object Label1: TLabel
        Left = 4
        Top = 7
        Width = 19
        Height = 13
        Caption = #1042#1080#1076
      end
      object cbViewKind: TComboBox
        Left = 30
        Top = 4
        Width = 171
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
      end
    end
  end
end
