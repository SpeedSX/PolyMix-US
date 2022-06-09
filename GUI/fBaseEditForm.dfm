object BaseEditForm: TBaseEditForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 323
  ClientWidth = 471
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  DesignSize = (
    471
    323)
  PixelsPerInch = 96
  TextHeight = 13
  object btOk: TButton
    Left = 295
    Top = 288
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object btCancel: TButton
    Left = 384
    Top = 288
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object FormStorage: TJvFormStorage
    AppStoragePath = 'BaseEditForm\'
    Options = [fpLocation]
    StoredValues = <>
    Left = 256
    Top = 288
  end
end
