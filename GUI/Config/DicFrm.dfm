object DicEditForm: TDicEditForm
  Left = 131
  Top = 682
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1094#1080#1103
  ClientHeight = 539
  ClientWidth = 702
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
  PixelsPerInch = 96
  TextHeight = 13
  object pcConf: TPageControl
    Left = 0
    Top = 0
    Width = 702
    Height = 503
    ActivePage = tsUser
    Align = alClient
    TabOrder = 0
    OnChange = pcConfChange
    OnChanging = pcConfChanging
    object tsSrvGrp: TTabSheet
      Caption = #1043#1088#1091#1087#1087#1099' '#1080' '#1089#1090#1088#1072#1085#1080#1094#1099
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object paGrpLeft: TPanel
        Left = 0
        Top = 0
        Width = 293
        Height = 475
        Align = alLeft
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 0
        object dgSrvGroups: TJvDBGrid
          Left = 0
          Top = 21
          Width = 293
          Height = 340
          Align = alClient
          DataSource = sdm.dsSrvGrps
          Options = [dgTitles, dgIndicator, dgColumnResize, dgRowLines, dgRowSelect, dgCancelOnExit]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          IniStorage = JvFormStorage1
          SelectColumnsDialogStrings.Caption = 'Select columns'
          SelectColumnsDialogStrings.OK = '&OK'
          SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
          EditControls = <>
          RowsHeight = 17
          TitleRowHeight = 17
          Columns = <
            item
              Expanded = False
              FieldName = 'GrpNumber'
              Title.Alignment = taCenter
              Title.Caption = #8470
              Width = 22
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'GrpDesc'
              Title.Caption = #1048#1084#1103
              Width = 237
              Visible = True
            end>
        end
        object Panel7: TPanel
          Left = 0
          Top = 0
          Width = 293
          Height = 21
          Align = alTop
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 1
          object Label2: TLabel
            Left = 4
            Top = 4
            Width = 44
            Height = 13
            Caption = #1043#1088#1091#1087#1087#1099
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
        object Panel6: TPanel
          Left = 0
          Top = 361
          Width = 293
          Height = 114
          Align = alBottom
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 2
          object sbNewGrp: TSpeedButton
            Left = 2
            Top = 4
            Width = 99
            Height = 25
            Caption = #1053#1086#1074#1072#1103' '#1075#1088#1091#1087#1087#1072
            OnClick = sbNewGrpClick
          end
          object sbDelGrp: TSpeedButton
            Left = 110
            Top = 4
            Width = 111
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100' '#1075#1088#1091#1087#1087#1091'...'
            OnClick = sbDelGrpClick
          end
          object GroupBox1: TGroupBox
            Left = 0
            Top = 34
            Width = 289
            Height = 75
            Caption = ' '#1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1075#1088#1091#1087#1087#1099' '
            TabOrder = 0
            object Label8: TLabel
              Left = 12
              Top = 49
              Width = 31
              Height = 13
              Caption = #1053#1086#1084#1077#1088
            end
            object vgDBSpinEdit2: TJvDBSpinEdit
              Left = 56
              Top = 46
              Width = 65
              Height = 21
              MaxValue = 20000.000000000000000000
              TabOrder = 0
              DataField = 'GrpNumber'
              DataSource = sdm.dsSrvGrps
            end
            object DBEdit3: TDBEdit
              Left = 12
              Top = 20
              Width = 261
              Height = 21
              DataField = 'GrpDesc'
              DataSource = sdm.dsSrvGrps
              TabOrder = 1
            end
          end
        end
      end
      object spPages: TJvxSplitter
        Left = 293
        Top = 0
        Width = 3
        Height = 475
        ControlFirst = paGrpLeft
        Align = alLeft
        BevelOuter = bvNone
        Color = clBtnShadow
      end
      object Panel4: TPanel
        Left = 296
        Top = 0
        Width = 398
        Height = 475
        Align = alClient
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 2
        object paSrvPages: TPanel
          Left = 0
          Top = 0
          Width = 398
          Height = 346
          Align = alClient
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 0
          object Panel8: TPanel
            Left = 0
            Top = 0
            Width = 398
            Height = 21
            Align = alTop
            BevelOuter = bvNone
            Caption = ' '
            TabOrder = 0
            object Label7: TLabel
              Left = 8
              Top = 4
              Width = 59
              Height = 13
              Caption = #1057#1090#1088#1072#1085#1080#1094#1099
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
          end
          object dgGrpPages: TJvDBGrid
            Left = 0
            Top = 21
            Width = 398
            Height = 188
            Align = alClient
            DataSource = sdm.dsSrvPages
            Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgRowLines, dgConfirmDelete, dgCancelOnExit]
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            IniStorage = JvFormStorage1
            SelectColumnsDialogStrings.Caption = 'Select columns'
            SelectColumnsDialogStrings.OK = '&OK'
            SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
            EditControls = <>
            RowsHeight = 17
            TitleRowHeight = 17
            Columns = <
              item
                Alignment = taCenter
                Expanded = False
                FieldName = 'GrpOrderNum'
                Title.Alignment = taCenter
                Title.Caption = #8470' '#1074' '#1075#1088#1091#1087#1087#1077
                Width = 70
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'PageCaption'
                Title.Caption = #1048#1084#1103
                Width = 227
                Visible = True
              end>
          end
          object Panel9: TPanel
            Left = 0
            Top = 209
            Width = 398
            Height = 137
            Align = alBottom
            BevelOuter = bvNone
            Caption = ' '
            TabOrder = 2
            object sbNewSrvPage: TSpeedButton
              Left = 6
              Top = 4
              Width = 83
              Height = 25
              Caption = #1053#1086#1074#1072#1103
              OnClick = sbNewSrvPageClick
            end
            object sbDelSrvGrp: TSpeedButton
              Left = 98
              Top = 4
              Width = 83
              Height = 25
              Caption = #1059#1076#1072#1083#1080#1090#1100'...'
              OnClick = sbDelSrvGrpClick
            end
            object Label11: TLabel
              Left = 200
              Top = 8
              Width = 13
              Height = 13
              Caption = #8470
            end
            object DBCheckBox3: TDBCheckBox
              Left = 8
              Top = 36
              Width = 161
              Height = 17
              Caption = #1042#1089#1090#1088#1086#1077#1085#1085#1072#1103' '#1089#1090#1088#1072#1085#1080#1094#1072
              DataField = 'PageBuiltIn'
              DataSource = sdm.dsSrvPages
              ReadOnly = True
              TabOrder = 0
              ValueChecked = 'True'
              ValueUnchecked = 'False'
            end
            object JvDBSpinEdit1: TJvDBSpinEdit
              Left = 216
              Top = 4
              Width = 57
              Height = 21
              MaxValue = 20000.000000000000000000
              TabOrder = 1
              DataField = 'GrpOrderNum'
              DataSource = sdm.dsSrvPages
            end
            object DBCheckBox5: TDBCheckBox
              Left = 8
              Top = 82
              Width = 229
              Height = 17
              Caption = #1057#1086#1079#1076#1072#1074#1072#1090#1100' '#1089#1090#1088#1072#1085#1080#1094#1091' '#1087#1088#1080' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086#1089#1090#1080
              DataField = 'CreateFrameOnShow'
              DataSource = sdm.dsSrvPages
              TabOrder = 2
              ValueChecked = 'True'
              ValueUnchecked = 'False'
            end
            object btEditOnCreateFrame: TButton
              Left = 140
              Top = 100
              Width = 95
              Height = 25
              Caption = #1057#1094#1077#1085#1072#1088#1080#1081'...'
              TabOrder = 3
              OnClick = btEditOnCreateFrameClick
            end
            object DBCheckBox6: TDBCheckBox
              Left = 8
              Top = 104
              Width = 125
              Height = 17
              Caption = #1057#1094#1077#1085#1072#1088#1080#1081' '#1089#1086#1079#1076#1072#1085#1080#1103
              DataField = 'EnableOnCreateFrame'
              DataSource = sdm.dsSrvPages
              TabOrder = 4
              ValueChecked = 'True'
              ValueUnchecked = 'False'
            end
            object DBCheckBox7: TDBCheckBox
              Left = 8
              Top = 60
              Width = 173
              Height = 17
              Caption = #1057#1086#1079#1076#1072#1074#1072#1090#1100' '#1087#1091#1089#1090#1091#1102' '#1089#1090#1088#1072#1085#1080#1094#1091
              DataField = 'EmptyFrame'
              DataSource = sdm.dsSrvPages
              TabOrder = 5
              ValueChecked = 'True'
              ValueUnchecked = 'False'
            end
          end
        end
        object JvxSplitter3: TJvxSplitter
          Left = 0
          Top = 346
          Width = 398
          Height = 3
          ControlFirst = paSrvPages
          Align = alBottom
          BevelOuter = bvNone
          Color = clBtnShadow
        end
        object Panel10: TPanel
          Left = 0
          Top = 349
          Width = 398
          Height = 126
          Align = alBottom
          BevelOuter = bvNone
          Caption = 'Panel10'
          TabOrder = 2
          object dgPageGrids: TJvDBGrid
            Left = 0
            Top = 21
            Width = 398
            Height = 105
            Align = alClient
            DataSource = sdm.dsPageGrids
            Options = [dgEditing, dgTitles, dgColumnResize, dgRowLines, dgConfirmDelete, dgCancelOnExit]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            IniStorage = JvFormStorage1
            SelectColumnsDialogStrings.Caption = 'Select columns'
            SelectColumnsDialogStrings.OK = '&OK'
            SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
            EditControls = <>
            RowsHeight = 17
            TitleRowHeight = 17
            Columns = <
              item
                Expanded = False
                FieldName = 'PageOrderNum'
                Title.Caption = #8470
                Width = 24
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'GridCaption'
                Title.Caption = #1058#1072#1073#1083#1080#1094#1072
                Width = 140
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'SrvDesc'
                ReadOnly = True
                Title.Caption = #1055#1088#1086#1094#1077#1089#1089
                Width = 176
                Visible = True
              end>
          end
          object Panel11: TPanel
            Left = 0
            Top = 0
            Width = 398
            Height = 21
            Align = alTop
            BevelOuter = bvNone
            Caption = ' '
            TabOrder = 1
            object Label9: TLabel
              Left = 5
              Top = 4
              Width = 127
              Height = 13
              Caption = #1058#1072#1073#1083#1080#1094#1099' '#1085#1072' '#1089#1090#1088#1072#1085#1080#1094#1077
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
          end
        end
      end
    end
    object tsOrdKind: TTabSheet
      Caption = #1042#1080#1076#1099' '#1079#1072#1082#1072#1079#1086#1074
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object spKind: TJvxSplitter
        Left = 293
        Top = 0
        Width = 3
        Height = 475
        Align = alLeft
        BevelOuter = bvNone
        Color = clBtnShadow
      end
      object paKinds: TPanel
        Left = 0
        Top = 0
        Width = 293
        Height = 475
        Align = alLeft
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 1
        object dgOrderKind: TJvDBGrid
          Left = 0
          Top = 21
          Width = 293
          Height = 329
          Align = alClient
          DataSource = sdm.dsOrderKind
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgRowLines, dgCancelOnExit]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          IniStorage = JvFormStorage1
          SelectColumnsDialogStrings.Caption = 'Select columns'
          SelectColumnsDialogStrings.OK = '&OK'
          SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
          EditControls = <>
          RowsHeight = 17
          TitleRowHeight = 17
          Columns = <
            item
              Expanded = False
              FieldName = 'KindID'
              Title.Caption = 'ID'
              Width = 23
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'KindDesc'
              Title.Caption = #1048#1084#1103
              Width = 237
              Visible = True
            end>
        end
        object Panel15: TPanel
          Left = 0
          Top = 0
          Width = 293
          Height = 21
          Align = alTop
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 1
          object Label3: TLabel
            Left = 4
            Top = 4
            Width = 32
            Height = 13
            Caption = #1042#1080#1076#1099
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
        object Panel16: TPanel
          Left = 0
          Top = 350
          Width = 293
          Height = 125
          Align = alBottom
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 2
          DesignSize = (
            293
            125)
          object sbNewKind: TSpeedButton
            Left = 2
            Top = 4
            Width = 93
            Height = 25
            Caption = #1053#1086#1074#1099#1081' '#1074#1080#1076
            OnClick = sbNewKindClick
          end
          object sbDelKind: TSpeedButton
            Left = 104
            Top = 4
            Width = 105
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100' '#1074#1080#1076'...'
            OnClick = sbDelKindClick
          end
          object GroupBox3: TGroupBox
            Left = 0
            Top = 36
            Width = 289
            Height = 84
            Anchors = [akLeft, akTop, akRight, akBottom]
            Caption = ' '#1048#1084#1103' '#1074#1080#1076#1072' '
            TabOrder = 0
            object Label21: TLabel
              Left = 12
              Top = 56
              Width = 87
              Height = 13
              Caption = #1043#1083#1072#1074#1085#1099#1081' '#1087#1088#1086#1094#1077#1089#1089
            end
            object DBEdit4: TDBEdit
              Left = 12
              Top = 22
              Width = 261
              Height = 21
              DataField = 'KindDesc'
              DataSource = sdm.dsOrderKind
              TabOrder = 0
            end
            object cbMainProcess: TDBLookupComboBox
              Left = 108
              Top = 52
              Width = 165
              Height = 21
              DataField = 'MainProcessID'
              DataSource = sdm.dsOrderKind
              KeyField = 'SrvID'
              ListField = 'SrvDesc'
              ListSource = sdm.dsServices
              TabOrder = 1
            end
          end
        end
      end
      object paProcessKinds: TPanel
        Left = 296
        Top = 0
        Width = 398
        Height = 475
        Align = alClient
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 2
        object Panel18: TPanel
          Left = 0
          Top = 0
          Width = 398
          Height = 21
          Align = alTop
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 0
          object Label10: TLabel
            Left = 8
            Top = 4
            Width = 59
            Height = 13
            Caption = #1055#1088#1086#1094#1077#1089#1089#1099
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
        object dgKindProcess: TJvDBGrid
          Left = 0
          Top = 21
          Width = 398
          Height = 374
          Align = alClient
          DataSource = sdm.dsKindProcess
          Options = [dgTitles, dgIndicator, dgColumnResize, dgRowLines, dgConfirmDelete, dgCancelOnExit]
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          IniStorage = JvFormStorage1
          SelectColumnsDialogStrings.Caption = 'Select columns'
          SelectColumnsDialogStrings.OK = '&OK'
          SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
          EditControls = <>
          RowsHeight = 17
          TitleRowHeight = 17
          Columns = <
            item
              Expanded = False
              FieldName = 'ProcessName'
              Title.Caption = #1048#1084#1103
              Width = 323
              Visible = True
            end>
        end
        object Panel19: TPanel
          Left = 0
          Top = 395
          Width = 398
          Height = 80
          Align = alBottom
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 2
          object sbAddKindProcess: TSpeedButton
            Left = 6
            Top = 4
            Width = 83
            Height = 25
            Caption = #1044#1086#1073#1072#1074#1080#1090#1100
            OnClick = sbAddKindProcessClick
          end
          object sbDeleteKindProcess: TSpeedButton
            Left = 204
            Top = 4
            Width = 83
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100'...'
            OnClick = sbDeleteKindProcessClick
          end
          object sbAddAllKindProcess: TSpeedButton
            Left = 98
            Top = 4
            Width = 97
            Height = 25
            Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074#1089#1077
            OnClick = sbAddAllKindProcessClick
          end
          object DBCheckBox2: TDBCheckBox
            Left = 8
            Top = 36
            Width = 237
            Height = 17
            Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1076#1086#1073#1072#1074#1083#1103#1090#1100' '#1074' '#1087#1088#1086#1089#1095#1077#1090#1099
            DataField = 'AutoAddDraft'
            DataSource = sdm.dsKindProcess
            ReadOnly = True
            TabOrder = 0
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object DBCheckBox9: TDBCheckBox
            Left = 8
            Top = 57
            Width = 223
            Height = 17
            Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1076#1086#1073#1072#1074#1083#1103#1090#1100' '#1074' '#1079#1072#1082#1072#1079#1099
            DataField = 'AutoAddWork'
            DataSource = sdm.dsKindProcess
            TabOrder = 1
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
        end
      end
    end
    object tsUser: TTabSheet
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080' '#1080' '#1087#1088#1072#1074#1072
      ImageIndex = 5
      object paUsers: TPanel
        Left = 0
        Top = 0
        Width = 293
        Height = 475
        Align = alLeft
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 0
        object dgUsers: TDBGridEh
          Left = 0
          Top = 21
          Width = 293
          Height = 264
          Align = alClient
          DataGrouping.GroupLevels = <>
          DataSource = adm.dsAccessUser
          Flat = False
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'Tahoma'
          FooterFont.Style = []
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgRowLines, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove, dghExtendVertLines]
          PopupMenu = pmUserPass
          RowDetailPanel.Color = clBtnFace
          SortLocal = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnGetCellParams = dgUsersGetCellParams
          Columns = <
            item
              EditButtons = <>
              FieldName = 'AccessUserID'
              Footers = <>
              Title.Caption = 'ID'
              Title.TitleButton = True
              Width = 23
            end
            item
              EditButtons = <>
              FieldName = 'Login'
              Footers = <>
              Title.Caption = #1051#1086#1075#1080#1085
              Title.TitleButton = True
              Width = 80
            end
            item
              EditButtons = <>
              FieldName = 'Name'
              Footers = <>
              Title.Caption = #1048#1084#1103
              Title.TitleButton = True
              Width = 154
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
        object Panel21: TPanel
          Left = 0
          Top = 0
          Width = 293
          Height = 21
          Align = alTop
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 1
          object Label13: TLabel
            Left = 4
            Top = 4
            Width = 83
            Height = 13
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
        object Panel22: TPanel
          Left = 0
          Top = 285
          Width = 293
          Height = 190
          Align = alBottom
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 2
          object sbAddUser: TSpeedButton
            Left = 4
            Top = 160
            Width = 75
            Height = 25
            Caption = #1053#1086#1074#1099#1081
            OnClick = sbAddUserClick
          end
          object sbDelUser: TSpeedButton
            Left = 86
            Top = 160
            Width = 77
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100'...'
            OnClick = sbDelUserClick
          end
          object sbCopyUser: TSpeedButton
            Left = 172
            Top = 160
            Width = 113
            Height = 25
            Caption = #1057#1086#1079#1076#1072#1090#1100' '#1082#1086#1087#1080#1102
            OnClick = sbCopyUserClick
          end
          object Label15: TLabel
            Left = 4
            Top = 10
            Width = 30
            Height = 13
            Caption = #1051#1086#1075#1080#1085
          end
          object Label16: TLabel
            Left = 4
            Top = 38
            Width = 19
            Height = 13
            Caption = #1048#1084#1103
          end
          object Label17: TLabel
            Left = 138
            Top = 10
            Width = 50
            Height = 13
            Caption = #1057#1086#1082#1088'. '#1080#1084#1103
          end
          object Label19: TLabel
            Left = 4
            Top = 91
            Width = 131
            Height = 13
            Caption = #1042#1080#1076' '#1079#1072#1082#1072#1079#1072' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
          end
          object Label20: TLabel
            Left = 4
            Top = 66
            Width = 24
            Height = 13
            Caption = #1056#1086#1083#1100
          end
          object DBEdit5: TDBEdit
            Left = 42
            Top = 8
            Width = 85
            Height = 21
            DataField = 'Login'
            DataSource = adm.dsAccessUser
            TabOrder = 0
          end
          object DBEdit6: TDBEdit
            Left = 42
            Top = 35
            Width = 221
            Height = 21
            DataField = 'Name'
            DataSource = adm.dsAccessUser
            TabOrder = 1
          end
          object DBEdit7: TDBEdit
            Left = 200
            Top = 8
            Width = 63
            Height = 21
            DataField = 'ShortName'
            DataSource = adm.dsAccessUser
            TabOrder = 2
          end
          object cbDefOrderKind: TJvDBLookupCombo
            Left = 4
            Top = 111
            Width = 261
            Height = 22
            DataField = 'DefaultKindID'
            DataSource = adm.dsAccessUser
            DisplayEmpty = '<'#1085#1077' '#1091#1082#1072#1079#1072#1085'>'
            EmptyValue = '0'
            EmptyItemColor = clScrollBar
            IgnoreCase = False
            ItemHeight = 17
            LookupField = 'KindID'
            LookupDisplay = 'KindDesc'
            LookupSource = sdm.dsOrderKind
            TabOrder = 3
          end
          object DBCheckBox4: TDBCheckBox
            Left = 4
            Top = 137
            Width = 125
            Height = 17
            Caption = #1071#1074#1083#1103#1077#1090#1089#1103' '#1088#1086#1083#1100#1102
            DataField = 'IsRole'
            DataSource = adm.dsAccessUser
            TabOrder = 4
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object JvDBLookupCombo1: TJvDBLookupCombo
            Left = 42
            Top = 62
            Width = 223
            Height = 22
            DataField = 'RoleID'
            DataSource = adm.dsAccessUser
            DisplayEmpty = '<'#1085#1077' '#1091#1082#1072#1079#1072#1085#1072'>'
            EmptyValue = '0'
            EmptyItemColor = clScrollBar
            IgnoreCase = False
            ItemHeight = 17
            LookupField = 'AccessUserID'
            LookupDisplay = 'Name'
            LookupSource = dsUserRoles
            TabOrder = 5
          end
        end
      end
      object Panel23: TPanel
        Left = 296
        Top = 0
        Width = 398
        Height = 475
        Align = alClient
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 1
        object paKindAccessHeader: TPanel
          Left = 0
          Top = 0
          Width = 398
          Height = 16
          Align = alTop
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 0
          object Label14: TLabel
            Left = 8
            Top = 4
            Width = 161
            Height = 13
            Caption = #1055#1088#1072#1074#1072' '#1076#1086#1089#1090#1091#1087#1072' '#1080' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
        object paKindAccess: TPanel
          Left = 0
          Top = 16
          Width = 398
          Height = 459
          Align = alClient
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 1
          object paUserAccess: TPanel
            Left = 0
            Top = 0
            Width = 398
            Height = 184
            Align = alTop
            BevelOuter = bvNone
            BorderWidth = 5
            Caption = ' '
            TabOrder = 0
            object boxUserAccess: TJvxCheckListBox
              Left = 5
              Top = 5
              Width = 388
              Height = 145
              Align = alClient
              AutoScroll = False
              BorderStyle = bsNone
              Color = clBtnFace
              ItemHeight = 13
              TabOrder = 0
              InternalVersion = 202
            end
            object Panel26: TPanel
              Left = 5
              Top = 150
              Width = 388
              Height = 29
              Align = alBottom
              BevelOuter = bvNone
              Caption = ' '
              TabOrder = 1
              Visible = False
              object sbCheckAllUser: TSpeedButton
                Left = 0
                Top = 4
                Width = 111
                Height = 25
                Caption = #1042#1089#1077' '#1088#1072#1079#1088#1077#1096#1080#1090#1100
                Glyph.Data = {
                  42020000424D4202000000000000420000002800000010000000100000000100
                  10000300000000020000920B0000920B00000000000000000000007C0000E003
                  00001F0000001F7CE161A155A155A155A155A155A155A155A155A155A155A155
                  A155A1551F7C1F7C216E097F097F097F097F097F097F097F097F097F097F097F
                  097FA1551F7C1F7C216E097FB556734E734E734E734E734E734E734E734E734E
                  097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F734E
                  097FA1551F7C1F7C216E097FB556FF7FFF7F0D33DC73FF7FFF7FFF7FFF7F734E
                  097FA1551F7C1F7C216E097FB556FF7F975BA40AC71AFF7FFF7FFF7FFF7F734E
                  097FA1551F7C1F7C216E097FB556FF7FEA26C512A40A7453FF7FFF7FFF7F734E
                  097FA1551F7C1F7C216E097FB556524BA40A303F2E37C616DD77FF7FFF7F734E
                  097FA1551F7C1F7C216E097FB556524BC716DC73DD77C71A2E37FF7FFF7F734E
                  097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FB967C512965BFF7F734E
                  097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7F965BC612DB6F734E
                  097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7F965BE922524E
                  097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7FFF7F965B0912
                  E97AA1551F7C1F7C0166097FB556B556514ACD398C318C318C318C31B5563156
                  646DE1611F7C1F7C1F7C0166016601669352FF7F9C739C73D65A8C31C159E161
                  E1611F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C935293529352514A1F7C1F7C1F7C
                  1F7C1F7C1F7C}
                OnClick = sbCheckAllUserClick
              end
              object sbUnCheckAllUser: TSpeedButton
                Left = 122
                Top = 4
                Width = 111
                Height = 25
                Caption = #1042#1089#1077' '#1079#1072#1087#1088#1077#1090#1080#1090#1100
                Glyph.Data = {
                  42020000424D4202000000000000420000002800000010000000100000000100
                  10000300000000020000920B0000920B00000000000000000000007C0000E003
                  00001F0000001F7CE161A155A155A155A155A155A155A155A155A155A155A155
                  A155A1551F7C1F7C216E097F097F097F097F097F097F097F097F097F097F097F
                  097FA1551F7C1F7C216E097FB556734E734E734E734E734E734E734E734E734E
                  097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F734E
                  097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F734E
                  097FA1551F7C1F7C216E097FB556056C007CFF7FFF7FFF7FFF7F056CFF7F734E
                  097FA1551F7C1F7C216E097FB556FF7F056C007CFF7FFF7F056C007CFF7F734E
                  097FA1551F7C1F7C216E097FB556FF7FFF7F007C056C056C007CFF7FFF7F734E
                  097FA1551F7C1F7C216E097FB556FF7FFF7FAA7D007CAA7DFF7FFF7FFF7F734E
                  097FA1551F7C1F7C216E097FB556FF7F056C007CFF7F056C007CFF7FFF7F734E
                  097FA1551F7C1F7C216E097FB556056C007CFF7FFF7FFF7F056C007CFF7F734E
                  097FA1551F7C1F7C216E097FB556007CFF7FFF7FFF7FFF7FFF7F056CFF7F524E
                  097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F0912
                  E97AA1551F7C1F7C0166097FB556B556514ACD398C318C318C318C31B5563156
                  646DE1611F7C1F7C1F7C0166016601669352FF7F9C739C73D65A8C31C159E161
                  E1611F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C935293529352514A1F7C1F7C1F7C
                  1F7C1F7C1F7C}
                OnClick = sbUnCheckAllUserClick
              end
            end
          end
          object JvxSplitter7: TJvxSplitter
            Left = 0
            Top = 184
            Width = 398
            Height = 3
            ControlFirst = paUserAccess
            Align = alTop
            BevelOuter = bvNone
            Color = clBtnShadow
          end
          object pcKindAccess: TPageControl
            Left = 0
            Top = 234
            Width = 398
            Height = 225
            ActivePage = tsKindXS
            Align = alClient
            TabOrder = 2
            object tsKindXS: TTabSheet
              Caption = #1054#1073#1097#1080#1077
              object Panel27: TPanel
                Left = 0
                Top = 168
                Width = 390
                Height = 29
                Align = alBottom
                BevelOuter = bvNone
                Caption = ' '
                TabOrder = 0
                object sbCheckAllKind: TSpeedButton
                  Left = 0
                  Top = 4
                  Width = 109
                  Height = 25
                  Caption = #1042#1089#1077' '#1088#1072#1079#1088#1077#1096#1080#1090#1100
                  Glyph.Data = {
                    42020000424D4202000000000000420000002800000010000000100000000100
                    10000300000000020000920B0000920B00000000000000000000007C0000E003
                    00001F0000001F7CE161A155A155A155A155A155A155A155A155A155A155A155
                    A155A1551F7C1F7C216E097F097F097F097F097F097F097F097F097F097F097F
                    097FA1551F7C1F7C216E097FB556734E734E734E734E734E734E734E734E734E
                    097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F734E
                    097FA1551F7C1F7C216E097FB556FF7FFF7F0D33DC73FF7FFF7FFF7FFF7F734E
                    097FA1551F7C1F7C216E097FB556FF7F975BA40AC71AFF7FFF7FFF7FFF7F734E
                    097FA1551F7C1F7C216E097FB556FF7FEA26C512A40A7453FF7FFF7FFF7F734E
                    097FA1551F7C1F7C216E097FB556524BA40A303F2E37C616DD77FF7FFF7F734E
                    097FA1551F7C1F7C216E097FB556524BC716DC73DD77C71A2E37FF7FFF7F734E
                    097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FB967C512965BFF7F734E
                    097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7F965BC612DB6F734E
                    097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7F965BE922524E
                    097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7FFF7F965B0912
                    E97AA1551F7C1F7C0166097FB556B556514ACD398C318C318C318C31B5563156
                    646DE1611F7C1F7C1F7C0166016601669352FF7F9C739C73D65A8C31C159E161
                    E1611F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C935293529352514A1F7C1F7C1F7C
                    1F7C1F7C1F7C}
                  OnClick = sbCheckAllKindClick
                end
                object sbUncheckAllKind: TSpeedButton
                  Left = 116
                  Top = 4
                  Width = 113
                  Height = 25
                  Caption = #1042#1089#1077' '#1079#1072#1087#1088#1077#1090#1080#1090#1100
                  Glyph.Data = {
                    42020000424D4202000000000000420000002800000010000000100000000100
                    10000300000000020000920B0000920B00000000000000000000007C0000E003
                    00001F0000001F7CE161A155A155A155A155A155A155A155A155A155A155A155
                    A155A1551F7C1F7C216E097F097F097F097F097F097F097F097F097F097F097F
                    097FA1551F7C1F7C216E097FB556734E734E734E734E734E734E734E734E734E
                    097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F734E
                    097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F734E
                    097FA1551F7C1F7C216E097FB556056C007CFF7FFF7FFF7FFF7F056CFF7F734E
                    097FA1551F7C1F7C216E097FB556FF7F056C007CFF7FFF7F056C007CFF7F734E
                    097FA1551F7C1F7C216E097FB556FF7FFF7F007C056C056C007CFF7FFF7F734E
                    097FA1551F7C1F7C216E097FB556FF7FFF7FAA7D007CAA7DFF7FFF7FFF7F734E
                    097FA1551F7C1F7C216E097FB556FF7F056C007CFF7F056C007CFF7FFF7F734E
                    097FA1551F7C1F7C216E097FB556056C007CFF7FFF7FFF7F056C007CFF7F734E
                    097FA1551F7C1F7C216E097FB556007CFF7FFF7FFF7FFF7FFF7F056CFF7F524E
                    097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F0912
                    E97AA1551F7C1F7C0166097FB556B556514ACD398C318C318C318C31B5563156
                    646DE1611F7C1F7C1F7C0166016601669352FF7F9C739C73D65A8C31C159E161
                    E1611F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C935293529352514A1F7C1F7C1F7C
                    1F7C1F7C1F7C}
                  OnClick = sbUncheckAllKindClick
                end
              end
              object boxKindAccess: TJvxCheckListBox
                Left = 0
                Top = 0
                Width = 390
                Height = 168
                Align = alClient
                AutoScroll = False
                BorderStyle = bsNone
                ItemHeight = 13
                TabOrder = 1
                InternalVersion = 202
              end
            end
            object tsProcXS: TTabSheet
              Caption = #1055#1088#1086#1094#1077#1089#1089#1099
              ImageIndex = 1
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object dgProcessAccess: TMyDBGridEh
                Left = 0
                Top = 0
                Width = 216
                Height = 197
                Align = alClient
                AllowedOperations = []
                AllowedSelections = [gstRecordBookmarks]
                AutoFitColWidths = True
                DataGrouping.GroupLevels = <>
                DataSource = adm.dsAccessProc
                Flat = True
                FooterColor = clWindow
                FooterFont.Charset = DEFAULT_CHARSET
                FooterFont.Color = clWindowText
                FooterFont.Height = -11
                FooterFont.Name = 'Tahoma'
                FooterFont.Style = []
                Options = [dgColumnResize, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
                OptionsEh = [dghHighlightFocus, dghClearSelection, dghDialogFind, dghColumnResize, dghColumnMove]
                RowDetailPanel.Color = clBtnFace
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'Tahoma'
                TitleFont.Style = []
                IniStorage = JvFormStorage1
                Columns = <
                  item
                    EditButtons = <>
                    FieldName = 'ProcessName'
                    Footers = <>
                    Title.Caption = 'ID'
                    Width = 151
                  end>
                object RowDetailData: TRowDetailPanelControlEh
                end
              end
              object paProcessAccess: TPanel
                Left = 219
                Top = 0
                Width = 171
                Height = 197
                Align = alRight
                BevelOuter = bvNone
                Caption = ' '
                TabOrder = 1
                object boxProcAccess: TJvxCheckListBox
                  Left = 0
                  Top = 0
                  Width = 171
                  Height = 136
                  Align = alClient
                  BorderStyle = bsNone
                  Color = clBtnFace
                  ItemHeight = 13
                  TabOrder = 0
                  InternalVersion = 202
                end
                object Panel28: TPanel
                  Left = 0
                  Top = 136
                  Width = 171
                  Height = 61
                  Align = alBottom
                  BevelOuter = bvNone
                  Caption = ' '
                  TabOrder = 1
                  object sbCheckAllKindProcess: TSpeedButton
                    Left = 6
                    Top = 4
                    Width = 109
                    Height = 25
                    Caption = #1042#1089#1077' '#1088#1072#1079#1088#1077#1096#1080#1090#1100
                    Glyph.Data = {
                      42020000424D4202000000000000420000002800000010000000100000000100
                      10000300000000020000920B0000920B00000000000000000000007C0000E003
                      00001F0000001F7CE161A155A155A155A155A155A155A155A155A155A155A155
                      A155A1551F7C1F7C216E097F097F097F097F097F097F097F097F097F097F097F
                      097FA1551F7C1F7C216E097FB556734E734E734E734E734E734E734E734E734E
                      097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F734E
                      097FA1551F7C1F7C216E097FB556FF7FFF7F0D33DC73FF7FFF7FFF7FFF7F734E
                      097FA1551F7C1F7C216E097FB556FF7F975BA40AC71AFF7FFF7FFF7FFF7F734E
                      097FA1551F7C1F7C216E097FB556FF7FEA26C512A40A7453FF7FFF7FFF7F734E
                      097FA1551F7C1F7C216E097FB556524BA40A303F2E37C616DD77FF7FFF7F734E
                      097FA1551F7C1F7C216E097FB556524BC716DC73DD77C71A2E37FF7FFF7F734E
                      097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FB967C512965BFF7F734E
                      097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7F965BC612DB6F734E
                      097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7F965BE922524E
                      097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7FFF7F965B0912
                      E97AA1551F7C1F7C0166097FB556B556514ACD398C318C318C318C31B5563156
                      646DE1611F7C1F7C1F7C0166016601669352FF7F9C739C73D65A8C31C159E161
                      E1611F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C935293529352514A1F7C1F7C1F7C
                      1F7C1F7C1F7C}
                    OnClick = sbCheckAllKindProcessClick
                  end
                  object sbUncheckAllKindProcess: TSpeedButton
                    Left = 6
                    Top = 34
                    Width = 109
                    Height = 25
                    Caption = #1042#1089#1077' '#1079#1072#1087#1088#1077#1090#1080#1090#1100
                    Glyph.Data = {
                      42020000424D4202000000000000420000002800000010000000100000000100
                      10000300000000020000920B0000920B00000000000000000000007C0000E003
                      00001F0000001F7CE161A155A155A155A155A155A155A155A155A155A155A155
                      A155A1551F7C1F7C216E097F097F097F097F097F097F097F097F097F097F097F
                      097FA1551F7C1F7C216E097FB556734E734E734E734E734E734E734E734E734E
                      097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F734E
                      097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F734E
                      097FA1551F7C1F7C216E097FB556056C007CFF7FFF7FFF7FFF7F056CFF7F734E
                      097FA1551F7C1F7C216E097FB556FF7F056C007CFF7FFF7F056C007CFF7F734E
                      097FA1551F7C1F7C216E097FB556FF7FFF7F007C056C056C007CFF7FFF7F734E
                      097FA1551F7C1F7C216E097FB556FF7FFF7FAA7D007CAA7DFF7FFF7FFF7F734E
                      097FA1551F7C1F7C216E097FB556FF7F056C007CFF7F056C007CFF7FFF7F734E
                      097FA1551F7C1F7C216E097FB556056C007CFF7FFF7FFF7F056C007CFF7F734E
                      097FA1551F7C1F7C216E097FB556007CFF7FFF7FFF7FFF7FFF7F056CFF7F524E
                      097FA1551F7C1F7C216E097FB556FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F0912
                      E97AA1551F7C1F7C0166097FB556B556514ACD398C318C318C318C31B5563156
                      646DE1611F7C1F7C1F7C0166016601669352FF7F9C739C73D65A8C31C159E161
                      E1611F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C935293529352514A1F7C1F7C1F7C
                      1F7C1F7C1F7C}
                    OnClick = sbUncheckAllKindProcessClick
                  end
                end
              end
              object JvxSplitter8: TJvxSplitter
                Left = 216
                Top = 0
                Width = 3
                Height = 197
                ControlFirst = dgProcessAccess
                ControlSecond = paProcessAccess
                Align = alRight
                BevelOuter = bvNone
                Color = clBtnShadow
              end
            end
          end
          object Panel25: TPanel
            Left = 0
            Top = 187
            Width = 398
            Height = 47
            Align = alTop
            BevelOuter = bvNone
            Caption = ' '
            TabOrder = 3
            object Label18: TLabel
              Left = 6
              Top = 7
              Width = 65
              Height = 13
              Caption = #1042#1080#1076' '#1079#1072#1082#1072#1079#1072
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object cbOrderKind: TJvDBLookupCombo
              Left = 82
              Top = 3
              Width = 233
              Height = 22
              DeleteKeyClear = False
              EmptyValue = '0'
              EmptyItemColor = clScrollBar
              IgnoreCase = False
              ItemHeight = 17
              LookupField = 'KindID'
              LookupDisplay = 'KindDesc'
              LookupSource = sdm.dsOrderKind
              TabOrder = 0
              OnChange = cbOrderKindChange
            end
            object rbDraftAccess: TRadioButton
              Left = 6
              Top = 28
              Width = 113
              Height = 17
              Caption = #1063#1077#1088#1085#1086#1074#1080#1082#1080
              Checked = True
              TabOrder = 1
              TabStop = True
              OnClick = cbOrderKindChange
            end
            object rbWorkAccess: TRadioButton
              Left = 110
              Top = 28
              Width = 113
              Height = 17
              Caption = #1047#1072#1082#1072#1079#1099' '#1074' '#1088#1072#1073#1086#1090#1077
              TabOrder = 2
              OnClick = cbOrderKindChange
            end
          end
        end
      end
      object JvxSplitter6: TJvxSplitter
        Left = 293
        Top = 0
        Width = 3
        Height = 475
        ControlFirst = paUsers
        Align = alLeft
        BevelOuter = bvNone
        Color = clBtnShadow
      end
    end
    object tsParams: TTabSheet
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1079#1072#1082#1072#1079#1072
      ImageIndex = 3
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbNewPrm: TSpeedButton
        Left = 2
        Top = 294
        Width = 83
        Height = 25
        Caption = #1053#1086#1074#1099#1081'...'
        Enabled = False
      end
      object sbDelPrm: TSpeedButton
        Left = 94
        Top = 294
        Width = 83
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100'...'
        Enabled = False
      end
      object dgParams: TJvDBGrid
        Left = 2
        Top = 9
        Width = 383
        Height = 277
        DataSource = sdm.dsParams
        Options = [dgTitles, dgIndicator, dgColumnResize, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        IniStorage = JvFormStorage1
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
        Columns = <
          item
            Expanded = False
            FieldName = 'ParName'
            Title.Caption = #1048#1084#1103
            Width = 127
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ParDesc'
            Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
            Width = 216
            Visible = True
          end>
      end
      object GroupBox2: TGroupBox
        Left = 390
        Top = 4
        Width = 195
        Height = 207
        Enabled = False
        TabOrder = 1
        object Label4: TLabel
          Left = 8
          Top = 14
          Width = 19
          Height = 13
          Caption = #1048#1084#1103
          FocusControl = DBEdit1
        end
        object Label5: TLabel
          Left = 8
          Top = 62
          Width = 49
          Height = 13
          Caption = #1054#1087#1080#1089#1072#1085#1080#1077
          FocusControl = DBEdit2
        end
        object Label6: TLabel
          Left = 10
          Top = 110
          Width = 18
          Height = 13
          Caption = #1058#1080#1087
        end
        object DBEdit1: TDBEdit
          Left = 8
          Top = 34
          Width = 179
          Height = 21
          DataField = 'ParName'
          DataSource = sdm.dsParams
          Enabled = False
          ReadOnly = True
          TabOrder = 0
        end
        object DBEdit2: TDBEdit
          Left = 8
          Top = 80
          Width = 179
          Height = 21
          DataField = 'ParDesc'
          DataSource = sdm.dsParams
          Enabled = False
          ReadOnly = True
          TabOrder = 1
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 503
    Width = 702
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object paBut: TPanel
      Left = 517
      Top = 0
      Width = 185
      Height = 36
      Align = alRight
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 0
      object btOk: TButton
        Left = 12
        Top = 6
        Width = 81
        Height = 25
        Caption = #1054#1050
        ModalResult = 1
        TabOrder = 0
        OnClick = btOkClick
      end
      object btCancel: TButton
        Left = 102
        Top = 6
        Width = 75
        Height = 25
        Cancel = True
        Caption = #1054#1090#1084#1077#1085#1072
        ModalResult = 2
        TabOrder = 1
        OnClick = btCancelClick
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 309
      Height = 36
      Align = alLeft
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 1
    end
  end
  object JvFormStorage1: TJvFormStorage
    AppStoragePath = 'DicForm\'
    StoredProps.Strings = (
      'paGrpLeft.Width'
      'paKinds.Width'
      'paUserAccess.Height'
      'paUsers.Width'
      'dgProcessAccess.Width')
    StoredValues = <>
    Left = 406
    Top = 322
  end
  object pmCheckAllProc: TPopupMenu
    Left = 500
    Top = 81
    object miCheckAllProcCur: TMenuItem
      Caption = '... '#1076#1083#1103' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1087#1088#1086#1094#1077#1089#1089#1072
      OnClick = miCheckAllProcCurClick
    end
    object miCheckAllProcCurProcAllKinds: TMenuItem
      Caption = '...'#1076#1083#1103' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1087#1088#1086#1094#1077#1089#1089#1072' '#1074#1086' '#1074#1089#1077#1093' '#1074#1080#1076#1072#1093
      OnClick = miCheckAllProcCurProcAllKindClick
    end
    object miCheckAllProcAllProcCurKind: TMenuItem
      Caption = '... '#1076#1083#1103' '#1074#1089#1077#1093' '#1087#1088#1086#1094#1077#1089#1089#1086#1074' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1074#1080#1076#1072
      OnClick = miCheckAllProcAllProcCurKindClick
    end
    object N1: TMenuItem
      Caption = '... '#1076#1083#1103' '#1074#1089#1077#1093' '#1087#1088#1086#1094#1077#1089#1089#1086#1074' '#1074#1089#1077#1093' '#1074#1080#1076#1086#1074' '#1079#1072#1082#1072#1079#1072
      OnClick = miCheckAllProcAllProcAllKindClick
    end
  end
  object pmCheckAllKind: TPopupMenu
    Left = 500
    Top = 112
    object N5: TMenuItem
      Caption = '...'#1076#1083#1103' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1074#1080#1076#1072
    end
    object N4: TMenuItem
      Caption = '...'#1076#1083#1103' '#1074#1089#1077#1093' '#1074#1080#1076#1086#1074' '#1079#1072#1082#1072#1079#1072
    end
  end
  object dsUserRoles: TDataSource
    DataSet = cdUserRoles
    Left = 460
    Top = 78
  end
  object cdUserRoles: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 462
    Top = 112
  end
  object pmSrv: TPopupMenu
    Left = 478
    Top = 180
  end
  object pmUserPass: TPopupMenu
    Left = 100
    Top = 116
    object btnUserPass: TMenuItem
      Caption = #1047#1072#1076#1072#1090#1100' '#1087#1072#1088#1086#1083#1100
      OnClick = btnUserPassClick
    end
  end
end
