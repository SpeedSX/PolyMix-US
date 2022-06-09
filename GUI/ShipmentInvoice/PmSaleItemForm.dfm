inherited SaleItemForm: TSaleItemForm
  Caption = #1056#1077#1072#1083#1080#1079#1072#1094#1080#1103
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited Label1: TLabel
    Width = 33
    Caption = #1047#1072#1082#1072#1079':'
    ExplicitWidth = 33
  end
  inherited Label2: TLabel
    Width = 135
    Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072' '#1087#1088#1086#1076#1091#1082#1094#1080#1080':'
    ExplicitWidth = 135
  end
  inherited comboSource: TDBLookupComboboxEh
    DropDownBox.Columns = <
      item
        FieldName = 'OrderNum'
        Title.Caption = #1053#1086#1084#1077#1088
        Width = 50
      end
      item
        EndEllipsis = True
        FieldName = 'ItemText'
        Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        Width = 180
      end
      item
        FieldName = 'Quantity'
        Title.Caption = #1058#1080#1088#1072#1078
      end
      item
        FieldName = 'CreationDate'
        Title.Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
        Width = 92
      end>
  end
  object btSelectProduct: TBitBtn [12]
    Left = 62
    Top = 158
    Width = 85
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1042#1099#1073#1088#1072#1090#1100'...'
    TabOrder = 6
    Visible = False
    OnClick = btSelectProductClick
  end
end
