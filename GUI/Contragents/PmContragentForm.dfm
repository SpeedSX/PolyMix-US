object ContragentForm: TContragentForm
  Left = 215
  Top = 494
  BorderIcons = [biSystemMenu]
  Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1079#1072#1082#1072#1079#1095#1080#1082#1072
  ClientHeight = 453
  ClientWidth = 653
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    653
    453)
  PixelsPerInch = 96
  TextHeight = 13
  object btOk: TBitBtn
    Left = 464
    Top = 422
    Width = 87
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 0
    NumGlyphs = 2
  end
  object btCancel: TBitBtn
    Left = 560
    Top = 422
    Width = 85
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
    NumGlyphs = 2
  end
  object pcProps: TPageControl
    Left = 7
    Top = 8
    Width = 638
    Height = 408
    ActivePage = tsCommon
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object tsCommon: TTabSheet
      Caption = #1054#1073#1097#1080#1077
      DesignSize = (
        630
        380)
      object lbName: TLabel
        Left = 8
        Top = 16
        Width = 122
        Height = 13
        Caption = #1050#1088#1072#1090#1082#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
        FocusControl = edName
      end
      object Label2: TLabel
        Left = 8
        Top = 151
        Width = 87
        Height = 13
        Caption = #1054#1092#1080#1089' '#1090#1077#1083#1077#1092#1086#1085' 1:'
        FocusControl = edPhone
      end
      object lbAddr: TLabel
        Left = 8
        Top = 248
        Width = 60
        Height = 13
        Alignment = taRightJustify
        Caption = #1060#1080#1079'. '#1072#1076#1088#1077#1089':'
        FocusControl = edAddress
        Transparent = True
      end
      object lbUser: TLabel
        Left = 8
        Top = 324
        Width = 57
        Height = 13
        Alignment = taRightJustify
        Caption = #1052#1077#1085#1077#1076#1078#1077#1088':'
      end
      object Label5: TLabel
        Left = 339
        Top = 195
        Width = 32
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'E-mail:'
        ExplicitLeft = 268
      end
      object lbFirmType: TLabel
        Left = 478
        Top = 52
        Width = 114
        Height = 13
        Caption = #1060#1086#1088#1084#1072' '#1089#1086#1073#1089#1090#1074#1077#1085#1085#1086#1089#1090#1080':'
        Visible = False
      end
      object lbContrType: TLabel
        Left = 444
        Top = 16
        Width = 23
        Height = 13
        Anchors = [akTop, akRight]
        Caption = #1042#1080#1076':'
        ExplicitLeft = 373
      end
      object lbFullName: TLabel
        Left = 8
        Top = 60
        Width = 116
        Height = 13
        Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
        FocusControl = edFullName
      end
      object Label7: TLabel
        Left = 8
        Top = 195
        Width = 87
        Height = 13
        Caption = #1054#1092#1080#1089' '#1090#1077#1083#1077#1092#1086#1085' 2:'
        FocusControl = edPhone2
      end
      object Label13: TLabel
        Left = 8
        Top = 107
        Width = 58
        Height = 13
        Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103':'
      end
      object Label14: TLabel
        Left = 339
        Top = 107
        Width = 98
        Height = 13
        Anchors = [akTop, akRight]
        Caption = #1042#1080#1076' '#1076#1077#1103#1090#1077#1083#1100#1085#1086#1089#1090#1080':'
        ExplicitLeft = 268
      end
      object edName: TDBEdit
        Left = 8
        Top = 32
        Width = 422
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'Name'
        TabOrder = 0
      end
      object edPhone: TDBEdit
        Left = 8
        Top = 168
        Width = 310
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'Phone'
        TabOrder = 7
      end
      object edAddress: TDBEdit
        Left = 84
        Top = 245
        Width = 532
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'Address'
        TabOrder = 12
      end
      object paInfoSource: TPanel
        Left = 2
        Top = 272
        Width = 618
        Height = 51
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 13
        DesignSize = (
          618
          51)
        object lbOther: TLabel
          Left = 336
          Top = 3
          Width = 41
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = #1044#1088#1091#1075#1086#1081':'
          ExplicitLeft = 264
        end
        object lbSource: TLabel
          Left = 7
          Top = 5
          Width = 117
          Height = 13
          Alignment = taRightJustify
          Caption = #1048#1089#1090#1086#1095#1085#1080#1082' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080':'
        end
        object edOther: TDBEdit
          Left = 336
          Top = 22
          Width = 277
          Height = 21
          Anchors = [akTop, akRight]
          DataField = 'SourceOther'
          TabOrder = 0
        end
        object lkSource: TDBLookupComboBox
          Left = 7
          Top = 22
          Width = 310
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'SourceCode'
          KeyField = 'Code'
          ListField = 'Name'
          TabOrder = 1
        end
      end
      object lkUser: TDBLookupComboBox
        Left = 8
        Top = 341
        Width = 201
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'UserCode'
        KeyField = 'AccessUserID'
        ListField = 'Name'
        ReadOnly = True
        TabOrder = 14
      end
      object cbMultiActivity: TJvCheckedComboBox
        Left = 339
        Top = 124
        Width = 278
        Height = 21
        CapSelectAll = '&Select all'
        CapDeSelectAll = '&Deselect all'
        CapInvertAll = '&Invert all'
        Anchors = [akTop, akRight]
        TabOrder = 6
        OnChange = cbMultiActivityChange
      end
      object edEmail: TDBEdit
        Left = 339
        Top = 212
        Width = 167
        Height = 21
        Anchors = [akTop, akRight]
        DataField = 'Email'
        TabOrder = 10
      end
      object btSendMail: TBitBtn
        Left = 513
        Top = 209
        Width = 103
        Height = 24
        Anchors = [akTop, akRight]
        Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077'...'
        TabOrder = 11
        OnClick = btSendMailClick
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000230B0000230B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFAAABACAAABACAAABACAAABACAAABACAAABACAA
          ABACAAABACAAABACAAABACFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFAAABAC
          FCFCFBF8F8F7F4F4F3F0F0EFECECEBE8E8E7D9D9D9D2D2D2AAABACFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFAAABACFEFEFDFCFCFBFAFAF9F6F6F5F2F2F1EE
          EEEDEAEAE9E0E0E0AAABACFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFAAABAC
          FEFEFDFEFEFDFEFEFDFAFAF9F6F6F5F2F2F1EEEEEDEAEAE9AAABACFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFAAABACFEFEFDFEFEFDFEFEFDFEFEFDFAFAF9F6
          F6F5F2F2F1EEEEEDAAABACFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFAAABAC
          FEFEFDFEFEFDFEFEFDFEFEFDFEFEFDFAFAF9F6F6F5F2F2F1AAABACFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFAAABACFEFEFDFEFEFDFEFEFDFEFEFDFEFEFDFE
          FEFDFAFAF9F6F6F5AAABAC29ADD629ADD629ADD629ADD6FF00FFFF00FFAAABAC
          FEFEFDFEFEFDFEFEFDFEFEFDFEFEFDFEFEFDFEFEFDFAFAF9AAABAC86D1EA7FCF
          E96EC7E629ADD6FF00FFFF00FFAAABACFEFEFDFEFEFDFEFEFDFEFEFDFEFEFDFE
          FEFDFEFEFDFEFEFDAAABAC8FD4EC90D5EC7FCFE929ADD6FF00FFFF00FFAAABAC
          FEFEFDFEFEFDFEFEFDFEFEFDFEFEFDC9C9C9C0C1C1B7B8B9AAABACA1DCEFA4DD
          EF98D8EE29ADD6FF00FFFF00FFAAABACFEFEFDFEFEFDFEFEFDFEFEFDFEFEFDC9
          C9C9F9F9F9AAABACB0E2F2B0E2F2B0E2F2B0E2F229ADD6FF00FFFF00FFAAABAC
          FEFEFDFEFEFDFEFEFDFEFEFDFEFEFDB9BABAAAABACDEF4FAD1EFF8FFB539FFA4
          05B0E2F229ADD6FF00FFFF00FFAAABACAAABACAAABACAAABACAAABACAAABACAA
          ABACDEF4FADEF4FADAF3FAFFB539FFB539DEF4FA29ADD6FF00FFFF00FFFF00FF
          78C8E6E6F8FCE6F8FCE6F8FCE6F8FCE6F8FCE6F8FCE6F8FCE6F8FCE6F8FCE6F8
          FCDEF4FA29ADD6FF00FFFF00FFFF00FF78C8E654B7E054B7E054B7E054B7E054
          B7E054B7E054B7E054B7E054B7E054B7E054B7E045ADDDFF00FF}
      end
      object edFirmType: TDBEdit
        Left = 478
        Top = 71
        Width = 121
        Height = 21
        DataField = 'FirmType'
        TabOrder = 2
        Visible = False
      end
      object edFullName: TDBEdit
        Left = 8
        Top = 77
        Width = 579
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'FullName'
        TabOrder = 3
      end
      object edPhone2: TDBEdit
        Left = 8
        Top = 212
        Width = 310
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'Phone2'
        TabOrder = 8
      end
      object cbActivity: TDBLookupComboboxEh
        Left = 338
        Top = 341
        Width = 276
        Height = 21
        Anchors = [akTop, akRight]
        DataField = 'ActivityCode'
        DropDownBox.AutoDrop = True
        DropDownBox.Rows = 25
        EditButtons = <>
        KeyField = 'Code'
        ListField = 'Name'
        ListSource = dsActivity
        TabOrder = 5
        Visible = False
        OnClick = cbActivityClick
      end
      object cbStatus: TDBLookupComboboxEh
        Left = 8
        Top = 124
        Width = 310
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'StatusCode'
        DropDownBox.AutoDrop = True
        DropDownBox.Rows = 25
        EditButtons = <>
        KeyField = 'Code'
        ListField = 'Name'
        ListSource = dsStatus
        TabOrder = 4
        Visible = True
        OnClick = cbStatusClick
        OnCloseUp = cbStatusCloseUp
      end
      object cbPersonType: TDBComboBoxEh
        Left = 443
        Top = 32
        Width = 173
        Height = 21
        Anchors = [akTop, akRight]
        DataField = 'PersonType'
        EditButtons = <>
        TabOrder = 1
        Visible = True
        OnChange = cbPersonTypeChange
        OnClick = cbPersonTypeClick
      end
      object cbIsDead: TDBCheckBox
        Left = 338
        Top = 162
        Width = 133
        Height = 27
        TabStop = False
        Anchors = [akTop, akRight]
        Caption = #1053#1077#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1080#1081
        DataField = 'IsDead'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object cbAlert: TDBCheckBox
        Left = 596
        Top = 74
        Width = 24
        Height = 27
        TabStop = False
        Anchors = [akTop, akRight]
        Caption = '!'
        DataField = 'Alert'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 15
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
    end
    object tsPerson: TTabSheet
      BorderWidth = 2
      Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1099#1077' '#1083#1080#1094#1072
      ImageIndex = 3
      object dgPersons: TMyDBGridEh
        Left = 0
        Top = 0
        Width = 626
        Height = 341
        Align = alClient
        AllowedOperations = []
        DataGrouping.GroupLevels = <>
        DataSource = dsPersons
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        RowDetailPanel.Color = clBtnFace
        RowHeight = 18
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDblClick = btEditPersonClick
        Columns = <
          item
            EditButtons = <>
            FieldName = 'Name'
            Footers = <>
            Title.Caption = #1048#1084#1103
            Width = 163
          end
          item
            EditButtons = <>
            FieldName = 'PersonTypeName'
            Footers = <>
            Title.Caption = #1042#1080#1076' '#1082#1086#1085#1090#1072#1082#1090#1072
            Width = 113
          end
          item
            EditButtons = <>
            FieldName = 'Phone'
            Footers = <>
            Title.Caption = #1058#1077#1083#1077#1092#1086#1085
            Width = 102
          end
          item
            EditButtons = <>
            FieldName = 'PhoneCell'
            Footers = <>
            Title.Caption = #1052#1086#1073'. '#1090#1077#1083#1077#1092#1086#1085
            Width = 100
          end
          item
            EditButtons = <>
            FieldName = 'Email'
            Footers = <>
            Title.Caption = 'E-mail'
            Width = 95
          end
          item
            AlwaysShowEditButton = True
            EditButtons = <>
            FieldName = 'Birthday'
            Footers = <>
            Title.Caption = #1044#1077#1085#1100' '#1088#1086#1078#1076#1077#1085#1080#1103
            Width = 96
            OnUpdateData = dgPersonsColumnsBirthdayUpdateData
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 341
        Width = 626
        Height = 35
        Align = alBottom
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 1
        object btAdd: TBitBtn
          Left = 4
          Top = 6
          Width = 86
          Height = 25
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 0
          OnClick = btAddClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000120B0000120B00001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777777777777777777777777777777777777777000777777777777700077
            7777777777700077777777770000000007777777000000000777777700000000
            0777777777700077777777777770007777777777777000777777777777777777
            7777777777777777777777777777777777777777777777777777}
        end
        object btDelete: TBitBtn
          Left = 192
          Top = 6
          Width = 86
          Height = 25
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 2
          OnClick = btDeleteClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000120B0000120B00001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777777777777777777777777777777777777777777777777777777777777
            7777777777777777777777700000000007777770000000000777777000000000
            0777777777777777777777777777777777777777777777777777777777777777
            7777777777777777777777777777777777777777777777777777}
        end
        object btEdit: TBitBtn
          Left = 100
          Top = 6
          Width = 81
          Height = 25
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
          TabOrder = 1
          OnClick = btEditPersonClick
        end
      end
    end
    object tsRelated: TTabSheet
      BorderWidth = 2
      Caption = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1077
      ImageIndex = 5
      object Panel2: TPanel
        Left = 0
        Top = 341
        Width = 626
        Height = 35
        Align = alBottom
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 0
        object btAddRelated: TBitBtn
          Left = 4
          Top = 6
          Width = 86
          Height = 25
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 0
          OnClick = btAddRelatedClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000120B0000120B00001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777777777777777777777777777777777777777000777777777777700077
            7777777777700077777777770000000007777777000000000777777700000000
            0777777777700077777777777770007777777777777000777777777777777777
            7777777777777777777777777777777777777777777777777777}
        end
        object btDeleteRelated: TBitBtn
          Left = 192
          Top = 6
          Width = 86
          Height = 25
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 2
          OnClick = btDeleteRelatedClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000120B0000120B00001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777777777777777777777777777777777777777777777777777777777777
            7777777777777777777777700000000007777770000000000777777000000000
            0777777777777777777777777777777777777777777777777777777777777777
            7777777777777777777777777777777777777777777777777777}
        end
        object btEditRelated: TBitBtn
          Left = 100
          Top = 6
          Width = 81
          Height = 25
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
          TabOrder = 1
          OnClick = btEditRelatedClick
        end
      end
      object dgRelated: TMyDBGridEh
        Left = 0
        Top = 121
        Width = 626
        Height = 220
        Align = alClient
        AllowedOperations = []
        DataGrouping.GroupLevels = <>
        DataSource = dsRelated
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        RowDetailPanel.Color = clBtnFace
        RowHeight = 18
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            EditButtons = <>
            FieldName = 'Name'
            Footers = <>
            Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            Width = 197
          end
          item
            EditButtons = <>
            FieldName = 'ContactName'
            Footers = <>
            Title.Caption = #1050#1086#1085#1090#1072#1082#1090
            Width = 203
          end
          item
            EditButtons = <>
            FieldName = 'Phone1'
            Footers = <>
            Title.Caption = #1058#1077#1083'. 1'
            Width = 93
          end
          item
            EditButtons = <>
            FieldName = 'Phone2'
            Footers = <>
            Title.Caption = #1058#1077#1083'. 2'
            Width = 82
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 626
        Height = 121
        Align = alTop
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 2
        DesignSize = (
          626
          121)
        object Label12: TLabel
          Left = 2
          Top = 100
          Width = 82
          Height = 13
          Caption = #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082#1080':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object gbPayCond: TGroupBox
          Left = 4
          Top = 4
          Width = 611
          Height = 85
          Anchors = [akLeft, akTop, akRight]
          Caption = ' '#1059#1089#1083#1086#1074#1080#1103' '#1086#1087#1083#1072#1090#1099' '
          TabOrder = 0
          DesignSize = (
            611
            85)
          object Label10: TLabel
            Left = 14
            Top = 52
            Width = 94
            Height = 13
            Caption = #1055#1088#1077#1076#1086#1090#1075#1088#1091#1079#1082#1072', %:'
          end
          object lbPrePay: TLabel
            Left = 14
            Top = 26
            Width = 84
            Height = 13
            Caption = #1055#1088#1077#1076#1086#1087#1083#1072#1090#1072', %:'
          end
          object Label11: TLabel
            Left = 180
            Top = 26
            Width = 85
            Height = 13
            Caption = #1054#1090#1089#1088#1086#1095#1082#1072', '#1076#1085#1077#1081':'
          end
          object edPrePayPercent: TDBEdit
            Left = 114
            Top = 22
            Width = 43
            Height = 21
            DataField = 'PrePayPercent'
            TabOrder = 0
          end
          object edPreShipPercent: TDBEdit
            Left = 114
            Top = 48
            Width = 43
            Height = 21
            DataField = 'PreShipPercent'
            TabOrder = 1
          end
          object edPayDelay: TDBEdit
            Left = 268
            Top = 22
            Width = 43
            Height = 21
            DataField = 'PayDelay'
            TabOrder = 2
          end
          object cbCheckPayConditions: TDBCheckBox
            Left = 334
            Top = 48
            Width = 163
            Height = 17
            Caption = #1050#1086#1085#1090#1088#1086#1083#1100' '#1091#1089#1083#1086#1074#1080#1081' '#1086#1087#1083#1072#1090#1099
            DataField = 'CheckPayConditions'
            TabOrder = 3
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object cbIsPayDelayInBankDays: TDBCheckBox
            Left = 334
            Top = 24
            Width = 127
            Height = 17
            Caption = #1041#1072#1085#1082#1086#1074#1089#1082#1080#1077' '#1076#1085#1080
            DataField = 'IsPayDelayInBankDays'
            TabOrder = 4
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object DBCheckBox1: TDBCheckBox
            Left = 591
            Top = 68
            Width = 20
            Height = 17
            Anchors = [akTop, akRight]
            Caption = '!'
            DataField = 'Alert'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
        end
      end
    end
    object tsContact: TTabSheet
      Caption = #1050#1086#1085#1090#1072#1082#1090#1099
      ImageIndex = 4
    end
    object tsFinance: TTabSheet
      Caption = #1056#1077#1082#1074#1080#1079#1080#1090#1099
      ImageIndex = 1
      DesignSize = (
        630
        380)
      object lbBank: TLabel
        Left = 12
        Top = 238
        Width = 121
        Height = 13
        Caption = #1041#1072#1085#1082#1086#1074#1089#1082#1080#1077' '#1088#1077#1082#1074#1080#1079#1080#1090#1099':'
        FocusControl = edBank
      end
      object lbIndCode: TLabel
        Left = 12
        Top = 148
        Width = 184
        Height = 13
        Caption = #1048#1085#1076#1080#1074#1080#1076#1091#1072#1083#1100#1085#1099#1081' '#1085#1072#1083#1086#1075#1086#1074#1099#1081' '#1085#1086#1084#1077#1088':'
      end
      object lbNDSCode: TLabel
        Left = 244
        Top = 148
        Width = 212
        Height = 13
        Caption = #1053#1086#1084#1077#1088' '#1089#1074#1080#1076#1077#1090#1077#1083#1100#1089#1090#1074#1072' '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072' '#1053#1044#1057':'
      end
      object Label4: TLabel
        Left = 12
        Top = 102
        Width = 57
        Height = 13
        Caption = #1050#1086#1076' '#1054#1050#1055#1054':'
      end
      object Label8: TLabel
        Left = 12
        Top = 193
        Width = 107
        Height = 13
        Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1081' '#1072#1076#1088#1077#1089':'
        FocusControl = edLegalAddress
      end
      object Label9: TLabel
        Left = 12
        Top = 11
        Width = 102
        Height = 13
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1074' 1'#1057':'
      end
      object Label16: TLabel
        Left = 12
        Top = 56
        Width = 116
        Height = 13
        Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
        FocusControl = edFullName2
      end
      object edBank: TDBEdit
        Left = 12
        Top = 256
        Width = 536
        Height = 21
        DataField = 'Bank'
        TabOrder = 5
      end
      object edIndCode: TDBEdit
        Left = 12
        Top = 165
        Width = 209
        Height = 21
        DataField = 'IndCode'
        TabOrder = 2
      end
      object edNDSCode: TDBEdit
        Left = 244
        Top = 165
        Width = 210
        Height = 21
        DataField = 'NDSCode'
        TabOrder = 3
      end
      object edOKPO: TDBEdit
        Left = 12
        Top = 120
        Width = 209
        Height = 21
        DataField = 'OKPOCode'
        TabOrder = 1
      end
      object edLegalAddress: TDBEdit
        Left = 12
        Top = 211
        Width = 536
        Height = 21
        DataField = 'LegalAddress'
        TabOrder = 4
      end
      object edExternalName: TDBEdit
        Left = 12
        Top = 29
        Width = 209
        Height = 21
        DataField = 'ExternalName'
        TabOrder = 0
      end
      object edFullName2: TDBEdit
        Left = 12
        Top = 73
        Width = 571
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'FullName'
        TabOrder = 6
      end
    end
    object tsAddress: TTabSheet
      BorderWidth = 2
      Caption = #1040#1076#1088#1077#1089#1072
      ImageIndex = 6
      object Panel3: TPanel
        Left = 0
        Top = 341
        Width = 626
        Height = 35
        Align = alBottom
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 0
        object btAddAddress: TBitBtn
          Left = 4
          Top = 6
          Width = 86
          Height = 25
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 0
          OnClick = btAddAddressClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000120B0000120B00001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777777777777777777777777777777777777777000777777777777700077
            7777777777700077777777770000000007777777000000000777777700000000
            0777777777700077777777777770007777777777777000777777777777777777
            7777777777777777777777777777777777777777777777777777}
        end
        object btDeleteAddress: TBitBtn
          Left = 192
          Top = 6
          Width = 86
          Height = 25
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 2
          OnClick = btDeleteAddressClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000120B0000120B00001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777777777777777777777777777777777777777777777777777777777777
            7777777777777777777777700000000007777770000000000777777000000000
            0777777777777777777777777777777777777777777777777777777777777777
            7777777777777777777777777777777777777777777777777777}
        end
        object btEditAddress: TBitBtn
          Left = 100
          Top = 6
          Width = 81
          Height = 25
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
          TabOrder = 1
          OnClick = btEditAddressClick
        end
      end
      object dgAddr: TMyDBGridEh
        Left = 0
        Top = 0
        Width = 626
        Height = 341
        Align = alClient
        AllowedOperations = []
        DataGrouping.GroupLevels = <>
        DataSource = dsAddrs
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        RowDetailPanel.Color = clBtnFace
        RowHeight = 18
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDblClick = btEditAddressClick
        Columns = <
          item
            EditButtons = <>
            FieldName = 'Address'
            Footers = <>
            Title.Caption = #1040#1076#1088#1077#1089
            Width = 266
          end
          item
            EditButtons = <>
            FieldName = 'Name'
            Footers = <>
            Title.Caption = #1048#1084#1103
            Width = 129
          end
          item
            EditButtons = <>
            FieldName = 'Note'
            Footers = <>
            Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            Width = 209
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object tsOther: TTabSheet
      Caption = #1044#1088#1091#1075#1086#1077
      ImageIndex = 2
      DesignSize = (
        630
        380)
      object Label1: TLabel
        Left = 12
        Top = 27
        Width = 121
        Height = 13
        Caption = #1044#1077#1085#1100' '#1088#1086#1078#1076#1077#1085#1080#1103' '#1092#1080#1088#1084#1099':'
      end
      object Label3: TLabel
        Left = 12
        Top = 52
        Width = 65
        Height = 13
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103':'
      end
      object dtFirmBirthday: TJvDateEdit
        Left = 142
        Top = 24
        Width = 113
        Height = 21
        DialogTitle = #1042#1099#1073#1086#1088' '#1076#1072#1090#1099
        ImageKind = ikDropDown
        Weekends = [Sun, Sat]
        TabOrder = 0
      end
      object memoNotes: TDBMemo
        Left = 12
        Top = 71
        Width = 607
        Height = 298
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataField = 'Notes'
        TabOrder = 1
      end
      object cbSyncWeb: TDBCheckBox
        Left = 522
        Top = 26
        Width = 97
        Height = 17
        Anchors = [akTop, akRight]
        Caption = #1044#1086#1089#1090#1091#1087' '#1082' '#1089#1072#1081#1090#1091
        DataField = 'SyncWeb'
        TabOrder = 2
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
    end
  end
  object dsPersons: TDataSource
    Left = 44
    Top = 402
  end
  object FormStorage: TJvFormStorage
    AppStoragePath = 'CustomerInfo\'
    StoredValues = <>
    Left = 8
    Top = 403
  end
  object dsRelated: TDataSource
    Left = 84
    Top = 402
  end
  object dsAddrs: TDataSource
    Left = 124
    Top = 402
  end
  object dsStatus: TDataSource
    Left = 164
    Top = 402
  end
  object dsActivity: TDataSource
    Left = 202
    Top = 402
  end
end
