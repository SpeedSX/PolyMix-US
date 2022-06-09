inherited ShipmentDocForm: TShipmentDocForm
  Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1086#1090#1088#1091#1079#1082#1080
  ClientHeight = 263
  ClientWidth = 589
  ExplicitWidth = 595
  ExplicitHeight = 295
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel [0]
    Left = 270
    Top = 16
    Width = 43
    Height = 13
    Caption = #1042#1099#1076#1072#1083':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel [1]
    Left = 458
    Top = 16
    Width = 41
    Height = 13
    Anchors = [akTop, akRight]
    Caption = #1055#1088#1080#1085#1103#1083':'
    ExplicitLeft = 406
  end
  object Label8: TLabel [2]
    Left = 12
    Top = 16
    Width = 84
    Height = 13
    Caption = #8470' '#1085#1072#1082#1083#1072#1076#1085#1086#1081':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel [3]
    Left = 132
    Top = 16
    Width = 90
    Height = 13
    Caption = #1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel [4]
    Left = 12
    Top = 68
    Width = 153
    Height = 13
    Caption = #1054#1090#1075#1088#1091#1078#1072#1077#1084#1072#1103' '#1087#1088#1086#1076#1091#1082#1094#1080#1103':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  inherited btOk: TButton
    Left = 413
    Top = 228
    TabOrder = 8
    ExplicitLeft = 413
    ExplicitTop = 228
  end
  inherited btCancel: TButton
    Left = 502
    Top = 228
    TabOrder = 9
    ExplicitLeft = 502
    ExplicitTop = 228
  end
  object edWhoOut: TDBEdit [7]
    Left = 270
    Top = 59
    Width = 117
    Height = 21
    DataField = 'WhoOut'
    TabOrder = 2
    Visible = False
  end
  object edWhoIn: TDBEdit [8]
    Left = 458
    Top = 33
    Width = 119
    Height = 21
    Anchors = [akTop, akRight]
    DataField = 'WhoIn'
    TabOrder = 3
  end
  object edShipDocNum: TDBEdit [9]
    Left = 12
    Top = 33
    Width = 97
    Height = 21
    DataField = 'ShipmentDocNum'
    TabOrder = 0
  end
  object deDateOut: TJvDBDatePickerEdit [10]
    Left = 132
    Top = 33
    Width = 119
    Height = 21
    AllowNoDate = True
    DataField = 'ShipmentDate'
    TabOrder = 1
  end
  object dgShipment: TMyDBGridEh [11]
    Left = 13
    Top = 86
    Width = 562
    Height = 131
    AllowedOperations = [alopInsertEh, alopAppendEh]
    AllowedSelections = [gstNon]
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoFitColWidths = True
    DataGrouping.GroupLevels = <>
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
    ParentFont = False
    ReadOnly = True
    RowDetailPanel.Color = clBtnFace
    RowHeight = 16
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = btEditItemClick
    Columns = <
      item
        EditButtons = <>
        FieldName = 'ItemText'
        Footers = <>
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 317
      end
      item
        EditButtons = <>
        FieldName = 'ID_Number'
        Footers = <>
        Title.Caption = #8470' '#1079#1072#1082#1072#1079#1072
        Width = 75
      end
      item
        EditButtons = <>
        FieldName = 'Quantity'
        Footers = <>
        Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        Width = 76
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object btNewItem: TBitBtn [12]
    Left = 12
    Top = 228
    Width = 88
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 5
    OnClick = btNewItemClick
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
    Margin = 7
    Spacing = 6
  end
  object btEditItem: TBitBtn [13]
    Left = 108
    Top = 228
    Width = 88
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    TabOrder = 6
    OnClick = btEditItemClick
    Glyph.Data = {
      E6010000424DE601000000000000E60000002800000010000000100000000100
      08000000000000010000210B0000210B00002C0000002C00000000000000FFFF
      FF0007035A007B645A003E3935002D2C2A00FEFEFC00F2F2F000EDEDEB00FBFB
      FA00F8F8F700F7F7F600E7E7E600E2E2E10006A11C00108E230006731C00118F
      2A0018AB440058CA840000808000374546003A5C600097E7FB008286870015C4
      FB000C84B10001A5E6000B3B5400165E8200909293001F92F20080A6CB003187
      E7002A407B006E88D8002D44B4006F7FD500111B8300D7D7D700D1D1D100C5C5
      C500BABABA001919190014141414141414141414141414141414141818181818
      181818181818181814141E0606060606090B07080C0D272918141E0606060606
      06090B07080C0D2718141E0606062B042806090B07080C0D18141E06282A0405
      152806090B07080C18141E06060606161A1C2206090B070818141E06282A2A16
      1D031A222A2A2A0718141E060606060620191B1A2206060A18141E0606060606
      2017191B1A22060618141E1010101010102017191B1A221018140E130E0E0E0E
      0E0E2017191B1A221414140E131212111414142017191F26021414140E0E0F14
      1414141420212424260214141414141414141414142423252414141414141414
      14141414141424241414}
    Margin = 7
    Spacing = 6
  end
  object btDelItem: TBitBtn [14]
    Left = 204
    Top = 228
    Width = 88
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 7
    OnClick = btDelItemClick
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
    Margin = 7
    Spacing = 6
  end
  object cbWhoOut: TDBComboBoxEh [15]
    Left = 270
    Top = 33
    Width = 171
    Height = 21
    DataField = 'WhoOutUserId'
    EditButtons = <>
    TabOrder = 10
    Visible = True
  end
  inherited FormStorage: TJvFormStorage
    AppStoragePath = 'ShipmentDocForm\'
    Left = 484
    Top = 10
  end
end
