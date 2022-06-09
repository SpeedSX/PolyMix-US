object ExpDM: TExpDM
  OldCreateOrder = False
  Height = 198
  Width = 237
  object dsComExp: TDataSource
    DataSet = cdComExp
    Left = 177
    Top = 54
  end
  object dsOwnExp: TDataSource
    DataSet = cdOwnExp
    Left = 177
    Top = 8
  end
  object aqComExp: TADOQuery
    LockType = ltBatchOptimistic
    Parameters = <>
    SQL.Strings = (
      
        'select N, ExpDate, ExpKind, ExpOther, ExpAddOther, CostUSD, Cost' +
        'Grn, OwnExp '
      'from CommonExpenses'
      'where OwnExp = 0'
      '@@@RANGE ExpDate'
      '-- '#1086#1089#1090#1072#1074#1083#1077#1085#1072' '#1086#1076#1085#1072' '#1089#1090#1088#1086#1082#1072' '#1076#1083#1103' '#1092#1080#1083#1100#1090#1088#1072#1094#1080#1080' '#1087#1086' '#1090#1080#1087#1091' '#1088#1072#1089#1093#1086#1076#1086#1074)
    Left = 16
    Top = 56
    object aqComExpN: TAutoIncField
      FieldName = 'N'
      ReadOnly = True
    end
    object aqComExpExpDate: TDateTimeField
      FieldName = 'ExpDate'
      ProviderFlags = [pfInUpdate]
    end
    object aqComExpExpKind: TIntegerField
      FieldName = 'ExpKind'
      ProviderFlags = [pfInUpdate]
    end
    object aqComExpExpOther: TStringField
      FieldName = 'ExpOther'
      ProviderFlags = [pfInUpdate]
      Size = 30
    end
    object aqComExpExpAddOther: TStringField
      FieldName = 'ExpAddOther'
      ProviderFlags = [pfInUpdate]
      Size = 128
    end
    object aqComExpCostUSD: TBCDField
      FieldName = 'CostUSD'
      ProviderFlags = [pfInUpdate]
      Precision = 18
      Size = 2
    end
    object aqComExpCostGrn: TBCDField
      FieldName = 'CostGrn'
      ProviderFlags = [pfInUpdate]
      Precision = 18
      Size = 2
    end
    object aqComExpOwnExp: TBooleanField
      FieldName = 'OwnExp'
      ProviderFlags = [pfInUpdate]
    end
  end
  object aqOwnExp: TADOQuery
    LockType = ltBatchOptimistic
    Parameters = <>
    SQL.Strings = (
      
        'select N, ExpDate, ExpKind, ExpOther, ExpAddOther, CostUSD, Cost' +
        'Grn, OwnExp '
      'from CommonExpenses'
      'where OwnExp = 1'
      '@@@RANGE ExpDate'
      '-- '#1086#1089#1090#1072#1074#1083#1077#1085#1072' '#1086#1076#1085#1072' '#1089#1090#1088#1086#1082#1072' '#1076#1083#1103' '#1092#1080#1083#1100#1090#1088#1072#1094#1080#1080' '#1087#1086' '#1090#1080#1087#1091' '#1088#1072#1089#1093#1086#1076#1086#1074)
    Left = 16
    Top = 8
    object aqOwnExpN: TAutoIncField
      FieldName = 'N'
      ReadOnly = True
    end
    object aqOwnExpExpDate: TDateTimeField
      FieldName = 'ExpDate'
      ProviderFlags = [pfInUpdate]
    end
    object aqOwnExpExpKind: TIntegerField
      FieldName = 'ExpKind'
      ProviderFlags = [pfInUpdate]
    end
    object aqOwnExpExpOther: TStringField
      FieldName = 'ExpOther'
      ProviderFlags = [pfInUpdate]
      Size = 30
    end
    object aqOwnExpExpAddOther: TStringField
      FieldName = 'ExpAddOther'
      ProviderFlags = [pfInUpdate]
      Size = 128
    end
    object aqOwnExpCostUSD: TBCDField
      FieldName = 'CostUSD'
      ProviderFlags = [pfInUpdate]
      Precision = 18
      Size = 2
    end
    object aqOwnExpCostGrn: TBCDField
      FieldName = 'CostGrn'
      ProviderFlags = [pfInUpdate]
      Precision = 18
      Size = 2
    end
    object aqOwnExpOwnExp: TBooleanField
      FieldName = 'OwnExp'
      ProviderFlags = [pfInUpdate]
    end
  end
  object pvOwnExp: TDataSetProvider
    DataSet = aqOwnExp
    Left = 72
    Top = 8
  end
  object pvComExp: TDataSetProvider
    DataSet = aqComExp
    Left = 72
    Top = 56
  end
  object cdOwnExp: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvOwnExp'
    OnNewRecord = cdOwnExpNewRecord
    Left = 124
    Top = 8
    object cdOwnExpN: TAutoIncField
      FieldName = 'N'
    end
    object cdOwnExpExpDate: TDateTimeField
      FieldName = 'ExpDate'
      ProviderFlags = [pfInUpdate]
    end
    object cdOwnExpExpKind: TIntegerField
      FieldName = 'ExpKind'
      ProviderFlags = [pfInUpdate]
    end
    object cdOwnExpExpOther: TStringField
      FieldName = 'ExpOther'
      ProviderFlags = [pfInUpdate]
      OnChange = cdComExpExpOtherChange
      Size = 30
    end
    object cdOwnExpExpAddOther: TStringField
      FieldName = 'ExpAddOther'
      ProviderFlags = [pfInUpdate]
      Size = 128
    end
    object cdOwnExpCostUSD: TBCDField
      FieldName = 'CostUSD'
      ProviderFlags = [pfInUpdate]
      OnChange = cdComExpCostUSDChange
      Precision = 18
      Size = 2
    end
    object cdOwnExpCostGrn: TBCDField
      FieldName = 'CostGrn'
      ProviderFlags = [pfInUpdate]
      OnChange = cdComExpCostGrnChange
      Precision = 18
      Size = 2
    end
    object cdOwnExpOwnExp: TBooleanField
      FieldName = 'OwnExp'
      ProviderFlags = [pfInUpdate]
    end
    object cdOwnExpExpKindLookup: TStringField
      FieldKind = fkLookup
      FieldName = 'ExpKindLookup'
      LookupKeyFields = 'Code'
      LookupResultField = 'Name'
      KeyFields = 'ExpKind'
      ProviderFlags = []
      OnGetText = cdOwnExpExpKindLookupGetText
      Size = 50
      Lookup = True
    end
  end
  object cdComExp: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvComExp'
    OnNewRecord = cdOwnExpNewRecord
    Left = 124
    Top = 56
    object cdComExpN: TAutoIncField
      FieldName = 'N'
    end
    object cdComExpExpDate: TDateTimeField
      FieldName = 'ExpDate'
      ProviderFlags = [pfInUpdate]
    end
    object cdComExpExpKind: TIntegerField
      FieldName = 'ExpKind'
      ProviderFlags = [pfInUpdate]
    end
    object cdComExpExpOther: TStringField
      FieldName = 'ExpOther'
      ProviderFlags = [pfInUpdate]
      OnChange = cdComExpExpOtherChange
      Size = 30
    end
    object cdComExpExpAddOther: TStringField
      FieldName = 'ExpAddOther'
      ProviderFlags = [pfInUpdate]
      Size = 128
    end
    object cdComExpCostUSD: TBCDField
      FieldName = 'CostUSD'
      ProviderFlags = [pfInUpdate]
      OnChange = cdComExpCostUSDChange
      DisplayFormat = '#,###,##0.00'
      EditFormat = '#######0.00'
      Precision = 18
      Size = 2
    end
    object cdComExpCostGrn: TBCDField
      FieldName = 'CostGrn'
      ProviderFlags = [pfInUpdate]
      OnChange = cdComExpCostGrnChange
      DisplayFormat = '#,###,##0.00'
      EditFormat = '#######0.00'
      Precision = 18
      Size = 2
    end
    object cdComExpOwnExp: TBooleanField
      FieldName = 'OwnExp'
      ProviderFlags = [pfInUpdate]
    end
    object cdComExpExpKindLookup: TStringField
      FieldKind = fkLookup
      FieldName = 'ExpKindLookup'
      LookupKeyFields = 'Code'
      LookupResultField = 'Name'
      KeyFields = 'ExpKind'
      ProviderFlags = []
      OnGetText = cdOwnExpExpKindLookupGetText
      Size = 50
      Lookup = True
    end
  end
  object aspComExpToUSD: TADOStoredProc
    ProcedureName = 'up_ComExpToUSD;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@Course'
        Attributes = [paNullable]
        DataType = ftFloat
        Precision = 15
        Value = Null
      end
      item
        Name = '@Mode'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@FromDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@ToDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@ExpKind'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@OwnExp'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end>
    Left = 40
    Top = 108
  end
end
