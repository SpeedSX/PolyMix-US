inherited RelatedContragentForm: TRelatedContragentForm
  Caption = #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082
  ClientHeight = 271
  ClientWidth = 502
  ExplicitWidth = 508
  ExplicitHeight = 303
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 12
    Top = 12
    Width = 58
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel [1]
    Left = 13
    Top = 159
    Width = 118
    Height = 13
    Caption = #1052#1086#1073#1080#1083#1100#1085#1099#1081' '#1090#1077#1083#1077#1092#1086#1085' 1:'
  end
  object Label4: TLabel [2]
    Left = 259
    Top = 159
    Width = 118
    Height = 13
    Caption = #1052#1086#1073#1080#1083#1100#1085#1099#1081' '#1090#1077#1083#1077#1092#1086#1085' 2:'
  end
  object Label2: TLabel [3]
    Left = 13
    Top = 60
    Width = 92
    Height = 13
    Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1086#1077' '#1083#1080#1094#1086':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel [4]
    Left = 13
    Top = 109
    Width = 70
    Height = 13
    Caption = #1050#1086#1076' '#1028#1044#1056#1055#1054#1059':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  inherited btOk: TButton
    Left = 320
    Top = 232
    TabOrder = 5
    ExplicitLeft = 357
  end
  inherited btCancel: TButton
    Left = 409
    Top = 232
    TabOrder = 6
    ExplicitLeft = 446
  end
  object edName: TDBEdit [7]
    Left = 12
    Top = 30
    Width = 471
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'Name'
    DataSource = RelatedDataSource
    TabOrder = 0
  end
  object DBEdit3: TDBEdit [8]
    Left = 13
    Top = 178
    Width = 229
    Height = 21
    DataField = 'Phone1'
    DataSource = RelatedDataSource
    TabOrder = 3
  end
  object DBEdit4: TDBEdit [9]
    Left = 259
    Top = 177
    Width = 225
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'Phone2'
    DataSource = RelatedDataSource
    TabOrder = 4
  end
  object DBEdit2: TDBEdit [10]
    Left = 13
    Top = 78
    Width = 471
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'ContactName'
    DataSource = RelatedDataSource
    TabOrder = 1
  end
  object DBEdit5: TDBEdit [11]
    Left = 13
    Top = 128
    Width = 471
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'Code'
    DataSource = RelatedDataSource
    TabOrder = 2
  end
  inherited FormStorage: TJvFormStorage
    Left = 48
  end
  object RelatedDataSource: TDataSource
    Left = 12
    Top = 288
  end
end
