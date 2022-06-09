object NotesPopupForm: TNotesPopupForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 311
  ClientWidth = 460
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object dgNotes: TMyDBGridEh
    Left = 0
    Top = 0
    Width = 460
    Height = 311
    Align = alClient
    AllowedOperations = []
    AutoFitColWidths = True
    DataGrouping.GroupLevels = <>
    DataSource = dsNotes
    EvenRowColor = clWindow
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    OddRowColor = clWindow
    Options = [dgColumnResize, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghClearSelection, dghDialogFind, dghColumnResize, dghColumnMove, dghAutoFitRowHeight]
    RowDetailPanel.Color = clBtnFace
    RowHeight = 2
    RowLines = 1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = dgNotesDblClick
    OnGetCellParams = dgNotesGetCellParams
    Columns = <
      item
        EditButtons = <>
        FieldName = 'UserName'
        Footers = <>
        ReadOnly = True
        Title.Caption = #1040#1074#1090#1086#1088
        Width = 81
      end
      item
        EditButtons = <>
        FieldName = 'Note'
        Footers = <>
        ReadOnly = True
        Title.Caption = #1058#1077#1082#1089#1090
        Width = 273
        WordWrap = True
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object mtNotes: TMemTableEh
    Params = <>
    DataDriver = ddNotes
    Left = 20
    Top = 2
  end
  object ddNotes: TDataSetDriverEh
    KeyFields = 'OrderNoteID'
    Left = 50
    Top = 2
  end
  object dsNotes: TDataSource
    DataSet = mtNotes
    Left = 84
    Top = 4
  end
end
