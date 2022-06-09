unit PmScriptExchange;

interface

uses Classes, SysUtils, DB, PmProcessCfg;

type
  TScriptExchange = class(TObject)
  private
    ScriptDir: string;
    function EachWriteScriptToFile(Srv: TPolyProcessCfg): boolean;
    function EachReadScriptFromFile(Srv: TPolyProcessCfg): boolean;
    function ReadScriptFromFile(SrvName, ScrName: string): boolean;
    function ReadGridScriptsFromFile(Srv: TPolyProcessCfg): boolean;
    function WriteScriptToFile(SrvName, ScrName: string): boolean;
    function WriteGridScriptsToFile(Srv: TPolyProcessCfg): boolean;
  public
    function ImportScriptsFromFiles: boolean;
    function ExportScriptsToFiles: boolean; overload;
    function ExportScriptsToFiles(Process: TPolyProcessCfg): boolean; overload;
  end;

var
  ScriptExchange: TScriptExchange;

implementation

uses JvJCLUtils, JvBrowseFolder, ServData, RDBUtils, PmConfigManager;

function TScriptExchange.EachReadScriptFromFile(Srv: TPolyProcessCfg): boolean;
var i: integer;
begin
  Result := true;
  if sdm.cdServices.Locate('SrvID', Srv.SrvID, []) {and not Srv.OnlyWorkOrder} then
  begin
    if (Srv.BaseSrv = nil) and (Srv.Scripts.Count > 0) then
      for i := 0 to Pred(Srv.Scripts.Count) do
        ReadScriptFromFile(Srv.TableName, Srv.Scripts[i]);
    //if Srv is TGridPolyProcess then
       ReadGridScriptsFromFile(Srv{ as TGridPolyProcess});
  end;
end;

function TScriptExchange.ImportScriptsFromFiles: boolean;
begin
  ScriptDir := ExtractFileDir(paramstr(0));
  if BrowseDirectory(ScriptDir, '»мпорт сценариев из файлов', 0) then
  begin
    if ScriptDir[Length(ScriptDir)] <> '\' then ScriptDir := ScriptDir + '\';
    TConfigManager.Instance.ForEachProcess(EachReadScriptFromFile);
    Result := true;
  end;
  // Ќе примен€ем изменени€ и не обновл€ем скрипты,
  // т.к. эта процедура вызываетс€ из редактора конфигурации.
end;

function TScriptExchange.WriteScriptToFile(SrvName, ScrName: string): boolean;
var
  Lines: TStringList;
begin
  Result := true;   // всегда возвращает true
  Lines := TStringList.Create;
  try
    ReadStringListFromBlob(Lines, sdm.cdServices.FieldByName(ScrName) as TBlobField);
    // 15.06.2005 - Ёксперимент Ёкспорт ¬—≈’ даже пустых
    //if Length(Lines.Text) > 3 then
      Lines.SaveToFile(ScriptDir + SrvName + '_' + ScrName + '.pas');
  finally
    FreeAndNil(Lines);
  end;
end;

function TScriptExchange.WriteGridScriptsToFile(Srv: TPolyProcessCfg): boolean;
var
  Lines: TStringList;
  g, i: integer;
  go: TProcessGridCfg;
begin
  Result := true;   // всегда возвращает true
  Lines := TStringList.Create;
  try
    if not sdm.cdProcessGrids.Active then sdm.RefreshProcessGrids;
    sdm.SetCurProcess(Srv.SrvID);
    for g := 0 to Pred(Srv.Grids.Count) do
    begin
      go := (Srv.Grids.Items[g] as TProcessGridCfg);
      if sdm.cdProcessGrids.Locate('GridID', go.GridID, []) then
        for i := 0 to Pred(go.Scripts.Count) do
        begin
          ReadStringListFromBlob(Lines, sdm.cdProcessGrids.FieldByName(go.Scripts[i]) as TBlobField);
          // 15.06.2005 - Ёксперимент Ёкспорт ¬—≈’ даже пустых
          //if Length(Lines.Text) > 3 then
            Lines.SaveToFile(ScriptDir + Srv.TableName + '@' + sdm.cdProcessGrids['GridName'] + '_' + go.Scripts[i] + '.pas');
        end;
    end;
  finally
    FreeAndNil(Lines);
  end;
end;

function TScriptExchange.EachWriteScriptToFile(Srv: TPolyProcessCfg): boolean;
var
  i: integer;
begin
  Result := true;
  if sdm.cdServices.Locate('SrvID', Srv.SrvID, []) then
  begin
    if Srv.Scripts.Count > 0 then
      for i := 0 to Pred(Srv.Scripts.Count) do
        WriteScriptToFile(Srv.TableName, Srv.Scripts[i]);
    //if Srv is TGridPolyProcess then
       WriteGridScriptsToFile(Srv as TPolyProcessCfg);
  end;
end;

function TScriptExchange.ExportScriptsToFiles: boolean;
begin
  Result := true;
  ScriptDir := ExtractFileDir(paramstr(0));
  if BrowseDirectory(ScriptDir, 'Ёкспорт сценариев в файлы', 0) then
  begin
    if ScriptDir[Length(ScriptDir)] <> '\' then ScriptDir := ScriptDir + '\';
    TConfigManager.Instance.ForEachProcess(EachWriteScriptToFile);
  end;
end;

function TScriptExchange.ExportScriptsToFiles(Process: TPolyProcessCfg): boolean;
begin
  Result := true;
  ScriptDir := ExtractFileDir(paramstr(0));
  if BrowseDirectory(ScriptDir, 'Ёкспорт сценариев в файлы', 0) then
  begin
    if ScriptDir[Length(ScriptDir)] <> '\' then ScriptDir := ScriptDir + '\';
    Result := EachWriteScriptToFile(Process);
  end;
end;

function TScriptExchange.ReadGridScriptsFromFile(Srv: TPolyProcessCfg): boolean;
var
  Lines: TStringList;
  g, i: integer;
  go: TProcessGridCfg;
  ScrFName: string;
  ScriptField: TBlobField;
begin
  Result := true;   // всегда возвращает true
  Lines := TStringList.Create;
  try
    if not sdm.cdProcessGrids.Active then sdm.RefreshProcessGrids;
    sdm.SetCurProcess(Srv.SrvID);
    for g := 0 to Pred(Srv.Grids.Count) do
    begin
      go := (Srv.Grids.Items[g] as TProcessGridCfg);
      if go.Scripts <> nil then
      begin
        if sdm.cdProcessGrids.Locate('GridID', go.GridID, []) then
        begin
          for i := 0 to Pred(go.Scripts.Count) do
          begin
            ScrFName := ScriptDir + Srv.TableName + '@' + sdm.cdProcessGrids['GridName'] + '_' + go.Scripts[i] + '.pas';
            if FileExists(ScrFName) then
            begin
              Lines.LoadFromFile(ScrFName);
              sdm.cdProcessGrids.Edit;
              ScriptField := sdm.cdProcessGrids.FieldByName(go.Scripts[i]) as TBlobField;
              if Length(Lines.Text) > 3 then
                WriteStringListToBlob(Lines, ScriptField)
              else
                ScriptField.Clear;
            end;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(Lines);
  end;
end;

function TScriptExchange.ReadScriptFromFile(SrvName, ScrName: string): boolean;
var
  Lines: TStringList;
  ScrFName: string;
  ScriptField: TBlobField;
begin
  Result := true;   // всегда возвращает true
  Lines := TStringList.Create;
  try
    ScrFName := ScriptDir + SrvName + '_' + ScrName + '.pas';
    if FileExists(ScrFName) then begin
      Lines.LoadFromFile(ScrFName);
      sdm.cdServices.Edit;
      ScriptField := sdm.cdServices.FieldByName(ScrName) as TBlobField;
      if Length(Lines.Text) > 3 then
        WriteStringListToBlob(Lines, ScriptField)
      else
        ScriptField.Clear;
    end;
 finally
    FreeAndNil(Lines);
  end;
end;

initialization
  ScriptExchange := TScriptExchange.Create;

finalization
  FreeAndNil(ScriptExchange);

end.
