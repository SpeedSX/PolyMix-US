unit PmDocItemEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseEditForm, JvComponentBase, StdCtrls, DBGridEh, JvFormPlacement,
  Mask, DBCtrlsEh, DBLookupEh, DBCtrls, DB,

  PmEntity, PmDocument, Buttons;

type
  TDocItemEditForm = class(TBaseEditForm)
    lbSource: TLabel;
    comboSource: TDBLookupComboboxEh;
    lbEditableName: TLabel;
    edItemText: TDBEdit;
    edQuantity: TDBEdit;
    edItemCost: TDBEdit;
    lbQuantity: TLabel;
    lbItemCost: TLabel;
    lbItemPrice: TLabel;
    dtPrice: TDBText;
    dsItemSource: TDataSource;
    procedure comboSourceChange(Sender: TObject);
  private
  protected
    FItems: TDocumentItems;
    FItemSourceData: TDataSet;
    //FSettingsControls: boolean;
    //FCustomerID: integer;
    procedure SetItems(Value: TDocumentItems); virtual;
    procedure SetItemSource(Value: TDataSet); virtual;
    procedure DoOnSourceChanged; virtual;
  public
    property Items: TDocumentItems read FItems write SetItems;
    property ItemSourceData: TDataSet read FItemSourceData write SetItemSource;
  end;

  TDocItemEditFormClass = class of TDocItemEditForm;
  
implementation

uses RDBUtils, CalcUtils, StdDic, PmSelectExtMatForm;

{$R *.dfm}

procedure TDocItemEditForm.SetItems(Value: TDocumentItems);
begin
  FItems := Value;
  edItemText.DataSource := FItems.DataSource;
  edQuantity.DataSource := FItems.DataSource;
  edItemCost.DataSource := FItems.DataSource;
  comboSource.DataSource := FItems.DataSource;
end;

procedure TDocItemEditForm.comboSourceChange(Sender: TObject);
begin
  DoOnSourceChanged;
end;

procedure TDocItemEditForm.SetItemSource(Value: TDataSet);
begin
  FItemSourceData := Value;
  dsItemSource.DataSet := FItemSourceData;
  //FSettingsControls := true;
  //FCustomerID := FCustomerOrders.Criteria.CustomerID;
  //FSettingsControls := false;
end;

procedure TDocItemEditForm.DoOnSourceChanged;
begin

end;

end.
