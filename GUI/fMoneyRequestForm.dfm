inherited MoneyRequestForm: TMoneyRequestForm
  ClientHeight = 110
  ClientWidth = 244
  ExplicitWidth = 250
  ExplicitHeight = 135
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 8
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  inherited btOk: TButton
    Left = 68
    Top = 75
    TabOrder = 2
    ExplicitLeft = 68
    ExplicitTop = 85
  end
  inherited btCancel: TButton
    Left = 157
    Top = 75
    TabOrder = 3
    ExplicitLeft = 157
    ExplicitTop = 85
  end
  object edMoney: TJvValidateEdit [3]
    Left = 8
    Top = 32
    Width = 121
    Height = 21
    CriticalPoints.MaxValueIncluded = True
    CriticalPoints.MinValueIncluded = False
    DisplayFormat = dfFloat
    DecimalPlaces = 2
    HasMaxValue = True
    HasMinValue = True
    TabOrder = 0
  end
  object cbPercent: TCheckBox [4]
    Left = 143
    Top = 34
    Width = 97
    Height = 17
    Caption = #1074' % '#1086#1090' '#1089#1091#1084#1084#1099
    TabOrder = 1
    OnClick = cbPercentClick
  end
  inherited FormStorage: TJvFormStorage
    AppStoragePath = 'MoneyRequestForm\'
  end
end
