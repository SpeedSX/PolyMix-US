object PaperSelectForm: TPaperSelectForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1073#1091#1084#1072#1075#1080
  ClientHeight = 313
  ClientWidth = 734
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    734
    313)
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 17
    Top = 8
    Width = 107
    Height = 13
    Caption = #1057#1087#1080#1089#1086#1082' '#1074#1080#1076#1086#1074' '#1073#1091#1084#1072#1075#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 21
    Top = 273
    Width = 34
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1042#1080#1076
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object gdPaperList: TMyDBGridEh
    Left = 8
    Top = 32
    Width = 714
    Height = 225
    DataSource = dsPaperList
    AllowedOperations = [alopInsertEh, alopAppendEh]
    AllowedSelections = [gstNon]
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoFitColWidths = True
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
    FooterFont.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
    ParentFont = False
    ReadOnly = True
    RowDetailPanel.Color = clBtnFace
    RowHeight = 16
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = [fsBold]
    TitleLines = 2
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Name'
        Footers = <>
        Title.Caption = #1055#1086#1088#1076#1091#1082#1094#1080#1103
        Width = 207
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object btCancel: TButton
    Left = 613
    Top = 280
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
    ExplicitLeft = 626
    ExplicitTop = 298
  end
  object btOk: TButton
    Left = 512
    Top = 280
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 3
    ExplicitLeft = 525
    ExplicitTop = 298
  end
  object edPaperFind: TEdit
    Left = 98
    Top = 269
    Width = 184
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 0
    OnChange = edPaperFindChange
  end
  object dsPaperList: TDataSource
  end
  object FormStorage: TJvFormStorage
    AppStoragePath = 'SelectPaperForm\'
    Options = [fpLocation]
    StoredValues = <>
    Left = 488
    Top = 2
  end
end
