object CustomReportDetailsForm: TCustomReportDetailsForm
  Left = 123
  Top = 525
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1086#1090#1095#1077#1090#1072
  ClientHeight = 564
  ClientWidth = 807
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    807
    564)
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel
    Left = 14
    Top = 8
    Width = 48
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object lbPreview: TLabel
    Left = 4
    Top = 536
    Width = 81
    Height = 13
    Caption = #1058#1072#1073#1083#1080#1094#1072' '#1086#1090#1095#1077#1090#1072
    Visible = False
  end
  object lbCols: TLabel
    Left = 298
    Top = 58
    Width = 84
    Height = 13
    Caption = #1057#1090#1086#1083#1073#1094#1099' '#1086#1090#1095#1077#1090#1072
  end
  object edName: TDBEdit
    Left = 14
    Top = 26
    Width = 383
    Height = 21
    DataField = 'ReportName'
    DataSource = dsReport
    TabOrder = 0
  end
  object cbAddFilter: TDBCheckBox
    Left = 416
    Top = 10
    Width = 201
    Height = 17
    Caption = #1044#1086#1073#1072#1074#1083#1103#1090#1100' '#1086#1087#1080#1089#1072#1085#1080#1077' '#1074#1099#1073#1086#1088#1082#1080
    DataField = 'AddFilter'
    DataSource = dsReport
    TabOrder = 1
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object cbProcessDetails: TDBCheckBox
    Left = 416
    Top = 30
    Width = 197
    Height = 17
    Caption = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103' '#1087#1088#1086#1094#1077#1089#1089#1086#1074
    DataField = 'ProcessDetails'
    DataSource = dsReport
    TabOrder = 2
    ValueChecked = 'True'
    ValueUnchecked = 'False'
    OnClick = cbProcessDetailsClick
  end
  object dgPreview: TMyDBGridEh
    Left = 76
    Top = 516
    Width = 587
    Height = 37
    DataGrouping.GroupLevels = <>
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghHighlightFocus, dghClearSelection, dghDialogFind, dghColumnResize, dghColumnMove]
    RowDetailPanel.Color = clBtnFace
    RowHeight = 18
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Visible = False
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object pcSourceFields: TPageControl
    Left = 14
    Top = 60
    Width = 245
    Height = 466
    ActivePage = tsOrderFields
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 4
    object tsOrderFields: TTabSheet
      Caption = #1047#1072#1082#1072#1079
      object dgOrderFields: TMyDBGridEh
        Left = 0
        Top = 0
        Width = 237
        Height = 438
        Align = alClient
        AutoFitColWidths = True
        DataGrouping.GroupLevels = <>
        DataSource = dsOrderFields
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove]
        RowDetailPanel.Color = clBtnFace
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDblClick = btAddClick
        Columns = <
          item
            EditButtons = <>
            FieldName = 'Caption'
            Footers = <>
            Title.Caption = #1055#1086#1083#1077
            Width = 199
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object tsProcessFields: TTabSheet
      Caption = #1057#1086#1089#1090#1072#1074' '#1079#1072#1082#1072#1079#1072
      ImageIndex = 1
      object dgProcessFields: TMyDBGridEh
        Left = 0
        Top = 0
        Width = 237
        Height = 409
        Align = alClient
        DataGrouping.GroupLevels = <>
        DataSource = dsProcessFields
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove]
        RowDetailPanel.Color = clBtnFace
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDblClick = btAddClick
        OnGetCellParams = dgProcessFieldsGetCellParams
        Columns = <
          item
            EditButtons = <>
            FieldName = 'Caption'
            Footers = <>
            Title.Caption = #1055#1086#1083#1077
            Width = 182
          end
          item
            EditButtons = <>
            FieldName = 'FieldName'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 409
        Width = 237
        Height = 29
        Align = alBottom
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 1
        object cbShowAllFields: TCheckBox
          Left = 6
          Top = 8
          Width = 247
          Height = 17
          Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1074#1089#1077' '#1087#1086#1083#1103
          TabOrder = 0
          OnClick = cbShowAllFieldsClick
        end
      end
      object treeViewProcessFields: TDBVirtualStringTree
        Left = 8
        Top = 96
        Width = 201
        Height = 281
        Ctl3D = False
        DefaultNodeHeight = 16
        Header.AutoSizeIndex = 0
        Header.DefaultHeight = 17
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoDrag, hoVisible]
        Header.Style = hsXPStyle
        Images = ImageList1
        Margin = 2
        NodeDataSize = 4
        ParentCtl3D = False
        TabOrder = 2
        TextMargin = 1
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnDblClick = treeViewProcessFieldsDblClick
        OnGetImageIndex = treeViewProcessFieldsGetImageIndex
        OnInitNode = treeViewProcessFieldsInitNode
        DBOptions.Source = cdProcessFields
        DBOnChangeCurrentRecord = treeViewProcessFieldsDBOnChangeCurrentRecord
        Columns = <
          item
            Position = 0
            Width = 182
            WideText = #1055#1086#1083#1077
          end
          item
            Position = 1
            Width = 304
            WideText = 'FieldName'
          end>
      end
    end
  end
  object btAdd: TBitBtn
    Left = 264
    Top = 200
    Width = 29
    Height = 25
    Caption = '>'
    TabOrder = 5
    OnClick = btAddClick
  end
  object btAddAll: TBitBtn
    Left = 264
    Top = 230
    Width = 29
    Height = 25
    Caption = '>>'
    Enabled = False
    TabOrder = 6
  end
  object btRemoveAll: TBitBtn
    Left = 264
    Top = 290
    Width = 29
    Height = 25
    Caption = '<<'
    Enabled = False
    TabOrder = 7
  end
  object btRemove: TBitBtn
    Left = 264
    Top = 260
    Width = 29
    Height = 25
    Caption = '<'
    TabOrder = 8
    OnClick = btRemoveClick
  end
  object dgReportCols: TMyDBGridEh
    Left = 298
    Top = 76
    Width = 465
    Height = 223
    AllowedOperations = [alopUpdateEh]
    AutoFitColWidths = True
    DataGrouping.GroupLevels = <>
    DataSource = dsReportCols
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    OptionsEh = [dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
    RowDetailPanel.Color = clBtnFace
    TabOrder = 9
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Caption'
        Footers = <>
        Title.Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082
        Width = 176
      end
      item
        EditButtons = <>
        FieldName = 'SourceName'
        Footers = <>
        ReadOnly = True
        Title.Caption = #1048#1089#1090#1086#1095#1085#1080#1082
        Width = 174
      end
      item
        EditButtons = <>
        FieldName = 'FilterEnabled'
        Footers = <>
        Title.Caption = #1060#1080#1083#1100#1090#1088
        Width = 46
      end
      item
        EditButtons = <>
        FieldName = 'FieldName'
        Footers = <>
        Title.Caption = #1055#1086#1083#1077'-'#1080#1089#1090#1086#1095#1085#1080#1082
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object btMoveDown: TBitBtn
    Left = 770
    Top = 184
    Width = 28
    Height = 25
    TabOrder = 10
    OnClick = btMoveDownClick
    Glyph.Data = {
      7E020000424D7E020000000000007E0100002800000010000000100000000100
      08000000000000010000120B0000120B0000520000005200000000000000FFFF
      FF00FF00FF00E6AA8C00DE9A7600DD977300DB956F00DA926B00D0805200EFC8
      B600F5DDD2009D3806009D390600A03C0A00A2400E00A6451300A5451300AA4A
      1800AA4A1900B1552500D2896400D38B6600D58F6B00D9967400DA977500DE9B
      7800DA977600DB987700E19F7E00E1A07E00D7997A00E2A28100E3A58500E1A3
      8300E5A78900E8B39900E9B79E00EABCA400ECC2AC00EFC9B600F0CDBB00F0D0
      C000F1D1C100F2D5C600F3D7C900F3D9CC00F6E2D800A03D0900AD501E00AD50
      1F00B1552400B65B2A00B65B2B00BA613000B9603000B9613000BA613100B961
      3100BE663700BE673700C16C3C00C16B3D00C5714100C5714200C9754700C875
      4700CB7A4B00CB7A4C00CE7D4F00D3855900D4875D00D68A6000D78D6400D88F
      6800D9916A00DA926C00DC967000DF9D7A00DF9E7B00EABBA200F5DFD300F7E6
      DD00020202020202020B0C020202020202020202020202020D21212F02020202
      020202020202020E174B4A170E0202020202020202020F184C46454A18100202
      0202020202121A1D48474645191A110202020202301B1F074948474645191B31
      02020213162005060749484746454E143202341E252423050607494847030303
      1533383738354F04050607494803383635390202023A264D0405060749033B02
      02020202023D271C4D04050607033C0202020202023E291F1C4D040506033F02
      0202020202402C201F1C4D04050341020202020202425022201F1C4D04034302
      020202020244512E0A2D2B2A2809440202020202020808080808080808080802
      0202}
    Spacing = 0
  end
  object btMoveUp: TBitBtn
    Left = 770
    Top = 154
    Width = 28
    Height = 25
    TabOrder = 11
    OnClick = btMoveUpClick
    Glyph.Data = {
      5A020000424D5A020000000000005A0100002800000010000000100000000100
      08000000000000010000120B0000120B0000490000004900000000000000FFFF
      FF00FF00FF00E6AA8C00DC977100DB946E00DA926B00D99068009D3906009D38
      05009D3905009D3806009F3C09009F3C0A00A3410E00A2400E00A5451300A645
      1400AA4A1900AD4F1E00D48D6800D9957200DE9B7800DF9D7B00E1A07E00E2A2
      8100E2A38300E3A68700E4A98B00E5AB8D00E5AC8F00E2AA8D00E6AF9300E8B3
      9800E8B39900E9B49A00E8B49A00DEAD9400E6B69E00E4BAA400EAC2AE00EFD1
      C200F0D7CA00F5E1D700A94A1800AE501E00B2552400B1562400B55B2A00B65B
      2B00B55B2B00B9603000BA613100BD663700C16C3C00C26C3D00C5714200C976
      4700C8754700CC7A4B00CC794C00CE7D4F00D0805200D3845800D4875C00D589
      5F00D68B6200D78D6500DD997500EDCBB900EDCFBF00EED3C400F6E5DC000202
      0208080B08090B08080A080202020202020D03030303030303030C0202020202
      020F0307434241403F030E020202020202100306074342414003110202020202
      022C0305060743424103120202020202021303040506074342032D0202020202
      022E03440405060743032F020202323131310316440405060703303031313325
      23030317164404050603030314340235272119181716440405061A1535020202
      3746221918171644041B1F360202020202384724191817161D26380202020202
      02023A2A2019181E28390202020202020202023B291D1C453C02020202020202
      020202023D482B3D020202020202020202020202023E3E02020202020202}
    Spacing = 0
  end
  object btOk: TButton
    Left = 632
    Top = 533
    Width = 79
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    ModalResult = 1
    TabOrder = 12
  end
  object btCancel: TButton
    Left = 722
    Top = 533
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 13
  end
  object cbIncludeEmpty: TDBCheckBox
    Left = 604
    Top = 30
    Width = 197
    Height = 17
    Caption = #1042#1082#1083#1102#1095#1072#1090#1100' '#1079#1072#1087#1080#1089#1080' '#1073#1077#1079' '#1087#1088#1086#1094#1077#1089#1089#1086#1074
    DataField = 'IncludeEmptyDetails'
    DataSource = dsReport
    TabOrder = 14
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object cbRepeat: TDBCheckBox
    Left = 604
    Top = 10
    Width = 187
    Height = 17
    Caption = #1055#1086#1074#1090#1086#1088#1103#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1079#1072#1082#1072#1079#1072
    DataField = 'RepeatOrderFields'
    DataSource = dsReport
    TabOrder = 15
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object PageControl1: TPageControl
    Left = 298
    Top = 326
    Width = 499
    Height = 200
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 16
    object TabSheet1: TTabSheet
      Caption = #1057#1090#1086#1083#1073#1077#1094
      object Label5: TLabel
        Left = 7
        Top = 12
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
      object Label1: TLabel
        Left = 256
        Top = 12
        Width = 91
        Height = 13
        Caption = #1060#1086#1088#1084#1072#1090' (MS Excel)'
      end
      object Label15: TLabel
        Left = 8
        Top = 62
        Width = 38
        Height = 13
        Caption = #1060#1080#1083#1100#1090#1088
      end
      object Label16: TLabel
        Left = 258
        Top = 62
        Width = 84
        Height = 13
        Caption = #1042#1080#1076' '#1092#1080#1083#1100#1090#1088#1072#1094#1080#1080
      end
      object Label18: TLabel
        Left = 174
        Top = 142
        Width = 40
        Height = 13
        Caption = #1064#1080#1088#1080#1085#1072
      end
      object DBEdit1: TDBEdit
        Left = 8
        Top = 32
        Width = 231
        Height = 21
        DataField = 'Caption'
        DataSource = dsReportCols
        TabOrder = 0
      end
      object DBEdit2: TDBEdit
        Left = 256
        Top = 32
        Width = 225
        Height = 21
        DataField = 'DisplayFormat'
        DataSource = dsReportCols
        TabOrder = 1
      end
      object cbSumTotal: TDBCheckBox
        Left = 8
        Top = 115
        Width = 179
        Height = 17
        Caption = #1057#1091#1084#1084#1080#1088#1086#1074#1072#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1103
        DataField = 'SumTotal'
        DataSource = dsReportCols
        TabOrder = 2
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object cbSumByGroup: TDBCheckBox
        Left = 174
        Top = 115
        Width = 287
        Height = 17
        Caption = #1055#1086' '#1075#1088#1091#1087#1087#1077' ('#1074' '#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1080#1077' '#1089' '#1087#1086#1083#1103#1084#1080' '#1089#1086#1088#1090#1080#1088#1086#1074#1082#1080')'
        DataField = 'SumByGroup'
        DataSource = dsReportCols
        TabOrder = 3
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBEdit3: TDBEdit
        Left = 8
        Top = 80
        Width = 233
        Height = 21
        DataField = 'Filter'
        DataSource = dsReportCols
        TabOrder = 4
      end
      object cbFilterType: TJvDBComboBox
        Left = 256
        Top = 80
        Width = 225
        Height = 21
        DataField = 'FilterType'
        DataSource = dsReportCols
        ItemHeight = 13
        Items.Strings = (
          #1059#1089#1083#1086#1074#1080#1077' '#1074#1082#1083#1102#1095#1077#1085#1080#1103' '#1089#1090#1088#1086#1082#1080' '#1087#1088#1086#1094#1077#1089#1089#1072
          #1059#1089#1083#1086#1074#1080#1077' '#1074#1082#1083#1102#1095#1077#1085#1080#1103' '#1089#1090#1088#1086#1082#1080' '#1086#1090#1095#1077#1090#1072
          #1059#1089#1083#1086#1074#1080#1077' '#1085#1072' '#1086#1090#1086#1073#1088#1072#1078#1077#1085#1080#1077' '#1103#1095#1077#1081#1082#1080)
        TabOrder = 5
        Values.Strings = (
          '1'
          '2'
          '3')
        ListSettings.OutfilteredValueFont.Charset = DEFAULT_CHARSET
        ListSettings.OutfilteredValueFont.Color = clRed
        ListSettings.OutfilteredValueFont.Height = -11
        ListSettings.OutfilteredValueFont.Name = 'Tahoma'
        ListSettings.OutfilteredValueFont.Style = []
      end
      object DBCheckBox2: TDBCheckBox
        Left = 8
        Top = 140
        Width = 141
        Height = 17
        Caption = #1040#1074#1090#1086#1087#1086#1076#1073#1086#1088' '#1096#1080#1088#1080#1085#1099
        DataField = 'AutoFitColumn'
        DataSource = dsReportCols
        TabOrder = 6
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBEdit4: TDBEdit
        Left = 228
        Top = 138
        Width = 89
        Height = 21
        DataField = 'ColumnWidth'
        DataSource = dsReportCols
        TabOrder = 7
      end
    end
    object tsStyle: TTabSheet
      Caption = #1057#1090#1080#1083#1100
      ImageIndex = 2
      object Bevel2: TBevel
        Left = 244
        Top = 36
        Width = 11
        Height = 129
        Shape = bsLeftLine
      end
      object Panel2: TPanel
        Left = 6
        Top = 26
        Width = 233
        Height = 143
        BevelOuter = bvNone
        Caption = 'Panel2'
        TabOrder = 0
        object Label14: TLabel
          Left = 5
          Top = 8
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
        object Label9: TLabel
          Left = 6
          Top = 60
          Width = 74
          Height = 13
          Caption = #1042#1099#1088#1072#1074#1085#1080#1074#1072#1085#1080#1077
        end
        object Label10: TLabel
          Left = 17
          Top = 84
          Width = 64
          Height = 13
          Caption = #1062#1074#1077#1090' '#1090#1077#1082#1089#1090#1072
          Enabled = False
        end
        object Label11: TLabel
          Left = 25
          Top = 108
          Width = 55
          Height = 13
          Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072
          Enabled = False
        end
        object DBCheckBox5: TDBCheckBox
          Left = 6
          Top = 30
          Width = 101
          Height = 17
          Caption = #1055#1086#1083#1091#1078#1080#1088#1085#1099#1081
          DataField = 'CaptionFontBold'
          DataSource = dsReportCols
          TabOrder = 0
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object DBCheckBox6: TDBCheckBox
          Left = 124
          Top = 30
          Width = 97
          Height = 17
          Caption = #1050#1091#1088#1089#1080#1074
          DataField = 'CaptionFontItalic'
          DataSource = dsReportCols
          TabOrder = 1
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object dbcbAlignHeaderCell: TJvDBComboBox
          Left = 88
          Top = 56
          Width = 143
          Height = 21
          DataField = 'CaptionAlignment'
          DataSource = dsReportCols
          ItemHeight = 13
          TabOrder = 2
          ListSettings.OutfilteredValueFont.Charset = DEFAULT_CHARSET
          ListSettings.OutfilteredValueFont.Color = clRed
          ListSettings.OutfilteredValueFont.Height = -11
          ListSettings.OutfilteredValueFont.Name = 'Tahoma'
          ListSettings.OutfilteredValueFont.Style = []
        end
        object colorHeaderFont: TAnyColorCombo
          Left = 88
          Top = 82
          Width = 90
          Height = 20
          DisplayNames = False
          Enabled = False
          TabOrder = 3
        end
        object colorHeaderBk: TAnyColorCombo
          Left = 88
          Top = 108
          Width = 90
          Height = 20
          ColorValue = clWhite
          DisplayNames = False
          Enabled = False
          TabOrder = 4
        end
      end
      object Panel3: TPanel
        Left = 250
        Top = 28
        Width = 239
        Height = 143
        BevelOuter = bvNone
        Caption = 'Panel3'
        TabOrder = 1
        object Label6: TLabel
          Left = 9
          Top = 6
          Width = 34
          Height = 13
          Caption = #1058#1077#1082#1089#1090
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label7: TLabel
          Left = 7
          Top = 60
          Width = 74
          Height = 13
          Caption = #1042#1099#1088#1072#1074#1085#1080#1074#1072#1085#1080#1077
        end
        object Label8: TLabel
          Left = 17
          Top = 86
          Width = 64
          Height = 13
          Caption = #1062#1074#1077#1090' '#1090#1077#1082#1089#1090#1072
          Enabled = False
        end
        object Label4: TLabel
          Left = 26
          Top = 110
          Width = 55
          Height = 13
          Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072
          Enabled = False
        end
        object DBCheckBox3: TDBCheckBox
          Left = 8
          Top = 28
          Width = 101
          Height = 17
          Caption = #1055#1086#1083#1091#1078#1080#1088#1085#1099#1081
          DataField = 'FontBold'
          DataSource = dsReportCols
          TabOrder = 0
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object DBCheckBox4: TDBCheckBox
          Left = 128
          Top = 28
          Width = 97
          Height = 17
          Caption = #1050#1091#1088#1089#1080#1074
          DataField = 'FontItalic'
          DataSource = dsReportCols
          TabOrder = 1
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object dbcbAlignCell: TJvDBComboBox
          Left = 88
          Top = 56
          Width = 139
          Height = 21
          DataField = 'Alignment'
          DataSource = dsReportCols
          ItemHeight = 13
          TabOrder = 2
          ListSettings.OutfilteredValueFont.Charset = DEFAULT_CHARSET
          ListSettings.OutfilteredValueFont.Color = clRed
          ListSettings.OutfilteredValueFont.Height = -11
          ListSettings.OutfilteredValueFont.Name = 'Tahoma'
          ListSettings.OutfilteredValueFont.Style = []
        end
        object colorFont: TAnyColorCombo
          Left = 87
          Top = 82
          Width = 90
          Height = 20
          DisplayNames = False
          Enabled = False
          TabOrder = 3
        end
        object colorBk: TAnyColorCombo
          Left = 87
          Top = 108
          Width = 90
          Height = 20
          ColorValue = clWhite
          DisplayNames = False
          Enabled = False
          TabOrder = 4
        end
      end
      object DBCheckBox7: TDBCheckBox
        Left = 12
        Top = 7
        Width = 179
        Height = 17
        Caption = #1055#1091#1089#1090#1072#1103' '#1089#1090#1088#1086#1082#1072' '#1087#1086#1089#1083#1077' '#1075#1088#1091#1087#1087#1099
        DataField = 'AddRowAfterGroup'
        DataSource = dsReport
        TabOrder = 2
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
    end
    object tsSort: TTabSheet
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
      ImageIndex = 1
      object Label2: TLabel
        Left = 12
        Top = 10
        Width = 82
        Height = 13
        Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1087#1086
      end
      object Label3: TLabel
        Left = 46
        Top = 42
        Width = 45
        Height = 13
        Caption = #1047#1072#1090#1077#1084' '#1087#1086
      end
      object Label12: TLabel
        Left = 46
        Top = 106
        Width = 45
        Height = 13
        Caption = #1047#1072#1090#1077#1084' '#1087#1086
      end
      object Label13: TLabel
        Left = 46
        Top = 74
        Width = 45
        Height = 13
        Caption = #1047#1072#1090#1077#1084' '#1087#1086
      end
      object DBCheckBox1: TDBCheckBox
        Left = 12
        Top = 146
        Width = 137
        Height = 17
        Caption = #1055#1086' '#1074#1086#1079#1088#1072#1089#1090#1072#1085#1080#1102
        DataField = 'SortAscending'
        DataSource = dsReport
        TabOrder = 0
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBLookupComboBox1: TDBLookupComboBox
        Left = 100
        Top = 6
        Width = 227
        Height = 21
        DataField = 'Sort1'
        DataSource = dsReport
        DropDownRows = 10
        KeyField = 'OrderNum'
        ListField = 'SourceName'
        ListSource = dsReportCols
        TabOrder = 1
      end
      object DBLookupComboBox2: TDBLookupComboBox
        Left = 100
        Top = 38
        Width = 227
        Height = 21
        DataField = 'Sort2'
        DataSource = dsReport
        DropDownRows = 10
        KeyField = 'OrderNum'
        ListField = 'SourceName'
        ListSource = dsReportCols
        TabOrder = 2
      end
      object DBLookupComboBox3: TDBLookupComboBox
        Left = 100
        Top = 102
        Width = 227
        Height = 21
        DataField = 'Sort4'
        DataSource = dsReport
        DropDownRows = 10
        KeyField = 'OrderNum'
        ListField = 'SourceName'
        ListSource = dsReportCols
        TabOrder = 4
      end
      object DBLookupComboBox4: TDBLookupComboBox
        Left = 100
        Top = 70
        Width = 227
        Height = 21
        DataField = 'Sort3'
        DataSource = dsReport
        DropDownRows = 10
        KeyField = 'OrderNum'
        ListField = 'SourceName'
        ListSource = dsReportCols
        TabOrder = 3
      end
    end
  end
  object dsReportCols: TDataSource
    Left = 438
    Top = 162
  end
  object dsReport: TDataSource
    Left = 194
    Top = 8
  end
  object cdOrderFields: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'cdOrderFieldsIndex1'
        Fields = 'OrderNum'
      end>
    Params = <>
    StoreDefs = True
    Left = 172
    Top = 234
    object cdOrderFieldsOrderNum: TIntegerField
      FieldName = 'OrderNum'
    end
    object cdOrderFieldsFieldName: TStringField
      FieldName = 'FieldName'
      Size = 50
    end
    object cdOrderFieldsCaption: TStringField
      FieldName = 'Caption'
      Size = 100
    end
    object cdOrderFieldsAdded: TBooleanField
      FieldName = 'IsAdded'
    end
    object cdOrderFieldsDisplayFormat: TStringField
      FieldName = 'DisplayFormat'
      Size = 40
    end
  end
  object cdProcessFields: TVTClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'cdProcessFieldsIndex1'
        Fields = 'OrderNum'
      end>
    Params = <>
    StoreDefs = True
    OnCalcFields = cdProcessFieldsCalcFields
    Left = 174
    Top = 266
    object cdProcessFieldsOrderNum: TIntegerField
      FieldName = 'OrderNum'
    end
    object cdProcessFieldsFieldName: TStringField
      FieldName = 'FieldName'
      Size = 50
    end
    object cdProcessFieldsCaption: TStringField
      FieldName = 'Caption'
      Size = 100
    end
    object cdProcessFieldsProcessID: TIntegerField
      FieldName = 'ProcessID'
    end
    object cdProcessFieldsIsProcessName: TBooleanField
      FieldName = 'IsProcessName'
    end
    object cdProcessFieldsAdded: TBooleanField
      FieldName = 'IsAdded'
    end
    object cdProcessFieldsIsGridField: TBooleanField
      FieldName = 'IsGridField'
    end
    object cdProcessFieldsDisplayFormat: TStringField
      FieldName = 'DisplayFormat'
      Size = 40
    end
    object cdProcessFieldsC: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'C'
      Calculated = True
    end
    object cdProcessFieldsParentID: TIntegerField
      FieldName = 'ParentID'
    end
  end
  object dsOrderFields: TDataSource
    DataSet = cdOrderFields
    Left = 206
    Top = 234
  end
  object dsProcessFields: TDataSource
    DataSet = cdProcessFields
    Left = 208
    Top = 266
  end
  object ImageList1: TImageList
    Left = 264
    Top = 96
    Bitmap = {
      494C010101000300040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009A9A9A00818487008184
      8700818487008184870081848700818487008184870081848700818487008184
      8700818487008184870081848700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009A9A9A00FEFEFC00FEFE
      FC00FEFEFC00FAFAF800F6F6F400F2F2F000EDEDEB00E9E9E700E5E5E300E1E1
      E000D4D4D400C5C5C50081848700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009A9A9A00FEFEFC00F37D
      2000F37D2000F37D2000F37D2000F37D2000F37D2000F37D2000F37D2000F37D
      2000F37D2000D4D4D40081848700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009A9A9A00FEFEFC00F37D
      2000FFFFFF00FFFFFF00F37D2000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00F37D2000E1E1E00081848700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009A9A9A00FEFEFC00F37D
      2000F37D2000F37D2000F37D2000F37D2000F37D2000F37D2000F37D2000F37D
      2000F37D2000E5E5E30081848700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009A9A9A00FEFEFC00F37D
      2000FFFFFF00FFFFFF00F37D2000FFFFFF00699CB000FFFFFF001C668C001860
      8900F37D20005B8EAF0081848700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009A9A9A00FEFEFC00F37D
      2000F37D2000F37D2000F37D2000377592000D5F95000D5C8C001976AB001A7A
      AF000C5D93000D6095002C658E00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009A9A9A00FEFEFC00F37D
      2000FFFFFF00FFFFFF004687A100126595003A9FCA002B86AD0042A7CF0048B1
      D8003CA7D30048B6DE0007548F002E6A93000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009A9A9A00FEFEFC00F37D
      2000F37D2000F37D200023688A003DA0CB004AB5DC00409FC400347B98003173
      90002F89B20045B1D9002993C700155D91000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009A9A9A00FEFEFC00F37D
      2000FFFFFF00FFFFFF00185F840057B8DD0054B8DC004F687400737373006B52
      52004A5A6A003CA3CC0041A6CF000C4979000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009A9A9A00FEFEFC00C758
      0300C7580300C758030053899F004199BD0068C9E7007A7A7A007D7D7D007055
      55007D5757003195C0002D7EA600467FA5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009A9A9A00FEFEFC00C758
      0300C7580300C7580300C75803005B8CA1002A7696007A7A7A007D7D7D007055
      55007D5757000C5A8C004C82A700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009A9A9A00FEFEFC00FEFE
      FC00FEFEFC00FEFEFC00FEFEFC00FEFEFC00FEFEFC00706F6F006B6A6A005F4D
      4D0070525200FEFEFC0081848700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009A9A9A00818487008184
      87008184870081848700818487008184870081848700706F6F008B8B8B00554D
      4D004D4343008184870081848700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000696868005150
      5000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF0000000000008001000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      8001000000000000800100000000000080000000000000008000000000000000
      8000000000000000800000000000000080010000000000008001000000000000
      8001000000000000FFCF00000000000000000000000000000000000000000000
      000000000000}
  end
end
