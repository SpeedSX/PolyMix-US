object EditProcessGridForm: TEditProcessGridForm
  Left = 175
  Top = 595
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1090#1086#1083#1073#1094#1086#1074' '#1074' '#1090#1072#1073#1083#1080#1094#1077
  ClientHeight = 404
  ClientWidth = 555
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
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 45
    Height = 13
    Caption = #1057#1090#1086#1083#1073#1094#1099
  end
  object Label2: TLabel
    Left = 344
    Top = 20
    Width = 75
    Height = 13
    Caption = #1053#1086#1084#1077#1088' '#1089#1090#1086#1083#1073#1094#1072
  end
  object Label3: TLabel
    Left = 344
    Top = 144
    Width = 55
    Height = 13
    Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072
  end
  object Label4: TLabel
    Left = 344
    Top = 276
    Width = 74
    Height = 13
    Caption = #1042#1099#1088#1072#1074#1085#1080#1074#1072#1085#1080#1077
  end
  object Label5: TLabel
    Left = 344
    Top = 212
    Width = 62
    Height = 13
    Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 344
    Top = 48
    Width = 25
    Height = 13
    Caption = #1055#1086#1083#1077
  end
  object Label7: TLabel
    Left = 344
    Top = 96
    Width = 74
    Height = 13
    Caption = #1042#1099#1088#1072#1074#1085#1080#1074#1072#1085#1080#1077
  end
  object Label8: TLabel
    Left = 344
    Top = 120
    Width = 64
    Height = 13
    Caption = #1062#1074#1077#1090' '#1090#1077#1082#1089#1090#1072
  end
  object Label9: TLabel
    Left = 344
    Top = 300
    Width = 64
    Height = 13
    Caption = #1062#1074#1077#1090' '#1090#1077#1082#1089#1090#1072
  end
  object Label10: TLabel
    Left = 344
    Top = 324
    Width = 55
    Height = 13
    Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072
  end
  object btNew: TSpeedButton
    Left = 8
    Top = 374
    Width = 73
    Height = 25
    Caption = #1053#1086#1074#1099#1081
    OnClick = btNewClick
  end
  object btDel: TSpeedButton
    Left = 88
    Top = 374
    Width = 73
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    OnClick = btDelClick
  end
  object btClear: TSpeedButton
    Left = 168
    Top = 374
    Width = 73
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    OnClick = btClearClick
  end
  object btAddAll: TSpeedButton
    Left = 248
    Top = 374
    Width = 85
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074#1089#1077
    OnClick = btAddAllClick
  end
  object Label11: TLabel
    Left = 8
    Top = 332
    Width = 302
    Height = 26
    Caption = 
      #1041#1091#1076#1100#1090#1077' '#1074#1085#1080#1084#1072#1090#1077#1083#1100#1085#1099' '#1087#1088#1080' '#1091#1082#1072#1079#1072#1085#1080#1080' '#1085#1086#1084#1077#1088#1086#1074' '#1089#1090#1086#1083#1073#1094#1086#1074'!'#13#10#1053#1091#1084#1077#1088#1072#1094#1080#1103' '#1085#1072#1095 +
      #1080#1085#1072#1077#1090#1089#1103' '#1089' 0, '#1087#1088#1086#1087#1091#1097#1077#1085#1085#1099#1093' '#1073#1099#1090#1100' '#1085#1077' '#1076#1086#1083#1078#1085#1086'.'
  end
  object Bevel1: TBevel
    Left = 412
    Top = 212
    Width = 137
    Height = 9
    Shape = bsBottomLine
  end
  object btOk: TButton
    Left = 388
    Top = 374
    Width = 75
    Height = 25
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 0
  end
  object btCancel: TButton
    Left = 472
    Top = 374
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object vgDBSpinEdit1: TJvDBSpinEdit
    Left = 432
    Top = 16
    Width = 61
    Height = 21
    TabOrder = 2
    DataField = 'ColNumber'
    DataSource = sdm.dsSrvGridCols
  end
  object cldbColor: TJvColorComboBox
    Left = 412
    Top = 140
    Width = 139
    Height = 20
    ColorNameMap.Strings = (
      'clBlack='#1063#1077#1088#1085#1099#1081
      'clMaroon='#1058#1077#1084#1085#1086'-'#1082#1088#1072#1089#1085#1099#1081
      'clGreen='#1047#1077#1083#1077#1085#1099#1081
      'clOlive='#1054#1083#1080#1074#1082#1086#1074#1099#1081
      'clNavy='#1058#1077#1084#1085#1086'-'#1089#1080#1085#1080#1081
      'clPurple='#1060#1080#1086#1083#1077#1090#1086#1074#1099#1081
      'clTeal='#1052#1086#1088#1089#1082#1086#1081
      'clGray='#1057#1077#1088#1099#1081
      'clSilver='#1057#1077#1088#1077#1073#1088#1103#1085#1099#1081
      'clRed='#1050#1088#1072#1089#1085#1099#1081
      'clLime='#1051#1080#1084#1086#1085
      'clYellow='#1046#1077#1083#1090#1099#1081
      'clBlue='#1057#1080#1085#1080#1081
      'clFuchsia='#1052#1072#1083#1080#1085#1086#1074#1099#1081
      'clAqua='#1040#1082#1074#1072
      'clWhite='#1041#1077#1083#1099#1081
      'clScrollBar='#1055#1086#1083#1086#1089#1072' '#1087#1088#1086#1082#1088#1091#1090#1082#1080
      'clBackground='#1060#1086#1085
      'clActiveCaption='#1047#1072#1075#1086#1083#1086#1074#1086#1082
      'clInactiveCaption='#1053#1077#1072#1082#1090#1080#1074#1085#1099#1081' '#1079#1072#1075#1086#1083#1086#1074#1086#1082
      'clMenu='#1052#1077#1085#1102
      'clWindow='#1060#1086#1085' '#1086#1082#1085#1072
      'clWindowFrame='#1056#1072#1084#1082#1072' '#1086#1082#1085#1072
      'clMenuText='#1058#1077#1089#1090' '#1084#1077#1085#1102
      'clWindowText='#1058#1077#1082#1089#1090' '#1086#1082#1085#1072
      'clCaptionText='#1058#1077#1082#1089#1090' '#1079#1072#1075#1086#1083#1086#1074#1082#1072
      'clActiveBorder='#1040#1082#1090#1080#1074#1085#1072#1103' '#1088#1072#1084#1082#1072
      'clInactiveBorder='#1053#1077#1072#1082#1090#1080#1074#1085#1072#1103' '#1088#1072#1084#1082#1072
      'clAppWorkSpace='#1056#1072#1073#1086#1095#1077#1077' '#1087#1088#1086#1089#1090#1088#1072#1085#1089#1090#1074#1086
      'clHighlight='#1042#1099#1076#1077#1083#1077#1085#1080#1077
      'clHighlightText='#1042#1099#1076#1077#1083#1077#1085#1085#1099#1081' '#1090#1077#1082#1089#1090
      'clBtnFace='#1050#1085#1086#1087#1082#1072
      'clBtnShadow='#1058#1077#1085#1100' '#1082#1085#1086#1087#1082#1080
      'clGrayText='#1057#1077#1088#1099#1081' '#1090#1077#1082#1089#1090
      'clBtnText='#1058#1077#1082#1089#1090' '#1082#1085#1086#1087#1082#1080
      'clInactiveCaptionText='#1058#1077#1082#1089#1090' '#1085#1077#1072#1082#1090#1080#1074#1085#1086#1075#1086' '#1079#1072#1075#1086#1083#1086#1074#1082#1072
      'clBtnHighlight='#1042#1099#1076#1077#1083#1077#1085#1085#1072#1103' '#1082#1085#1086#1087#1082#1072
      'clDkShadow3D=3D '#1090#1077#1085#1100
      'clLight3D=3D '#1089#1074#1077#1090
      'cl3DDkShadow=3D '#1090#1077#1085#1100
      'cl3DLight=3D '#1089#1074#1077#1090
      'clInfoText='#1048#1085#1092#1086'-'#1090#1077#1082#1089#1090
      'clInfoBk='#1048#1085#1092#1086'-'#1087#1072#1085#1077#1083#1100
      'clMoneyGreen='#1057#1074#1077#1090#1083#1086'-'#1079#1077#1083#1077#1085#1099#1081
      'clSkyBlue='#1053#1077#1073#1077#1089#1085#1086'-'#1075#1086#1083#1091#1073#1086#1081
      'clMedGray='#1057#1088#1077#1076#1085#1077#1089#1077#1088#1099#1081
      'clNone=<'#1053#1077#1090'>'
      'clCustom='#1044#1088#1091#1075#1086#1081'...'
      'clDefault='#1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102)
    ColorValue = clWindow
    ColorDialogText = #1044#1088#1091#1075#1086#1081'...'
    DroppedDownWidth = 139
    NewColorText = #1044#1088#1091#1075#1086#1081
    Options = [coText, coSysColors, coCustomColors]
    TabOrder = 3
    OnChange = cldbColorCloseUp
  end
  object DBEdit1: TDBEdit
    Left = 344
    Top = 228
    Width = 205
    Height = 21
    DataField = 'Caption'
    DataSource = sdm.dsSrvGridCols
    TabOrder = 4
  end
  object RxDBComboBox1: TJvDBComboBox
    Left = 428
    Top = 272
    Width = 123
    Height = 21
    DataField = 'CaptionAlignment'
    DataSource = sdm.dsSrvGridCols
    ItemHeight = 13
    Items.Strings = (
      #1055#1086' '#1094#1077#1085#1090#1088#1091
      #1042#1087#1088#1072#1074#1086
      #1042#1083#1077#1074#1086)
    TabOrder = 5
    Values.Strings = (
      '2'
      '1'
      '0')
  end
  object cbField: TDBLookupComboBox
    Left = 376
    Top = 45
    Width = 175
    Height = 21
    DataField = 'FieldName'
    DataSource = sdm.dsSrvGridCols
    KeyField = 'FieldName'
    ListField = 'FieldName'
    ListSource = sdm.dsSrvFieldInfo
    TabOrder = 6
    OnCloseUp = cbFieldCloseUp
  end
  object DBCheckBox1: TDBCheckBox
    Left = 344
    Top = 168
    Width = 157
    Height = 17
    Caption = #1058#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1095#1090#1077#1085#1080#1103
    DataField = 'ReadOnly'
    DataSource = sdm.dsSrvGridCols
    TabOrder = 7
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object RxDBComboBox2: TJvDBComboBox
    Left = 428
    Top = 92
    Width = 123
    Height = 21
    DataField = 'Alignment'
    DataSource = sdm.dsSrvGridCols
    ItemHeight = 13
    Items.Strings = (
      #1055#1086' '#1094#1077#1085#1090#1088#1091
      #1042#1087#1088#1072#1074#1086
      #1042#1083#1077#1074#1086)
    TabOrder = 8
    Values.Strings = (
      '2'
      '1'
      '0')
  end
  object cldbCaptionColor: TJvColorComboBox
    Left = 412
    Top = 320
    Width = 139
    Height = 20
    ColorValue = clBtnFace
    ColorDialogText = #1044#1088#1091#1075#1086#1081'...'
    DroppedDownWidth = 139
    NewColorText = #1044#1088#1091#1075#1086#1081
    Options = [coText, coSysColors, coCustomColors]
    TabOrder = 9
    OnChange = cldbCaptionColorCloseUp
  end
  object cldbFontColor: TJvColorComboBox
    Left = 412
    Top = 116
    Width = 139
    Height = 20
    ColorDialogText = #1044#1088#1091#1075#1086#1081'...'
    DroppedDownWidth = 139
    NewColorText = #1044#1088#1091#1075#1086#1081
    Options = [coText, coSysColors, coCustomColors]
    TabOrder = 10
    OnChange = cldbFontColorCloseUp
  end
  object cldbCaptionFontColor: TJvColorComboBox
    Left = 412
    Top = 296
    Width = 139
    Height = 20
    ColorDialogText = #1044#1088#1091#1075#1086#1081'...'
    DroppedDownWidth = 139
    NewColorText = #1044#1088#1091#1075#1086#1081
    Options = [coText, coSysColors, coCustomColors]
    TabOrder = 11
    OnChange = cldbCaptionFontColorCloseUp
  end
  object DBCheckBox2: TDBCheckBox
    Left = 468
    Top = 168
    Width = 73
    Height = 17
    Caption = #1042#1080#1076#1080#1084#1099#1081
    DataField = 'Visible'
    DataSource = sdm.dsSrvGridCols
    TabOrder = 12
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox3: TDBCheckBox
    Left = 344
    Top = 72
    Width = 101
    Height = 17
    Caption = #1055#1086#1083#1091#1078#1080#1088#1085#1099#1081
    DataField = 'FontBold'
    DataSource = sdm.dsSrvGridCols
    TabOrder = 13
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox4: TDBCheckBox
    Left = 448
    Top = 72
    Width = 97
    Height = 17
    Caption = #1050#1091#1088#1089#1080#1074
    DataField = 'FontItalic'
    DataSource = sdm.dsSrvGridCols
    TabOrder = 14
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox5: TDBCheckBox
    Left = 344
    Top = 252
    Width = 101
    Height = 17
    Caption = #1055#1086#1083#1091#1078#1080#1088#1085#1099#1081
    DataField = 'CaptionFontBold'
    DataSource = sdm.dsSrvGridCols
    TabOrder = 15
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox6: TDBCheckBox
    Left = 448
    Top = 252
    Width = 97
    Height = 17
    Caption = #1050#1091#1088#1089#1080#1074
    DataField = 'CaptionFontItalic'
    DataSource = sdm.dsSrvGridCols
    TabOrder = 16
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox7: TDBCheckBox
    Left = 344
    Top = 188
    Width = 75
    Height = 17
    Caption = #1062#1077#1085#1072
    DataField = 'PriceColumn'
    DataSource = sdm.dsSrvGridCols
    TabOrder = 17
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object cbShowEditButton: TDBCheckBox
    Left = 344
    Top = 348
    Width = 209
    Height = 17
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1082#1085#1086#1087#1082#1091' '#1074#1099#1073#1086#1088#1072
    DataField = 'ShowEditButton'
    DataSource = sdm.dsSrvGridCols
    TabOrder = 18
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox8: TDBCheckBox
    Left = 436
    Top = 186
    Width = 97
    Height = 19
    Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
    DataField = 'CostColumn'
    DataSource = sdm.dsSrvGridCols
    TabOrder = 19
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object dgCols: TMyDBGridEh
    Left = 8
    Top = 27
    Width = 325
    Height = 299
    DataSource = sdm.dsSrvGridCols
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghHighlightFocus, dghClearSelection, dghDialogFind]
    TabOrder = 20
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnGetCellParams = dgColsGetCellParams
    Columns = <
      item
        EditButtons = <>
        FieldName = 'ColNumber'
        Footers = <>
        Title.Caption = '#'
        Width = 24
      end
      item
        EditButtons = <>
        FieldName = 'FieldName'
        Footers = <>
        Title.Caption = #1055#1086#1083#1077
        Width = 115
      end
      item
        EditButtons = <>
        FieldName = 'Caption'
        Footers = <>
        Title.Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082
        Width = 102
      end>
  end
end
