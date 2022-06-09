object OrderProductStorageFrom: TOrderProductStorageFrom
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1087#1088#1086#1076#1091#1082#1094#1080#1080
  ClientHeight = 331
  ClientWidth = 747
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    747
    331)
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 17
    Top = 8
    Width = 107
    Height = 13
    Caption = #1057#1087#1080#1089#1086#1082' '#1087#1088#1086#1076#1091#1082#1094#1080#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 21
    Top = 263
    Width = 34
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1053#1072#1081#1090#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 21
    Top = 289
    Width = 68
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object gdProductList: TMyDBGridEh
    Left = 8
    Top = 32
    Width = 727
    Height = 213
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
      end
      item
        EditButtons = <>
        FieldName = 'A4'
        Footers = <>
        Title.Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1088#1091#1082#1072#1074#1077
        Width = 103
      end
      item
        EditButtons = <>
        FieldName = 'A2'
        Footers = <>
        Title.Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1103#1097#1080#1082#1077
        Width = 105
      end
      item
        EditButtons = <>
        FieldName = 'A3'
        Footers = <>
        Title.Caption = #1056#1072#1079#1084#1077#1088' '#1103#1097#1080#1082#1072
        Width = 102
      end
      item
        EditButtons = <>
        FieldName = 'A1'
        Footers = <>
        Title.Caption = #1062#1077#1085#1072
      end
      item
        EditButtons = <>
        FieldName = 'Count'
        Footers = <>
        Title.Caption = #1050#1086#1083'-'#1074#1086' '#1085#1072' '#1089#1082#1083#1072#1076#1077
        Width = 73
        WordWrap = True
      end
      item
        EditButtons = <>
        FieldName = 'Reserv'
        Footers = <>
        Title.Caption = #1056#1077#1079#1077#1088#1074
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object btCancel: TButton
    Left = 638
    Top = 289
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object btOk: TButton
    Left = 537
    Top = 289
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object edProductFind: TEdit
    Left = 98
    Top = 259
    Width = 184
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 0
    OnChange = edProductFindChange
  end
  object edQty: TJvCalcEdit
    Left = 98
    Top = 286
    Width = 121
    Height = 21
    AutoSize = False
    DecimalPlaces = 0
    DisplayFormat = '0'
    ShowButton = False
    TabOrder = 4
    DecimalPlacesAlwaysShown = False
  end
  object FormStorage: TJvFormStorage
    AppStoragePath = 'SelectProductStorageForm\'
    Options = [fpLocation]
    StoredValues = <>
    Left = 488
    Top = 2
  end
end
