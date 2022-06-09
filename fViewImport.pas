unit fViewImport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGridEh, MyDBGridEh, StdCtrls, ExtCtrls, DB, DBClient,
  GridsEh, DBGridEhGrouping;

type
  TViewImportForm = class(TForm)
    Panel1: TPanel;
    btOk: TButton;
    btCancel: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    Panel3: TPanel;
    dgImport: TMyDBGridEh;
    cdImport: TClientDataSet;
    dsImport: TDataSource;
    cdImportEnabled: TBooleanField;
    cdImportFileName: TStringField;
    cdImportComment: TStringField;
    cdImportID_Number: TIntegerField;
    cdImportKindID: TIntegerField;
    cdImportCreationDate: TDateTimeField;
    cdImportCustomerName: TStringField;
    cdImportTotalCost: TFloatField;
    cdImportModifyDate: TDateTimeField;
    cdImportCreatorName: TStringField;
    cdImportModifierName: TStringField;
    procedure btCancelClick(Sender: TObject);
  private
    function GetDataSet: TDataSet;
    { Private declarations }
  public
    constructor Create(Owner: TComponent); override;
    property DataSet: TDataSet read GetDataSet;
  end;

var
  ViewImportForm: TViewImportForm;

function ViewImportFolder(var FileList: TStringList): boolean;

implementation

uses PmOrderExchange, FileCtrl, JvJclUtils, ServData, RDbUtils, RDialogs, PmOrder;

{$R *.dfm}

function ViewImportFolder(var FileList: TStringList): boolean;
const
  LastDir: string = '';
var
  sr: TSearchRec;
  OrderInfo: TOrderInfo;
  ViewDataSet: TDataSet;
  r: integer;
begin
  FileList := nil;
  if LastDir = '' then LastDir := ExtractFileDir(ParamStr(0));
  if SelectDirectory(LastDir, [], 0) then
  begin
    ViewImportForm := TViewImportForm.Create(nil);
    ViewDataSet := ViewImportForm.DataSet;
    try
      if FindFirst(LastDir + '\*.xml', faAnyFile, sr) = 0 then
      begin
        repeat
          if OrderExchange.ReadOrderInfo(LastDir + '\' + sr.Name, OrderInfo) then
          begin
            ViewDataSet.Append;
            ViewDataSet['Comment'] := OrderInfo.Comment;
            ViewDataSet['CustomerName'] := OrderInfo.CustomerName;
            ViewDataSet[TOrder.F_OrderNumber] := OrderInfo.ID_Number;
            ViewDataSet['Enabled'] := true;
            ViewDataSet['TotalCost'] := OrderInfo.TotalCost;
            ViewDataSet['FileName'] := sr.Name;
            ViewDataSet['KindID'] := OrderInfo.KindID;
            ViewDataSet['ModifyDate'] := OrderInfo.ModifyDate;
            ViewDataSet['CreationDate'] := OrderInfo.CreationDate;
            ViewDataSet.Post;
          end;
        until FindNext(sr) <> 0;
        FindClose(sr);
        ViewDataSet.First;
        if ViewDataSet.RecordCount > 0 then
        begin
          R := ViewImportForm.ShowModal;
          Result := r = mrOk;
          if Result then
          begin
            FileList := TStringList.Create;
            try
              ViewDataSet.First;
              while not ViewDataSet.Eof do
              begin
                if ViewDataSet['Enabled'] then
                  FileList.Add(LastDir + '\' + ViewDataSet['FileName']);
                ViewDataSet.Next;
              end;
            except on e: Exception do
              begin
                if FileList <> nil then FreeAndNil(FileList);
                raise e;
              end;
            end;
          end;
        end
        else
          RusMessageDlg('Не найдены файлы для импорта', mtInformation, [mbOk], 0);
      end;
    finally
      FreeAndNil(ViewImportForm);
    end;
  end;
end;

constructor TViewImportForm.Create;
begin
  inherited;
  CreateLookupField(cdImport, Self, TOrder.F_KindName, TStringField, 40,
     sdm.cdOrderKind, 'KindID', 'KindID', 'KindDesc');
  cdImport.CreateDataSet;
end;

function TViewImportForm.GetDataSet: TDataSet;
begin
  Result := cdImport;
end;

procedure TViewImportForm.btCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

end.
