inherited InvoiceForm: TInvoiceForm
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSizeable
  Caption = #1057#1095#1077#1090'-'#1092#1072#1082#1090#1091#1088#1072
  ClientHeight = 336
  ClientWidth = 604
  Constraints.MinHeight = 278
  Constraints.MinWidth = 612
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 612
  ExplicitHeight = 370
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 14
    Top = 12
    Width = 40
    Height = 13
    Caption = #1053#1086#1084#1077#1088':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel [1]
    Left = 178
    Top = 12
    Width = 34
    Height = 13
    Caption = #1044#1072#1090#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel [2]
    Left = 14
    Top = 60
    Width = 76
    Height = 13
    Caption = #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btNewCust: TSpeedButton [3]
    Left = 483
    Top = 75
    Width = 110
    Height = 25
    Hint = #1042#1099#1073#1088#1072#1090#1100' '#1079#1072#1082#1072#1079#1095#1080#1082#1072
    Anchors = [akTop, akRight]
    Caption = #1042#1099#1073#1088#1072#1090#1100'...'
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
    ExplicitLeft = 484
  end
  object Label5: TLabel [4]
    Left = 288
    Top = 12
    Width = 73
    Height = 13
    Caption = #1042#1080#1076' '#1086#1087#1083#1072#1090#1099':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel [5]
    Left = 14
    Top = 106
    Width = 65
    Height = 13
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103':'
  end
  object Label6: TLabel [6]
    Left = 14
    Top = 160
    Width = 50
    Height = 13
    Caption = #1055#1086#1079#1080#1094#1080#1080':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel [7]
    Left = 484
    Top = 12
    Width = 59
    Height = 13
    Caption = #1057#1086#1079#1076#1072#1090#1077#1083#1100':'
  end
  object memoNotes: TDBMemo [8]
    Left = 14
    Top = 123
    Width = 579
    Height = 32
    DataField = 'Notes'
    TabOrder = 5
  end
  inherited btOk: TButton
    Left = 432
    Top = 300
    TabOrder = 11
    ExplicitLeft = 432
    ExplicitTop = 300
  end
  inherited btCancel: TButton
    Left = 519
    Top = 300
    TabOrder = 12
    ExplicitLeft = 519
    ExplicitTop = 300
  end
  object edInvoiceNum: TDBEdit [11]
    Left = 14
    Top = 29
    Width = 147
    Height = 21
    DataField = 'InvoiceNum'
    TabOrder = 0
  end
  object deInvoiceDate: TJvDBDatePickerEdit [12]
    Left = 178
    Top = 29
    Width = 95
    Height = 21
    AllowNoDate = True
    DataField = 'InvoiceDate'
    TabOrder = 1
  end
  object lkCustomer: TJvDBLookupCombo [13]
    Left = 14
    Top = 77
    Width = 460
    Height = 21
    DataField = 'ContragentID'
    DisplayEmpty = '<'#1053#1077' '#1091#1082#1072#1079#1072#1085'>'
    Anchors = [akLeft, akTop, akRight]
    LookupField = 'N'
    LookupDisplay = 'Name;Phone'
    LookupSource = dsCust
    TabOrder = 4
  end
  object lkPayType: TJvDBLookupCombo [14]
    Left = 288
    Top = 29
    Width = 185
    Height = 21
    DataField = 'PayType'
    DisplayEmpty = '<'#1053#1077' '#1091#1082#1072#1079#1072#1085'>'
    LookupField = 'Code'
    LookupDisplay = 'Name'
    LookupSource = dsPayType
    TabOrder = 2
  end
  object dgInvoiceItems: TMyDBGridEh [15]
    Left = 15
    Top = 178
    Width = 576
    Height = 109
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
    FooterColor = clInfoBk
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    FooterRowCount = 1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
    ParentFont = False
    ReadOnly = True
    RowDetailPanel.Color = clBtnFace
    RowHeight = 16
    SumList.Active = True
    TabOrder = 6
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
        Width = 187
      end
      item
        EditButtons = <>
        FieldName = 'OrderNumText'
        Footers = <>
        Title.Caption = #8470' '#1079#1072#1082#1072#1079#1072
        Width = 54
      end
      item
        EditButtons = <>
        FieldName = 'Quantity'
        Footers = <>
        Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        Width = 63
      end
      item
        EditButtons = <>
        FieldName = 'Price'
        Footers = <>
        Title.Caption = #1047#1072' '#1077#1076'., '#1075#1088#1085
        Width = 65
      end
      item
        EditButtons = <>
        FieldName = 'ItemCost'
        Footer.FieldName = 'ItemCost'
        Footer.ValueType = fvtSum
        Footers = <>
        Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100', '#1075#1088#1085
        Width = 90
      end
      item
        EditButtons = <>
        FieldName = 'PayCost'
        Footers = <>
        Title.Caption = #1054#1087#1083#1072#1095#1077#1085#1086', '#1075#1088#1085
        Width = 80
      end
      item
        EditButtons = <>
        FieldName = 'ItemDebt'
        Footers = <>
        Title.Caption = #1044#1086#1083#1075', '#1075#1088#1085
        Visible = False
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object btNewItem: TBitBtn [16]
    Left = 14
    Top = 300
    Width = 88
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 7
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
  object btEditItem: TBitBtn [17]
    Left = 110
    Top = 300
    Width = 88
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    TabOrder = 8
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
  object btDelItem: TBitBtn [18]
    Left = 206
    Top = 300
    Width = 88
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 9
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
  object edUserName: TDBEdit [19]
    Left = 484
    Top = 29
    Width = 110
    Height = 21
    Color = clBtnFace
    DataField = 'UserName'
    ReadOnly = True
    TabOrder = 3
  end
  object btPayItem: TBitBtn [20]
    Left = 312
    Top = 276
    Width = 88
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1054#1087#1083#1072#1090#1080#1090#1100
    ModalResult = 1
    TabOrder = 10
    Visible = False
    OnClick = btPayItemClick
    Glyph.Data = {
      A6020000424DA602000000000000A60100002800000010000000100000000100
      08000000000000010000120B0000120B00005C0000005C00000000000000FFFF
      FF00FF00FF00AFAF9B00A2A2900099998800B2B2A100C3C3B200BFBFAE00CFCF
      BE00C7C7B600D6D6C500D5D5C400D3D3C200D0D0BF00CBCBBB00DDDDCC00DBDB
      CA00D8D8C800F9F9E900F3F3E300EFEFE000E9E9DA00F4F4E600EBEBDE00E5E5
      D800B2B2A800F5F5E800B1B1A800F7F7EC00EEEEE300F8F8EF00F1F1E800F5F5
      EE00FAFAF400FCFCF700F8F8F300FBFBF700FDFDFA00FDFDFB00FEFEFD00B8B9
      9700748045008C9765006F9C6C003E7E4600287E38001F7C3C00037127001178
      3300127733002E874B004F98670003742A00068132001C7A3C003F8457004C8A
      6100047E3000067E320009883A0009893D000A8D4100099B49000A9A48000CA3
      50000C9448000BAE58000BA854000CA352000C9C4F000DB45E000CA657000FAE
      5D000FA85A0010BC680013C46E0013BF6B0014C16F0016D6820019DC8B001CDE
      8F001BED9A001EF5A30020FEAC001FF0A10028FFB30031FFB7003EFFC50048FF
      C900E5E5E500FFFFFF0002020202020202020230303002020202020202020202
      0230303A413630380202020202020202304044434343403B39021A04041C5A2E
      3D4B4B4848474B4B3D3706131403052935453B2930404C4C4930081716151715
      511616163F4C4F4F4532071B181818181818303F4E504C4030070A1D1E1E1E1E
      30484E524D3E2F1E1D0A0F1F2020202B3C51533C302020201F0F09222121212A
      425656554A304A5122090D23242424243055575757575757330E0B2625252525
      253046555854514A310D12282727272727272C3059463134270C110101010101
      0101012C302D0101010B19101010101010101010101010101010020202020202
      02020202020202020202}
    Margin = 7
    Spacing = 6
  end
  inherited FormStorage: TJvFormStorage
    AppStoragePath = 'InvoiceForm\'
    Left = 402
    Top = 10
  end
  object dsPayType: TDataSource
    Left = 366
    Top = 8
  end
  object dsCust: TDataSource
    Left = 376
    Top = 50
  end
end
