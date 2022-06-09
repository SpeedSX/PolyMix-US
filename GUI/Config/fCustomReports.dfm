object EditCustomReportsForm: TEditCustomReportsForm
  Left = 170
  Top = 533
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1086#1090#1095#1077#1090#1086#1074
  ClientHeight = 396
  ClientWidth = 478
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 382
    Top = 0
    Width = 96
    Height = 396
    Align = alRight
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    object btEdit: TButton
      Left = 4
      Top = 6
      Width = 83
      Height = 25
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
      TabOrder = 0
      OnClick = btEditClick
    end
    object btNew: TButton
      Left = 4
      Top = 40
      Width = 81
      Height = 25
      Caption = #1053#1086#1074#1099#1081'...'
      TabOrder = 1
      OnClick = btNewClick
    end
    object btDelete: TButton
      Left = 4
      Top = 74
      Width = 81
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 2
      OnClick = btDeleteClick
    end
    object Panel3: TPanel
      Left = 0
      Top = 321
      Width = 96
      Height = 75
      Align = alBottom
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 3
      object btOk: TButton
        Left = 6
        Top = 8
        Width = 81
        Height = 25
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
      object btCancel: TButton
        Left = 6
        Top = 42
        Width = 81
        Height = 25
        Cancel = True
        Caption = #1054#1090#1084#1077#1085#1072
        ModalResult = 2
        TabOrder = 1
      end
    end
    object btLoadFromFile: TButton
      Left = 4
      Top = 132
      Width = 81
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100'...'
      TabOrder = 4
      OnClick = btLoadFromFileClick
    end
    object btSaveToFile: TButton
      Left = 4
      Top = 168
      Width = 81
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100'...'
      TabOrder = 5
      OnClick = btSaveToFileClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 382
    Height = 396
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    Caption = ' '
    TabOrder = 1
    object dgReports: TMyDBGridEh
      Left = 5
      Top = 5
      Width = 372
      Height = 386
      Align = alClient
      AllowedOperations = []
      AllowedSelections = [gstRecordBookmarks]
      AutoFitColWidths = True
      ColumnDefValues.Layout = tlCenter
      DataSource = dsCustomReports
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'Tahoma'
      FooterFont.Style = []
      Options = [dgColumnResize, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghHighlightFocus, dghClearSelection, dghDialogFind]
      RowHeight = 17
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          EditButtons = <>
          FieldName = 'ReportName'
          Footers = <>
          ReadOnly = True
          Width = 198
        end>
    end
  end
  object dsCustomReports: TDataSource
    Left = 238
    Top = 68
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.rpt'
    Filter = #1054#1090#1095#1077#1090#1099'|*.rpt'
    Left = 196
    Top = 108
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.rpt'
    Filter = #1054#1090#1095#1077#1090#1099'|*.rpt'
    Left = 236
    Top = 108
  end
end
