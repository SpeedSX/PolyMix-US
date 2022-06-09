unit JvInterpreter_CustomQuery;

interface

uses JvInterpreter, Variants, DB, Classes, ADODB, DBClient, SysUtils, Forms, Provider;

procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);
procedure InitCustomSQL;
procedure DoneCustomSQL;
function CreateQueryEx(BaseName: string; ProviderOptions: TProviderOptions;
  UpdateMode: TUpdateMode; ResolveToDataSet: boolean): TDataSource;
procedure SetQuerySQL(ds: TDataSource; SQL: string);

var
  ClientCustomDM, ServerCustomDM: TDataModule;

implementation

uses CalcUtils, RDBUtils, PmDatabase;

{ Custom Query system }
{ TODO -cCS: Theese procs should be separated into 2: on client and on server }

procedure RAI2_InitCustomSQL(var Value: Variant; Args: TJvInterpreterArgs);
begin
  InitCustomSQL;
end;

procedure InitCustomSQL;
begin
  if ServerCustomDM <> nil then FreeAndNil(ServerCustomDM);
  ServerCustomDM := TDataModule.Create(nil);
  // Очень плохо использовать формы с указанием владельца и освобождать потом,
  // а в Delphi 2007 еще и выскочит exception.
  //Application.CreateForm(TDataModule, ServerCustomDM);
  if ClientCustomDM <> nil then FreeAndNil(ClientCustomDM);
  ClientCustomDM := TDataModule.Create(nil);
  //Application.CreateForm(TDataModule, ClientCustomDM);
end;

procedure DoneCustomSQL;
begin
  if ServerCustomDM <> nil then FreeAndNil(ServerCustomDM);
  if ClientCustomDM <> nil then FreeAndNil(ClientCustomDM);
end;

procedure RAI2_DoneCustomSQL(var Value: Variant; Args: TJvInterpreterArgs);
begin
  DoneCustomSQL;
end;

procedure RAI2_CreateQuery(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if (ServerCustomDM = nil) or (ClientCustomDM = nil) then
    raise Exception.Create('Модуль данных для сценариев не был создан');
//  try
  Value := O2V(CreateQueryDM(ClientCustomDM, ServerCustomDM, string(Args.Values[0]),
    Database.Connection));
//  except
//    Value := O2V(nil);
//  end;
end;

procedure RAI2_CreateQueryEx(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(CreateQueryEx(string(Args.Values[0]), TProviderOptions(Word(V2S(Args.Values[1]))),
    TUpdateMode(Args.Values[2]), Args.Values[3]));
end;

function CreateQueryEx(BaseName: string; ProviderOptions: TProviderOptions;
  UpdateMode: TUpdateMode; ResolveToDataSet: boolean): TDataSource;
begin
  if (ServerCustomDM = nil) or (ClientCustomDM = nil) then
    raise Exception.Create('Модуль данных для сценариев не был создан');
  Result := CreateQueryExDM(ClientCustomDM, ServerCustomDM, BaseName, ProviderOptions,
    UpdateMode, ResolveToDataSet, Database.Connection);
end;

procedure RAI2_SetQuerySQL(var Value: Variant; Args: TJvInterpreterArgs);
begin
  SetQuerySQL(V2O(Args.Values[0]) as TDataSource, string(Args.Values[1]));
end;

procedure SetQuerySQL(ds: TDataSource; SQL: string);
var
  cc: TComponent;
  aq: TADOQuery;
begin
  if (ds <> nil) and (ds.DataSet <> nil) then begin
    cc := ds.Owner.FindComponent((ds.DataSet as TClientDataSet).ProviderName);
    if cc <> nil then begin
      aq := (cc as TDataSetProvider).DataSet as TADOQuery;
      aq.SQL.Text := SQL;
    end;
  end;
end;

procedure RAI2_SetQueryParam(var Value: Variant; Args: TJvInterpreterArgs);
var
  ds: TDataSource;
  cc: TComponent;
  aq: TADOQuery;
begin
  ds := V2O(Args.Values[0]) as TDataSource;
  if (ds <> nil) and (ds.DataSet <> nil) then begin
    cc := ds.Owner.FindComponent((ds.DataSet as TClientDataSet).ProviderName);
    if cc <> nil then begin
      aq := (cc as TDataSetProvider).DataSet as TADOQuery;
      aq.Parameters.ParamByName(string(Args.Values[1])).Value := Args.Values[2];
    end;
  end;
end;

procedure RAI2_FreeQuery(var Value: Variant; Args: TJvInterpreterArgs);
var
  ds: TDataSource;
  cc: TComponent;
  aq: TADOQuery;
begin
  ds := V2O(Args.Values[0]) as TDataSource;
  if (ds <> nil) and (ds.DataSet <> nil) then begin
    cc := ds.Owner.FindComponent((ds.DataSet as TClientDataSet).ProviderName);
    if cc <> nil then begin
      aq := (cc as TDataSetProvider).DataSet as TADOQuery;
      aq.Free;
      cc.Free;
      ds.DataSet.Free;
      ds.Free;
    end;
  end;
end;

procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);
begin
  with JvInterpreterAdapter do
  begin
    AddFunction('CalcSrv', 'InitCustomSQL', RAI2_InitCustomSQL, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'DoneCustomSQL', RAI2_DoneCustomSQL, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'CreateQuery', RAI2_CreateQuery, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'CreateQueryEx', RAI2_CreateQueryEx, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddFunction('CalcSrv', 'SetQuerySQL', RAI2_SetQuerySQL, 2, [varEmpty, varEmpty], varEmpty);
    AddFunction('CalcSrv', 'SetQueryParam', RAI2_SetQueryParam, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFunction('CalcSrv', 'FreeQuery', RAI2_FreeQuery, 1, [varEmpty], varEmpty);
    { TUpdateMode }
    AddConst('Db', 'upWhereAll', Ord(upWhereAll));
    AddConst('Db', 'upWhereChanged', Ord(upWhereChanged));
    AddConst('Db', 'upWhereKeyOnly', Ord(upWhereKeyOnly));
 end; { with }
end;


end.
