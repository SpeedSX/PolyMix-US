unit NDicFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBClient, DataHlp, DicObj, DB;

const
  sNewDicCap = 'Новый справочник';
  sEditDicCap = 'Свойства справочника';

type
  TNewDicForm = class(TForm)
    edDesc: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edName: TEdit;
    btOk: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    rbTable: TRadioButton;
    rbMDim: TRadioButton;
    btStruct: TButton;
    procedure btStructClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
  private
    FStructData: TClientDataSet;
    //FDicDataSource: TDataSource;
  public
    property StructData: TClientDataSet read FStructData write FStructData;
    //property DicDataSource: TDataSource read FDicDataSource write FDicDataSource;
  end;

var
  NewDicForm: TNewDicForm;

// DicProp = nil - режим создания нового справочника,
// иначе редактирования свойств справочника DicProp.
function ExecNewDic(var DicName, DicDesc: string; var MultiDim: boolean;
  var StructData: TClientDataSet; DicProp: TDictionary): boolean;

implementation

{$R *.DFM}

uses DicStFrm, DicData;

function ExecNewDic(var DicName, DicDesc: string; var MultiDim: boolean;
  var StructData: TClientDataSet; DicProp: TDictionary): boolean;
var
  NewMode: boolean;
begin
  NewDicForm := TNewDicForm.Create(nil);
  try
    NewMode := DicProp = nil;
    if NewMode then NewDicForm.Caption := sNewDicCap
    else NewDicForm.Caption := sEditDicCap;
    NewDicForm.edDesc.Text := DicDesc;
    NewDicForm.edName.Text := DicName;
    NewDicForm.rbMDim.Checked := MultiDim; //    NewDicForm.rbTable.Checked := not MultiDim;
    // Менять тип можно только в новом справочнике
    NewDicForm.rbTable.Enabled := NewMode;
    NewDicForm.rbMDim.Enabled := NewMode;
    NewDicForm.edName.Enabled := NewMode;
    // Создаем набор данных, описывающий структуру справочника
    if (StructData = nil) and not DicDm.CreateDicStructData(StructData, DicProp, false) then
    begin
      Result := false;
      Exit;
    end;
    NewDicForm.StructData := StructData;
    Result := NewDicForm.ShowModal = mrOk;
    if Result then
    begin
      DicDesc := NewDicForm.edDesc.Text;
      DicName := NewDicForm.edName.Text;
      MultiDim := NewDicForm.rbMDim.Checked;
    end;
    // StructData здесь не освобождается!
  finally
    NewDicForm.Free;
  end;
end;

procedure TNewDicForm.btStructClick(Sender: TObject);
begin
  ExecStructForm(FStructData, stDic, cmClose);
end;

procedure TNewDicForm.btOkClick(Sender: TObject);
begin
  if (edDesc.Text = '') or (edName.Text = '') then ModalResult := mrNone;
end;

end.
