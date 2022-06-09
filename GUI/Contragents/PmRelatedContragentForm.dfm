inherited RelatedContragentForm: TRelatedContragentForm
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072
  ClientHeight = 327
  ClientWidth = 539
  OnActivate = FormActivate
  ExplicitWidth = 545
  ExplicitHeight = 352
  PixelsPerInch = 96
  TextHeight = 13
  object lbFilt: TLabel [0]
    Left = 8
    Top = 12
    Width = 46
    Height = 13
    Caption = #1060#1080#1083#1100#1090#1088':'
    FocusControl = edName
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel1: TBevel [1]
    Left = 64
    Top = 8
    Width = 13
    Height = 26
    Shape = bsLeftLine
  end
  object Label1: TLabel [2]
    Left = 76
    Top = 12
    Width = 19
    Height = 13
    Caption = #1048#1084#1103
  end
  inherited btOk: TButton
    Left = 367
    Top = 292
    ExplicitLeft = 367
    ExplicitTop = 292
  end
  inherited btCancel: TButton
    Left = 456
    Top = 292
    ExplicitLeft = 456
    ExplicitTop = 292
  end
  object dgCustomers: TMyDBGridEh [5]
    Left = 8
    Top = 40
    Width = 523
    Height = 241
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColumnDefValues.Layout = tlCenter
    DataSource = RelatedDataSource
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    RowHeight = 15
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Name'
        Footers = <>
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 165
      end
      item
        EditButtons = <>
        FieldName = 'FullName'
        Footers = <>
        Title.Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 188
      end
      item
        EditButtons = <>
        FieldName = 'Phone'
        Footers = <>
        Title.Caption = #1058#1077#1083#1077#1092#1086#1085
        Width = 131
      end>
  end
  object edName: TEdit [6]
    Left = 106
    Top = 8
    Width = 175
    Height = 21
    TabOrder = 3
    OnChange = edNameChange
  end
  object RelatedDataSource: TDataSource
    Left = 220
    Top = 288
  end
end
