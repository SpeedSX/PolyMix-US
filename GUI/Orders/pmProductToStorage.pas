{
  Да простят меня те кто будет разрабатывать это приложение...
  отступаю от концепции MVC
}

unit pmProductToStorage;

interface

uses SysUtils, Controls, Dialogs, Classes, Variants, Db, DataHlp, ADODB,
  Provider, DBClient;

type

TProductStorageController = class
  public
    OrderID: integer;
    CustomerID: integer;
    DMStorag : TDataModule;
    ProviderStorage: TDataSetProvider;
    DSetStorage: TDataSet;
    DSourceStorage: TDataSource;
    ADOStorage : TADOQuery;
    constructor Create(_orderId : Integer);
    destructor Destroy;
    procedure AppendRecord;
    procedure EditRecord;
    procedure DeleteRecord;
    procedure SetSQL;
  end;

implementation

uses Maindata, RDBUtils, JvInterpreter_CustomQuery, PmDatabase, fOrderProductStorageFrom;

destructor TProductStorageController.Destroy;
begin
  DSourceStorage.DataSet.Close;
  FreeAndNil(DMStorag);
  inherited Destroy;
end;

constructor TProductStorageController.Create(_orderId : Integer);
begin
  OrderId := _orderId;

  DMStorag := TDataModule.Create(nil);

  DSourceStorage := CreateQueryExDM(DMStorag, DMStorag, ClassName,
    [{poAllowMultiRecordUpdates, poDisableInserts, poDisableDeletes, poDisableEdits}],
    upWhereAll, true {ResolveToDataSet}, DataBase.Connection);
  DSetStorage := DSourceStorage.DataSet;

  inherited Create;

  SetSQL;

end;

procedure TProductStorageController.SetSQL;
var s : String;
begin
    DSourceStorage.DataSet.Close;
    if OrderID>0 then
    begin
      s := 'SELECT ops.*, CONVERT(varchar, inDate, 104) as dateToStorage  , dsp.Name '+
           'FROM OrderProductToStorage ops inner join Dic_StoreProduct dsp on (ops.Kind = dsp.Code) where ops.orderId = ' + IntToStr(OrderID) +
           ' ORDER BY id';
      SetQuerySQL(DSourceStorage, s);
      DSourceStorage.DataSet.Open;
    end;
end;

procedure TProductStorageController.AppendRecord;
var
  AppendRecortForm : TOrderProductStorageFrom;
  insQuery: TADOQuery;
  s: String;
  ds:TDataSource;
begin
  AppendRecortForm := TOrderProductStorageFrom.Create(nil);
  try
     ds:=CreateQueryExDM(DMStorag, DMStorag, ClassName,
          [poDisableInserts, poDisableDeletes, poDisableEdits],
          upWhereKeyOnly, true , DataBase.Connection);
     s := 'Select * from Dic_StoreProduct d left join ProductCount pc on (d.Code = pc.Kind) where d.visible=1';
     SetQuerySQL(ds, s);
     AppendRecortForm.gdProductList.DataSource:=ds;
     ds.DataSet.Open;
     AppendRecortForm.gdProductList.Columns[4].Visible:=false;
     if AppendRecortForm.ShowModal = mrOk then
     begin
        insQuery := TADOQuery.Create(nil);
        insQuery.Connection := DataBase.Connection;
        insQuery.SQL.Text:='INSERT INTO OrderProductToStorage( orderId,Kind,NProduct,Price,RCount,BCount,BSize) '+
          'VALUES (:orderId,:Kind,:NProduct,:Price,:RCount,:BCount,:BSize)';
        insQuery.Parameters.ParamByName('orderId').Value := OrderID;
        insQuery.Parameters.ParamByName('Kind').Value := ds.DataSet.FieldByName('Code').AsInteger;
        insQuery.Parameters.ParamByName('NProduct').Value := AppendRecortForm.edQty.Value;
        insQuery.Parameters.ParamByName('Price').Value := ds.DataSet.FieldByName('A1').AsFloat;
        insQuery.Parameters.ParamByName('RCount').Value := ds.DataSet.FieldByName('A4').AsInteger;
        insQuery.Parameters.ParamByName('BCount').Value := ds.DataSet.FieldByName('A2').AsInteger;
        insQuery.Parameters.ParamByName('BSize').Value := ds.DataSet.FieldByName('A3').AsString;
        insQuery.ExecSQL;
     end;
  finally
    if insQuery<>nil then
    begin
     insQuery.Close;
     insQuery.Free;
    end;
     DSetStorage.Close;
     DSetStorage.Open;
     DSetStorage.Last;
     ds.DataSet.close;
     FreeAndNil(AppendRecortForm);
     ds.DataSet.Free;
     ds.Free;
  end;


end;

procedure TProductStorageController.EditRecord;
var
  EditRecortForm : TOrderProductStorageFrom;
  editQuery: TADOQuery;
  ds:TDataSource;
  s : string;
  EdID : integer;
begin
    EditRecortForm := TOrderProductStorageFrom.Create(nil);
    try
     EdID := DSetStorage.FieldByName('id').AsInteger;
     ds:=CreateQueryExDM(DMStorag, DMStorag, ClassName,
          [poDisableInserts, poDisableDeletes, poDisableEdits],
          upWhereKeyOnly, true , DataBase.Connection);
     s := 'Select * from Dic_StoreProduct d left join ProductCount pc on (d.Code = pc.Kind) where visible=1';
     SetQuerySQL(ds, s);
     EditRecortForm.gdProductList.DataSource:=ds;
     ds.DataSet.Open;
     ds.DataSet.Locate('Code', DSetStorage.FieldByName('Kind').AsInteger,[]);
     EditRecortForm.edQty.Value:=DSetStorage.FieldByName('NProduct').AsInteger;
     EditRecortForm.gdProductList.Columns[4].Visible:=false;
    if EditRecortForm.ShowModal = mrOk then
     begin
        editQuery := TADOQuery.Create(nil);
        editQuery.Connection := DataBase.Connection;
        editQuery.SQL.Text:='UPDATE OrderProductToStorage SET Kind = :Kind ,NProduct = :NProduct,' +
            'Price = :Price, RCount = :RCount,BCount = :BCount, BSize = :BSize '+
            'WHERE id = :Id ';

        editQuery.Parameters.ParamByName('Id').Value := DSetStorage.FieldByName('id').AsInteger;
        editQuery.Parameters.ParamByName('Kind').Value := ds.DataSet.FieldByName('Code').AsInteger;
        editQuery.Parameters.ParamByName('NProduct').Value := EditRecortForm.edQty.Value;
        editQuery.Parameters.ParamByName('Price').Value := ds.DataSet.FieldByName('A1').AsFloat;
        editQuery.Parameters.ParamByName('RCount').Value := ds.DataSet.FieldByName('A4').AsInteger;
        editQuery.Parameters.ParamByName('BCount').Value := ds.DataSet.FieldByName('A2').AsInteger;
        editQuery.Parameters.ParamByName('BSize').Value := ds.DataSet.FieldByName('A3').AsString;
        editQuery.ExecSQL;
     end;
    finally
     if editQuery<>nil then
     begin
        editQuery.Close;
        editQuery.Free;
     end;
     DSetStorage.Close;
     DSetStorage.Open;
     DSetStorage.Locate('id',EdID,[]);
     ds.DataSet.close;
     FreeAndNil(EditRecortForm);
     ds.DataSet.Free;
     ds.Free;
  end;
end;

procedure TProductStorageController.DeleteRecord;
var
  delQuery : TADOQuery;
begin
  if MessageDlg('Удалить запись?', mtWarning, mbYesNo, 0, mbNo) = mrYes then
  try
     delQuery := TADOQuery.Create(nil);
     delQuery.Connection := DataBase.Connection;
     delQuery.SQL.Text := 'delete from OrderProductToStorage where id = ' + IntToStr(DSetStorage.FieldByName('id').AsInteger);
     delQuery.ExecSQL;
  finally
    if delQuery<>nil then
    begin
      delQuery.Close;
      delQuery.Free;
      DSetStorage.Close;
      DSetStorage.Open;
    end;
  end;
end;

end.
