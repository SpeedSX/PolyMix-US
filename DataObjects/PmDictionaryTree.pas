unit PmDictionaryTree;

interface

uses Variants, DB, DBClient, PmEntity;

type
  TDictionaryTree = class(TEntity)
  protected
    procedure DoOnCalcFields; override;
    procedure ProviderBeforeUpdateRecord(Sender: TObject; SourceDS: TDataSet;
      DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind; var Applied: Boolean); override;
  public
    constructor Create;
    procedure Open; override;
    function ApplyUpdates: boolean; override;

    function GetNextFolderId: integer;
    function SetTreeViewDicDesc(RecordId: integer; dicName: string; var value: string): boolean;
  end;

implementation

uses DicData, RDBUtils, PmDatabase;

const
  F_Key = 'DicID';

constructor TDictionaryTree.Create;
begin
  inherited Create(F_Key);
  FEnableClearEvents := true;
  if DicDm <> nil then
  begin
    SetDataSet(DicDm.cdTreeViewDics);
    DataSetProvider := DicDm.pvTreeViewDics;
    //ADODataSet := DicDm.aqTreeViewDics;
  end;
end;

// Здесь нельзя применить обработку AfterConnect т.к. в этот момент sdm еще не создан
// не очень удобно, т.к. можно забыть вызвать Open и не устанавливаются timeouts.
procedure TDictionaryTree.Open;
begin
  if DataSet = nil then
  begin
    SetDataSet(DicDm.cdTreeViewDics);
    DataSetProvider := DicDm.pvTreeViewDics;
    //ADODataSet := DicDm.aqTreeViewDics;
  end;
  inherited Open;
  // открыть второй необходимый набор данных
  if not DicDM.cdDicsFolders.Active then
     Database.OpenDataSet(DicDm.cdDicsFolders);
end;

procedure TDictionaryTree.DoOnCalcFields;
begin
  if DataSet.Fields.FieldByName('isNotFolder').AsInteger = 0 then
    DataSet.Fields.FieldByName('C').AsInteger := 1
  else
    DataSet.Fields.FieldByName('C').AsInteger := 0;
end;

// Применение изменений к дереву - здесь меняются только другие наборы данных,
// а уже после применения изменений для них будут внесены изменения в БД.
procedure TDictionaryTree.ProviderBeforeUpdateRecord(Sender: TObject; SourceDS: TDataSet;
   DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind; var Applied: Boolean);
var
 isNotFolder: integer;
 dicID, lastDicId, parentID: integer;
 isFound: boolean;
 dicName, dicDesc: string;
 cdDics, cdDicsFolders: TClientDataSet;
begin
  cdDics := DicDm.cdDics;
  cdDicsFolders := DicDm.cdDicsFolders;

  isNotFolder := DeltaDS.FieldByName('IsNotFolder').OldValue;
  if isNotFolder = 0 then
  begin
    // Папка
    lastDicId := NvlInteger(cdDicsFolders.FieldByName('FolderID').Value);

    if UpdateKind = ukModify then
    begin
      dicID := DeltaDS.FieldByName('DicID').OldValue;
      isFound := cdDicsFolders.Locate('FolderID', dicID, []);
      if isFound then
      begin
        cdDicsFolders.Edit;
        if VarType(DeltaDS.FieldByName('ParentID').NewValue) <> varEmpty then
          cdDicsFolders.FieldByName('ParentID').Value := DeltaDS.FieldByName('ParentID').NewValue;
        if VarType(DeltaDS.FieldByName('DicDesc').NewValue) <> varEmpty then
          cdDicsFolders.FieldByName('DicDesc').Value := DeltaDS.FieldByName('DicDesc').NewValue;

        cdDicsFolders.Post;
      end
    end
    else if UpdateKind = ukInsert then
    begin
      cdDicsFolders.Insert();
      cdDicsFolders.FieldByName('FolderID').Value:=DeltaDS.FieldByName('DicID').NewValue;
      cdDicsFolders.FieldByName('DicDesc').Value:=DeltaDS.FieldByName('DicDesc').NewValue;
      cdDicsFolders.FieldByName('ParentID').Value:=DeltaDS.FieldByName('ParentID').NewValue;
      cdDicsFolders.Post;
    end
    else if UpdateKind = ukDelete then
    begin
      dicID := DeltaDS.FieldByName('DicID').OldValue;
      isFound := cdDicsFolders.Locate('FolderID', dicID, []);
      if isFound then
        cdDicsFolders.Delete;
    end;

    // Возвращаемся на текущую папку
    if (lastDicId <> 0) and (lastDicId <> cdDicsFolders.FieldByName('FolderID').Value) then
       cdDicsFolders.Locate('FolderID', lastDicId, []);
  end
  else
  begin
    // Справочник
    lastDicId := NvlInteger(cdDics.FieldByName('DicID').Value);

    if UpdateKind = ukModify then
    begin
      dicID := DeltaDS.FieldByName('DicID').OldValue;
      parentID := DeltaDS.FieldByName('ParentID').NewValue;
      isFound := cdDics.Locate('DicID', dicID, []);
      if isFound then
      begin
        cdDics.Edit;
        cdDics.FieldByName('ParentID').Value := parentID;
        // TODO: Other fields could be modified
        cdDics.Post;
      end;
    end
    else
    if UpdateKind = ukInsert then
    begin
      dicID := DeltaDS.FieldByName('DicID').NewValue;
      parentID := DeltaDS.FieldByName('ParentID').NewValue;
      cdDics.Insert;

      cdDics['DicID']:=DeltaDS.FieldByName('DicID').NewValue;
      cdDics.FieldByName('DicName').Value:=DeltaDS.FieldByName('DicName').NewValue;
      cdDics.FieldByName('DicDesc').Value:=DeltaDS.FieldByName('DicDesc').NewValue;
      cdDics.FieldByName('DicBuiltIn').Value:=DeltaDS.FieldByName('DicBuiltIn').NewValue;
      cdDics.FieldByName('DicReadOnly').Value:=DeltaDS.FieldByName('DicReadOnly').NewValue;
      cdDics.FieldByName('IsDim').Value:=DeltaDS.FieldByName('IsDim').NewValue;
      cdDics.FieldByName('MultiDim').Value:=DeltaDS.FieldByName('MultiDim').NewValue;
      cdDics.FieldByName('AllowModifyDim').Value:=DeltaDS.FieldByName('AllowModifyDim').NewValue;
      cdDics.FieldByName('AffectUserRights').Value:=DeltaDS.FieldByName('AffectUserRights').NewValue;
      cdDics.FieldByName('ParentID').Value:=DeltaDS.FieldByName('ParentID').NewValue;
    end
    else if UpdateKind = ukDelete then
    begin
      dicID := DeltaDS.FieldByName('DicID').OldValue;
      isFound := cdDics.Locate('DicID', dicID, []);
      if isFound then
        cdDics.Delete;
    end;

    // Возвращаемся на текущий справочник
    if (lastDicId <> 0) and (lastDicId <> cdDics.FieldByName('DicID').Value) then
       cdDics.Locate('DicID', lastDicId, []);
  end;
  Applied := true;
end;

function TDictionaryTree.GetNextFolderId: integer;
var
  OldFilter: string;
  OldFiltered: boolean;
  folderId: integer;
begin
  if not DataSet.Active then Exit;
  try
    begin
      OldFilter := DataSet.Filter;
      OldFiltered := DataSet.Filtered;

      DataSet.Filter := 'isNotFolder = 0';
      DataSet.Filtered := true;

      DataSet.First;
      Result := DataSet.FieldByName('DicID').AsInteger;

      while(not DataSet.Eof) do
      begin
        folderId := DataSet.FieldByName('DicID').AsInteger;
        if (folderId > Result) then
          Result := folderId;
        DataSet.Next;
      end;    // while
    end;
  finally
    begin
       DataSet.Filter := OldFilter;
       DataSet.Filtered := OldFiltered;
    end;
  end;

  Result := Result + 1;
end;

function TDictionaryTree.SetTreeViewDicDesc(RecordId: integer; dicName: string; var value: string): boolean;
var
  oldFiltered, isFound: boolean;
begin
   oldFiltered := DataSet.Filtered;
   Result := false;

   if not DataSet.Active then Exit;
   try
   begin
    oldFiltered := DataSet.Filtered;
    DataSet.Filtered := false;

    isFound := DataSet.Locate('DicID;DicName', VarArrayOf([RecordId,dicName]), []);
    if isFound then
    begin
     try
      DataSet.Edit;
      DataSet.FieldByName('DicDesc').Value := value;
      DataSet.Post;

      Result := true;
     except end;
    end;
   end;
   finally
    begin
      DataSet.Filtered := oldFiltered;
      if not Result then value := '';
    end;
   end;
end;

function TDictionaryTree.ApplyUpdates: boolean;
begin
  if DataSet.Active then
  begin
    inherited ApplyUpdates;
    DicDM.cdDics.ApplyUpdates(0);
    DicDM.cdDicsFolders.ApplyUpdates(0);
  end;
end;


end.
