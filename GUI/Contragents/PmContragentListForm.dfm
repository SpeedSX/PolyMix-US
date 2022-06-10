object ContragentListForm: TContragentListForm
  Left = 187
  Top = 656
  Caption = #1057#1087#1080#1089#1086#1082' '#1079#1072#1082#1072#1079#1095#1080#1082#1086#1074
  ClientHeight = 352
  ClientWidth = 792
  Color = clBtnFace
  Constraints.MinHeight = 163
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 792
    Height = 51
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lbFilt: TLabel
      Left = 4
      Top = 8
      Width = 46
      Height = 13
      Caption = #1060#1080#1083#1100#1090#1088':'
      FocusControl = edName
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 72
      Top = 8
      Width = 23
      Height = 13
      Caption = #1048#1084#1103':'
    end
    object Bevel1: TBevel
      Left = 60
      Top = 8
      Width = 13
      Height = 37
      Shape = bsLeftLine
    end
    object lbFilter: TLabel
      Left = 596
      Top = 8
      Width = 40
      Height = 13
      Caption = #1057#1090#1072#1090#1091#1089':'
    end
    object Label4: TLabel
      Left = 236
      Top = 8
      Width = 58
      Height = 13
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103':'
    end
    object lbContrType: TLabel
      Left = 415
      Top = 8
      Width = 98
      Height = 13
      Caption = #1042#1080#1076' '#1076#1077#1103#1090#1077#1083#1100#1085#1086#1089#1090#1080':'
    end
    object edName: TEdit
      Left = 70
      Top = 24
      Width = 153
      Height = 21
      TabOrder = 0
      OnChange = edNameChange
      OnKeyPress = edNameKeyPress
    end
    object cbbFilter: TComboBox
      Left = 596
      Top = 24
      Width = 189
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      TabOrder = 3
      OnChange = edNameChange
    end
    object cbbCat: TComboBox
      Left = 234
      Top = 24
      Width = 171
      Height = 21
      Style = csDropDownList
      DropDownCount = 25
      ItemHeight = 13
      TabOrder = 1
      OnChange = cbbCatChange
    end
    object cbbActivity: TComboBox
      Left = 414
      Top = 24
      Width = 171
      Height = 21
      Style = csDropDownList
      DropDownCount = 25
      ItemHeight = 13
      TabOrder = 2
      OnChange = edNameChange
    end
    object cbbActivityEh: TDBLookupComboboxEh
      Left = 414
      Top = 34
      Width = 171
      Height = 21
      EditButtons = <>
      ListSource = dsActivity
      TabOrder = 4
      Visible = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 312
    Width = 792
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object InsertBtn: TSpeedButton
      Left = 3
      Top = 6
      Width = 91
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100'...'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777777777777777777777777777777777777000777777777777700077
        7777777777700077777777770000000007777777000000000777777700000000
        0777777777700077777777777770007777777777777000777777777777777777
        7777777777777777777777777777777777777777777777777777}
      Spacing = 5
      OnClick = InsertBtnClick
    end
    object EditBtn: TSpeedButton
      Left = 105
      Top = 6
      Width = 87
      Height = 25
      Caption = #1057#1074#1086#1081#1089#1090#1074#1072'...'
      NumGlyphs = 2
      Spacing = 5
      OnClick = EditBtnClick
    end
    object DeleteBtn: TSpeedButton
      Left = 203
      Top = 6
      Width = 89
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000120B0000120B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777777777777777777777777777777777777777777777777777777777
        7777777777777777777777700000000007777770000000000777777000000000
        0777777777777777777777777777777777777777777777777777777777777777
        7777777777777777777777777777777777777777777777777777}
      Spacing = 5
      OnClick = DeleteBtnClick
    end
    object Panel4: TPanel
      Left = 575
      Top = 0
      Width = 217
      Height = 40
      Align = alRight
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 0
      object CancelBtn: TSpeedButton
        Left = 124
        Top = 7
        Width = 85
        Height = 25
        Caption = #1054#1090#1084#1077#1085#1072
        NumGlyphs = 2
        Spacing = 5
        OnClick = CancelBtnClick
      end
      object Label2: TLabel
        Left = 5
        Top = -4
        Width = 140
        Height = 13
        Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1084#1077#1085#1103#1077#1090#1089#1103' '#1074' '#1082#1086#1076#1077
        Visible = False
      end
      object OkBtn: TButton
        Left = 18
        Top = 7
        Width = 95
        Height = 25
        Caption = #1054#1050
        ModalResult = 1
        TabOrder = 0
        OnClick = OkBtnClick
      end
    end
    object btActions: TButton
      Left = 305
      Top = 6
      Width = 89
      Height = 25
      Caption = #1044#1077#1081#1089#1090#1074#1080#1103' >>'
      TabOrder = 1
      OnClick = btActionsClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 51
    Width = 792
    Height = 261
    Align = alClient
    BevelOuter = bvNone
    BevelWidth = 10
    BorderWidth = 5
    Caption = 'Panel3'
    TabOrder = 2
    object dgCust: TMyDBGridEh
      Left = 5
      Top = 5
      Width = 782
      Height = 251
      Align = alClient
      AllowedOperations = []
      AllowedSelections = [gstRecordBookmarks]
      ColumnDefValues.Layout = tlCenter
      ColumnDefValues.Title.TitleButton = True
      DataGrouping.GroupLevels = <>
      DataSource = dsCust
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'Tahoma'
      FooterFont.Style = []
      Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghIncSearch, dghRowHighlight, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
      RowDetailPanel.Color = clBtnFace
      RowHeight = 17
      SortLocal = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = dgCustDblClick
      OnGetCellParams = dgCustGetCellParams
      OnKeyPress = dgGridKeyPress
      IniStorage = FormStorage
      Columns = <
        item
          EditButtons = <>
          FieldName = 'IsWork'
          Footers = <>
          Title.Caption = ' '
          Width = 23
        end
        item
          EditButtons = <>
          FieldName = 'Name'
          Footers = <>
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Width = 203
        end
        item
          EditButtons = <>
          FieldName = 'Phone'
          Footers = <>
          Title.Caption = #1058#1077#1083#1077#1092#1086#1085
          Width = 100
        end
        item
          EditButtons = <>
          FieldName = 'Fax'
          Footers = <>
          Title.Caption = #1060#1072#1082#1089
          Width = 84
        end
        item
          EditButtons = <>
          FieldName = 'FirstPersonName'
          Footers = <>
          Title.Caption = #1055#1088#1077#1076#1089#1090#1072#1074#1080#1090#1077#1083#1100
          Width = 110
        end
        item
          EditButtons = <>
          FieldName = 'Address'
          Footers = <>
          Title.Caption = #1040#1076#1088#1077#1089
          Width = 112
        end
        item
          EditButtons = <>
          FieldName = 'FullName'
          Footers = <>
          Title.Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Width = 165
        end
        item
          EditButtons = <>
          FieldName = 'BriefNote'
          Footers = <>
          Title.Caption = #1044#1086#1087'. '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103
        end
        item
          EditButtons = <>
          FieldName = 'StatusName'
          Footers = <>
          Title.Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
          Width = 63
        end
        item
          EditButtons = <>
          FieldName = 'ActivityName'
          Footers = <>
          Title.Caption = #1042#1080#1076' '#1076#1077#1103#1090#1077#1083#1100#1085#1086#1089#1090#1080
          Width = 104
        end
        item
          EditButtons = <>
          FieldName = 'CreationDate'
          Footers = <>
          Title.Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
          Width = 81
        end
        item
          EditButtons = <>
          FieldName = 'CreatorName'
          Footers = <>
          Title.Caption = #1052#1077#1085#1077#1076#1078#1077#1088
          Title.TitleButton = False
        end
        item
          EditButtons = <>
          FieldName = 'N'
          Footers = <>
          Title.Caption = #1050#1086#1076
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object dsCust: TDataSource
    Left = 248
    Top = 68
  end
  object FormStorage: TJvFormStorage
    AppStoragePath = 'Customers\'
    StoredValues = <>
    Left = 212
    Top = 65
  end
  object pmActions: TPopupMenu
    Left = 400
    Top = 320
    object miMerge: TMenuItem
      Action = acMerge
    end
    object miHistory: TMenuItem
      Action = acHistory
    end
  end
  object acContragent: TActionList
    Left = 480
    Top = 72
    object acMerge: TAction
      Caption = #1054#1073#1098#1077#1076#1080#1085#1080#1090#1100'...'
      OnExecute = acMergeExecute
    end
    object acHistory: TAction
      Caption = #1048#1089#1090#1086#1088#1080#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1081'...'
      ImageIndex = 0
      OnExecute = acHistoryExecute
    end
  end
  object imContragent: TImageList
    Left = 440
    Top = 72
    Bitmap = {
      494C010101000300040010001000FFFFFFFFFF00FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006331310063313100633131006331
      3100633131006331310063313100633131000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6840000FFFFDE00FFE7B500FF9C
      0000D6840000CE630000CE63000063313100A24F2200A24F2200A24F2200A24F
      2200A24F2200A24F2200A24F2200A24F22000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D6840000D6840000D684
      0000D6840000D684000063313100DE9C8400E7E7E700E7E7E700E7E7E700E7E7
      E700E7E7E700E7E7E700E7E7E700A24F22000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D6840000FFFFFF006331
      3100633131009C9C9C0063313100DE9C8400E7E7E700EFBD7B00EFBD7B00EFEF
      EE00C9C9C900C9C9C900E7E7E700A24F22000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D6840000FFFFFF00FF9C
      0000D68400009C9C9C0063313100DE9C8400E7E7E700F7D6B500DE9C3900F3F3
      F200EFEFEE00EBEBEA00E7E7E700A24F22000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6840000E7E7
      E700C6C6C60063313100D6C6BD00DE9C8400E7E7E700EFBD7B00EFBD7B00F7F7
      F600C9C9C900C9C9C900E7E7E700A24F22000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C9762B00D684
      000063313100FEFEFD00F7E7DE00DE9C8400E7E7E700F7D6B500DE9C3900FAFA
      F900F7F7F600F3F3F200E7E7E700A24F22000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6840000E7E7
      E7006331310063313100D6C6BD00DE9C8400E7E7E700EFBD7B00EFBD7B00FEFE
      FD00C9C9C900C9C9C900E7E7E700A24F22000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D6840000FFFFFF00FF9C
      0000633131009C9C9C0063313100DE9C8400E7E7E700F7D6B500DE9C3900FEFE
      FD00FEFEFD00FCFCFB00E7E7E700A24F22000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D6840000FFFFFF00E7E7
      E700C6C6C6009C9C9C0063313100DE9C8400E7E7E700EFBD7B00EFBD7B00FEFE
      FD00C9C9C900C9C9C900E7E7E700A24F22000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000063313100633131006331
      3100633131006331310063313100DE9C8400E7E7E700F7D6B500DE9C3900FEFE
      FD00FEFEFD00FEFEFD00E7E7E700A24F22000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6840000FFFFDE00FFE7B500FF9C
      0000D6840000CE630000CE63000063313100E7E7E700E7E7E700E7E7E700E7E7
      E700E7E7E700E7E7E700E7E7E700A24F22000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6840000D6840000D6840000D684
      0000D6840000D6840000D684000063313100D06F0100D06F0100D06F0100D06F
      0100D06F0100D06F0100D06F0100A24F22000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CE630000ED97
      3300ED973300ED973300ED973300ED973300ED973300F6CA9A00ED973300F6CA
      9A00ED973300306DF9007F748800CE6300000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DA7B
      0D00DA7B0D00DA7B0D00DA7B0D00DA7B0D00DA7B0D00DA7B0D00DA7B0D00DA7B
      0D00DA7B0D00DA7B0D00DA7B0D00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF00000000000000FF000000000000
      0000000000000000800000000000000080000000000000008000000000000000
      C000000000000000C000000000000000C0000000000000008000000000000000
      8000000000000000800000000000000000000000000000000000000000000000
      C000000000000000E001000000000000}
  end
  object pmContragentType: TPopupMenu
    Left = 438
    Top = 318
    object miNewContractor: TMenuItem
      Caption = #1055#1086#1076#1088#1103#1076#1095#1080#1082'...'
      OnClick = miNewContractorClick
    end
    object miNewSupplier: TMenuItem
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082'...'
      OnClick = miNewSupplierClick
    end
  end
  object dsActivity: TDataSource
    Left = 542
    Top = 8
  end
end