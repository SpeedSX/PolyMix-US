inherited OrderPaymentsForm: TOrderPaymentsForm
  Caption = #1054#1087#1083#1072#1090#1099' '#1079#1072#1082#1072#1079#1072
  ClientHeight = 275
  ClientWidth = 517
  OnCreate = FormCreate
  ExplicitWidth = 523
  ExplicitHeight = 307
  PixelsPerInch = 96
  TextHeight = 13
  inherited btOk: TButton
    Left = 341
    Top = 240
    ExplicitLeft = 341
    ExplicitTop = 240
  end
  inherited btCancel: TButton
    Left = 430
    Top = 240
    ExplicitLeft = 430
    ExplicitTop = 240
  end
  object dgPayments: TMyDBGridEh [2]
    Left = 10
    Top = 10
    Width = 494
    Height = 220
    AllowedOperations = [alopAppendEh]
    AllowedSelections = [gstNon]
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoFitColWidths = True
    ColumnDefValues.Layout = tlCenter
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
    MinAutoFitWidth = 60
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
    ParentFont = False
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
        FieldName = 'PayDate'
        Footers = <>
        Title.Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
        Width = 93
      end
      item
        EditButtons = <>
        FieldName = 'PayCost'
        Footers = <>
        Title.Caption = #1054#1087#1083#1072#1095#1077#1085#1086', '#1075#1088#1085
        Width = 84
      end
      item
        EditButtons = <>
        FieldName = 'PayTypeName'
        Footers = <>
        Title.Caption = #1042#1080#1076' '#1086#1087#1083#1072#1090#1099
        Width = 87
      end
      item
        EditButtons = <>
        FieldName = 'InvoiceNum'
        Footers = <>
        Title.Caption = #8470' '#1089#1095#1077#1090#1072
      end
      item
        EditButtons = <>
        FieldName = 'ContragentName'
        Footers = <>
        Title.Caption = #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082
        Width = 135
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object btDelete: TButton [3]
    Left = 10
    Top = 240
    Width = 77
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 3
    OnClick = btDeleteClick
  end
  object btLocateIncome: TButton [4]
    Left = 98
    Top = 240
    Width = 149
    Height = 25
    Caption = #1055#1077#1088#1077#1081#1090#1080' '#1082' '#1087#1086#1089#1090#1091#1087#1083#1077#1085#1080#1102
    ModalResult = 1
    TabOrder = 4
    OnClick = btLocateIncomeClick
  end
end
