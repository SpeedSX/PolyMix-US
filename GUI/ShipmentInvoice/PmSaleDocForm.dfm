inherited SaleDocForm: TSaleDocForm
  Caption = #1056#1077#1072#1083#1080#1079#1072#1094#1080#1103
  PixelsPerInch = 96
  TextHeight = 13
  inherited dgItems: TMyDBGridEh
    Height = 107
    Columns = <
      item
        EditButtons = <>
        FieldName = 'ItemText'
        Footers = <>
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 271
      end
      item
        EditButtons = <>
        FieldName = 'OrderNumText'
        Footers = <>
        Title.Caption = #8470' '#1079#1072#1082#1072#1079#1072
        Width = 70
      end
      item
        EditButtons = <>
        FieldName = 'Quantity'
        Footers = <>
        Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        Width = 76
      end
      item
        EditButtons = <>
        FieldName = 'ItemCost'
        Footers = <>
        Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100', '#1075#1088#1085
        Width = 90
      end>
  end
  object GroupBox2: TGroupBox [19]
    Left = 14
    Top = 244
    Width = 577
    Height = 49
    Anchors = [akLeft, akRight, akBottom]
    Caption = ' '#1044#1086#1074#1077#1088#1077#1085#1085#1086#1089#1090#1100' '
    TabOrder = 11
    object Label8: TLabel
      Left = 142
      Top = 23
      Width = 17
      Height = 13
      Caption = #8470':'
    end
    object Label9: TLabel
      Left = 12
      Top = 23
      Width = 35
      Height = 13
      Caption = #1057#1077#1088#1080#1103':'
    end
    object Label10: TLabel
      Left = 258
      Top = 23
      Width = 30
      Height = 13
      Caption = #1044#1072#1090#1072':'
    end
    object edTrustNum: TDBEdit
      Left = 168
      Top = 20
      Width = 73
      Height = 21
      DataField = 'TrustNum'
      TabOrder = 0
    end
    object edTrustSerie: TDBEdit
      Left = 52
      Top = 20
      Width = 73
      Height = 21
      DataField = 'TrustSerie'
      TabOrder = 1
    end
    object deTrustDate: TJvDBDatePickerEdit
      Left = 300
      Top = 19
      Width = 99
      Height = 21
      AllowNoDate = True
      DataField = 'TrustDate'
      TabOrder = 2
    end
  end
  inherited lkPayType: TJvDBLookupCombo
    TabOrder = 12
  end
  inherited dsContragent: TDataSource
    Left = 438
    Top = 10
  end
end
