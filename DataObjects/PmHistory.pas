unit PmHistory;

interface

uses DB,

     PmEntity;

type
  TOrderHistoryView = class(TEntity)
  private
    FOrderID: integer;
    procedure EventKindGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure EventUserGetText(Sender: TField; var Text: String; DisplayText: boolean);
  public
    constructor Create(_OrderID: integer);
  end;

  TGlobalHistoryCriteria = record
    StartDate, EndDate: variant;
    UserLogin: variant;
  end;

  TGlobalHistoryView = class(TEntity)
  private
    FCriteria: TGlobalHistoryCriteria;
    //FOriginalSQL: string;
    procedure EventKindGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure EventUserGetText(Sender: TField; var Text: String; DisplayText: boolean);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DoBeforeOpen; override;
    function GetSQL: string;
    procedure SetCriteria(_Criteria: TGlobalHistoryCriteria);

    property Criteria: TGlobalHistoryCriteria read FCriteria write SetCriteria;
  end;

  TContragentHistoryView = class(TEntity)
  private
    FContragentID: integer;
    procedure EventKindGetText(Sender: TField; var Text: String; DisplayText: boolean);
    procedure EventUserGetText(Sender: TField; var Text: String; DisplayText: boolean);
  public
    constructor Create(ContragentID: integer);
  end;

implementation

uses SysUtils, Variants,

     RDBUtils, MainData, PmAccessManager;

const
  F_HistoryKey = 'EventID';

function GetEventKindText(Sender: TField): string;
const
  TextValues: array[1..4] of string = ('Изменение', 'Добавление', 'Удаление',
    'Событие');
begin
  if not Sender.IsNull and (Sender.Value >= 1) and (Sender.Value <= 4) then
    Result := TextValues[Sender.AsInteger]
  else
    Result := '';
end;


{$REGION 'TOrderHistoryView'}

constructor TOrderHistoryView.Create(_OrderID: integer);
begin
  inherited Create;
  FKeyField := F_HistoryKey;
  FOrderID := _OrderID;
  DefaultLastRecord := true;
  RefreshAfterApply := true;
  SetDataSet(dm.cdOrderHistory);
  DataSetProvider := dm.pvOrderHistory;

  ADODataSet.Parameters.ParamByName('OrderID').Value := FOrderID;

  DataSet.FieldByName('EventKind').OnGetText := EventKindGetText;
  DataSet.FieldByName('EventUser').OnGetText := EventUserGetText;
end;

procedure TOrderHistoryView.EventKindGetText(Sender: TField; var Text: String;
  DisplayText: boolean);
begin
  Text := GetEventKindText(Sender);
end;

procedure TOrderHistoryView.EventUserGetText(Sender: TField; var Text: String;
  DisplayText: boolean);
begin
  Text := AccessManager.FormatUserName(Sender.AsString);
end;

{$ENDREGION}

{$REGION 'TGlobalHistoryView' }

//const
//  MACRO_CONDITION = '@@@Condition';

procedure TGlobalHistoryView.DoBeforeOpen;
begin
  inherited DoBeforeOpen;
  ADODataSet.SQL.Text := GetSQL;
end;

procedure Add(var s: string; x: string);
begin
  if s = '' then s := x else s := s + ' and ' + x;
end;

function TGlobalHistoryView.GetSQL: string;
var
  expr: string;
begin
  expr := '';

  if not VarIsNull(FCriteria.StartDate) then
    add(expr, 'EventDate >= ' + FormatSQLDateTime(FCriteria.StartDate));
  if not VarIsNull(FCriteria.EndDate) then
    add(expr, 'EventDate <= ' + FormatSQLDateTime(FCriteria.EndDate));
  if NvlString(FCriteria.UserLogin) <> '' then
    add(expr, 'EventUser = ''' + FCriteria.UserLogin + '''');

  if expr <> '' then expr := 'where ' + expr;

  //Result := StringReplace(FOriginalSQL, MACRO_CONDITION, expr, [rfReplaceAll]);
  Result := 'select EventID, EventDate, EventText, EventUser, EventKind' + #13#10
          + 'from GlobalHistory' + #13#10
          + expr + #13#10
          + 'order by EventDate';
end;

constructor TGlobalHistoryView.Create;
begin
  inherited Create;
  FKeyField := F_HistoryKey;
  DefaultLastRecord := true;
  RefreshAfterApply := true;
  SetDataSet(dm.cdGlobalHistory);
  DataSetProvider := dm.pvGlobalHistory;

  //FOriginalSQL := ADODataSet.SQL.Text;
  PagerMode := pmCursor;

  DataSet.FieldByName('EventKind').OnGetText := EventKindGetText;
  DataSet.FieldByName('EventUser').OnGetText := EventUserGetText;
end;

// Здесь больше различных видов сообщений
procedure TGlobalHistoryView.EventKindGetText(Sender: TField; var Text: String; DisplayText: Boolean);
const
  TextValues: array[1..5] of string = ('Отладка', 'Инфо', 'Внимание!', 'Ошибка!', 'Сбой!');
begin
  if not Sender.IsNull and (Sender.Value >= 0) and (Sender.Value <= 4) then
    Text := TextValues[Sender.AsInteger + 1]
  else
    Text := '';
end;

procedure TGlobalHistoryView.EventUserGetText(Sender: TField; var Text: String;
  DisplayText: boolean);
begin
  Text := AccessManager.FormatUserName(Sender.AsString);
end;

procedure TGlobalHistoryView.SetCriteria(_Criteria: TGlobalHistoryCriteria);
begin
  FCriteria := _Criteria;
  //Reload;
end;

destructor TGlobalHistoryView.Destroy;
begin
  // Здесь возвращаем обратно оригинальный текст запроса.
  // Рискованный путь, т.к. к этому моменту dataset уже может
  // не существовать, но в данном случае все нормально, а если
  // понадобится такое, то можно хранить текст запроса прямо здесь.
  //ADODataSet.SQL.Text := FOriginalSQL;
  inherited Destroy;
end;

{$ENDREGION}

{$REGION 'TContragentHistoryView'}

constructor TContragentHistoryView.Create(ContragentID: integer);
begin
  inherited Create;
  FKeyField := F_HistoryKey;
  FContragentID := ContragentID;
  DefaultLastRecord := true;
  RefreshAfterApply := true;
  SetDataSet(dm.cdContragentHistory);
  DataSetProvider := dm.pvContragentHistory;

  ADODataSet.Parameters.ParamByName('ContragentID').Value := FContragentID;

  DataSet.FieldByName('EventKind').OnGetText := EventKindGetText;
  DataSet.FieldByName('EventUser').OnGetText := EventUserGetText;
end;

procedure TContragentHistoryView.EventKindGetText(Sender: TField; var Text: String;
  DisplayText: boolean);
begin
  Text := GetEventKindText(Sender);
end;

procedure TContragentHistoryView.EventUserGetText(Sender: TField; var Text: String;
  DisplayText: boolean);
begin
  Text := AccessManager.FormatUserName(Sender.AsString);
end;

{$ENDREGION}

end.
