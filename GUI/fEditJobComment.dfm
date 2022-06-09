object EditJobCommentForm: TEditJobCommentForm
  Left = 308
  Top = 333
  BorderStyle = bsDialog
  Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103
  ClientHeight = 449
  ClientWidth = 538
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    538
    449)
  PixelsPerInch = 96
  TextHeight = 13
  object btSave: TButton
    Left = 368
    Top = 418
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    ModalResult = 1
    TabOrder = 0
  end
  object btCancel: TButton
    Left = 456
    Top = 418
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object pcComments: TPageControl
    Left = 8
    Top = 6
    Width = 523
    Height = 405
    ActivePage = tsJobComment
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object tsJobComment: TTabSheet
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103' '#1082' '#1088#1072#1073#1086#1090#1077
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object paAlert: TPanel
        Left = 0
        Top = 342
        Width = 515
        Height = 35
        Align = alBottom
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 0
        object cbJobAlert: TCheckBox
          Left = 10
          Top = 10
          Width = 287
          Height = 17
          Caption = #1055#1088#1086#1073#1083#1077#1084#1085#1072#1103' '#1088#1072#1073#1086#1090#1072
          TabOrder = 0
          OnClick = cbJobAlertClick
        end
      end
      object TextEditor: TMemo
        Left = 0
        Top = 0
        Width = 515
        Height = 342
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
    object tsOrderComment: TTabSheet
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103' '#1082' '#1079#1072#1082#1072#1079#1091
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
end
