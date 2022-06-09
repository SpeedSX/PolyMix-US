object JobListForm: TJobListForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1080#1089#1086#1082' '#1088#1072#1073#1086#1090
  ClientHeight = 234
  ClientWidth = 626
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object paJobList: TPanel
    Left = 0
    Top = 0
    Width = 626
    Height = 196
    Align = alClient
    BevelOuter = bvNone
    BevelWidth = 10
    TabOrder = 0
  end
  object paBottom: TPanel
    Left = 0
    Top = 196
    Width = 626
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      626
      38)
    object btOk: TButton
      Left = 459
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1042#1099#1073#1088#1072#1090#1100
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btCancel: TButton
      Left = 544
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
end
