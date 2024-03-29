object ReportsForm: TReportsForm
  Left = 236
  Top = 234
  Caption = #1060#1086#1088#1084#1099' '#1080' '#1089#1094#1077#1085#1072#1088#1080#1080
  ClientHeight = 416
  ClientWidth = 674
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    674
    416)
  PixelsPerInch = 96
  TextHeight = 13
  object btOk: TButton
    Left = 546
    Top = 354
    Width = 122
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    ModalResult = 1
    TabOrder = 0
    OnClick = btOkClick
  end
  object btCancel: TButton
    Left = 546
    Top = 385
    Width = 122
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object btEdit: TButton
    Left = 546
    Top = 28
    Width = 122
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1057#1094#1077#1085#1072#1088#1080#1081'...'
    Default = True
    TabOrder = 2
    OnClick = btEditClick
  end
  object btDelete: TButton
    Left = 546
    Top = 92
    Width = 122
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1059#1076#1072#1083#1080#1090#1100'...'
    TabOrder = 3
    OnClick = btDeleteClick
  end
  object btAdd: TButton
    Left = 546
    Top = 60
    Width = 122
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 4
    OnClick = btAddClick
  end
  object pgGlobal: TPageControl
    Left = 8
    Top = 8
    Width = 529
    Height = 402
    ActivePage = tsReports
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 5
    OnChange = pgGlobalChange
    object tsGlobal: TTabSheet
      Caption = #1057#1086#1073#1099#1090#1080#1103
      ImageIndex = 1
      ExplicitHeight = 345
      object dgOrdScripts: TMyDBGridEh
        Left = 0
        Top = 0
        Width = 521
        Height = 374
        Align = alClient
        DataGrouping.GroupLevels = <>
        DataSource = rdm.dsOrdScripts
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghEnterAsTab, dghRowHighlight, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
        RowDetailPanel.Color = clBtnFace
        RowHeight = 17
        SortLocal = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        IniStorage = ReportStorage
        Columns = <
          item
            EditButtons = <>
            FieldName = 'ScriptName'
            Footers = <>
            Title.Caption = #1048#1084#1103
            Width = 98
          end
          item
            EditButtons = <>
            FieldName = 'ScriptDesc'
            Footers = <>
            Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
            Width = 272
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = 'ModifyDate'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
            Width = 94
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object tsReports: TTabSheet
      Caption = #1054#1090#1095#1077#1090#1099
      ExplicitHeight = 345
      object Panel1: TPanel
        Left = 0
        Top = 277
        Width = 521
        Height = 97
        Align = alBottom
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 0
        ExplicitTop = 248
        object Label2: TLabel
          Left = 4
          Top = 11
          Width = 45
          Height = 13
          Caption = #1050#1083#1072#1074#1080#1096#1072
        end
        object Label1: TLabel
          Left = 5
          Top = 47
          Width = 36
          Height = 13
          Caption = #1043#1088#1091#1087#1087#1072
        end
        object cbShortCut: TJvDBComboBox
          Left = 56
          Top = 8
          Width = 161
          Height = 21
          DataField = 'ShortCut'
          DataSource = rdm.dsReports
          ItemHeight = 13
          TabOrder = 0
          ListSettings.OutfilteredValueFont.Charset = DEFAULT_CHARSET
          ListSettings.OutfilteredValueFont.Color = clRed
          ListSettings.OutfilteredValueFont.Height = -11
          ListSettings.OutfilteredValueFont.Name = 'Tahoma'
          ListSettings.OutfilteredValueFont.Style = []
        end
        object DBCheckBox1: TDBCheckBox
          Left = 240
          Top = 8
          Width = 189
          Height = 17
          Caption = #1056#1072#1073#1086#1090#1072#1077#1090' '#1087#1088#1080' '#1086#1090#1082#1088#1099#1090#1086#1084' '#1079#1072#1082#1072#1079#1077
          DataField = 'WorkInsideOrder'
          DataSource = rdm.dsReports
          TabOrder = 1
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object DBCheckBox3: TDBCheckBox
          Left = 240
          Top = 28
          Width = 269
          Height = 17
          Caption = #1057#1083#1091#1078#1077#1073#1085#1099#1081' '#1084#1086#1076#1091#1083#1100' ('#1085#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1074' '#1089#1087#1080#1089#1082#1077')'
          DataField = 'IsUnit'
          DataSource = rdm.dsReports
          TabOrder = 2
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object dbcDefault: TDBCheckBox
          Left = 240
          Top = 48
          Width = 201
          Height = 17
          Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
          DataField = 'IsDefault'
          DataSource = rdm.dsReports
          TabOrder = 3
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object DBCheckBox2: TDBCheckBox
          Left = 240
          Top = 68
          Width = 173
          Height = 17
          Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1082#1085#1086#1087#1082#1091' '#1086#1090#1084#1077#1085#1099
          DataField = 'ShowCancel'
          DataSource = rdm.dsReports
          TabOrder = 4
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object cbReportGroup: TDBLookupComboboxEh
          Left = 56
          Top = 44
          Width = 161
          Height = 21
          DataField = 'ReportGroupId'
          DataSource = rdm.dsReports
          DropDownBox.ListSource = dsReportGroups
          DropDownBox.Options = []
          EditButtons = <>
          KeyField = 'Code'
          ListField = 'Name'
          ListSource = dsReportGroups
          TabOrder = 5
          Visible = True
        end
      end
      object dgReports: TMyDBGridEh
        Left = 0
        Top = 0
        Width = 521
        Height = 277
        Align = alClient
        DataGrouping.GroupLevels = <>
        DataSource = rdm.dsReports
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        OptionsEh = [dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghEnterAsTab, dghRowHighlight, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
        RowDetailPanel.Color = clBtnFace
        RowHeight = 17
        SortLocal = True
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        VTitleMargin = 12
        IniStorage = ReportStorage
        Columns = <
          item
            EditButtons = <>
            FieldName = 'IsDefault'
            Footers = <>
            Title.Caption = #1059#1084'.'
            Title.TitleButton = True
            Width = 26
          end
          item
            EditButtons = <>
            FieldName = 'IsUnit'
            Footers = <>
            Title.Caption = #1052#1086#1076'.'
            Title.TitleButton = True
            Width = 25
          end
          item
            EditButtons = <>
            FieldName = 'ScriptName'
            Footers = <>
            Title.Caption = #1048#1084#1103' '#1084#1086#1076#1091#1083#1103
            Title.TitleButton = True
            Width = 96
          end
          item
            EditButtons = <>
            FieldName = 'ScriptDesc'
            Footers = <>
            Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
            Title.TitleButton = True
            Width = 217
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = 'ModifyDate'
            Footers = <>
            Title.Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
            Title.TitleButton = True
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object tsForms: TTabSheet
      Caption = #1060#1086#1088#1084#1099
      ImageIndex = 2
      ExplicitHeight = 345
      object dgForms: TMyDBGridEh
        Left = 0
        Top = 0
        Width = 521
        Height = 341
        Align = alClient
        DataGrouping.GroupLevels = <>
        DataSource = rdm.dsForms
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        OptionsEh = [dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghEnterAsTab, dghRowHighlight, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
        RowDetailPanel.Color = clBtnFace
        RowHeight = 17
        SortLocal = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        IniStorage = ReportStorage
        Columns = <
          item
            EditButtons = <>
            FieldName = 'FormName'
            Footers = <>
            Title.Caption = #1042#1085#1091#1090#1088'. '#1080#1084#1103
            Width = 94
          end
          item
            EditButtons = <>
            FieldName = 'FormDesc'
            Footers = <>
            Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
            Width = 282
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = 'ModifyDate'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
            Width = 94
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 341
        Width = 521
        Height = 33
        Align = alBottom
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 1
        ExplicitTop = 312
        object btEditDfm: TButton
          Left = 224
          Top = 5
          Width = 87
          Height = 25
          Caption = #1060#1086#1088#1084#1072'...'
          TabOrder = 0
          OnClick = btEditDfmClick
        end
      end
    end
  end
  object btSave: TButton
    Left = 546
    Top = 136
    Width = 122
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083'...'
    TabOrder = 6
    OnClick = btSaveClick
  end
  object btLoad: TButton
    Left = 546
    Top = 168
    Width = 122
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1092#1072#1081#1083#1072'...'
    TabOrder = 7
    OnClick = btLoadClick
  end
  object btUpdate: TButton
    Left = 546
    Top = 200
    Width = 122
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1086#1073#1085#1086#1074#1080#1090#1100'...'
    TabOrder = 8
    OnClick = btUpdateClick
  end
  object OpenDlg: TOpenDialog
    DefaultExt = '.pas'
    Filter = #1060#1072#1081#1083#1099' '#1089#1094#1077#1085#1072#1088#1080#1077#1074' (*.pas)|*.pas'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofCreatePrompt, ofEnableSizing]
    Left = 552
    Top = 248
  end
  object SaveDlg: TSaveDialog
    DefaultExt = '.pas'
    Filter = #1060#1072#1081#1083#1099' '#1089#1094#1077#1085#1072#1088#1080#1077#1074' (*.pas)|*.pas'
    Left = 584
    Top = 248
  end
  object ReportStorage: TJvFormStorage
    AppStoragePath = 'ReportForm\'
    StoredValues = <>
    Left = 616
    Top = 248
  end
  object dsReportGroups: TDataSource
    Left = 80
    Top = 348
  end
end
