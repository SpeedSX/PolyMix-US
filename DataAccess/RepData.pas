unit RepData;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBClient, Provider, ADODB, DBTables, PmDatabase;

type
  Trdm = class(TDataModule, IRCDataModule)
    aqCustomReports: TADOQuery;
    aqForms: TADOQuery;
    aqFormsDesc: TStringField;
    aqFormsFormDfm: TMemoField;
    aqFormsFormID: TAutoIncField;
    aqFormsFormPas: TMemoField;
    aqFormsModifyDate: TDateTimeField;
    aqFormsName: TStringField;
    aqOrdScripts: TADOQuery;
    aqOrdScriptsModifyDate: TDateTimeField;
    aqOrdScriptsScript: TMemoField;
    aqOrdScriptsScriptDesc: TStringField;
    aqOrdScriptsScriptID: TAutoIncField;
    aqOrdScriptsScriptName: TStringField;
    aqReports: TADOQuery;
    aqReportsIsDefault: TBooleanField;
    aqReportsIsUnit: TBooleanField;
    aqReportsModifyDate: TDateTimeField;
    aqReportsScript: TMemoField;
    aqReportsScriptDesc: TStringField;
    aqReportsScriptID: TAutoIncField;
    aqReportsScriptName: TStringField;
    aqReportsShortCut: TIntegerField;
    aqReportsShowCancel: TBooleanField;
    aqReportsWorkInsideOrder: TBooleanField;
    cdCustomReports: TClientDataSet;
    cdCustomReportsAddFilter: TBooleanField;
    cdCustomReportsProcessDetails: TBooleanField;
    cdCustomReportsProcessLine: TBooleanField;
    cdCustomReportsReportID: TAutoIncField;
    cdCustomReportsReportName: TStringField;
    cdForms: TClientDataSet;
    cdFormsFormDesc: TStringField;
    cdFormsFormDfm: TMemoField;
    cdFormsFormID: TAutoIncField;
    cdFormsFormName: TStringField;
    cdFormsFormPas: TMemoField;
    cdFormsModifyDate: TDateTimeField;
    cdOrdScripts: TClientDataSet;
    cdOrdScriptsModifyDate: TDateTimeField;
    cdOrdScriptsScript: TMemoField;
    cdOrdScriptsScriptDesc: TStringField;
    cdOrdScriptsScriptID: TAutoIncField;
    cdOrdScriptsScriptName: TStringField;
    cdReports: TClientDataSet;
    cdReportsIsDefault: TBooleanField;
    cdReportsIsUnit: TBooleanField;
    cdReportsModifyDate: TDateTimeField;
    cdReportsScript: TMemoField;
    cdReportsScriptDesc: TStringField;
    cdReportsScriptID: TAutoIncField;
    cdReportsScriptName: TStringField;
    cdReportsShortCut: TIntegerField;
    cdReportsShowCancel: TBooleanField;
    cdReportsWorkInsideOrder: TBooleanField;
    dsForms: TDataSource;
    dsOrdScripts: TDataSource;
    dsReports: TDataSource;
    pvCustomReports: TDataSetProvider;
    pvForms: TDataSetProvider;
    pvOrdScripts: TDataSetProvider;
    pvReports: TDataSetProvider;
    cdCustomReportCols: TClientDataSet;
    pvCustomReportCols: TDataSetProvider;
    aqCustomReportCols: TADOQuery;
    cdCustomReportColsReportItemID: TAutoIncField;
    cdCustomReportColsReportID: TIntegerField;
    cdCustomReportColsFieldSourceType: TIntegerField;
    cdCustomReportColsFieldName: TStringField;
    cdCustomReportColsCaption: TStringField;
    cdCustomReportColsProcessID: TIntegerField;
    cdCustomReportColsOrderNum: TIntegerField;
    cdCustomReportColsFontBold: TBooleanField;
    cdCustomReportColsFontItalic: TBooleanField;
    cdCustomReportColsAlignment: TIntegerField;
    cdCustomReportColsFontColor: TIntegerField;
    cdCustomReportColsBkColor: TIntegerField;
    cdCustomReportColsCaptionFontBold: TBooleanField;
    cdCustomReportColsCaptionFontItalic: TBooleanField;
    cdCustomReportColsCaptionFontColor: TIntegerField;
    cdCustomReportColsCaptionBkColor: TIntegerField;
    cdCustomReportColsCaptionAlignment: TIntegerField;
    cdCustomReportColsSourceName: TStringField;
    cdCustomReportsIncludeEmptyDetails: TBooleanField;
    cdCustomReportColsDisplayFormat: TStringField;
    cdCustomReportsRepeatOrderFields: TBooleanField;
    cdCustomReportColsSumByGroup: TBooleanField;
    cdCustomReportColsSumTotal: TBooleanField;
    cdCustomReportsSort1: TIntegerField;
    cdCustomReportsSort2: TIntegerField;
    cdCustomReportsSort3: TIntegerField;
    cdCustomReportsSortAscending: TBooleanField;
    cdCustomReportsSort4: TIntegerField;
    cdCustomReportColsFilter: TStringField;
    cdCustomReportColsFilterEnabled: TBooleanField;
    cdCustomReportColsFilterType: TIntegerField;
    cdCustomReportColsAutoFitColumn: TBooleanField;
    cdCustomReportColsColumnWidth: TIntegerField;
    cdCustomReportsAddRowAfterGroup: TBooleanField;
    procedure cdFormsNewRecord(DataSet: TDataSet);
    procedure GetUnitSource(UnitName: String; var Source: String;
      var Done: Boolean);
    procedure pvFormsBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
      UpdateKind: TUpdateKind; var Applied: Boolean);
    procedure pvReportsBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
      var Applied: Boolean);
    procedure cdReportsNewRecord(DataSet: TDataSet);
  public
    procedure ApplyAll;
    procedure CancelAll;
    procedure CloseAll;
    procedure CreateDfmStream(Sender: TObject; UnitName: String;
      var Stream: TStream; var Done: Boolean);
    procedure FreeDfmStream(Sender: TObject; Stream: TStream);
    function OpenAll: boolean;
    procedure OpenDataSet(DataSet: TDataSet);
    function OpenForms: boolean;
    function OpenOrdScripts: boolean;
    function OpenReports: boolean;
  end;

var
  rdm: Trdm;

const
  FormNameField = 'FormName';
  FormDescField = 'FormDesc';
  FormPasField = 'FormPas';
  FormDfmField = 'FormDfm';
  FormDateField = 'ModifyDate';
  RptDateField = 'ModifyDate';
  F_ScriptName = 'ScriptName';
  F_ScriptDesc = 'ScriptDesc';
  ScriptField = 'Script';
  F_ScriptID = 'ScriptID';
  F_FormID = 'FormID';
  F_CustomReportColID = 'ReportItemID';
  F_CustomReportID = 'ReportID';

implementation

{$R *.DFM}

uses MainData, Datahlp, ServData, PmProcess, RDBUtils;

procedure Trdm.ApplyAll;
begin
  Database.ApplyDataSet(cdReports);
  Database.ApplyDataSet(cdForms);
  Database.ApplyDataSet(cdOrdScripts);
  CloseAll;
  OpenAll;
end;

procedure Trdm.CancelAll;
begin
  cdReports.CancelUpdates;
  cdForms.CancelUpdates;
  cdOrdScripts.CancelUpdates;
end;

procedure Trdm.cdFormsNewRecord(DataSet: TDataSet);
begin
  DataSet[FormNameField] := '';
  DataSet[FormDescField] := '';
  DataSet[FormPasField] := '';
  DataSet[FormDfmField] := '';
  DataSet[FormDateField] := Now;
end;

procedure Trdm.cdReportsNewRecord(DataSet: TDataSet);
begin
  DataSet['WorkInsideOrder'] := false;
  DataSet['IsUnit'] := false;
  DataSet['IsDefault'] := false;
  DataSet['ShowCancel'] := true;
  DataSet[RptDateField] := Now;
end;

procedure Trdm.CloseAll;
begin
  cdReports.Close;
  cdForms.Close;
  cdOrdScripts.Close;
end;

{// Читает скрипты и возвращает, используется CodeEditForm
function Trdm.GetFormScripts: TStringList;
var
  i: integer;
  Scripts: TStringList;
  so: TScript;
  f: TField;
begin
  Scripts := TStringList.Create;
  if sdm.ScriptInfo.Count > 0 then  // инициализация списка именами скриптов
    for i := 0 to Pred(sdm.ScriptInfo.Count) do begin
      // Добавляем, разумеется, только те скрипты, которые у нас есть,
      // т.к. описаний больше, чем надо.
      f := cdForms.FindField(sdm.ScriptInfo[i]);
      if f <> nil then begin
        so := NewScriptObj;
        ReadStringListFromBlob(so.Script, f as TBlobField);
        Scripts.AddObject(sdm.ScriptInfo[i], so);
      end;
    end;
  Result := Scripts;
end;}

{procedure TFormValue.WriteIni(Ini: TIniFile; Section: string);
begin
  if not varIsNull(Value) then begin
    if VarType(Value) = varBoolean then
      Ini.WriteInteger(Section, Name, Value)
    else if VarType(Value) = varInteger then         
      Ini.WriteInteger(Section, Name, Value)
    else if VarType(Value) = varDateTime then
      Ini.WriteDateTime(Section, Name, Value)
    else if VarType(Value) = varString then
      Ini.WriteString(Section, Name, Value)
    else if (VarType(Value) = varDouble) or (VarType(Value) = varCurrency) then
      Ini.WriteFloat(Section, Name, Value);
  end;
end;

procedure TFormValue.ReadIni(Ini: TIniFile; Section: string);
begin
  if not varIsNull(Value) then begin
    Value := DefaultValue;
    if VarType(Value) = varBoolean then
      Value := Ini.ReadString(Section, Name, DefaultValue) = '1'
    else if VarType(Value) = varInteger then
      Value := Ini.ReadInteger(Section, Name, DefaultValue)
    else if VarType(Value) = varDateTime then
      Value := Ini.ReadDateTime(Section, Name, DefaultValue)
    else if VarType(Value) = varString then
      Value := Ini.ReadString(Section, Name, DefaultValue)
    else if (VarType(Value) = varDouble) or (VarType(Value) = varCurrency) then
      Value := Ini.ReadFloat(Section, Name, DefaultValue);
  end;
end;}

procedure Trdm.CreateDfmStream(Sender: TObject; UnitName: String;
  var Stream: TStream; var Done: Boolean);
var
  f: TField;
begin
  try
    if not cdForms.Active then OpenForms;
    if cdForms.Locate(FormNameField, UnitName, [loCaseInsensitive]) then begin
      f := cdForms.FieldByName(FormDfmField);
      Stream := cdForms.CreateBlobStream(f, bmRead);
      Done := Stream <> nil;
    end else
      Done := false;
  except
    Done := false;
  end;
end;

procedure Trdm.FreeDfmStream(Sender: TObject; Stream: TStream);
begin
  if Stream <> nil then Stream.Free;
end;

procedure Trdm.GetUnitSource(UnitName: String; var Source: String; var Done: Boolean);
begin
  try
    if not cdForms.Active then OpenForms;
    if cdForms.Locate(FormNameField, UnitName, [loCaseInsensitive]) then begin
      Source := cdForms[FormPasField];
      Done := true;
    end else begin
      if not cdReports.Active then OpenReports;
      if cdReports.Locate(F_ScriptName, UnitName, [loCaseInsensitive]) then begin
        Source := cdReports[ScriptField];
        Done := true;
      end else
        Done := false;
    end;
  except
    Done := false;
  end;
end;

function Trdm.OpenAll: boolean;
begin
  OpenReports;
  OpenForms;
  OpenOrdScripts;
  Result := cdReports.Active and cdForms.Active and cdOrdScripts.Active;
end;

procedure TRDM.OpenDataSet(DataSet: TDataSet);
begin
  Database.OpenDataSet(DataSet);
end;

function Trdm.OpenForms: boolean;
begin
  OpenDataSet(cdForms);
  Result := cdForms.Active;
end;

function Trdm.OpenOrdScripts: boolean;
begin
  OpenDataSet(cdOrdScripts);
  Result := cdOrdScripts.Active;
end;

function Trdm.OpenReports: boolean;
begin
  OpenDataSet(cdReports);
  cdReports.AddIndex('iScriptDesc', 'ScriptDesc', []);
  cdReports.IndexDefs.Update;
  cdReports.IndexFieldNames := 'ScriptDesc';
  Result := cdReports.Active;
end;

procedure Trdm.pvFormsBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
  UpdateKind: TUpdateKind; var Applied: Boolean);
begin
  //try  09.05.2005
    if (UpdateKind = ukInsert) {or (UpdateKind = ukModify) }then begin
      DeltaDS.Edit;
      DeltaDS[FormDateField] := Now;
    end;
    DeltaDS.FieldByName(F_FormID).ProviderFlags := [pfInKey, pfInWhere];
  //except end;
end;

procedure Trdm.pvReportsBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
  var Applied: Boolean);
begin
  //try  09.05.2005
    if (UpdateKind = ukInsert) {or (UpdateKind = ukModify) }then begin
      DeltaDS.Edit;
      DeltaDS[FormDateField] := Now;
    end;
    DeltaDS.FieldByName(F_ScriptID).ProviderFlags := [pfInKey, pfInWhere];
  //except end;
end;

end.
