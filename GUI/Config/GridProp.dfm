object GridPropForm: TGridPropForm
  Left = 336
  Top = 262
  BorderStyle = bsDialog
  Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1090#1072#1073#1083#1080#1094#1099
  ClientHeight = 382
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    418
    382)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 52
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
  end
  object Label2: TLabel
    Left = 8
    Top = 39
    Width = 85
    Height = 13
    Caption = #1042#1085#1091#1090#1088#1077#1085#1085#1077#1077' '#1080#1084#1103':'
  end
  object Bevel1: TBevel
    Left = 6
    Top = 338
    Width = 401
    Height = 13
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsTopLine
  end
  object Label3: TLabel
    Left = 8
    Top = 68
    Width = 90
    Height = 13
    Caption = #1041#1072#1079#1086#1074#1072#1103' '#1090#1072#1073#1083#1080#1094#1072':'
  end
  object lbGrpNum: TLabel
    Left = 204
    Top = 268
    Width = 100
    Height = 13
    Caption = #1053#1086#1084#1077#1088' '#1085#1072' '#1089#1090#1088#1072#1085#1080#1094#1077':'
  end
  object lbSrvPage: TLabel
    Left = 206
    Top = 218
    Width = 53
    Height = 13
    Caption = #1057#1090#1088#1072#1085#1080#1094#1072':'
  end
  object btOk: TButton
    Left = 250
    Top = 350
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btOkClick
  end
  object btCancel: TButton
    Left = 336
    Top = 350
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox2: TGroupBox
    Left = 6
    Top = 218
    Width = 187
    Height = 85
    Caption = ' '#1054#1073#1088#1072#1073#1072#1090#1099#1074#1072#1077#1090' '#1089#1086#1073#1099#1090#1080#1103' '
    TabOrder = 2
    object cb4: TDBCheckBox
      Left = 8
      Top = 20
      Width = 101
      Height = 17
      Caption = #1042#1093#1086#1076' '#1074' '#1090#1072#1073#1083#1080#1094#1091
      DataField = 'AssignGridEnter'
      DataSource = dsGrid
      TabOrder = 0
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
    object cb12: TDBCheckBox
      Left = 8
      Top = 40
      Width = 209
      Height = 17
      Caption = #1054#1090#1088#1080#1089#1086#1074#1082#1072' '#1103#1095#1077#1081#1082#1080' '#1090#1072#1073#1083#1080#1094#1099
      DataField = 'AssignDrawCell'
      DataSource = dsGrid
      TabOrder = 1
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
    object cb15: TDBCheckBox
      Left = 8
      Top = 60
      Width = 201
      Height = 17
      Caption = #1056#1072#1089#1095#1077#1090' '#1080#1090#1086#1075#1086#1074#1086#1081' '#1089#1091#1084#1084#1099
      DataField = 'EnableCalcTotalCost'
      DataSource = dsGrid
      TabOrder = 2
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
  end
  object edName: TDBEdit
    Left = 106
    Top = 36
    Width = 303
    Height = 21
    DataField = 'GridName'
    DataSource = dsGrid
    TabOrder = 3
  end
  object edDesc: TDBEdit
    Left = 68
    Top = 8
    Width = 341
    Height = 21
    DataField = 'GridCaption'
    DataSource = dsGrid
    TabOrder = 4
  end
  object cb11: TDBCheckBox
    Left = 10
    Top = 314
    Width = 397
    Height = 17
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1087#1072#1085#1077#1083#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1080' '#1080#1090#1086#1075#1086#1074
    DataField = 'ShowControlPanel'
    DataSource = dsGrid
    TabOrder = 5
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object lkBaseGrid: TJvDBLookupCombo
    Left = 106
    Top = 64
    Width = 303
    Height = 21
    DataField = 'BaseGridID'
    DataSource = dsGrid
    DisplayEmpty = '<'#1085#1077' '#1091#1082#1072#1079#1072#1085#1072'>'
    LookupField = 'GridID'
    LookupDisplay = 'GridCaption'
    LookupSource = dsTempGrid
    TabOrder = 6
  end
  object GroupBox1: TGroupBox
    Left = 6
    Top = 96
    Width = 405
    Height = 111
    Caption = #1048#1090#1086#1075#1086#1074#1099#1077' '#1087#1086#1083#1103
    TabOrder = 7
    object Label4: TLabel
      Left = 36
      Top = 25
      Width = 94
      Height = 13
      Caption = #1054#1073#1097#1072#1103' '#1089#1090#1086#1080#1084#1086#1089#1090#1100':'
    end
    object Label5: TLabel
      Left = 88
      Top = 54
      Width = 40
      Height = 13
      Caption = #1056#1072#1073#1086#1090#1072':'
    end
    object Label6: TLabel
      Left = 68
      Top = 82
      Width = 62
      Height = 13
      Caption = #1052#1072#1090#1077#1088#1080#1072#1083#1099':'
    end
    object lkTotal: TJvDBLookupCombo
      Left = 136
      Top = 22
      Width = 260
      Height = 21
      DataField = 'TotalFieldName'
      DataSource = dsGrid
      DisplayEmpty = '<'#1085#1077' '#1091#1082#1072#1079#1072#1085#1086'>'
      LookupField = 'FieldName'
      LookupDisplay = 'FieldName'
      LookupSource = dsTotalFields
      TabOrder = 0
    end
    object lkWorkTotal: TJvDBLookupCombo
      Left = 136
      Top = 50
      Width = 260
      Height = 21
      DataField = 'TotalWorkFieldName'
      DataSource = dsGrid
      DisplayEmpty = '<'#1085#1077' '#1091#1082#1072#1079#1072#1085#1086'>'
      LookupField = 'FieldName'
      LookupDisplay = 'FieldName'
      LookupSource = dsTotalFields
      TabOrder = 1
    end
    object lkMatTotal: TJvDBLookupCombo
      Left = 136
      Top = 78
      Width = 260
      Height = 21
      DataField = 'TotalMatFieldName'
      DataSource = dsGrid
      DisplayEmpty = '<'#1085#1077' '#1091#1082#1072#1079#1072#1085#1086'>'
      LookupField = 'FieldName'
      LookupDisplay = 'FieldName'
      LookupSource = dsTotalFields
      TabOrder = 2
    end
  end
  object edGrpNum: TJvDBSpinEdit
    Left = 310
    Top = 264
    Width = 53
    Height = 21
    MaxValue = 20000.000000000000000000
    TabOrder = 8
    DataField = 'PageOrderNum'
    DataSource = dsGrid
  end
  object lkSrvPage: TDBLookupComboBox
    Left = 204
    Top = 236
    Width = 199
    Height = 21
    DataField = 'ProcessPageID'
    DataSource = dsGrid
    KeyField = 'ProcessPageID'
    ListField = 'PageCaption'
    ListSource = sdm.dsSrvPages
    TabOrder = 9
  end
  object dsGrid: TDataSource
    Left = 134
    Top = 6
  end
  object dsTotalFields: TDataSource
    Left = 24
    Top = 144
  end
  object dsTempGrid: TDataSource
    Left = 320
    Top = 62
  end
end
