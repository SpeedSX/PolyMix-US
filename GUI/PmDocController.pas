unit PmDocController;

interface

uses Classes, Variants, Forms, DB,

  PmEntity, PmDocument, PmDocEditForm, PmDocItemEditForm;

type
  // �������������� ���������
  TDocController = class
  protected
    FDocs: TDocument;
    FItemSourceData: TDataSet;
    procedure EditItem(Sender: TObject);
    procedure AddItem(Sender: TObject);
    procedure RemoveItem(Sender: TObject);
    procedure AppendItem(_ItemEntity: TDocumentItems);
    procedure CheckItemSource; virtual;
    function ExecAddItemForm: boolean; //virtual; abstract;
    function ExecEditItemForm: boolean; //virtual; abstract;
    // ���������� ����� �������� ���������
    function ExecNewDocForm(_OnAddItem,
      _OnEditItem, _OnRemoveItem: TNotifyEvent): boolean; //virtual; abstract;
    // ���������� ����� �������������� ���������
    function ExecEditDocForm(_OnAddItem,
      _OnEditItem, _OnRemoveItem: TNotifyEvent): boolean; //virtual; abstract;
    function GetFormClass: TDocEditFormClass; virtual; abstract;
    function GetItemFormClass: TDocItemEditFormClass; virtual; abstract;
    procedure DoItemFormCreated(_Form: TForm); virtual;
  public
    function EditDocForm: boolean;
    class function CheckDocNumber(Docs: TDocument): boolean;
    class procedure SetDefaultPayType(Docs: TDocument);
    property Document: TDocument read FDocs write FDocs;   // �������� ��� ��������������
  end;

  TDocControllerClass = class of TDocController;

implementation

uses SysUtils, Controls, Dialogs, DateUtils,

  CalcUtils, RDialogs, PmDatabase, MainFilter, RDBUtils, StdDic,
  PmConfigManager;

procedure TDocController.CheckItemSource;
begin

end;

// �������� �������
procedure TDocController.AddItem(Sender: TObject);
begin
  CheckItemSource;
  AppendItem(FDocs.Items);
  if not ExecAddItemForm then
    FDocs.Items.DataSet.Cancel;
end;

procedure TDocController.EditItem(Sender: TObject);
begin
  CheckItemSource;
  if not FDocs.Items.IsEmpty then
    if not ExecEditItemForm then
      FDocs.Items.DataSet.Cancel;
end;

procedure TDocController.RemoveItem(Sender: TObject);
begin
  if not FDocs.Items.IsEmpty
    and (RusMessageDlg('�� ������������� ������ ������� ������?',
              mtConfirmation, mbYesNoCancel, 0) = mrYes) then
    FDocs.Items.Delete;
end;

procedure TDocController.AppendItem(_ItemEntity: TDocumentItems);
begin
  _ItemEntity.Append;
end;

class function TDocController.CheckDocNumber(Docs: TDocument): boolean;
var
  DocIDs: TIntArray;
begin
  // ���������, ���� �� ��� ����� ����� �����
  DocIDs := Docs.FindByDocNum(Docs.DocNum,
    YearOf(Docs.DocDate), Docs.KeyValue, Docs.PayType);
  Result := Length(DocIDS) = 0;
  if not Result then
    RusMessageDlg('�������� � ������� ' + Docs.DocNum + ' ��� ����������',
      mtError, [mbOk], 0)
end;

function TDocController.EditDocForm: boolean;
var
  NumIsOk, Cancelled: boolean;
begin
  NumIsOk := true;
  repeat
    Cancelled := not ExecNewDocForm(AddItem, EditItem, RemoveItem);
    if not Cancelled then
    begin
      NumIsOk := CheckDocNumber(FDocs);
    end;
  until NumIsOk or Cancelled;
  Result := not Cancelled;
end;

class procedure TDocController.SetDefaultPayType(Docs: TDocument);
var
  PayType: integer;
begin
  PayType := TConfigManager.Instance.StandardDics.GetDefaultPayType;
  if PayType <> 0 then
    Docs.PayType := PayType;
end;

function TDocController.ExecEditItemForm: boolean;
begin
  Result := ExecAddItemForm;
end;

function TDocController.ExecAddItemForm: boolean;
var
  ItemForm: TDocItemEditForm;
begin
  Application.CreateForm(GetItemFormClass, ItemForm);
  try
    ItemForm.Items := Document.Items as TDocumentItems;
    ItemForm.ItemSourceData := FItemSourceData;
    DoItemFormCreated(ItemForm);
    Result := ItemForm.ShowModal = mrOk;
  finally
    FreeAndNil(ItemForm);
  end;
end;

// ���������� ����� �������� ��������� ����������.
function TDocController.ExecNewDocForm(_OnAddItem,
  _OnEditItem, _OnRemoveItem: TNotifyEvent): boolean;
begin
  Result := ExecEditDocForm(_OnAddItem, _OnEditItem, _OnRemoveItem);
end;

// ���������� ����� �������������� ���������
function TDocController.ExecEditDocForm(_OnAddItem,
  _OnEditItem, _OnRemoveItem: TNotifyEvent): boolean;
var
  DocForm: TDocEditForm;
begin
  Application.CreateForm(GetFormClass, DocForm);
  try
    DocForm.Document := FDocs;
    DocForm.OnAddItem := _OnAddItem;
    DocForm.OnEditItem := _OnEditItem;
    DocForm.OnRemoveItem := _OnRemoveItem;
    Result := DocForm.ShowModal = mrOk;
  finally
    FreeAndNil(DocForm);
  end;
end;

procedure TDocController.DoItemFormCreated(_Form: TForm);
begin

end;

end.
