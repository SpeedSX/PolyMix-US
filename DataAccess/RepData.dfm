object rdm: Trdm
  OldCreateOrder = False
  Height = 448
  Width = 679
  object aqReports: TADOQuery
    Connection = dm.cnCalc
    Parameters = <>
    SQL.Strings = (
      
        'select ScriptID, Script, ScriptName, ScriptDesc, WorkInsideOrder' +
        ', ModifyDate,'
      'ShortCut, IsUnit, IsDefault, ShowCancel, ReportGroupId'
      'from GlobalScripts'
      '--order by ScriptDesc')
    Left = 12
    Top = 16
    object aqReportsScriptID: TAutoIncField
      FieldName = 'ScriptID'
      ReadOnly = True
    end
    object aqReportsScript: TMemoField
      FieldName = 'Script'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqReportsScriptName: TStringField
      FieldName = 'ScriptName'
      ProviderFlags = [pfInUpdate]
      Size = 30
    end
    object aqReportsScriptDesc: TStringField
      FieldName = 'ScriptDesc'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object aqReportsWorkInsideOrder: TBooleanField
      FieldName = 'WorkInsideOrder'
      ProviderFlags = [pfInUpdate]
    end
    object aqReportsModifyDate: TDateTimeField
      FieldName = 'ModifyDate'
      ProviderFlags = [pfInUpdate]
    end
    object aqReportsShortCut: TIntegerField
      FieldName = 'ShortCut'
      ProviderFlags = [pfInUpdate]
    end
    object aqReportsIsUnit: TBooleanField
      FieldName = 'IsUnit'
      ProviderFlags = [pfInUpdate]
    end
    object aqReportsIsDefault: TBooleanField
      FieldName = 'IsDefault'
      ProviderFlags = [pfInUpdate]
    end
    object aqReportsShowCancel: TBooleanField
      FieldName = 'ShowCancel'
      ProviderFlags = [pfInUpdate]
    end
    object aqReportsReportGroupId: TIntegerField
      FieldName = 'ReportGroupId'
      ProviderFlags = [pfInUpdate]
    end
  end
  object pvReports: TDataSetProvider
    DataSet = aqReports
    Options = [poAllowMultiRecordUpdates]
    UpdateMode = upWhereKeyOnly
    BeforeUpdateRecord = pvReportsBeforeUpdateRecord
    Left = 72
    Top = 16
  end
  object cdReports: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvReports'
    OnNewRecord = cdReportsNewRecord
    Left = 132
    Top = 16
    object cdReportsScriptID: TAutoIncField
      FieldName = 'ScriptID'
      ReadOnly = True
    end
    object cdReportsScript: TMemoField
      FieldName = 'Script'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdReportsScriptName: TStringField
      FieldName = 'ScriptName'
      ProviderFlags = [pfInUpdate]
      Size = 30
    end
    object cdReportsScriptDesc: TStringField
      FieldName = 'ScriptDesc'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdReportsWorkInsideOrder: TBooleanField
      FieldName = 'WorkInsideOrder'
      ProviderFlags = [pfInUpdate]
    end
    object cdReportsModifyDate: TDateTimeField
      FieldName = 'ModifyDate'
      ProviderFlags = [pfInUpdate]
      DisplayFormat = 'dd/mm/yyyy'
    end
    object cdReportsShortCut: TIntegerField
      FieldName = 'ShortCut'
      ProviderFlags = [pfInUpdate]
    end
    object cdReportsIsUnit: TBooleanField
      FieldName = 'IsUnit'
      ProviderFlags = [pfInUpdate]
    end
    object cdReportsIsDefault: TBooleanField
      FieldName = 'IsDefault'
      ProviderFlags = [pfInUpdate]
    end
    object cdReportsShowCancel: TBooleanField
      FieldName = 'ShowCancel'
      ProviderFlags = [pfInUpdate]
    end
    object cdReportsReportGroupId: TIntegerField
      FieldName = 'ReportGroupId'
      ProviderFlags = [pfInUpdate]
    end
  end
  object dsReports: TDataSource
    DataSet = cdReports
    Left = 188
    Top = 16
  end
  object cdForms: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvForms'
    OnNewRecord = cdFormsNewRecord
    Left = 136
    Top = 72
    object cdFormsFormID: TAutoIncField
      FieldName = 'FormID'
      ReadOnly = True
    end
    object cdFormsModifyDate: TDateTimeField
      FieldName = 'ModifyDate'
      ProviderFlags = [pfInUpdate]
      DisplayFormat = 'dd/mm/yyyy'
    end
    object cdFormsFormName: TStringField
      FieldName = 'FormName'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdFormsFormDesc: TStringField
      FieldName = 'FormDesc'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdFormsFormPas: TMemoField
      FieldName = 'FormPas'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdFormsFormDfm: TMemoField
      FieldName = 'FormDfm'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
  end
  object aqForms: TADOQuery
    Connection = dm.cnCalc
    Parameters = <>
    SQL.Strings = (
      'select FormID, FormName, FormDesc, ModifyDate, FormPas, FormDfm '
      'from ScriptedForms'
      'order by FormName')
    Left = 16
    Top = 72
    object aqFormsFormID: TAutoIncField
      FieldName = 'FormID'
      ReadOnly = True
    end
    object aqFormsModifyDate: TDateTimeField
      FieldName = 'ModifyDate'
      ProviderFlags = [pfInUpdate]
    end
    object aqFormsName: TStringField
      FieldName = 'FormName'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object aqFormsDesc: TStringField
      FieldName = 'FormDesc'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object aqFormsFormPas: TMemoField
      FieldName = 'FormPas'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqFormsFormDfm: TMemoField
      FieldName = 'FormDfm'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
  end
  object pvForms: TDataSetProvider
    DataSet = aqForms
    Options = [poAllowMultiRecordUpdates]
    UpdateMode = upWhereKeyOnly
    BeforeUpdateRecord = pvFormsBeforeUpdateRecord
    Left = 76
    Top = 72
  end
  object dsForms: TDataSource
    DataSet = cdForms
    Left = 188
    Top = 72
  end
  object aqOrdScripts: TADOQuery
    Connection = dm.cnCalc
    Parameters = <>
    SQL.Strings = (
      'select ScriptID, Script, ScriptName, ScriptDesc, ModifyDate '
      'from OrderScripts'
      'order by ScriptName')
    Left = 20
    Top = 124
    object aqOrdScriptsScriptID: TAutoIncField
      FieldName = 'ScriptID'
      ReadOnly = True
    end
    object aqOrdScriptsScript: TMemoField
      FieldName = 'Script'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqOrdScriptsScriptName: TStringField
      FieldName = 'ScriptName'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object aqOrdScriptsScriptDesc: TStringField
      FieldName = 'ScriptDesc'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object aqOrdScriptsModifyDate: TDateTimeField
      FieldName = 'ModifyDate'
      ProviderFlags = [pfInUpdate]
    end
  end
  object pvOrdScripts: TDataSetProvider
    DataSet = aqOrdScripts
    Options = [poAllowMultiRecordUpdates]
    UpdateMode = upWhereKeyOnly
    BeforeUpdateRecord = pvReportsBeforeUpdateRecord
    Left = 88
    Top = 124
  end
  object cdOrdScripts: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvOrdScripts'
    Left = 148
    Top = 124
    object cdOrdScriptsScriptID: TAutoIncField
      FieldName = 'ScriptID'
      ReadOnly = True
    end
    object cdOrdScriptsScript: TMemoField
      FieldName = 'Script'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdOrdScriptsScriptName: TStringField
      FieldName = 'ScriptName'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdOrdScriptsScriptDesc: TStringField
      FieldName = 'ScriptDesc'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdOrdScriptsModifyDate: TDateTimeField
      FieldName = 'ModifyDate'
      ProviderFlags = [pfInUpdate]
    end
  end
  object dsOrdScripts: TDataSource
    DataSet = cdOrdScripts
    Left = 212
    Top = 124
  end
  object cdCustomReports: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvCustomReports'
    Left = 208
    Top = 176
    object cdCustomReportsReportID: TAutoIncField
      FieldName = 'ReportID'
      ReadOnly = True
    end
    object cdCustomReportsReportName: TStringField
      FieldName = 'ReportName'
      ProviderFlags = [pfInUpdate]
      Size = 100
    end
    object cdCustomReportsAddFilter: TBooleanField
      FieldName = 'AddFilter'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportsProcessLine: TBooleanField
      FieldName = 'ProcessLine'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportsProcessDetails: TBooleanField
      FieldName = 'ProcessDetails'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportsIncludeEmptyDetails: TBooleanField
      FieldName = 'IncludeEmptyDetails'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportsRepeatOrderFields: TBooleanField
      FieldName = 'RepeatOrderFields'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportsSort1: TIntegerField
      FieldName = 'Sort1'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportsSort2: TIntegerField
      FieldName = 'Sort2'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportsSort3: TIntegerField
      FieldName = 'Sort3'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportsSort4: TIntegerField
      FieldName = 'Sort4'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportsSortAscending: TBooleanField
      FieldName = 'SortAscending'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportsAddRowAfterGroup: TBooleanField
      FieldName = 'AddRowAfterGroup'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportsReportGroupId: TIntegerField
      FieldName = 'ReportGroupId'
      ProviderFlags = [pfInUpdate]
    end
  end
  object pvCustomReports: TDataSetProvider
    DataSet = aqCustomReports
    Options = [poAllowMultiRecordUpdates]
    Left = 114
    Top = 176
  end
  object aqCustomReports: TADOQuery
    Connection = dm.cnCalc
    Parameters = <>
    SQL.Strings = (
      
        'select ReportID, ReportName, AddFilter, ProcessLine, ProcessDeta' +
        'ils, IncludeEmptyDetails, RepeatOrderFields,'
      
        'Sort1, Sort2, Sort3, Sort4, SortAscending, AddRowAfterGroup, Rep' +
        'ortGroupId'
      'from CustomReports'
      'order by ReportName')
    Left = 28
    Top = 178
  end
  object cdCustomReportCols: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'cdCustomReportColsIndex1'
        Fields = 'OrderNum'
      end>
    IndexName = 'cdCustomReportColsIndex1'
    Params = <>
    ProviderName = 'pvCustomReportCols'
    StoreDefs = True
    Left = 248
    Top = 234
    object cdCustomReportColsReportItemID: TAutoIncField
      FieldName = 'ReportItemID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object cdCustomReportColsReportID: TIntegerField
      FieldName = 'ReportID'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsFieldSourceType: TIntegerField
      FieldName = 'FieldSourceType'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsFieldName: TStringField
      FieldName = 'FieldName'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdCustomReportColsCaption: TStringField
      FieldName = 'Caption'
      ProviderFlags = [pfInUpdate]
      Size = 100
    end
    object cdCustomReportColsProcessID: TIntegerField
      FieldName = 'ProcessID'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsOrderNum: TIntegerField
      FieldName = 'OrderNum'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsFontBold: TBooleanField
      FieldName = 'FontBold'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsFontItalic: TBooleanField
      FieldName = 'FontItalic'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsAlignment: TIntegerField
      FieldName = 'Alignment'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsFontColor: TIntegerField
      FieldName = 'FontColor'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsBkColor: TIntegerField
      FieldName = 'BkColor'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsCaptionFontBold: TBooleanField
      FieldName = 'CaptionFontBold'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsCaptionFontItalic: TBooleanField
      FieldName = 'CaptionFontItalic'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsCaptionFontColor: TIntegerField
      FieldName = 'CaptionFontColor'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsCaptionBkColor: TIntegerField
      FieldName = 'CaptionBkColor'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsCaptionAlignment: TIntegerField
      FieldName = 'CaptionAlignment'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsDisplayFormat: TStringField
      FieldName = 'DisplayFormat'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object cdCustomReportColsSourceName: TStringField
      FieldKind = fkInternalCalc
      FieldName = 'SourceName'
      ProviderFlags = []
      Size = 100
    end
    object cdCustomReportColsSumTotal: TBooleanField
      FieldName = 'SumTotal'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsSumByGroup: TBooleanField
      FieldName = 'SumByGroup'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsFilter: TStringField
      FieldName = 'Filter'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdCustomReportColsFilterEnabled: TBooleanField
      FieldKind = fkCalculated
      FieldName = 'FilterEnabled'
      Calculated = True
    end
    object cdCustomReportColsFilterType: TIntegerField
      FieldName = 'FilterType'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsAutoFitColumn: TBooleanField
      FieldKind = fkInternalCalc
      FieldName = 'AutoFitColumn'
      ProviderFlags = [pfInUpdate]
    end
    object cdCustomReportColsColumnWidth: TIntegerField
      FieldKind = fkInternalCalc
      FieldName = 'ColumnWidth'
      ProviderFlags = [pfInUpdate]
    end
  end
  object pvCustomReportCols: TDataSetProvider
    DataSet = aqCustomReportCols
    Options = [poAllowMultiRecordUpdates]
    Left = 142
    Top = 234
  end
  object aqCustomReportCols: TADOQuery
    Connection = dm.cnCalc
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from CustomReportColumns'
      'order by ReportID, OrderNum')
    Left = 38
    Top = 234
  end
end
