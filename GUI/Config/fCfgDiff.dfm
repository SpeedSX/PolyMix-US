object CfgDiffForm: TCfgDiffForm
  Left = 356
  Top = 286
  Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1082#1086#1085#1092#1080#1075#1091#1088#1072#1094#1080#1080
  ClientHeight = 335
  ClientWidth = 656
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 304
    Width = 656
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    DesignSize = (
      656
      31)
    object btOk: TButton
      Left = 492
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btCancel: TButton
      Left = 574
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
    object btDiff: TButton
      Left = 10
      Top = 2
      Width = 97
      Height = 25
      Caption = 'Diff'
      TabOrder = 2
      OnClick = btDiffClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 656
    Height = 304
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 10
    Caption = ' '
    TabOrder = 1
    object dgDiff: TMyDBGridEh
      Left = 10
      Top = 10
      Width = 636
      Height = 284
      Align = alClient
      AllowedOperations = [alopUpdateEh]
      DataGrouping.GroupLevels = <>
      DataSource = dsDiff
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'Tahoma'
      FooterFont.Style = []
      OptionsEh = [dghHighlightFocus, dghClearSelection, dghDialogFind, dghColumnResize, dghColumnMove]
      RowDetailPanel.Color = clBtnFace
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDrawColumnCell = dgDiffDrawColumnCell
      OnGetCellParams = dgDiffGetCellParams
      IniStorage = FormStorage
      Columns = <
        item
          EditButtons = <>
          FieldName = 'Checked'
          Footers = <>
          Title.Caption = ' '
          Width = 20
        end
        item
          EditButtons = <>
          FieldName = 'ScriptName'
          Footers = <>
          Width = 117
          OnGetCellParams = dgDiffColumns1GetCellParams
        end
        item
          EditButtons = <>
          FieldName = 'ScriptDesc'
          Footers = <>
          Width = 130
        end
        item
          Alignment = taRightJustify
          EditButtons = <>
          FieldName = 'CurDate'
          Footers = <>
          Width = 78
          OnGetCellParams = dgDiffColumns3GetCellParams
        end
        item
          EditButtons = <>
          FieldName = 'FileState'
          Footers = <>
          ReadOnly = True
          Title.Caption = '*'
          Width = 17
        end
        item
          EditButtons = <>
          FieldName = 'FileDate'
          Footers = <>
          Width = 90
          OnGetCellParams = dgDiffColumns5GetCellParams
        end
        item
          EditButtons = <>
          FieldName = 'FileName'
          Footers = <>
          Width = 144
          OnGetCellParams = dgDiffColumnsFileNameGetCellParams
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object dsDiff: TDataSource
    Left = 184
    Top = 84
  end
  object StateClip: TJvPicClip
    Cols = 4
    Picture.Data = {
      07544269746D61705E020000424D5E020000000000005E000000280000004000
      0000100000000100040000000000000200004D0C00004D0C00000A0000000A00
      0000FFFFFF0000FFFF00FF00FF000000FF00FFFF000000FF0000FF0000000000
      000000CC00000066FF0022222222222222222222222222222222222222222222
      2222222222222222222222222222222222222222222222222222222222222222
      2222222222222222222222222222222222222222222222222222222222222222
      2222222222222222222222222222222222222222222222222222222222222222
      2222222222222222222222222222922222222222222282222222222222262222
      2222222222232222222222222222992222222222222288222222222222662222
      2222222222332222222222222222999222222222222288822222222226662222
      2222222223332222222222299999999922222228888888882222222266666666
      6222222233333333322222299999999992222228888888888222222666666666
      6222222333333333322222299999999922222228888888882222222266666666
      6222222233333333322222222222999222222222222288822222222226662222
      2222222223332222222222222222992222222222222288222222222222662222
      2222222222332222222222222222922222222222222282222222222222262222
      2222222222232222222222222222222222222222222222222222222222222222
      2222222222222222222222222222222222222222222222222222222222222222
      2222222222222222222222222222222222222222222222222222222222222222
      22222222222222222222}
    Left = 140
    Top = 202
  end
  object FormStorage: TJvFormStorage
    AppStoragePath = 'CfgDiffForm\'
    StoredValues = <>
    Left = 346
    Top = 304
  end
end
