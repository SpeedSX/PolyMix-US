object DicDm: TDicDm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 473
  Width = 643
  object dsFieldInfo: TDataSource
    DataSet = cdFieldInfo
    Left = 208
    Top = 132
  end
  object cdAllDics: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvAllDics'
    Left = 136
    Top = 64
    object cdAllDicsDicID: TAutoIncField
      FieldName = 'DicID'
    end
    object cdAllDicsDicName: TStringField
      FieldName = 'DicName'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object cdAllDicsDicDesc: TStringField
      FieldName = 'DicDesc'
      ProviderFlags = [pfInUpdate]
      Size = 60
    end
    object cdAllDicsDicBuiltIn: TBooleanField
      FieldName = 'DicBuiltIn'
      ProviderFlags = [pfInUpdate]
    end
    object cdAllDicsDicReadOnly: TBooleanField
      FieldName = 'DicReadOnly'
      ProviderFlags = [pfInUpdate]
    end
    object cdAllDicsIsDim: TBooleanField
      FieldName = 'IsDim'
      ProviderFlags = [pfInUpdate]
    end
    object cdAllDicsMultiDim: TBooleanField
      FieldName = 'MultiDim'
      ProviderFlags = [pfInUpdate]
    end
    object cdAllDicsAllowModifyDim: TBooleanField
      FieldName = 'AllowModifyDim'
      ProviderFlags = [pfInUpdate]
    end
    object cdAllDicsParentID: TIntegerField
      FieldName = 'ParentID'
      ProviderFlags = [pfInUpdate]
    end
  end
  object pvAllDics: TDataSetProvider
    DataSet = aqAllDics
    Left = 76
    Top = 64
  end
  object aqAllDics: TADOQuery
    Connection = dm.cnCalc
    Parameters = <>
    SQL.Strings = (
      
        'select DicID, DicName, DicDesc, DicBuiltIn, DicReadOnly, IsDim, ' +
        'MultiDim, AllowModifyDim, ParentID'
      'from'
      '   DicElements'
      'order by DicDesc')
    Left = 16
    Top = 64
    object aqAllDicsDicID: TIntegerField
      FieldName = 'DicID'
    end
    object aqAllDicsDicName: TStringField
      FieldName = 'DicName'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object aqAllDicsDicDesc: TStringField
      FieldName = 'DicDesc'
      ProviderFlags = [pfInUpdate]
      Size = 60
    end
    object aqAllDicsDicBuiltIn: TBooleanField
      FieldName = 'DicBuiltIn'
      ProviderFlags = [pfInUpdate]
    end
    object aqAllDicsDicReadOnly: TBooleanField
      FieldName = 'DicReadOnly'
      ProviderFlags = [pfInUpdate]
    end
    object aqAllDicsIsDim: TBooleanField
      FieldName = 'IsDim'
      ProviderFlags = [pfInUpdate]
    end
    object aqAllDicsMultiDim: TBooleanField
      FieldName = 'MultiDim'
      ProviderFlags = [pfInUpdate]
    end
    object aqAllDicsAllowModifyDim: TBooleanField
      FieldName = 'AllowModifyDim'
      ProviderFlags = [pfInUpdate]
    end
    object aqAllDicsParentID: TIntegerField
      FieldName = 'ParentID'
      ProviderFlags = [pfInUpdate]
    end
  end
  object aqFieldInfo: TADOQuery
    Connection = dm.cnCalc
    Parameters = <>
    SQL.Strings = (
      
        'select DicFieldID, DicID, FieldName, FieldDesc, FieldType, [Leng' +
        'th], [Precision], ReferenceID'
      'from DicFields'
      'order by DicID, FieldName')
    Left = 14
    Top = 140
    object aqFieldInfoDicFieldID: TAutoIncField
      FieldName = 'DicFieldID'
      ReadOnly = True
    end
    object aqFieldInfoDicID: TIntegerField
      FieldName = 'DicID'
    end
    object aqFieldInfoFieldName: TStringField
      FieldName = 'FieldName'
      Size = 40
    end
    object aqFieldInfoFieldDesc: TStringField
      FieldName = 'FieldDesc'
      Size = 40
    end
    object aqFieldInfoFieldType: TIntegerField
      FieldName = 'FieldType'
      ProviderFlags = [pfInUpdate]
    end
    object aqFieldInfoReferenceID: TIntegerField
      FieldName = 'ReferenceID'
      ProviderFlags = [pfInUpdate]
    end
    object aqFieldInfoLength: TIntegerField
      FieldName = 'Length'
      ProviderFlags = [pfInUpdate]
    end
    object aqFieldInfoPrecision: TIntegerField
      FieldName = 'Precision'
      ProviderFlags = [pfInUpdate]
    end
  end
  object pvFieldInfo: TDataSetProvider
    DataSet = aqFieldInfo
    Left = 74
    Top = 138
  end
  object cdFieldInfo: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pvFieldInfo'
    Left = 142
    Top = 136
    object cdFieldInfoDicFieldID: TAutoIncField
      FieldName = 'DicFieldID'
      ReadOnly = True
    end
    object cdFieldInfoDicID: TIntegerField
      FieldName = 'DicID'
    end
    object cdFieldInfoFieldName: TStringField
      FieldName = 'FieldName'
      Size = 40
    end
    object cdFieldInfoFieldDesc: TStringField
      FieldName = 'FieldDesc'
      Size = 40
    end
    object cdFieldInfoFieldType: TIntegerField
      FieldName = 'FieldType'
      ProviderFlags = [pfInUpdate]
    end
    object cdFieldInfoReferenceID: TIntegerField
      FieldName = 'ReferenceID'
      ProviderFlags = [pfInUpdate]
    end
    object cdFieldInfoLength: TIntegerField
      FieldName = 'Length'
      ProviderFlags = [pfInUpdate]
    end
    object cdFieldInfoPrecision: TIntegerField
      FieldName = 'Precision'
      ProviderFlags = [pfInUpdate]
    end
  end
  object aupNewDic: TADOStoredProc
    Connection = dm.cnCalc
    ProcedureName = 'up_NewTableDictionary;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@DicName'
        Attributes = [paNullable]
        DataType = ftString
        Size = 40
        Value = Null
      end
      item
        Name = '@DicDesc'
        Attributes = [paNullable]
        DataType = ftString
        Size = 40
        Value = Null
      end
      item
        Name = '@DicBuiltIn'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@ParentID'
        Attributes = [paNullable]
        DataType = ftInteger
        Value = Null
      end>
    Left = 300
    Top = 82
  end
  object aupDelDic: TADOStoredProc
    Connection = dm.cnCalc
    ProcedureName = 'up_DeleteDictionary;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@DicName'
        Attributes = [paNullable]
        DataType = ftString
        Size = 40
        Value = Null
      end>
    Left = 364
    Top = 86
  end
  object aupUpdateDic: TADOStoredProc
    Connection = dm.cnCalc
    ProcedureName = 'up_UpdateTableDictionary;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@DicID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@DicName'
        Attributes = [paNullable]
        DataType = ftString
        Size = 40
        Value = Null
      end
      item
        Name = '@DicDesc'
        Attributes = [paNullable]
        DataType = ftString
        Size = 40
        Value = Null
      end
      item
        Name = '@DicBuiltIn'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end>
    Left = 302
    Top = 134
  end
  object aqStruct: TADOQuery
    Connection = dm.cnCalc
    LockType = ltBatchOptimistic
    Parameters = <>
    SQL.Strings = (
      
        'select [ID], [FieldName], [FieldDesc], [FieldType], [Length], [P' +
        'recision], [Predefined], [ReferenceID], [HasFieldType]'
      'from DicStruct where 1=0')
    Left = 24
    Top = 286
    object aqStructID: TIntegerField
      FieldName = 'ID'
    end
    object aqStructFieldType: TIntegerField
      FieldName = 'FieldType'
    end
    object aqStructLength: TIntegerField
      FieldName = 'Length'
    end
    object aqStructPrecision: TIntegerField
      FieldName = 'Precision'
    end
    object aqStructPredefined: TBooleanField
      FieldName = 'Predefined'
    end
    object aqStructFieldName: TStringField
      FieldName = 'FieldName'
      Size = 40
    end
    object aqStructFieldDesc: TStringField
      FieldName = 'FieldDesc'
      Size = 40
    end
    object aqStructReferenceID: TIntegerField
      FieldName = 'ReferenceID'
    end
    object aqStructHasFieldType: TBooleanField
      FieldName = 'HasFieldType'
    end
  end
  object cdStruct: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ID'
    Params = <>
    ProviderName = 'pvStruct'
    BeforeInsert = DicStructBeforeInsert
    BeforeDelete = DicStructBeforeDelete
    OnNewRecord = DicStructNewRecord
    Left = 132
    Top = 288
    object cdStructID: TIntegerField
      FieldName = 'ID'
    end
    object cdStructFieldName: TStringField
      FieldName = 'FieldName'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object cdStructFIeldDesc: TStringField
      FieldName = 'FIeldDesc'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object cdStructFieldType: TIntegerField
      FieldName = 'FieldType'
      ProviderFlags = [pfInUpdate]
      OnChange = DicFieldTypeChange
    end
    object cdStructLength: TIntegerField
      FieldName = 'Length'
      ProviderFlags = [pfInUpdate]
    end
    object cdStructPrecision: TIntegerField
      FieldName = 'Precision'
      ProviderFlags = [pfInUpdate]
    end
    object cdStructPredefined: TBooleanField
      FieldName = 'Predefined'
    end
    object cdStructReferenceID: TIntegerField
      FieldName = 'ReferenceID'
    end
    object cdStructHasFieldType: TBooleanField
      FieldName = 'HasFieldType'
    end
  end
  object pvStruct: TDataSetProvider
    DataSet = aqStruct
    BeforeUpdateRecord = pvStructBeforeUpdateRecord
    Left = 76
    Top = 288
  end
  object aqOldStruct: TADOQuery
    Connection = dm.cnCalc
    LockType = ltBatchOptimistic
    Parameters = <>
    SQL.Strings = (
      
        'select [ID], [FieldName], [FIeldDesc], [FieldType], [Length], [P' +
        'recision], [Predefined], [ReferenceID], [HasFieldType]'
      'from DicStruct where 1=0')
    Left = 26
    Top = 344
    object aqOldStructID: TIntegerField
      FieldName = 'ID'
    end
    object aqOldStructFieldType: TIntegerField
      FieldName = 'FieldType'
    end
    object aqOldStructLength: TIntegerField
      FieldName = 'Length'
    end
    object aqOldStructPrecision: TIntegerField
      FieldName = 'Precision'
    end
    object aqOldStructPredefined: TBooleanField
      FieldName = 'Predefined'
    end
    object aqOldStructFieldName: TStringField
      FieldName = 'FieldName'
      Size = 40
    end
    object aqOldStructFieldDesc: TStringField
      FieldName = 'FieldDesc'
      Size = 40
    end
    object aqOldStructReferenceID: TIntegerField
      FieldName = 'ReferenceID'
    end
    object aqOldStructHasFieldType: TBooleanField
      FieldName = 'HasFieldType'
    end
  end
  object pvOldStruct: TDataSetProvider
    DataSet = aqOldStruct
    BeforeUpdateRecord = pvStructBeforeUpdateRecord
    Left = 90
    Top = 340
  end
  object cdOldStruct: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ID'
    Params = <>
    ProviderName = 'pvOldStruct'
    BeforeInsert = DicStructBeforeInsert
    BeforeDelete = DicStructBeforeDelete
    OnNewRecord = DicStructNewRecord
    Left = 152
    Top = 340
    object cdOldStructID: TIntegerField
      FieldName = 'ID'
    end
    object cdOldStructFieldName: TStringField
      FieldName = 'FieldName'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object cdOldStructFIeldDesc: TStringField
      FieldName = 'FIeldDesc'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object cdOldStructFieldType: TIntegerField
      FieldName = 'FieldType'
      ProviderFlags = [pfInUpdate]
    end
    object cdOldStructLength: TIntegerField
      FieldName = 'Length'
      ProviderFlags = [pfInUpdate]
    end
    object cdOldStructPrecision: TIntegerField
      FieldName = 'Precision'
      ProviderFlags = [pfInUpdate]
    end
    object cdOldStructPredefined: TBooleanField
      FieldName = 'Predefined'
    end
    object cdOldStructReferenceID: TIntegerField
      FieldName = 'ReferenceID'
    end
    object cdOldStructHasFieldType: TBooleanField
      FieldName = 'HasFieldType'
    end
  end
  object aqDicsFolders: TADOQuery
    Connection = dm.cnCalc
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select FolderID, DicDesc, ParentID'
      'from DicFolders'
      'order by DicDesc')
    Left = 462
    Top = 240
  end
  object pvDicsFolders: TDataSetProvider
    DataSet = aqDicsFolders
    Left = 462
    Top = 294
  end
  object cdDicsFolders: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'FolderID'
        Attributes = [faReadonly]
        DataType = ftAutoInc
      end
      item
        Name = 'DicDesc'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ParentID'
        DataType = ftInteger
      end>
    IndexDefs = <>
    Params = <>
    ProviderName = 'pvDicsFolders'
    StoreDefs = True
    Left = 464
    Top = 352
    object cdDicsFoldersFolderID: TAutoIncField
      FieldName = 'FolderID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object cdDicsFoldersDicDesc: TStringField
      FieldName = 'DicDesc'
      ProviderFlags = [pfInUpdate]
      Size = 60
    end
    object cdDicsFoldersParentID: TIntegerField
      FieldName = 'ParentID'
      ProviderFlags = [pfInUpdate]
    end
  end
end
