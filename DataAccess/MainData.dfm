object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 711
  Width = 851
  object aqUSD: TADOQuery
    Connection = cnCalc
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    SQL.Strings = (
      'select'
      '          Date, ID, Value,'
      
        '          Convert(varchar(15), Date, 104) + '#39'   '#39' + Convert(varc' +
        'har(15), Date, 108) as DateTm,'
      '          Convert(varchar(20), Date, 4) as DateOnly from dollar'
      'order by Date')
    Left = 20
    Top = 172
  end
  object cnCalc: TADOConnection
    CommandTimeout = 300
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=demo;Persist Security Info=True;Use' +
      'r ID=demo;Initial Catalog=PolyMix;Data Source=192.168.0.130;Use ' +
      'Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Use' +
      ' Encryption for Data=False;Tag with column collation when possib' +
      'le=False'
    ConnectionTimeout = 30
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'SQLOLEDB.1'
    AfterConnect = cnCalcAfterConnect
    Left = 28
    Top = 26
  end
  object pvUSD: TDataSetProvider
    DataSet = aqUSD
    ResolveToDataSet = True
    Left = 58
    Top = 174
  end
  object aspGetLastCourse: TADOStoredProc
    Connection = cnCalc
    ProcedureName = 'up_GetLastCourse;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@Val'
        Attributes = [paNullable]
        DataType = ftFloat
        Direction = pdInputOutput
        Precision = 15
        Value = Null
      end>
    Left = 38
    Top = 222
  end
  object aspNewOrder: TADOStoredProc
    Connection = cnCalc
    CommandTimeout = 300
    ProcedureName = 'up_NewOrder;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@IsDraft'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@Tirazz'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Comment'
        Attributes = [paNullable]
        DataType = ftString
        Size = 128
        Value = Null
      end
      item
        Name = '@Comment2'
        Attributes = [paNullable]
        DataType = ftString
        Size = 128
        Value = Null
      end
      item
        Name = '@ID_date'
        Attributes = [paNullable]
        DataType = ftSmallint
        Precision = 5
        Value = Null
      end
      item
        Name = '@ID_kind'
        Attributes = [paNullable]
        DataType = ftSmallint
        Precision = 5
        Value = Null
      end
      item
        Name = '@ID_char'
        Attributes = [paNullable]
        DataType = ftSmallint
        Precision = 5
        Value = Null
      end
      item
        Name = '@ID_color'
        Attributes = [paNullable]
        DataType = ftSmallint
        Precision = 5
        Value = Null
      end
      item
        Name = '@TotalCost'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@StartDate'
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@FinishDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@Customer'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Course'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@TotalGrn'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@ClientTotal'
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@IncludeAdv'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@RowColor'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@OrderState'
        Attributes = [paNullable]
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@PayState'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@KindID'
        Attributes = [paNullable]
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@CostProtected'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@ContentProtected'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@PrePayPercent'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@PreShipPercent'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@PayDelay'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@IsPayDelayInBankDays'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@CallCustomer'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@CallCustomerPhone'
        DataType = ftString
        Size = 40
        Value = Null
      end
      item
        Name = '@HaveLayout'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@HavePattern'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@ProductFormat'
        Attributes = [paNullable]
        DataType = ftString
        Size = 40
        Value = Null
      end
      item
        Name = '@ProductPages'
        Attributes = [paNullable]
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@SignManager'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@SignProof'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@IncludeCover'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@IsComposite'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@HaveProof'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@ExternalId'
        Attributes = [paNullable]
        DataType = ftString
        Size = -1
        Value = Null
      end
      item
        Name = '@ID'
        Attributes = [paNullable]
        DataType = ftInteger
        Direction = pdInputOutput
        Precision = 10
        Value = 0
      end>
    Left = 36
    Top = 380
  end
  object aspUpdateOrder: TADOStoredProc
    Connection = cnCalc
    ProcedureName = 'up_UpdateOrder;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@ID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Tirazz'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Comment'
        Attributes = [paNullable]
        DataType = ftString
        Size = 128
        Value = Null
      end
      item
        Name = '@Comment2'
        Attributes = [paNullable]
        DataType = ftString
        Size = 128
        Value = Null
      end
      item
        Name = '@ID_date'
        Attributes = [paNullable]
        DataType = ftSmallint
        Precision = 5
        Value = Null
      end
      item
        Name = '@ID_kind'
        Attributes = [paNullable]
        DataType = ftSmallint
        Precision = 5
        Value = Null
      end
      item
        Name = '@ID_char'
        Attributes = [paNullable]
        DataType = ftSmallint
        Precision = 5
        Value = Null
      end
      item
        Name = '@ID_color'
        Attributes = [paNullable]
        DataType = ftSmallint
        Precision = 5
        Value = Null
      end
      item
        Name = '@TotalCost'
        Attributes = [paNullable]
        DataType = ftBCD
        Precision = 15
        Size = 2
        Value = Null
      end
      item
        Name = '@StartDate'
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@FinishDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@Customer'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Course'
        Attributes = [paNullable]
        DataType = ftBCD
        Precision = 15
        Size = 2
        Value = Null
      end
      item
        Name = '@TotalGrn'
        Attributes = [paNullable]
        DataType = ftBCD
        Precision = 15
        Size = 2
        Value = Null
      end
      item
        Name = '@ClientTotal'
        Attributes = [paNullable]
        DataType = ftBCD
        Precision = 15
        Size = 2
        Value = Null
      end
      item
        Name = '@OrderState'
        Attributes = [paNullable]
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@IncludeAdv'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@RowColor'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@PayState'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@IsProcessCostStored'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@CostProtected'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@ContentProtected'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@OldComment'
        DataType = ftString
        Size = 128
        Value = Null
      end
      item
        Name = '@OldComment2'
        DataType = ftString
        Size = 128
        Value = Null
      end
      item
        Name = '@OldOrderState'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@OldPayState'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@OldRowColor'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@OldCustomer'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@KindID'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@PrePayPercent'
        Attributes = [paNullable]
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@PreShipPercent'
        Attributes = [paNullable]
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@PayDelay'
        Attributes = [paNullable]
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@IsPayDelayInBankDays'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@CallCustomer'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@CallCustomerPhone'
        DataType = ftString
        Size = 40
        Value = Null
      end
      item
        Name = '@HaveLayout'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@HavePattern'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@ProductFormat'
        Attributes = [paNullable]
        DataType = ftString
        Size = 40
        Value = Null
      end
      item
        Name = '@ProductPages'
        Attributes = [paNullable]
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@SignManager'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@SignProof'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@IncludeCover'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@IsComposite'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@HaveProof'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@ExternalId'
        Attributes = [paNullable]
        DataType = ftString
        Size = -1
        Value = Null
      end>
    Left = 36
    Top = 422
  end
  object aspDelOrder: TADOStoredProc
    Connection = cnCalc
    ProcedureName = 'up_DelOrder;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@ID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Lock'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 36
    Top = 468
  end
  object aspChangeOrderStatus: TADOStoredProc
    Connection = cnCalc
    ProcedureName = 'up_ChangeOrderStatus;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@Src'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@TotalGrn'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@Course'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@IncludeAdv'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@OrderState'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@PayState'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@ID_Color'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@ID_Char'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@ID_Kind'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@RowColor'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Lock'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@FinishDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@MakeCopy'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end>
    Left = 36
    Top = 512
  end
  object aqCalcOrder: TADOQuery
    CacheSize = 50
    Connection = cnCalc
    LockType = ltBatchOptimistic
    OnRecordChangeComplete = aqOrderRecordChangeComplete
    CommandTimeout = 300
    ParamCheck = False
    Parameters = <>
    Prepared = True
    Left = 196
    Top = 176
    object aqCalcOrderN: TIntegerField
      FieldName = 'N'
    end
    object aqCalcOrderID: TStringField
      FieldName = 'ID'
      Origin = 'YEAR(wo.CreationDate), wo.ID_Number'
      ProviderFlags = []
      Size = 13
    end
    object aqCalcOrderID_date: TSmallintField
      FieldName = 'ID_date'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderID_kind: TSmallintField
      FieldName = 'ID_kind'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderID_char: TSmallintField
      FieldName = 'ID_char'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderID_color: TSmallintField
      FieldName = 'ID_color'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderID_Year: TIntegerField
      FieldName = 'ID_Year'
      ProviderFlags = []
      ReadOnly = True
    end
    object aqCalcOrderID_number: TIntegerField
      FieldName = 'ID_number'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderTirazz: TIntegerField
      FieldName = 'Tirazz'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderCreationDate: TDateTimeField
      FieldName = 'CreationDate'
      Origin = 'wo.CreationDate, wo.ID_Number'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderCreationTime: TDateTimeField
      FieldName = 'CreationTime'
      Origin = 'wo.CreationDate, wo.ID_Number'
      ProviderFlags = []
    end
    object aqCalcOrderModifyDate: TDateTimeField
      FieldName = 'ModifyDate'
      Origin = 'wo.ModifyDate, wo.ID_Number'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderModifyTime: TDateTimeField
      FieldName = 'ModifyTime'
      Origin = 'wo.ModifyDate, wo.ID_Number'
      ProviderFlags = []
    end
    object aqCalcOrderCloseDate: TDateTimeField
      FieldName = 'CloseDate'
      Origin = 'wo.CloseDate, wo.ID_Number'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderCloseTime: TDateTimeField
      FieldName = 'CloseTime'
      Origin = 'wo.CloseDate, wo.ID_Number'
      ProviderFlags = []
    end
    object aqCalcOrderComment: TStringField
      FieldName = 'Comment'
      Origin = 'wo.Comment, YEAR(wo.CreationDate), wo.ID_Number'
      ProviderFlags = [pfInUpdate]
      Size = 128
    end
    object aqCalcOrderComment2: TStringField
      FieldName = 'Comment2'
      Size = 128
    end
    object aqCalcOrderCreatorName: TStringField
      FieldName = 'CreatorName'
      Origin = 'wo.CreatorName, YEAR(wo.CreationDate), wo.ID_Number'
      ProviderFlags = []
      Size = 30
    end
    object aqCalcOrderModifierName: TStringField
      FieldName = 'ModifierName'
      Origin = 'wo.ModifierName, YEAR(wo.CreationDate), wo.ID_Number'
      ProviderFlags = []
      Size = 30
    end
    object aqCalcOrderRowColor: TIntegerField
      FieldName = 'RowColor'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderCustomer: TIntegerField
      FieldName = 'Customer'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderCustomerName: TStringField
      FieldName = 'CustomerName'
      Origin = 'wc.Name, YEAR(wo.CreationDate), wo.ID_Number'
      ProviderFlags = []
      Size = 50
    end
    object aqCalcOrderCustomerFax: TStringField
      FieldName = 'CustomerFax'
      Origin = 'wc.Fax, YEAR(wo.CreationDate), wo.ID_Number'
      ProviderFlags = []
      Size = 50
    end
    object aqCalcOrderCustomerPhone: TStringField
      FieldName = 'CustomerPhone'
      Origin = 'wc.Phone, YEAR(wo.CreationDate), wo.ID_Number'
      ProviderFlags = []
      Size = 50
    end
    object aqCalcOrderKindID: TIntegerField
      FieldName = 'KindID'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderTotalGrn: TBCDField
      FieldKind = fkCalculated
      FieldName = 'TotalGrn'
      ProviderFlags = []
      currency = True
      Size = 2
      Calculated = True
    end
    object aqCalcOrderCostOf1: TBCDField
      FieldName = 'CostOf1'
      ProviderFlags = []
      currency = True
      Precision = 18
      Size = 2
    end
    object aqCalcOrderTotalCost: TBCDField
      FieldName = 'TotalCost'
      ProviderFlags = [pfInUpdate]
      currency = True
      Size = 2
    end
    object aqCalcOrderClientTotal: TBCDField
      FieldName = 'ClientTotal'
      ProviderFlags = [pfInUpdate]
      currency = True
      Size = 2
    end
    object aqCalcOrderIsProcessCostStored: TBooleanField
      FieldName = 'IsProcessCostStored'
      ProviderFlags = []
    end
    object aqCalcOrderClientTotalGrn: TBCDField
      FieldKind = fkCalculated
      FieldName = 'ClientTotalGrn'
      Size = 2
      Calculated = True
    end
    object aqCalcOrderCostOf1Grn: TBCDField
      FieldKind = fkCalculated
      FieldName = 'CostOf1Grn'
      Size = 2
      Calculated = True
    end
    object aqCalcOrderCostProtected: TBooleanField
      FieldName = 'CostProtected'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderContentProtected: TBooleanField
      FieldName = 'ContentProtected'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderFinalCostGrn: TBCDField
      FieldName = 'FinalCostGrn'
      Size = 2
    end
    object aqCalcOrderTotalExpenseCost: TBCDField
      FieldName = 'TotalExpenseCost'
      Size = 2
    end
    object aqCalcOrderCostView: TBooleanField
      FieldName = 'CostView'
      ProviderFlags = []
    end
    object aqCalcOrderProfitByGrn: TBooleanField
      FieldName = 'ProfitByGrn'
      ProviderFlags = []
    end
    object aqCalcOrderProfitPercent: TFloatField
      FieldName = 'ProfitPercent'
      ProviderFlags = []
    end
    object aqCalcOrderPrePayPercent: TFloatField
      FieldName = 'PrePayPercent'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderPreShipPercent: TFloatField
      FieldName = 'PreShipPercent'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderPayDelay: TIntegerField
      FieldName = 'PayDelay'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderIsLockedByUser: TBooleanField
      FieldName = 'IsLockedByUser'
      ProviderFlags = []
    end
    object aqCalcOrderCallCustomer: TBooleanField
      FieldName = 'CallCustomer'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderCallCustomerPhone: TStringField
      FieldName = 'CallCustomerPhone'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object aqCalcOrderHaveLayout: TBooleanField
      FieldName = 'HaveLayout'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderHavePattern: TBooleanField
      FieldName = 'HavePattern'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderSignManager: TBooleanField
      FieldName = 'SignManager'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderSignProof: TBooleanField
      FieldName = 'SignProof'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderProductFormat: TStringField
      FieldName = 'ProductFormat'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object aqCalcOrderProductPages: TIntegerField
      FieldName = 'ProductPages'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderIncludeCover: TBooleanField
      FieldName = 'IncludeCover'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderHasNotes: TBooleanField
      FieldName = 'HasNotes'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderIsComposite: TBooleanField
      FieldName = 'IsComposite'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderHaveProof: TBooleanField
      FieldName = 'HaveProof'
      ProviderFlags = [pfInUpdate]
    end
    object aqCalcOrderIsPayDelayInBankDays: TBooleanField
      FieldName = 'IsPayDelayInBankDays'
      ProviderFlags = [pfInUpdate]
    end
  end
  object pvCalcOrder: TDataSetProvider
    DataSet = aqCalcOrder
    OnGetTableName = pvWorkOrderGetTableName
    Left = 312
    Top = 172
  end
  object aqWorkOrder: TADOQuery
    CacheSize = 50
    Connection = cnCalc
    LockType = ltBatchOptimistic
    OnRecordChangeComplete = aqOrderRecordChangeComplete
    CommandTimeout = 300
    ParamCheck = False
    Parameters = <>
    Prepared = True
    Left = 208
    Top = 228
    object aqWorkOrderN: TIntegerField
      FieldName = 'N'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object aqWorkOrderID: TStringField
      FieldName = 'ID'
      Origin = 'YEAR(wo.CreationDate), wo.ID_Number'
      ProviderFlags = []
      Size = 13
    end
    object aqWorkOrderID_date: TSmallintField
      FieldName = 'ID_date'
      ProviderFlags = [pfInUpdate]
      DisplayFormat = '000'
      EditFormat = '000'
    end
    object aqWorkOrderCostOf1: TBCDField
      FieldName = 'CostOf1'
      ProviderFlags = [pfInUpdate]
      DisplayFormat = '#,###,##0.0000'
      currency = True
      Precision = 18
      Size = 2
    end
    object aqWorkOrderID_Year: TIntegerField
      FieldName = 'ID_Year'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderID_kind: TSmallintField
      FieldName = 'ID_kind'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderID_char: TSmallintField
      FieldName = 'ID_char'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderID_color: TSmallintField
      FieldName = 'ID_color'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderID_number: TIntegerField
      FieldName = 'ID_number'
      ProviderFlags = [pfInUpdate]
      DisplayFormat = '00000'
    end
    object aqWorkOrderTirazz: TIntegerField
      FieldName = 'Tirazz'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderTotalCost: TBCDField
      FieldName = 'TotalCost'
      ProviderFlags = [pfInUpdate]
      DisplayFormat = '#,###,##0.00'
      currency = True
      Precision = 18
      Size = 2
    end
    object aqWorkOrderCreationDate: TDateTimeField
      FieldName = 'CreationDate'
      Origin = 'wo.CreationDate, wo.ID_Number'
      ProviderFlags = [pfInUpdate]
      DisplayFormat = 'dd/mm/yyyy'
    end
    object aqWorkOrderCreationTime: TDateTimeField
      FieldName = 'CreationTime'
      Origin = 'wo.CreationDate, wo.ID_Number'
      ProviderFlags = []
      DisplayFormat = 'h:mm'
    end
    object aqWorkOrderModifyDate: TDateTimeField
      FieldName = 'ModifyDate'
      Origin = 'wo.ModifyDate, wo.ID_Number'
      ProviderFlags = [pfInUpdate]
      DisplayFormat = 'dd/mm/yyyy'
    end
    object aqWorkOrderModifyTime: TDateTimeField
      FieldName = 'ModifyTime'
      Origin = 'wo.ModifyDate, wo.ID_Number'
      ProviderFlags = []
      DisplayFormat = 'h:mm'
    end
    object aqWorkOrderCloseDate: TDateTimeField
      FieldName = 'CloseDate'
      Origin = 'wo.CloseDate, wo.ID_Number'
      ProviderFlags = [pfInUpdate]
      DisplayFormat = 'dd/mm/yyyy'
    end
    object aqWorkOrderCloseTime: TDateTimeField
      FieldName = 'CloseTime'
      Origin = 'wo.CloseDate, wo.ID_Number'
      ProviderFlags = []
      DisplayFormat = 'h:mm'
    end
    object aqWorkOrderComment: TStringField
      FieldName = 'Comment'
      Origin = 'wo.Comment, YEAR(wo.CreationDate), wo.ID_Number'
      ProviderFlags = [pfInUpdate]
      Size = 128
    end
    object aqWorkOrderComment2: TStringField
      FieldName = 'Comment2'
      ProviderFlags = [pfInUpdate]
      Size = 128
    end
    object aqWorkOrderCreatorName: TStringField
      FieldName = 'CreatorName'
      Origin = 'wo.CreatorName, YEAR(wo.CreationDate), wo.ID_Number'
      ProviderFlags = []
      Size = 30
    end
    object aqWorkOrderModifierName: TStringField
      FieldName = 'ModifierName'
      Origin = 'wo.ModifierName, YEAR(wo.CreationDate), wo.ID_Number'
      ProviderFlags = [pfInUpdate]
      Size = 30
    end
    object aqWorkOrderRowColor: TIntegerField
      FieldName = 'RowColor'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderCustomer: TIntegerField
      FieldName = 'Customer'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderCustomerName: TStringField
      FieldName = 'CustomerName'
      Origin = 'wc.Name, YEAR(wo.CreationDate), wo.ID_Number'
      ProviderFlags = []
      Size = 50
    end
    object aqWorkOrderCustomerFax: TStringField
      FieldName = 'CustomerFax'
      Origin = 'wc.Fax, YEAR(wo.CreationDate), wo.ID_Number'
      ProviderFlags = []
      Size = 30
    end
    object aqWorkOrderCustomerPhone: TStringField
      FieldName = 'CustomerPhone'
      Origin = 'wc.Phone, YEAR(wo.CreationDate), wo.ID_Number'
      ProviderFlags = []
      Size = 30
    end
    object aqWorkOrderTotalGrn: TBCDField
      FieldName = 'TotalGrn'
      ProviderFlags = [pfInUpdate]
      DisplayFormat = '#,###,##0.00'
      currency = True
      Precision = 18
      Size = 2
    end
    object aqWorkOrderCourse: TBCDField
      FieldName = 'Course'
      ProviderFlags = [pfInUpdate]
      Precision = 18
      Size = 2
    end
    object aqWorkOrderIncludeAdv: TBooleanField
      FieldName = 'IncludeAdv'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderIsComposite: TBooleanField
      FieldName = 'IsComposite'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderSourceCalcID: TIntegerField
      FieldName = 'SourceCalcID'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderStartDate: TDateTimeField
      FieldName = 'StartDate'
      Origin = 'wo.StartDate'
      ProviderFlags = [pfInUpdate]
      DisplayFormat = 'dd/mm/yyyy'
    end
    object aqWorkOrderFinishDate: TDateTimeField
      FieldName = 'FinishDate'
      Origin = 'wo.FinishDate'
      ProviderFlags = [pfInUpdate]
      DisplayFormat = 'dd/mm/yyyy'
    end
    object aqWorkOrderOrderState: TIntegerField
      FieldName = 'OrderState'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderPayState: TIntegerField
      FieldName = 'PayState'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderFactFinishDate: TDateTimeField
      FieldName = 'FactFinishDate'
      ProviderFlags = []
      DisplayFormat = 'dd/mm/yyyy'
    end
    object aqWorkOrderFactFinishTime: TDateTimeField
      FieldName = 'FactFinishTime'
      ProviderFlags = []
      DisplayFormat = 'h:mm'
    end
    object aqWorkOrderPlanFinishTime: TDateTimeField
      FieldKind = fkCalculated
      FieldName = 'PlanFinishTime'
      ProviderFlags = []
      DisplayFormat = 'h:mm'
      Calculated = True
    end
    object aqWorkOrderKindID: TIntegerField
      FieldName = 'KindID'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderClientTotal: TBCDField
      DisplayLabel = #1050' '#1086#1087#1083#1072#1090#1077',~$'
      FieldName = 'ClientTotal'
      ProviderFlags = [pfInUpdate]
      DisplayFormat = '#,###,##0.00'
      currency = True
      Size = 2
    end
    object aqWorkOrderIsProcessCostStored: TBooleanField
      FieldName = 'IsProcessCostStored'
      ProviderFlags = []
    end
    object aqWorkOrderClientTotalGrn: TBCDField
      FieldKind = fkCalculated
      FieldName = 'ClientTotalGrn'
      Calculated = True
    end
    object aqWorkOrderCostOf1Grn: TBCDField
      FieldKind = fkCalculated
      FieldName = 'CostOf1Grn'
      Precision = 18
      Size = 2
      Calculated = True
    end
    object aqWorkOrderCostProtected: TBooleanField
      FieldName = 'CostProtected'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderContentProtected: TBooleanField
      FieldName = 'ContentProtected'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderAutoPayState: TIntegerField
      FieldName = 'AutoPayState'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderFinalCostGrn: TBCDField
      FieldName = 'FinalCostGrn'
      ProviderFlags = []
      Size = 2
    end
    object aqWorkOrderStateChangeDate: TDateTimeField
      FieldName = 'StateChangeDate'
      ProviderFlags = []
    end
    object aqWorkOrderHasInvoice: TBooleanField
      FieldName = 'HasInvoice'
      ProviderFlags = []
    end
    object aqWorkOrderTotalInvoiceCost: TBCDField
      FieldName = 'TotalInvoiceCost'
      Size = 2
    end
    object aqWorkOrderTotalPayCost: TBCDField
      FieldName = 'TotalPayCost'
      Size = 2
    end
    object aqWorkOrderTotalExpenseCost: TBCDField
      FieldName = 'TotalExpenseCost'
      Size = 2
    end
    object aqWorkOrderProfitByGrn: TBooleanField
      FieldName = 'ProfitByGrn'
      ProviderFlags = []
    end
    object aqWorkOrderProfitPercent: TFloatField
      FieldName = 'ProfitPercent'
      ProviderFlags = []
    end
    object aqWorkOrderCostView: TBooleanField
      FieldName = 'CostView'
      ProviderFlags = []
    end
    object aqWorkOrderShipmentState: TIntegerField
      FieldName = 'ShipmentState'
      ProviderFlags = []
    end
    object aqWorkOrderIsLockedByUser: TBooleanField
      FieldName = 'IsLockedByUser'
      ProviderFlags = []
    end
    object aqWorkOrderShipmentApproved: TBooleanField
      FieldName = 'ShipmentApproved'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderPrePayPercent: TFloatField
      FieldName = 'PrePayPercent'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderPreShipPercent: TFloatField
      FieldName = 'PreShipPercent'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderPayDelay: TIntegerField
      FieldName = 'PayDelay'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderMatRequestModified: TBooleanField
      FieldName = 'MatRequestModified'
      ProviderFlags = []
    end
    object aqWorkOrderCallCustomer: TBooleanField
      FieldName = 'CallCustomer'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderCallCustomerPhone: TStringField
      FieldName = 'CallCustomerPhone'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object aqWorkOrderHaveLayout: TBooleanField
      FieldName = 'HaveLayout'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderHavePattern: TBooleanField
      FieldName = 'HavePattern'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderSignManager: TBooleanField
      FieldName = 'SignManager'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderSignProof: TBooleanField
      FieldName = 'SignProof'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderProductFormat: TStringField
      FieldName = 'ProductFormat'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object aqWorkOrderProductPages: TIntegerField
      FieldName = 'ProductPages'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderIncludeCover: TBooleanField
      FieldName = 'IncludeCover'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderHasNotes: TBooleanField
      FieldName = 'HasNotes'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderHaveProof: TBooleanField
      FieldName = 'HaveProof'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderOrderMaterialsApproved: TBooleanField
      FieldName = 'OrderMaterialsApproved'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderIsPayDelayInBankDays: TBooleanField
      FieldName = 'IsPayDelayInBankDays'
      ProviderFlags = [pfInUpdate]
    end
    object aqWorkOrderExternalId: TStringField
      FieldName = 'ExternalId'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
  end
  object pvWorkOrder: TDataSetProvider
    DataSet = aqWorkOrder
    OnGetTableName = pvWorkOrderGetTableName
    Left = 332
    Top = 224
  end
  object aspCopyOrder: TADOStoredProc
    Connection = cnCalc
    ProcedureName = 'up_CopyOrder2;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@Src'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Dst'
        Attributes = [paNullable]
        DataType = ftInteger
        Direction = pdInputOutput
        Precision = 10
        Value = Null
      end
      item
        Name = '@DefOrderState'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@DefPayState'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@FinishDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end>
    Left = 38
    Top = 560
  end
  object aspSetNewCourse: TADOStoredProc
    Connection = cnCalc
    ProcedureName = 'up_SetNewCourse;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@New'
        Attributes = [paNullable]
        DataType = ftFloat
        Precision = 15
        Value = Null
      end>
    Left = 32
    Top = 272
  end
  object aqProcessItems: TADOQuery
    Connection = cnCalc
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'OrderID1'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = 0
      end>
    SQL.Strings = (
      'SELECT ItemID, Part, ItemDesc, Cost, Enabled, opi.ProcessID,'
      
        '    (select min(PlanStartDate) from Job j where j.ItemID = opi.I' +
        'temID) as PlanStartDate,'
      
        '    (select max(PlanFinishDate) from Job j where j.ItemID = opi.' +
        'ItemID) as PlanFinishDate,'
      
        '    (select min(FactStartDate) from Job j where j.ItemID = opi.I' +
        'temID) as FactStartDate,'
      
        '    (select max(FactFinishDate) from Job j where j.ItemID = opi.' +
        'ItemID) as FactFinishDate,'
      
        '    (select sum(ISNULL(DATEDIFF(minute, FactStartDate, FactFinis' +
        'hDate), 0)) from Job j where j.ItemID = opi.ItemID) as FactDurat' +
        'ion,'
      
        '    (select sum(ISNULL(DATEDIFF(minute, PlanStartDate, PlanFinis' +
        'hDate), 0)) from Job j where j.ItemID = opi.ItemID) as PlanDurat' +
        'ion,'
      
        '--    opi.PlanFinishDate,  opi.FactFinishDate, opi.FactStartDate' +
        ','
      '    ItemProfit, IsItemInProfit,'
      '--    EquipCode,'
      
        '    (select count(distinct EquipCode) from Job where ItemID = op' +
        'i.ItemID) as EquipCount,'
      
        '    (select top 1 EquipCode from Job where ItemID = opi.ItemID) ' +
        'as EquipCode,'
      
        '    (select count(distinct IsPaused) from Job where ItemID = opi' +
        '.ItemID) as IsPausedCount,'
      
        '    (select top 1 IsPaused from Job where ItemID = opi.ItemID) a' +
        's IsPaused,'
      '    ProductIn,'
      '    ProductOut,'
      
        '    (select sum(FactProductIn) from Job j where j.ItemID = opi.I' +
        'temID) as FactProductIn,'
      
        '    (select sum(FactProductOut) from Job j where j.ItemID = opi.' +
        'ItemID) as FactProductOut,'
      '--    ProductIn, ProductOut, FactProductIn, FactProductOut,'
      '    Multiplier, SideCount,'
      
        '    Contractor, ContractorPercent, ContractorProcess, Contractor' +
        'Cost, OwnCost, OwnPercent,'
      
        '    MatCost, MatPercent, FactContractorCost, ManualContractorCos' +
        't,'
      
        '    ss.EnableTracking, ss.EnablePlanning, ss.UseInProfitMode, ss' +
        '.UseInTotal, ss.HideItem,'
      
        '    acp.PlanDate as PermitPlan, acp.FactDate as PermitFact, ss.S' +
        'equenceOrder,'
      
        '    case when IsDraft = 1 then acp.DraftInsert else acp.WorkInse' +
        'rt end as PermitInsert,'
      
        '    case when IsDraft = 1 then acp.DraftUpdate else acp.WorkUpda' +
        'te end as PermitUpdate,'
      
        '    case when IsDraft = 1 then acp.DraftDelete else acp.WorkDele' +
        'te end as PermitDelete,'
      '    cast(0 as bit) as IsPartName,'
      '    Cost as OldCost, opi.EstimatedDuration, opi.LinkedItemID,'
      '    opi.ContractorPayDate'
      
        'FROM OrderProcessItem opi inner join Services ss on opi.ProcessI' +
        'D = ss.SrvID'
      
        '    inner join WorkOrder wo on wo.N = opi.OrderID inner join Acc' +
        'essKindProcess acp'
      
        '    on wo.KindID = acp.KindID and acp.UserID = (select AccessUse' +
        'rID from AccessUser where [login] = SYSTEM_USER)'
      '    and acp.ProcessID = opi.ProcessID'
      'WHERE ss.SrvActive = 1 and opi.OrderID = :OrderID1'
      'ORDER BY Part, opi.ProcessID')
    Left = 576
    Top = 128
    object aqProcessItemsItemID: TAutoIncField
      FieldName = 'ItemID'
    end
    object aqProcessItemsPart: TIntegerField
      FieldName = 'Part'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsItemDesc: TStringField
      FieldName = 'ItemDesc'
      ProviderFlags = [pfInUpdate]
      Size = 150
    end
    object aqProcessItemsCost: TBCDField
      FieldName = 'Cost'
      ProviderFlags = [pfInUpdate]
      Precision = 18
      Size = 2
    end
    object aqProcessItemsEnabled: TBooleanField
      FieldName = 'Enabled'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsProcessID: TIntegerField
      FieldName = 'ProcessID'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsPlanStartDate: TDateTimeField
      FieldName = 'PlanStartDate'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsPlanFinishDate: TDateTimeField
      FieldName = 'PlanFinishDate'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsFactFinishDate: TDateTimeField
      FieldName = 'FactFinishDate'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsFactStartDate: TDateTimeField
      FieldName = 'FactStartDate'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsItemProfit: TBCDField
      FieldName = 'ItemProfit'
      ProviderFlags = [pfInUpdate]
      Precision = 18
      Size = 2
    end
    object aqProcessItemsIsItemInProfit: TBooleanField
      FieldName = 'IsItemInProfit'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsEquipCode: TIntegerField
      FieldName = 'EquipCode'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsProductIn: TIntegerField
      FieldName = 'ProductIn'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsProductOut: TIntegerField
      FieldName = 'ProductOut'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsMultiplier: TFloatField
      FieldName = 'Multiplier'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsFactProductIn: TIntegerField
      FieldName = 'FactProductIn'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsFactProductOut: TIntegerField
      FieldName = 'FactProductOut'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsEnableTracking: TBooleanField
      FieldName = 'EnableTracking'
      ProviderFlags = []
    end
    object aqProcessItemsEnablePlanning: TBooleanField
      FieldName = 'EnablePlanning'
      ProviderFlags = []
    end
    object aqProcessItemsPermitPlan: TBooleanField
      FieldName = 'PermitPlan'
      ProviderFlags = []
    end
    object aqProcessItemsPermitFact: TBooleanField
      FieldName = 'PermitFact'
      ProviderFlags = []
    end
    object aqProcessItemsUseInTotal: TBooleanField
      FieldName = 'UseInTotal'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsHideItem: TBooleanField
      FieldName = 'HideItem'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsUseInProfitMode: TIntegerField
      FieldName = 'UseInProfitMode'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsPermitInsert: TBooleanField
      FieldName = 'PermitInsert'
      ProviderFlags = []
    end
    object aqProcessItemsPermitUpdate: TBooleanField
      FieldName = 'PermitUpdate'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsPermitDelete: TBooleanField
      FieldName = 'PermitDelete'
      ProviderFlags = []
    end
    object aqProcessItemsIsPartName: TBooleanField
      FieldName = 'IsPartName'
      ProviderFlags = []
    end
    object aqProcessItemsContractorProcess: TBooleanField
      FieldName = 'ContractorProcess'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsOwnCost: TBCDField
      FieldName = 'OwnCost'
      ProviderFlags = [pfInUpdate]
      Precision = 18
      Size = 2
    end
    object aqProcessItemsOwnPercent: TBCDField
      FieldName = 'OwnPercent'
      ProviderFlags = [pfInUpdate]
      Precision = 18
      Size = 2
    end
    object aqProcessItemsContractorCost: TBCDField
      FieldName = 'ContractorCost'
      ProviderFlags = [pfInUpdate]
      Precision = 18
      Size = 2
    end
    object aqProcessItemsMatPercent: TBCDField
      FieldName = 'MatPercent'
      ProviderFlags = [pfInUpdate]
      Precision = 18
      Size = 2
    end
    object aqProcessItemsMatCost: TBCDField
      FieldName = 'MatCost'
      ProviderFlags = [pfInUpdate]
      Precision = 18
      Size = 2
    end
    object aqProcessItemsContractorPercent: TBCDField
      FieldName = 'ContractorPercent'
      ProviderFlags = [pfInUpdate]
      Precision = 18
      Size = 2
    end
    object aqProcessItemsContractor: TIntegerField
      FieldName = 'Contractor'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsFactContractorCost: TBCDField
      FieldName = 'FactContractorCost'
      ProviderFlags = [pfInUpdate]
      Precision = 18
      Size = 2
    end
    object aqProcessItemsManualContractorCost: TBooleanField
      FieldName = 'ManualContractorCost'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsOldCost: TBCDField
      FieldName = 'OldCost'
      ProviderFlags = []
      Precision = 18
      Size = 2
    end
    object aqProcessItemsEstimatedDuration: TIntegerField
      FieldName = 'EstimatedDuration'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsLinkedItemID: TIntegerField
      FieldName = 'LinkedItemID'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsSequenceOrder: TIntegerField
      FieldName = 'SequenceOrder'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsEquipCount: TIntegerField
      FieldName = 'EquipCount'
      ProviderFlags = []
    end
    object aqProcessItemsIsPausedCount: TIntegerField
      FieldName = 'IsPausedCount'
    end
    object aqProcessItemsIsPaused: TBooleanField
      FieldName = 'IsPaused'
      ProviderFlags = []
    end
    object aqProcessItemsContractorPayDate: TDateTimeField
      FieldName = 'ContractorPayDate'
      ProviderFlags = []
    end
    object aqProcessItemsSideCount: TIntegerField
      FieldName = 'SideCount'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsPlanDuration: TIntegerField
      FieldName = 'PlanDuration'
      ProviderFlags = [pfInUpdate]
    end
    object aqProcessItemsFactDuration: TIntegerField
      FieldName = 'FactDuration'
      ProviderFlags = [pfInUpdate]
    end
  end
  object pvProcessItems: TDataSetProvider
    DataSet = aqProcessItems
    UpdateMode = upWhereKeyOnly
    Left = 578
    Top = 170
  end
  object aspNewOrderProcessItem: TADOStoredProc
    Connection = cnCalc
    ProcedureName = 'up_NewOrderProcessItem;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@OrderID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Part'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@ItemDesc'
        Attributes = [paNullable]
        DataType = ftString
        Size = 150
        Value = Null
      end
      item
        Name = '@Cost'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@Enabled'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@ProcessID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@PlanStartDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@PlanFinishDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@FactStartDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@FactFinishDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@ItemProfit'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@IsItemInProfit'
        DataType = ftBoolean
        Value = True
      end
      item
        Name = '@EquipCode'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@ProductIn'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@ProductOut'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Multiplier'
        Attributes = [paNullable]
        DataType = ftFloat
        Precision = 15
        Value = Null
      end
      item
        Name = '@FactProductIn'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@FactProductOut'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Contractor'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@ContractorPercent'
        DataType = ftBCD
        Value = Null
      end
      item
        Name = '@ContractorProcess'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@OwnCost'
        DataType = ftBCD
        Value = Null
      end
      item
        Name = '@ContractorCost'
        DataType = ftBCD
        Value = Null
      end
      item
        Name = '@OwnPercent'
        DataType = ftBCD
        Value = Null
      end
      item
        Name = '@MatCost'
        DataType = ftBCD
        Value = Null
      end
      item
        Name = '@MatPercent'
        DataType = ftBCD
        Value = Null
      end
      item
        Name = '@FactContractorCost'
        DataType = ftBCD
        Value = Null
      end
      item
        Name = '@EstimatedDuration'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@LinkedItemID'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@ContractorPayDate'
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@SideCount'
        Attributes = [paNullable]
        DataType = ftInteger
        Value = Null
      end>
    Left = 156
    Top = 526
  end
  object aqProcessItemsLeft: TADOQuery
    Connection = cnCalc
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'OrderID'
        DataType = ftInteger
        Size = -1
        Value = Null
      end
      item
        Name = 'OrderID'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'SELECT ItemID, Part, ItemDesc, Cost, Enabled, opi.ProcessID,'
      
        '-- opi.PlanStartDate, opi.PlanFinishDate, opi.FactFinishDate, op' +
        'i.FactStartDate,'
      
        '    (select min(PlanStartDate) from Job j where j.ItemID = opi.I' +
        'temID) as PlanStartDate,'
      
        '    (select max(PlanFinishDate) from Job j where j.ItemID = opi.' +
        'ItemID) as PlanFinishDate,'
      
        '    (select min(FactStartDate) from Job j where j.ItemID = opi.I' +
        'temID) as FactStartDate,'
      
        '    (select max(FactFinishDate) from Job j where j.ItemID = opi.' +
        'ItemID) as FactFinishDate,'
      
        '    (select sum(DATEDIFF(minute, FactStartDate, FactFinishDate))' +
        ' from Job j where j.ItemID = opi.ItemID) as FactDuration,'
      
        '    (select sum(DATEDIFF(minute, PlanStartDate, PlanFinishDate))' +
        ' from Job j where j.ItemID = opi.ItemID) as PlanDuration,'
      '--    EquipCode,'
      
        '    (select count(distinct EquipCode) from Job where ItemID = op' +
        'i.ItemID) as EquipCount,'
      
        '    (select top 1 EquipCode from Job where ItemID = opi.ItemID) ' +
        'as EquipCode,'
      
        '    (select count(distinct IsPaused) from Job where ItemID = opi' +
        '.ItemID) as IsPausedCount,'
      
        '    (select top 1 IsPaused from Job where ItemID = opi.ItemID) a' +
        's IsPaused,'
      '--    ProductIn, ProductOut, FactProductIn, FactProductOut,'
      '    ProductIn,'
      '    ProductOut,'
      
        '    (select sum(FactProductIn) from Job j where j.ItemID = opi.I' +
        'temID) as FactProductIn,'
      
        '    (select sum(FactProductOut) from Job j where j.ItemID = opi.' +
        'ItemID) as FactProductOut,'
      '    Multiplier, SideCount,'
      '    ItemProfit, IsItemInProfit,'
      
        '    Contractor, ContractorCost, ContractorPercent, ContractorPro' +
        'cess, OwnCost, OwnPercent,'
      
        '    MatCost, MatPercent, FactContractorCost, ManualContractorCos' +
        't,'
      
        '    ss.EnableTracking, ss.EnablePlanning, ss.UseInProfitMode, ss' +
        '.UseInTotal, ss.HideItem, ss.SequenceOrder,'
      
        '    acp.PlanDate as PermitPlan, acp.FactDate as PermitFact, cast' +
        '(0 as bit)  as IsPartName,'
      
        '    case when IsDraft = 1 then acp.DraftInsert else acp.WorkInse' +
        'rt end as PermitInsert,'
      
        '    case when IsDraft = 1 then acp.DraftUpdate else acp.WorkUpda' +
        'te end as PermitUpdate,'
      
        '    case when IsDraft = 1 then acp.DraftDelete else acp.WorkDele' +
        'te end as PermitDelete,'
      
        '    Cost as OldCost, opi.EstimatedDuration, opi.LinkedItemID, op' +
        'i.ContractorPayDate'
      
        'FROM OrderProcessItem opi inner join Services ss on opi.ProcessI' +
        'D = ss.SrvID'
      
        '    inner join WorkOrder wo on wo.N = opi.OrderID inner join Acc' +
        'essKindProcess acp'
      
        '    on wo.KindID = acp.KindID and acp.UserID = (select AccessUse' +
        'rID from AccessUser where [login] = SYSTEM_USER)'
      '    and acp.ProcessID = opi.ProcessID'
      'WHERE ss.SrvActive = 1 and opi.OrderID = :OrderID'
      'union all'
      
        'SELECT distinct null as ItemID, Part, pd.[Name] as ItemDesc, nul' +
        'l as Cost, null as Enabled,'
      '    0 as ProcessID,'
      '    null as PlanStartDate, null as PlanFinishDate,'
      '    null as FactFinishDate, null as FactStartDate,'
      '    null as FactDuration, null as PlanDuration,'
      '    null as EquipCount, null as EquipCode,'
      '    null as IsPausedCount, cast (0 as bit) as IsPaused,'
      '    null as ProductIn, null as ProductOut,'
      '    null as FactProductIn, null as FactProductOut,'
      '    null as Multiplier, null as SideCount,'
      '    null as ItemProfit, cast(0 as bit) as IsItemInProfit,'
      
        '    null as Contractor, 0 as ContractorCost, 0 as ContractorPerc' +
        'ent, cast(0 as bit) as ContractorProcess,'
      
        '    0 as OwnCost, 0 as OwnPercent, 0 as MatCost, 0 as MatPercent' +
        ','
      
        '    0 as FactContractorCost, cast(0 as bit) as ManualContractorC' +
        'ost,'
      
        '    cast(1 as bit) as EnableTracking, cast(1 as bit) as EnablePl' +
        'anning,'
      
        '    cast(0 as bit) as UseInProfitMode, cast(0 as bit) as UseInTo' +
        'tal,'
      '    cast(0 as bit) as HideItem, 0 as SequenceOrder,'
      
        '    cast(1 as bit) as PermitPlan, cast(1 as bit) as PermitFact, ' +
        'cast(1 as bit) as IsPartName,'
      
        '    cast(1 as bit) as PermitInsert, cast(1 as bit) as PermitUpda' +
        'te, cast(1 as bit) as PermitDelete,'
      
        '    null as OldCost, null as EstimatedDuration, null as LinkedPr' +
        'ocessID,'
      '    null as ContractorPayDate'
      
        'FROM OrderProcessItem opi left join Dic_Parts pd on opi.Part = C' +
        'ode'
      'WHERE opi.OrderID = :OrderID'
      
        '  and (select ss1.HideItem from Services ss1 where ss1.SrvID = o' +
        'pi.ProcessID) = 0'
      '  and opi.Enabled = 1'
      'ORDER BY Part, ss.SequenceOrder'
      '--opi.ProcessID'
      '-- '#1086#1073#1098#1077#1076#1080#1085#1103#1077#1090#1089#1103' '#1089' '#1085#1072#1079#1074#1072#1085#1080#1103#1084#1080' '#1095#1072#1089#1090#1077#1081)
    Left = 674
    Top = 122
  end
  object pvProcessItemsLeft: TDataSetProvider
    DataSet = aqProcessItemsLeft
    UpdateMode = upWhereKeyOnly
    Left = 666
    Top = 166
  end
  object aspGetCurDate: TADOStoredProc
    Connection = cnCalc
    ProcedureName = 'up_GetCurDate'
    Parameters = <
      item
        Name = '@CurDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Direction = pdOutput
        Value = 0d
      end>
    Left = 138
    Top = 460
  end
  object cdDisplayInfo: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvDisplayInfo'
    Left = 400
    Top = 458
    object cdDisplayInfoDisplayInfoItemID: TAutoIncField
      FieldName = 'DisplayInfoItemID'
      ReadOnly = True
    end
    object cdDisplayInfoItemType: TIntegerField
      FieldName = 'ItemType'
      ProviderFlags = [pfInUpdate]
    end
    object cdDisplayInfoItemLabel: TStringField
      FieldName = 'ItemLabel'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdDisplayInfoItemFormat: TStringField
      FieldName = 'ItemFormat'
      ProviderFlags = [pfInUpdate]
      Size = 30
    end
    object cdDisplayInfoStartGroup: TBooleanField
      FieldName = 'StartGroup'
      ProviderFlags = [pfInUpdate]
    end
    object cdDisplayInfoFontBold: TBooleanField
      FieldName = 'FontBold'
      ProviderFlags = [pfInUpdate]
    end
    object cdDisplayInfoLabelFontBold: TBooleanField
      FieldName = 'LabelFontBold'
      ProviderFlags = [pfInUpdate]
    end
    object cdDisplayInfoFontColor: TIntegerField
      FieldName = 'FontColor'
      ProviderFlags = [pfInUpdate]
    end
    object cdDisplayInfoLabelFontColor: TIntegerField
      FieldName = 'LabelFontColor'
      ProviderFlags = [pfInUpdate]
    end
    object cdDisplayInfoBkColor: TIntegerField
      FieldName = 'BkColor'
      ProviderFlags = [pfInUpdate]
    end
    object cdDisplayInfoTransparent: TBooleanField
      FieldName = 'Transparent'
      ProviderFlags = [pfInUpdate]
    end
    object cdDisplayInfoLabelWidth: TIntegerField
      FieldName = 'LabelWidth'
      ProviderFlags = [pfInUpdate]
    end
    object cdDisplayInfoItemWidth: TIntegerField
      FieldName = 'ItemWidth'
      ProviderFlags = [pfInUpdate]
    end
  end
  object dsDisplayInfo: TDataSource
    DataSet = cdDisplayInfo
    Left = 332
    Top = 458
  end
  object aqDisplayInfo: TADOQuery
    Connection = cnCalc
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select DisplayInfoItemID, ItemType, ItemLabel, ItemFormat, Start' +
        'Group,'
      #9'FontBold,'#9'LabelFontBold, FontColor,'#9'LabelFontColor,'#9'BkColor,'
      #9'Transparent, LabelWidth, ItemWidth'
      'from DisplayInfo'
      'order by ItemNum')
    Left = 544
    Top = 458
  end
  object pvDisplayInfo: TDataSetProvider
    DataSet = aqDisplayInfo
    UpdateMode = upWhereKeyOnly
    Left = 474
    Top = 458
  end
  object aspENewOrder: TADOStoredProc
    Connection = cnCalc
    CommandTimeout = 300
    ProcedureName = 'up_EmergencyNewOrder;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@IsDraft'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@Tirazz'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Comment'
        Attributes = [paNullable]
        DataType = ftString
        Size = 128
        Value = Null
      end
      item
        Name = '@Comment2'
        Attributes = [paNullable]
        DataType = ftString
        Size = 128
        Value = Null
      end
      item
        Name = '@ID_date'
        Attributes = [paNullable]
        DataType = ftSmallint
        Precision = 5
        Value = Null
      end
      item
        Name = '@ID_kind'
        Attributes = [paNullable]
        DataType = ftSmallint
        Precision = 5
        Value = Null
      end
      item
        Name = '@ID_char'
        Attributes = [paNullable]
        DataType = ftSmallint
        Precision = 5
        Value = Null
      end
      item
        Name = '@ID_color'
        Attributes = [paNullable]
        DataType = ftSmallint
        Precision = 5
        Value = Null
      end
      item
        Name = '@TotalCost'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@StartDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@FinishDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@Creator'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Attrib'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Customer'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Course'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@TotalGrn'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@ClientTotal'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@IncludeAdv'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@RowColor'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@OrderState'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@CourseNBU'
        Attributes = [paNullable]
        DataType = ftFloat
        Precision = 15
        Value = Null
      end
      item
        Name = '@PayState'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@KindID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@CreationDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@ID_Number'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
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
    Left = 118
    Top = 380
  end
  object cdEntSettings: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvEntSettings'
    Left = 436
    Top = 116
    object cdEntSettingsSettingID: TIntegerField
      FieldName = 'SettingID'
    end
    object cdEntSettingsEditLock: TBooleanField
      FieldName = 'EditLock'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsGetCourseOnStart: TBooleanField
      FieldName = 'GetCourseOnStart'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsPermitFilterOff: TBooleanField
      FieldName = 'PermitFilterOff'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsBriefOrderID: TBooleanField
      FieldName = 'BriefOrderID'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsRoundTotalMode: TIntegerField
      FieldName = 'RoundTotalMode'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsRoundUSD: TBooleanField
      FieldName = 'RoundUSD'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsRoundPrecision: TIntegerField
      FieldName = 'RoundPrecision'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsPermitKindChange: TBooleanField
      FieldName = 'PermitKindChange'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsNativeCurrency: TBooleanField
      FieldName = 'NativeCurrency'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsRequireCustomer: TBooleanField
      FieldName = 'RequireCustomer'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsRequireBranch: TBooleanField
      FieldName = 'RequireBranch'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsRequireActivity: TBooleanField
      FieldName = 'RequireActivity'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsRequireProductType: TBooleanField
      FieldName = 'RequireProductType'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsRequireFinishDate: TBooleanField
      FieldName = 'RequireFinishDate'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsRequireInfoSource: TBooleanField
      FieldName = 'RequireInfoSource'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsExecNewRecordAfterInsert: TBooleanField
      FieldName = 'ExecNewRecordAfterInsert'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsAutoPayState: TBooleanField
      FieldName = 'AutoPayState'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsRequireFirmType: TBooleanField
      FieldName = 'RequireFirmType'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsRequireFullName: TBooleanField
      FieldName = 'RequireFullName'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsShowAddPlanDialog: TBooleanField
      FieldName = 'ShowAddPlanDialog'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsNewPlanInterface: TBooleanField
      FieldName = 'NewPlanInterface'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsVATPercent: TFloatField
      FieldName = 'VATPercent'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsCheckOverdueJobs: TBooleanField
      FieldName = 'CheckOverdueJobs'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsShowSyncInfo: TBooleanField
      FieldName = 'ShowSyncInfo'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsPayStateMode: TIntegerField
      FieldName = 'PayStateMode'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsLockSyncData: TBooleanField
      FieldName = 'LockSyncData'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsFactDateStrictOrder: TBooleanField
      FieldName = 'FactDateStrictOrder'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsRequireFactProductOut: TBooleanField
      FieldName = 'RequireFactProductOut'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsShipmentApprovement: TBooleanField
      FieldName = 'ShipmentApprovement'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsFileStoragePath: TStringField
      FieldName = 'FileStoragePath'
      ProviderFlags = [pfInUpdate]
      Size = 255
    end
    object cdEntSettingsJobColorByExecState: TBooleanField
      FieldName = 'JobColorByExecState'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsPlanShowExecState: TBooleanField
      FieldName = 'PlanShowExecState'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsPlanShowOrderState: TBooleanField
      FieldName = 'PlanShowOrderState'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsShowExpenseCost: TBooleanField
      FieldName = 'ShowExpenseCost'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsAllowCostProtect: TBooleanField
      FieldName = 'AllowCostProtect'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsRedScheduleSpace: TBooleanField
      FieldName = 'RedScheduleSpace'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsSplitJobs: TBooleanField
      FieldName = 'SplitJobs'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsInvoiceAllPayments: TBooleanField
      FieldName = 'InvoiceAllPayments'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsShowPartialInvoice: TBooleanField
      FieldName = 'ShowPartialInvoice'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsShowContragentFullName: TBooleanField
      FieldName = 'ShowContragentFullName'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsAllContractors: TBooleanField
      FieldName = 'AllContractors'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsSyncProducts: TBooleanField
      FieldName = 'SyncProducts'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsNewInvoicePayState: TBooleanField
      FieldName = 'NewInvoicePayState'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsShowInvoicePayerFilter: TBooleanField
      FieldName = 'ShowInvoicePayerFilter'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsShowInvoiceCustomerFilter: TBooleanField
      FieldName = 'ShowInvoiceCustomerFilter'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsOrderMaterialsApprovement: TBooleanField
      FieldName = 'OrderMaterialsApprovement'
      ProviderFlags = [pfInUpdate]
    end
    object cdEntSettingsShowExternalId: TBooleanField
      FieldName = 'ShowExternalId'
      ProviderFlags = [pfInUpdate]
    end
  end
  object pvEntSettings: TDataSetProvider
    DataSet = aqEntSettings
    Left = 360
    Top = 112
  end
  object aqEntSettings: TADOQuery
    Connection = cnCalc
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select SettingID, EditLock, GetCourseOnStart, PermitFilterOff, B' +
        'riefOrderID,'
      
        '  RoundTotalMode, RoundUSD, RoundPrecision, PermitKindChange, Na' +
        'tiveCurrency,'
      
        '  RequireCustomer, RequireFinishDate, RequireProductType, Requir' +
        'eActivity,'
      
        '  RequireInfoSource, RequireBranch, ExecNewRecordAfterInsert, Au' +
        'toPayState,'
      
        '  RequireFirmType, ShowAddPlanDialog, NewPlanInterface, VATPerce' +
        'nt, CheckOverdueJobs,'
      
        '  RequireFullName, ShowSyncInfo, PayStateMode, LockSyncData, Fac' +
        'tDateStrictOrder,'
      
        '  RequireFactProductOut, JobColorByExecState, ShipmentApprovemen' +
        't, FileStoragePath,'
      
        '  PlanShowOrderState, PlanShowExecState, ShowExpenseCost, AllowC' +
        'ostProtect,'
      
        '  RedScheduleSpace, SplitJobs, InvoiceAllPayments, ShowPartialIn' +
        'voice, ShowContragentFullName,'
      
        '  AllContractors, SyncProducts, NewInvoicePayState, ShowInvoiceP' +
        'ayerFilter, ShowInvoiceCustomerFilter,'
      '  OrderMaterialsApprovement, ShowExternalId'
      'from EnterpriseSettings')
    Left = 286
    Top = 112
  end
  object aqOrderRecycleBin: TADOQuery
    Connection = cnCalc
    CursorType = ctStatic
    CommandTimeout = 300
    Parameters = <>
    Left = 740
    Top = 428
  end
  object pvOrderRecycleBin: TDataSetProvider
    DataSet = aqOrderRecycleBin
    Left = 648
    Top = 480
  end
  object cdOrderRecycleBin: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvOrderRecycleBin'
    Left = 728
    Top = 464
    object cdOrderRecycleBinN: TAutoIncField
      FieldName = 'N'
      ReadOnly = True
    end
    object cdOrderRecycleBinComment: TStringField
      FieldName = 'Comment'
      Size = 128
    end
    object cdOrderRecycleBinCustomer: TIntegerField
      FieldName = 'Customer'
    end
    object cdOrderRecycleBinCustomerName: TStringField
      FieldName = 'CustomerName'
      Size = 50
    end
    object cdOrderRecycleBinCreationDate: TDateTimeField
      FieldName = 'CreationDate'
      DisplayFormat = 'dd.mm.yyyy hh:nn'
    end
    object cdOrderRecycleBinID: TStringField
      FieldName = 'ID'
      ReadOnly = True
      Size = 5
    end
    object cdOrderRecycleBinUserName: TStringField
      FieldName = 'UserName'
      ProviderFlags = [pfInUpdate]
      ReadOnly = True
      Size = 50
    end
    object cdOrderRecycleBinIsDraft: TBooleanField
      FieldName = 'IsDraft'
    end
    object cdOrderRecycleBinRowColor: TIntegerField
      FieldName = 'RowColor'
    end
    object cdOrderRecycleBinEntityName: TStringField
      FieldKind = fkCalculated
      FieldName = 'EntityName'
      Size = 40
      Calculated = True
    end
    object cdOrderRecycleBinDeleteDate: TDateTimeField
      FieldName = 'DeleteDate'
      DisplayFormat = 'dd.mm.yyyy hh:nn'
    end
    object cdOrderRecycleBinID_Number: TIntegerField
      FieldName = 'ID_Number'
    end
    object cdOrderRecycleBinKindID: TIntegerField
      FieldName = 'KindID'
      ProviderFlags = []
    end
  end
  object aspUpdateOrderProcessItem: TADOStoredProc
    Connection = cnCalc
    ProcedureName = 'up_UpdateOrderProcessItem2'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@ItemID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Part'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@ItemDesc'
        Attributes = [paNullable]
        DataType = ftString
        Size = 150
        Value = Null
      end
      item
        Name = '@Cost'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 4
        Precision = 18
        Value = Null
      end
      item
        Name = '@Enabled'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@ProcessID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@PlanStartDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@PlanFinishDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@FactStartDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@FactFinishDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@ItemProfit'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 4
        Precision = 18
        Value = Null
      end
      item
        Name = '@IsItemInProfit'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@EquipCode'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@ProductIn'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@ProductOut'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Multiplier'
        Attributes = [paNullable]
        DataType = ftFloat
        Precision = 15
        Value = Null
      end
      item
        Name = '@Contractor'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@ContractorPercent'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@ContractorProcess'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@OwnCost'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@ContractorCost'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@OwnPercent'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@MatCost'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@MatPercent'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@FactContractorCost'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 18
        Value = Null
      end
      item
        Name = '@EstimatedDuration'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@LinkedItemID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@ContractorPayDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@OldPlanStartDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@OldPlanFinishDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@OldFactStartDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@OldFactFinishDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@SideCount'
        Attributes = [paNullable]
        DataType = ftInteger
        Value = Null
      end>
    Left = 164
    Top = 576
  end
  object aspNewSpecialJob: TADOStoredProc
    Connection = cnCalc
    ProcedureName = 'up_NewSpecialJob;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@JobType'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@PlanStartDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@PlanFinishDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@FactStartDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@FactFinishDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@EquipCode'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Executor'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@TimeLocked'
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@JobID'
        Attributes = [paNullable]
        DataType = ftInteger
        Direction = pdInputOutput
        Precision = 10
        Value = Null
      end>
    Left = 272
    Top = 580
  end
  object aspAddToGlobalHistory: TADOStoredProc
    Connection = cnCalc
    ProcedureName = 'up_AddToGlobalHistory;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@EventKind'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@EventText'
        Attributes = [paNullable]
        DataType = ftString
        Size = 300
        Value = Null
      end
      item
        Name = '@EventValue'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 268
    Top = 528
  end
  object aspSetOrderOwner: TADOStoredProc
    Connection = cnCalc
    ProcedureName = 'up_SetOrderOwner'
    Parameters = <
      item
        Name = '@OrderID'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@OwnerName'
        DataType = ftString
        Size = 30
        Value = Null
      end>
    Left = 244
    Top = 476
  end
  object aqContragentRecycleBin: TADOQuery
    Connection = cnCalc
    Parameters = <>
    Left = 756
    Top = 568
  end
  object cdContragentRecycleBin: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvContragentRecycleBin'
    Left = 712
    Top = 512
    object cdContragentRecycleBinN: TIntegerField
      FieldName = 'N'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object cdContragentRecycleBinName: TStringField
      FieldName = 'Name'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdContragentRecycleBinCreationDate: TDateTimeField
      FieldName = 'CreationDate'
      ProviderFlags = [pfInUpdate]
      DisplayFormat = 'dd.mm.yyyy hh:nn'
    end
    object cdContragentRecycleBinDeleteDate: TDateTimeField
      FieldName = 'DeleteDate'
      ProviderFlags = [pfInUpdate]
      DisplayFormat = 'dd.mm.yyyy hh:nn'
    end
    object cdContragentRecycleBinUserName: TStringField
      FieldName = 'UserName'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object cdContragentRecycleBinContragentType: TIntegerField
      FieldName = 'ContragentType'
      ProviderFlags = [pfInUpdate]
    end
    object cdContragentRecycleBinIsWork: TBooleanField
      FieldName = 'IsWork'
      ProviderFlags = [pfInUpdate]
    end
    object cdContragentRecycleBinContragentTypeName: TStringField
      FieldKind = fkCalculated
      FieldName = 'ContragentTypeName'
      Size = 50
      Calculated = True
    end
  end
  object pvContragentRecycleBin: TDataSetProvider
    DataSet = aqContragentRecycleBin
    Left = 644
    Top = 532
  end
  object pvGlobalHistory: TDataSetProvider
    DataSet = aqGlobalHistory
    Left = 404
    Top = 552
  end
  object cdGlobalHistory: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvGlobalHistory'
    Left = 444
    Top = 568
    object cdGlobalHistoryEventDate: TDateTimeField
      FieldName = 'EventDate'
      DisplayFormat = 'dd.mm.yyyy hh:mm'
    end
    object cdGlobalHistoryEventText: TStringField
      FieldName = 'EventText'
      Size = 300
    end
    object cdGlobalHistoryEventUser: TStringField
      FieldName = 'EventUser'
      Size = 50
    end
    object cdGlobalHistoryEventKind: TIntegerField
      FieldName = 'EventKind'
    end
    object cdGlobalHistoryEventID: TIntegerField
      FieldName = 'EventID'
    end
  end
  object aqGlobalHistory: TADOQuery
    Connection = cnCalc
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'OrderID'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      '-- '#1074' '#1082#1086#1076#1077)
    Left = 352
    Top = 572
    object aqGlobalHistoryEventDate: TDateTimeField
      FieldName = 'EventDate'
    end
    object aqGlobalHistoryEventText: TStringField
      FieldName = 'EventText'
      Size = 300
    end
    object aqGlobalHistoryEventUser: TStringField
      FieldName = 'EventUser'
      Size = 50
    end
    object aqGlobalHistoryEventKind: TIntegerField
      FieldName = 'EventKind'
    end
    object aqGlobalHistoryEventID: TIntegerField
      FieldName = 'EventID'
    end
  end
  object pvOrderHistory: TDataSetProvider
    DataSet = aqOrderHistory
    Left = 556
    Top = 584
  end
  object cdOrderHistory: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvOrderHistory'
    ReadOnly = True
    Left = 636
    Top = 600
    object cdOrderHistoryEventID: TIntegerField
      FieldName = 'EventID'
    end
    object DateTimeField1: TDateTimeField
      FieldName = 'EventDate'
      DisplayFormat = 'dd.mm.yyyy hh:mm'
    end
    object StringField1: TStringField
      FieldName = 'EventText'
      Size = 300
    end
    object StringField2: TStringField
      FieldName = 'EventUser'
      Size = 50
    end
    object IntegerField1: TIntegerField
      FieldName = 'EventKind'
    end
  end
  object aqOrderHistory: TADOQuery
    Connection = cnCalc
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'OrderID'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      'select EventID, EventDate, EventText, EventUser, EventKind '
      'from OrderHistory where OrderID = :OrderID'
      'order by EventDate')
    Left = 516
    Top = 564
    object aqOrderHistoryEventID: TIntegerField
      FieldName = 'EventID'
    end
    object DateTimeField2: TDateTimeField
      FieldName = 'EventDate'
    end
    object StringField3: TStringField
      FieldName = 'EventText'
      Size = 300
    end
    object StringField4: TStringField
      FieldName = 'EventUser'
      Size = 50
    end
    object IntegerField2: TIntegerField
      FieldName = 'EventKind'
    end
  end
  object aqContragentHistory: TADOQuery
    Connection = cnCalc
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'ContragentID'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select EventID, EventDate, EventText, EventUser, EventKind '
      'from ContragentHistory where ContragentID = :ContragentID'
      'order by EventDate')
    Left = 492
    Top = 612
    object IntegerField3: TIntegerField
      FieldName = 'EventID'
    end
    object DateTimeField3: TDateTimeField
      FieldName = 'EventDate'
    end
    object StringField5: TStringField
      FieldName = 'EventText'
      Size = 300
    end
    object StringField6: TStringField
      FieldName = 'EventUser'
      Size = 50
    end
    object IntegerField4: TIntegerField
      FieldName = 'EventKind'
    end
  end
  object pvContragentHistory: TDataSetProvider
    DataSet = aqContragentHistory
    Left = 524
    Top = 644
  end
  object cdContragentHistory: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvContragentHistory'
    ReadOnly = True
    Left = 632
    Top = 652
    object IntegerField5: TIntegerField
      FieldName = 'EventID'
    end
    object DateTimeField4: TDateTimeField
      FieldName = 'EventDate'
      DisplayFormat = 'dd.mm.yyyy hh:mm'
    end
    object StringField7: TStringField
      FieldName = 'EventText'
      Size = 300
    end
    object StringField8: TStringField
      FieldName = 'EventUser'
      Size = 50
    end
    object IntegerField6: TIntegerField
      FieldName = 'EventKind'
    end
  end
end
