object EditTextForm: TEditTextForm
  Left = 308
  Top = 333
  Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103
  ClientHeight = 286
  ClientWidth = 452
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  DesignSize = (
    452
    286)
  PixelsPerInch = 96
  TextHeight = 13
  object btSave: TButton
    Left = 282
    Top = 255
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    ModalResult = 1
    TabOrder = 0
  end
  object btCancel: TButton
    Left = 370
    Top = 255
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object TextEditor: TMemo
    Left = 8
    Top = 8
    Width = 437
    Height = 240
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
end
