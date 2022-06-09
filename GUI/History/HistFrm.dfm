object HistoryForm: THistoryForm
  Left = 397
  Top = 530
  Caption = #1048#1089#1090#1086#1088#1080#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
  ClientHeight = 409
  ClientWidth = 636
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 636
    Height = 376
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    Caption = ' '
    TabOrder = 0
    object dgHistory: TMyDBGridEh
      Left = 5
      Top = 5
      Width = 626
      Height = 366
      Align = alClient
      AutoFitColWidths = True
      DataGrouping.GroupLevels = <>
      DataSource = dsHistory
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'Tahoma'
      FooterFont.Style = []
      RowDetailPanel.Color = clBtnFace
      RowHeight = 17
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      IniStorage = FormStorage
      Columns = <
        item
          EditButtons = <>
          FieldName = 'EventDate'
          Footers = <>
          Title.Caption = #1044#1072#1090#1072
          Width = 94
        end
        item
          EditButtons = <>
          FieldName = 'EventKind'
          Footers = <>
          Title.Caption = #1042#1080#1076
          Width = 75
        end
        item
          EditButtons = <>
          FieldName = 'EventText'
          Footers = <>
          Title.Caption = #1057#1086#1073#1099#1090#1080#1077
          Width = 334
        end
        item
          EditButtons = <>
          FieldName = 'EventUser'
          Footers = <>
          Title.Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
          Width = 82
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 376
    Width = 636
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object Panel3: TPanel
      Left = 504
      Top = 0
      Width = 132
      Height = 33
      Align = alRight
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 0
      object btClose: TButton
        Left = 8
        Top = 4
        Width = 119
        Height = 25
        Caption = #1047#1072#1082#1088#1099#1090#1100
        ModalResult = 1
        TabOrder = 0
      end
    end
    object btRefresh: TBitBtn
      Left = 8
      Top = 4
      Width = 105
      Height = 25
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 1
      OnClick = btRefreshClick
    end
  end
  object FormStorage: TJvFormStorage
    AppStoragePath = 'HistoryForm\'
    StoredValues = <>
    Left = 32
    Top = 60
  end
  object dsHistory: TDataSource
    Left = 224
    Top = 84
  end
end
