unit PmScriptList;

interface

uses DB, DBClient, Provider, PmEntity;

type
  TScriptList = class(TEntity)
  private
  protected
    procedure DoAfterConnect; override;
    procedure DoOnNewRecord; override;
    {procedure ProviderUpdateError(Sender: TObject;
      DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind;
      var Response: TResolverResponse); override;}
  public
    //function ReportCaption: string;

    procedure Open; override;
    constructor Create; override;
    //property SortAscending: Boolean read GetSortAscending;
  end;

var
  ScriptList: TScriptList;

implementation

uses SysUtils, RepData, RDBUtils;

const
  F_ScriptID = 'ScriptID';

constructor TScriptList.Create;
begin
  inherited Create;
  FKeyField := F_ScriptID;
end;

procedure TScriptList.DoAfterConnect;
begin
end;

// ����� ������ ��������� ��������� AfterConnect �.�. � ���� ������ rdm ��� �� ������
// �� ����� ������, �.�. ����� ������ ������� Open � �� ��������������� timeouts.
procedure TScriptList.Open;
begin
  if DataSet = nil then
  begin
    SetDataSet(rdm.cdReports);
    DataSetProvider := rdm.pvReports;
    //ADODataSet := rdm.aqReports;
  end;
  inherited Open;
end;

procedure TScriptList.DoOnNewRecord;
begin
  DataSet['WorkInsideOrder'] := false;
  DataSet['IsUnit'] := false;
  DataSet['IsDefault'] := false;
  DataSet['ShowCancel'] := true;
  DataSet[RptDateField] := Now;
end;

{
procedure TCustomReports.ProviderUpdateError(Sender: TObject;
  DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind;
  var Response: TResolverResponse);
begin
  // ������� �������� MIDAS. ��� ���������� ������ �� ������� ����������� ��������,
  // ������� ������������ ������������ ���������� ����������� �����.
  if E.ErrorCode = 1 then
    Response := rrIgnore
  else
    inherited ProviderUpdateError(Sender, DataSet, E, UpdateKind, Response);
end;
}

initialization

ScriptList := TScriptList.Create;

finalization

FreeAndNil(ScriptList);

end.
