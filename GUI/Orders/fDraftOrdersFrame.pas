unit fDraftOrdersFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fOrdersFrame, Menus, StdCtrls, Mask, DBCtrls, Buttons, GridsEh,
  DBGridEh, MyDBGridEh, ExtCtrls, JvExExtCtrls, JvNetscapeSplitter,
  DBGridEhGrouping;

type
  TDraftOrdersFrame = class(TOrdersFrame)
  private
    { Private declarations }
  protected
    procedure CreateGridColumns; override;
  public
    procedure AfterConstruction; override;
  end;

implementation

uses PmAccessManager, PmEntSettings;

{$R *.dfm}

procedure TDraftOrdersFrame.AfterConstruction;
begin
  inherited;
  MkCalcItem.Visible := false;
end;

procedure TDraftOrdersFrame.CreateGridColumns;
var
  Col: TColumnEh;
begin
  Col := dgOrders.Columns.Add;
  Col.FieldName := 'ID';
  Col.Title.Caption := '�';
  Width := 53;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'CustomerName';
  Col.Title.Caption := '��������';
  Col.Width := 95;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'Comment';
  Col.Title.Caption := '������������';
  Col.Width := 200;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'ClientTotalGrn';//'FinalCostGrn';
  Col.Title.Caption := '���������, ���';
  Col.Width := 80;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'ClientTotal';
  Col.Title.Caption := '���������, �.�.';
  Col.Width := 80;
  Col.Visible := not EntSettings.NativeCurrency;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'Tirazz';
  Col.Title.Caption := '�����';
  Col.Width := 80;
  Col.OnGetCellParams := TirazzGetCellParams;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'Comment2';
  Col.Title.Caption := '�����������';
  Col.Width := 200;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'CustomerPhone';
  Col.Title.Caption := '���.1';
  Col.Width := 150;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'CustomerFax';
  Col.Title.Caption := '���.2';
  Col.Width := 150;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'CreationDate';
  Col.Title.Caption := '���� ����.';
  Col.Width := 80;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'CreationTime';
  Col.Title.Caption := '����� ����.';
  Col.Width := 60;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'ModifyDate';
  Col.Title.Caption := '���� ���.';
  Col.Width := 80;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'ModifyTime';
  Col.Title.Caption := '����� ���.';
  Col.Width := 60;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'CreatorName';
  Col.Title.Caption := '���������';
  Col.Width := 120;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'KindName';
  Col.Title.Caption := '���';
  Col.Width := 120;
  Col.Title.TitleButton := false;
end;

end.
