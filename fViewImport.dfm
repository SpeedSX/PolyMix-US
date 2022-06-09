object ViewImportForm: TViewImportForm
  Left = 355
  Top = 311
  BorderIcons = [biSystemMenu]
  Caption = #1048#1084#1087#1086#1088#1090' '#1079#1072#1082#1072#1079#1086#1074
  ClientHeight = 318
  ClientWidth = 656
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 285
    Width = 656
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    ExplicitTop = 283
    ExplicitWidth = 659
    DesignSize = (
      656
      33)
    object btOk: TButton
      Left = 488
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1048#1084#1087#1086#1088#1090
      Default = True
      ModalResult = 1
      TabOrder = 0
      ExplicitLeft = 491
    end
    object btCancel: TButton
      Left = 573
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      OnClick = btCancelClick
      ExplicitLeft = 576
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 656
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    ExplicitWidth = 659
    object Label1: TLabel
      Left = 6
      Top = 6
      Width = 97
      Height = 13
      Caption = #1053#1072#1081#1076#1077#1085#1085#1099#1077' '#1079#1072#1082#1072#1079#1099
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 23
    Width = 656
    Height = 262
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    Caption = ' '
    TabOrder = 2
    ExplicitWidth = 659
    ExplicitHeight = 260
    object dgImport: TMyDBGridEh
      Left = 5
      Top = 5
      Width = 646
      Height = 252
      Align = alClient
      AllowedOperations = [alopUpdateEh]
      DataGrouping.GroupLevels = <>
      DataSource = dsImport
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'Tahoma'
      FooterFont.Style = []
      Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove]
      RowDetailPanel.Color = clBtnFace
      SortLocal = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          EditButtons = <>
          FieldName = 'Enabled'
          Footers = <>
          Title.Caption = #1048#1084#1087#1086#1088#1090
          Width = 44
        end
        item
          EditButtons = <>
          FieldName = 'ID_Number'
          Footers = <>
          Title.Caption = #1053#1086#1084#1077#1088
        end
        item
          EditButtons = <>
          FieldName = 'CustomerName'
          Footers = <>
          Title.Caption = #1047#1072#1082#1072#1079#1095#1080#1082
          Width = 143
        end
        item
          EditButtons = <>
          FieldName = 'Comment'
          Footers = <>
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Width = 166
        end
        item
          EditButtons = <>
          FieldName = 'TotalCost'
          Footers = <>
          Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
          Width = 76
        end
        item
          EditButtons = <>
          FieldName = 'ModifyDate'
          Footers = <>
          Title.Caption = #1048#1079#1084#1077#1085#1077#1085
        end
        item
          EditButtons = <>
          FieldName = 'KindName'
          Footers = <>
          Title.Caption = #1042#1080#1076
          Width = 82
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object cdImport: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 172
    Top = 51
    object cdImportEnabled: TBooleanField
      FieldName = 'Enabled'
    end
    object cdImportFileName: TStringField
      FieldName = 'FileName'
      Size = 255
    end
    object cdImportID_Number: TIntegerField
      FieldName = 'ID_Number'
    end
    object cdImportComment: TStringField
      FieldName = 'Comment'
      Size = 100
    end
    object cdImportKindID: TIntegerField
      FieldName = 'KindID'
    end
    object cdImportCreationDate: TDateTimeField
      FieldName = 'CreationDate'
      DisplayFormat = 'dd.mm.yyyy'
    end
    object cdImportCustomerName: TStringField
      FieldName = 'CustomerName'
      Size = 100
    end
    object cdImportTotalCost: TFloatField
      FieldName = 'TotalCost'
      DisplayFormat = '#,###,##0.00'
    end
    object cdImportModifyDate: TDateTimeField
      FieldName = 'ModifyDate'
    end
    object cdImportCreatorName: TStringField
      FieldName = 'CreatorName'
      Size = 50
    end
    object cdImportModifierName: TStringField
      FieldName = 'ModifierName'
      Size = 50
    end
  end
  object dsImport: TDataSource
    DataSet = cdImport
    Left = 202
    Top = 51
  end
end
