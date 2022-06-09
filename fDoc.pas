unit fDoc;

{$I Calc.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, JvExControls, JvComponent, JvSpeedButton, JvExExtCtrls, JvSplit,
  Grids, DBGrids, JvExDBGrids, JvDBGrid, DBCtrls, StdCtrls, ExtCtrls, DBClient,
  DataHlp, JvExtComponent;

type
  TDocFrame = class(TFrame)
    paDocInfo: TPanel;
    Panel1: TPanel;
    Label112: TLabel;
    Label113: TLabel;
    DBText1: TDBText;
    dgAdd: TJvDBGrid;
    RxSplitter3: TJvxSplitter;
    Panel28: TPanel;
    dgOrders: TJvDBGrid;
    C: TPanel;
    Panel48: TPanel;
    sbAddContrOrder: TJvSpeedButton;
    sbDelContrOrder: TJvSpeedButton;
    sbEditContrOrder: TJvSpeedButton;
    ContrTimer: TTimer;
    procedure dgEditContrAddClick(Sender: TObject);
    procedure dgAddDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dgOrdersEnter(Sender: TObject);
    procedure dgKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sbAddContrOrderClick(Sender: TObject);
    procedure sbDelContrOrderClick(Sender: TObject);
    procedure ContrTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    procedure EditDoc(dq: TClientDataSet; qi: TQueryIndex; OpenText: boolean);
    procedure NewDoc;
    procedure NewContrOrder;
    procedure EditContrOrder;
    procedure NewAdd;
  end;

implementation

{$R *.dfm}

uses DocData;

procedure TDocFrame.dgEditContrAddClick(Sender: TObject);
begin
  if dgAdd.Focused then
    EditDoc(dmd.cdAdd, qiAdd, true)  // редактирование текста дополнения
  else if dgOrders.Focused then
    EditContrOrder                   // редактирование параметров связанного заказа
end;

procedure TDocFrame.dgAddDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  i: integer;
  Bmp: TBitmap;
begin
  if (Column.Field <> nil) and (Column.FieldName = 'State') then begin
    try
      i := Column.Field.Value;
    except i := Ord(csOpen) end;
    if (i < Ord(csOpen)) or (i > Ord(csComplete)) then Exit;
    Bmp := ContrClip.GraphicCell[i];
    (Sender as TGridClass).Canvas.FillRect(Rect);
    DrawBitmapTransparent((Sender as TGridClass).Canvas, (Rect.Left + Rect.Right - Bmp.Width) div 2,
      (Rect.Top + Rect.Bottom - Bmp.Height) div 2, Bmp, clOlive);
  end;
end;

procedure TDocFrame.dgOrdersEnter(Sender: TObject);
var dq: TDataSet;
begin
  if ActiveControl = dgAdd then sbEditContrOrder.Caption := 'Открыть текст'
  else sbEditContrOrder.Caption := 'Параметры заказа...';
  try
    dq := (Sender as TGridClass).DataSource.DataSet;
    sbDelContrOrder.Enabled := dq.Active and not dq.IsEmpty and dq.CanModify;
    sbAddContrOrder.Enabled := dq.Active and dq.CanModify;
    sbEditContrOrder.Enabled := sbDelContrOrder.Enabled;
    siPrint.DropDownMenu := nil;
    acPrint.Enabled := sbDelContrOrder.Enabled and (ActiveControl <> dgOrders);
  except end;
end;

procedure TDocFrame.dgKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = vk_Insert) and siNew.Enabled then siNewClick(Sender)
  else if (Key = vk_Delete) and siDelete.Enabled then begin
    if (ssCtrl in Shift) and (ssShift in Shift) then DeleteAllOrders
    else siDeleteClick(Sender);
  end else
    if (Key = vk_Return) and siEdit.Enabled then EditCurrent;
end;

procedure TDocFrame.sbAddContrOrderClick(Sender: TObject);
begin
  if ActiveControl = dgAdd then NewAdd
  else if ActiveControl = dgOrders then NewContrOrder;
end;

procedure TDocFrame.sbDelContrOrderClick(Sender: TObject);
begin
  if (ActiveControl = dgOrders) and dmd.cdContrOrder.Active and not dmd.cdContrOrder.IsEmpty then begin
    if RusMessageDlg('Удалить запись о заказе? Вы уверены?', mtWarning, [mbYes, mbNo], 0) = mrYes then begin
      dmd.cdContrOrder.Delete;
      ApplyTable(dmd.cdContrOrder);
      ReloadQuery(qiContrOrder);
//    if SendContr then SendNotif(ContractNotif); // Посылаем всем сообщение, что надо перечитать заказы
    end;
  end else
  if (ActiveControl = dgAdd) and dmd.cdAdd.Active and not dmd.cdAdd.IsEmpty then begin
    if RusMessageDlg('Удалить дополнение? Вы уверены?', mtWarning, [mbYes, mbNo], 0) = mrYes then begin
      dmd.cdAdd.Delete;
      ApplyTable(dmd.cdAdd);
      ReloadQuery(qiAdd);
//    if SendContr then SendNotif(ContractNotif); // Посылаем всем сообщение, что надо перечитать дополнения
    end;
  end;
end;

procedure TDocFrame.ContrTimerTimer(Sender: TObject);
begin
  if not AllowContract or not PermitWork then Exit;
  if dmd.cdAdd.Active or not Database.Connected then Exit;
  Inc(WaitRefresh);
  if WaitRefresh >= 6 then begin
    ContrTimer.Enabled := false;
    WaitRefresh := 0;
    with dmd do begin
      dmd.OpenDataSet(cdAdd);
      ReEnableControls(cdAdd);
      dmd.OpenDataSet(cdContrOrder);
      ReEnableControls(cdContrOrder);
    end;
    ContrTimer.Enabled := true;
  end;
end;

procedure TDocFrame.NewAdd;
const StuffStr = '-     ';
var
  sName, dName: string;
begin
  with dmd do begin
    if not (ApplyTable(cdContract) and ApplyTable(cdAdd)) then Exit;
    if not cdContract.Active or cdContract.IsEmpty or not cdAdd.Active then Exit;
    ReEnableControls(cdAdd);
    cdAdd.Append;
    cdAdd['Name'] := StuffStr;      // Потом по этой строке найдем запись
    if ExecSelectDocFileName(sName, 'Выбор Файла - дополнения к документу') then begin
      dName := ExtractFileName(sName);
      if InputQuery('Новый документ', 'Название', dName) then begin
        // нужно проверить, не существует ли уже дополнение к договору с таким именем
        if cdAdd.Locate('Name', dName, [loCaseInsensitive]) then begin
          cdAdd.CancelUpdates;
          RusMessageDlg('Документ с таким именем уже существует', mtError, [mbOk], 0);
          Exit;
        end;
        cdAdd.Post;
        cdAdd.Locate('Name', StuffStr, []);
        if not (cdAdd.State in [dsEdit, dsInsert]) then cdAdd.Edit;
        cdAdd['Name'] := dName;
        cdAdd['DocFileName'] := sName;
        ApplyTable(cdAdd);
        ReloadQuery(qiAdd);
//        if SendContr then SendNotif(ContractNotif); // Посылаем всем сообщение, что надо перечитать дополнения
      end else
        cdAdd.CancelUpdates;
    end else
      cdAdd.CancelUpdates;
  end;
end;

procedure TDocFrame.NewContrOrder;
var
  i, CurCustomer: integer;
begin
  with dmd do begin
    if not (ApplyTable(cdContract) and ApplyTable(cdContrOrder)) then Exit;
    if not cdContract.Active or cdContract.IsEmpty or not cdContrOrder.Active then Exit;
    ReEnableControls(cdContrOrder);
    cdContrOrder.Append;
    if VarIsNull(cdContract['Customer']) then
      CurCustomer := 0
    else                                       // Только заказы выбранного заказчика
      CurCustomer := cdContract['Customer'];
    if ExecSelectOrderForm(CurCustomer, {WithoutExpCalc} false, {var ProductID} i) = mrOk then begin
      try
        if i = 0 then Exit;
        cdContrOrder['ContrID'] := cdContract['ID'];
        cdContrOrder['OrderID'] := i;
        try cdContrOrder['ProductName'] := cdOrders['Comment']; except end;
        if not ApplyTable(cdContrOrder) then Exit;
        ReloadQuery(qiContrOrder);
//        if SendContr then SendNotif(ContractNotif); // Посылаем всем сообщение, что надо перечитать заказы
        EditContrOrder;
      except
        cdContrOrder.CancelUpdates;
        RusMessageDlg('Ошибка при выборе заказа', mtInformation, [mbOk], 0);
      end;
    end else
      cdContrOrder.CancelUpdates;
  end;
end;

procedure TDocFrame.EditContrOrder;
begin
  with dmd do begin
    if cdContrOrder.Active and not cdContrOrder.IsEmpty then
      if ExecContrOrderProp = mrOk then begin
        ApplyTable(cdContrOrder);
        ReloadQuery(qiContrOrder);
        {$IFNDEF NoNet}
        if SendContr then SendNotif(ContractNotif); // Посылаем всем сообщение, что надо перечитать заказы
        {$ENDIF}
      end else
        cdContrOrder.CancelUpdates;
  end;
end;

// Редактирование документа или дополнения к документу
procedure TDocFrame.EditDoc(dq: TClientDataSet; qi: TQueryIndex; OpenText: boolean);
begin
  if OpenText then
     ExecOpenDocText(dq)
  else begin
    AllNotifIgnore := true;
    try
      if (dq.Active) and not dq.IsEmpty then begin
         if not (dq.State in [dsEdit, dsInsert]) then dq.Edit;
         if ExecNewDocForm(false) = mrOk then begin
           ApplyTable(dq);
           ReloadQuery(qi);
          {$IFNDEF NoNet}
           if SendContr then SendNotif(ContractNotif); // Посылаем всем сообщение, что надо перечитать договора
          {$ENDIF}
         end else
           dq.CancelUpdates;
      end;
    finally
      AllNotifIgnore := false;
    end;
  end;
end;

// -----  Такой же код (почти)- в Документации:DocFrm !!!!!!!!

procedure TDocFrame.NewDoc;
begin
  with dmd do begin
    if not ApplyTable(cdContract) then Exit;
    ReEnableControls(cdContract);
    cdContract.Append;
    if ExecNewDocForm(true) = mrOk then begin
      ApplyTable(cdContract);
      ReloadQuery(qiContract);
      {$IFNDEF NoNet}
      if SendContr then SendNotif(ContractNotif); // Посылаем всем сообщение, что надо перечитать договора
      {$ENDIF}
    end else
      cdContract.CancelUpdates;
  end;
end;

procedure TDocFrame.EnableTimer;
begin
  MForm.ContrTimer.Enabled := AllowContract;
end;

end.
