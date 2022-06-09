inherited InvoiceItemForm: TInvoiceItemForm
  Caption = #1055#1086#1079#1080#1094#1080#1103' '#1089#1095#1077#1090'-'#1092#1072#1082#1090#1091#1088#1099
  ClientHeight = 288
  OnActivate = FormActivate
  OnCreate = FormCreate
  ExplicitHeight = 320
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 12
    Top = 8
    Width = 33
    Height = 13
    Caption = #1047#1072#1082#1072#1079':'
  end
  object Label3: TLabel [1]
    Left = 12
    Top = 202
    Width = 64
    Height = 13
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086':'
  end
  object Label4: TLabel [2]
    Left = 156
    Top = 202
    Width = 58
    Height = 13
    Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100':'
  end
  object Label5: TLabel [3]
    Left = 295
    Top = 202
    Width = 64
    Height = 13
    Caption = #1062#1077#1085#1072' '#1079#1072' '#1077#1076'.:'
  end
  object dtPrice: TDBText [4]
    Left = 295
    Top = 222
    Width = 164
    Height = 17
    DataField = 'Price'
  end
  inherited btOk: TButton
    Top = 253
    TabOrder = 7
    ExplicitTop = 253
  end
  inherited btCancel: TButton
    Top = 253
    TabOrder = 8
    ExplicitTop = 253
  end
  object comboOrder: TDBLookupComboboxEh [7]
    Left = 12
    Top = 27
    Width = 447
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'OrderID'
    DropDownBox.AutoFitColWidths = False
    DropDownBox.Columns = <
      item
        FieldName = 'OrderNumber'
        Title.Caption = #1053#1086#1084#1077#1088
        Width = 50
      end
      item
        EndEllipsis = True
        FieldName = 'Comment'
        Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        Width = 180
      end
      item
        Alignment = taRightJustify
        FieldName = 'FinalCostGrn'
        Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
        Width = 90
      end
      item
        FieldName = 'Tirazz'
        Title.Caption = #1058#1080#1088#1072#1078
      end
      item
        Alignment = taCenter
        FieldName = 'CreationDate'
        Title.Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
        Width = 92
      end
      item
        FieldName = 'CreatorName'
        Title.Caption = #1052#1077#1085#1077#1076#1078#1077#1088
        Width = 94
      end>
    DropDownBox.Options = [dlgColumnResizeEh, dlgColLinesEh]
    DropDownBox.AutoDrop = True
    DropDownBox.Rows = 20
    DropDownBox.ShowTitles = True
    DropDownBox.Sizable = True
    EditButtons = <>
    KeyField = 'N'
    ListField = 'Description'
    TabOrder = 0
    Visible = True
    OnChange = comboOrderChange
  end
  object edQuantity: TDBEdit [8]
    Left = 12
    Top = 220
    Width = 121
    Height = 21
    DataField = 'Quantity'
    TabOrder = 5
  end
  object edItemCost: TDBEdit [9]
    Left = 156
    Top = 220
    Width = 121
    Height = 21
    DataField = 'ItemCost'
    TabOrder = 6
  end
  object cbNotPaidOnly: TCheckBox [10]
    Left = 222
    Top = 52
    Width = 139
    Height = 17
    Caption = #1058#1086#1083#1100#1082#1086' '#1085#1077#1086#1087#1083#1072#1095#1077#1085#1085#1099#1077
    TabOrder = 1
    OnClick = cbNotPaidOnlyClick
  end
  object cbAllCustomers: TCheckBox [11]
    Left = 368
    Top = 52
    Width = 93
    Height = 17
    Caption = #1042#1089#1077' '#1079#1072#1082#1072#1079#1095#1080#1082#1080
    TabOrder = 2
    OnClick = cbAllCustomersClick
  end
  object GroupBox1: TGroupBox [12]
    Left = 12
    Top = 72
    Width = 447
    Height = 121
    Caption = ' '#1055#1088#1086#1076#1091#1082#1094#1080#1103' '
    TabOrder = 4
    DesignSize = (
      447
      121)
    object edItemText: TDBEdit
      Left = 26
      Top = 39
      Width = 407
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      DataField = 'ItemText'
      TabOrder = 0
    end
    object rbItemText: TRadioButton
      Left = 8
      Top = 20
      Width = 113
      Height = 17
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      TabOrder = 1
      OnClick = rbItemCodeClick
    end
    object rbItemCode: TRadioButton
      Left = 8
      Top = 70
      Width = 113
      Height = 17
      Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
      TabOrder = 2
      OnClick = rbItemCodeClick
    end
    object comboProducts: TDBLookupComboboxEh
      Left = 26
      Top = 89
      Width = 407
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      DataField = 'ExternalProductID'
      DropDownBox.Options = [dlgColumnResizeEh, dlgColLinesEh]
      DropDownBox.AutoDrop = True
      DropDownBox.Rows = 20
      DropDownBox.ShowTitles = True
      DropDownBox.Sizable = True
      EditButtons = <>
      KeyField = 'Code'
      ListField = 'Name'
      ListSource = dsProducts
      TabOrder = 3
      Visible = True
      OnChange = comboProductsChange
    end
  end
  object cbNotInvoicedOnly: TCheckBox [13]
    Left = 94
    Top = 52
    Width = 112
    Height = 17
    Caption = #1058#1086#1083#1100#1082#1086' '#1073#1077#1079' '#1089#1095#1077#1090#1072
    TabOrder = 3
    OnClick = cbNotInvoicedOnlyClick
  end
  object dsProducts: TDataSource
    Left = 240
    Top = 252
  end
end
