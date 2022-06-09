object OrderProp: TOrderProp
  Left = 231
  Top = 513
  BorderIcons = []
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1079#1072#1082#1072#1079#1072
  ClientHeight = 481
  ClientWidth = 506
  Color = clBtnFace
  Constraints.MinHeight = 508
  Constraints.MinWidth = 490
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    506
    481)
  PixelsPerInch = 96
  TextHeight = 13
  object pcOrderProp: TPageControl
    Left = 6
    Top = 8
    Width = 492
    Height = 428
    ActivePage = tsCommon
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object tsCommon: TTabSheet
      Caption = #1054#1073#1097#1080#1077
      DesignSize = (
        484
        400)
      object lbChar: TLabel
        Left = 6
        Top = 54
        Width = 174
        Height = 13
        Caption = #1050#1086#1085#1089#1090#1088#1091#1082#1090#1080#1074#1085#1072#1103' '#1093#1072#1088#1072#1082#1090#1077#1088#1080#1089#1090#1080#1082#1072':'
        Visible = False
      end
      object lbColor: TLabel
        Left = 229
        Top = 54
        Width = 69
        Height = 13
        Caption = #1050#1088#1072#1089#1086#1095#1085#1086#1089#1090#1100':'
        Visible = False
      end
      object Label6: TLabel
        Left = 6
        Top = 104
        Width = 51
        Height = 13
        Caption = #1047#1072#1082#1072#1079#1095#1080#1082':'
      end
      object Label8: TLabel
        Left = 6
        Top = 151
        Width = 135
        Height = 13
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1087#1088#1086#1076#1091#1082#1094#1080#1080':'
        FocusControl = edComment
      end
      object btNewCust: TSpeedButton
        Left = 365
        Top = 118
        Width = 110
        Height = 25
        Hint = #1042#1099#1073#1088#1072#1090#1100' '#1079#1072#1082#1072#1079#1095#1080#1082#1072
        Anchors = [akTop, akRight]
        Caption = #1047#1072#1082#1072#1079#1095#1080#1082#1080'...'
        Glyph.Data = {
          AA010000424DAA010000000000008A000000280000000E000000120000000100
          08000000000020010000430B0000430B0000150000001500000000000000FFFF
          FF000D0C0C00251B160014121100160F0B0038333000E4D9D000685A4D009A85
          7100AEA29500DAD2C90051473B00A79A8B0083766500BCB1A300928169009B8D
          7300EBE9E500F3F3F200C0C0C000141414141414141414020214141400001414
          140202141414020908021414000014140209080214020D090802141400001402
          0D09080210020D080C0C0914000014020D080C0C0C02100C080C021400001402
          100C080C0C020C08080C0214000003020C08080C020C11100E08021400000C0C
          11100E0802110D0D110E0214000002110D111008020A0D0C0D0E02080000020A
          0D0D110E020F0C0F0C020C080000020F0D0C0D0E0202070F0F0208080000020F
          0C0F0C02030212070F020E0800001402070F0F050D02131207060C1400001402
          12070F02100E0404050F041400001402131207050D0414041212041400001414
          0504040B12041414020214140000141414141402021414141414141400001414
          1414141414141414141414140000}
        ParentShowHint = False
        ShowHint = True
        Spacing = 7
        OnClick = btNewCustClick
        ExplicitLeft = 348
      end
      object lbColorBox: TLabel
        Left = 6
        Top = 197
        Width = 68
        Height = 13
        Caption = #1062#1074#1077#1090' '#1089#1090#1088#1086#1082#1080':'
      end
      object lbFinish: TLabel
        Left = 150
        Top = 197
        Width = 117
        Height = 13
        Caption = #1055#1083#1072#1085#1086#1074#1086#1077' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1077':'
      end
      object lbOrderState: TLabel
        Left = 6
        Top = 260
        Width = 123
        Height = 13
        Alignment = taRightJustify
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103':'
      end
      object lbPayState: TLabel
        Left = 244
        Top = 260
        Width = 99
        Height = 13
        Alignment = taRightJustify
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1086#1087#1083#1072#1090#1099':'
      end
      object lbOrderKind: TLabel
        Left = 6
        Top = 9
        Width = 60
        Height = 13
        Caption = #1042#1080#1076' '#1079#1072#1082#1072#1079#1072':'
      end
      object lbManualPayState: TLabel
        Left = 244
        Top = 309
        Width = 82
        Height = 13
        Alignment = taRightJustify
        Caption = #1057#1083#1091#1095#1072#1081' '#1086#1087#1083#1072#1090#1099':'
      end
      object Bevel2: TBevel
        Left = 6
        Top = 248
        Width = 471
        Height = 8
        Anchors = [akLeft, akTop, akRight]
        Shape = bsTopLine
        ExplicitWidth = 447
      end
      object lbKind: TLabel
        Left = 228
        Top = 9
        Width = 81
        Height = 13
        Caption = #1042#1080#1076' '#1087#1088#1086#1076#1091#1082#1094#1080#1080':'
        Visible = False
      end
      object lbExternalId: TLabel
        Left = 6
        Top = 309
        Width = 60
        Height = 13
        Caption = #1042#1085#1077#1096#1085#1080#1081' '#8470
        FocusControl = edExternalId
      end
      object edComment: TEdit
        Left = 6
        Top = 167
        Width = 468
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 5
      end
      object lkChar: TDBLookupComboBox
        Left = 6
        Top = 70
        Width = 213
        Height = 21
        DataField = 'ID_char'
        DropDownRows = 11
        KeyField = 'A3'
        ListField = 'A2'
        ListSource = dsTSChar
        TabOrder = 2
        Visible = False
      end
      object lkColor: TDBLookupComboBox
        Left = 228
        Top = 70
        Width = 248
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'ID_color'
        KeyField = 'Code'
        ListField = 'Name'
        ListSource = dsTSColors
        TabOrder = 3
        Visible = False
      end
      object acColorBox: TAnyColorCombo
        Left = 6
        Top = 215
        Width = 121
        Height = 22
        ColorValue = clWhite
        TabOrder = 6
      end
      object lkCustomer: TJvDBLookupCombo
        Left = 6
        Top = 120
        Width = 352
        Height = 21
        DropDownCount = 15
        DataField = 'Customer'
        DisplayEmpty = '<'#1053#1077' '#1091#1082#1072#1079#1072#1085'>'
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 16
        LookupField = 'N'
        LookupDisplay = 'Name;Phone'
        LookupSource = dsCust
        TabOrder = 4
        OnChange = lkCustomerChange
        OnGetImage = lkCustomerGetImage
      end
      object lkOrderState: TJvDBLookupCombo
        Left = 6
        Top = 279
        Width = 183
        Height = 21
        DataField = 'OrderState'
        DisplayEmpty = '<'#1085#1077' '#1091#1082#1072#1079#1072#1085#1086'>'
        EmptyItemColor = clMenu
        IndexSwitch = False
        ItemHeight = 16
        LookupField = 'Code'
        LookupDisplay = 'Name'
        TabOrder = 9
        OnChange = lkOrderStateCloseUp
        OnGetImage = lkOrderStateGetImage
      end
      object lkPayState: TJvDBLookupCombo
        Left = 244
        Top = 279
        Width = 228
        Height = 21
        DataField = 'PayState'
        DisplayEmpty = '<'#1085#1077' '#1091#1082#1072#1079#1072#1085#1086'>'
        EmptyItemColor = clMenu
        Anchors = [akLeft, akTop, akRight]
        IndexSwitch = False
        ItemHeight = 16
        LookupField = 'Code'
        LookupDisplay = 'Name'
        TabOrder = 10
        OnChange = lkPayStateChange
        OnGetImage = lkPayStateGetImage
      end
      object tmFinish: TMaskEdit
        Left = 256
        Top = 215
        Width = 50
        Height = 21
        EditMask = '!90:00;1; '
        MaxLength = 5
        TabOrder = 8
        Text = '  :  '
      end
      object deFinish: TJvDateEdit
        Left = 150
        Top = 215
        Width = 93
        Height = 21
        DialogTitle = #1042#1099#1073#1086#1088' '#1076#1072#1090#1099
        ImageKind = ikDropDown
        Weekends = [Sun, Sat]
        TabOrder = 7
        OnChange = deFinishChange
      end
      object cbOrderKind: TJvComboBox
        Left = 6
        Top = 26
        Width = 213
        Height = 21
        Style = csDropDownList
        EmptyValue = '0'
        EmptyFontColor = clWindowText
        ItemHeight = 13
        TabOrder = 0
        OnChange = cbOrderKindChange
      end
      object lkManualPayState: TJvDBLookupCombo
        Left = 244
        Top = 327
        Width = 228
        Height = 21
        DataField = 'PayState'
        DisplayEmpty = '<'#1085#1077' '#1091#1082#1072#1079#1072#1085'>'
        EmptyItemColor = clMenu
        Anchors = [akLeft, akTop, akRight]
        IndexSwitch = False
        ItemHeight = 16
        LookupField = 'Code'
        LookupDisplay = 'Name'
        TabOrder = 11
        OnGetImage = lkManualPayStateGetImage
      end
      object lkKind: TDBLookupComboBox
        Left = 228
        Top = 26
        Width = 248
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'ID_kind'
        DropDownRows = 6
        KeyField = 'Code'
        ListField = 'Name'
        ListSource = dsTSKind
        TabOrder = 1
        Visible = False
        OnCloseUp = lkKindCloseUp
      end
      object cbComposite: TCheckBox
        Left = 379
        Top = 216
        Width = 97
        Height = 17
        Anchors = [akTop, akRight]
        Caption = #1057#1073#1086#1088#1085#1099#1081' '#1079#1072#1082#1072#1079
        TabOrder = 12
        Visible = False
      end
      object edExternalId: TEdit
        Left = 6
        Top = 327
        Width = 183
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 13
      end
    end
    object tsNotes: TTabSheet
      Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077
      ImageIndex = 4
    end
    object tsFinance: TTabSheet
      Caption = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1077
      ImageIndex = 1
      DesignSize = (
        484
        400)
      object Label7: TLabel
        Left = 8
        Top = 12
        Width = 71
        Height = 13
        Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081':'
      end
      object gbPayConditions: TGroupBox
        Left = 6
        Top = 60
        Width = 470
        Height = 85
        Anchors = [akLeft, akTop, akRight]
        Caption = ' '#1059#1089#1083#1086#1074#1080#1103' '#1086#1087#1083#1072#1090#1099' '
        TabOrder = 0
        object Label1: TLabel
          Left = 14
          Top = 52
          Width = 90
          Height = 13
          Caption = #1055#1088#1077#1076#1086#1090#1075#1088#1091#1079#1082#1072', %'
        end
        object lbPrePay: TLabel
          Left = 14
          Top = 26
          Width = 80
          Height = 13
          Caption = #1055#1088#1077#1076#1086#1087#1083#1072#1090#1072', %'
        end
        object Label3: TLabel
          Left = 180
          Top = 26
          Width = 81
          Height = 13
          Caption = #1054#1090#1089#1088#1086#1095#1082#1072', '#1076#1085#1077#1081
        end
        object edPreShip: TJvValidateEdit
          Left = 116
          Top = 48
          Width = 37
          Height = 21
          CriticalPoints.MaxValueIncluded = False
          CriticalPoints.MinValueIncluded = False
          HasMaxValue = True
          HasMinValue = True
          MaxValue = 100.000000000000000000
          TabOrder = 1
        end
        object edPayDelay: TJvValidateEdit
          Left = 272
          Top = 22
          Width = 37
          Height = 21
          CriticalPoints.MaxValueIncluded = False
          CriticalPoints.MinValueIncluded = False
          HasMinValue = True
          TabOrder = 2
        end
        object edPrePay: TJvValidateEdit
          Left = 116
          Top = 22
          Width = 37
          Height = 21
          CriticalPoints.MaxValueIncluded = False
          CriticalPoints.MinValueIncluded = False
          HasMaxValue = True
          HasMinValue = True
          MaxValue = 100.000000000000000000
          TabOrder = 0
        end
        object cbIsPayDelayInBankDays: TCheckBox
          Left = 336
          Top = 24
          Width = 97
          Height = 17
          Caption = #1041#1072#1085#1082#1086#1074#1089#1082#1080#1077' '#1076#1085#1080
          TabOrder = 3
        end
      end
      object edComment2: TEdit
        Left = 8
        Top = 30
        Width = 470
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
      end
    end
    object tsAttached: TTabSheet
      Caption = #1060#1072#1081#1083#1099
      ImageIndex = 3
      DesignSize = (
        484
        400)
      object Label4: TLabel
        Left = 14
        Top = 14
        Width = 122
        Height = 13
        Caption = #1055#1088#1080#1082#1088#1077#1087#1083#1077#1085#1085#1099#1077' '#1092#1072#1081#1083#1099':'
      end
      object Label5: TLabel
        Left = 16
        Top = 286
        Width = 53
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
        ExplicitTop = 280
      end
      object btAddFile: TBitBtn
        Left = 394
        Top = 33
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100'...'
        TabOrder = 2
        OnClick = btAddFileClick
      end
      object btRemoveFile: TBitBtn
        Left = 394
        Top = 64
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1059#1076#1072#1083#1080#1090#1100'...'
        TabOrder = 3
        OnClick = btRemoveFileClick
      end
      object btOpenFile: TBitBtn
        Left = 394
        Top = 119
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1054#1090#1082#1088#1099#1090#1100'...'
        TabOrder = 4
        OnClick = btOpenFileClick
      end
      object dgAttached: TMyDBGridEh
        Left = 14
        Top = 33
        Width = 369
        Height = 246
        AllowedOperations = []
        Anchors = [akLeft, akTop, akRight, akBottom]
        AutoFitColWidths = True
        DataGrouping.GroupLevels = <>
        DrawMemoText = True
        Flat = False
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        Options = [dgColumnResize, dgTabs, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        RowDetailPanel.Color = clBtnFace
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            EditButtons = <>
            FieldName = 'FileName'
            Footers = <>
            Width = 155
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object memoFileDesc: TDBMemo
        Left = 14
        Top = 304
        Width = 370
        Height = 85
        Anchors = [akLeft, akRight, akBottom]
        DataField = 'FileDesc'
        TabOrder = 1
      end
    end
    object tsAdvanced: TTabSheet
      Caption = #1040#1076#1084#1080#1085#1080#1089#1090#1088#1072#1090#1080#1074#1085#1099#1077
      ImageIndex = 2
      object lbCreationDate: TLabel
        Left = 10
        Top = 55
        Width = 80
        Height = 13
        Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
      end
      object lbNum: TLabel
        Left = 10
        Top = 22
        Width = 35
        Height = 13
        Caption = #1053#1086#1084#1077#1088':'
      end
      object lbCreator: TLabel
        Left = 10
        Top = 95
        Width = 59
        Height = 13
        Caption = #1057#1086#1079#1076#1072#1090#1077#1083#1100':'
      end
      object lbStartDate: TLabel
        Left = 10
        Top = 135
        Width = 102
        Height = 13
        Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1088#1072#1073#1086#1090':'
      end
      object deCreationDate: TJvDateEdit
        Left = 124
        Top = 52
        Width = 91
        Height = 21
        DialogTitle = #1042#1099#1073#1086#1088' '#1076#1072#1090#1099
        ImageKind = ikDropDown
        Weekends = [Sun, Sat]
        TabOrder = 0
        OnChange = deFinishChange
      end
      object edCreationTime: TMaskEdit
        Left = 230
        Top = 52
        Width = 50
        Height = 21
        EditMask = '!90:00;1; '
        MaxLength = 5
        TabOrder = 1
        Text = '  :  '
      end
      object btChangeCreationDate: TBitBtn
        Left = 294
        Top = 50
        Width = 82
        Height = 25
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        TabOrder = 2
        OnClick = btChangeCreationDateClick
      end
      object edNum: TEdit
        Left = 124
        Top = 19
        Width = 91
        Height = 21
        TabOrder = 3
        Text = 'edNum'
      end
      object btChangeNumber: TBitBtn
        Left = 294
        Top = 17
        Width = 82
        Height = 25
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        TabOrder = 4
        OnClick = btChangeNumberClick
      end
      object lkCreator: TDBLookupComboBox
        Left = 124
        Top = 92
        Width = 155
        Height = 21
        DropDownRows = 6
        KeyField = 'AccessUserID'
        ListField = 'Name'
        TabOrder = 5
      end
      object deStartDate: TJvDateEdit
        Left = 124
        Top = 132
        Width = 90
        Height = 21
        DialogTitle = #1042#1099#1073#1086#1088' '#1076#1072#1090#1099
        ImageKind = ikDropDown
        Weekends = [Sun, Sat]
        TabOrder = 6
        OnChange = deFinishChange
      end
      object edStartTime: TMaskEdit
        Left = 230
        Top = 132
        Width = 50
        Height = 21
        EditMask = '!90:00;1; '
        MaxLength = 5
        TabOrder = 7
        Text = '  :  '
      end
      object btChangeStartDate: TBitBtn
        Left = 294
        Top = 130
        Width = 82
        Height = 25
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        TabOrder = 8
        OnClick = btChangeStartDateClick
      end
      object btSetStartDateToCreationDate: TBitBtn
        Left = 382
        Top = 130
        Width = 98
        Height = 25
        Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
        TabOrder = 9
        OnClick = btSetStartDateToCreationDateClick
      end
    end
  end
  object btOk: TBitBtn
    Left = 311
    Top = 446
    Width = 89
    Height = 27
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = btOkClick
    Glyph.Data = {
      32060000424D3206000000000000420000002800000028000000130000000100
      100003000000F0050000120B0000120B00000000000000000000007C0000E003
      00001F0000001F7C1F7C1F7C1F7C1F7C1F7C903E4D2E85018501850185014D2E
      903E1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C734ECE39C618
      C618C618C618082194521F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CC811
      8501E605861EC62E273B4643C636862AC50D85014E361F7C1F7C1F7C1F7C1F7C
      1F7C1F7C1F7C2925C6180821AD35CE3910421042CE39AD350821C618EF3D1F7C
      1F7C1F7C1F7C1F7C1F7C1F7CA6098501C71E081BE90AEA16E9260A2F09332837
      4743A62E85050B221F7C1F7C1F7C1F7C1F7C1F7C0821C618CE39EF3DAD35CE39
      10423146314631461042AD35C6188C311F7C1F7C1F7C1F7C1F7CC70DC6052A2F
      CA06CA02C902EA12E926092F092F092F092F283BE63A85052D2E1F7C1F7C1F7C
      1F7C2925E71C524A6B2D6B2D6B2DCE39104231463146314631461042EF3DC618
      CE391F7C1F7C1F7C4D2E8501EC1ACA06CA026602E511A80AEA1EE92A092F092F
      092F0A2F283BC636850192461F7C1F7CCE39C618CE398C316B2D292529258C31
      EF3D104231463146314631461042CE39C618734E1F7C1F7C85016A1A0C1BCA06
      4602D34E7B6B4A26A80EE922E92A092F092F092FEA2A27370516E9191F7C1F7C
      C6188C31EF3D8C31292594525A6BAD358C31EF3D104231463146314610421042
      4A296B2D1F7C903E8401313B0C1F670ED34E9C737C6F9C736C2EA70EEA1EE922
      E926E922EA1EE91AE62EA601134A3146C6189452EF3D6B2DB5569C737B6F9C73
      EF3D8C31EF3DEF3D10421042EF3DEF3DCE39C618D4512B1E2912523BCC1E1453
      BD779D73BD779D73BD776D32A70AEA0EE912E912C90ACA062727CA02C7098C31
      6B2D9452EF3DD65ABD779C73BD779C73BD7710426B2DAD35AD35AD358C316B2D
      10426B2D08212A1AAD26523B323FDE7BDE7BDE7BBC6FDE7BDE7BDE7B8D326602
      CA02CA02CA02CA02E81EE81EE6056B2DEF3D94529452DE7BDE7BDE7B9C73DE7B
      DE7BDE7B10424A296B2D6B2D6B2D6B2DEF3DEF3D08214A1AD032533F30337653
      FF7F5447C90E985BFF7FFF7FFF7F8D366602CA02CA02CA02E81AE81E47128C31
      31469452524AF75EFF7FD65A8C313967FF7FFF7FFF7F104229256B2D6B2D6B2D
      EF3DEF3D6B2D6B1ACF2E754F323B323B5343323B3137C90E9857FF7FFF7FFF7F
      8D364602CA02C9020B27E81E670A8C313146F75E9452734EB5569452734E8C31
      1863FF7FFF7FFF7F104229256B2D6B2D1042EF3D2925AC1EAC1A9857533F533F
      533F533F533F54430E23BA63FF7FFF7FFF7F1453880E31337353CA028802CE39
      AD3518639452945294529452B556B55610427B6FFF7FFF7FFF7FD65A6B2D524A
      F75E6B2D8C31F13A8702995F5443544354435443544354435443533FBB6BFF7F
      FF7FFF7F995F54432F3B8802D13A734E4A295A6BB556B556B556B556B556B556
      B55694529C73FF7FFF7FFF7F5A6BB556734E4A291F7C1F7CA9061033995F533F
      544354435443544354435443533FBB67FF7FBB6B533F7453A90EAD221F7C1F7C
      6B2D524A3967B556B556B556B556B556B556B55694527B6FFF7F9C739452F75E
      8C31CE391F7C1F7CF036870277579857533F544354435443544354435443533F
      7753533F754BED268802165B1F7C1F7C524A4A2918631863B556B556B556B556
      B556B556B556945218639452D65A10424A291F7C1F7C1F7C1F7CAB12880A9857
      985B5443544354435443544354435443533F764F323B8802D23E1F7C1F7C1F7C
      1F7C8C316B2D18633967B556B556B556B556B556B556B556B556F75E94524A29
      734E1F7C1F7C1F7C1F7C1F7CAB128806323BBA639757754B5443544375477653
      9757ED228802CF2A1F7C1F7C1F7C1F7C1F7C1F7C8C316B2D94527B6F1863D65A
      B556B556D65AF75E1863EF3D4A2910421F7C1F7C1F7C1F7C1F7C1F7C1F7CCF2E
      8802A90E102F5547764F7653323BEE2687028906144F1F7C1F7C1F7C1F7C1F7C
      1F7C1F7C1F7C31464A298C31524AD65AF75EF75E945210424A296B2DB5561F7C
      1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CCF2EA90A8802880288028802AB1A
      F13E1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C31468C314A29
      4A294A294A29AD35734E1F7C1F7C1F7C1F7C1F7C1F7C}
    NumGlyphs = 2
    Spacing = 8
  end
  object btCancel: TBitBtn
    Left = 411
    Top = 446
    Width = 89
    Height = 27
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
    Glyph.Data = {
      E6050000424DE605000000000000420000002800000026000000130000000100
      100003000000A4050000120B0000120B00000000000000000000007C0000E003
      00001F000000386B386B386B386B386B52564945A538633463346334A5384945
      5152386B386B386B386B386B386B386B386B386B386B734EAD35292508210821
      08212925AD35734E386B386B386B386B386B386B386B386B386B084163348340
      E45404652469246D045DC34463340841386B386B386B386B386B386B386B386B
      8C3108212925AD35EF3DEF3DEF3DAD354A2908218C31386B386B386B386B386B
      386B386B8438633CE5600671A66C877087748774C67825794471A3448438386B
      386B386B386B386B386B29252925CE3931461042104210423146524A524A1042
      4A292925386B386B386B386B17678438843CE76847644664855C855485548554
      85648674C6784579C3488438386B386B386B386B29254A291042AD35CE39AD35
      AD35AD35AD35CE391042524A31464A292925386B386B386B294563382C6D4760
      665C4A59F76EDE7BFF7FDE7B386F8C598568A6744575A3440841386B386BAD35
      2925524AAD35AD3510423967DE7BFF7FDE7B5A6B3146EF3D314631464A298C31
      386B386B62344A5DE96C66600F62FF7FFF7FFF7FFF7FFF7FFF7FFF7F0F5E8568
      A674446D8334386B386B082110423146AD35734EFF7FFF7FFF7FFF7FFF7FFF7F
      FF7F734EEF3D314610420821734E6B49843CCE75096D8D61FF7FFF7FFF7F5266
      65680B71197BFF7FFF7FCE6166700675C4484945EF3D4A29B556524A524AFF7F
      FF7FFF7FD65ACE39524A7B6FFF7FFF7F734EEF3D31466B2DAD35C6444A59AD71
      4A6D5A73FF7FFF7FFF7FDE7B4A596668666CD77AFF7FBD7B6564A66C0461C640
      6B2D1042B556524A7B6FFF7FFF7FFF7FDE7B1042CE39EF3D5A6BFF7FBD77CE39
      1042CE396B2D8444AD61CE718C69FF7FFF7FF876FF7FFF7FDE7B4A5966688768
      FF7FFF7F2B694764256584446B2D524AB556734EFF7FFF7F5A6BFF7FFF7FDE7B
      1042CE39EF3DFF7FFF7F3146CE39EF3D6B2D844C526ECF6D5372FF7F7B77C864
      D776FF7FFF7FDE7B2A5945643A7BFF7F4D6946602565A54C8C31F75EB556F75E
      FF7F9C73EF3D3967FF7FFF7FDE7B1042AD357B6FFF7F524AAD35EF3D8C318554
      F06932725372FF7FDE7B8D650B69D776FF7FFF7FDE7B2955BD7BFF7F4D694660
      4769A654AD359452D65AF75EFF7FDE7B734E31463967FF7FFF7FDE7BEF3DBD77
      FF7F524AAD351042AD35E75CCE699572F06DDE7FFF7FAD5D116EF06D5B7BFF7F
      FF7FDE7BFF7FFF7F2C69F16DCC6DE758EF3D94521863B556FF7FFF7F524AD65A
      B5569C73FF7FFF7FDE7BFF7FFF7F524AB556734EEF3DAD6508651977116E3A77
      FF7FDE7B4A554A59AE65F772FF7FFF7FFF7F5B7B126E537228696B61734E1042
      5A6BB5567B6FFF7FDE7BEF3D1042734E3967FF7FFF7FFF7F9C73D65AF75E3146
      524A386BA66474729672326EBD7BFF7FFF7F186F7266F76EFF7FFF7FBD7B336E
      336E3072A6647262386BEF3D18631863D65ADE7BFF7FFF7F5A6BD65A3967FF7F
      FF7FDE7BD65AD65AD65AEF3DB556386B6B65E86419777572126E7C7BFF7FFF7F
      FF7FFF7FFF7F9D7B326E326E7372E7644B65386B386B524A10427B6F1863D65A
      BD77FF7FFF7FFF7FFF7FFF7FBD77D65AD65AF75E10423146386B386B386BE764
      296919779672126E5372F8761977F8767472126E336EB6722A69C764386B386B
      386B386B104231467B6F1863B556F75E5A6B7B6F5A6BF75EB556D65A3967524A
      1042386B386B386B386B386BE764E8647472197796725472126E336E7472D772
      5372E864C764386B386B386B386B386B386B1042104218635A6B1863F75ED65A
      D65AF75E3967F75E10421042386B386B386B386B386B386B176B6B65A6642969
      F06D537295725272CF6D0969A6646B65386B386B386B386B386B386B386B386B
      524AEF3D3146B556F75E1863D65AB5563146EF3D524A386B386B386B386B386B
      386B386B386B386BB46AAD65E864A664A664A664E864AD65B46A386B386B386B
      386B386B386B386B386B386B386BF75E734E1042EF3DEF3DEF3D1042734EF75E
      386B386B386B386B386B}
    NumGlyphs = 2
    Spacing = 8
  end
  object btSelectTemplate: TBitBtn
    Left = 7
    Top = 446
    Width = 105
    Height = 27
    Anchors = [akLeft, akBottom]
    Caption = #1055#1086' '#1096#1072#1073#1083#1086#1085#1091'...'
    TabOrder = 1
    OnClick = btSelectTemplateClick
    NumGlyphs = 2
    Spacing = 8
  end
  object dsTSKind: TDataSource
    Left = 366
    Top = 34
  end
  object dsTSColors: TDataSource
    Left = 398
    Top = 34
  end
  object dsTSChar: TDataSource
    Left = 430
    Top = 34
  end
  object dsCust: TDataSource
    Left = 24
    Top = 362
  end
end
