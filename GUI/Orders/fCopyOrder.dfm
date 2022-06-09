object CopyOrderForm: TCopyOrderForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1082#1086#1087#1080#1080' '#1079#1072#1082#1072#1079#1072
  ClientHeight = 229
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    345
    229)
  PixelsPerInch = 96
  TextHeight = 13
  object Label9: TLabel
    Left = 11
    Top = 10
    Width = 117
    Height = 13
    Alignment = taRightJustify
    Caption = #1055#1083#1072#1085#1086#1074#1086#1077' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1077':'
  end
  object btOk: TBitBtn
    Left = 138
    Top = 196
    Width = 103
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1057#1086#1079#1076#1072#1090#1100' '#1082#1086#1087#1080#1102
    Default = True
    ModalResult = 1
    TabOrder = 0
    NumGlyphs = 2
    Spacing = 7
    ExplicitLeft = 57
    ExplicitTop = 85
  end
  object btCancel: TBitBtn
    Left = 247
    Top = 196
    Width = 93
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
    NumGlyphs = 2
    Spacing = 7
    ExplicitLeft = 166
    ExplicitTop = 85
  end
  object deFinishDate: TJvDateEdit
    Left = 11
    Top = 29
    Width = 106
    Height = 21
    ImageKind = ikDropDown
    ButtonWidth = 17
    TabOrder = 2
    OnChange = deFinishDateChange
  end
  object tmFinish: TMaskEdit
    Left = 132
    Top = 29
    Width = 50
    Height = 21
    EditMask = '!90:00;1; '
    MaxLength = 5
    TabOrder = 3
    Text = '  :  '
  end
  object Panel1: TPanel
    Left = 10
    Top = 64
    Width = 325
    Height = 121
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = ' '
    TabOrder = 4
    ExplicitHeight = 77
    object lbWarning: TJvHTLabel
      Left = 10
      Top = 6
      Width = 29
      Height = 14
      Caption = #1058#1077#1082#1089#1090
    end
  end
end
