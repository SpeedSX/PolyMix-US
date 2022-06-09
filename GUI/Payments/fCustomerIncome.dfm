object CustomerIncomeForm: TCustomerIncomeForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1086#1089#1090#1091#1087#1083#1077#1085#1080#1077' '#1086#1090' '#1079#1072#1082#1072#1079#1095#1080#1082#1072
  ClientHeight = 362
  ClientWidth = 351
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    351
    362)
  PixelsPerInch = 96
  TextHeight = 13
  object btOk: TButton
    Left = 184
    Top = 329
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object btCancel: TButton
    Left = 268
    Top = 329
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object pcIncomeProps: TPageControl
    Left = 8
    Top = 8
    Width = 336
    Height = 314
    ActivePage = TabSheet2
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
      object Label1: TLabel
        Left = 12
        Top = 11
        Width = 30
        Height = 13
        Caption = #1044#1072#1090#1072':'
      end
      object Label2: TLabel
        Left = 12
        Top = 43
        Width = 64
        Height = 13
        Caption = #1042#1080#1076' '#1086#1087#1083#1072#1090#1099':'
      end
      object Label3: TLabel
        Left = 12
        Top = 76
        Width = 59
        Height = 13
        Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085':'
      end
      object Label4: TLabel
        Left = 12
        Top = 208
        Width = 65
        Height = 13
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103':'
      end
      object Label5: TLabel
        Left = 12
        Top = 143
        Width = 68
        Height = 13
        Caption = #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082':'
      end
      object Label6: TLabel
        Left = 12
        Top = 176
        Width = 67
        Height = 13
        Caption = #1053#1086#1084#1077#1088' '#1089#1095#1077#1090#1072':'
      end
      object Label7: TLabel
        Left = 12
        Top = 109
        Width = 83
        Height = 13
        Caption = #1050#1086#1088#1088#1077#1082#1094#1080#1103', '#1075#1088#1085':'
      end
      object deDate: TJvDBDateEdit
        Left = 100
        Top = 8
        Width = 121
        Height = 21
        DataField = 'IncomeDate'
        DialogTitle = #1042#1099#1073#1077#1088#1080#1090#1077' '#1076#1072#1090#1091
        TabOrder = 0
      end
      object comboPayKind: TJvDBLookupCombo
        Left = 100
        Top = 40
        Width = 121
        Height = 21
        DataField = 'PayType'
        LookupField = 'Code'
        LookupDisplay = 'Name'
        LookupSource = dsPayType
        TabOrder = 1
      end
      object edIncomeCost: TDBEdit
        Left = 100
        Top = 73
        Width = 121
        Height = 21
        DataField = 'IncomeGrn'
        TabOrder = 2
      end
      object Memo1: TMemo
        Left = 100
        Top = 209
        Width = 213
        Height = 67
        TabOrder = 3
      end
      object comboCustomer: TDBLookupComboboxEh
        Left = 100
        Top = 140
        Width = 215
        Height = 21
        DataField = 'CustomerID'
        DropDownBox.AutoFitColWidths = False
        DropDownBox.Columns = <
          item
            FieldName = 'Name'
            Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077'/'#1048#1084#1103
            Width = 303
          end>
        DropDownBox.Options = [dlgColumnResizeEh, dlgColLinesEh]
        DropDownBox.AutoDrop = True
        DropDownBox.Rows = 20
        DropDownBox.ShowTitles = True
        DropDownBox.Sizable = True
        EditButtons = <>
        KeyField = 'N'
        ListField = 'Name'
        ListSource = dsCust
        TabOrder = 4
        Visible = True
      end
      object edInvoiceNum: TDBEdit
        Left = 100
        Top = 174
        Width = 121
        Height = 21
        DataField = 'InvoiceNum'
        TabOrder = 5
      end
      object edReturnCost: TDBEdit
        Left = 100
        Top = 106
        Width = 121
        Height = 21
        DataField = 'ReturnCost'
        TabOrder = 6
      end
      object btRestIncome: TBitBtn
        Left = 228
        Top = 104
        Width = 87
        Height = 25
        Caption = #1055#1077#1088#1077#1087#1083#1072#1090#1072
        TabOrder = 7
        OnClick = btRestIncomeClick
        Glyph.Data = {
          42020000424D4202000000000000420000002800000010000000100000000100
          10000300000000020000120B0000120B00000000000000000000007C0000E003
          00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C9646F42D1F7C1F7C1F7C1F7C1F7C
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CD952D61DD61D1F7C1F7C1F7C1F7C1F7C
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1B53F61DFF12F61D1F7C1F7C1F7C1F7C1F7C
          1F7C1F7C1F7C1F7C1F7C1F7C1B57F7211F1FFF0EF7211F7C1F7C1F7C1F7C1F7C
          1F7C1F7C1F7C1F7C1F7C1C5717221E2BBE0ADE16172217221722172217221722
          1722993A1F7C1F7C3C5738265E47BD2E9C1E9C1EBC22BC22BC22BC22BC1E9C1E
          BC2238261F7C1F7C59267F47DD32DD32DD32BC329B2A7A265A22592259225A22
          BB2E59261F7C1F7C3D5B7A2A7F4BDD36DD36FD3A1E3F1E3F1E3F1E3B1E3B1E3B
          1E3F7A2A1F7C1F7C1F7C5D5B7B2E7F4BFE3A3E437B2E7B2E7B2E7B2E7B2E7B2E
          7B2EDC421F7C1F7C1F7C1F7C5D5B9B2E9F4B5F479B2E1F7C1F7C1F7C1F7C1F7C
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C5E5BBC329F4FBC321F7C1F7C1F7C1F7C1F7C
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C7E5BBC32BC321F7C1F7C1F7C1F7C1F7C
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C7E5F1D471F7C1F7C1F7C1F7C1F7C
          1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
          1F7C1F7C1F7C}
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1054#1087#1083#1072#1090#1099' '#1079#1072#1082#1072#1079#1086#1074
      ImageIndex = 1
      object dgPayments: TMyDBGridEh
        Left = 0
        Top = 0
        Width = 328
        Height = 250
        Align = alClient
        AllowedOperations = [alopAppendEh]
        AllowedSelections = [gstNon]
        ColumnDefValues.Layout = tlCenter
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
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghDialogFind, dghColumnResize, dghColumnMove]
        ParentFont = False
        ReadOnly = True
        RowDetailPanel.Color = clBtnFace
        RowHeight = 17
        RowSizingAllowed = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            EditButtons = <>
            FieldName = 'PayDate'
            Footers = <>
            Title.Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
            Width = 93
          end
          item
            EditButtons = <>
            FieldName = 'PayCost'
            Footers = <>
            Title.Caption = #1054#1087#1083#1072#1095#1077#1085#1086', '#1075#1088#1085
            Width = 84
          end
          item
            EditButtons = <>
            FieldName = 'ID_Number'
            Footers = <>
            Title.Caption = #8470' '#1079#1072#1082#1072#1079#1072
            Width = 75
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 250
        Width = 328
        Height = 36
        Align = alBottom
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 1
        object btDelete: TButton
          Left = 0
          Top = 6
          Width = 75
          Height = 25
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 0
          OnClick = btDeleteClick
        end
      end
    end
  end
  object dsPayType: TDataSource
    Left = 232
    Top = 12
  end
  object dsCust: TDataSource
    Left = 248
    Top = 68
  end
end
