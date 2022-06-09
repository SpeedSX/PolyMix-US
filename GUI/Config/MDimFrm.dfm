object MultiDimForm: TMultiDimForm
  Left = 389
  Top = 216
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
  ClientHeight = 340
  ClientWidth = 484
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 305
    Width = 484
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    object btOk: TButton
      Left = 328
      Top = 6
      Width = 75
      Height = 25
      Caption = #1054#1050
      ModalResult = 1
      TabOrder = 1
    end
    object btCancel: TButton
      Left = 408
      Top = 6
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 2
      OnClick = btCancelClick
    end
    object btApply: TButton
      Left = 242
      Top = 6
      Width = 81
      Height = 25
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      TabOrder = 0
      OnClick = btApplyClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 169
    Width = 484
    Height = 136
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object dgItems: TMyDBGridEh
      Left = 0
      Top = 0
      Width = 484
      Height = 136
      Align = alClient
      DataSource = dsItems
      Flat = False
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'Tahoma'
      FooterFont.Style = []
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object paDim: TPanel
    Left = 0
    Top = 0
    Width = 484
    Height = 169
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 2
    object CheckBox1: TCheckBox
      Left = 12
      Top = 12
      Width = 113
      Height = 17
      Caption = #1042#1099#1073#1086#1088#1082#1072
      TabOrder = 0
    end
    object RxDBLookupCombo1: TJvDBLookupCombo
      Left = 126
      Top = 10
      Width = 351
      Height = 21
      TabOrder = 1
    end
  end
  object dsItems: TDataSource
    Left = 152
    Top = 199
  end
end
