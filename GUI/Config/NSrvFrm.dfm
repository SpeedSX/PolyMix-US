object SrvPropForm: TSrvPropForm
  Left = 311
  Top = 326
  BorderStyle = bsDialog
  Caption = #1053#1086#1074#1099#1081' '#1087#1088#1086#1094#1077#1089#1089
  ClientHeight = 406
  ClientWidth = 447
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
    447
    406)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 10
    Width = 48
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object Label2: TLabel
    Left = 6
    Top = 38
    Width = 81
    Height = 13
    Caption = #1042#1085#1091#1090#1088#1077#1085#1085#1077#1077' '#1080#1084#1103
  end
  object Bevel1: TBevel
    Left = 6
    Top = 361
    Width = 433
    Height = 13
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsTopLine
    ExplicitTop = 378
  end
  object Label3: TLabel
    Left = 8
    Top = 68
    Width = 62
    Height = 13
    Caption = #1054#1089#1085#1086#1074#1072#1085' '#1085#1072':'
  end
  object Label4: TLabel
    Left = 8
    Top = 312
    Width = 112
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1043#1088#1091#1087#1087#1072' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1103
    ExplicitTop = 350
  end
  object Label5: TLabel
    Left = 8
    Top = 337
    Width = 215
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1053#1086#1084#1077#1088' '#1074' '#1087#1086#1089#1083#1077#1076#1086#1074#1072#1090#1077#1083#1100#1085#1086#1089#1090#1080' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103
    ExplicitTop = 354
  end
  object gbUseInProfit: TGroupBox
    Left = 160
    Top = 180
    Width = 201
    Height = 81
    Caption = ' '#1059#1095#1072#1089#1090#1080#1077' '#1074' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1080' '#1085#1072#1094#1077#1085#1082#1080' '
    TabOrder = 16
    Visible = False
    object rbFullCost: TRadioButton
      Left = 8
      Top = 18
      Width = 185
      Height = 17
      Caption = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1087#1086#1083#1085#1072#1103' '#1089#1090#1086#1080#1084#1086#1089#1090#1100
      TabOrder = 0
    end
    object rbNoCost: TRadioButton
      Left = 8
      Top = 37
      Width = 153
      Height = 17
      Caption = #1053#1077' '#1091#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1085#1072#1094#1077#1085#1082#1077
      TabOrder = 1
    end
    object rbScriptedCost: TRadioButton
      Left = 8
      Top = 56
      Width = 183
      Height = 17
      Caption = #1056#1072#1079#1084#1077#1088' '#1091#1095#1072#1089#1090#1080#1103' '#1091#1082#1072#1079#1099#1074#1072#1077#1090#1089#1103
      TabOrder = 2
    end
  end
  object btOk: TButton
    Left = 280
    Top = 373
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 9
    OnClick = btOkClick
    ExplicitTop = 390
  end
  object btCancel: TButton
    Left = 364
    Top = 373
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 10
    ExplicitTop = 390
  end
  object GroupBox1: TGroupBox
    Left = 194
    Top = 150
    Width = 153
    Height = 77
    Caption = ' '#1042#1080#1076' '#1087#1088#1086#1094#1077#1089#1089#1072' '
    TabOrder = 3
    Visible = False
    object rbTable: TRadioButton
      Left = 10
      Top = 18
      Width = 113
      Height = 17
      Caption = #1058#1072#1073#1083#1080#1094#1072
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbForm: TRadioButton
      Left = 10
      Top = 56
      Width = 113
      Height = 17
      Caption = #1055#1088#1086#1080#1079#1074#1086#1083#1100#1085#1099#1081
      Enabled = False
      TabOrder = 2
    end
    object rbSimple: TRadioButton
      Left = 10
      Top = 37
      Width = 113
      Height = 17
      Caption = #1055#1088#1086#1089#1090#1086#1081
      Enabled = False
      TabOrder = 1
    end
  end
  object btStruct: TButton
    Left = 108
    Top = 373
    Width = 159
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1057#1090#1088#1091#1082#1090#1091#1088#1072' '#1076#1072#1085#1085#1099#1093'...'
    TabOrder = 8
    OnClick = btStructClick
    ExplicitTop = 390
  end
  object GroupBox2: TGroupBox
    Left = 236
    Top = 94
    Width = 201
    Height = 205
    Caption = ' '#1054#1073#1088#1072#1073#1072#1090#1099#1074#1072#1077#1090' '#1089#1086#1073#1099#1090#1080#1103' '
    TabOrder = 4
    object cb1: TDBCheckBox
      Left = 8
      Top = 20
      Width = 145
      Height = 17
      Caption = #1042#1099#1095#1080#1089#1083#1077#1085#1080#1077' '#1087#1086#1083#1077#1081
      DataField = 'AssignCalcFields'
      DataSource = dsServices
      TabOrder = 0
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
    object cb2: TDBCheckBox
      Left = 8
      Top = 40
      Width = 129
      Height = 17
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093
      DataField = 'AssignDataChange'
      DataSource = dsServices
      TabOrder = 1
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
    object cb3: TDBCheckBox
      Left = 8
      Top = 60
      Width = 97
      Height = 17
      Caption = #1053#1086#1074#1072#1103' '#1079#1072#1087#1080#1089#1100
      DataField = 'AssignNewRecord'
      DataSource = dsServices
      TabOrder = 2
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
    object cb14: TDBCheckBox
      Left = 8
      Top = 80
      Width = 180
      Height = 17
      Caption = #1055#1077#1088#1077#1076' '#1076#1086#1073#1072#1074#1083#1077#1085#1080#1077#1084' '#1079#1072#1087#1080#1089#1080
      DataField = 'AssignBeforeInsert'
      DataSource = dsServices
      TabOrder = 3
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
    object cb16: TDBCheckBox
      Left = 8
      Top = 100
      Width = 189
      Height = 17
      Caption = #1055#1086#1089#1083#1077' '#1086#1090#1082#1088#1099#1090#1080#1103' '#1085#1072#1073#1086#1088#1072' '#1076#1072#1085#1085#1099#1093
      DataField = 'EnableAfterOpen'
      DataSource = dsServices
      TabOrder = 4
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
    object DBCheckBox3: TDBCheckBox
      Left = 8
      Top = 120
      Width = 149
      Height = 17
      Caption = #1055#1077#1088#1077#1076' '#1087#1088#1086#1082#1088#1091#1090#1082#1086#1081
      DataField = 'EnableBeforeScroll'
      DataSource = dsServices
      TabOrder = 5
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
    object DBCheckBox6: TDBCheckBox
      Left = 8
      Top = 140
      Width = 163
      Height = 17
      Caption = #1055#1086#1089#1083#1077' '#1087#1088#1086#1082#1088#1091#1090#1082#1080
      DataField = 'EnableAfterScroll'
      DataSource = dsServices
      TabOrder = 6
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
    object DBCheckBox7: TDBCheckBox
      Left = 8
      Top = 160
      Width = 165
      Height = 17
      Caption = #1055#1086#1089#1083#1077' '#1074#1093#1086#1076#1072' '#1074' '#1079#1072#1082#1072#1079
      DataField = 'EnableAfterOrderOpen'
      DataSource = dsServices
      TabOrder = 7
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
    object DBCheckBox8: TDBCheckBox
      Left = 8
      Top = 180
      Width = 185
      Height = 17
      Caption = #1055#1077#1088#1077#1076' '#1091#1076#1072#1083#1077#1085#1080#1077#1084' '#1079#1072#1087#1080#1089#1080
      DataField = 'EnableBeforeDelete'
      DataSource = dsServices
      TabOrder = 8
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
  end
  object cb9: TDBCheckBox
    Left = 8
    Top = 194
    Width = 145
    Height = 17
    Caption = #1058#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1086#1074
    DataField = 'OnlyWorkOrder'
    DataSource = dsServices
    TabOrder = 6
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object cb8: TDBCheckBox
    Left = 8
    Top = 114
    Width = 201
    Height = 17
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077
    DataField = 'ShowInReport'
    DataSource = dsServices
    TabOrder = 5
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object edName: TDBEdit
    Left = 100
    Top = 36
    Width = 337
    Height = 21
    DataField = 'SrvName'
    DataSource = dsServices
    TabOrder = 1
  end
  object edDesc: TDBEdit
    Left = 68
    Top = 8
    Width = 369
    Height = 21
    DataField = 'SrvDesc'
    DataSource = dsServices
    TabOrder = 0
  end
  object cb13: TDBCheckBox
    Left = 8
    Top = 214
    Width = 109
    Height = 17
    Caption = #1053#1077' '#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100
    DataField = 'NotForCopy'
    DataSource = dsServices
    TabOrder = 7
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object lkBaseSrv: TJvDBLookupCombo
    Left = 80
    Top = 64
    Width = 357
    Height = 21
    DataField = 'BaseSrvID'
    DataSource = dsServices
    DisplayEmpty = '<'#1073#1072#1079#1086#1074#1099#1081' '#1087#1088#1086#1094#1077#1089#1089' '#1085#1077' '#1091#1082#1072#1079#1072#1085'>'
    LookupField = 'SrvID'
    LookupDisplay = 'SrvDesc'
    TabOrder = 2
    OnChange = lkBaseSrvChange
  end
  object cb17: TDBCheckBox
    Left = 8
    Top = 134
    Width = 213
    Height = 17
    Caption = #1054#1090#1089#1083#1077#1078#1080#1074#1072#1090#1100' '#1089#1086#1089#1090#1086#1103#1085#1080#1077' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103
    DataField = 'EnableTracking'
    DataSource = dsServices
    TabOrder = 11
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox1: TDBCheckBox
    Left = 8
    Top = 154
    Width = 185
    Height = 17
    Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1087#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077
    DataField = 'EnablePlanning'
    DataSource = dsServices
    TabOrder = 12
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox2: TDBCheckBox
    Left = 8
    Top = 234
    Width = 213
    Height = 17
    Caption = #1044#1086#1073#1072#1074#1083#1103#1090#1100' '#1074' '#1086#1073#1097#1080#1081' '#1080#1090#1086#1075
    DataField = 'UseInTotal'
    DataSource = dsServices
    TabOrder = 13
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox4: TDBCheckBox
    Left = 8
    Top = 254
    Width = 225
    Height = 17
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1074' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1080' '#1087#1088#1080#1073#1099#1083#1080
    DataField = 'ShowInProfit'
    DataSource = dsServices
    TabOrder = 14
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox5: TDBCheckBox
    Left = 8
    Top = 174
    Width = 179
    Height = 17
    Caption = #1057#1082#1088#1099#1074#1072#1090#1100' '#1074' '#1089#1086#1089#1090#1072#1074#1077' '#1079#1072#1082#1072#1079#1072
    DataField = 'HideItem'
    DataSource = dsServices
    TabOrder = 15
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object edSequenceOrder: TDBEdit
    Left = 236
    Top = 333
    Width = 53
    Height = 21
    Anchors = [akLeft, akBottom]
    DataField = 'SequenceOrder'
    DataSource = dsServices
    TabOrder = 17
    ExplicitTop = 350
  end
  object lkEquipGroup: TJvDBLookupCombo
    Left = 130
    Top = 308
    Width = 159
    Height = 21
    DataField = 'DefaultEquipGroupCode'
    DataSource = sdm.dsServices
    Anchors = [akLeft, akBottom]
    LookupField = 'Code'
    LookupDisplay = 'Name'
    LookupSource = dsEquipGroup
    TabOrder = 18
    ExplicitTop = 346
  end
  object DBCheckBox9: TDBCheckBox
    Left = 8
    Top = 274
    Width = 221
    Height = 17
    Caption = #1055#1086#1084#1077#1095#1072#1090#1100' '#1082#1072#1082' '#1089#1091#1073#1087#1086#1076#1088#1103#1076#1085#1099#1081' '#1087#1088#1086#1094#1077#1089#1089
    DataField = 'DefaultContractorProcess'
    DataSource = dsServices
    TabOrder = 19
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox10: TDBCheckBox
    Left = 8
    Top = 94
    Width = 201
    Height = 17
    Caption = #1040#1082#1090#1080#1074#1085#1099#1081
    DataField = 'SrvActive'
    DataSource = dsServices
    TabOrder = 20
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object dsEquipGroup: TDataSource
    Left = 164
    Top = 290
  end
  object dsServices: TDataSource
    Left = 254
    Top = 326
  end
end
