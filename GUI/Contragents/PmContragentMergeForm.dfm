inherited ContragentMergeForm: TContragentMergeForm
  Caption = #1054#1073#1098#1077#1076#1080#1085#1077#1085#1080#1077' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1086#1074
  ClientHeight = 194
  ClientWidth = 427
  ExplicitWidth = 433
  ExplicitHeight = 219
  DesignSize = (
    427
    194)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 12
    Top = 8
    Width = 136
    Height = 13
    Caption = #1054#1073#1098#1077#1076#1080#1085#1080#1090#1100' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072':'
  end
  object Label2: TLabel [1]
    Left = 12
    Top = 60
    Width = 83
    Height = 13
    Caption = #1089' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1086#1084':'
  end
  inherited btOk: TButton
    Left = 260
    Top = 161
    TabOrder = 5
    ExplicitLeft = 260
    ExplicitTop = 161
  end
  inherited btCancel: TButton
    Left = 345
    Top = 161
    TabOrder = 4
    ExplicitLeft = 345
    ExplicitTop = 161
  end
  object comboSource: TDBLookupComboboxEh [4]
    Left = 12
    Top = 27
    Width = 407
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DropDownBox.AutoFitColWidths = False
    DropDownBox.Columns = <
      item
        FieldName = 'Name'
        Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077'/'#1048#1084#1103
        Width = 303
      end
      item
        FieldName = 'FirmType'
        Title.Caption = #1060#1086#1088#1084#1072' '#1089#1086#1073'.'
        Width = 63
      end
      item
        Alignment = taRightJustify
        FieldName = 'RestIncome'
        Title.Caption = #1054#1089#1090#1072#1090#1086#1082' '#1087#1086#1089#1090#1091#1087#1083#1077#1085#1080#1081', '#1075#1088#1085
        Width = 124
      end
      item
        FieldName = 'ToPayGrn'
        Title.Caption = #1041#1072#1083#1072#1085#1089', '#1075#1088#1085
      end
      item
        Alignment = taCenter
        FieldName = 'CreationDate'
        Title.Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
        Width = 92
      end
      item
        FieldName = 'CreatorName'
        Title.Caption = #1052#1077#1085#1077#1076#1078#1077#1088
        Width = 94
      end>
    DropDownBox.Options = [dlgColumnResizeEh, dlgColLinesEh]
    DropDownBox.AutoDrop = True
    DropDownBox.Rows = 20
    DropDownBox.ShowTitles = True
    DropDownBox.Sizable = True
    EditButtons = <>
    KeyField = 'N'
    ListField = 'Name'
    ListSource = ListSource
    ReadOnly = True
    TabOrder = 0
    Visible = True
  end
  object comboDest: TDBLookupComboboxEh [5]
    Left = 12
    Top = 79
    Width = 407
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DropDownBox.AutoFitColWidths = False
    DropDownBox.Columns = <
      item
        FieldName = 'Name'
        Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077'/'#1048#1084#1103
        Width = 303
      end
      item
        FieldName = 'FirmType'
        Title.Caption = #1060#1086#1088#1084#1072' '#1089#1086#1073'.'
        Width = 63
      end
      item
        Alignment = taRightJustify
        FieldName = 'RestIncome'
        Title.Caption = #1054#1089#1090#1072#1090#1086#1082' '#1087#1086#1089#1090#1091#1087#1083#1077#1085#1080#1081', '#1075#1088#1085
        Width = 124
      end
      item
        FieldName = 'ToPayGrn'
        Title.Caption = #1041#1072#1083#1072#1085#1089', '#1075#1088#1085
      end
      item
        Alignment = taCenter
        FieldName = 'CreationDate'
        Title.Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
        Width = 92
      end
      item
        FieldName = 'CreatorName'
        Title.Caption = #1052#1077#1085#1077#1076#1078#1077#1088
        Width = 94
      end>
    DropDownBox.Options = [dlgColumnResizeEh, dlgColLinesEh]
    DropDownBox.AutoDrop = True
    DropDownBox.Rows = 20
    DropDownBox.ShowTitles = True
    DropDownBox.Sizable = True
    EditButtons = <>
    KeyField = 'N'
    ListField = 'Name'
    ListSource = ListSource
    TabOrder = 1
    Visible = True
  end
  object cbMergeFields: TCheckBox [6]
    Left = 12
    Top = 112
    Width = 401
    Height = 17
    Caption = #1054#1073#1098#1077#1076#1080#1085#1080#1090#1100' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1102' '#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1077
    TabOrder = 2
  end
  object cbMergePersons: TCheckBox [7]
    Left = 12
    Top = 135
    Width = 401
    Height = 17
    Caption = #1054#1073#1098#1077#1076#1080#1085#1080#1090#1100' '#1082#1086#1085#1090#1072#1082#1090#1099
    TabOrder = 3
  end
  inherited FormStorage: TJvFormStorage
    AppStoragePath = 'ContragentMergeForm\'
  end
  object ListSource: TDataSource
    Left = 80
    Top = 160
  end
end
