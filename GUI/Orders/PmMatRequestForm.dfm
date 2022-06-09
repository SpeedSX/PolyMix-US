inherited MaterialRequestEditForm: TMaterialRequestEditForm
  Caption = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1084#1072#1090#1077#1088#1080#1072#1083' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072
  ClientHeight = 377
  ClientWidth = 422
  OnActivate = FormActivate
  OnCreate = FormCreate
  ExplicitWidth = 428
  ExplicitHeight = 409
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 12
    Top = 12
    Width = 53
    Height = 13
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
  end
  inherited btOk: TButton
    Left = 246
    Top = 342
    Default = False
    TabOrder = 3
    ExplicitLeft = 246
    ExplicitTop = 342
  end
  inherited btCancel: TButton
    Left = 335
    Top = 342
    TabOrder = 4
    ExplicitLeft = 335
    ExplicitTop = 342
  end
  object edMatDesc: TDBEdit [3]
    Left = 12
    Top = 28
    Width = 397
    Height = 21
    DataField = 'MatDesc'
    ReadOnly = True
    TabOrder = 0
  end
  object gbCalc: TGroupBox [4]
    Left = 12
    Top = 60
    Width = 397
    Height = 66
    Caption = ' '#1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '
    TabOrder = 1
    object Label2: TLabel
      Left = 12
      Top = 19
      Width = 64
      Height = 13
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086':'
    end
    object lbMatUnitName: TDBText
      Left = 87
      Top = 40
      Width = 55
      Height = 17
      DataField = 'MatUnitName'
    end
    object lbMatCost: TLabel
      Left = 148
      Top = 19
      Width = 58
      Height = 13
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100':'
    end
    object lbPlanDate: TLabel
      Left = 282
      Top = 19
      Width = 81
      Height = 13
      Caption = #1055#1083#1072#1085#1086#1074#1072#1103' '#1076#1072#1090#1072':'
    end
    object lbMatCostGrn: TLabel
      Left = 246
      Top = 40
      Width = 21
      Height = 13
      Caption = #1075#1088#1085'.'
    end
    object edMatAmount: TDBEdit
      Left = 12
      Top = 36
      Width = 69
      Height = 21
      DataField = 'MatAmount'
      ReadOnly = True
      TabOrder = 0
    end
    object edMatCost: TDBEdit
      Left = 148
      Top = 36
      Width = 93
      Height = 21
      DataField = 'MatCostNative'
      ReadOnly = True
      TabOrder = 1
    end
    object dePlanDate: TJvDBDateEdit
      Left = 282
      Top = 36
      Width = 107
      Height = 21
      DataField = 'PlanReceiveDate'
      DialogTitle = #1042#1099#1073#1086#1088' '#1076#1072#1090#1099
      Weekends = [Sun, Sat]
      TabOrder = 2
    end
  end
  object GroupBox1: TGroupBox [5]
    Left = 12
    Top = 132
    Width = 397
    Height = 200
    Caption = ' '#1060#1072#1082#1090#1080#1095#1077#1089#1082#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '
    TabOrder = 2
    DesignSize = (
      397
      200)
    object lbFactMatAmount: TLabel
      Left = 12
      Top = 19
      Width = 64
      Height = 13
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086':'
    end
    object lbFactMatUnitName: TDBText
      Left = 87
      Top = 39
      Width = 55
      Height = 17
      DataField = 'MatUnitName'
    end
    object lbFactMatCost: TLabel
      Left = 148
      Top = 19
      Width = 58
      Height = 13
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100':'
    end
    object lbFactDate: TLabel
      Left = 282
      Top = 19
      Width = 99
      Height = 13
      Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1072#1103' '#1076#1072#1090#1072':'
    end
    object lbFactMatCostGrn: TLabel
      Left = 246
      Top = 40
      Width = 21
      Height = 13
      Caption = #1075#1088#1085'.'
    end
    object lbSupplier: TLabel
      Left = 14
      Top = 66
      Width = 61
      Height = 13
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
    end
    object lbPayDate: TLabel
      Left = 12
      Top = 155
      Width = 71
      Height = 13
      Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099':'
    end
    object lbFactMat: TLabel
      Left = 14
      Top = 110
      Width = 77
      Height = 13
      Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072':'
    end
    object edFactMatAmount: TDBEdit
      Left = 12
      Top = 36
      Width = 69
      Height = 21
      DataField = 'FactMatAmount'
      TabOrder = 0
    end
    object edFactMatCost: TDBEdit
      Left = 148
      Top = 36
      Width = 93
      Height = 21
      DataField = 'FactMatCost'
      TabOrder = 1
    end
    object deFactDate: TJvDBDateEdit
      Left = 282
      Top = 36
      Width = 107
      Height = 21
      DataField = 'FactReceiveDate'
      DialogTitle = #1042#1099#1073#1086#1088' '#1076#1072#1090#1099
      Weekends = [Sun, Sat]
      TabOrder = 2
    end
    object cbSupplier: TDBLookupComboBox
      Left = 12
      Top = 82
      Width = 377
      Height = 21
      DataField = 'SupplierID'
      KeyField = 'N'
      ListField = 'Name'
      ListSource = dsSuppliers
      TabOrder = 3
    end
    object dePayDate: TJvDBDateEdit
      Left = 12
      Top = 172
      Width = 107
      Height = 21
      DataField = 'PayDate'
      DialogTitle = #1042#1099#1073#1086#1088' '#1076#1072#1090#1099
      Weekends = [Sun, Sat]
      TabOrder = 6
    end
    object cbFactMat: TDBLookupComboboxEh
      Left = 12
      Top = 126
      Width = 316
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      DataField = 'ExternalMatID'
      DropDownBox.Options = [dlgColumnResizeEh, dlgColLinesEh]
      DropDownBox.AutoDrop = True
      DropDownBox.Rows = 20
      DropDownBox.ShowTitles = True
      DropDownBox.Sizable = True
      EditButtons = <>
      KeyField = 'Code'
      ListField = 'Name'
      ListSource = dsMaterials
      TabOrder = 4
      Visible = True
    end
    object btFindFact: TButton
      Left = 334
      Top = 124
      Width = 55
      Height = 25
      Caption = #1053#1072#1081#1090#1080
      TabOrder = 5
    end
  end
  inherited FormStorage: TJvFormStorage
    AppStoragePath = 'MatRequestEditForm\'
    Left = 48
    Top = 326
  end
  object dsSuppliers: TDataSource
    Left = 18
    Top = 328
  end
  object dsMaterials: TDataSource
    Left = 124
    Top = 340
  end
end
