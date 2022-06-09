unit PmCfgUpdater;

interface

uses Classes, Types, Controls, Dialogs, RDialogs, DBCLient, DB;

type
  TCfgUpdater = class
  private
    cdDiff: TClientDataSet;
    CfgDir: string;
    Collectors: TList;
    procedure CreateDiffDataSet(Owner: TComponent);
    procedure DoWriteScriptToFile(Sender: TObject);
    procedure FillDiffDataSet(Collectors: TList);
    //procedure ExcludeUnchecked(Collectors: TList);
  public
    procedure Execute;
  end;

var
  CfgUpdater: TCfgUpdater;

const
  fsNewCurrent = 1;
  fsChangedCurrent = 2;
  fsNewStandard = 3;
  fsChangedStandard = 4;

implementation

uses FileCtrl, SysUtils, DateUtils, RepData, ServData, fCfgDiff, RDbUtils, DiffUnit,
  HashUnit, JclFileUtils;

type
  TCfgCollector = class;

  TCollectedItem = class(TObject)
  public
    FileID: integer;
    FileState: integer;
    CurDate, FileDate: TDateTime;
    ScriptName, ScriptDesc: string;
    FileName, FilePath: string;
    Collector: TCfgCollector;
 end;

  TCfgCollector = class(TObject)
    FBaseFolder: string;
    FFolder: string;
    FDataSet: TClientDataSet;
    FCollected: TList;
    FDateFieldName, FScriptNameFieldName, FScriptDescFieldName, FScriptFieldName: string;
  protected
    FCheckExtensions: TStringList;
    procedure DoOnNewScript; virtual;
    procedure SaveFileTo(Col: TCollectedItem; FileName: string); virtual;
    procedure LoadFromFile(Col: TCollectedItem); virtual;
    procedure DoOnLoadScript(Col: TCollectedItem); virtual;
    function EqualContentFile(FileName: string; ScriptField: TField): boolean;
    function EqualContent(FileName: string): boolean; virtual;
  public
    property BaseFolder: string read FBaseFolder write FBaseFolder;
    property Collected: TList read FCollected;
    property Name: string read FFolder;

    procedure Collect; virtual;
    procedure ApplyChanges(FileIds: array of integer); virtual;
    destructor Destroy; override;
    constructor Create(_DataSet: TClientDataSet; _Folder, _ScriptNameFieldName, _ScriptDescFieldName: string);
    procedure Exclude(ScriptName, FileName: string);
    procedure SaveFileTemp(ScriptName: string);
    procedure SaveFileToCfg(Col: TCollectedItem);
  end;

  TEventCollector = class(TCfgCollector)
    constructor Create;
  end;

  TProcessCollector = class(TCfgCollector)
    constructor Create;
    procedure Collect; override;
  end;

  TFormCollector = class(TCfgCollector)
  protected
    procedure SaveFileTo(Col: TCollectedItem; FileName: string); override;
    procedure DoOnLoadScript(Col: TCollectedItem); override;
    function EqualContent(FileName: string): boolean; override;
  public
    constructor Create;
  end;

  TUnitCollector = class(TCfgCollector)
  protected
    procedure DoOnNewScript; override;
  public
    constructor Create;
    procedure Collect; override;
  end;

  TReportCollector = class(TCfgCollector)
  protected
    procedure DoOnNewScript; override;
  public
    constructor Create;
    procedure Collect; override;
  end;

procedure TCfgUpdater.Execute;
var
  i: integer;
  FileIDs: array of integer;
begin
  if SelectDirectory(CfgDir, [], 0) then begin
    Collectors := TList.Create;
    try
      Collectors.Add(TEventCollector.Create);
      Collectors.Add(TProcessCollector.Create);
      Collectors.Add(TFormCollector.Create);
      Collectors.Add(TUnitCollector.Create);
      Collectors.Add(TReportCollector.Create);
      for i := 0 to Collectors.Count - 1 do begin
        TCfgCollector(Collectors[i]).BaseFolder := CfgDir;
        TCfgCollector(Collectors[i]).Collect;
      end;
      CfgDiffForm := TCfgDiffForm.Create(nil);
      try
        CreateDiffDataSet(CfgDiffForm);
        FillDiffDataSet(Collectors);
        cdDiff.First;
        CfgDiffForm.DiffDataSet := cdDiff;
        CfgDiffForm.OnWriteScriptToFile := DoWriteScriptToFile;
        if CfgDiffForm.ShowModal = mrOk then begin
          cdDiff.Filter := 'Checked';
          cdDiff.Filtered := true;
          if not cdDiff.IsEmpty then begin
            SetLength(FileIds, cdDiff.RecordCount);
            i := 0;
            while not cdDiff.eof do begin
              FileIds[i] := cdDiff['FileID'];
              cdDiff.Next;
              Inc(i);
            end;
            //ExcludeUnchecked(Collectors);
            for i := 0 to Collectors.Count - 1 do
              TCfgCollector(Collectors[i]).ApplyChanges(FileIds);
            RusMessageDlg('Изменения применены успешно', mtInformation, [mbOk], 0);
          end;
        end;
      finally
        CfgDiffForm.Free;
      end;
    finally
      // подчищаем
      for i := 0 to Collectors.Count - 1 do
        TCfgCollector(Collectors[i]).Free;
      Collectors.Free;
    end;
  end;
end;

procedure TCfgUpdater.CreateDiffDataSet(Owner: TComponent);
begin
  cdDiff := TClientDataSet.Create(Owner);
  with cdDiff do begin
    with TBooleanField.Create(Owner) do begin
      Name := 'cdDiffChecked';
      FieldKind := fkData;
      FieldName := 'Checked';
      DataSet := cdDiff;
    end;
    with TIntegerField.Create(Owner) do begin
      Name := 'cdDiffFileState';
      FieldKind := fkData;
      FieldName := 'FileState';
      DataSet := cdDiff;
    end;
    with TIntegerField.Create(Owner) do begin
      Name := 'cdDiffFileID';
      FieldKind := fkData;
      FieldName := 'FileID';
      DataSet := cdDiff;
    end;
    with TDateTimeField.Create(Owner) do begin
      Name := 'cdDiffFileDate';
      FieldKind := fkData;
      FieldName := 'FileDate';
      DataSet := cdDiff;
    end;
    with TDateTimeField.Create(Owner) do begin
      Name := 'cdDiffCurDate';
      FieldKind := fkData;
      FieldName := 'CurDate';
      DataSet := cdDiff;
    end;
    with TStringField.Create(Owner) do begin
      Name := 'cdScriptName';
      FieldKind := fkData;
      FieldName := 'ScriptName';
      Size := 255;
      DataSet := cdDiff;
    end;
    with TStringField.Create(Owner) do begin
      Name := 'cdScriptDesc';
      FieldKind := fkData;
      FieldName := 'ScriptDesc';
      Size := 255;
      DataSet := cdDiff;
    end;
    with TStringField.Create(Owner) do begin
      Name := 'cdFileName';
      FieldKind := fkData;
      FieldName := 'FileName';
      Size := 255;
      DataSet := cdDiff;
    end;
    with TStringField.Create(Owner) do begin
      Name := 'cdFilePath';
      FieldKind := fkData;
      FieldName := 'FilePath';
      Size := 255;
      DataSet := cdDiff;
    end;
    with TStringField.Create(Owner) do begin
      Name := 'cdCollector';
      FieldKind := fkData;
      FieldName := 'Collector';
      Size := 255;
      DataSet := cdDiff;
    end;
  end;
  cdDiff.CreateDataSet;
end;

procedure TCfgUpdater.DoWriteScriptToFile(Sender: TObject);
var
  i: integer;
  ColName: string;
begin
  ColName := cdDiff['Collector'];
  for i := 0 to Collectors.Count - 1 do
    if ColName = TCfgCollector(Collectors[i]).Name then
    begin
      TCfgCollector(Collectors[i]).SaveFileTemp(cdDiff['ScriptName']);
      Exit;
    end;
end;

procedure TCfgUpdater.FillDiffDataSet(Collectors: TList);
var
  I, c: Integer;
  ColList: TList;
  Col: TCollectedItem;
  FileID: integer;
  Collector: TCfgCollector;
begin
  FileID := 1;
  for I := 0 to Collectors.Count - 1 do
  begin
    Collector := TCfgCollector(Collectors[i]);
    ColList := Collector.Collected;
    if ColList.Count > 0 then
      for c := 0 to ColList.Count - 1 do
      begin
        Col := TCollectedItem(ColList[c]);
        cdDiff.Append;
        cdDiff['FileID'] := FileID;
        Col.FileID := FileID;
        cdDiff['Checked'] := false;
        cdDiff['FileState'] := Col.FileState;
        cdDiff['FileDate'] := Col.FileDate;
        cdDiff['CurDate'] := Col.CurDate;
        cdDiff['ScriptName'] := Col.ScriptName;
        cdDiff['ScriptDesc'] := Col.ScriptDesc;
        cdDiff['FileName'] := Col.FileName;
        cdDiff['FilePath'] := Col.FilePath;
        cdDiff['Collector'] := Collector.Name;
        Inc(FileID);
      end;
  end;
end;

{procedure TCfgUpdater.ExcludeUnchecked(Collectors: TList);
var
  Collector: TCfgCollector;
  i: integer;
begin
  cdDiff.Filtered := true;
  for i := 0 to Collectors.Count - 1 do
  begin
    Collector := TCfgCollector(Collectors[i]);
    cdDiff.Filter := 'Collector=''' + Collector.Name + ''' and not Checked';
    while not cdDiff.eof do begin
      Collector.Exclude(cdDiff['ScriptName'], cdDiff['FileName']);
      cdDiff.Next;
    end;
  end;
end;}

procedure TCfgCollector.Collect;
var
  F: TSearchRec;
  DosError: integer;
  Collected: TCollectedItem;
  FileName, SearchFolder: string;
begin
  FDataSet.Open;
  // идем по файлам стандартной конфигурации...
  SearchFolder := FBaseFolder + '\' + FFolder + '\';
  DosError := FindFirst(SearchFolder + '*.pas', faAnyFile, F);
  try
    while DosError = 0 do
    begin
      //ext := ExtractFileExt(F.Name);
      if (F.Attr <> faDirectory) {and (CompareStr(ext, '.pas') = 0) }then
      begin
        Collected := nil;
        if FDataSet.Locate(FScriptNameFieldName, PathExtractFileNameNoExt(F.Name), [loCaseInsensitive]) then
        begin
          // файл найден в текущей конфигурации
          if CompareDateTime(FileDateToDateTime(F.Time), NvlFloat(FDataSet[FDateFieldName])) <> EqualsValue then
          begin
            // Дата разная. Надо сравнить содержимое.
            if not EqualContent(SearchFolder + F.Name) then
            begin
              Collected := TCollectedItem.Create;
              Collected.FileDate := FileDateToDateTime(F.Time);
              Collected.CurDate := NvlFloat(FDataSet[FDateFieldName]);
              Collected.ScriptName := FDataSet[FScriptNameFieldName];
              Collected.FilePath := SearchFolder + F.Name;
              Collected.ScriptDesc := NvlString(FDataSet[FScriptDescFieldName]);
              Collected.FileName := ExtractFileName(F.Name);
              if CompareDateTime(FileDateToDateTime(F.Time), NvlFloat(FDataSet[FDateFieldName])) = GreaterThanValue	then
                Collected.FileState := fsChangedStandard
              else
                Collected.FileState := fsChangedCurrent;
            end;
          end;
        end else begin // файл не найден в текущей конфигурации
          Collected := TCollectedItem.Create;
          Collected.FileDate := FileDateToDateTime(F.Time);
          Collected.ScriptName := PathExtractFileNameNoExt(F.Name);
          Collected.ScriptDesc := '';//ExtractFileName(F.Name);
          Collected.FileName := ExtractFileName(F.Name);
          Collected.FilePath := SearchFolder + F.Name;
          Collected.FileState := fsNewStandard;
        end;
        if Collected <> nil then begin
          Collected.Collector := Self;
          FCollected.Add(Collected);
        end;
      end;
      DosError := FindNext(F);
    end;
  finally
    FindClose(F);
  end;
  // идем по файлам текущей конфигурации...
  FDataSet.First;
  while not FDataSet.eof do begin
    //for i := 0 to FCheckExtensions.Count - 1 do begin
    //  FileName := FBaseFolder + FFolder + '\' + FDataSet[FScriptNameFieldName] + FCheckExtensions[i];
      FileName := FBaseFolder + '\' + FFolder + '\' + FDataSet[FScriptNameFieldName] + '.pas';
      if not FileExists(FileName) then begin
        Collected := TCollectedItem.Create;
        Collected.CurDate := FDataSet[FDateFieldName];
        Collected.ScriptName := FDataSet[FScriptNameFieldName];
        Collected.ScriptDesc := NvlString(FDataSet[FScriptDescFieldName]);
        Collected.FileName := FDataSet[FScriptNameFieldName] + '.pas';
        Collected.FilePath := FileName;
        Collected.FileState := fsNewCurrent;
        FCollected.Add(Collected);
      end;
    //end;
    FDataSet.Next;
  end;
end;

function TCfgCollector.EqualContent(FileName: string): boolean;
begin
  Result := EqualContentFile(FileName, FDataSet.FieldByName(FScriptFieldName));
end;

function TCfgCollector.EqualContentFile(FileName: string; ScriptField: TField): boolean;
var
  Diff: TDiff;
  HashList1, HashList2: TList;
  //TempFileName: string;
  Lines1, Lines2: TStrings;
  i: integer;
begin
  Result := false;
  Lines1 := TStringList.create;
  Lines2 := TStringList.create;
  HashList1 := TList.create;
  HashList2 := TList.create;
  Diff := TDiff.Create(nil);
  try
    Lines1.LoadFromFile(FileName);
    ReadStringListFromBlob(Lines2, ScriptField as TBlobField);
    //create the hash lists to compare...
    HashList1.capacity := Lines1.Count;
    HashList2.capacity := Lines2.Count;
    for i := 0 to Lines1.Count-1 do
      HashList1.add(HashLine(Lines1[i], false, false));
    for i := 0 to Lines2.Count-1 do
      HashList2.add(HashLine(Lines2[i], false, false));

    //screen.cursor := crHourglass;
    try
      //CALCULATE THE DIFFS HERE ...
      if not Diff.Execute(PIntArray(HashList1.List), PIntArray(HashList2.List),
        HashList1.count, HashList2.count) then exit;
      Result := Diff.ChangeCount = 0;
    finally
      //screen.cursor := crDefault;
    end;
  finally
    Diff.Free;
    HashList1.Free;
    HashList2.Free;
    Lines1.Free;
    Lines2.Free;
  end;
end;

procedure TCfgCollector.ApplyChanges(FileIds: array of integer);
var
  f, i, fid: integer;
  Col: TCollectedItem;
begin
  if FCollected.Count > 0 then
    for f := 0 to Length(FileIds) - 1 do
    begin
      fid := FileIds[f];
      for i := 0 to FCollected.Count - 1 do
      begin
        Col := TCollectedItem(FCollected[i]);
        if fid = Col.FileID then
        begin
          case Col.FileState of
             fsNewCurrent: SaveFileToCfg(Col);
             fsChangedCurrent: SaveFileToCfg(Col);
             fsNewStandard: LoadFromFile(Col);
             fsChangedStandard: LoadFromFile(Col);
          end;
          break;
        end;
      end;
      FDataSet.ApplyUpdates(0);
    end;
end;

procedure TCfgCollector.SaveFileTemp(ScriptName: string);
var
  Col: TCollectedItem;
  i: integer;
begin
  for i := 0 to FCollected.Count - 1 do begin
    Col := TCollectedItem(FCollected[i]);
    if Col.ScriptName = ScriptName then begin
      SaveFileTo(Col, ExtractFilePath(ParamStr(0)) + CfgTempFileName);
      Exit;
    end;
  end;
end;

procedure TCfgCollector.SaveFileToCfg(Col: TCollectedItem);
begin
  SaveFileTo(Col, FBaseFolder + '\' + FFolder + '\' + Col.FileName);
end;

procedure TCfgCollector.SaveFileTo(Col: TCollectedItem; FileName: string);
begin
  if FDataSet.Locate(FScriptNameFieldName, Col.ScriptName, [loCaseInsensitive]) then begin
    (FDataSet.FieldByName(FScriptFieldName) as TBlobField).SaveToFile(FileName);
    FileSetDate(FileName, DateTimeToFileDate(Col.CurDate));
  end else
    raise Exception.Create('Не найден сценарий ' + Col.ScriptName);
end;

destructor TCfgCollector.Destroy;
var i: integer;
begin
  if FCollected.Count > 0 then
    for i := 0 to FCollected.Count - 1 do
      TCollectedItem(FCollected[i]).Free;
  FCollected.Free;
  FCheckExtensions.Free;
  inherited Destroy;
end;

constructor TCfgCollector.Create(_DataSet: TClientDataSet;
  _Folder, _ScriptNameFieldName, _ScriptDescFieldName: string);
begin
  inherited Create;
  FCollected := TList.Create;
  FDataSet := _DataSet;
  FFolder := _Folder;
  FDateFieldName := 'ModifyDate';
  FScriptFieldName := 'Script';
  FScriptNameFieldName := _ScriptNameFieldName;
  FScriptDescFieldName := _ScriptDescFieldName;
  FCheckExtensions := TStringList.Create;
  FCheckExtensions.Add('.pas');
end;

procedure TCfgCollector.DoOnNewScript;
begin
end;

procedure TCfgCollector.Exclude(ScriptName, FileName: string);
var
  i: integer;
  Col: TCollectedItem;
begin
  if FCollected.Count > 0 then begin
    for i := 0 to FCollected.Count - 1 do
    begin
      Col := TCollectedItem(FCollected.Items[i]);
      if (Col.FileName = FileName) and (Col.ScriptName = ScriptName) then begin
        FCollected.Delete(i);
        Exit;
      end;
    end;
  end;
  raise Exception.Create('Не найден файл для Exclude (ScriptName = ' + ScriptName + ', FileName = ' + FileName);
end;

procedure TCfgCollector.LoadFromFile(Col: TCollectedItem);
begin
  if FDataSet.Locate(FScriptNameFieldName, Col.ScriptName, [loCaseInsensitive]) then begin
    FDataSet.Edit;
  end else begin
    FDataSet.Append;
    FDataSet[FScriptNameFieldName] := Col.ScriptName;
    FDataSet[FScriptDescFieldName] := Col.ScriptName;
    FDataSet[FDateFieldName] := Col.FileDate;
    DoOnNewScript;
  end;
  DoOnLoadScript(Col);
  FDataSet.Post;
end;

procedure TCfgCollector.DoOnLoadScript(Col: TCollectedItem);
begin
 (FDataSet.FieldByName(FScriptFieldName) as TBlobField).LoadFromFile(Col.FilePath);
end;

constructor TEventCollector.Create;
begin
  inherited Create(rdm.cdOrdScripts, 'Events', 'ScriptName', 'ScriptDesc');
end;

constructor TFormCollector.Create;
begin
  inherited Create(rdm.cdForms, 'Forms', 'FormName', 'FormDesc');
  FCheckExtensions.Add('.dfm');
end;

procedure TFormCollector.DoOnLoadScript(Col: TCollectedItem);
begin
  (FDataSet.FieldByName(FormPasField) as TBlobField).LoadFromFile(Col.FilePath);
  (FDataSet.FieldByName(FormDfmField) as TBlobField).LoadFromFile(ChangeFileExt(Col.FilePath, '.dfm'));
end;

procedure TFormCollector.SaveFileTo(Col: TCollectedItem; FileName: string);
begin
  if FDataSet.Locate(FScriptNameFieldName, Col.ScriptName, [loCaseInsensitive]) then begin
    //if ExtractFileExtension(Col.FileName) = '.dfm' then
      //(FDataSet.FieldByName(FormDfmField) as TBlobField).SaveToFile(FileName);
    //else
    (FDataSet.FieldByName(FormPasField) as TBlobField).SaveToFile(FileName);
    FileSetDate(FileName, DateTimeToFileDate(Col.CurDate));
    FileName := ChangeFileExt(FileName, '.dfm');
    (FDataSet.FieldByName(FormDfmField) as TBlobField).SaveToFile(FileName);
    FileSetDate(FileName, DateTimeToFileDate(Col.CurDate));
  end else
    raise Exception.Create('Не найден сценарий ' + Col.ScriptName);
end;

function TFormCollector.EqualContent(FileName: string): boolean;
begin
  Result := EqualContentFile(FileName, FDataSet.FieldByName(FormPasField))
   and EqualContentFile(ChangeFileExt(FileName, '.dfm'), FDataSet.FieldByName(FormDfmField));
end;

constructor TUnitCollector.Create;
begin
  inherited Create(rdm.cdReports, 'Units', 'ScriptName', 'ScriptDesc');
end;

procedure TUnitCollector.Collect;
var
  SaveFilter: string;
  SaveFiltered: boolean;
begin
  SaveFilter := FDataSet.Filter;
  SaveFiltered := FDataSet.Filtered;
  try
    FDataSet.Filter := 'IsUnit';
    FDataSet.Filtered := true;
    FDataSet.Open;
    inherited Collect;
  finally
    FDataSet.Filter := SaveFilter;
    FDataSet.Filtered := SaveFiltered;
  end;
end;

procedure TUnitCollector.DoOnNewScript;
begin
  FDataSet['IsUnit'] := true;
end;

constructor TReportCollector.Create;
begin
  inherited Create(rdm.cdReports, 'Reports', 'ScriptName', 'ScriptDesc');
end;

procedure TReportCollector.Collect;
var
  SaveFilter: string;
  SaveFiltered: boolean;
begin
  SaveFilter := FDataSet.Filter;
  SaveFiltered := FDataSet.Filtered;
  try
    FDataSet.Filter := 'not IsUnit';
    FDataSet.Filtered := true;
    FDataSet.Open;
    inherited Collect;
  finally
    FDataSet.Filter := SaveFilter;
    FDataSet.Filtered := SaveFiltered;
  end;
end;

procedure TReportCollector.DoOnNewScript;
begin
  FDataSet['IsUnit'] := false;
end;

constructor TProcessCollector.Create;
begin
  inherited Create(sdm.cdServices, 'StandardProcesses', '', '');
end;

procedure TProcessCollector.Collect;
begin
end;

initialization

CfgUpdater := TCfgUpdater.Create;

finalization

CfgUpdater.Free;

end.
