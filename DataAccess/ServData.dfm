object sdm: Tsdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 537
  Width = 718
  object dsServices: TDataSource
    DataSet = cdServices
    Left = 84
    Top = 6
  end
  object dsSrvGrps: TDataSource
    DataSet = cdSrvGrps
    Left = 394
    Top = 4
  end
  object pvServices: TDataSetProvider
    DataSet = aqServices
    Options = [poAllowMultiRecordUpdates]
    UpdateMode = upWhereKeyOnly
    Left = 20
    Top = 60
  end
  object pvSrvGrps: TDataSetProvider
    DataSet = aqSrvGrps
    Options = [poAllowMultiRecordUpdates]
    UpdateMode = upWhereKeyOnly
    BeforeUpdateRecord = pvSrvGrpsBeforeUpdateRecord
    Left = 292
    Top = 4
  end
  object pvParams: TDataSetProvider
    DataSet = aqParams
    Options = [poAllowMultiRecordUpdates]
    UpdateMode = upWhereChanged
    Left = 240
    Top = 188
  end
  object pvSrvFieldInfo: TDataSetProvider
    DataSet = aqSrvFieldInfo
    Options = [poAllowMultiRecordUpdates]
    Left = 144
    Top = 264
  end
  object cdServices: TClientDataSet
    Aggregates = <>
    FetchOnDemand = False
    Params = <>
    ProviderName = 'pvServices'
    Left = 84
    Top = 56
    object cdServicesSrvID: TAutoIncField
      FieldName = 'SrvID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object cdServicesSrvName: TStringField
      FieldName = 'SrvName'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object cdServicesSrvDesc: TStringField
      FieldName = 'SrvDesc'
      ProviderFlags = [pfInUpdate]
      Size = 60
    end
    object cdServicesSrvActive: TBooleanField
      FieldName = 'SrvActive'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesOnChange: TMemoField
      FieldName = 'OnChange'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesOnNewRecord: TMemoField
      FieldName = 'OnNewRecord'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesOnCalcFields: TMemoField
      FieldName = 'OnCalcFields'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesOnParamChange: TMemoField
      FieldName = 'OnParamChange'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesOnSetPrices: TMemoField
      FieldName = 'OnSetPrices'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesOnCheck: TMemoField
      FieldName = 'OnCheck'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesOnGetText: TMemoField
      FieldName = 'OnGetText'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesBeforeInsert: TMemoField
      FieldName = 'BeforeInsert'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesAssignCalcFields: TBooleanField
      FieldName = 'AssignCalcFields'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesAssignDataChange: TBooleanField
      FieldName = 'AssignDataChange'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesAssignNewRecord: TBooleanField
      FieldName = 'AssignNewRecord'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesAssignBeforeInsert: TBooleanField
      FieldName = 'AssignBeforeInsert'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesServiceKind: TIntegerField
      FieldName = 'ServiceKind'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesStoreSettings: TBooleanField
      FieldName = 'StoreSettings'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesOnlyWorkOrder: TBooleanField
      FieldName = 'OnlyWorkOrder'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesShowInReport: TBooleanField
      FieldName = 'ShowInReport'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesNotForCopy: TBooleanField
      FieldName = 'NotForCopy'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesBaseSrvID: TIntegerField
      FieldName = 'BaseSrvID'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesAfterOpen: TMemoField
      FieldName = 'AfterOpen'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesEnableAfterOpen: TBooleanField
      FieldName = 'EnableAfterOpen'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesEnablePlanning: TBooleanField
      FieldName = 'EnablePlanning'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesEnableTracking: TBooleanField
      FieldName = 'EnableTracking'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesUseInTotal: TBooleanField
      FieldName = 'UseInTotal'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesShowInProfit: TBooleanField
      FieldName = 'ShowInProfit'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesUseInProfitMode: TIntegerField
      FieldName = 'UseInProfitMode'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesOnItemParams: TMemoField
      FieldName = 'OnItemParams'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesHideItem: TBooleanField
      FieldName = 'HideItem'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesEnableBeforeScroll: TBooleanField
      FieldName = 'EnableBeforeScroll'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesEnableAfterScroll: TBooleanField
      FieldName = 'EnableAfterScroll'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesBeforeScroll: TMemoField
      FieldName = 'BeforeScroll'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesAfterScroll: TMemoField
      FieldName = 'AfterScroll'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesAfterOrderOpen: TMemoField
      FieldName = 'AfterOrderOpen'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesEnableAfterOrderOpen: TBooleanField
      FieldName = 'EnableAfterOrderOpen'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesIsContent: TBooleanField
      FieldName = 'IsContent'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesDefaultEquipGroupCode: TIntegerField
      FieldName = 'DefaultEquipGroupCode'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesOnCreateNotPlanned: TMemoField
      FieldName = 'OnCreateNotPlanned'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesOnCreateDayPlan: TMemoField
      FieldName = 'OnCreateDayPlan'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesOnNotPlannedCalcFields: TMemoField
      FieldName = 'OnNotPlannedCalcFields'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesOnDayPlanCalcFields: TMemoField
      FieldName = 'OnDayPlanCalcFields'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesOnGetNotPlannedSQL: TMemoField
      FieldName = 'OnGetNotPlannedSQL'
      BlobType = ftMemo
    end
    object cdServicesOnGetDayPlanSQL: TMemoField
      FieldName = 'OnGetDayPlanSQL'
      BlobType = ftMemo
    end
    object cdServicesOnCreateNotPlannedColumns: TMemoField
      FieldName = 'OnCreateNotPlannedColumns'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesOnCreateDayPlanColumns: TMemoField
      FieldName = 'OnCreateDayPlanColumns'
      BlobType = ftMemo
    end
    object cdServicesOnCreateProduction: TMemoField
      FieldName = 'OnCreateProduction'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesOnGetProductionSQL: TMemoField
      FieldName = 'OnGetProductionSQL'
      BlobType = ftMemo
    end
    object cdServicesOnCreateProductionColumns: TMemoField
      FieldName = 'OnCreateProductionColumns'
      BlobType = ftMemo
    end
    object cdServicesOnProductionCalcFields: TMemoField
      FieldName = 'OnProductionCalcFields'
      BlobType = ftMemo
    end
    object cdServicesOnEstimateDuration: TMemoField
      FieldName = 'OnEstimateDuration'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesLinkedProcessID: TIntegerField
      FieldName = 'LinkedProcessID'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesSequenceOrder: TIntegerField
      FieldName = 'SequenceOrder'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesEnableBeforeDelete: TBooleanField
      FieldName = 'EnableBeforeDelete'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesBeforeDelete: TMemoField
      FieldName = 'BeforeDelete'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdServicesEnableLinking: TBooleanField
      FieldName = 'EnableLinking'
      ProviderFlags = [pfInUpdate]
    end
    object cdServicesDefaultContractorProcess: TBooleanField
      FieldName = 'DefaultContractorProcess'
      ProviderFlags = [pfInUpdate]
    end
  end
  object cdSrvGrps: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvSrvGrps'
    BeforeInsert = cdSrvGrpsBeforeInsert
    OnNewRecord = cdSrvGrpsNewRecord
    Left = 348
    Top = 4
    object cdSrvGrpsGrpID: TAutoIncField
      FieldName = 'GrpID'
      ReadOnly = True
    end
    object cdSrvGrpsGrpNumber: TIntegerField
      FieldName = 'GrpNumber'
    end
    object cdSrvGrpsGrpDesc: TStringField
      FieldName = 'GrpDesc'
      Size = 40
    end
  end
  object cdParams: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvParams'
    Left = 264
    Top = 156
    object cdParamsParamID: TAutoIncField
      FieldName = 'ParamID'
      ReadOnly = True
    end
    object cdParamsParName: TStringField
      FieldName = 'ParName'
      Size = 32
    end
    object cdParamsParDesc: TStringField
      FieldName = 'ParDesc'
      Size = 80
    end
  end
  object cdSrvFieldInfo: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvSrvFieldInfo'
    Left = 204
    Top = 276
    object cdSrvFieldInfoSrvFieldID: TAutoIncField
      FieldName = 'SrvFieldID'
      ReadOnly = True
    end
    object cdSrvFieldInfoSrvID: TIntegerField
      FieldName = 'SrvID'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvFieldInfoFieldName: TStringField
      FieldName = 'FieldName'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object cdSrvFieldInfoFieldDesc: TStringField
      FieldName = 'FieldDesc'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object cdSrvFieldInfoFieldType: TIntegerField
      FieldName = 'FieldType'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvFieldInfoLength: TIntegerField
      FieldName = 'Length'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvFieldInfoPrecision: TIntegerField
      FieldName = 'Precision'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvFieldInfoDisplayFormat: TStringField
      FieldName = 'DisplayFormat'
      ProviderFlags = [pfInUpdate]
      Size = 30
    end
    object cdSrvFieldInfoEditFormat: TStringField
      FieldName = 'EditFormat'
      ProviderFlags = [pfInUpdate]
      Size = 30
    end
    object cdSrvFieldInfoFieldStatus: TIntegerField
      FieldName = 'FieldStatus'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvFieldInfoNotForCopy: TBooleanField
      FieldName = 'NotForCopy'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvFieldInfoCustomGetText: TBooleanField
      FieldName = 'CustomGetText'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvFieldInfoCalcTotal: TBooleanField
      FieldName = 'CalcTotal'
      ProviderFlags = []
    end
    object cdSrvFieldInfoLookupDicID: TIntegerField
      FieldName = 'LookupDicID'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvFieldInfoLookupKeyField: TStringField
      FieldName = 'LookupKeyField'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object cdSrvFieldInfoIsCost: TBooleanField
      FieldName = 'IsCost'
      ProviderFlags = [pfInUpdate]
    end
  end
  object aqServices: TADOQuery
    Connection = dm.cnCalc
    Parameters = <>
    SQL.Strings = (
      'SELECT SrvID, SrvName, SrvDesc, SrvActive,'
      'OnChange, OnNewRecord, OnCalcFields, OnParamChange, OnSetPrices,'
      
        'OnCheck, AssignCalcFields, AssignDataChange, AssignNewRecord, Se' +
        'rviceKind,'
      
        'StoreSettings, OnlyWorkOrder, ShowInReport, UseInTotal, UseInPro' +
        'fitMode, '
      'ShowInProfit, NotForCopy, OnGetText, OnItemParams,'
      'BeforeInsert, AssignBeforeInsert, '
      
        'BaseSrvID, AfterOpen, EnableAfterOpen, EnablePlanning, EnableTra' +
        'cking,'
      
        'HideItem, EnableBeforeScroll, EnableAfterScroll, BeforeScroll, A' +
        'fterScroll,'
      
        'EnableAfterOrderOpen, AfterOrderOpen, IsContent, OnCreateNotPlan' +
        'ned,'
      'OnCreateDayPlan, OnNotPlannedCalcFields, OnDayPlanCalcFields,'
      'OnGetNotPlannedSQL, OnGetDayPlanSQL, OnCreateNotPlannedColumns,'
      
        'OnCreateDayPlanColumns, OnGetProductionSQL, OnCreateProductionCo' +
        'lumns,'
      
        'OnCreateProduction, OnProductionCalcFields, OnEstimateDuration, ' +
        'LinkedProcessID,'
      
        'DefaultEquipGroupCode, SequenceOrder, BeforeDelete, EnableBefore' +
        'Delete,'
      'EnableLinking, DefaultContractorProcess'
      'FROM Services'
      'order by SrvActive DESC, SrvDesc')
    Left = 16
    Top = 10
    object aqServicesSrvID: TAutoIncField
      FieldName = 'SrvID'
      ReadOnly = True
    end
    object aqServicesSrvName: TStringField
      FieldName = 'SrvName'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object aqServicesSrvDesc: TStringField
      FieldName = 'SrvDesc'
      ProviderFlags = [pfInUpdate]
      Size = 60
    end
    object aqServicesSrvActive: TBooleanField
      FieldName = 'SrvActive'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesOnChange: TMemoField
      FieldName = 'OnChange'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesOnNewRecord: TMemoField
      FieldName = 'OnNewRecord'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesOnCalcFields: TMemoField
      FieldName = 'OnCalcFields'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesOnParamChange: TMemoField
      FieldName = 'OnParamChange'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesOnSetPrices: TMemoField
      FieldName = 'OnSetPrices'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesOnCheck: TMemoField
      FieldName = 'OnCheck'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesOnGetText: TMemoField
      FieldName = 'OnGetText'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesOnItemParams: TMemoField
      FieldName = 'OnItemParams'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesBeforeInsert: TMemoField
      FieldName = 'BeforeInsert'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesAfterOpen: TMemoField
      FieldName = 'AfterOpen'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesAssignCalcFields: TBooleanField
      FieldName = 'AssignCalcFields'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesAssignDataChange: TBooleanField
      FieldName = 'AssignDataChange'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesAssignNewRecord: TBooleanField
      FieldName = 'AssignNewRecord'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesAssignBeforeInsert: TBooleanField
      FieldName = 'AssignBeforeInsert'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesServiceKind: TIntegerField
      FieldName = 'ServiceKind'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesStoreSettings: TBooleanField
      FieldName = 'StoreSettings'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesOnlyWorkOrder: TBooleanField
      FieldName = 'OnlyWorkOrder'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesShowInReport: TBooleanField
      FieldName = 'ShowInReport'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesNotForCopy: TBooleanField
      FieldName = 'NotForCopy'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesBaseSrvID: TIntegerField
      FieldName = 'BaseSrvID'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesEnableAfterOpen: TBooleanField
      FieldName = 'EnableAfterOpen'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesEnablePlanning: TBooleanField
      FieldName = 'EnablePlanning'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesEnableTracking: TBooleanField
      FieldName = 'EnableTracking'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesShowInProfit: TBooleanField
      FieldName = 'ShowInProfit'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesUseInProfitMode: TIntegerField
      FieldName = 'UseInProfitMode'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesUseInTotal: TBooleanField
      FieldName = 'UseInTotal'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesHideItem: TBooleanField
      FieldName = 'HideItem'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesEnableBeforeScroll: TBooleanField
      FieldName = 'EnableBeforeScroll'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesEnableAfterScroll: TBooleanField
      FieldName = 'EnableAfterScroll'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesBeforeScroll: TMemoField
      FieldName = 'BeforeScroll'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesAfterScroll: TMemoField
      FieldName = 'AfterScroll'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesEnableAfterOrderOpen: TBooleanField
      FieldName = 'EnableAfterOrderOpen'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesAfterOrderOpen: TMemoField
      FieldName = 'AfterOrderOpen'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesIsContent: TBooleanField
      FieldName = 'IsContent'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesDefaultEquipGroupCode: TIntegerField
      FieldName = 'DefaultEquipGroupCode'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesOnCreateNotPlanned: TMemoField
      FieldName = 'OnCreateNotPlanned'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesOnCreateDayPlan: TMemoField
      FieldName = 'OnCreateDayPlan'
      BlobType = ftMemo
    end
    object aqServicesOnNotPlannedCalcFields: TMemoField
      FieldName = 'OnNotPlannedCalcFields'
      BlobType = ftMemo
    end
    object aqServicesOnDayPlanCalcFields: TMemoField
      FieldName = 'OnDayPlanCalcFields'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesOnGetDayPlanSQL: TMemoField
      FieldName = 'OnGetDayPlanSQL'
      BlobType = ftMemo
    end
    object aqServicesOnGetNotPlannedSQL: TMemoField
      FieldName = 'OnGetNotPlannedSQL'
      BlobType = ftMemo
    end
    object aqServicesOnCreateNotPlannedColumns: TMemoField
      FieldName = 'OnCreateNotPlannedColumns'
      BlobType = ftMemo
    end
    object aqServicesOnCreateDayPlanColumns: TMemoField
      FieldName = 'OnCreateDayPlanColumns'
      BlobType = ftMemo
    end
    object aqServicesOnCreateProduction: TMemoField
      FieldName = 'OnCreateProduction'
      BlobType = ftMemo
    end
    object aqServicesOnGetProductionSQL: TMemoField
      FieldName = 'OnGetProductionSQL'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesOnCreateProductionColumns: TMemoField
      FieldName = 'OnCreateProductionColumns'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesOnProductionCalcFields: TMemoField
      FieldName = 'OnProductionCalcFields'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesOnEstimateDuration: TMemoField
      FieldName = 'OnEstimateDuration'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesLinkedProcessID: TIntegerField
      FieldName = 'LinkedProcessID'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesSequenceOrder: TIntegerField
      FieldName = 'SequenceOrder'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesEnableBeforeDelete: TBooleanField
      FieldName = 'EnableBeforeDelete'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesBeforeDelete: TMemoField
      FieldName = 'BeforeDelete'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqServicesEnableLinking: TBooleanField
      FieldName = 'EnableLinking'
      ProviderFlags = [pfInUpdate]
    end
    object aqServicesDefaultContractorProcess: TBooleanField
      FieldName = 'DefaultContractorProcess'
      ProviderFlags = [pfInUpdate]
    end
  end
  object aqSrvGrps: TADOQuery
    Connection = dm.cnCalc
    Parameters = <>
    SQL.Strings = (
      'SELECT GrpID, GrpNumber, GrpDesc'
      'from SrvGroups order by GrpNumber')
    Left = 236
    Top = 4
    object aqSrvGrpsGrpID: TAutoIncField
      FieldName = 'GrpID'
      ReadOnly = True
    end
    object aqSrvGrpsGrpNumber: TIntegerField
      FieldName = 'GrpNumber'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvGrpsGrpDesc: TStringField
      FieldName = 'GrpDesc'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
  end
  object aspNewSrv: TADOStoredProc
    Connection = dm.cnCalc
    ProcedureName = 'up_NewService;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@SrvName'
        Attributes = [paNullable]
        DataType = ftString
        Size = 40
        Value = Null
      end
      item
        Name = '@SrvDesc'
        Attributes = [paNullable]
        DataType = ftString
        Size = 60
        Value = Null
      end
      item
        Name = '@SrvActive'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@AssignCalcFields'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@AssignDataChange'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@AssignNewRecord'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@AssignBeforeInsert'
        Size = -1
        Value = Null
      end
      item
        Name = '@ServiceKind'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@StoreSettings'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@OnlyWorkOrder'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@ShowInProfit'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@ShowInReport'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@UseInProfitMode'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@UseInTotal'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@NotForCopy'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@BaseSrvID'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@EnableAfterOpen'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@EnablePlanning'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@EnableTracking'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@HideItem'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@EnableBeforeScroll'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@EnableAfterScroll'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@EnableAfterOrderOpen'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@EnableBeforeDelete'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@DefaultEquipGroupCode'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@IsContent'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@LinkedProcessID'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@SequenceOrder'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@EnableLinking'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@DefaultContractorProcess'
        DataType = ftBoolean
        Value = Null
      end>
    Left = 22
    Top = 172
  end
  object aqParams: TADOQuery
    Connection = dm.cnCalc
    Parameters = <>
    SQL.Strings = (
      'select ParamID, ParName, ParDesc'
      'from OrderParams')
    Left = 220
    Top = 164
    object aqParamsParamID: TAutoIncField
      FieldName = 'ParamID'
      ReadOnly = True
    end
    object aqParamsParName: TStringField
      FieldName = 'ParName'
      ProviderFlags = [pfInUpdate]
      Size = 32
    end
    object aqParamsParDesc: TStringField
      FieldName = 'ParDesc'
      ProviderFlags = [pfInUpdate]
      Size = 80
    end
  end
  object aqSrvFieldInfo: TADOQuery
    Connection = dm.cnCalc
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select SrvFieldID, SrvID, [FieldName], FieldDesc, [FieldType], [' +
        'Length], [Precision],'
      
        'DisplayFormat, EditFormat, FieldStatus, [MinValue], [MaxValue], ' +
        'NotForCopy, CustomGetText,'
      'CalcTotal, LookupDicID, LookupKeyField, IsCost'
      'from SrvFields'
      'order by SrvFieldID')
    Left = 96
    Top = 250
    object aqSrvFieldInfoSrvFieldID: TIntegerField
      FieldName = 'SrvFieldID'
    end
    object aqSrvFieldInfoSrvID: TIntegerField
      FieldName = 'SrvID'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvFieldInfoFieldName: TStringField
      FieldName = 'FieldName'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object aqSrvFieldInfoFieldDesc: TStringField
      FieldName = 'FieldDesc'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object aqSrvFieldInfoDisplayFormat: TStringField
      FieldName = 'DisplayFormat'
      ProviderFlags = [pfInUpdate]
      Size = 30
    end
    object aqSrvFieldInfoEditFormat: TStringField
      FieldName = 'EditFormat'
      ProviderFlags = [pfInUpdate]
      Size = 30
    end
    object aqSrvFieldInfoFieldType: TIntegerField
      FieldName = 'FieldType'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvFieldInfoLength: TIntegerField
      FieldName = 'Length'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvFieldInfoPrecision: TIntegerField
      FieldName = 'Precision'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvFieldInfoFieldStatus: TIntegerField
      FieldName = 'FieldStatus'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvFieldInfoMinValue: TIntegerField
      FieldName = 'MinValue'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvFieldInfoMaxValue: TIntegerField
      FieldName = 'MaxValue'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvFieldInfoNotForCopy: TBooleanField
      FieldName = 'NotForCopy'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvFieldInfoCustomGetText: TBooleanField
      FieldName = 'CustomGetText'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvFieldInfoCalcTotal: TBooleanField
      FieldName = 'CalcTotal'
      ProviderFlags = []
    end
    object aqSrvFieldInfoLookupDicID: TIntegerField
      FieldName = 'LookupDicID'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvFieldInfoLookupKeyField: TStringField
      FieldName = 'LookupKeyField'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object aqSrvFieldInfoIsCost: TBooleanField
      FieldName = 'IsCost'
      ProviderFlags = [pfInUpdate]
    end
  end
  object aqSrvGridCols: TADOQuery
    Connection = dm.cnCalc
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select ColID, GridID, ColNumber, Alignment, FontBold, FontItalic' +
        ', Color, FieldName,'
      
        'ReadOnly, Caption, CaptionFontBold, CaptionFontItalic, CaptionAl' +
        'ignment,'
      
        'CaptionColor, FontColor, CaptionFontColor, Visible, PriceColumn,' +
        ' CostColumn, ShowEditButton'
      'from SrvGridColumns'
      'order by GridID, ColNumber')
    Left = 28
    Top = 344
    object aqSrvGridColsColID: TAutoIncField
      FieldName = 'ColID'
      ReadOnly = True
    end
    object aqSrvGridColsSrvID: TIntegerField
      FieldName = 'GridID'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvGridColsColNumber: TIntegerField
      FieldName = 'ColNumber'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvGridColsAlignment: TIntegerField
      FieldName = 'Alignment'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvGridColsColor: TIntegerField
      FieldName = 'Color'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvGridColsFieldName: TStringField
      FieldName = 'FieldName'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object aqSrvGridColsReadOnly: TBooleanField
      FieldName = 'ReadOnly'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvGridColsCaption: TStringField
      FieldName = 'Caption'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object aqSrvGridColsCaptionAlignment: TIntegerField
      FieldName = 'CaptionAlignment'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvGridColsCaptionColor: TIntegerField
      FieldName = 'CaptionColor'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvGridColsFontColor: TIntegerField
      FieldName = 'FontColor'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvGridColsCaptionFontColor: TIntegerField
      FieldName = 'CaptionFontColor'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvGridColsFontBold: TBooleanField
      FieldName = 'FontBold'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvGridColsFontItalic: TBooleanField
      FieldName = 'FontItalic'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvGridColsCaptionFontBold: TBooleanField
      FieldName = 'CaptionFontBold'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvGridColsCaptionFontItalic: TBooleanField
      FieldName = 'CaptionFontItalic'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvGridColsVisible: TBooleanField
      FieldName = 'Visible'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvGridColsProtected: TBooleanField
      FieldName = 'PriceColumn'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvGridColsCostColumn: TBooleanField
      FieldName = 'CostColumn'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvGridColsShowEditButton: TBooleanField
      FieldName = 'ShowEditButton'
      ProviderFlags = [pfInUpdate]
    end
  end
  object pvSrvGridCols: TDataSetProvider
    DataSet = aqSrvGridCols
    Options = [poAllowMultiRecordUpdates]
    UpdateMode = upWhereKeyOnly
    Left = 96
    Top = 344
  end
  object cdSrvGridCols: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvSrvGridCols'
    Left = 168
    Top = 344
    object cdSrvGridColsColID: TAutoIncField
      FieldName = 'ColID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object cdSrvGridColsSrvID: TIntegerField
      FieldName = 'GridID'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvGridColsColNumber: TIntegerField
      FieldName = 'ColNumber'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvGridColsAlignment: TIntegerField
      FieldName = 'Alignment'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvGridColsColor: TIntegerField
      FieldName = 'Color'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvGridColsFieldName: TStringField
      FieldName = 'FieldName'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdSrvGridColsReadOnly: TBooleanField
      FieldName = 'ReadOnly'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvGridColsCaption: TStringField
      FieldName = 'Caption'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdSrvGridColsCaptionAlignment: TIntegerField
      FieldName = 'CaptionAlignment'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvGridColsCaptionColor: TIntegerField
      FieldName = 'CaptionColor'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvGridColsFontColor: TIntegerField
      FieldName = 'FontColor'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvGridColsCaptionFontColor: TIntegerField
      FieldName = 'CaptionFontColor'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvGridColsFontBold: TBooleanField
      FieldName = 'FontBold'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvGridColsFontItalic: TBooleanField
      FieldName = 'FontItalic'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvGridColsCaptionFontBold: TBooleanField
      FieldName = 'CaptionFontBold'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvGridColsCaptionFontItalic: TBooleanField
      FieldName = 'CaptionFontItalic'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvGridColsVisible: TBooleanField
      FieldName = 'Visible'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvGridColsProtected: TBooleanField
      FieldName = 'PriceColumn'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvGridColsCostColumn: TBooleanField
      FieldName = 'CostColumn'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvGridColsShowEditButton: TBooleanField
      FieldName = 'ShowEditButton'
      ProviderFlags = [pfInUpdate]
    end
  end
  object cdOldSrvStruct: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeDelete = SrvStructBeforeDelete
    OnNewRecord = StructNewRecord
    Left = 100
    Top = 406
    object cdOldSrvStructID: TIntegerField
      FieldName = 'ID'
    end
    object cdOldSrvStructFieldName: TStringField
      FieldName = 'FieldName'
      Size = 40
    end
    object cdOldSrvStructFieldDesc: TStringField
      FieldName = 'FieldDesc'
      Size = 40
    end
    object cdOldSrvStructFieldType: TIntegerField
      FieldName = 'FieldType'
      OnChange = SrvFieldTypeChange
    end
    object cdOldSrvStructLength: TIntegerField
      FieldName = 'Length'
    end
    object cdOldSrvStructPrecision: TIntegerField
      FieldName = 'Precision'
    end
    object cdOldSrvStructDisplayFormat: TStringField
      FieldName = 'DisplayFormat'
      Size = 30
    end
    object cdOldSrvStructEditFormat: TStringField
      FieldName = 'EditFormat'
      Size = 30
    end
    object cdOldSrvStructPredefined: TBooleanField
      FieldName = 'Predefined'
    end
    object cdOldSrvStructFieldStatus: TIntegerField
      FieldName = 'FieldStatus'
    end
    object cdOldSrvStructNotForCopy: TBooleanField
      FieldName = 'NotForCopy'
    end
    object cdOldSrvStructCustomGetText: TBooleanField
      FieldName = 'CustomGetText'
    end
    object cdOldSrvStructCalcTotal: TBooleanField
      FieldName = 'CalcTotal'
    end
    object cdOldSrvStructLookupDicID: TIntegerField
      FieldName = 'LookupDicID'
    end
    object cdOldSrvStructLookupKeyField: TStringField
      FieldName = 'LookupKeyField'
      Size = 40
    end
    object cdOldSrvStructIsCost: TBooleanField
      FieldName = 'IsCost'
      ProviderFlags = [pfInUpdate]
    end
  end
  object cdSrvStruct: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeDelete = SrvStructBeforeDelete
    OnNewRecord = StructNewRecord
    Left = 22
    Top = 408
    object cdSrvStructID: TIntegerField
      FieldName = 'ID'
    end
    object cdSrvStructFieldName: TStringField
      FieldName = 'FieldName'
      Size = 40
    end
    object cdSrvStructFieldDesc: TStringField
      FieldName = 'FieldDesc'
      Size = 40
    end
    object cdSrvStructFieldType: TIntegerField
      FieldName = 'FieldType'
      OnChange = SrvFieldTypeChange
    end
    object cdSrvStructLength: TIntegerField
      FieldName = 'Length'
    end
    object cdSrvStructPrecision: TIntegerField
      FieldName = 'Precision'
    end
    object cdSrvStructPredefined: TBooleanField
      FieldName = 'Predefined'
    end
    object cdSrvStructDisplayFormat: TStringField
      FieldName = 'DisplayFormat'
      Size = 30
    end
    object cdSrvStructEditFormat: TStringField
      FieldName = 'EditFormat'
      Size = 30
    end
    object cdSrvStructFieldStatus: TIntegerField
      FieldName = 'FieldStatus'
    end
    object cdSrvStructNotForCopy: TBooleanField
      FieldName = 'NotForCopy'
    end
    object cdSrvStructCustomGetText: TBooleanField
      FieldName = 'CustomGetText'
    end
    object cdSrvStructCalcTotal: TBooleanField
      FieldName = 'CalcTotal'
    end
    object cdSrvStructLookupDicID: TIntegerField
      FieldName = 'LookupDicID'
    end
    object cdSrvStructLookupKeyField: TStringField
      FieldName = 'LookupKeyField'
      Size = 40
    end
    object cdSrvStructIsCost: TBooleanField
      FieldName = 'IsCost'
      ProviderFlags = [pfInUpdate]
    end
  end
  object dsParams: TDataSource
    DataSet = cdParams
    Left = 292
    Top = 188
  end
  object dsSrvGridCols: TDataSource
    DataSet = cdSrvGridCols
    Left = 236
    Top = 344
  end
  object dsSrvFieldInfo: TDataSource
    DataSet = cdSrvFieldInfo
    Left = 252
    Top = 264
  end
  object aspDelSrv: TADOStoredProc
    Connection = dm.cnCalc
    ProcedureName = 'up_DeleteService;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@SrvID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 88
    Top = 176
  end
  object aqPageGrids: TADOQuery
    Connection = dm.cnCalc
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select pg.GridID, p.SrvDesc, pg.PageOrderNum, pg.ProcessPageID, ' +
        'pg.GridCaption '
      
        'from ProcessGrids pg inner join Services p on pg.ProcessID = p.S' +
        'rvID'
      'where p.SrvActive = 1'
      'order by pg.PageOrderNum')
    Left = 372
    Top = 140
    object aqPageGridsSrvID: TAutoIncField
      FieldName = 'GridID'
      ProviderFlags = [pfInWhere]
      ReadOnly = True
    end
    object aqPageGridsSrvDesc: TStringField
      FieldName = 'SrvDesc'
      ProviderFlags = []
      Size = 60
    end
    object aqPageGridsPageOrderNum: TIntegerField
      FieldName = 'PageOrderNum'
      ProviderFlags = [pfInUpdate]
    end
    object aqPageGridsSrvPageID: TIntegerField
      FieldName = 'ProcessPageID'
      ProviderFlags = []
    end
    object aqPageGridsGridCaption: TStringField
      FieldName = 'GridCaption'
      Size = 80
    end
  end
  object pvPageGrids: TDataSetProvider
    DataSet = aqPageGrids
    Options = [poAllowMultiRecordUpdates]
    UpdateMode = upWhereChanged
    Left = 428
    Top = 140
  end
  object dsPageGrids: TDataSource
    DataSet = cdPageGrids
    Left = 540
    Top = 140
  end
  object cdPageGrids: TClientDataSet
    Aggregates = <>
    Filtered = True
    Params = <>
    ProviderName = 'pvPageGrids'
    Left = 488
    Top = 140
    object cdPageGridsSrvID: TAutoIncField
      FieldName = 'GridID'
      ProviderFlags = [pfInWhere]
      ReadOnly = True
    end
    object cdPageGridsSrvDesc: TStringField
      FieldName = 'SrvDesc'
      ProviderFlags = []
      Size = 60
    end
    object cdPageGridsGrpOrderNum: TIntegerField
      FieldName = 'PageOrderNum'
      ProviderFlags = [pfInUpdate]
    end
    object cdPageGridsSrvPageID: TIntegerField
      FieldName = 'ProcessPageID'
      ProviderFlags = []
    end
    object cdPageGridsGridCaption: TStringField
      FieldName = 'GridCaption'
      ProviderFlags = [pfInUpdate]
      Size = 80
    end
  end
  object dsSrvPages: TDataSource
    DataSet = cdSrvPages
    Left = 408
    Top = 52
  end
  object cdSrvPages: TClientDataSet
    Aggregates = <>
    Filtered = True
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'cdSrvPagesIndex1'
        Fields = 'GrpOrderNum'
      end>
    Params = <>
    ProviderName = 'pvSrvPages'
    StoreDefs = True
    Left = 352
    Top = 56
    object cdSrvPagesSrvPageID: TAutoIncField
      FieldName = 'ProcessPageID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object cdSrvPagesPageCaption: TStringField
      FieldName = 'PageCaption'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdSrvPagesGrpID: TIntegerField
      FieldName = 'GrpID'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvPagesGrpOrderNum: TIntegerField
      FieldName = 'GrpOrderNum'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvPagesPageBuiltIn: TBooleanField
      FieldName = 'PageBuiltIn'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvPagesCreateFrameOnShow: TBooleanField
      FieldName = 'CreateFrameOnShow'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvPagesGrpNumber: TIntegerField
      FieldName = 'GrpNumber'
      ProviderFlags = []
    end
    object cdSrvPagesOnCreateFrame: TMemoField
      FieldName = 'OnCreateFrame'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdSrvPagesEnableOnCreateFrame: TBooleanField
      FieldName = 'EnableOnCreateFrame'
      ProviderFlags = [pfInUpdate]
    end
    object cdSrvPagesEmptyFrame: TBooleanField
      FieldName = 'EmptyFrame'
      ProviderFlags = [pfInUpdate]
    end
  end
  object aqSrvPages: TADOQuery
    Connection = dm.cnCalc
    Parameters = <>
    SQL.Strings = (
      'select ProcessPageID, PageCaption, sp.GrpID, GrpOrderNum, '
      
        '  sp.CreateFrameOnShow, sg.GrpNumber, sp.PageBuiltIn, sp.OnCreat' +
        'eFrame,'
      '  sp.EnableOnCreateFrame, sp.EmptyFrame'
      'from SrvPages sp inner join SrvGroups sg '
      'on sp.GrpID = sg.GrpID'
      'order by sg.GrpNumber, GrpOrderNum')
    Left = 236
    Top = 56
    object aqSrvPagesSrvPageID: TAutoIncField
      FieldName = 'ProcessPageID'
      ReadOnly = True
    end
    object aqSrvPagesPageCaption: TStringField
      FieldName = 'PageCaption'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object aqSrvPagesGrpID: TIntegerField
      FieldName = 'GrpID'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvPagesGrpOrderNum: TIntegerField
      FieldName = 'GrpOrderNum'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvPagesPageBuiltIn: TBooleanField
      FieldName = 'PageBuiltIn'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvPagesCreateFrameOnShow: TBooleanField
      FieldName = 'CreateFrameOnShow'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvPagesGrpNumber: TIntegerField
      FieldName = 'GrpNumber'
      ProviderFlags = []
    end
    object aqSrvPagesOnCreateFrame: TMemoField
      FieldName = 'OnCreateFrame'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqSrvPagesEnableOnCreateFrame: TBooleanField
      FieldName = 'EnableOnCreateFrame'
      ProviderFlags = [pfInUpdate]
    end
    object aqSrvPagesEmptyFrame: TBooleanField
      FieldName = 'EmptyFrame'
      ProviderFlags = [pfInUpdate]
    end
  end
  object pvSrvPages: TDataSetProvider
    DataSet = aqSrvPages
    Options = [poAllowMultiRecordUpdates]
    UpdateMode = upWhereKeyOnly
    Left = 292
    Top = 56
  end
  object aspNewSrvGrp: TADOStoredProc
    Connection = dm.cnCalc
    ProcedureName = 'up_NewSrvGroup;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@GrpNumber'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@GrpDesc'
        Attributes = [paNullable]
        DataType = ftString
        Size = 40
        Value = Null
      end
      item
        Name = '@ID'
        Attributes = [paNullable]
        DataType = ftInteger
        Direction = pdInputOutput
        Precision = 10
        Value = Null
      end>
    Left = 420
    Top = 206
  end
  object aspDelSrvGrp: TADOStoredProc
    Connection = dm.cnCalc
    ProcedureName = 'up_DelSrvGroup;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@GrpID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 496
    Top = 204
  end
  object dsProcessGrids: TDataSource
    DataSet = cdProcessGrids
    Left = 636
    Top = 32
  end
  object cdProcessGrids: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvProcessGrids'
    Left = 596
    Top = 48
    object cdProcessGridsGridID: TAutoIncField
      FieldName = 'GridID'
      ReadOnly = True
    end
    object cdProcessGridsProcessID: TIntegerField
      FieldName = 'ProcessID'
      ProviderFlags = [pfInUpdate]
    end
    object cdProcessGridsProcessPageID: TIntegerField
      FieldName = 'ProcessPageID'
      ProviderFlags = [pfInUpdate]
    end
    object cdProcessGridsPageOrderNum: TIntegerField
      FieldName = 'PageOrderNum'
      ProviderFlags = [pfInUpdate]
    end
    object cdProcessGridsGridName: TStringField
      FieldName = 'GridName'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdProcessGridsGridCaption: TStringField
      FieldName = 'GridCaption'
      ProviderFlags = [pfInUpdate]
      Size = 80
    end
    object cdProcessGridsShowControlPanel: TBooleanField
      FieldName = 'ShowControlPanel'
      ProviderFlags = [pfInUpdate]
    end
    object cdProcessGridsAssignDrawCell: TBooleanField
      FieldName = 'AssignDrawCell'
      ProviderFlags = [pfInUpdate]
    end
    object cdProcessGridsEditableGrid: TBooleanField
      FieldName = 'EditableGrid'
      ProviderFlags = [pfInUpdate]
    end
    object cdProcessGridsOnContextPopup: TMemoField
      FieldName = 'OnContextPopup'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdProcessGridsOnSelectPopup: TMemoField
      FieldName = 'OnSelectPopup'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdProcessGridsOnDrawCell: TMemoField
      FieldName = 'OnDrawCell'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdProcessGridsGridColor: TIntegerField
      FieldName = 'GridColor'
      ProviderFlags = [pfInUpdate]
    end
    object cdProcessGridsAssignGridEnter: TBooleanField
      FieldName = 'AssignGridEnter'
      ProviderFlags = [pfInUpdate]
    end
    object cdProcessGridsOnGridEnter: TMemoField
      FieldName = 'OnGridEnter'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdProcessGridsTotalFieldName: TStringField
      FieldName = 'TotalFieldName'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdProcessGridsTotalWorkFieldName: TStringField
      FieldName = 'TotalWorkFieldName'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdProcessGridsTotalMatFieldName: TStringField
      FieldName = 'TotalMatFieldName'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdProcessGridsBaseGridID: TIntegerField
      FieldName = 'BaseGridID'
      ProviderFlags = [pfInUpdate]
    end
    object cdProcessGridsOnCalcTotal: TMemoField
      FieldName = 'OnCalcTotal'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object cdProcessGridsEnableCalcTotalCost: TBooleanField
      FieldName = 'EnableCalcTotalCost'
      ProviderFlags = [pfInUpdate]
    end
  end
  object aqProcessGrids: TADOQuery
    Connection = dm.cnCalc
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select GridID, ProcessID, ProcessPageID, PageOrderNum, '
      
        'GridName, GridCaption, ShowControlPanel, AssignDrawCell, Editabl' +
        'eGrid,'
      
        'OnContextPopup, OnSelectPopup, OnDrawCell, GridColor, AssignGrid' +
        'Enter,'
      
        'OnGridEnter, TotalFieldName, TotalWorkFieldName, TotalMatFieldNa' +
        'me,'
      'BaseGridID, EnableCalcTotalCost, OnCalcTotal'
      'from ProcessGrids'
      'order by GridID')
    Left = 532
    Top = 20
    object aqProcessGridsGridID: TAutoIncField
      FieldName = 'GridID'
      ReadOnly = True
    end
    object aqProcessGridsProcessID: TIntegerField
      FieldName = 'ProcessID'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessGridsProcessPageID: TIntegerField
      FieldName = 'ProcessPageID'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessGridsPageOrderNum: TIntegerField
      FieldName = 'PageOrderNum'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessGridsGridName: TStringField
      FieldName = 'GridName'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object aqProcessGridsGridCaption: TStringField
      FieldName = 'GridCaption'
      ProviderFlags = [pfInUpdate]
      Size = 80
    end
    object aqProcessGridsShowControlPanel: TBooleanField
      FieldName = 'ShowControlPanel'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessGridsAssignDrawCell: TBooleanField
      FieldName = 'AssignDrawCell'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessGridsEditableGrid: TBooleanField
      FieldName = 'EditableGrid'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessGridsOnContextPopup: TMemoField
      FieldName = 'OnContextPopup'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqProcessGridsOnSelectPopup: TMemoField
      FieldName = 'OnSelectPopup'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqProcessGridsOnDrawCell: TMemoField
      FieldName = 'OnDrawCell'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqProcessGridsGridColor: TIntegerField
      FieldName = 'GridColor'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessGridsAssignGridEnter: TBooleanField
      FieldName = 'AssignGridEnter'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessGridsOnGridEnter: TMemoField
      FieldName = 'OnGridEnter'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
    object aqProcessGridsTotalFieldName: TStringField
      FieldName = 'TotalFieldName'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object aqProcessGridsTotalWorkFieldName: TStringField
      DisplayWidth = 50
      FieldName = 'TotalWorkFieldName'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object aqProcessGridsTotalMatFieldName: TStringField
      FieldName = 'TotalMatFieldName'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object aqProcessGridsBaseGridID: TIntegerField
      FieldName = 'BaseGridID'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessGridsEnableCalcTotalCost: TBooleanField
      FieldName = 'EnableCalcTotalCost'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessGridsOnCalcTotal: TMemoField
      FieldName = 'OnCalcTotal'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
    end
  end
  object pvProcessGrids: TDataSetProvider
    DataSet = aqProcessGrids
    Options = [poAllowMultiRecordUpdates]
    UpdateMode = upWhereKeyOnly
    Left = 588
    Top = 8
  end
  object aqOrderKind: TADOQuery
    Connection = dm.cnCalc
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select KindID, KindDesc, MainProcessID from KindOrder order by K' +
        'indID')
    Left = 412
    Top = 274
    object aqOrderKindKindID: TAutoIncField
      FieldName = 'KindID'
      ReadOnly = True
    end
    object aqOrderKindKindDesc: TStringField
      FieldName = 'KindDesc'
      ProviderFlags = [pfInUpdate]
      Size = 80
    end
    object aqOrderKindMainProcessID: TIntegerField
      FieldName = 'MainProcessID'
      ProviderFlags = [pfInUpdate]
    end
  end
  object aqKindProcess: TADOQuery
    Connection = dm.cnCalc
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select KindProcessID, KindID, AutoAddDraft, AutoAddWork, kp.Proc' +
        'essID, ss.SrvDesc as ProcessName1'
      
        'from KindProcess kp inner join Services ss on kp.ProcessID = ss.' +
        'SrvID'
      'order by KindProcessID')
    Left = 410
    Top = 332
    object aqKindProcessKindProcessID: TAutoIncField
      FieldName = 'KindProcessID'
      ReadOnly = True
    end
    object aqKindProcessProcessID: TIntegerField
      FieldName = 'ProcessID'
      ProviderFlags = [pfInUpdate]
    end
    object aqKindProcessKindID: TIntegerField
      FieldName = 'KindID'
      ProviderFlags = [pfInUpdate]
    end
    object aqKindProcessAutoAddDraft: TBooleanField
      FieldName = 'AutoAddDraft'
      ProviderFlags = [pfInUpdate]
    end
    object aqKindProcessAutoAddWork: TBooleanField
      FieldName = 'AutoAddWork'
      ProviderFlags = [pfInUpdate]
    end
    object aqKindProcessProcessName1: TStringField
      FieldName = 'ProcessName1'
      ProviderFlags = []
      Size = 60
    end
  end
  object cdKindProcess: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'KindProcessID'
        Attributes = [faReadonly]
        DataType = ftAutoInc
      end
      item
        Name = 'KindID'
        DataType = ftInteger
      end
      item
        Name = 'AutoAddDraft'
        DataType = ftBoolean
      end
      item
        Name = 'AutoAddWork'
        DataType = ftBoolean
      end>
    IndexDefs = <
      item
        Name = 'cdKindProcessIndex1'
        Fields = 'ProcessName1'
      end>
    IndexName = 'cdKindProcessIndex1'
    Params = <>
    ProviderName = 'pvKindProcess'
    StoreDefs = True
    OnNewRecord = cdKindProcessNewRecord
    Left = 548
    Top = 334
    object cdKindProcessKindProcessID: TAutoIncField
      FieldName = 'KindProcessID'
      ProviderFlags = [pfInUpdate]
      ReadOnly = True
    end
    object cdKindProcessKindID: TIntegerField
      FieldName = 'KindID'
      ProviderFlags = [pfInUpdate]
    end
    object cdKindProcessAutoAddDraft: TBooleanField
      FieldName = 'AutoAddDraft'
      ProviderFlags = [pfInUpdate]
    end
    object cdKindProcessAutoAddWork: TBooleanField
      FieldName = 'AutoAddWork'
      ProviderFlags = [pfInUpdate]
    end
    object cdKindProcessProcessName: TStringField
      FieldKind = fkLookup
      FieldName = 'ProcessName'
      LookupDataSet = cdServices
      LookupKeyFields = 'SrvID'
      LookupResultField = 'SrvDesc'
      KeyFields = 'ProcessID'
      ProviderFlags = []
      Size = 80
      Lookup = True
    end
    object cdKindProcessProcessID: TIntegerField
      FieldName = 'ProcessID'
      ProviderFlags = [pfInUpdate]
    end
    object cdKindProcessProcessName1: TStringField
      FieldName = 'ProcessName1'
      ProviderFlags = []
      Size = 60
    end
  end
  object cdOrderKind: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvOrderKind'
    Left = 536
    Top = 280
    object cdOrderKindKindID: TAutoIncField
      FieldName = 'KindID'
      ReadOnly = True
    end
    object cdOrderKindKindDesc: TStringField
      FieldName = 'KindDesc'
      ProviderFlags = [pfInUpdate]
      Size = 80
    end
    object cdOrderKindMainProcessID: TIntegerField
      FieldName = 'MainProcessID'
      ProviderFlags = [pfInUpdate]
    end
  end
  object dsOrderKind: TDataSource
    DataSet = cdOrderKind
    Left = 604
    Top = 278
  end
  object pvOrderKind: TDataSetProvider
    DataSet = aqOrderKind
    Constraints = False
    Options = [poAllowMultiRecordUpdates]
    UpdateMode = upWhereKeyOnly
    BeforeUpdateRecord = pvOrderKindBeforeUpdateRecord
    Left = 476
    Top = 276
  end
  object dsKindProcess: TDataSource
    DataSet = cdKindProcess
    Left = 620
    Top = 330
  end
  object pvKindProcess: TDataSetProvider
    DataSet = aqKindProcess
    Options = [poAllowMultiRecordUpdates]
    UpdateMode = upWhereKeyOnly
    BeforeUpdateRecord = pvKindProcessBeforeUpdateRecord
    Left = 472
    Top = 334
  end
  object aqKindPages: TADOQuery
    Connection = dm.cnCalc
    Parameters = <
      item
        Name = 'KindID'
        DataType = ftInteger
        Size = -1
        Value = 0
      end
      item
        Name = 'UserID'
        DataType = ftInteger
        Size = -1
        Value = 0
      end>
    SQL.Strings = (
      
        'select sp.ProcessPageID, sg.GrpNumber, sp.GrpOrderNum, pg.GridID' +
        ', pg.PageOrderNum, '
      
        'sp.PageCaption, sp.CreateFrameOnShow, sp.OnCreateFrame, sp.Enabl' +
        'eOnCreateFrame, '
      
        'sp.EmptyFrame, pg.ProcessID, akp.DraftInsert, akp.DraftUpdate, a' +
        'kp.DraftDelete,'
      
        'akp.WorkInsert, akp.WorkUpdate, akp.WorkDelete, akp.PlanDate, ak' +
        'p.FactDate,'
      'akp.WorkView, akp.DraftView, ss.OnlyWorkOrder'
      'from SrvPages sp inner join SrvGroups sg on sp.GrpID = sg.GrpID'
      
        '  inner join ProcessGrids pg on pg.ProcessPageID = sp.ProcessPag' +
        'eID'
      '  inner join Services ss on pg.ProcessID = ss.SrvID'
      '  inner join KindProcess kp on kp.ProcessID = pg.ProcessID'
      
        '  inner join AccessKindProcess akp on akp.ProcessID = pg.Process' +
        'ID and kp.KindID = akp.KindID'
      '--  inner join KindOrder ko on pg.ProcessID = ko.KindID'
      
        'where kp.KindID = :KindID and akp.UserID = :UserID and ss.SrvAct' +
        'ive = 1'
      'order by sg.GrpNumber, GrpOrderNum, pg.PageOrderNum')
    Left = 412
    Top = 394
  end
  object dsKindPages: TDataSource
    DataSet = cdKindPages
    Left = 616
    Top = 392
  end
  object cdKindPages: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvKindPages'
    Left = 552
    Top = 392
  end
  object pvKindPages: TDataSetProvider
    DataSet = aqKindPages
    Left = 478
    Top = 394
  end
  object dsPlan: TDataSource
    DataSet = cdPlan
    Left = 616
    Top = 452
  end
  object pvPlan: TDataSetProvider
    DataSet = aqPlan
    Left = 480
    Top = 452
  end
  object cdPlan: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 548
    Top = 456
  end
  object aqPlan: TADOQuery
    Connection = dm.cnCalc
    Parameters = <>
    Left = 416
    Top = 452
  end
end
