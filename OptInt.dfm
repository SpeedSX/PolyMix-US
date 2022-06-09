object OptIntForm: TOptIntForm
  Left = 231
  Top = 443
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1080#1085#1090#1077#1088#1092#1077#1081#1089#1072' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
  ClientHeight = 469
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  DesignSize = (
    490
    469)
  PixelsPerInch = 96
  TextHeight = 13
  object btOk: TBitBtn
    Left = 297
    Top = 438
    Width = 89
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btOkClick
    NumGlyphs = 2
    Spacing = 7
  end
  object btCancel: TBitBtn
    Left = 397
    Top = 438
    Width = 89
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
    OnClick = btCancelClick
    NumGlyphs = 2
    Spacing = 7
  end
  object pcOptions: TPageControl
    Left = 6
    Top = 6
    Width = 480
    Height = 425
    ActivePage = tsCommon
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object tsCommon: TTabSheet
      Caption = #1054#1073#1097#1080#1077
      object cbConfDel: TCheckBox
        Left = 8
        Top = 8
        Width = 417
        Height = 17
        Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1091#1076#1072#1083#1077#1085#1080#1103' '#1079#1072#1087#1080#1089#1080' '#1087#1088#1086#1094#1077#1089#1089#1072' '#1074' '#1089#1086#1089#1090#1072#1074#1077' '#1079#1072#1082#1072#1079#1072
        TabOrder = 0
      end
      object cbAutoOpen: TCheckBox
        Left = 240
        Top = 242
        Width = 213
        Height = 17
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080#1081' '#1074#1093#1086#1076' '#1074' '#1079#1072#1082#1072#1079
        Enabled = False
        TabOrder = 12
        Visible = False
      end
      object cbCustConfDel: TCheckBox
        Left = 8
        Top = 28
        Width = 297
        Height = 17
        Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1091#1076#1072#1083#1077#1085#1080#1103' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
        TabOrder = 1
      end
      object cbHideOnEdit: TCheckBox
        Left = 202
        Top = 254
        Width = 281
        Height = 17
        Caption = #1057#1082#1088#1099#1074#1072#1090#1100' '#1090#1072#1073#1083#1080#1094#1091' '#1079#1072#1082#1072#1079#1086#1074' '#1087#1088#1080' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1080
        TabOrder = 13
        Visible = False
      end
      object GroupBox5: TGroupBox
        Left = 8
        Top = 215
        Width = 379
        Height = 65
        Caption = ' '#1058#1072#1073#1083#1080#1094#1099' '#1087#1088#1086#1094#1077#1089#1089#1086#1074' '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 10
        object cbEnterAsTab: TCheckBox
          Left = 12
          Top = 20
          Width = 209
          Height = 17
          Caption = #1054#1073#1088#1072#1073#1072#1090#1099#1074#1072#1090#1100' <Enter> '#1082#1072#1082' <Tab>'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object cbAutoAppend: TCheckBox
          Left = 12
          Top = 40
          Width = 233
          Height = 17
          Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1076#1086#1073#1072#1074#1083#1103#1090#1100' '#1085#1086#1074#1099#1077' '#1089#1090#1088#1086#1082#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
      end
      object cbCopyToWork: TCheckBox
        Left = 8
        Top = 88
        Width = 385
        Height = 17
        Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1080#1089#1093#1086#1076#1085#1099#1081' '#1087#1088#1086#1089#1095#1077#1090' '#1087#1088#1080' '#1087#1077#1088#1077#1074#1086#1076#1077' '#1087#1088#1086#1089#1095#1077#1090#1072' '#1074' '#1079#1072#1082#1072#1079
        TabOrder = 4
      end
      object cbShowProcessCount: TCheckBox
        Left = 8
        Top = 48
        Width = 373
        Height = 17
        Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1079#1072#1087#1080#1089#1077#1081' '#1074' '#1090#1072#1073#1083#1080#1094#1077' '#1087#1088#1086#1094#1077#1089#1089#1086#1074
        TabOrder = 2
      end
      object gbErrHandling: TGroupBox
        Left = 8
        Top = 285
        Width = 379
        Height = 65
        Caption = ' '#1055#1088#1080' '#1086#1096#1080#1073#1082#1072#1093' '#1074' '#1089#1094#1077#1085#1072#1088#1080#1103#1093'... '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 11
        object rbErrorEdit: TRadioButton
          Left = 12
          Top = 20
          Width = 313
          Height = 17
          Caption = #1047#1072#1075#1088#1091#1078#1072#1090#1100' '#1089#1094#1077#1085#1072#1088#1080#1081' '#1074' '#1088#1077#1076#1072#1082#1090#1086#1088' ('#1088#1077#1078#1080#1084' '#1088#1072#1079#1088#1072#1073#1086#1090#1095#1080#1082#1072')'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object rbErrorMsg: TRadioButton
          Left = 12
          Top = 40
          Width = 333
          Height = 17
          Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1089#1086#1086#1073#1097#1077#1085#1080#1077' '#1086#1073' '#1086#1096#1080#1073#1082#1077' ('#1088#1077#1078#1080#1084' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103')'
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          TabStop = True
        end
      end
      object cbNewAtEnd: TCheckBox
        Left = 8
        Top = 68
        Width = 277
        Height = 17
        Caption = #1053#1086#1074#1099#1077' '#1087#1088#1086#1089#1095#1077#1090#1099' '#1080' '#1079#1072#1082#1072#1079#1099' - '#1074' '#1082#1086#1085#1094#1077' '#1090#1072#1073#1083#1080#1094#1099
        Color = clBtnFace
        ParentColor = False
        TabOrder = 3
        Visible = False
      end
      object cbEnableVB: TCheckBox
        Left = 8
        Top = 128
        Width = 413
        Height = 17
        Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1077' '#1084#1072#1082#1088#1086#1089#1086#1074' MS Excel '#1087#1088#1080' '#1074#1099#1074#1086#1076#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
        TabOrder = 6
      end
      object cbVerboseLog: TCheckBox
        Left = 8
        Top = 355
        Width = 379
        Height = 17
        Caption = #1055#1086#1076#1088#1086#1073#1085#1086#1077' '#1078#1091#1088#1085#1072#1083#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1086#1073#1099#1090#1080#1081' ('#1076#1083#1103' '#1088#1072#1079#1088#1072#1073#1086#1090#1095#1080#1082#1072')'
        TabOrder = 14
      end
      object cbShowUserLogin: TCheckBox
        Left = 8
        Top = 168
        Width = 413
        Height = 17
        Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1083#1086#1075#1080#1085#1099' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
        TabOrder = 8
      end
      object cbShortExcel: TCheckBox
        Left = 8
        Top = 108
        Width = 349
        Height = 17
        Caption = #1057#1086#1082#1088#1072#1097#1077#1085#1085#1099#1081' '#1080#1085#1090#1077#1088#1092#1077#1081#1089' Excel '#1074' '#1086#1090#1095#1077#1090#1072#1093
        TabOrder = 5
      end
      object cbOpenOffice: TCheckBox
        Left = 8
        Top = 148
        Width = 379
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' OpenOffice'
        TabOrder = 7
      end
      object cbConfirmQuit: TCheckBox
        Left = 8
        Top = 188
        Width = 413
        Height = 17
        Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1074#1099#1093#1086#1076#1072' '#1080#1079' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103' '#1080#1083#1080' '#1079#1072#1082#1072#1079#1072
        TabOrder = 9
      end
    end
    object tsView: TTabSheet
      Caption = #1042#1080#1076
      ImageIndex = 1
      object Label1: TLabel
        Left = 312
        Top = 168
        Width = 66
        Height = 13
        Caption = #1064#1088#1080#1092#1090' '#1084#1077#1085#1102
      end
      object gbPanel: TGroupBox
        Left = 8
        Top = 278
        Width = 317
        Height = 109
        Caption = ' '#1055#1072#1085#1077#1083#1100' '#1082#1086#1084#1072#1085#1076' '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object cbGrayBtn: TCheckBox
          Left = 8
          Top = 19
          Width = 233
          Height = 17
          Caption = #1063#1077#1088#1085#1086'-'#1073#1077#1083#1099#1077' '#1082#1072#1088#1090#1080#1085#1082#1080' '#1087#1088#1080' '#1085#1077#1072#1082#1090#1080#1074#1085#1086#1089#1090#1080
          Checked = True
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          State = cbChecked
          TabOrder = 0
        end
        object cbFlatBtn: TCheckBox
          Left = 8
          Top = 39
          Width = 181
          Height = 17
          Caption = #1055#1083#1086#1089#1082#1080#1077' '#1082#1085#1086#1087#1082#1080
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 1
        end
        object cbBack: TCheckBox
          Left = 8
          Top = 60
          Width = 257
          Height = 17
          Caption = #1060#1086#1085#1086#1074#1086#1077' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077' '#1087#1072#1085#1077#1083#1080' '#1080#1085#1089#1090#1088#1091#1084#1077#1085#1090#1086#1074
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 3
          OnClick = cbBackClick
        end
        object feBack: TJvFilenameEdit
          Left = 28
          Top = 80
          Width = 253
          Height = 21
          AddQuotes = False
          Filter = 
            #1042#1089#1110' '#1092#1072#1081#1083#1080' (*.*)|*.*|'#1060#1072#1081#1083#1080' '#1079#1086#1073#1088#1072#1078#1077#1085#1100'|*.bmp;*.gif;*.jpg;*.jpeg;*.i' +
            'co;*.wmf;*.emf'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
      end
      object GroupBox6: TGroupBox
        Left = 8
        Top = 222
        Width = 317
        Height = 49
        Caption = ' '#1058#1072#1073#1083#1080#1094#1072' '#1087#1088#1086#1094#1077#1089#1089#1086#1074' '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object Label7: TLabel
          Left = 10
          Top = 21
          Width = 69
          Height = 13
          Caption = #1042#1099#1089#1086#1090#1072' '#1089#1090#1088#1086#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object edPageCostRowHeight: TEdit
          Left = 86
          Top = 18
          Width = 45
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = '16'
        end
        object udPageCostRowHeight: TUpDown
          Left = 131
          Top = 18
          Width = 15
          Height = 21
          Associate = edPageCostRowHeight
          Position = 16
          TabOrder = 1
          Thousands = False
        end
        object cbPageCostRowLines: TCheckBox
          Left = 168
          Top = 20
          Width = 97
          Height = 17
          Caption = #1051#1080#1085#1080#1080' '#1089#1090#1088#1086#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
      end
      object clNewColor: TJvColorComboBox
        Left = 310
        Top = 8
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
        TabOrder = 2
      end
      object MyDBGridEh1: TMyDBGridEh
        Left = 6
        Top = 6
        Width = 289
        Height = 203
        DataGrouping.GroupLevels = <>
        DataSource = dsColors
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        Options = [dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghHighlightFocus, dghClearSelection, dghDialogFind, dghColumnResize, dghColumnMove]
        RowDetailPanel.Color = clBtnFace
        TabOrder = 3
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            EditButtons = <>
            FieldName = 'ColorDesc'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object boxFonts: TJvFontComboBox
        Left = 312
        Top = 188
        Width = 137
        Height = 22
        DroppedDownWidth = 137
        MaxMRUCount = 0
        FontName = 'Gautami'
        ItemIndex = 51
        Sorted = False
        TabOrder = 4
      end
    end
    object tsWork: TTabSheet
      Caption = #1047#1072#1082#1072#1079#1099
      ImageIndex = 4
      DesignSize = (
        472
        397)
      object Label5: TLabel
        Left = 40
        Top = 240
        Width = 12
        Height = 13
        Caption = #1047#1072
      end
      object Label8: TLabel
        Left = 111
        Top = 240
        Width = 29
        Height = 13
        Caption = #1095#1072#1089#1086#1074
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 134
        Width = 452
        Height = 65
        Anchors = [akLeft, akTop, akRight]
        Caption = ' '#1062#1074#1077#1090' '#1089#1090#1088#1086#1082#1080' '#1074' '#1090#1072#1073#1083#1080#1094#1077' '#1079#1072#1082#1072#1079#1086#1074' '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object rbStateRowColor: TRadioButton
          Left = 10
          Top = 40
          Width = 253
          Height = 17
          Caption = #1047#1072#1074#1080#1089#1080#1090' '#1086#1090' '#1089#1086#1089#1090#1086#1103#1085#1080#1103' '#1079#1072#1082#1072#1079#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object rbUserRowColor: TRadioButton
          Left = 10
          Top = 20
          Width = 189
          Height = 17
          Caption = #1053#1072#1079#1085#1072#1095#1072#1077#1090#1089#1103' '#1087#1088#1086#1080#1079#1074#1086#1083#1100#1085#1086
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
      end
      object cbMarkUrgent: TCheckBox
        Left = 18
        Top = 214
        Width = 209
        Height = 17
        Caption = #1042#1099#1076#1077#1083#1103#1090#1100' '#1094#1074#1077#1090#1086#1084' '#1089#1088#1086#1095#1085#1099#1077' '#1079#1072#1082#1072#1079#1099
        TabOrder = 1
      end
      object edUrgent: TSpinEdit
        Left = 58
        Top = 237
        Width = 47
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        MaxValue = 100
        MinValue = 0
        ParentFont = False
        TabOrder = 2
        Value = 8
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 12
        Width = 452
        Height = 107
        Anchors = [akLeft, akTop, akRight]
        Caption = ' '#1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1089#1086#1089#1090#1086#1103#1085#1080#1077' '#1079#1072#1082#1072#1079#1072' '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        object cbShowOrderState: TCheckBox
          Left = 10
          Top = 20
          Width = 119
          Height = 17
          Caption = #1042#1099#1087#1086#1083#1085#1077#1085#1080#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object cbShowPayState: TCheckBox
          Left = 10
          Top = 40
          Width = 93
          Height = 17
          Caption = #1054#1087#1083#1072#1090#1099
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object cbShowShipmentState: TCheckBox
          Left = 10
          Top = 60
          Width = 93
          Height = 17
          Caption = #1054#1090#1075#1088#1091#1079#1082#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object cbShowLockState: TCheckBox
          Left = 10
          Top = 80
          Width = 93
          Height = 17
          Caption = #1041#1083#1086#1082#1080#1088#1086#1074#1082#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
      end
      object cbShowMatDateInWorkOrderPreview: TCheckBox
        Left = 18
        Top = 273
        Width = 436
        Height = 17
        Caption = 
          #1042' '#1088#1077#1078#1080#1084#1077' '#1087#1088#1086#1089#1084#1086#1090#1088#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1086#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1076#1072#1090#1099' '#1087#1083#1072#1085'/'#1092#1072#1082#1090' '#1074' '#1090#1072#1073#1083#1080#1094#1077' '#1084 +
          #1072#1090#1077#1088#1080#1072#1083#1086#1074
        TabOrder = 4
      end
    end
    object tsConnection: TTabSheet
      Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1077
      ImageIndex = 6
      TabVisible = False
      object cbSaveUser: TCheckBox
        Left = 8
        Top = 16
        Width = 189
        Height = 17
        Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1080#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
      end
      object rgFilter: TRadioGroup
        Left = 6
        Top = 44
        Width = 271
        Height = 44
        Caption = ' '#1060#1080#1083#1100#1090#1088#1072#1094#1080#1103' '#1076#1072#1085#1085#1099#1093' '
        Columns = 2
        ItemIndex = 1
        Items.Strings = (
          #1051#1086#1082#1072#1083#1100#1085#1072#1103
          #1053#1072' '#1089#1077#1088#1074#1077#1088#1077)
        TabOrder = 1
      end
      object GroupBox4: TGroupBox
        Left = 4
        Top = 104
        Width = 277
        Height = 69
        Caption = ' '#1055#1088#1086#1074#1077#1088#1103#1090#1100' '#1085#1072#1083#1080#1095#1080#1077' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1081' '#1085#1072' '#1089#1077#1088#1074#1077#1088#1077' '
        TabOrder = 2
        object cbCheckEXEUpdate: TCheckBox
          Left = 16
          Top = 20
          Width = 89
          Height = 17
          Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1099
          TabOrder = 0
        end
        object cbCheckXLSUpdate: TCheckBox
          Left = 16
          Top = 40
          Width = 153
          Height = 17
          Caption = #1064#1072#1073#1083#1086#1085#1086#1074' Excel-'#1086#1090#1095#1077#1090#1086#1074
          TabOrder = 1
        end
      end
    end
    object tsDoc: TTabSheet
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 2
      TabVisible = False
      object Label3: TLabel
        Left = 12
        Top = 8
        Width = 174
        Height = 13
        Caption = #1055#1072#1087#1082#1072' '#1076#1083#1103' '#1089#1074#1103#1079#1072#1085#1085#1099#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
        Visible = False
      end
      object dirDoc: TJvDirectoryEdit
        Left = 12
        Top = 28
        Width = 285
        Height = 21
        DialogKind = dkWin32
        MultipleDirs = True
        TabOrder = 0
        Visible = False
      end
      object cbCheckDep: TCheckBox
        Left = 12
        Top = 64
        Width = 369
        Height = 17
        Caption = #1055#1088#1086#1074#1077#1088#1103#1090#1100' '#1079#1072#1074#1080#1089#1080#1084#1086#1089#1090#1080' '#1087#1088#1080' '#1080#1079#1084#1077#1085#1077#1085#1080#1080' '#1079#1072#1082#1072#1079#1072' '#1054#1058#1050#1051#1070#1063#1045#1053#1054
        TabOrder = 1
        Visible = False
      end
    end
    object tsMat: TTabSheet
      Caption = #1052#1072#1090#1077#1088#1080#1072#1083#1099
      ImageIndex = 7
      object Label10: TLabel
        Left = 30
        Top = 74
        Width = 287
        Height = 13
        Caption = '('#1087#1086#1089#1090#1088#1072#1085#1080#1095#1085#1072#1103' '#1079#1072#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1079#1072#1082#1091#1087#1086#1082' '#1073#1091#1076#1077#1090' '#1086#1090#1082#1083#1102#1095#1077#1085#1072')'
      end
      object Label11: TLabel
        Left = 30
        Top = 34
        Width = 215
        Height = 13
        Caption = '('#1041#1083#1086#1082#1080#1088#1086#1074#1082#1072' '#1087#1088#1080' '#1101#1090#1086#1084' '#1085#1077' '#1073#1091#1076#1077#1090' '#1088#1072#1073#1086#1090#1072#1090#1100')'
      end
      object cbEditMatRequest: TCheckBox
        Left = 16
        Top = 14
        Width = 323
        Height = 17
        Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1074' '#1090#1072#1073#1083#1080#1094#1077' '#1079#1072#1082#1091#1087#1086#1082
        TabOrder = 0
      end
      object cbShowTotalMatRequests: TCheckBox
        Left = 16
        Top = 54
        Width = 275
        Height = 17
        Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1080#1090#1086#1075#1086#1074#1099#1077' '#1089#1091#1084#1084#1099' '#1074' '#1090#1072#1073#1083#1080#1094#1077' '#1079#1072#1082#1091#1087#1086#1082
        TabOrder = 1
      end
    end
    object tsInvoice: TTabSheet
      Caption = #1057#1095#1077#1090#1072
      ImageIndex = 5
      object Label9: TLabel
        Left = 32
        Top = 36
        Width = 281
        Height = 13
        Caption = '('#1087#1086#1089#1090#1088#1072#1085#1080#1095#1085#1072#1103' '#1079#1072#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1089#1095#1077#1090#1086#1074' '#1073#1091#1076#1077#1090' '#1086#1090#1082#1083#1102#1095#1077#1085#1072')'
      end
      object cbShowTotalInvoices: TCheckBox
        Left = 16
        Top = 14
        Width = 275
        Height = 17
        Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1080#1090#1086#1075#1086#1074#1099#1077' '#1089#1091#1084#1084#1099
        TabOrder = 0
      end
    end
    object tsSchedule: TTabSheet
      Caption = #1055#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077
      ImageIndex = 6
      DesignSize = (
        472
        397)
      object GroupBox1: TGroupBox
        Left = 12
        Top = 15
        Width = 446
        Height = 92
        Anchors = [akLeft, akTop, akRight]
        Caption = ' '#1042#1080#1076' '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label2: TLabel
          Left = 210
          Top = 28
          Width = 39
          Height = 13
          Caption = #1056#1072#1079#1084#1077#1088':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label4: TLabel
          Left = 11
          Top = 29
          Width = 40
          Height = 13
          Caption = #1064#1088#1080#1092#1090':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object edScheduleFontSize: TSpinEdit
          Left = 256
          Top = 26
          Width = 57
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          MaxValue = 100
          MinValue = 0
          ParentFont = False
          TabOrder = 0
          Value = 8
        end
        object cbScheduleShowCost: TCheckBox
          Left = 10
          Top = 60
          Width = 343
          Height = 17
          Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1089#1090#1086#1080#1084#1086#1089#1090#1100' '#1088#1072#1073#1086#1090
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object boxGridFonts: TJvFontComboBox
          Left = 59
          Top = 26
          Width = 137
          Height = 22
          DroppedDownWidth = 137
          MaxMRUCount = 0
          FontName = 'Gautami'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemIndex = 51
          ParentFont = False
          Sorted = False
          TabOrder = 2
        end
      end
    end
  end
  object ColorDlg: TColorDialog
    Left = 176
    Top = 426
  end
  object cdColors: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeScroll = cdColorsBeforeScroll
    AfterScroll = cdColorsAfterScroll
    Left = 372
    Top = 60
    object cdColorsColorDesc: TStringField
      FieldName = 'ColorDesc'
      Size = 100
    end
    object cdColorsColorValue: TIntegerField
      FieldName = 'ColorValue'
    end
    object cdColorsColorName: TStringField
      FieldName = 'ColorName'
      Size = 50
    end
  end
  object dsColors: TDataSource
    DataSet = cdColors
    Left = 408
    Top = 58
  end
end
