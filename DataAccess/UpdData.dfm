object udm: Tudm
  OldCreateOrder = False
  Left = 392
  Top = 218
  Height = 150
  Width = 215
  object aqImage: TADOQuery
    CursorType = ctStatic
    CommandTimeout = 300
    Parameters = <>
    SQL.Strings = (
      'SELECT FileID, FileName, FileVersion, FileDate, FileImage '
      'FROM PolyCalcVersion')
    Left = 102
    Top = 32
    object aqImageFileID: TAutoIncField
      FieldName = 'FileID'
      ReadOnly = True
    end
    object aqImageFileName: TStringField
      FieldName = 'FileName'
      ProviderFlags = [pfInUpdate]
      Size = 80
    end
    object aqImageFileVersion: TIntegerField
      FieldName = 'FileVersion'
      ProviderFlags = [pfInUpdate]
    end
    object aqImageFileDate: TDateTimeField
      FieldName = 'FileDate'
      ProviderFlags = [pfInUpdate]
    end
    object aqImageFileImage: TBlobField
      FieldName = 'FileImage'
      ProviderFlags = [pfInUpdate]
    end
  end
  object aqClear: TADOQuery
    CommandTimeout = 300
    Parameters = <>
    SQL.Strings = (
      'delete from PolyCalcVersion')
    Left = 148
    Top = 32
  end
end
