inherited GlobalHistoryForm: TGlobalHistoryForm
  Top = 279
  Caption = #1046#1091#1088#1085#1072#1083' '#1089#1080#1089#1090#1077#1084#1085#1099#1093' '#1089#1086#1073#1099#1090#1080#1081
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    Top = 33
    Height = 343
    ExplicitTop = 33
    ExplicitHeight = 343
    inherited dgHistory: TMyDBGridEh
      Height = 333
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
    end
  end
  object Panel4: TPanel [2]
    Left = 0
    Top = 0
    Width = 636
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 2
    object Label1: TLabel
      Left = 276
      Top = 12
      Width = 72
      Height = 13
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
    end
    object Label2: TLabel
      Left = 4
      Top = 12
      Width = 41
      Height = 13
      Caption = #1044#1072#1090#1072': '#1089' '
    end
    object Label3: TLabel
      Left = 144
      Top = 12
      Width = 13
      Height = 13
      Caption = #1076#1086
    end
    object cbUser: TComboBox
      Left = 360
      Top = 8
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 0
      OnChange = FilterChanged
    end
    object deStart: TJvDateEdit
      Left = 52
      Top = 8
      Width = 85
      Height = 21
      TabOrder = 1
      OnChange = FilterChanged
    end
    object deFinish: TJvDateEdit
      Left = 168
      Top = 8
      Width = 85
      Height = 21
      TabOrder = 2
      OnChange = FilterChanged
    end
  end
  inherited FormStorage: TJvFormStorage
    AppStoragePath = 'GlobalHistoryForm\'
    StoredValues = <
      item
        Name = 'StartDate'
        OnSave = FormStorageStoredValues0Save
        OnRestore = FormStorageStoredValues0Restore
      end
      item
        Name = 'EndDate'
        OnSave = FormStorageStoredValues1Save
        OnRestore = FormStorageStoredValues1Restore
      end
      item
        Name = 'UserLogin'
        OnSave = FormStorageStoredValues2Save
        OnRestore = FormStorageStoredValues2Restore
      end>
  end
end
