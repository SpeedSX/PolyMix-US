object StructForm: TStructForm
  Left = 290
  Top = 339
  BorderStyle = bsDialog
  Caption = #1057#1090#1088#1091#1082#1090#1091#1088#1072' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 405
  ClientWidth = 667
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    667
    405)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 6
    Width = 84
    Height = 13
    Caption = #1055#1086#1083#1103' '#1090#1072#1073#1083#1080#1094#1099
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbFieldStatus: TLabel
    Left = 502
    Top = 66
    Width = 96
    Height = 13
    Caption = #1055#1086#1074#1077#1076#1077#1085#1080#1077' '#1087#1086#1083#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbFieldType: TLabel
    Left = 502
    Top = 20
    Width = 51
    Height = 13
    Caption = #1058#1080#1087' '#1087#1086#1083#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbDisplayFormat: TLabel
    Left = 502
    Top = 214
    Width = 109
    Height = 13
    Caption = #1060#1086#1088#1084#1072#1090' '#1086#1090#1086#1073#1088#1072#1078#1077#1085#1080#1103
  end
  object lbEditFormat: TLabel
    Left = 502
    Top = 258
    Width = 126
    Height = 13
    Caption = #1060#1086#1088#1084#1072#1090' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103
  end
  object lbLookupDic: TLabel
    Left = 502
    Top = 114
    Width = 81
    Height = 13
    Caption = #1055#1086' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1091
  end
  object lbLookupKey: TLabel
    Left = 502
    Top = 160
    Width = 79
    Height = 13
    Caption = #1050#1083#1102#1095#1077#1074#1086#1077' '#1087#1086#1083#1077
  end
  object dgStruct: TMyDBGridEh
    Left = 12
    Top = 21
    Width = 483
    Height = 348
    AllowedSelections = [gstRecordBookmarks]
    DataGrouping.GroupLevels = <>
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
    OnGetCellParams = dgStructGetCellParams
    Columns = <
      item
        EditButtons = <>
        FieldName = 'ID'
        Footers = <>
        ReadOnly = True
        Title.Caption = #8470
        Width = 23
      end
      item
        Checkboxes = True
        EditButtons = <>
        FieldName = 'CalcTotal'
        Footers = <>
        Title.Caption = #1057#1091#1084'.'
        Width = 27
      end
      item
        EditButtons = <>
        FieldName = 'FieldDesc'
        Footers = <>
        Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        Width = 128
      end
      item
        EditButtons = <>
        FieldName = 'FieldName'
        Footers = <>
        Title.Caption = #1048#1084#1103
        Width = 97
      end
      item
        ButtonStyle = cbsNone
        EditButtons = <>
        FieldName = 'FieldType'
        Footers = <>
        ReadOnly = True
        Title.Caption = #1058#1080#1087
        Width = 94
      end
      item
        EditButtons = <>
        FieldName = 'Length'
        Footers = <>
        Title.Caption = #1044#1083#1080#1085#1072
        Width = 39
      end
      item
        EditButtons = <>
        FieldName = 'Precision'
        Footers = <>
        Title.Caption = #1058#1086#1095#1085'.'
        Width = 35
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object btOk: TButton
    Left = 304
    Top = 376
    Width = 93
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 1
  end
  object btAdd: TButton
    Left = 12
    Top = 376
    Width = 87
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 2
    OnClick = btAddClick
  end
  object btDelete: TButton
    Left = 106
    Top = 376
    Width = 87
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 3
    OnClick = btDeleteClick
  end
  object btCancelOrClose: TButton
    Left = 408
    Top = 376
    Width = 87
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
  end
  object cbFieldType: TComboBox
    Left = 503
    Top = 36
    Width = 129
    Height = 21
    Style = csDropDownList
    DropDownCount = 10
    ItemHeight = 13
    TabOrder = 5
    OnChange = cbFieldTypeChange
    Items.Strings = (
      #1062#1077#1083#1099#1081' '
      #1044#1077#1085#1077#1078#1085#1099#1081' '
      #1057#1090#1088#1086#1082#1072' '
      #1051#1086#1075#1080#1095#1077#1089#1082#1080#1081' '
      #1042#1077#1097#1077#1089#1090#1074#1077#1085#1085#1099#1081' '
      #1050#1086#1088#1086#1090#1082#1080#1081' '#1094#1077#1083#1099#1081
      #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103
      #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      #1058#1077#1082#1089#1090#1086#1074#1099#1081
      #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082
      #1055#1088#1086#1094#1077#1089#1089
      #1058#1072#1073#1083#1080#1094#1072' '#1087#1088#1086#1094#1077#1089#1089#1072
      '<'#1085#1077' '#1086#1087#1088#1077#1076#1077#1083#1077#1085'>')
  end
  object cbFieldStatus: TComboBox
    Left = 502
    Top = 84
    Width = 129
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    OnChange = cbFieldStatusChange
    Items.Strings = (
      #1057#1090#1072#1085#1076#1072#1088#1090#1085#1086#1077
      #1042#1080#1088#1090#1091#1072#1083#1100#1085#1086#1077
      #1042#1099#1095#1080#1089#1083#1103#1077#1084#1086#1077
      #1053#1077#1079#1072#1074#1080#1089#1080#1084#1086#1077)
  end
  object edDisplayFormat: TDBEdit
    Left = 502
    Top = 230
    Width = 129
    Height = 21
    DataField = 'DisplayFormat'
    TabOrder = 7
  end
  object edEditFormat: TDBEdit
    Left = 502
    Top = 274
    Width = 129
    Height = 21
    DataField = 'EditFormat'
    TabOrder = 8
  end
  object cbNotForCopy: TDBCheckBox
    Left = 502
    Top = 306
    Width = 125
    Height = 17
    Caption = #1053#1077' '#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100
    DataField = 'NotForCopy'
    TabOrder = 9
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object cbGetText: TDBCheckBox
    Left = 502
    Top = 328
    Width = 97
    Height = 17
    Caption = 'OnGetText'
    DataField = 'CustomGetText'
    TabOrder = 10
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object cbCalcTotal: TDBCheckBox
    Left = 502
    Top = 350
    Width = 143
    Height = 17
    Caption = #1057#1091#1084#1084#1080#1088#1086#1074#1072#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1103
    DataField = 'CalcTotal'
    TabOrder = 11
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object cmbLookupDic: TDBLookupComboBox
    Left = 500
    Top = 132
    Width = 161
    Height = 21
    DataField = 'LookupDicID'
    KeyField = 'DicID'
    ListField = 'DicDesc'
    ListSource = dsDics
    TabOrder = 12
  end
  object cmbLookupKey: TDBLookupComboBox
    Left = 502
    Top = 178
    Width = 161
    Height = 21
    DataField = 'LookupKeyField'
    KeyField = 'FieldName'
    ListField = 'FieldName'
    TabOrder = 13
  end
  object dsDics: TDataSource
    Left = 624
    Top = 108
  end
end
