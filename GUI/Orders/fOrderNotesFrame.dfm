object OrderNotesFrame: TOrderNotesFrame
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  TabOrder = 0
  DesignSize = (
    451
    304)
  object Label9: TLabel
    Left = 9
    Top = 146
    Width = 65
    Height = 13
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103':'
  end
  object Label5: TLabel
    Left = 9
    Top = 111
    Width = 144
    Height = 13
    Caption = #1060#1086#1088#1084#1072#1090' '#1075#1086#1090#1086#1074#1086#1081' '#1087#1088#1086#1076#1091#1082#1094#1080#1080':'
  end
  object Label6: TLabel
    Left = 314
    Top = 111
    Width = 65
    Height = 13
    Caption = #1054#1073#1098#1077#1084', '#1089#1090#1088'.:'
  end
  object Label1: TLabel
    Left = 10
    Top = 40
    Width = 59
    Height = 13
    Caption = #1047#1072#1082#1072#1079#1095#1080#1082#1086#1084
  end
  object Label2: TLabel
    Left = 10
    Top = 60
    Width = 84
    Height = 13
    Caption = #1087#1088#1077#1076#1086#1089#1090#1072#1074#1083#1077#1085#1099':'
  end
  object dgNotes: TMyDBGridEh
    Left = 9
    Top = 164
    Width = 432
    Height = 98
    AllowedOperations = []
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoFitColWidths = True
    DataGrouping.GroupLevels = <>
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghColumnResize, dghColumnMove, dghAutoFitRowHeight]
    RowDetailPanel.Color = clBtnFace
    RowHeight = 5
    RowLines = 1
    TabOrder = 10
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = btEditNoteClick
    OnGetCellParams = dgNotesGetCellParams
    Columns = <
      item
        Checkboxes = False
        EditButtons = <>
        FieldName = 'UseTech'
        Footers = <>
        MaxWidth = 26
        MinWidth = 26
        ReadOnly = True
        Title.Caption = #1058#1077#1093'.'
        Width = 26
      end
      item
        EditButtons = <>
        FieldName = 'UserName'
        Footers = <>
        ReadOnly = True
        Title.Caption = #1040#1074#1090#1086#1088
        Width = 81
      end
      item
        EditButtons = <>
        FieldName = 'Note'
        Footers = <>
        ReadOnly = True
        Title.Caption = #1058#1077#1082#1089#1090
        Width = 290
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object btAddNote: TBitBtn
    Left = 8
    Top = 269
    Width = 89
    Height = 27
    Anchors = [akLeft, akBottom]
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 11
    OnClick = btAddNoteClick
    Glyph.Data = {
      5A010000424D5A01000000000000CA000000280000000C0000000C0000000100
      08000000000090000000430B0000430B0000250000002500000000000000FFFF
      FF00E8E7E8005E373100D6CAC6001C080000A2502D00F1793D00DE9570003833
      3000B387640075695F00E4D9D000685A4D00CEC3B900C6BEB70055504B00E1E0
      DF009C908300AEA29500DAD2C900EBE3DA00A79A8B00B4A79800C6BBAE00988D
      7F00BCB1A300EBE9E500BABAB80000330F0016B36A00CCF4FD009CD4E400216A
      9A005EA3DB00EBEBEB00C0C0C000242424170A06060A17242424242408060606
      06060616242424080606060101060606161C18060606060101060606061A0806
      0606060101060606060806060101010101010101060607070101010101010101
      07070807070707010107070707081A070707070101070707070E240807070701
      01070707081C242408070707070707082424242424180807070818242424}
    Spacing = 8
  end
  object btEditNote: TBitBtn
    Left = 103
    Top = 269
    Width = 89
    Height = 27
    Anchors = [akLeft, akBottom]
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    TabOrder = 12
    OnClick = btEditNoteClick
    Glyph.Data = {
      FE010000424DFE01000000000000FE0000002800000010000000100000000100
      08000000000000010000210B0000210B00003200000032000000FFFFFF0000FF
      FF00FF00FF000000FF00FFFF000000FF0000FF0000000000000007035A007B64
      5A003E3935002D2C2A00FEFEFC00F2F2F000EDEDEB00FBFBFA00F8F8F700F7F7
      F600E7E7E600E2E2E10006A11C00108E230006731C00118F2A0018AB440058CA
      8400374546003A5C600097E7FB008286870015C4FB000C84B10001A5E6000B3B
      5400165E8200909293001F92F20080A6CB003187E7002A407B006E88D8002D44
      B4006F7FD500111B8300D7D7D700D1D1D100C5C5C500BABABA0019191900FFFF
      FF0002020202020202020202020202020202021D1D1D1D1D1D1D1D1D1D1D1D1D
      0202230C0C0C0C0C0F110D0E12132C2E1D02230C0C0C0C0C0C0F110D0E12132C
      1D02230C0C0C300A2D0C0F110D0E12131D02230C2D2F0A0B1A2D0C0F110D0E12
      1D02230C0C0C0C1B1F21270C0F110D0E1D02230C2D2F2F1B22091F272F2F2F0D
      1D02230C0C0C0C0C251E201F270C0C101D02230C0C0C0C0C251C1E201F270C0C
      1D0223161616161616251C1E201F27161D021419141414141414251C1E201F27
      0202021419181817020202251C1E242B08020202141415020202020225262929
      2B08020202020202020202020229282A29020202020202020202020202022929
      0202}
    Spacing = 8
  end
  object btDeleteNote: TBitBtn
    Left = 199
    Top = 269
    Width = 89
    Height = 27
    Anchors = [akLeft, akBottom]
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 13
    OnClick = btDeleteNoteClick
    Glyph.Data = {
      1E010000424D1E01000000000000B2000000280000000A000000090000000100
      0800000000006C000000430B0000430B00001F0000001F00000000000000FFFF
      FF00E8E7E800D6CAC6001C08000075695F00E4D9D000685A4D00CEC3B900C6BE
      B70055504B009C908300AEA29500DAD2C900EBE3DA00A79A8B00988D7F00EBE9
      E50000330F0016B36A00CCF4FD009CD4E400216A9A005EA3DB00C9D5E7001415
      E3005F5FF4009091D700FAFAFA00EBEBEB00C0C0C0001B19191919191919191B
      000019191B191919191B19190000191B1C181919181C1A19000019191B1C1818
      1C1A191900001919191A1C1C1B191919000019191A021C1C021919190000191B
      021C1A1A1C021A190000191A021A19191A021A1900001B19191919191919191B
      0000}
    Spacing = 8
  end
  object cbCallCustomer: TDBCheckBox
    Left = 9
    Top = 14
    Width = 137
    Height = 17
    Caption = #1047#1072#1082#1072#1079#1095#1080#1082' '#1085#1072' '#1087#1088#1080#1083#1072#1076#1082#1077':'
    DataField = 'CallCustomer'
    TabOrder = 0
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object cbHaveLayout: TDBCheckBox
    Left = 103
    Top = 38
    Width = 103
    Height = 17
    Caption = #1052#1072#1082#1077#1090
    DataField = 'HaveLayout'
    TabOrder = 2
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object cbHavePattern: TDBCheckBox
    Left = 103
    Top = 60
    Width = 103
    Height = 17
    Caption = #1054#1073#1088#1072#1079#1077#1094
    DataField = 'HavePattern'
    TabOrder = 3
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object cbSignProof: TDBCheckBox
    Left = 238
    Top = 60
    Width = 203
    Height = 17
    Caption = #1053#1091#1078#1085#1072' '#1087#1086#1076#1087#1080#1089#1100' '#1087#1088#1091#1092#1086#1074
    DataField = 'SignProof'
    TabOrder = 6
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object cbSignManager: TDBCheckBox
    Left = 238
    Top = 38
    Width = 203
    Height = 17
    Caption = #1059#1090#1074#1077#1088#1076#1080#1090#1100' '#1084#1072#1082#1077#1090' '#1091' '#1084#1077#1085#1077#1076#1078#1077#1088#1072
    DataField = 'SignManager'
    TabOrder = 5
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object edCustomerPhone: TDBEdit
    Left = 158
    Top = 12
    Width = 284
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'CallCustomerPhone'
    TabOrder = 1
  end
  object edProductFormat: TDBEdit
    Left = 158
    Top = 108
    Width = 145
    Height = 21
    DataField = 'ProductFormat'
    TabOrder = 7
  end
  object edProductPages: TDBEdit
    Left = 384
    Top = 108
    Width = 58
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'ProductPages'
    TabOrder = 8
  end
  object cbIncludeCover: TDBCheckBox
    Left = 314
    Top = 134
    Width = 125
    Height = 17
    Caption = #1042#1082#1083#1102#1095#1072#1103' '#1086#1073#1083#1086#1078#1082#1091
    DataField = 'IncludeCover'
    TabOrder = 9
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object cbHaveProof: TDBCheckBox
    Left = 103
    Top = 82
    Width = 103
    Height = 17
    Caption = #1062#1074#1077#1090#1086#1087#1088#1086#1073#1072
    DataField = 'HaveProof'
    TabOrder = 4
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object mtNotes: TMemTableEh
    FetchAllOnOpen = True
    Params = <>
    DataDriver = ddNotes
    Left = 414
    Top = 72
  end
  object ddNotes: TDataSetDriverEh
    KeyFields = 'OrderNoteID'
    Left = 380
    Top = 72
  end
  object dsNotes: TDataSource
    DataSet = mtNotes
    Left = 348
    Top = 74
  end
end
