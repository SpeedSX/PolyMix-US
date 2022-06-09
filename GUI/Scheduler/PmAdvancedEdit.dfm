inherited JobAdvancedEditForm: TJobAdvancedEditForm
  Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1088#1072#1073#1086#1090#1099
  ClientHeight = 221
  ClientWidth = 385
  OnCreate = FormCreate
  ExplicitWidth = 391
  ExplicitHeight = 246
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel [0]
    Left = 16
    Top = 136
    Width = 127
    Height = 13
    Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088' '#1088#1072#1073#1086#1090#1099':'
  end
  object Label8: TLabel [1]
    Left = 16
    Top = 160
    Width = 135
    Height = 13
    Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088' '#1087#1088#1086#1094#1077#1089#1089#1072':'
  end
  inherited btOk: TButton
    Left = 209
    Top = 186
    ExplicitLeft = 209
    ExplicitTop = 186
  end
  inherited btCancel: TButton
    Left = 298
    Top = 186
    ExplicitLeft = 298
    ExplicitTop = 186
  end
  object GroupBox1: TGroupBox [4]
    Left = 12
    Top = 10
    Width = 361
    Height = 117
    Caption = ' '#1042#1080#1076' '#1088#1072#1079#1073#1080#1074#1082#1080' '
    TabOrder = 2
    object Label2: TLabel
      Left = 12
      Top = 57
      Width = 60
      Height = 13
      Caption = #1056#1072#1079#1073#1080#1074#1082#1072' 2:'
    end
    object Label1: TLabel
      Left = 12
      Top = 28
      Width = 60
      Height = 13
      Caption = #1056#1072#1079#1073#1080#1074#1082#1072' 1:'
    end
    object Label3: TLabel
      Left = 12
      Top = 88
      Width = 60
      Height = 13
      Caption = #1056#1072#1079#1073#1080#1074#1082#1072' 3:'
    end
    object Label4: TLabel
      Left = 244
      Top = 28
      Width = 35
      Height = 13
      Caption = #1053#1086#1084#1077#1088':'
    end
    object Label5: TLabel
      Left = 244
      Top = 58
      Width = 35
      Height = 13
      Caption = #1053#1086#1084#1077#1088':'
    end
    object Label6: TLabel
      Left = 244
      Top = 88
      Width = 35
      Height = 13
      Caption = #1053#1086#1084#1077#1088':'
    end
    object cbSplitMode1: TComboBox
      Left = 82
      Top = 24
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object cbSplitMode3: TComboBox
      Left = 82
      Top = 84
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
    end
    object edSplitPart1: TEdit
      Left = 286
      Top = 24
      Width = 45
      Height = 21
      TabOrder = 2
      Text = '0'
    end
    object udSplitPart1: TUpDown
      Left = 331
      Top = 24
      Width = 16
      Height = 21
      Associate = edSplitPart1
      TabOrder = 3
    end
    object edSplitPart2: TEdit
      Left = 286
      Top = 54
      Width = 45
      Height = 21
      TabOrder = 4
      Text = '0'
    end
    object udSplitPart2: TUpDown
      Left = 331
      Top = 54
      Width = 16
      Height = 21
      Associate = edSplitPart2
      TabOrder = 5
    end
    object edSplitPart3: TEdit
      Left = 286
      Top = 84
      Width = 45
      Height = 21
      TabOrder = 6
      Text = '0'
    end
    object udSplitPart3: TUpDown
      Left = 331
      Top = 84
      Width = 16
      Height = 21
      Associate = edSplitPart3
      TabOrder = 7
    end
  end
  object cbSplitMode2: TComboBox [5]
    Left = 94
    Top = 64
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
  end
  object edJobID: TEdit [6]
    Left = 160
    Top = 132
    Width = 65
    Height = 21
    TabOrder = 4
    Text = '0'
  end
  object edItemID: TEdit [7]
    Left = 160
    Top = 156
    Width = 65
    Height = 21
    TabOrder = 5
    Text = '0'
  end
end
