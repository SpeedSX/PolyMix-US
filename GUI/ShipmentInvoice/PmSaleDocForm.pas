unit PmSaleDocForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseEditForm, JvComponentBase, StdCtrls, DBCtrls, JvFormPlacement,
  Buttons, JvExControls, JvDBLookup, JvExMask, JvToolEdit, JvMaskEdit,
  JvCheckedMaskEdit, JvDatePickerEdit, JvDBDatePickerEdit, Mask,
  DB, GridsEh, DBGridEh, MyDBGridEh,

  NotifyEvent, PmSaleDocs, PmDocEditForm, PmDocument, PmContragent;

type
  TSaleDocForm = class(TDocEditForm)
    GroupBox2: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    edTrustNum: TDBEdit;
    edTrustSerie: TDBEdit;
    deTrustDate: TJvDBDatePickerEdit;
  private
  protected
    function ValidateForm: boolean; override;
    procedure SetDoc(Value: TDocument); override;
    function GetContragents: TContragents; override;
  public
  end;

implementation

{$R *.dfm}

uses RDBUtils, MainData, PmContragentListForm, StdDic,
  PmConfigManager;

procedure TSaleDocForm.SetDoc(Value: TDocument);
begin
  inherited;
  edTrustSerie.DataSource := Document.DataSource;
  edTrustNum.DataSource := Document.DataSource;
  deTrustDate.DataSource := Document.DataSource;
end;

function TSaleDocForm.ValidateForm: boolean;
begin
  Result := inherited ValidateForm;
  if Result then
  begin
    Result := not VarIsNull(lkPayType.KeyValue);
    if not Result then
    begin
      ActiveControl := lkPayType;
      raise Exception.Create('Пожалуйста, укажите вид оплаты');
    end;
  end;
end;

function TSaleDocForm.GetContragents: TContragents;
begin
  Result := Customers;
end;

end.
