object OrderFilesForm: TOrderFilesForm
  Left = 0
  Top = 0
  Caption = #1055#1088#1080#1082#1088#1077#1087#1083#1077#1085#1085#1099#1077' '#1092#1072#1081#1083#1099
  ClientHeight = 413
  ClientWidth = 471
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  DesignSize = (
    471
    413)
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 14
    Top = 14
    Width = 122
    Height = 13
    Caption = #1055#1088#1080#1082#1088#1077#1087#1083#1077#1085#1085#1099#1077' '#1092#1072#1081#1083#1099':'
  end
  object Label5: TLabel
    Left = 14
    Top = 285
    Width = 53
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
  end
  object dgAttached: TMyDBGridEh
    Left = 14
    Top = 33
    Width = 339
    Height = 240
    AllowedOperations = []
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoFitColWidths = True
    DataGrouping.GroupLevels = <>
    DrawMemoText = True
    Flat = False
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgColumnResize, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    RowDetailPanel.Color = clBtnFace
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        EditButtons = <>
        FieldName = 'FileName'
        Footers = <>
        Width = 155
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object memoFileDesc: TDBMemo
    Left = 14
    Top = 304
    Width = 339
    Height = 91
    Anchors = [akLeft, akRight, akBottom]
    DataField = 'FileDesc'
    ReadOnly = True
    TabOrder = 1
  end
  object btOpenFile: TBitBtn
    Left = 362
    Top = 33
    Width = 101
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083'...'
    TabOrder = 2
    OnClick = btOpenFileClick
  end
  object btOk: TBitBtn
    Left = 362
    Top = 368
    Width = 101
    Height = 27
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 3
    NumGlyphs = 2
    Spacing = 8
  end
end
