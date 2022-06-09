object NewDicForm: TNewDicForm
  Left = 324
  Top = 300
  BorderStyle = bsDialog
  Caption = #1053#1086#1074#1099#1081' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082
  ClientHeight = 183
  ClientWidth = 351
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 6
    Width = 49
    Height = 13
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077
  end
  object Label2: TLabel
    Left = 14
    Top = 54
    Width = 81
    Height = 13
    Caption = #1042#1085#1091#1090#1088#1077#1085#1085#1077#1077' '#1080#1084#1103
  end
  object edDesc: TEdit
    Left = 12
    Top = 22
    Width = 331
    Height = 21
    TabOrder = 0
    Text = 'edDesc'
  end
  object edName: TEdit
    Left = 12
    Top = 70
    Width = 331
    Height = 21
    TabOrder = 1
    Text = 'edName'
  end
  object btOk: TButton
    Left = 184
    Top = 150
    Width = 75
    Height = 25
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 2
    OnClick = btOkClick
  end
  object Button2: TButton
    Left = 268
    Top = 150
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object GroupBox1: TGroupBox
    Left = 12
    Top = 104
    Width = 153
    Height = 69
    Caption = #1042#1080#1076' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
    TabOrder = 4
    object rbTable: TRadioButton
      Left = 10
      Top = 20
      Width = 113
      Height = 17
      Caption = #1058#1072#1073#1083#1080#1094#1072
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbMDim: TRadioButton
      Left = 10
      Top = 42
      Width = 113
      Height = 17
      Caption = #1052#1085#1086#1075#1086#1084#1077#1088#1085#1099#1081
      Enabled = False
      TabOrder = 1
    end
  end
  object btStruct: TButton
    Left = 184
    Top = 116
    Width = 159
    Height = 25
    Caption = #1057#1090#1088#1091#1082#1090#1091#1088#1072' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072'...'
    TabOrder = 5
    OnClick = btStructClick
  end
end
