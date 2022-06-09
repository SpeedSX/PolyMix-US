inherited OrderNoteForm: TOrderNoteForm
  BorderStyle = bsSizeable
  Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1082' '#1079#1072#1082#1072#1079#1091
  ClientHeight = 284
  ClientWidth = 469
  Constraints.MinHeight = 270
  Constraints.MinWidth = 370
  ExplicitWidth = 477
  ExplicitHeight = 318
  PixelsPerInch = 96
  TextHeight = 13
  object DBText1: TDBText [0]
    Left = 54
    Top = 10
    Width = 123
    Height = 17
    DataField = 'UserName'
  end
  object Label1: TLabel [1]
    Left = 12
    Top = 10
    Width = 35
    Height = 13
    Caption = #1040#1074#1090#1086#1088':'
  end
  object Label2: TLabel [2]
    Left = 12
    Top = 228
    Width = 93
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1044#1072#1090#1072' '#1087#1088#1080#1084#1077#1095#1072#1085#1080#1103':'
  end
  object DBText2: TDBText [3]
    Left = 112
    Top = 228
    Width = 159
    Height = 17
    Anchors = [akLeft, akBottom]
    DataField = 'NoteDate'
  end
  inherited btOk: TButton
    Top = 249
    ExplicitTop = 237
  end
  inherited btCancel: TButton
    Top = 249
    ExplicitTop = 237
  end
  object DBMemo1: TDBMemo [6]
    Left = 10
    Top = 34
    Width = 449
    Height = 159
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataField = 'Note'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    ExplicitHeight = 163
  end
  object cbUseTech: TDBCheckBox [7]
    Left = 12
    Top = 202
    Width = 281
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1076#1083#1103' '#1090#1077#1093#1085#1086#1083#1086#1075#1080#1095#1077#1089#1082#1080#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
    DataField = 'UseTech'
    TabOrder = 3
    ValueChecked = 'True'
    ValueUnchecked = 'False'
    ExplicitTop = 206
  end
  inherited FormStorage: TJvFormStorage
    AppStoragePath = 'OrderNoteForm\'
    Left = 332
    Top = 4
  end
end
