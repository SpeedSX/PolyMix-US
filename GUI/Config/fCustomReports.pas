unit fCustomReports;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGridEh, MyDBGridEh, StdCtrls, ExtCtrls, GridsEh,
  DB,

  PmCustomReport, PmOrder, DBGridEhGrouping;

type
  TEditCustomReportsForm = class(TForm)
    Panel1: TPanel;
    btEdit: TButton;
    btNew: TButton;
    Panel2: TPanel;
    dgReports: TMyDBGridEh;
    btDelete: TButton;
    Panel3: TPanel;
    btOk: TButton;
    btCancel: TButton;
    dsCustomReports: TDataSource;
    btLoadFromFile: TButton;
    btSaveToFile: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure btNewClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btEditClick(Sender: TObject);
    procedure btSaveToFileClick(Sender: TObject);
    procedure btLoadFromFileClick(Sender: TObject);
  private
    FReportData: TCustomReports;
    FAfterInsertID, FAfterDeleteID: string;
    FOrder: TOrder;
    procedure ReportAfterDelete(Sender: TObject);
    procedure ReportAfterInsert(Sender: TObject);
    procedure UpdateButtonState;
  public
    constructor Create(_ReportData: TCustomReports; _Order: TOrder);
    function CalcReportName(RepName: string): string;
  end;

function ExecCustomReportEditor(ReportData: TCustomReports; OrderData: TOrder): boolean;

implementation

{$R *.dfm}

uses fCustomReportDetails, JvAppXMLStorage, jvAppStorage, RDBUtils, PmAccessManager;

function ExecCustomReportEditor(ReportData: TCustomReports; OrderData: TOrder): boolean;
var
  EditCustomReportsForm: TEditCustomReportsForm;
begin
  EditCustomReportsForm := TEditCustomReportsForm.Create(ReportData, OrderData);
  try
    Result := EditCustomReportsForm.ShowModal = mrOk;
  finally
    FreeAndNil(EditCustomReportsForm);
  end;
end;

constructor TEditCustomReportsForm.Create(_ReportData: TCustomReports; _Order: TOrder);
begin
  inherited Create(nil);
  FReportData := _ReportData;
  FOrder := _Order;
  dsCustomReports.DataSet := FReportData.DataSet;
  FAfterDeleteID := FReportData.AfterDeleteNotifier.RegisterHandler(ReportAfterDelete);
  FAfterInsertID := FReportData.AfterInsertNotifier.RegisterHandler(ReportAfterInsert);
  UpdateButtonState;
end;

function GetIndexedName(DataSet: TDataSet; FieldName, FieldValue: string): string;
var
  OldFilter: string;
  OldFiltered: boolean;
  FValue: string;
  Index: integer;
begin
  DataSet.DisableControls;
  OldFilter := DataSet.Filter;
  OldFiltered := DataSet.Filtered;
  Index := 0;
  try
    repeat
      if Index = 0 then begin
        Inc(Index);
        FValue := FieldValue;
      end else begin
        Inc(Index);
        FValue := FieldValue + ' (' + IntToStr(Index) + ')';
      end;
      DataSet.Filter := FieldName + '=''' + FValue + '''';
      DataSet.Filtered := true;
    until DataSet.RecordCount = 0;
  finally
    DataSet.Filter := OldFilter;
    DataSet.Filtered := OldFiltered;
    DataSet.EnableControls;
  end;
  Result := FValue;
end;

procedure TEditCustomReportsForm.btNewClick(Sender: TObject);
const
  NewReportStr = 'Новый отчет';
var
  NewName: string;
begin
  NewName := GetIndexedName(FReportData.DataSet, 'ReportName', NewReportStr);
  FReportData.DataSet.Append;
  FReportData.DataSet['ReportName'] := NewName;
  FReportData.ApplyUpdates;  // применяем и обновляем
  FReportData.DataSet.Locate('ReportName', NewName, []);
  if ExecCustomReportDetailsEditor(FReportData, FOrder) then
    FReportData.ApplyUpdates
  else
    FReportData.CancelUpdates;
end;

procedure TEditCustomReportsForm.btDeleteClick(Sender: TObject);
begin
  FReportData.DataSet.Delete;
end;

procedure TEditCustomReportsForm.ReportAfterDelete(Sender: TObject);
begin
  UpdateButtonState;
end;

procedure TEditCustomReportsForm.ReportAfterInsert(Sender: TObject);
begin
  UpdateButtonState;
end;

procedure TEditCustomReportsForm.UpdateButtonState;
var c: boolean;
begin
  c := FReportData.DataSet.IsEmpty;
  btDelete.Enabled := not c and AccessManager.CurUser.DeleteCustomReports;
  btEdit.Enabled := not c and AccessManager.CurUser.EditCustomReports;;
  btNew.Enabled := AccessManager.CurUser.EditCustomReports;
end;

procedure TEditCustomReportsForm.FormDestroy(Sender: TObject);
begin
  FReportData.AfterInsertNotifier.UnregisterHandler(FAfterInsertID);
  FReportData.AfterDeleteNotifier.UnregisterHandler(FAfterDeleteID);
end;

procedure TEditCustomReportsForm.btEditClick(Sender: TObject);
begin
  if ExecCustomReportDetailsEditor(FReportData, FOrder) then
    FReportData.ApplyUpdates
  else
    FReportData.CancelUpdates;
end;

const
  ParamsTag = 'Params\';
  ItemsTag = 'Items';
  RootNode = 'ReportInfo';

{type
  TItemObj = class(TPersistent, IJvAppStoragePublishedProps)
  published
    FieldSourceType: integer;
    FieldName: string;
    Caption: string;
    ProcessID: integer;
    OrderNum: integer;
    FontBold, FontItalic, CaptionFontBold, CaptionFontItalic: boolean;
    Alignment, CaptionAlignment: integer;
    FontColor, BkColor, CaptionFontColor: integer;
    DisplayFormat, Filter: string;
    SumTotal, SumByGroup: boolean;
  end;}

procedure WriteFieldList(xml: TJvAppXMLFileStorage);
var
  cdDetails: TDataSet;
  ItemN: integer;
  //list: TList;
  //ItemObj: TItemObj;

  procedure WriteValue(FieldName, val: string);
  begin
    xml.WriteString(ItemsTag + '\Item' + IntToStr(ItemN) + '\' + FieldName, val);
  end;

  procedure WriteB(FieldName: string);
  begin
    WriteValue(FieldName, IntToStr(Ord(NvlBoolean(cdDetails[FieldName]))));
  end;

  procedure WriteI(FieldName: string);
  begin
    WriteValue(FieldName, IntToStr(NvlInteger(cdDetails[FieldName])));
  end;

  procedure WriteS(FieldName: string);
  begin
    WriteValue(FieldName, NvlString(cdDetails[FieldName]));
  end;

begin
  //list := TList.Create;
  cdDetails := CustomReports.Details.DataSet;
  cdDetails.First;
  ItemN := 0;
  while not cdDetails.Eof do
  begin
    {ItemObj := TItemObj.Create;
    ItemObj.FieldSourceType := cdDetails['FieldSourceType'];
    ItemObj.FieldName := cdDetails['FieldName'];
    ItemObj.Caption := cdDetails['Caption'];
    ItemObj.ProcessID := NvlInteger(cdDetails['ProcessID']);
    ItemObj.OrderNum := cdDetails['OrderNum'];
    ItemObj.FontBold := cdDetails['FontBold'];
    ItemObj.FontItalic := cdDetails['FontItalic'];
    ItemObj.CaptionFontBold := cdDetails['CaptionFontBold'];
    ItemObj.CaptionFontItalic := cdDetails['CaptionFontItalic'];
    ItemObj.Alignment := cdDetails['Alignment'];
    ItemObj.CaptionAlignment := cdDetails['CaptionAlignment'];
    ItemObj.FontColor := cdDetails['FontColor'];
    ItemObj.BkColor := cdDetails['BkColor'];
    ItemObj.CaptionFontColor := cdDetails['CaptionFontColor'];
    ItemObj.DisplayFormat := NvlString(cdDetails['DisplayFormat']);
    ItemObj.Filter := NvlString(cdDetails['Filter']);
    ItemObj.SumTotal := NvlBoolean(cdDetails['SumTotal']);
    ItemObj.SumByGroup := NvlBoolean(cdDetails['SumByGroup']);
    list.Add(ItemObj);}
    WriteI('FieldSourceType');
    WriteS('FieldName');
    WriteS('Caption');
    WriteI('ProcessID');
    WriteI('OrderNum');
    WriteB('FontBold');
    WriteB('FontItalic');
    WriteB('CaptionFontBold');
    WriteB('CaptionFontItalic');
    WriteI('Alignment');
    WriteI('CaptionAlignment');
    WriteI('FontColor');
    WriteI('BkColor');
    WriteI('CaptionFontColor');
    WriteS('DisplayFormat');
    WriteS('Filter');
    WriteB('SumTotal');
    WriteB('SumByGroup');
    cdDetails.Next;
    Inc(ItemN);
  end;
  //Result := list;
end;

procedure TEditCustomReportsForm.btSaveToFileClick(Sender: TObject);
var
  xml: TJvAppXMLFileStorage;
  //FieldList: TList;

  procedure WriteBoolParam(ParamName: string);
  var b: boolean;
  begin
    b := NvlBoolean(CustomReports.DataSet[ParamName]);
    xml.WriteInteger(ParamsTag + ParamName, Ord(b));
  end;

  procedure WriteIntegerParam(ParamName: string);
  begin
    if not VarIsNull(CustomReports.DataSet[ParamName]) then
      xml.WriteInteger(ParamsTag + ParamName, CustomReports.DataSet[ParamName]);
  end;

begin
  if SaveDialog1.Execute then
  begin
    xml := TJvAppXMLFileStorage.Create(nil);
    try
      xml.FileName := SaveDialog1.FileName;
      xml.Location := flCustom;
      xml.RootNodeName := RootNode;
      xml.WriteString(ParamsTag + 'Name', CustomReports.ReportCaption);
      xml.WriteInteger(ParamsTag + 'ItemCount', CustomReports.Details.DataSet.RecordCount);

      WriteBoolParam('AddFilter');
      WriteBoolParam('ProcessDetails');
      WriteBoolParam('IncludeEmptyDetails');
      WriteBoolParam('RepeatOrderFields');
      WriteIntegerParam('Sort1');
      WriteIntegerParam('Sort2');
      WriteIntegerParam('Sort3');
      WriteIntegerParam('Sort4');
      WriteBoolParam('SortAscending');

      WriteFieldList(xml) ;
      //FieldList := BuildFieldList(xml);
      //try
        //xml.WriteObjectList('Items', FieldList);
      //finally
      //  FieldList.Free;
      //end;
      xml.Flush;
    finally
      xml.Free;
    end;
  end;
end;

procedure ReadFieldList(xml: TJvAppXMLFileStorage);
var
  Count, i: integer;
  cd: TDataSet;

  procedure ReadI(FieldName: string);
  begin
    cd[FieldName] := xml.ReadInteger(ItemsTag + '\Item' + IntToStr(I) + '\' + FieldName);
  end;

  procedure ReadS(FieldName: string);
  begin
    cd[FieldName] := xml.ReadString(ItemsTag + '\Item' + IntToStr(I) + '\' + FieldName);
  end;

  procedure ReadB(FieldName: string);
  begin
    cd[FieldName] := xml.ReadInteger(ItemsTag + '\Item' + IntToStr(I) + '\' + FieldName) = 1;
  end;

begin
  Count := xml.ReadInteger(ParamsTag + 'ItemCount');
  cd := CustomReports.Details.DataSet;
  for i := 0 to Count - 1 do
  begin
    cd.Append;
    ReadI('FieldSourceType');
    ReadS('FieldName');
    ReadS('Caption');
    ReadI('ProcessID');
    ReadI('OrderNum');
    ReadB('FontBold');
    ReadB('FontItalic');
    ReadB('CaptionFontBold');
    ReadB('CaptionFontItalic');
    ReadI('Alignment');
    ReadI('CaptionAlignment');
    ReadI('FontColor');
    ReadI('BkColor');
    ReadI('CaptionFontColor');
    ReadS('DisplayFormat');
    ReadS('Filter');
    ReadB('SumTotal');
    ReadB('SumByGroup');
  end;
end;

procedure TEditCustomReportsForm.btLoadFromFileClick(Sender: TObject);
var
  xml: TJvAppXMLFileStorage;
  cd: TDataSet;
  NewName: string;

  procedure ReadBoolParam(ParamName: string);
  begin
    cd[ParamName] := xml.ReadInteger(ParamsTag + ParamName, 0) = 1;
  end;

  procedure ReadIntegerParam(ParamName: string);
  var v: integer;
  begin
    v := xml.ReadInteger(ParamsTag + ParamName, -1);
    if v <> -1 then
      cd[ParamName] := v;
  end;

begin
  if OpenDialog1.Execute then
  begin
    xml := TJvAppXMLFileStorage.Create(nil);
    xml.AutoReload := false;
    xml.AutoFlush := false;
    try
      xml.FileName := OpenDialog1.FileName;
      xml.Location := flCustom;
      xml.RootNodeName := RootNode;
      xml.Reload;
      cd := FReportData.DataSet;

      NewName := xml.ReadString(ParamsTag + 'Name');
      // Проверяем есть ли уже с таким же именем
      if FReportData.DataSet.Locate('ReportName', NewName, []) then
        NewName := CalcReportName(NewName);
      // Добавляем новый
      cd.Append;
      cd['ReportName'] := NewName;

      ReadBoolParam('AddFilter');
      ReadBoolParam('ProcessDetails');
      ReadBoolParam('IncludeEmptyDetails');
      ReadBoolParam('RepeatOrderFields');
      ReadIntegerParam('Sort1');
      ReadIntegerParam('Sort2');
      ReadIntegerParam('Sort3');
      ReadIntegerParam('Sort4');
      ReadBoolParam('SortAscending');

      FReportData.ApplyUpdates;  // применяем и обновляем

      if FReportData.DataSet.Locate('ReportName', NewName, []) then
        ReadFieldList(xml);
      //FieldList := BuildFieldList(xml);
      //try
        //xml.WriteObjectList('Items', FieldList);
      //finally
      //  FieldList.Free;
      //end;
    finally
      xml.FileName := '';   // Для того чтобы не сохранялся файл
      xml.Free;
    end;
  end;
end;

function TEditCustomReportsForm.CalcReportName(RepName: string): string;
var
  i: Integer;
  NewName: string;
begin
  i := 1;
  repeat
    NewName := RepName + ' (' + IntToStr(i) + ')';
    Inc(i);
  until not FReportData.DataSet.Locate('ReportName', NewName, []);
  Result := NewName;
end;

end.
