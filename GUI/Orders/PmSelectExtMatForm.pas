unit PmSelectExtMatForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, MyDBGridEh, StdCtrls, DB, DicObj, DBGridEhGrouping;

type
  TSelectExternalDicForm = class(TForm)
    btOk: TButton;
    btCancel: TButton;
    dgExtDic: TMyDBGridEh;
    dsExtDic: TDataSource;
    rbNotSelected: TRadioButton;
    rbSelected: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure rbSelectedClick(Sender: TObject);
  private
    FExtMatID: variant;
    FExtDic: TDictionary;
    function GetExtID: variant;
    procedure SetExtID(Value: variant);
    procedure SetExtDic(Value: TDictionary);
  public
    property ExtID: variant read GetExtID write SetExtID;
    property ExtDic: TDictionary read FExtDic write SetExtDic;
  end;

//function ExecSelectExternalMaterialForm(var ExtMatID: variant): boolean;
//function ExecSelectExternalProductForm(var ExtProductID: variant): boolean;
function ExecSelectExternalDictionaryForm(var ExtID: variant; Dic: TDictionary;
  Caption: string): boolean;

implementation

uses StdDic, RDBUtils;

{$R *.dfm}

function ExecSelectExternalDictionaryForm(var ExtID: variant; Dic: TDictionary;
  Caption: string): boolean;
var
  SelectExternalDicForm: TSelectExternalDicForm;
begin
  Application.CreateForm(TSelectExternalDicForm, SelectExternalDicForm);
  try
    SelectExternalDicForm.ExtDic := Dic;
    SelectExternalDicForm.ExtID := ExtID;
    Result := SelectExternalDicForm.ShowModal = mrOk;
    if Result then
      ExtID := SelectExternalDicForm.ExtID;
  finally
    FreeAndNil(SelectExternalDicForm);
  end;
end;

procedure TSelectExternalDicForm.FormCreate(Sender: TObject);
begin
  ActiveControl := dgExtDic;
end;

procedure TSelectExternalDicForm.SetExtID(Value: variant);
begin
  if FExtDic.LocateCode(NvlInteger(Value)) then
    rbSelected.Checked := true
  else
    rbNotSelected.Checked := true;
  rbSelectedClick(Self);
end;

function TSelectExternalDicForm.GetExtID: variant;
begin
  if rbSelected.Checked then
    Result := FExtDic.CurrentCode
  else
    Result := null;
end;

procedure TSelectExternalDicForm.rbSelectedClick(Sender: TObject);
begin
  dgExtDic.Enabled := rbSelected.Checked;
  if rbSelected.Checked then
    dgExtDic.Font.Color := clWindowText
  else
    dgExtDic.Font.Color := clGrayText;
end;

procedure TSelectExternalDicForm.SetExtDic(Value: TDictionary);
begin
  FExtDic := Value;
  dsExtDic.DataSet := FExtDic.DicItems;
  Caption := FExtDic.Desc;
end;

end.
