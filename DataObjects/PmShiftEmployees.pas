unit PmShiftEmployees;

interface

uses Classes, Variants, DB,

  PmEntity;

type
  TShiftEmployeeCriteria = record
    //ShiftID: integer;
    //DepartmentID: integer;
    StartTime, FinishTime: TDateTime;
  end;

  {TShiftEquipEmployeeCriteria = record
    //ShiftID: integer;
    //EquipID: integer;
    StartTime, FinishTime: TDateTime;
  end;}

  TBaseEmployees = class(TEntity)
  private
    FDataSource: TDataSource;
    FCriteria: TShiftEmployeeCriteria;
    procedure SetCriteria(Value: TShiftEmployeeCriteria);
  protected
    procedure DoBeforeOpen; override;
    procedure DoAfterOpen; override;
    function GetSQL: string; virtual; abstract;
  public
    property Criteria: TShiftEmployeeCriteria read FCriteria write SetCriteria;

    constructor Create(_KeyName, _InternalName: string);

    function GetEmployee(ShiftStartDate: TDateTime): variant;
    function GetAssistant(ShiftStartDate: TDateTime): variant;
    procedure SetEmployee(ShiftStartDate: TDateTime; _EmployeeID: variant);
    procedure SetAssistant(ShiftStartDate: TDateTime; _AssistID: variant);
  end;

  TShiftEmployees = class(TBaseEmployees)
  private
    FDepartmentID: integer;
  protected
    function GetSQL: string; override;
    procedure DoOnNewRecord; override;
  public
    property DepartmentID: integer read FDepartmentID;

    constructor Create(_DepartmentID: integer);
  end;

  TShiftAssistants = class(TBaseEmployees)
  private
    FDepartmentID: integer;
  protected
    function GetSQL: string; override;
    procedure DoOnNewRecord; override;
  public
    property DepartmentID: integer read FDepartmentID;

    constructor Create(_DepartmentID: integer);
  end;

  TEquipEmployees = class(TBaseEmployees)
  private
    FEquipID: integer;
  protected
    function GetSQL: string; override;
    procedure DoOnNewRecord; override;
  public
    property EquipID: integer read FEquipID;

    constructor Create(_EquipID: integer);
  end;

  TEquipAssistants = class(TBaseEmployees)
  private
    FEquipID: integer;
  protected
    function GetSQL: string; override;
    procedure DoOnNewRecord; override;
  public
    property EquipID: integer read FEquipID;

    constructor Create(_EquipID: integer);
  end;


implementation

uses Forms, Provider, SysUtils, DBClient,

  RDBUtils, PlanData, PmDatabase, JvInterpreter_CustomQuery;

const
  F_ShiftEmployeesKey = 'EmployeeToShiftID';
  F_ShiftAssistantsKey = 'EmployeeToShiftID';
  F_EquipEmployeesKey = 'EmployeeToEquipShiftID';
  F_EquipAssistantsKey = 'EmployeeToEquipShiftID';  
  F_ShiftStartDate = 'ShiftStartDate';
  F_EmployeeID = 'EmployeeID';
  F_AssistantID = 'AssistantID';

{$REGION 'TBaseEmployees'}

constructor TBaseEmployees.Create(_KeyName, _InternalName: string);
var
  _DataSource: TDataSource;
  _DataSet: TDataSet;
  _Provider: TDataSetProvider;
begin
  if PlanDM = nil then
    Application.CreateForm(TPlanDM, PlanDM);

  _DataSource := CreateQueryExDM(PlanDM, PlanDM, _InternalName,
    [{poAllowMultiRecordUpdates, poDisableInserts, poDisableDeletes, poDisableEdits}],
    upWhereKeyOnly, false {ResolveToDataSet}, Database.Connection, _Provider);
  _DataSet := _DataSource.DataSet;

  inherited Create;
  FKeyField := _KeyName;

  SetDataSet(_DataSet);
  FDataSource := _DataSource;
  DataSetProvider := _Provider;

  DefaultLastRecord := false;
  RefreshAfterApply := true;
end;

procedure TBaseEmployees.DoBeforeOpen;
begin
  inherited DoBeforeOpen;
  ADODataSet.SQL.Text := GetSQL;
end;

procedure TBaseEmployees.DoAfterOpen;
begin
  TClientDataSet(DataSet).AddIndex('iStartDate', F_ShiftStartDate, []);
end;

function TBaseEmployees.GetEmployee(ShiftStartDate: TDateTime): variant;
begin
  if DataSet.Locate(F_ShiftStartDate, ShiftStartDate, []) then
    Result := DataSet[F_EmployeeID]
  else
    Result := null;
end;

function TBaseEmployees.GetAssistant(ShiftStartDate: TDateTime): variant;
begin
  if DataSet.Locate(F_ShiftStartDate, ShiftStartDate, []) then
    Result := DataSet[F_AssistantID]
  else
    Result := null;
end;

procedure TBaseEmployees.SetEmployee(ShiftStartDate: TDateTime; _EmployeeID: variant);
begin
  if VarIsNull(_EmployeeID) or VarIsEmpty(_EmployeeID) then
  begin
    if DataSet.Locate(F_ShiftStartDate, ShiftStartDate, []) then
    begin
      DataSet.Delete;
    end;
  end
  else
  begin
    if DataSet.Locate(F_ShiftStartDate, ShiftStartDate, []) then
    begin
      DataSet.Edit;
    end else
    begin
      DataSet.Append;
      DataSet[F_ShiftStartDate] := ShiftStartDate;
    end;
    DataSet[F_EmployeeID] := _EmployeeID;
  end;
  ApplyUpdates;
end;

procedure TBaseEmployees.SetAssistant(ShiftStartDate: TDateTime; _AssistID: variant);
begin
  if VarIsNull(_AssistID) or VarIsEmpty(_AssistID) then
  begin
    if DataSet.Locate(F_ShiftStartDate, ShiftStartDate, []) then
    begin
      DataSet.Delete;
    end;
  end
  else
  begin
    if DataSet.Locate(F_ShiftStartDate, ShiftStartDate, []) then
    begin
      DataSet.Edit;
    end else
    begin
      DataSet.Append;
      DataSet[F_ShiftStartDate] := ShiftStartDate;
    end;
    DataSet[F_AssistantID] := _AssistID;
  end;
  ApplyUpdates;
end;

procedure TBaseEmployees.SetCriteria(Value: TShiftEmployeeCriteria);
begin
  FCriteria := Value;
end;

{$ENDREGION}

{$REGION 'TShiftAssistants'}

constructor TShiftAssistants.Create(_DepartmentID: integer);
begin
  inherited Create(F_ShiftAssistantsKey, 'ShiftAssistants_' + IntToStr(_DepartmentID));
  FDepartmentID := _DepartmentID;
end;


function TShiftAssistants.GetSQL: string;
begin
  Result := 'select * from EmployeeToDepartmentShift eds' + #13#10
    + 'where eds.ShiftStartDate >= ' + FormatSQLDateTime(FCriteria.StartTime)
    + '  and eds.ShiftStartDate <= ' + FormatSQLDateTime(FCriteria.FinishTime);
end;

procedure TShiftAssistants.DoOnNewRecord;
begin
  inherited;
  DataSet['DepartmentID'] := FDepartmentID;
end;

{$ENDREGION}

{$REGION 'TShiftEmployees'}

constructor TShiftEmployees.Create(_DepartmentID: integer);
begin
  inherited Create(F_ShiftEmployeesKey, 'ShiftEmployees_' + IntToStr(_DepartmentID));
  FDepartmentID := _DepartmentID;
end;


function TShiftEmployees.GetSQL: string;
begin
  Result := 'select * from EmployeeToDepartmentShift eds' + #13#10
    + 'where eds.ShiftStartDate >= ' + FormatSQLDateTime(FCriteria.StartTime)
    + '  and eds.ShiftStartDate <= ' + FormatSQLDateTime(FCriteria.FinishTime);
end;

procedure TShiftEmployees.DoOnNewRecord;
begin
  inherited;
  DataSet['DepartmentID'] := FDepartmentID;
end;


{$ENDREGION}

{$REGION 'TEquipEmployees'}

constructor TEquipEmployees.Create(_EquipID: integer);
begin
  inherited Create(F_EquipEmployeesKey, 'EquipEmployees_' + IntToStr(_EquipID));
  FEquipID := _EquipID;
end;

function TEquipEmployees.GetSQL: string;
begin
  Result := 'select * from EmployeeToEquipShift ees' + #13#10
    + 'where ees.ShiftStartDate >= ' + FormatSQLDateTime(FCriteria.StartTime)
    + '  and ees.ShiftStartDate <= ' + FormatSQLDateTime(FCriteria.FinishTime)
    + '  and ees.EquipID = ' + IntToStr(FEquipID);
end;

procedure TEquipEmployees.DoOnNewRecord;
begin
  inherited;
  DataSet['EquipID'] := FEquipID;
end;

{$ENDREGION}

{$REGION 'TEquipAssistants'}

constructor TEquipAssistants.Create(_EquipID: integer);
begin
  inherited Create(F_EquipAssistantsKey, 'EquipAssistant_' + IntToStr(_EquipID));
  FEquipID := _EquipID;
end;

function TEquipAssistants.GetSQL: string;
begin
  Result := 'select * from EmployeeToEquipShift ees' + #13#10
    + 'where ees.ShiftStartDate >= ' + FormatSQLDateTime(FCriteria.StartTime)
    + '  and ees.ShiftStartDate <= ' + FormatSQLDateTime(FCriteria.FinishTime)
    + '  and ees.EquipID = ' + IntToStr(FEquipID);
end;

procedure TEquipAssistants.DoOnNewRecord;
begin
  inherited;
  DataSet['EquipID'] := FEquipID;
end;

{$ENDREGION}

end.
