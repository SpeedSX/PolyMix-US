unit PmReportData;

interface

uses Classes, DB, PmEntity;

type
  TReportData = class(TEntity)
  protected
    FFieldList: TList;
  public
    const
      F_RowID = 'RowID';
      AuxFieldsCount = 2;
    // Все передается в собственность!
    constructor Create(_ReportDataSet: TDataSet; _FieldList: TList);
    destructor Destroy; override;
    property FieldList: TList read FFieldList;
  end;

implementation

constructor TReportData.Create(_ReportDataSet: TDataSet; _FieldList: TList);
begin
  inherited Create;
  FKeyField := F_RowID;
  SetDataSet(_ReportDataSet);
  FFieldList := _FieldList;
end;

destructor TReportData.Destroy;
begin
  FFieldList.Free;
  inherited;
end;

end.
