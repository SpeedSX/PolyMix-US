object EntSettingsForm: TEntSettingsForm
  Left = 289
  Top = 443
  BorderStyle = bsDialog
  Caption = #1043#1083#1086#1073#1072#1083#1100#1085#1099#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 596
  ClientWidth = 436
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    436
    596)
  PixelsPerInch = 96
  TextHeight = 13
  object pcSettings: TPageControl
    Left = 6
    Top = 8
    Width = 423
    Height = 485
    ActivePage = tsCommon
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object tsCommon: TTabSheet
      Caption = #1054#1073#1097#1080#1077
      object DBCheckBox2: TDBCheckBox
        Left = 14
        Top = 12
        Width = 337
        Height = 17
        Caption = #1041#1083#1086#1082#1080#1088#1086#1074#1082#1072' '#1086#1073#1098#1077#1082#1090#1086#1074' '#1087#1088#1080' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1080
        DataField = 'EditLock'
        DataSource = dsEntSettings
        TabOrder = 0
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox3: TDBCheckBox
        Left = 14
        Top = 34
        Width = 305
        Height = 17
        Caption = #1057#1086#1082#1088#1072#1097#1077#1085#1085#1099#1081' '#1096#1080#1092#1088' '#1087#1088#1086#1089#1095#1077#1090#1072
        DataField = 'BriefOrderID'
        DataSource = dsEntSettings
        TabOrder = 1
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox4: TDBCheckBox
        Left = 14
        Top = 56
        Width = 323
        Height = 17
        Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1086#1090#1082#1083#1102#1095#1077#1085#1080#1077' '#1092#1080#1083#1100#1090#1088#1072' '#1087#1086' '#1076#1072#1090#1077
        DataField = 'PermitFilterOff'
        DataSource = dsEntSettings
        TabOrder = 2
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox5: TDBCheckBox
        Left = 14
        Top = 78
        Width = 291
        Height = 17
        Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1074#1080#1076#1072' '#1079#1072#1082#1072#1079#1072
        DataField = 'PermitKindChange'
        DataSource = dsEntSettings
        TabOrder = 3
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox6: TDBCheckBox
        Left = 14
        Top = 100
        Width = 317
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1074#1085#1077#1096#1085#1080#1081' '#1085#1086#1084#1077#1088' '#1079#1072#1082#1072#1079#1072
        DataField = 'ShowExternalId'
        DataSource = dsEntSettings
        TabOrder = 4
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object GroupBox1: TGroupBox
        Left = 3
        Top = 324
        Width = 309
        Height = 125
        Caption = ' '#1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
        object DBCheckBox8: TDBCheckBox
          Left = 10
          Top = 20
          Width = 275
          Height = 17
          Caption = #1048#1089#1090#1086#1095#1085#1080#1082' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080' ('#1090#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1095#1080#1082#1086#1074')'
          DataField = 'RequireInfoSource'
          DataSource = dsEntSettings
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object DBCheckBox10: TDBCheckBox
          Left = 10
          Top = 40
          Width = 189
          Height = 17
          Caption = #1057#1077#1075#1084#1077#1085#1090' '#1088#1099#1085#1082#1072'  ('#1085#1077' '#1088#1077#1072#1083#1080#1079#1086#1074#1072#1085#1086')'
          DataField = 'RequireBranch'
          DataSource = dsEntSettings
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object DBCheckBox11: TDBCheckBox
          Left = 10
          Top = 60
          Width = 223
          Height = 17
          Caption = #1042#1080#1076' '#1076#1077#1103#1090#1077#1083#1100#1085#1086#1089#1090#1080
          DataField = 'RequireActivity'
          DataSource = dsEntSettings
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object dbcFirmType: TDBCheckBox
          Left = 10
          Top = 80
          Width = 291
          Height = 17
          Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
          DataField = 'RequireFirmType'
          DataSource = dsEntSettings
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object dbcRequireFullName: TDBCheckBox
          Left = 10
          Top = 100
          Width = 187
          Height = 17
          Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          DataField = 'RequireFullName'
          DataSource = dsEntSettings
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
      end
      object GroupBox2: TGroupBox
        Left = 3
        Top = 233
        Width = 309
        Height = 85
        Caption = ' '#1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1079#1072#1082#1072#1079#1072' '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 9
        object DBCheckBox7: TDBCheckBox
          Left = 10
          Top = 20
          Width = 139
          Height = 17
          Caption = #1047#1072#1082#1072#1079#1095#1080#1082
          DataField = 'RequireCustomer'
          DataSource = dsEntSettings
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object DBCheckBox9: TDBCheckBox
          Left = 10
          Top = 40
          Width = 175
          Height = 17
          Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072' '#1087#1088#1086#1076#1091#1082#1094#1080#1080
          DataField = 'RequireProductType'
          DataSource = dsEntSettings
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object DBCheckBox12: TDBCheckBox
          Left = 10
          Top = 60
          Width = 221
          Height = 17
          Caption = #1044#1072#1090#1072' '#1087#1083#1072#1085#1086#1074#1086#1075#1086' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1079#1072#1082#1072#1079#1072
          DataField = 'RequireFinishDate'
          DataSource = dsEntSettings
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
      end
      object DBCheckBox20: TDBCheckBox
        Left = 14
        Top = 122
        Width = 337
        Height = 17
        Caption = #1058#1088#1077#1073#1091#1077#1090#1089#1103' '#1088#1072#1079#1088#1077#1096#1077#1085#1080#1077' '#1085#1072' '#1086#1090#1075#1088#1091#1079#1082#1091
        DataField = 'ShipmentApprovement'
        DataSource = dsEntSettings
        TabOrder = 5
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox24: TDBCheckBox
        Left = 14
        Top = 166
        Width = 337
        Height = 17
        Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1089#1091#1084#1084#1091' '#1079#1072#1090#1088#1072#1090
        DataField = 'ShowExpenseCost'
        DataSource = dsEntSettings
        TabOrder = 6
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox26: TDBCheckBox
        Left = 14
        Top = 188
        Width = 337
        Height = 17
        Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1073#1083#1086#1082#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1090#1086#1080#1084#1086#1089#1090#1080' ('#1085#1077' '#1088#1077#1082#1086#1084#1077#1085#1076#1091#1077#1090#1089#1103')'
        DataField = 'AllowCostProtect'
        DataSource = dsEntSettings
        TabOrder = 7
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox31: TDBCheckBox
        Left = 14
        Top = 210
        Width = 337
        Height = 17
        Caption = #1054#1073#1098#1077#1076#1080#1085#1103#1090#1100' '#1089#1091#1073#1087#1086#1076#1088#1103#1076#1095#1080#1082#1086#1074' '#1080' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
        DataField = 'AllContractors'
        DataSource = dsEntSettings
        TabOrder = 10
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox36: TDBCheckBox
        Left = 14
        Top = 144
        Width = 337
        Height = 17
        Caption = #1058#1088#1077#1073#1091#1077#1090#1089#1103' '#1088#1072#1079#1088#1077#1096#1077#1085#1080#1077' '#1085#1072' '#1079#1072#1082#1091#1087#1082#1091' '#1084#1072#1090#1077#1088#1080#1072#1083#1086#1074
        DataField = 'OrderMaterialsApprovement'
        DataSource = dsEntSettings
        TabOrder = 11
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
    end
    object tsOther: TTabSheet
      Caption = #1056#1072#1089#1095#1077#1090
      ImageIndex = 1
      object Label2: TLabel
        Left = 6
        Top = 276
        Width = 80
        Height = 13
        Caption = #1057#1090#1072#1074#1082#1072' '#1053#1044#1057', %'
      end
      object gbRound: TGroupBox
        Left = 6
        Top = 6
        Width = 405
        Height = 257
        TabOrder = 0
        object lb1: TLabel
          Left = 28
          Top = 34
          Width = 150
          Height = 13
          Caption = #1058#1086#1095#1085#1086#1089#1090#1100' '#1094#1077#1085#1099' 1 '#1101#1082#1079'., '#1079#1085#1072#1082#1086#1074
          Enabled = False
        end
        object lbAtt: TLabel
          Left = 28
          Top = 94
          Width = 204
          Height = 39
          Caption = 
            #1042#1085#1080#1084#1072#1085#1080#1077'! '#1042#1082#1083#1102#1095#1077#1085#1080#1077' '#1082#1086#1088#1088#1077#1082#1094#1080#1080' '#1084#1086#1078#1077#1090#13#10#1087#1088#1080#1074#1077#1089#1090#1080' '#1082' '#1079#1072#1074#1099#1096#1077#1085#1080#1102' '#1089#1090#1086#1080#1084#1086 +
            #1089#1090#1080#13#10#1079#1072#1082#1072#1079#1072' '#1087#1088#1080' '#1073#1086#1083#1100#1096#1080#1093' '#1090#1080#1088#1072#1078#1072#1093'.'
          Enabled = False
        end
        object lb2: TLabel
          Left = 36
          Top = 170
          Width = 98
          Height = 13
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1079#1085#1072#1082#1086#1074
          Enabled = False
        end
        object lbAtt2: TLabel
          Left = 220
          Top = 164
          Width = 144
          Height = 65
          Caption = 
            '0 - '#1053#1077' '#1086#1082#1088#1091#1075#1083#1103#1090#1100#13#10'...'#13#10'2 - '#1054#1082#1088#1091#1075#1083#1077#1085#1080#1077' '#1076#1086' '#1094#1077#1083#1086#1075#1086#13#10'3 - '#1054#1082#1088#1091#1075#1083#1077#1085#1080#1077' ' +
            #1076#1086' '#1076#1077#1089#1103#1090#1082#1086#1074#13#10'...'
          Enabled = False
        end
        object edPrec: TEdit
          Left = 188
          Top = 31
          Width = 49
          Height = 21
          Enabled = False
          TabOrder = 0
          Text = '0'
        end
        object udPrec: TUpDown
          Left = 237
          Top = 31
          Width = 15
          Height = 21
          Associate = edPrec
          Enabled = False
          Max = 30
          TabOrder = 1
          Thousands = False
        end
        object rbCorTotal: TRadioButton
          Left = 12
          Top = 10
          Width = 245
          Height = 17
          Caption = #1050#1086#1088#1088#1077#1082#1094#1080#1103' '#1086#1073#1097#1077#1081' '#1089#1091#1084#1084#1099' '#1087#1086' '#1094#1077#1085#1077' 1 '#1101#1082#1079'.'
          TabOrder = 3
          OnClick = rbCorTotalClick
        end
        object rbRoundTotal: TRadioButton
          Left = 16
          Top = 148
          Width = 237
          Height = 17
          Caption = #1054#1082#1088#1091#1075#1083#1077#1085#1080#1077' '#1086#1073#1097#1077#1081' '#1089#1091#1084#1084#1099
          TabOrder = 4
          OnClick = rbRoundTotalClick
        end
        object edPrec2: TEdit
          Left = 144
          Top = 167
          Width = 49
          Height = 21
          Enabled = False
          TabOrder = 5
          Text = '0'
        end
        object udPrec2: TUpDown
          Left = 193
          Top = 167
          Width = 15
          Height = 21
          Associate = edPrec2
          Enabled = False
          Max = 30
          TabOrder = 6
          Thousands = False
        end
        object rbNoRoundTotal: TRadioButton
          Left = 16
          Top = 232
          Width = 113
          Height = 17
          Caption = #1053#1077' '#1086#1082#1088#1091#1075#1083#1103#1090#1100
          Checked = True
          TabOrder = 7
          TabStop = True
          OnClick = rbCorTotalClick
        end
        object Panel2: TPanel
          Left = 28
          Top = 56
          Width = 225
          Height = 29
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 2
          object rbUSD: TRadioButton
            Left = 12
            Top = 8
            Width = 73
            Height = 17
            Caption = 'USD'
            Enabled = False
            TabOrder = 0
          end
          object rbUAH: TRadioButton
            Left = 96
            Top = 8
            Width = 93
            Height = 17
            Caption = 'UAH'
            Enabled = False
            TabOrder = 1
          end
        end
      end
      object edVATPercent: TJvValidateEdit
        Left = 100
        Top = 273
        Width = 48
        Height = 21
        CriticalPoints.MaxValueIncluded = False
        CriticalPoints.MinValueIncluded = False
        DisplayFormat = dfFloat
        HasMaxValue = True
        HasMinValue = True
        MaxValue = 100.000000000000000000
        TabOrder = 1
      end
    end
    object tsPayments: TTabSheet
      Caption = #1060#1080#1085#1072#1085#1089#1099
      ImageIndex = 2
      ExplicitLeft = 8
      object Label1: TLabel
        Left = 32
        Top = 32
        Width = 370
        Height = 13
        Caption = 
          #1063#1072#1089#1090#1085#1099#1077' '#1089#1083#1091#1095#1072#1080' '#1073#1091#1076#1091#1090' '#1076#1086#1089#1090#1091#1087#1085#1099' '#1076#1083#1103' '#1088#1091#1095#1085#1086#1081' '#1091#1089#1090#1072#1085#1086#1074#1082#1080' '#1074' '#1087#1086#1083#1077' "'#1057#1083#1091#1095#1072 +
          #1081'"'
      end
      object DBCheckBox13: TDBCheckBox
        Left = 12
        Top = 12
        Width = 353
        Height = 17
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1086#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1089#1086#1089#1090#1086#1103#1085#1080#1077' '#1086#1087#1083#1072#1090#1099' '#1079#1072#1082#1072#1079#1072
        DataField = 'AutoPayState'
        DataSource = dsEntSettings
        TabOrder = 0
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox16: TDBCheckBox
        Left = 12
        Top = 168
        Width = 390
        Height = 17
        Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1089#1086#1089#1090#1086#1103#1085#1080#1077' '#1089#1080#1085#1093#1088#1086#1085#1080#1079#1072#1094#1080#1080' '#1089' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1089#1082#1086#1081' '#1089#1080#1089#1090#1077#1084#1086#1081
        DataField = 'ShowSyncInfo'
        DataSource = dsEntSettings
        TabOrder = 1
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object rbPayStateMode: TRadioGroup
        Left = 32
        Top = 56
        Width = 338
        Height = 105
        Caption = ' '#1057#1087#1086#1089#1086#1073' '#1086#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103' '#1089#1086#1089#1090#1086#1103#1085#1080#1103' '#1086#1087#1083#1072#1090#1099' '#1079#1072#1082#1072#1079#1072' '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
      object rbPayStateModeInvPos: TRadioButton
        Left = 42
        Top = 117
        Width = 311
        Height = 17
        Caption = #1055#1086' '#1092#1072#1082#1090#1091' '#1086#1087#1083#1072#1090#1099' '#1082#1072#1078#1076#1086#1081' '#1087#1086#1079#1080#1094#1080#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object rbPayStateModeInvoice: TRadioButton
        Left = 42
        Top = 97
        Width = 311
        Height = 17
        Caption = #1055#1086' '#1092#1072#1082#1090#1091' '#1086#1087#1083#1072#1090#1099' '#1074#1089#1077#1093' '#1089#1095#1077#1090#1086#1074
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object rbPayStateModeOrder: TRadioButton
        Left = 42
        Top = 77
        Width = 311
        Height = 17
        Caption = #1055#1086' '#1089#1090#1086#1080#1084#1086#1089#1090#1080' '#1079#1072#1082#1072#1079#1072' '#1080' '#1089#1091#1084#1084#1077' '#1086#1087#1083#1072#1090
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
      end
      object DBCheckBox17: TDBCheckBox
        Left = 12
        Top = 190
        Width = 377
        Height = 17
        Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1080#1085#1093#1088#1086#1085#1080#1079#1080#1088#1086#1074#1072#1085#1085#1099#1093' '#1076#1072#1085#1085#1099#1093
        DataField = 'LockSyncData'
        DataSource = dsEntSettings
        TabOrder = 6
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object rbPayStateModeOldInvoices: TRadioButton
        Left = 42
        Top = 137
        Width = 311
        Height = 17
        Caption = #1056#1077#1078#1080#1084' '#1089#1086#1074#1084#1077#1089#1090#1080#1084#1086#1089#1090#1080' '#1089' '#1074#1077#1088#1089#1080#1077#1081' < 2.3'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
      end
      object DBCheckBox28: TDBCheckBox
        Left = 12
        Top = 212
        Width = 377
        Height = 17
        Caption = #1059#1095#1080#1090#1099#1074#1072#1090#1100' '#1074#1089#1077' '#1086#1087#1083#1072#1090#1099' '#1074' '#1089#1095#1077#1090#1072#1093
        DataField = 'InvoiceAllPayments'
        DataSource = dsEntSettings
        TabOrder = 8
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox29: TDBCheckBox
        Left = 12
        Top = 234
        Width = 377
        Height = 17
        Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1089#1086#1089#1090#1086#1103#1085#1080#1077' "'#1085#1077#1090' '#1089#1095#1077#1090#1072'" '#1087#1088#1080' '#1085#1077#1076#1086#1089#1090#1072#1090#1086#1095#1085#1086#1081' '#1089#1091#1084#1084#1077' '#1089#1095#1077#1090#1086#1074
        DataField = 'ShowPartialInvoice'
        DataSource = dsEntSettings
        TabOrder = 9
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox30: TDBCheckBox
        Left = 12
        Top = 256
        Width = 377
        Height = 17
        Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1087#1086#1083#1085#1086#1077' '#1080#1084#1103' '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072' '#1074' '#1089#1095#1077#1090#1072#1093' '#1080' '#1086#1087#1083#1072#1090#1072#1093
        DataField = 'ShowContragentFullName'
        DataSource = dsEntSettings
        TabOrder = 10
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox32: TDBCheckBox
        Left = 12
        Top = 278
        Width = 377
        Height = 17
        Caption = #1059#1082#1072#1079#1099#1074#1072#1090#1100' '#1085#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1091' '#1076#1083#1103' '#1089#1095#1077#1090#1072' ('#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1076#1083#1103' '#1089#1080#1085#1093#1088#1086#1085#1080#1079#1072#1094#1080#1080')'
        DataField = 'SyncProducts'
        DataSource = dsEntSettings
        TabOrder = 11
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox33: TDBCheckBox
        Left = 12
        Top = 300
        Width = 377
        Height = 17
        Caption = #1059#1087#1088#1086#1097#1077#1085#1085#1099#1077' '#1089#1086#1089#1090#1086#1103#1085#1080#1103' '#1086#1087#1083#1072#1090#1099' '#1089#1095#1077#1090#1072
        DataField = 'NewInvoicePayState'
        DataSource = dsEntSettings
        TabOrder = 12
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox34: TDBCheckBox
        Left = 12
        Top = 322
        Width = 377
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1092#1080#1083#1100#1090#1088' '#1087#1086' '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1091' '#1074' '#1089#1095#1077#1090#1072#1093
        DataField = 'ShowInvoicePayerFilter'
        DataSource = dsEntSettings
        TabOrder = 13
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox35: TDBCheckBox
        Left = 12
        Top = 344
        Width = 377
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1092#1080#1083#1100#1090#1088' '#1087#1086' '#1079#1072#1082#1072#1079#1095#1080#1082#1091' '#1074' '#1089#1095#1077#1090#1072#1093
        DataField = 'ShowInvoiceCustomerFilter'
        DataSource = dsEntSettings
        TabOrder = 14
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox37: TDBCheckBox
        Left = 12
        Top = 366
        Width = 317
        Height = 17
        Caption = #1062#1077#1085#1099' '#1074' '#1075#1088#1085'. ('#1091#1089#1090#1072#1085#1086#1074#1080#1090#1077' '#1082#1091#1088#1089' '#1091'.'#1077'. = 1)'
        DataField = 'NativeCurrency'
        DataSource = dsEntSettings
        TabOrder = 15
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
    end
    object tsPlan: TTabSheet
      Caption = #1055#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077
      ImageIndex = 3
      object DBCheckBox14: TDBCheckBox
        Left = 6
        Top = 12
        Width = 395
        Height = 17
        Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1088#1080' '#1076#1086#1073#1072#1074#1083#1077#1085#1080#1080' '#1074' '#1087#1083#1072#1085
        DataField = 'ShowAddPlanDialog'
        DataSource = dsEntSettings
        TabOrder = 0
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox15: TDBCheckBox
        Left = 6
        Top = 35
        Width = 387
        Height = 17
        Caption = #1057#1082#1088#1099#1074#1072#1090#1100' '#1090#1072#1073#1083#1080#1094#1091' '#1085#1077#1079#1072#1087#1083#1072#1085#1080#1088#1086#1074#1072#1085#1085#1099#1093' '#1088#1072#1073#1086#1090
        DataField = 'NewPlanInterface'
        DataSource = dsEntSettings
        TabOrder = 1
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox1: TDBCheckBox
        Left = 6
        Top = 58
        Width = 395
        Height = 17
        Caption = #1055#1088#1086#1074#1077#1088#1103#1090#1100' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1077' '#1086#1090#1084#1077#1090#1082#1080' '#1086' '#1085#1072#1095#1072#1083#1077' '#1080' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1080
        DataField = 'CheckOverdueJobs'
        DataSource = dsEntSettings
        TabOrder = 2
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox18: TDBCheckBox
        Left = 6
        Top = 81
        Width = 395
        Height = 17
        Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1080#1077' '#1086#1090#1084#1077#1090#1082#1080' '#1090#1086#1083#1100#1082#1086' '#1074' '#1087#1086#1088#1103#1076#1082#1077' '#1086#1095#1077#1088#1077#1076#1085#1086#1089#1090#1080' '#1088#1072#1073#1086#1090
        DataField = 'FactDateStrictOrder'
        DataSource = dsEntSettings
        TabOrder = 3
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox19: TDBCheckBox
        Left = 6
        Top = 104
        Width = 395
        Height = 17
        Caption = #1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1086#1077' '#1091#1082#1072#1079#1072#1085#1080#1077' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1081' '#1074#1099#1088#1072#1073#1086#1090#1082#1080
        DataField = 'RequireFactProductOut'
        DataSource = dsEntSettings
        TabOrder = 4
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox21: TDBCheckBox
        Left = 6
        Top = 127
        Width = 285
        Height = 17
        Caption = #1062#1074#1077#1090' '#1088#1072#1073#1086#1090#1099' '#1079#1072#1074#1080#1089#1080#1090' '#1086#1090' '#1089#1086#1089#1090#1086#1103#1085#1080#1103' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103
        DataField = 'JobColorByExecState'
        DataSource = dsEntSettings
        TabOrder = 5
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox22: TDBCheckBox
        Left = 6
        Top = 150
        Width = 285
        Height = 17
        Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1089#1086#1089#1090#1086#1103#1085#1080#1077' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1088#1072#1073#1086#1090#1099
        DataField = 'PlanShowExecState'
        DataSource = dsEntSettings
        TabOrder = 6
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox23: TDBCheckBox
        Left = 6
        Top = 173
        Width = 285
        Height = 17
        Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1089#1086#1089#1090#1086#1103#1085#1080#1077' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1079#1072#1082#1072#1079#1072
        DataField = 'PlanShowOrderState'
        DataSource = dsEntSettings
        TabOrder = 7
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox25: TDBCheckBox
        Left = 6
        Top = 196
        Width = 321
        Height = 17
        Caption = #1042#1099#1076#1077#1083#1103#1090#1100' '#1087#1088#1086#1087#1091#1089#1082#1080' '#1074' '#1087#1083#1072#1085#1077' '
        DataField = 'RedScheduleSpace'
        DataSource = dsEntSettings
        TabOrder = 8
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox27: TDBCheckBox
        Left = 6
        Top = 219
        Width = 321
        Height = 17
        Caption = #1056#1072#1079#1073#1080#1074#1072#1090#1100' '#1088#1072#1073#1086#1090#1099' '#1085#1072' '#1075#1088#1072#1085#1080#1094#1077' '#1089#1084#1077#1085' ('#1085#1077' '#1088#1077#1082#1086#1084#1077#1085#1076#1091#1077#1090#1089#1103')'
        DataField = 'SplitJobs'
        DataSource = dsEntSettings
        TabOrder = 9
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
    end
    object tsFiles: TTabSheet
      Caption = #1060#1072#1081#1083#1099
      ImageIndex = 4
      object Label3: TLabel
        Left = 16
        Top = 16
        Width = 232
        Height = 13
        Caption = #1055#1072#1087#1082#1072' '#1076#1083#1103' '#1093#1088#1072#1085#1077#1085#1080#1103' '#1087#1088#1080#1082#1088#1077#1087#1083#1077#1085#1085#1099#1093' '#1092#1072#1081#1083#1086#1074':'
      end
      object DirEditAttached: TJvDirectoryEdit
        Left = 16
        Top = 35
        Width = 377
        Height = 21
        DialogKind = dkWin32
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel
    Left = 6
    Top = 500
    Width = 423
    Height = 55
    Anchors = [akLeft, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    DesignSize = (
      423
      55)
    object Memo1: TMemo
      Left = 8
      Top = 6
      Width = 407
      Height = 45
      Anchors = [akLeft, akTop, akRight]
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1103#1074#1083#1103#1102#1090#1089#1103' '#1086#1073#1097#1080#1084#1080' '#1076#1083#1103' '#1074#1089#1077#1093' '#1088#1072#1073#1086#1095#1080#1093' '#1084#1077#1089#1090' '#1087#1088#1077#1076#1087#1088#1080#1103#1090#1080#1103'. '
        
          #1044#1083#1103' '#1090#1086#1075#1086', '#1095#1090#1086#1073#1099' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1101#1090#1080#1093' '#1085#1072#1089#1090#1088#1086#1077#1082' '#1074#1089#1090#1091#1087#1080#1083#1080' '#1074' '#1076#1077#1081#1089#1090#1074#1080#1077', '#1085#1077#1086 +
          #1073#1093#1086#1076#1080#1084' '
        #1087#1077#1088#1077#1079#1072#1087#1091#1089#1082' '#1082#1083#1080#1077#1085#1090#1089#1082#1080#1093' '#1087#1088#1086#1075#1088#1072#1084#1084' '#1085#1072' '#1074#1089#1077#1093' '#1088#1072#1073#1086#1095#1080#1093' '#1084#1077#1089#1090#1072#1093'.')
      TabOrder = 0
    end
  end
  object btOk: TButton
    Left = 274
    Top = 564
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btCancel: TButton
    Left = 356
    Top = 564
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object dsEntSettings: TDataSource
    Left = 26
    Top = 394
  end
end
