unit fmRelated;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGridEh, MyDBGridEh, ImgList, GridsEh, DBGridEhGrouping;

type
  TRelatedProcessGridFrame = class(TFrame)
    dgProcess: TMyDBGridEh;
    imStates: TImageList;
    procedure dgProcessDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
  private
    FStateCodeList, FStateTextList: TStringList;
    FShowProcessState: boolean;
    FShowOrderDate: boolean;
    function GetDBGrid: TDBGridEh;
    procedure SetShowPartName(Value: boolean);
    procedure SetShowProcessState(Value: boolean);
    procedure SetShowOrderDate(Value: boolean);
  public
    procedure UpdateHeight;
    property DBGrid: TDBGridEh read GetDBGrid;
    property ShowPartName: boolean write SetShowPartName;
    property ShowProcessState: boolean write SetShowProcessState;
    property ShowOrderDate: boolean write SetShowOrderDate;
    { Public declarations }
    constructor Create(Owner: TComponent);

  end;

implementation

uses fProdBase, CalcUtils, RDBUtils, PmUtils, PmProcess;

{$R *.dfm}

constructor TRelatedProcessGridFrame.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  FShowOrderDate := true; // видно по умолчанию
end;

procedure TRelatedProcessGridFrame.dgProcessDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  if Column.FieldName = 'ContractorProcess' then
  begin
    (Sender as TGridClass).Canvas.FillRect(Rect);
    if NvlBoolean(Column.Field.Value) then
      DrawGridCellBitmap((Sender as TGridClass).Canvas, Rect, bmpContractor, clFuchsia, taCenter);
  end
  else
    dgProcess.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

function TRelatedProcessGridFrame.GetDBGrid: TDBGridEh;
begin
  Result := dgProcess;
end;

procedure TRelatedProcessGridFrame.UpdateHeight;
var c: integer;
begin
  c := DBGrid.DataSource.DataSet.RecordCount;
  if c = 0 then c := 1;
  if c > 8 then c := 8;
  Height := dgProcess.TitleHeight + 6 + c * (dgProcess.RowHeight + 1);
end;

procedure TRelatedProcessGridFrame.SetShowPartName(Value: boolean);
begin
  dgProcess.FieldColumns[F_PartName].Visible := Value;
end;

procedure TRelatedProcessGridFrame.SetShowProcessState(Value: boolean);
var
  c: TColumnEh;
begin
  if Value and not FShowProcessState then
  begin
    TStateImages.CreateProcessStateLists(imStates, FStateCodeList, FStateTextList);

    // Первый стобец - 'ExecState'
    c := dgProcess.FieldColumns['ExecState'];
    c.Visible := true;
    c.ImageList := imStates;
    c.NotInKeyListIndex := -1;
    c.DblClickNextval := false;
    c.KeyList.Assign(FStateCodeList);
    c.PickList.Assign(FStateTextList);
  end
  else
  if FShowProcessState and not Value then
  begin
    c := dgProcess.FieldColumns['ExecState'];
    c.Visible := false;
    imStates.Clear;
    c.ImageList := nil;
    FStateCodeList.Free;
    FStateTextList.Free;
  end;

  FShowProcessState := Value;
end;

procedure TRelatedProcessGridFrame.SetShowOrderDate(Value: boolean);
var
  c: TColumnEh;
begin
  if Value <> FShowOrderDate then
  begin
    c := dgProcess.FieldColumns['CreationDate'];
    c.Visible := Value;
  end;
  FShowOrderDate := Value;
end;

end.
