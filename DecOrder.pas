unit DecOrder;

{$I Calc.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, Mask, DBCtrls, Buttons, ExtCtrls, DBClient,
  JvExControls, JvComponent, JvDBLookup;

type
  TDecompForm = class(TForm)
    Panel1: TPanel;
    Label9: TLabel;
    Panel3: TPanel;
    dtChifer: TDBText;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    Label6: TLabel;
    Label8: TLabel;
    btNewCust: TSpeedButton;
    edComment: TDBEdit;
    lkCustomer: TJvDBLookupCombo;
    dgItems: TDBGrid;
    btDelete: TBitBtn;
    btAppend: TBitBtn;
    edNProduct: TDBEdit;
    Label1: TLabel;
    edPercent: TDBEdit;
    Label2: TLabel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    Label3: TLabel;
    edSub: TDBEdit;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btOkClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure btInsertClick(Sender: TObject);
    procedure btAppendClick(Sender: TObject);
    procedure btNewCustClick(Sender: TObject);
    procedure lkCustomerCloseUp(Sender: TObject);
  private
    procedure SetCustName;
  public
    procedure DisableDBControls;
    procedure EnableDBControls;
  end;

var
  DecompForm: TDecompForm;

procedure DecomposeOrder;

implementation

uses MainData, ADOError, RDialogs, DB, cusel, 
   ADOReClc, DataHlp
  {$IFNDEF NoNet}
  , OptCalc, NtfQueue, NtfConst
  {$ENDIF}
;

{$R *.DFM}

procedure DecomposeOrder;
begin
  Application.CreateForm(TDecompForm, DecompForm);
  DecompForm.DisableDBControls;  // не уверен, надо ли...
  if DecompForm.ShowModal = mrOk then begin
    ReloadQuery(qiWork);
   {$IFNDEF NoNet}
    if SendOrd then SendNotif(WorkOrderNotif);
   {$ENDIF}
  end;
  FreeAndNil(DecompForm);
end;

procedure TDecompForm.FormActivate(Sender: TObject);
begin
  EnableDBControls;
end;

procedure TDecompForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dm.cdWorkItem.Active := false;
  DisableDBControls;
end;

// !!!!!!! использованы наборы данных APPSERVER!!!!!!! 
procedure TDecompForm.EnableDBControls;
begin
  if (dm = nil) then Exit;
  lkCustomer.LookupSource := dm.dsCust;
  try
    if not dm.cdWorkCust.Active then
      dm.OpenDataSet(cdWorkCust);
    // считываем подзаказы
    dm.aqWorkItem.Parameters.ParamByName('OrderID').Value := dm.aqWorkOrder['N'];
    dm.cdWorkItem.Active := false;
    dm.OpenDataSet(cdWorkItem);
  except on E: EDatabaseError do ProcessError(E); end;
  lkCustomer.DataSource := dm.dsWorkItem;
  edNProduct.DataSource := dm.dsWorkItem;
  edComment.DataSource := dm.dsWorkItem;
  edPercent.DataSource := dm.dsWorkItem;
  edSub.DataSource := dm.dsWorkItem;
  dgItems.DataSource := dm.dsWorkItem;
  dtChifer.DataSource := dm.dsWorkOrder;
end;

procedure TDecompForm.DisableDBControls;
begin
  if (dm = nil) then Exit;
  lkCustomer.DataSource := nil;
  lkCustomer.LookupSource := nil;
  edNProduct.DataSource := nil;
  edComment.DataSource := nil;
  edPercent.DataSource := nil;
  edSub.DataSource := nil;
  dgItems.DataSource := nil;
  dtChifer.DataSource := nil;
end;

// ------------- Применение изменений ----------------

procedure TDecompForm.btOkClick(Sender: TObject);

  function CheckPercents(dqw: TDataSet): boolean;    // Проверяем сумму процентов
  var s: integer;
  begin
    Result := true;
    dqw.DisableControls;
    try
      dqw.First;
      s := 0;
      while not dqw.EOF do begin
        try
          S := S + dqw['Percent'];
        except end;
        dqw.Next;
      end;
      if s <> 100 then
        Result := RusMessageDlg('Сумма процентов не равна 100%. Все равно сохранить?',
           mtConfirmation, [mbYes, mbNo], 0) = mrYes;
    finally
      dqw.EnableControls;
    end;
  end;

  // Проверяет, изменились ли какие-то составляющие заказа?
  function ItemsChanged(dqw: TClientDataSet): boolean;

    function FindOldID(IDVal: integer; var OldPercent: integer): boolean;
    var bm: TBookmark;
    begin
      bm := dqw.GetBookmark;
      dqw.First;
      Result := false;
      while not dqw.EOF do begin
        try
          if dqw.FieldByName('ID').OldValue = IDVal then begin
            OldPercent := dqw.FieldByName('Percent').OldValue;
            Result := true;
            break;
          end;
        except end;
        dqw.Next;
      end;
      dqw.GotoBookmark(bm);
      dqw.FreeBookmark(bm);
    end;

  var OldPer: integer;
  begin
    Result := false;
    dqw.DisableControls;
    dqw.StatusFilter := [usModified, usDeleted];
    try
      dqw.First;
      while not dqw.EOF do begin
        try
          if not FindOldID(dqw.FieldByName('ID').NewValue, OldPer) then
            RusMessageDlg('Удален компонент заказа! Отслеживание зависимых документов пока не реализовано!', mtInformation, [mbOk], 0)
          else if OldPer <> dqw['Percent'] then Result := true;
        except end;
        dqw.Next;
      end;
    finally
//      dqw.UpdateRecordTypes := [rtUnModified, rtModified, rtInserted];
      dqw.EnableControls;
    end;
  end;

var
  OldComp, ChkDep: boolean;
  ReOrderID: integer;
  ReOrderCode: string;
  ReKind: TChangeKind;

begin
  with dm do
  try
    cdWorkItem.CheckBrowseMode;
    // Если сумма <> 100%, то спрашиваем польз-теля, если он согласен, то продолжаем...
    if not CheckPercents(cdWorkItem) then begin ModalResult := mrNone; Exit; end;
    if cdWorkItem.ChangeCount <= 0 then Exit;
   // Запоминаем, надо ли пересчитывать зависимые док-ты
    ChkDep := CheckDep and ItemsChanged(cdWorkItem);

    if not cnCalc.InTransaction then cnCalc.BeginTrans;
    cdWorkItem.ApplyUpdates(0);
    // Если нужно изменить свойство IsComposite, т. е. заказ был или стал составным, то update.
    try OldComp := WorkOrderData['IsComposite']; except OldComp := false; end;
    // Все это можно было бы перенести в триггер, но в ODBC-версии могуь быть проблемы
    // !!!!!!!!!!!!!!!!! для ADO можно попробовать упростить
    if (not OldComp) = (cdWorkItem.RecordCount > 1) then begin
      WorkOrderData.Edit;
      WorkOrderData['IsComposite'] := not OldComp;
      if not OldComp then WorkOrderData['Customer'] := NoNameKey;
      OrderApplyUpdates(WorkOrderData);
    end;
    cnCalc.CommitTrans;

    ReOrderID := WorkOrderData['N'];
    ReOrderCode := WorkOrderData['ID'];
    ReKind := chSumChanged;
    if ChkDep then CheckDependsAndShowForm(ReOrderID, ReOrderCode, ReKind, cnCalc);
  except
    on E: EDatabaseError do begin
      cnCalc.RollbackTrans;
      ProcessError(E);
      ModalResult := mrNone;
    end;
  end;
end;

procedure TDecompForm.btCancelClick(Sender: TObject);
begin
  try dm.cdWorkItem.CancelUpdates except end;
end;

procedure TDecompForm.btDeleteClick(Sender: TObject);
begin
  try
    if dm.cdWorkItem.RecordCount = 1 then
      RusMessageDlg('Это единственный подзаказ. Его нельзя удалить.', mtInformation, [mbOk], 0)
    else if RusMessageDlg('Удалить подзаказ?'#13 +
      'Удаление подзаказа приведет к удалению всех связанных записей.', mtConfirmation,
       [mbYes, mbNo], 0) = mrYes then
      dm.cdWorkItem.Delete;
  except end;
end;

procedure TDecompForm.btInsertClick(Sender: TObject);
begin
  try
    dm.cdWorkItem.Insert;
  except end;
end;

procedure TDecompForm.btAppendClick(Sender: TObject);
begin
  try
    dm.cdWorkItem.Append;
  except end;
end;

procedure TDecompForm.btNewCustClick(Sender: TObject);
var
  i, CurCustomer: integer;
begin
  try
    CurCustomer := lkCustomer.KeyValue;
  except CurCustomer := NoNameKey end;
  i := ExecCustSelect({ShowCalc} false, {ShowWork} true,
      {CurCustomer} CurCustomer, {CurIsCalc} false);
  if i = custNoName then i := NoNameKey;
  if (i <> custError) and (i <> custCancel) then begin
    lkCustomer.KeyValue := i;
    SetCustName;
  end;
end;

procedure TDecompForm.SetCustName;
begin
  try
    if dm.cdWorkItem['Customer'] <> NoNameKey then begin
      if not (dm.cdWorkItem.State in [dsInsert, dsEdit]) then dm.cdWorkItem.Edit;
      dm.cdWorkItem['CustName'] := dm.cdWorkCust['Name'];
    end;
  except end;
end;

procedure TDecompForm.lkCustomerCloseUp(Sender: TObject);
begin
  SetCustName;
end;

end.
