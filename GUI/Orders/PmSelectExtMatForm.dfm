object SelectExternalDicForm: TSelectExternalDicForm
  Left = 0
  Top = 0
  Anchors = [akLeft, akTop, akRight, akBottom]
  Caption = #1042#1099#1073#1086#1088' '#1084#1072#1090#1077#1088#1080#1072#1083#1072
  ClientHeight = 247
  ClientWidth = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 320
  ExplicitHeight = 240
  DesignSize = (
    480
    247)
  PixelsPerInch = 96
  TextHeight = 13
  object btOk: TButton
    Left = 309
    Top = 214
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object btCancel: TButton
    Left = 398
    Top = 214
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object dgExtDic: TMyDBGridEh
    Left = 28
    Top = 30
    Width = 443
    Height = 177
    AllowedSelections = [gstAll, gstNon]
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoFitColWidths = True
    DataGrouping.GroupLevels = <>
    DataSource = dsExtDic
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghPreferIncSearch, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
    ReadOnly = True
    RowDetailPanel.Color = clBtnFace
    RowHeight = 17
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Name'
        Footers = <>
        Title.Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
        Width = 373
      end
      item
        EditButtons = <>
        FieldName = 'Code'
        Footers = <>
        Title.Caption = #1050#1086#1076
        Width = 50
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object rbNotSelected: TRadioButton
    Left = 10
    Top = 8
    Width = 93
    Height = 17
    Caption = ' '#1053#1077' '#1074#1099#1073#1088#1072#1085
    TabOrder = 3
    OnClick = rbSelectedClick
  end
  object rbSelected: TRadioButton
    Left = 10
    Top = 32
    Width = 15
    Height = 17
    TabOrder = 4
    OnClick = rbSelectedClick
  end
  object dsExtDic: TDataSource
    Left = 10
    Top = 214
  end
end
