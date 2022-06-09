object adm: Tadm
  OldCreateOrder = False
  Height = 324
  Width = 390
  object cdAccessUser: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    ProviderName = 'pvAccessUser'
    AfterOpen = cdAccessUserAfterOpen
    OnNewRecord = cdAccessUserNewRecord
    Left = 182
    Top = 14
    object cdAccessUserAccessUserID: TAutoIncField
      FieldName = 'AccessUserID'
      ReadOnly = True
    end
    object cdAccessUserLogin: TStringField
      FieldName = 'Login'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object cdAccessUserName: TStringField
      FieldName = 'Name'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdAccessUserShortName: TStringField
      FieldName = 'ShortName'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserEditUsers: TBooleanField
      FieldName = 'EditUsers'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserEditDics: TBooleanField
      FieldName = 'EditDics'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserEditProcesses: TBooleanField
      FieldName = 'EditProcesses'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserEditModules: TBooleanField
      FieldName = 'EditModules'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserUploadFiles: TBooleanField
      FieldName = 'UploadFiles'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserSetCourse: TBooleanField
      FieldName = 'SetCourse'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserViewOwnOnly: TBooleanField
      FieldName = 'ViewOwnOnly'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserWorkViewOwnOnly: TBooleanField
      FieldName = 'WorkViewOwnOnly'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserDefaultKindID: TIntegerField
      FieldName = 'DefaultKindID'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserRoleID: TIntegerField
      FieldName = 'RoleID'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserIsRole: TBooleanField
      FieldName = 'IsRole'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserPermitPlanView: TBooleanField
      FieldName = 'PermitPlanView'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserAddCustomer: TBooleanField
      FieldName = 'AddCustomer'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserEditOwnCustomer: TBooleanField
      FieldName = 'EditOwnCustomer'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserEditOtherCustomer: TBooleanField
      FieldName = 'EditOtherCustomer'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserViewOtherCustomer: TBooleanField
      FieldName = 'ViewOtherCustomer'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserChangeCustomerOwner: TBooleanField
      FieldName = 'ChangeCustomerOwner'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserDataPaging: TBooleanField
      FieldName = 'DataPaging'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserViewReports: TBooleanField
      FieldName = 'ViewReports'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserEditCustomReports: TBooleanField
      FieldName = 'EditCustomReports'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserDeleteCustomReports: TBooleanField
      FieldName = 'DeleteCustomReports'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserViewPayments: TBooleanField
      FieldName = 'ViewPayments'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserEditPayments: TBooleanField
      FieldName = 'EditPayments'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserViewInvoices: TBooleanField
      FieldName = 'ViewInvoices'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserAddInvoices: TBooleanField
      FieldName = 'AddInvoices'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserDeleteInvoices: TBooleanField
      FieldName = 'DeleteInvoices'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserDescribeUbScheduleJob: TBooleanField
      FieldName = 'DescribeUnScheduleJob'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserViewNotPlanned: TBooleanField
      FieldName = 'ViewNotPlanned'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserViewProduction: TBooleanField
      FieldName = 'ViewProduction'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserContragentGroup: TIntegerField
      FieldName = 'ContragentGroup'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserShowDelayedOrders: TBooleanField
      FieldName = 'ShowDelayedOrders'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserViewShipment: TBooleanField
      FieldName = 'ViewShipment'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserAddShipment: TBooleanField
      FieldName = 'AddShipment'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserDeleteShipment: TBooleanField
      FieldName = 'DeleteShipment'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserShipmentApprovement: TBooleanField
      FieldName = 'ShipmentApprovement'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserViewMatRequests: TBooleanField
      FieldName = 'ViewMatRequests'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserUpdateMatPayDate: TBooleanField
      FieldName = 'UpdateMatPayDate'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserOrderMaterialsApprovement: TBooleanField
      FieldName = 'OrderMaterialsApprovement'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessUserAddPayments: TBooleanField
      FieldName = 'AddPayments'
    end
    object cdAccessUserSetPaymentStatus: TBooleanField
      FieldName = 'SetPaymentStatus'
    end
  end
  object pvAccessUser: TDataSetProvider
    DataSet = aqAccessUser
    Options = [poAllowMultiRecordUpdates]
    UpdateMode = upWhereKeyOnly
    OnUpdateError = pvAccessUserUpdateError
    BeforeUpdateRecord = pvAccessUserBeforeUpdateRecord
    Left = 108
    Top = 12
  end
  object cdAccessKind: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvAccessKind'
    Left = 184
    Top = 66
    object cdAccessKindAccessKindID: TAutoIncField
      FieldName = 'AccessKindID'
      ReadOnly = True
    end
    object cdAccessKindKindID: TIntegerField
      FieldName = 'KindID'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindUserID: TIntegerField
      FieldName = 'UserID'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindWorkCreate: TBooleanField
      FieldName = 'WorkCreate'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindDraftCreate: TBooleanField
      FieldName = 'DraftCreate'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindWorkUpdate: TBooleanField
      FieldName = 'WorkUpdateOwn'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindDraftUpdate: TBooleanField
      FieldName = 'DraftUpdateOwn'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindWorkDelete: TBooleanField
      FieldName = 'WorkDeleteOwn'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindDraftDelete: TBooleanField
      FieldName = 'DraftDeleteOwn'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindWorkUpdateOther: TBooleanField
      FieldName = 'WorkUpdateOther'
    end
    object cdAccessKindWorkDeleteOther: TBooleanField
      FieldName = 'WorkDeleteOther'
    end
    object cdAccessKindDraftUpdateOther: TBooleanField
      FieldName = 'DraftUpdateOther'
    end
    object cdAccessKindDraftDeleteOther: TBooleanField
      FieldName = 'DraftDeleteOther'
    end
    object cdAccessKindWorkBrowse: TBooleanField
      FieldName = 'WorkBrowse'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindDraftBrowse: TBooleanField
      FieldName = 'DraftBrowse'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindCheckOnSave: TBooleanField
      FieldName = 'CheckOnSave'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindWorkPriceView: TBooleanField
      FieldName = 'WorkPriceView'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindDraftPriceView: TBooleanField
      FieldName = 'DraftPriceView'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindWorkCostView: TBooleanField
      FieldName = 'WorkCostView'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindDraftCostView: TBooleanField
      FieldName = 'DraftCostView'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindMakeWork: TBooleanField
      FieldName = 'MakeWork'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindMakeDraft: TBooleanField
      FieldName = 'MakeDraft'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindPlanFinishDate: TBooleanField
      FieldName = 'PlanFinishDate'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindPlanStartDate: TBooleanField
      FieldName = 'PlanStartDate'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindFactFinishDate: TBooleanField
      FieldName = 'FactFinishDate'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindFactStartDate: TBooleanField
      FieldName = 'FactStartDate'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindWorkVisible: TBooleanField
      FieldName = 'WorkVisible'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindDraftVisible: TBooleanField
      FieldName = 'DraftVisible'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindShowProfitInside: TBooleanField
      FieldName = 'ShowProfitInside'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindShowProfitPreview: TBooleanField
      FieldName = 'ShowProfitPreview'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindModifyProfit: TBooleanField
      FieldName = 'ModifyProfit'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindViewOnlyProtected: TBooleanField
      FieldName = 'ViewOnlyProtected'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindCostProtection: TBooleanField
      FieldName = 'CostProtection'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindContentProtection: TBooleanField
      FieldName = 'ContentProtection'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindChangeOrderOwner: TBooleanField
      FieldName = 'ChangeOrderOwner'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindUpdatePayConditions: TBooleanField
      FieldName = 'UpdatePayConditions'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindCancelMaterialRequest: TBooleanField
      FieldName = 'CancelMaterialRequest'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindEditMaterialRequest: TBooleanField
      FieldName = 'EditMaterialRequest'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessKindFactCostView: TBooleanField
      FieldName = 'FactCostView'
      ProviderFlags = [pfInUpdate]
    end
  end
  object pvAccessKind: TDataSetProvider
    DataSet = aqAccessKind
    Options = [poAllowMultiRecordUpdates]
    UpdateMode = upWhereKeyOnly
    OnUpdateError = pvAccessUserUpdateError
    BeforeUpdateRecord = pvAccessKindBeforeUpdateRecord
    Left = 108
    Top = 66
  end
  object dsAccessKind: TDataSource
    DataSet = cdAccessKind
    Left = 262
    Top = 66
  end
  object cdAccessProc: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'cdAccessProcIndex2'
        Fields = 'ProcessID'
      end>
    IndexName = 'cdAccessProcIndex2'
    Params = <>
    ProviderName = 'pvAccessProc'
    StoreDefs = True
    Left = 186
    Top = 130
    object cdAccessProcAccessKindProcessID: TAutoIncField
      FieldName = 'AccessKindProcessID'
      ReadOnly = True
    end
    object cdAccessProcKindID: TIntegerField
      FieldName = 'KindID'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessProcProcessID: TIntegerField
      FieldName = 'ProcessID'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessProcUserID: TIntegerField
      FieldName = 'UserID'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessProcDraftInsert: TBooleanField
      FieldName = 'DraftInsert'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessProcDraftUpdate: TBooleanField
      FieldName = 'DraftUpdate'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessProcDraftDelete: TBooleanField
      FieldName = 'DraftDelete'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessProcWorkInsert: TBooleanField
      FieldName = 'WorkInsert'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessProcWorkUpdate: TBooleanField
      FieldName = 'WorkUpdate'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessProcWorkDelete: TBooleanField
      FieldName = 'WorkDelete'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessProcPlanDate: TBooleanField
      FieldName = 'PlanDate'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessProcFactDate: TBooleanField
      FieldName = 'FactDate'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessProcWorkView: TBooleanField
      FieldName = 'WorkView'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessProcDraftView: TBooleanField
      FieldName = 'DraftView'
      ProviderFlags = [pfInUpdate]
    end
    object cdAccessProcProcessName: TStringField
      FieldKind = fkLookup
      FieldName = 'ProcessName'
      LookupDataSet = sdm.cdServices
      LookupKeyFields = 'SrvID'
      LookupResultField = 'SrvDesc'
      KeyFields = 'ProcessID'
      LookupCache = True
      Size = 40
      Lookup = True
    end
  end
  object pvAccessProc: TDataSetProvider
    DataSet = aqAccessProc
    Options = [poAllowMultiRecordUpdates]
    UpdateMode = upWhereKeyOnly
    OnUpdateError = pvAccessUserUpdateError
    BeforeUpdateRecord = pvAccessProcBeforeUpdateRecord
    Left = 108
    Top = 124
  end
  object dsAccessProc: TDataSource
    DataSet = cdAccessProc
    Left = 264
    Top = 126
  end
  object aqAccessUser: TADOQuery
    Connection = dm.cnCalc
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select AccessUserID, Login, Name, ShortName, EditUsers, EditDics' +
        ', EditProcesses,'
      
        'EditModules, UploadFiles, SetCourse, AddCustomer, EditOwnCustome' +
        'r, EditOtherCustomer, ViewOtherCustomer, ChangeCustomerOwner,'
      
        'ViewOwnOnly, WorkViewOwnOnly, PermitPlanView, DataPaging, ViewRe' +
        'ports, EditCustomReports, DeleteCustomReports, '
      
        'ViewPayments, EditPayments, ViewInvoices, AddInvoices, DeleteInv' +
        'oices, DescribeUnScheduleJob, ViewNotPlanned,'
      'ViewProduction, ViewShipment, AddShipment, DeleteShipment,'
      
        'DefaultKindID, IsRole, RoleID, ContragentGroup, ShowDelayedOrder' +
        's, ShipmentApprovement, ViewMatRequests,'
      
        'UpdateMatPayDate, OrderMaterialsApprovement, AddPayments,  SetPa' +
        'ymentStatus'
      'from AccessUser '
      'order by AccessUserID')
    Left = 24
    Top = 14
  end
  object aqAccessKind: TADOQuery
    Connection = dm.cnCalc
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT AccessKindID, KindID, UserID, WorkCreate, DraftCreate,'
      'WorkUpdateOwn, DraftUpdateOwn, WorkDeleteOwn, DraftDeleteOwn,'
      
        'WorkUpdateOther, DraftUpdateOther, WorkDeleteOther, DraftDeleteO' +
        'ther,'
      'WorkVisible, DraftVisible, WorkBrowse, DraftBrowse, CheckOnSave,'
      'WorkPriceView, DraftPriceView, WorkCostView, DraftCostView,'
      'MakeWork, MakeDraft, PlanFinishDate, PlanStartDate,'
      'FactFinishDate, FactStartDate,'
      'ShowProfitInside, ShowProfitPreview, ModifyProfit,'
      'ViewOnlyProtected, CostProtection, ContentProtection,'
      'ChangeOrderOwner, UpdatePayConditions, CancelMaterialRequest,'
      'EditMaterialRequest, FactCostView'
      'FROM AccessKind')
    Left = 24
    Top = 68
  end
  object dsAccessUser: TDataSource
    DataSet = cdAccessUser
    Left = 254
    Top = 12
  end
  object aqAccessProc: TADOQuery
    Connection = dm.cnCalc
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'Login'
        DataType = ftString
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'SELECT AccessKindProcessID, KindID, ProcessID, UserID, '
      'DraftInsert, DraftUpdate, DraftDelete, '
      'WorkInsert, WorkUpdate, WorkDelete, '
      'PlanDate, FactDate, WorkView, DraftView'
      'FROM AccessKindProcess')
    Left = 30
    Top = 124
  end
  object spCopyUser: TADOStoredProc
    Connection = dm.cnCalc
    ProcedureName = 'up_CopyAccessUser'
    Parameters = <
      item
        Name = '@UserID'
        DataType = ftInteger
        Value = 0
      end
      item
        Name = '@NewUserID'
        DataType = ftInteger
        Direction = pdOutput
        Value = 0
      end>
    Left = 30
    Top = 190
  end
end
