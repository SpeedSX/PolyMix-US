object SelectInvoiceForm: TSelectInvoiceForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1089#1095#1077#1090#1072'-'#1092#1072#1082#1090#1091#1088#1099
  ClientHeight = 225
  ClientWidth = 567
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    567
    225)
  PixelsPerInch = 96
  TextHeight = 13
  object dgInvoices: TMyDBGridEh
    Left = 8
    Top = 10
    Width = 550
    Height = 173
    AllowedOperations = []
    AllowedSelections = [gstNon]
    Anchors = [akLeft, akTop, akRight, akBottom]
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
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
    ParentFont = False
    ReadOnly = True
    RowDetailPanel.Color = clBtnFace
    RowHeight = 16
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        EditButtons = <>
        FieldName = 'InvoiceNum'
        Footers = <>
        Title.Caption = #8470
        Width = 74
      end
      item
        EditButtons = <>
        FieldName = 'InvoiceDate'
        Footers = <>
        Title.Caption = #1044#1072#1090#1072
        Width = 70
      end
      item
        EditButtons = <>
        FieldName = 'InvoiceCost'
        Footers = <>
        Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
        Width = 63
      end
      item
        EditButtons = <>
        FieldName = 'CustomerName'
        Footers = <>
        Title.Caption = #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082
        Width = 113
      end
      item
        EditButtons = <>
        FieldName = 'OrderNumber'
        Footers = <>
        Title.Caption = #8470' '#1079#1072#1082#1072#1079#1072
        Width = 70
      end
      item
        EditButtons = <>
        FieldName = 'ItemText'
        Footers = <>
        Title.Caption = #1055#1088#1086#1076#1091#1082#1094#1080#1103
        Width = 130
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object btOk: TButton
    Left = 400
    Top = 192
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 1
    ExplicitLeft = 283
    ExplicitTop = 190
  end
  object btCancel: TButton
    Left = 484
    Top = 192
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
    ExplicitLeft = 367
    ExplicitTop = 190
  end
end
