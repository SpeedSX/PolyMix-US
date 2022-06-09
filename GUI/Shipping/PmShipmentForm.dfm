inherited ShipmentForm: TShipmentForm
  BorderIcons = [biSystemMenu]
  Caption = #1054#1090#1075#1088#1091#1079#1082#1072
  ClientHeight = 211
  ClientWidth = 448
  Constraints.MinHeight = 240
  Constraints.MinWidth = 292
  ExplicitWidth = 454
  ExplicitHeight = 243
  PixelsPerInch = 96
  TextHeight = 13
  object lbTirazz: TLabel [0]
    Left = 298
    Top = 132
    Width = 36
    Height = 13
    Caption = #1058#1080#1088#1072#1078':'
  end
  object Label11: TLabel [1]
    Left = 12
    Top = 60
    Width = 77
    Height = 13
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
  end
  object lbOrder: TLabel [2]
    Left = 14
    Top = 8
    Width = 33
    Height = 13
    Caption = #1047#1072#1082#1072#1079':'
  end
  inherited btOk: TButton
    Left = 276
    Top = 175
    TabOrder = 6
    ExplicitLeft = 276
    ExplicitTop = 175
  end
  inherited btCancel: TButton
    Left = 363
    Top = 175
    TabOrder = 7
    ExplicitLeft = 363
    ExplicitTop = 175
  end
  object edTirazz: TDBEdit [5]
    Left = 342
    Top = 129
    Width = 93
    Height = 21
    DataField = 'Tirazz'
    Enabled = False
    ReadOnly = True
    TabOrder = 5
  end
  object GroupBox1: TGroupBox [6]
    Left = 10
    Top = 108
    Width = 267
    Height = 53
    Caption = ' '#1054#1090#1088#1091#1078#1072#1077#1084#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '
    TabOrder = 4
    object Label6: TLabel
      Left = 144
      Top = 23
      Width = 35
      Height = 13
      Caption = #1055#1072#1095#1077#1082':'
    end
    object Label5: TLabel
      Left = 12
      Top = 23
      Width = 41
      Height = 13
      Caption = #1045#1076#1080#1085#1080#1094':'
    end
    object edBatchNum: TDBEdit
      Left = 184
      Top = 20
      Width = 73
      Height = 21
      DataField = 'BatchNum'
      TabOrder = 0
    end
    object edNOut: TDBEdit
      Left = 58
      Top = 20
      Width = 73
      Height = 21
      DataField = 'Quantity'
      TabOrder = 1
    end
  end
  object edItemText: TDBEdit [7]
    Left = 12
    Top = 77
    Width = 423
    Height = 21
    DataField = 'ItemText'
    TabOrder = 3
  end
  object comboOrder: TDBLookupComboboxEh [8]
    Left = 12
    Top = 25
    Width = 425
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
  object cbNotShippedOnly: TCheckBox [9]
    Left = 196
    Top = 50
    Width = 139
    Height = 17
    Caption = #1058#1086#1083#1100#1082#1086' '#1085#1077#1086#1090#1075#1088#1091#1078#1077#1085#1085#1099#1077
    TabOrder = 1
    OnClick = cbNotShippedOnlyClick
  end
  object cbAllCustomers: TCheckBox [10]
    Left = 343
    Top = 50
    Width = 93
    Height = 17
    Caption = #1042#1089#1077' '#1079#1072#1082#1072#1079#1095#1080#1082#1080
    TabOrder = 2
    OnClick = cbAllCustomersClick
  end
  inherited FormStorage: TJvFormStorage
    AppStoragePath = 'ShipmentForm\'
    Left = 12
    Top = 270
  end
end
