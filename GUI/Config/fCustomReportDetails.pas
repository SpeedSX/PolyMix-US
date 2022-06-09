unit fCustomReportDetails;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Grids, DBGridEh, GridsEh, MyDBGridEh,
  DBCtrls, Mask, Buttons, ImgList, JvCombobox, JvColorCombo, JvExStdCtrls,
  JvDBCombobox, DB, DBClient,

  AnyColor, PmProcess, PmProcessCfg, PmCustomReport, PmOrder,
  BaseRpt, FIBVTreeCmps, VirtualTrees, DBVirtualStringTree, DBGridEhGrouping;

type
  TCustomReportDetailsForm = class(TForm)
    edName: TDBEdit;
    lbName: TLabel;
    cbAddFilter: TDBCheckBox;
    cbProcessDetails: TDBCheckBox;
    lbPreview: TLabel;
    dgPreview: TMyDBGridEh;
    pcSourceFields: TPageControl;
    tsOrderFields: TTabSheet;
    tsProcessFields: TTabSheet;
    dgOrderFields: TMyDBGridEh;
    dgProcessFields: TMyDBGridEh;
    Panel1: TPanel;
    cbShowAllFields: TCheckBox;
    btAdd: TBitBtn;
    btAddAll: TBitBtn;
    btRemoveAll: TBitBtn;
    btRemove: TBitBtn;
    dgReportCols: TMyDBGridEh;
    lbCols: TLabel;
    btMoveDown: TBitBtn;
    btMoveUp: TBitBtn;
    btOk: TButton;
    btCancel: TButton;
    dsReportCols: TDataSource;
    dsReport: TDataSource;
    cdOrderFields: TClientDataSet;
    cdProcessFields: TVTClientDataSet;
    dsOrderFields: TDataSource;
    dsProcessFields: TDataSource;
    cdOrderFieldsOrderNum: TIntegerField;
    cdOrderFieldsFieldName: TStringField;
    cdOrderFieldsCaption: TStringField;
    cdOrderFieldsAdded: TBooleanField;
    cdProcessFieldsOrderNum: TIntegerField;
    cdProcessFieldsFieldName: TStringField;
    cdProcessFieldsCaption: TStringField;
    cdProcessFieldsProcessID: TIntegerField;
    cdProcessFieldsIsProcessName: TBooleanField;
    cdProcessFieldsAdded: TBooleanField;
    cdProcessFieldsIsGridField: TBooleanField;
    cbIncludeEmpty: TDBCheckBox;
    cdOrderFieldsDisplayFormat: TStringField;
    cdProcessFieldsDisplayFormat: TStringField;
    cbRepeat: TDBCheckBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    tsSort: TTabSheet;
    Label5: TLabel;
    DBEdit1: TDBEdit;
    Label1: TLabel;
    DBEdit2: TDBEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label12: TLabel;
    DBCheckBox1: TDBCheckBox;
    cbSumTotal: TDBCheckBox;
    cbSumByGroup: TDBCheckBox;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    DBLookupComboBox3: TDBLookupComboBox;
    Label13: TLabel;
    DBLookupComboBox4: TDBLookupComboBox;
    treeViewProcessFields: TDBVirtualStringTree;
    cdProcessFieldsC: TIntegerField;
    cdProcessFieldsParentID: TIntegerField;
    ImageList1: TImageList;
    tsStyle: TTabSheet;
    Bevel2: TBevel;
    Label15: TLabel;
    DBEdit3: TDBEdit;
    Label16: TLabel;
    cbFilterType: TJvDBComboBox;
    DBCheckBox2: TDBCheckBox;
    DBEdit4: TDBEdit;
    Label18: TLabel;
    Panel2: TPanel;
    Label14: TLabel;
    DBCheckBox5: TDBCheckBox;
    DBCheckBox6: TDBCheckBox;
    dbcbAlignHeaderCell: TJvDBComboBox;
    Label9: TLabel;
    Label10: TLabel;
    colorHeaderFont: TAnyColorCombo;
    colorHeaderBk: TAnyColorCombo;
    Label11: TLabel;
    Panel3: TPanel;
    Label6: TLabel;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    dbcbAlignCell: TJvDBComboBox;
    Label7: TLabel;
    Label8: TLabel;
    colorFont: TAnyColorCombo;
    colorBk: TAnyColorCombo;
    Label4: TLabel;
    DBCheckBox7: TDBCheckBox;
    procedure btAddClick(Sender: TObject);
    procedure btRemoveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbProcessDetailsClick(Sender: TObject);
    procedure dgProcessFieldsGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      State: TGridDrawState);
    procedure cbShowAllFieldsClick(Sender: TObject);
    procedure btMoveDownClick(Sender: TObject);
    procedure btMoveUpClick(Sender: TObject);
    procedure cdProcessFieldsCalcFields(DataSet: TDataSet);
    procedure treeViewProcessFieldsDBOnChangeCurrentRecord(
      Sender: TDBVirtualStringTree; RecordId: Integer);
    procedure treeViewProcessFieldsGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure treeViewProcessFieldsInitNode(Sender: TBaseVirtualTree;
      ParentNode, Node: PVirtualNode;
      var InitialStates: TVirtualNodeInitStates);
    procedure treeViewProcessFieldsDblClick(Sender: TObject);
  private
    hideNodes: TList;
    FReportData: TCustomReports;
    FColData: TCustomReportColumns;
    ColorMap: TStringList;
    FAfterScrollID: string;
    FShowAdded: Boolean;
    OrderNum: integer;
    FOrder: TOrder;
    //FCalcID: string;
    procedure CreateOrderFields;
    procedure CreateProcessFields(AllFields: boolean);
    procedure AddColor(box: TAnyColorCombo; Name: string; xlColor: integer; color:
        TColor);
    procedure AddOrderField(FieldName, Caption: string);
    procedure AddOrderFieldFormat(FieldName, Caption, DisplayFormat: string);
    procedure AddProcessField(ProcessID: integer; FieldName, Caption,
        DisplayFormat: string);
    procedure AddProcessName(ProcessID: integer; Name: string);
    procedure ColumnAfterScroll(Sender: TObject);
    function ConvertToExcelFormat(Fmt: string): string;
    procedure DisableFilter(DataSet: TClientDataSet);
    procedure EnableFilter(DataSet: TClientDataSet);
    procedure FillAlignList(box: TJvDBComboBox);
    procedure FillColorList(box: TAnyColorCombo);
    function GetOrderFieldCaption(FieldName: string): string;
    function GetProcessFieldCaption(ProcessID: integer; FieldName: string): string;
    function LocateOrderFieldInReport(FieldName: string): Boolean;
    function LocateProcessFieldInReport(ProcessID: integer; FieldName: string): Boolean;
    function TotalFields(Prc: TPolyProcessCfg): boolean;
    function GridFields(Prc: TPolyProcessCfg; Param: pointer): boolean;
    procedure AddInvoiceItemsFields;
    procedure AddInvoiceItemsField(const FieldName, DisplayFormat: string);
    function GetInvoiceItemsFieldCaption(const FieldName: string): string;
    procedure AddOrderPaymentsFields;
    procedure AddOrderPaymentsField(const FieldName, DisplayFormat: string);
    function GetOrderPaymentsFieldCaption(const FieldName: string): string;
    procedure AddShipmentFields;
    procedure AddOrderShipmentField(const FieldName, DisplayFormat: string);
    function GetOrderShipmentFieldCaption(const FieldName: string): string;
    function IsExcludedField(Field: TField; Process: TPolyProcess): Boolean;
    procedure PrepareColumns;
    procedure RefreshIndex(DataSet: TClientDataSet);
    procedure UpdateDetailControls;
    procedure UpdateReportControls;
    function GetColumnSourceName: string;
    procedure ShowNode(processID: integer; fieldName: string); overload;
    procedure ShowNode(node: PVirtualNode); overload;
    procedure HideNode(node: PVirtualNode);
    function GetNextNode(node: PVirtualNode) : PVirtualNode;
    procedure FixColumnOrder;
  public
    constructor Create(_ReportData: TCustomReports; _CurOrder: TOrder);
    procedure AddAllProcessFields(Prc: TPolyProcessCfg);
  end;

const
  FieldNameIndex = 1;

function ExecCustomReportDetailsEditor(ReportData: TCustomReports; _CurOrder: TOrder): boolean;

implementation

{$R *.dfm}

uses ExHandler, ServMod, RDBUtils, PmAppController, CalcUtils,
  PmCustomReportCommon, PmInvoiceItems, PmOrderInvoiceItems, PmOrderPayments,
  PmConfigManager, PmOrderProcessItems, PmMaterials, PmInvoice, PmShipment;

const
  InvoiceItemsName = '����-�������';
  OrderPaymentsName = '������';
  OrderShipmentName = '��������';

function ExecCustomReportDetailsEditor(ReportData: TCustomReports; _CurOrder: TOrder): boolean;
var
  CustomReportDetailsForm: TCustomReportDetailsForm;
begin
  CustomReportDetailsForm := TCustomReportDetailsForm.Create(ReportData, _CurOrder);
  try
    Result := CustomReportDetailsForm.ShowModal = mrOk;
  finally
    FreeAndNil(CustomReportDetailsForm);
  end;
end;

constructor TCustomReportDetailsForm.Create(_ReportData: TCustomReports; _CurOrder: TOrder);
begin
  inherited Create(nil);
  FReportData := _ReportData;
  FOrder := _CurOrder;
  FColData := TCustomReportColumns(_ReportData.Details);
  // ��������� ������� ��������� �������� ��������� ����
  FShowAdded := true;
  FixColumnOrder;
end;

procedure TCustomReportDetailsForm.AddColor(box: TAnyColorCombo; Name: string;
  xlColor: integer; color: TColor);
begin
  box.Items.AddObject(Name, TObject(color));
  ColorMap.AddObject(IntToStr(Ord(color)), TObject(xlColor));
end;

function GetDisplayFormat(Field: TField): string;
begin
  if Field is TNumericField then Result := (Field as TNumericField).DisplayFormat
  else if Field is TDateTimeField then Result := (Field as TDateTimeField).DisplayFormat
  else if Field is TAggregateField then Result := (Field as TAggregateField).DisplayFormat
  else Result := '';
end;

procedure TCustomReportDetailsForm.AddOrderField(FieldName, Caption: string);
var
  cdOrd: TDataSet;
begin
  cdOrd := AppController.WorkOrder.DataSet;
  AddOrderFieldFormat(FieldName, Caption, GetDisplayFormat(cdOrd.FieldByName(FieldName)));
end;

procedure TCustomReportDetailsForm.AddOrderFieldFormat(FieldName, Caption, DisplayFormat: string);
begin
  cdOrderFields.Append;
  cdOrderFields['OrderNum'] := OrderNum;
  cdOrderFields['FieldName'] := FieldName;
  cdOrderFields['Caption'] := Caption;
  cdOrderFields['DisplayFormat'] := DisplayFormat;
  // ������ �� ������, ������� ��������� ����� ���������
  cdOrderFields['IsAdded'] := LocateOrderFieldInReport(FieldName);
  Inc(OrderNum);
end;

procedure TCustomReportDetailsForm.AddProcessField(ProcessID: integer;
  FieldName, Caption, DisplayFormat: string);
begin
  cdProcessFields.Append;
  cdProcessFields['OrderNum'] := OrderNum;
  cdProcessFields['FieldName'] := FieldName;
  cdProcessFields['Caption'] := Caption;
  cdProcessFields['IsProcessName'] := false;
  cdProcessFields['ProcessID'] := ProcessID;
  cdProcessFields['ParentID'] := ProcessID;
  cdProcessFields['DisplayFormat'] := DisplayFormat;
  //cdProcessFields.Post;
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! �� ����������! ���� �����������
  //cdProcessFields.Edit;
  cdProcessFields['IsAdded'] := LocateProcessFieldInReport(ProcessID, FieldName);
  Inc(OrderNum);
end;

procedure TCustomReportDetailsForm.AddProcessName(ProcessID: integer; Name: string);
begin
  cdProcessFields.Append;
  cdProcessFields['OrderNum'] := OrderNum;
  cdProcessFields['FieldName'] := '';
  cdProcessFields['Caption'] := Name;
  cdProcessFields['IsProcessName'] := true;
  cdProcessFields['ProcessID'] := ProcessID;
  cdProcessFields['ParentID'] := 0;
  cdProcessFields['IsAdded'] := false;
  Inc(OrderNum);
end;

// ��������� ������ ����� ������, ������� ����� ���������� � �����
procedure TCustomReportDetailsForm.CreateOrderFields;
var
  cdOrd: TDataSet;
  DispFmt: string;
begin
  cdOrderFields.CreateDataSet;
  cdOrderFields.DisableControls;
  try
    cdOrd := AppController.WorkOrder.DataSet;
    OrderNum := 1;
    //AddOrderField('ID', '����');
    AddOrderFieldFormat(TOrder.F_OrderNumber, '�����', CalcUtils.OrderNumDisplayFmt);
    AddOrderField('Comment', '������������');
    AddOrderField('Comment2', '�����������');
    AddOrderField('Tirazz', '�����');
    AddOrderField('CustomerName', '��������');
    //AddOrderField('CustomerFullName', '������ ��� ���������'); �� ��������, �.�. ���� � ������ ������ ������ � ������ ���� ��?
    AddOrderField('CustomerPhone', '������� ���������');
    AddOrderField('CustomerFax', '���� ���������');
    AddOrderField('TotalGrn', '���������, ���.');
    AddOrderFieldFormat('ClientTotalGrn', '�������� ���������, ���.', GetDisplayFormat(cdOrd.FieldByName('TotalGrn')));
    //AddOrderFieldFormat('TotalGrn', '��������� ��� �������, ���.', GetDisplayFormat(cdOrd.FieldByName('TotalGrn')));
    AddOrderField('TotalCost', '��������� ��� ������� � ��������� ��.');
    AddOrderField('ClientTotal', '�������� ��������� � ��������� ��.');
    AddOrderField('ProfitPercent', '����� �������, %');
    AddOrderField(TOrder.F_Course, '���� ��������� ��.');
    AddOrderFieldFormat(TOrder.F_KindName, '��� ������', '');
    AddOrderField(TOrder.F_CreatorName, '���������');
    // TODO: �������� ����-����� ����� �����
    AddOrderField('CreationDate', '���� ��������');
    AddOrderField('CreationTime', '����� ��������');
    AddOrderField('ModifyDate', '���� ���������');
    AddOrderField('ModifyTime', '����� ���������');
    AddOrderField('CloseDate', '���� ��������');
    AddOrderField('CloseTime', '����� ��������');
    AddOrderField(TOrder.F_OrderState, '��������� ����������');
    AddOrderField(TOrder.F_PayState, '��������� ������');
    AddOrderFieldFormat('FinishDate', '�������� ���� ����������', 'dd/mm/yyyy h:mm');
    AddOrderFieldFormat('FactFinishDate', '����������� ���� ����������', 'dd/mm/yyyy h:mm');
    AddOrderFieldFormat('StartDate', '���� ������ �����', 'dd/mm/yyyy');
    AddOrderField('CostOf1', '��������� ���. � ��������� ��.');
    AddOrderFieldFormat('CostOf1Grn', '��������� ���., ���.', GetDisplayFormat(cdOrd.FieldByName('CostOf1')));
    DispFmt := GetDisplayFormat(cdOrd.FieldByName('TotalGrn'));
    AddOrderFieldFormat(TWorkOrder.F_TotalPayCost, '����� ����� �� ������, ���.', DispFmt);
    AddOrderFieldFormat(TWorkOrder.F_DebtCost, '���� �� ������ (��� ��������), ���.', DispFmt);
    AddOrderFieldFormat(TWorkOrder.F_AllDebtCost, '���� �� ������, ���.', DispFmt);
    AddOrderFieldFormat(TWorkOrder.F_TotalInvoiceCost, '����� ������������ ������ �� ������, ���.', DispFmt);
    AddOrderFieldFormat(TOrder.F_TotalExpenseCost, '����� ������ �� ������, ���.', DispFmt);
    AddOrderFieldFormat(TOrder.F_TotalOrderProfitCost, '������� �� ������, ���.', DispFmt);
    AddOrderField('ProductFormat', '������ ���������');
    AddOrderField('ProductPages', '���-�� �������');
    AddOrderField('IncludeCover', '������� �������');
    AddOrderField('IsComposite', '��������� �����');
    AddOrderField('CallCustomer', '������� ���������');
    AddOrderField('CallCustomerPhone', '���. ��� ������ ���������');
    AddOrderField('HaveLayout', '���� �����');
    AddOrderField('HavePattern', '���� �������');
    AddOrderField('HaveProof', '���� ����������');
    AddOrderField('SignProof', '����� ������� ������');
    AddOrderField('SignManager', '��������� ����� � ���������');
    AddOrderField(TWorkOrder.F_ExternalId, '������� �');
    //AddOrderField(F_TotalDebtCost, '����� ������������� �� ������', GetDisplayFormat(cdOrd.FieldByName('TotalGrn')));
    EnableFilter(cdOrderFields);
    //cdOrderFields.First;
  finally
    cdOrderFields.EnableControls;
  end;
  cdOrderFields.IndexFieldNames := 'OrderNum';
end;

procedure TCustomReportDetailsForm.AddAllProcessFields(Prc: TPolyProcessCfg);
var
  Fields: TFields;
  i: Integer;
  DataPrc: TPolyProcess;
begin
  // TODO: ������ �� ����������� ��� ��� ����� ����� � ���� �������� !!!!!!!!!!!
  // �� ������ ������. ���� ������� ��������� ������, ����������� ����, � TPolyProcessCfg.
  DataPrc := FOrder.Processes.ServiceByID(Prc.SrvID, false);
  Fields := DataPrc.DataSet.Fields;
  for I := 0 to Fields.Count - 1 do
    if not IsExcludedField(Fields[i], DataPrc) then
      AddProcessField(Prc.SrvID, Fields[i].FieldName, Fields[i].DisplayName,
        GetDisplayFormat(Fields[i]));
end;

function TCustomReportDetailsForm.GridFields(Prc: TPolyProcessCfg; Param: pointer): boolean;
var
  I: Integer;
  c: Integer;
  GridList, GridCols: TCollection;
  GridCol: TGridCol;
  AllFields: boolean;
  DataPrc: TPolyProcess;
begin
  AllFields := boolean(Param^);
  AddProcessName(Prc.SrvID, Prc.ServiceName);
  DataPrc := FOrder.Processes.ServiceByID(Prc.SrvID, false);
  if not AllFields then
  begin
    GridList := Prc.Grids;
    if GridList.Count > 0 then begin
      for I := 0 to GridList.Count - 1 do
      begin
        GridCols := (GridList.Items[i] as TProcessGridCfg).GridCols;
        if (GridCols <> nil) and (GridCols.Count > 0) then
        begin
          for c := 0 to GridCols.Count - 1 do
          begin
            GridCol := (GridCols.Items[c] as TGridCol);
            if not IsExcludedField(DataPrc.DataSet.FieldByName(GridCol.FieldName), DataPrc) then
              AddProcessField(Prc.SrvID, GridCol.FieldName, GridCol.Caption,
                GetDisplayFormat(DataPrc.DataSet.FieldByName(GridCol.FieldName)));
          end;
        end
        else
          AddAllProcessFields(Prc);
      end;
    end
    else
      AddAllProcessFields(Prc);
  end
  else
    AddAllProcessFields(Prc);

  if (Prc.TableName <> ClientPriceTableName) and (Prc.TableName <> ShipmentTableName) then
  begin
    // ����, ������� ��� � ������� ��������
    AddProcessField(Prc.SrvID, TOrderProcessItems.F_ItemDesc, '��������', '');
    AddProcessField(Prc.SrvID, TOrderProcessItems.F_EquipName, '������������', '');
    AddProcessField(Prc.SrvID, F_PartName, '�����', '');
    AddProcessField(Prc.SrvID, TOrderProcessItems.F_Cost, '��������� ��������� ��� ���������', CalcUtils.NumDisplayFmt);
    AddProcessField(Prc.SrvID, TOrderProcessItems.F_MatCost, '��������� ��������� ����������, ���.', CalcUtils.NumDisplayFmt);
    AddProcessField(Prc.SrvID, TOrderProcessItems.F_EnabledWorkCost, '��������� ��������� ������', CalcUtils.NumDisplayFmt);
    AddProcessField(Prc.SrvID, TOrderProcessItems.F_ContractorCost, '��������� ��������� ����������', CalcUtils.NumDisplayFmt);
    AddProcessField(Prc.SrvID, TOrderProcessItems.F_FactContractorCost, '����������� ��������� ����������', CalcUtils.NumDisplayFmt);
    AddProcessField(Prc.SrvID, F_ContractorName, '������������', '');
    AddProcessField(Prc.SrvID, TOrderProcessItems.F_OwnCost, '��������� ��������� ������ ��������', CalcUtils.NumDisplayFmt);
    AddProcessField(Prc.SrvID, TOrderProcessItems.F_ItemProfit, '�������, ���.', CalcUtils.NumDisplayFmt);
    AddProcessField(Prc.SrvID, TOrderProcessItems.F_EstimatedDuration, '��������� �����, ���', '');
    AddProcessField(Prc.SrvID, TOrderProcessItems.F_PlanDuration, '�������� �����, ���', '');
    AddProcessField(Prc.SrvID, TOrderProcessItems.F_FactDuration, '����������� �����, ���', '');
    AddProcessField(Prc.SrvID, TOrderProcessItems.F_FactProductOut, '����������� ���������� �� ������', '');
    // ���������
    AddProcessField(Prc.SrvID, TMaterials.F_SupplierName, '���������', '');
    AddProcessField(Prc.SrvID, TMaterials.F_FactMatAmount, '����������� ���-�� ���������', '');
    AddProcessField(Prc.SrvID, TMaterials.F_FactMatCost, '����������� ��������� ���������, ���.', '');
    AddProcessField(Prc.SrvID, TMaterials.F_PlanReceiveDate, '�������� ���� �������� ���������', '');
    AddProcessField(Prc.SrvID, TMaterials.F_FactReceiveDate, '����������� ���� �������� ���������', '');
  end;

  Result := true;
end;

function TCustomReportDetailsForm.TotalFields(Prc: TPolyProcessCfg): boolean;
begin
  AddProcessName(Prc.SrvID, Prc.ServiceName);
  AddProcessField(Prc.SrvID, TOrderProcessItems.F_Cost, '��������� ��������� ��� ���������', CalcUtils.NumDisplayFmt);
  AddProcessField(Prc.SrvID, TOrderProcessItems.F_EnabledWorkCost, '��������� ��������� ������', CalcUtils.NumDisplayFmt);
  AddProcessField(Prc.SrvID, TOrderProcessItems.F_MatCost, '��������� ��������� ����������, ���.', CalcUtils.NumDisplayFmt);
  AddProcessField(Prc.SrvID, TOrderProcessItems.F_ContractorCost, '��������� ��������� ����������', CalcUtils.NumDisplayFmt);
  AddProcessField(Prc.SrvID, TOrderProcessItems.F_FactContractorCost, '����������� ��������� ����������, ���.', CalcUtils.NumDisplayFmt);
  AddProcessField(Prc.SrvID, TOrderProcessItems.F_OwnCost, '��������� ��������� ������ ��������', CalcUtils.NumDisplayFmt);
  AddProcessField(Prc.SrvID, TOrderProcessItems.F_ItemProfit, '�������, ���.', CalcUtils.NumDisplayFmt);
  Result := true;
end;

procedure TCustomReportDetailsForm.AddInvoiceItemsField(const FieldName, DisplayFormat: string);
begin
  AddProcessField(OrderDetails_InvoiceItems, FieldName,
    GetInvoiceItemsFieldCaption(FieldName), DisplayFormat);
end;

function TCustomReportDetailsForm.GetInvoiceItemsFieldCaption(const FieldName: string): string;
begin
  if FieldName = TInvoices.F_InvoiceNum then
    Result := '����� �����'
  else if FieldName = TInvoices.F_InvoiceDate then
    Result := '���� �����'
  else if FieldName = TOrderInvoiceItems.F_ContragentName then
    Result := '��������'
  else if FieldName = TOrderInvoiceItems.F_ContragentFullName then
    Result := '������ ������������ ���������'
  else if FieldName = TOrderInvoiceItems.F_PayTypeName then
    Result := '��� ������'
  else if FieldName = TInvoiceItems.F_ItemText then
    Result := '������������'
  else if FieldName = TInvoiceItems.F_Price then
    Result := '����'
  else if FieldName = TInvoiceItems.F_Quantity then
    Result := '����������'
  else if FieldName = TInvoiceItems.F_ItemCost then
    Result := '���������'
  else if FieldName = TInvoiceItems.F_PayCost then
    Result := '����� ����� �� ������'
  else if FieldName = TInvoiceItems.F_InvoicePayCost then
    Result := '����� ����� �� �����'
  else if FieldName = TInvoiceItems.F_ItemDebt then
    Result := '����� �����'
  else
    ExceptionHandler.Raise_(Exception.Create('�� ���� ���������� �������� ��� ���� ����� ' + FieldName));
end;

procedure TCustomReportDetailsForm.AddInvoiceItemsFields;
begin
  AddProcessName(OrderDetails_InvoiceItems, InvoiceItemsName);
  AddInvoiceItemsField(TInvoices.F_InvoiceNum, '');
  AddInvoiceItemsField(TInvoices.F_InvoiceDate, ExcelDateFormat);
  AddInvoiceItemsField(TOrderInvoiceItems.F_PayTypeName, '');
  AddInvoiceItemsField(TOrderInvoiceItems.F_ContragentName, '');
  AddInvoiceItemsField(TOrderInvoiceItems.F_ContragentFullName, '');
  AddInvoiceItemsField(TInvoiceItems.F_ItemText, '');
  AddInvoiceItemsField(TInvoiceItems.F_Price, CalcUtils.NumDisplayFmt4);
  AddInvoiceItemsField(TInvoiceItems.F_Quantity, '');
  AddInvoiceItemsField(TInvoiceItems.F_ItemCost, CalcUtils.NumDisplayFmt);
  AddInvoiceItemsField(TInvoiceItems.F_PayCost, CalcUtils.NumDisplayFmt);
  AddInvoiceItemsField(TInvoiceItems.F_InvoicePayCost, CalcUtils.NumDisplayFmt);
  AddInvoiceItemsField(TInvoiceItems.F_ItemDebt, CalcUtils.NumDisplayFmt);
end;

function TCustomReportDetailsForm.GetOrderPaymentsFieldCaption(const FieldName: string): string;
begin
  if FieldName = TOrderPayments.F_InvoiceNum then
    Result := '����� �����'
  else if FieldName = TOrderPayments.F_PayDate then
    Result := '���� ������'
  else if FieldName = TOrderPayments.F_ContragentName then
    Result := '��������'
  else if FieldName = TOrderPayments.F_PayTypeName then
    Result := '��� ������'
  else if FieldName = TOrderPayments.F_PayCost then
    Result := '�����, ���.'
  else if FieldName = TOrderPayments.F_GetterName then
    Result := '������'
  else
    ExceptionHandler.Raise_(Exception.Create('�� ���� ���������� �������� ��� ���� ����� ' + FieldName));
end;

procedure TCustomReportDetailsForm.AddOrderPaymentsField(const FieldName, DisplayFormat: string);
begin
  AddProcessField(OrderDetails_Payments, FieldName,
    GetOrderPaymentsFieldCaption(FieldName), DisplayFormat);
end;

procedure TCustomReportDetailsForm.AddOrderPaymentsFields;
begin
  AddProcessName(OrderDetails_Payments, OrderPaymentsName);
  AddOrderPaymentsField(TOrderPayments.F_PayTypeName, '');
  AddOrderPaymentsField(TOrderPayments.F_PayCost, CalcUtils.NumDisplayFmt);
  AddOrderPaymentsField(TOrderPayments.F_PayDate, 'dd/mm/yyyy h:mm');
  AddOrderPaymentsField(TOrderPayments.F_ContragentName, '');
  AddOrderPaymentsField(TOrderPayments.F_GetterName, '');
  AddOrderPaymentsField(TOrderPayments.F_InvoiceNum, '');
end;

procedure TCustomReportDetailsForm.AddShipmentFields;
begin
  AddProcessName(OrderDetails_Shipment, OrderShipmentName);
  AddOrderShipmentField(TShipment.F_NumberToShip, '');
  AddOrderShipmentField(TShipment.F_ShipmentDate, '');
  AddOrderShipmentField(TShipment.F_ShipmentDocNum, '');
  AddOrderShipmentField(TShipment.F_WhoIn, '');
  AddOrderShipmentField(TShipment.F_WhoOut, '');
  AddOrderShipmentField(TShipment.F_Comment, '');
end;

procedure TCustomReportDetailsForm.AddOrderShipmentField(const FieldName, DisplayFormat: string);
begin
  AddProcessField(OrderDetails_Shipment, FieldName,
    GetOrderShipmentFieldCaption(FieldName), DisplayFormat);
end;

function TCustomReportDetailsForm.GetOrderShipmentFieldCaption(const FieldName: string): string;
begin
  if FieldName = TShipment.F_NumberToShip then
    Result := '���������'
  else if FieldName = TShipment.F_ShipmentDate then
    Result := '���� ��������'
  else if FieldName = TShipment.F_ShipmentDocNum then
    Result := '����� ���������'
  else if FieldName = TShipment.F_WhoIn then
    Result := '������'
  else if FieldName = TShipment.F_WhoOut then
    Result := '�����'
  else if FieldName = TShipment.F_Comment then
    Result := '����������'
  else
    ExceptionHandler.Raise_(Exception.Create('�� ���� ���������� �������� ��� ���� �������� ' + FieldName));
end;

// ��������� ������ ����� ���������, ������� ����� ���������� � �����
procedure TCustomReportDetailsForm.CreateProcessFields(AllFields: boolean);
var
  I: Integer;
begin
  if cdProcessFields.Active then cdProcessFields.Close;
  cdProcessFields.CreateDataSet;
  cdProcessFields.DisableControls;
  DisableFilter(cdProcessFields);
  try
    OrderNum := 1;
    // ���� �������� �����������, �� ��������� ��� ����, ����� ������ ��������
    if cbProcessDetails.Checked then
    begin
      TConfigManager.Instance.ForEachProcess(GridFields, @AllFields);
      AddInvoiceItemsFields;
      AddOrderPaymentsFields;
      AddShipmentFields;
    end
    else
      TConfigManager.Instance.ForEachProcess(TotalFields);
  finally
    cdProcessFields.EnableControls;
    EnableFilter(cdProcessFields);
  end;
  cdProcessFields.IndexFieldNames := 'OrderNum';

//  try
    hideNodes.Clear;
    treeViewProcessFields.LoadTree;
//  except end;
end;

procedure TCustomReportDetailsForm.btAddClick(Sender: TObject);
var
  node: PVirtualNode;
  nodeData: PNodeData;
  fieldName: string;
begin
  FColData.DataSet.DisableControls;
  try
    if (pcSourceFields.ActivePage = tsOrderFields) then
    begin
      if cdOrderFields.IsEmpty then Exit;
      FColData.DataSet.Append;
      FColData.DataSet['FieldSourceType'] := fstOrder;
      FColData.DataSet['FieldName'] := cdOrderFields['FieldName'];
      FColData.DataSet['Caption'] := cdOrderFields['Caption'];
      FColData.DataSet['DisplayFormat'] := ConvertToExcelFormat(NvlString(cdOrderFields['DisplayFormat']));
      cdOrderFields.Edit;
      cdOrderFields['IsAdded'] := true;
      cdOrderFields.Post;
    end
    else
    if not cdProcessFields['IsProcessName'] and not cdProcessFields.IsEmpty then
    begin
      node := treeViewProcessFields.FocusedNode;
      if node <> nil then
      begin
        nodeData := treeViewProcessFields.GetNodeData(node);
        fieldName := nodeData.FieldValues[FieldNameIndex];

        if (fieldName <> '') then
        begin
          FColData.DataSet.Append;
          FColData.DataSet['FieldSourceType'] := fstProcess;
          FColData.DataSet['FieldName'] := cdProcessFields['FieldName'];
          FColData.DataSet['Caption'] := cdProcessFields['Caption'];
          FColData.DataSet['DisplayFormat'] := ConvertToExcelFormat(NvlString(cdProcessFields['DisplayFormat']));
          FColData.DataSet['ProcessID'] := cdProcessFields['ProcessID'];
          cdProcessFields.Edit;
          cdProcessFields['IsAdded'] := true;
          cdProcessFields.Post;

          HideNode(treeViewProcessFields.FocusedNode);
        end;
      end;
    end
    else
      Exit;

    if (FColData.DataSet.State = dsEdit) or (FColData.DataSet.State = dsInsert) then
    begin
      FColData.DataSet['SourceName'] := GetColumnSourceName;
      FColData.DataSet['FontBold'] := false;
      FColData.DataSet['FontItalic'] := false;
      FColData.DataSet['Alignment'] := xlHAlignGeneral;
      FColData.DataSet['FontColor'] := xlColorIndexAutomatic;
      FColData.DataSet['BkColor'] := xlColorIndexAutomatic;
      FColData.DataSet['CaptionFontBold'] := true;
      FColData.DataSet['CaptionFontItalic'] := false;
      FColData.DataSet['CaptionFontColor'] := xlColorIndexAutomatic;
      FColData.DataSet['CaptionBkColor'] := xlColorIndexAutomatic;
      FColData.DataSet['CaptionAlignment'] := xlHAlignGeneral;
      FColData.DataSet.Post; // ����� �� ������ �� ������ ������� � ����� ������ ����� ����������
    end;
    FixColumnOrder;
  finally
    FColData.DataSet.EnableControls;
    UpdateDetailControls;
  end;
end;

procedure TCustomReportDetailsForm.FillAlignList(box: TJvDBComboBox);
begin
  box.Items.Clear;
  box.Items.Add('�� ��������');
  box.Items.Add('�����');
  box.Items.Add('������');
  box.Items.Add('�� ������');
  box.Items.Add('������ ������ �������');
  box.Values.Clear;
  box.Values.Add(IntToStr(xlHAlignGeneral));
  box.Values.Add(IntToStr(xlHAlignLeft));
  box.Values.Add(IntToStr(xlHAlignRight));
  box.Values.Add(IntToStr(xlHAlignCenter));
  box.Values.Add(IntToStr(xlHAlignJustify));
end;

procedure TCustomReportDetailsForm.FillColorList(box: TAnyColorCombo);
begin
  box.Items.Clear;
  AddColor(box, '����', xlColorIndexAutomatic, RGB(255, 255, 255));
  AddColor(box, '�����������', xlColorIndexNone, RGB(255, 255, 255));
  AddColor(box, '������', xlColor1, RGB(0, 0, 0));
  AddColor(box, '����������', xlColor53, RGB(153, 51, 0));
  AddColor(box, '���������', xlColor52, RGB(51, 51, 0));
  AddColor(box, '�����-�������', xlColor51, RGB(0, 51, 0));
  AddColor(box, '�����-�����', xlColor49, RGB(0, 51, 102));
  AddColor(box, '�����-�����', xlColor11, RGB(0, 0, 128));
  AddColor(box, '������', xlColor55, RGB(51, 51, 153));
  AddColor(box, '����� 80%', xlColor56, RGB(51, 51, 51));
  AddColor(box, '�����-�������', xlColor9, RGB(128, 0, 0));
  AddColor(box, '���������', xlColor46, RGB(255, 102, 0));
  AddColor(box, '���������-�������', xlColor52, RGB(128, 128, 0));
  // TODO: ��������� �����!!!!!!!!!!!!!!!!!!!
end;

function TCustomReportDetailsForm.LocateOrderFieldInReport(FieldName: string): Boolean;
begin
  Result := FColData.DataSet.Locate('FieldSourceType;FieldName',
    VarArrayOf([fstOrder, FieldName]), []);
end;

function TCustomReportDetailsForm.LocateProcessFieldInReport(ProcessID: integer;
    FieldName: string): Boolean;
begin
  Result := FColData.DataSet.Locate('FieldSourceType;FieldName;ProcessID',
    VarArrayOf([fstProcess, FieldName, ProcessID]), []);
end;

procedure TCustomReportDetailsForm.btRemoveClick(Sender: TObject);
var
  SrcType, OrderNum: integer;
begin
  if VarType(FColData.DataSet['FieldSourceType']) <> varNull then
  begin
    SrcType := FColData.DataSet['FieldSourceType'];
    if SrcType = fstOrder then
    begin
      OrderNum := NvlInteger(cdOrderFields['OrderNum']);
      cdOrderFields.DisableControls;
      DisableFilter(cdOrderFields);
      try
        if cdOrderFields.Locate('FieldName', FColData.DataSet['FieldName'], []) then
        begin
          cdOrderFields.Edit;
          cdOrderFields['IsAdded'] := false;
        end;
      finally
        EnableFilter(cdOrderFields);
        cdOrderFields.Locate('OrderNum', OrderNum, []);
        cdOrderFields.EnableControls;
      end;
    end
    else
    begin
      OrderNum := NvlInteger(cdProcessFields['OrderNum']);
      cdProcessFields.DisableControls;
      DisableFilter(cdProcessFields);
      try
        if cdProcessFields.Locate('ProcessID;FieldName',
            VarArrayOf([FColData.DataSet['ProcessID'], FColData.DataSet['FieldName']]), []) then begin
          cdProcessFields.Edit;
          cdProcessFields['IsAdded'] := false;
          ShowNode(cdProcessFields.FieldByName('ProcessID').Value,
                   cdProcessFields.FieldByName('FieldName').Value);
        end;
      finally
        EnableFilter(cdProcessFields);
        cdProcessFields.Locate('OrderNum', OrderNum, []);
        cdProcessFields.EnableControls;
      end;
    end;
    FColData.DataSet.Delete;
    FixColumnOrder;
  end;
end;

// ������������� ��������
procedure TCustomReportDetailsForm.FixColumnOrder;
var
  CurKey: variant;
  RecNo: integer;
begin
  CurKey := FColData.KeyValue;
  if not VarIsNull(CurKey) then
  try
    RecNo := 1;
    FColData.DataSet.DisableControls;
    FColData.DataSet.First;
    while not FColData.DataSet.Eof do
    begin
      if FColData.OrderNum <> RecNo then
      begin
        FColData.OrderNum := RecNo;
        FColData.DataSet.Post;
      end;
      FColData.DataSet.Next;
      Inc(RecNo);
    end;
  finally
    FColData.Locate(CurKey);
    FColData.DataSet.EnableControls;
  end;
end;

procedure TCustomReportDetailsForm.FormCreate(Sender: TObject);
begin
  dgProcessFields.Visible := false;
  treeViewProcessFields.Align := alClient;

  hideNodes := TList.Create();

  treeViewProcessFields.DBOptions.HasChildField := 'C';
  treeViewProcessFields.DBOptions.IDField := 'ProcessID';
  treeViewProcessFields.DBOptions.IDParentParam := 'ParentID';

  treeViewProcessFields.DBOptions.LookFields.Clear();
  treeViewProcessFields.DBOptions.LookFields.Add('Caption');
  treeViewProcessFields.DBOptions.LookFields.Add('FieldName');
  treeViewProcessFields.DBOptions.LookFields.Add('ProcessID');

  dsReportCols.DataSet := FColData.DataSet;
  dsReport.DataSet := FReportData.DataSet;
  CreateOrderFields;
  CreateProcessFields(true);  // ������� ������� ������ ��� ���� �����
  PrepareColumns;
  CreateProcessFields(false); // ������ ������ ��� ���, ������� ���� � ������
  // ����� ������ �� ����� �������. ����� �������� ������ ����������.

  ColorMap := TStringList.Create;
  ColorMap.Sorted := true;
  FillAlignList(dbcbAlignCell);
  FillAlignList(dbcbAlignHeaderCell);
  FillColorList(colorFont);
  FillColorList(colorBk);
  FillColorList(colorHeaderFont);
  FillColorList(colorHeaderBk);
  FAfterScrollID := FColData.AfterScrollNotifier.RegisterHandler(ColumnAfterScroll);
  RefreshIndex(FColData.DataSet as TClientDataSet);
  dsReportCols.DataSet := FColData.DataSet;
  UpdateReportControls;
end;

procedure TCustomReportDetailsForm.FormDestroy(Sender: TObject);
begin
  //FColData.OnCalcFieldsNotifier.UnRegisterHandler(FCalcID);
  FColData.AfterScrollNotifier.UnRegisterHandler(FAfterScrollID);

  hideNodes.Clear();
  hideNodes.Free;
end;

function TCustomReportDetailsForm.GetOrderFieldCaption(FieldName: string): string;
var
  Key: integer;
begin
  cdOrderFields.DisableControls;
  try
    if cdOrderFields.IsEmpty then Key := 0
    else Key := cdOrderFields['OrderNum'];
    DisableFilter(cdOrderFields);
    if cdOrderFields.Locate('FieldName', FieldName, [loCaseInsensitive]) then
      Result := cdOrderFields['Caption']
    else
      Result := '?';
    EnableFilter(cdOrderFields);
    if Key <> 0 then cdOrderFields.Locate('OrderNum', Key, []);
  finally
    EnableFilter(cdOrderFields);
    cdOrderFields.EnableControls;
  end;
end;

function TCustomReportDetailsForm.GetProcessFieldCaption(ProcessID: integer;
    FieldName: string): string;
var
  Key: integer;
begin
  cdProcessFields.DisableControls;
  try
    if cdProcessFields.IsEmpty then Key := 0
    else Key := cdProcessFields['OrderNum'];
    DisableFilter(cdProcessFields);
    if cdProcessFields.Locate('ProcessID;FieldName', VarArrayOf([ProcessID, FieldName]), [loCaseInsensitive]) then
      Result := cdProcessFields['Caption']
    else
      Result := '?';
    EnableFilter(cdProcessFields);
    cdProcessFields.Locate('OrderNum', Key, []);
  finally
    EnableFilter(cdProcessFields);
    cdProcessFields.EnableControls;
  end;
end;

procedure TCustomReportDetailsForm.cbProcessDetailsClick(Sender: TObject);
begin
  CreateProcessFields(cbShowAllFields.Checked);
  UpdateReportControls;
end;

procedure TCustomReportDetailsForm.dgProcessFieldsGetCellParams(
  Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if NvlBoolean(cdProcessFields['IsProcessName']) then begin
    AFont.Style := [fsBold];
    Background := clYellow;
  end;
end;

procedure TCustomReportDetailsForm.cbShowAllFieldsClick(Sender: TObject);
begin
  CreateProcessFields(cbShowAllFields.Checked);
end;

procedure TCustomReportDetailsForm.btMoveDownClick(Sender: TObject);
var
  OrderNum{, NextOrderNum, ProcessID, NextProcessID}: integer;
  //FieldName, NextFieldName: string;
  //Located: boolean;
  NextColID, CurColID: variant;
begin
  if FColData.DataSet.RecNo < FColData.DataSet.RecordCount then
  begin
    OrderNum := FColData.DataSet['OrderNum'];
    CurColID := FColData.KeyValue;
    //FieldName := FColData.DataSet['FieldName'];
    //ProcessID := NvlInteger(FColData.DataSet['ProcessID']);

    FColData.DataSet.Next;
    NextColID := FColData.KeyValue;
    //NextOrderNum := FColData.DataSet['OrderNum'];
    //NextFieldName := FColData.DataSet['FieldName'];
    //NextProcessID := NvlInteger(FColData.DataSet['ProcessID']);
    FColData.DataSet.Prior;

    FColData.DataSet.Edit;
    FColData.DataSet['OrderNum'] := OrderNum + 1;

    {if NextProcessID > 0 then
      Located := FColData.DataSet.Locate('OrderNum;FieldName;ProcessID', VarArrayOf([NextOrderNum, NextFieldName, NextProcessID]), [])
    else
      Located := FColData.DataSet.Locate('OrderNum;FieldName;FieldSourceType', VarArrayOf([NextOrderNum, NextFieldName, fstOrder]), []);
    if not Located then
      raise Exception.Create('�� ������� ��������� ������');}
    if FColData.Locate(NextColID) then
    begin
      FColData.DataSet.Edit;
      FColData.DataSet['OrderNum'] := OrderNum;
      FColData.DataSet.Post;
    end
    else
      raise Exception.Create('�� ������� ��������� ������');

    {if ProcessID > 0 then
      Located := FColData.DataSet.Locate('OrderNum;FieldName;ProcessID', VarArrayOf([OrderNum + 1, FieldName, ProcessID]), [])
    else
      Located := FColData.DataSet.Locate('OrderNum;FieldName;FieldSourceType', VarArrayOf([OrderNum + 1, FieldName, fstOrder]), []);
    if not Located then
      raise Exception.Create('�� ������� ������������ ������');}

    FColData.Locate(CurColID);

    RefreshIndex(FColData.DataSet as TClientDataSet);
    FixColumnOrder;
  end;
end;

procedure TCustomReportDetailsForm.RefreshIndex(DataSet: TClientDataSet);
var
  //OldIndex: string;
  OrderNum: integer;
begin
  DataSet.DisableControls;
  try
    //OldIndex := DataSet.IndexName;
    OrderNum := NvlInteger(DataSet['OrderNum']);
    //DataSet.IndexName := '';
    //DataSet.IndexName := OldIndex;
    DataSet.Filtered := false;
    DataSet.Filtered := true;
    DataSet.Locate('OrderNum', OrderNum, []);
  finally
    DataSet.EnableControls;
  end;
end;

procedure TCustomReportDetailsForm.btMoveUpClick(Sender: TObject);
var
  OrderNum{, PrevOrderNum, ProcessID, PrevProcessID}: integer;
  //FieldName, PrevFieldName: string;
  //Located: boolean;
  PrevColID, CurColID: variant;
begin
  if FColData.DataSet.RecNo > 1 then
  begin
    OrderNum := FColData.DataSet['OrderNum'];
    CurColID := FColData.KeyValue;
    //FieldName := FColData.DataSet['FieldName'];
    //ProcessID := NvlInteger(FColData.DataSet['ProcessID']);

    FColData.DataSet.Prior;
    //PrevOrderNum := FColData.DataSet['OrderNum'];
    //PrevFieldName := FColData.DataSet['FieldName'];
    //PrevProcessID := NvlInteger(FColData.DataSet['ProcessID']);
    PrevColID := FColData.KeyValue;
    FColData.DataSet.Next;

    FColData.DataSet.Edit;
    FColData.DataSet['OrderNum'] := OrderNum - 1;

    {if PrevProcessID > 0 then
      Located := FColData.DataSet.Locate('OrderNum;FieldName;ProcessID', VarArrayOf([PrevOrderNum, PrevFieldName, PrevProcessID]), [])
    else
      Located := FColData.DataSet.Locate('OrderNum;FieldName;FieldSourceType', VarArrayOf([PrevOrderNum, PrevFieldName, fstOrder]), []);
    if not Located then
      raise Exception.Create('�� ������� ���������� ������');}
    if FColData.Locate(PrevColID) then
    begin
      FColData.DataSet.Edit;
      FColData.DataSet['OrderNum'] := OrderNum;
      FColData.DataSet.Post;
    end else
      raise Exception.Create('�� ������� ���������� ������');

    FColData.Locate(CurColID);
    {if ProcessID > 0 then
      Located := FColData.DataSet.Locate('OrderNum;FieldName;ProcessID', VarArrayOf([OrderNum - 1, FieldName, ProcessID]), [])
    else
      Located := FColData.DataSet.Locate('OrderNum;FieldName;FieldSourceType', VarArrayOf([OrderNum - 1, FieldName, fstOrder]), []);
    if not Located then
      raise Exception.Create('�� ������� ������������ ������');}

    RefreshIndex(FColData.DataSet as TClientDataSet);
    FixColumnOrder;
  end;
end;

// TODO: ������ ���� Excel!
function TCustomReportDetailsForm.ConvertToExcelFormat(Fmt: string): string;
begin
  if Pos('#', Fmt) <> 0 then Result := ExcelMoneyFormat
  else if Pos('dd', Fmt) <> 0 then Result := ExcelDateFormat//'��.��.��'
  else if Pos('h:', Fmt) <> 0 then Result := ExcelTimeFormat//'��:��'
  else Result := Fmt;
end;

function TCustomReportDetailsForm.IsExcludedField(Field: TField; Process: TPolyProcess): Boolean;
var
  FieldData: TDataSet;
begin
  Result := (Field.FieldName = 'Enabled')
    or (Field.FieldName = F_ProcessKey) or (Field.FieldName = F_ProcessKey)
    or (Field.FieldName = F_ItemID) or (Field.Tag = ftVirtual);
  // � ������������ ����������� ��������
  if not Result and (Field.FieldKind = fkCalculated) then
  begin
    FieldData := Process.ProcessCfg.GetFieldInfo(Field.FieldName);
    if FieldData = nil then
      raise Exception.Create('���� ' + Field.FieldName + ' �� �������');
    Result := VarIsNull(FieldData['LookupDicID']) or VarIsNull(FieldData['LookupKeyField']);
  end;
end;

procedure TCustomReportDetailsForm.UpdateDetailControls;
var e: boolean;
begin
  {e := not FColData.DataSet.IsEmpty and FReportData.ProcessDetails
    and (FColData.DataSet['FieldSourceType'] = fstProcess);}
  e := not FColData.DataSet.IsEmpty;
  cbSumTotal.Enabled := e;
  cbSumByGroup.Enabled := e and FReportData.ProcessDetails
    and (FColData.DataSet['FieldSourceType'] = fstProcess);
end;

procedure TCustomReportDetailsForm.ColumnAfterScroll(Sender: TObject);
begin
  UpdateDetailControls;
end;

// ��������� ������������ ���� ��������� �� ���� �������� ������
procedure TCustomReportDetailsForm.PrepareColumns;
var
  SaveFiltered: boolean;
  //SaveFilter: string;
begin
  FColData.DataSet.DisableControls;
  cdProcessFields.DisableControls;
  SaveFiltered := cdProcessFields.Filtered;
  //SaveFilter := cdProcessFields.Filter;
  cdProcessFields.Filtered := false;
  try
    FColData.DataSet.First;
    while not FColData.DataSet.eof do
    begin
      FColData.SourceName := GetColumnSourceName;
      FColData.DataSet.Next;
    end;
  finally
    FColData.DataSet.EnableControls;
    //cdProcessFields.Filter := SaveFilter;
    cdProcessFields.Filtered := SaveFiltered;
  end;
end;

// ��������� ������������ ���� ���������
function TCustomReportDetailsForm.GetColumnSourceName: string;
var
  sn: string;
  DataSet: TDataSet;
begin
  DataSet := FColData.DataSet;
  if VarIsNull(DataSet['FieldSourceType']) then
    sn := ''
  else if DataSet['FieldSourceType'] = fstOrder then
    sn := '�����: ' + GetOrderFieldCaption(NvlString(DataSet['FieldName']))
  else if not VarIsNull(DataSet['ProcessID']) then
  begin
    if DataSet['ProcessID'] >= 0 then
      sn := TConfigManager.Instance.ServiceByID(DataSet['ProcessID']).ServiceName + ' : '
        + GetProcessFieldCaption(DataSet['ProcessID'], NvlString(DataSet['FieldName']))
    else if DataSet['ProcessID'] = OrderDetails_InvoiceItems then
      sn := InvoiceItemsName + ' : ' + GetInvoiceItemsFieldCaption(DataSet['FieldName'])
    else if DataSet['ProcessID'] = OrderDetails_Payments then
      sn := OrderPaymentsName + ' : ' + GetOrderPaymentsFieldCaption(DataSet['FieldName'])
    else if DataSet['ProcessID'] = OrderDetails_Shipment then
      sn := OrderShipmentName + ' : ' + GetOrderShipmentFieldCaption(DataSet['FieldName'])
    else
      ExceptionHandler.Raise_(Exception.Create('����������� ��� �������� ' + VarToStr(DataSet['ProcessID'])));
  end
  else
    sn := '';
  Result := sn;
end;

procedure TCustomReportDetailsForm.UpdateReportControls;
begin
  cbRepeat.Enabled := FReportData.ProcessDetails;
end;

procedure TCustomReportDetailsForm.cdProcessFieldsCalcFields(
  DataSet: TDataSet);
begin
   if DataSet.Fields.FieldByName('IsProcessName').Value = true then
      DataSet.Fields.FieldByName('C').Value := 1
   else
      DataSet.Fields.FieldByName('C').Value := 0;
end;

procedure TCustomReportDetailsForm.DisableFilter(DataSet: TClientDataSet);
begin
  DataSet.Filtered := false;
end;

procedure TCustomReportDetailsForm.EnableFilter(DataSet: TClientDataSet);
begin
  // ������ ������ ���� �� ����������� ��������� ���������� ����
  if not DataSet.Filtered and not FShowAdded then
  begin
    DataSet.Filtered := true;
    DataSet.Filter := 'not IsAdded';
  end;
end;

procedure TCustomReportDetailsForm.treeViewProcessFieldsDBOnChangeCurrentRecord(
  Sender: TDBVirtualStringTree; RecordId: Integer);
var
  processID: integer;
  fieldName: string;
  isFound{, oldFiltered}: bool;
  node: PVirtualNode;
  nodeData: PNodeData;
begin
  processID := RecordId;
  node := treeViewProcessFields.FocusedNode;

  //oldFiltered := cdProcessFields.Filtered;
  if node <> nil then
  begin
    try
      begin
        //cdProcessFields.Filtered := false;

        cdProcessFields.Filter := 'ProcessID = ' + IntToStr(RecordId);

        nodeData := treeViewProcessFields.GetNodeData(node);
        fieldName := nodeData.FieldValues[FieldNameIndex];
        isFound := cdProcessFields.Locate('ProcessID;FieldName', VarArrayOf([processID, fieldName]), []);
      end;
    finally
      //cdProcessFields.Filtered := oldFiltered;
    end;
  end;
end;

procedure TCustomReportDetailsForm.HideNode(node: PVirtualNode);
var
  selectedNode: PVirtualNode;
  nodeData : PNodeData;
  fieldName: string;
begin
  if (node <> nil) then
  begin
    nodeData := treeViewProcessFields.GetNodeData(node);
    fieldName := nodeData.FieldValues[FieldNameIndex];

    if (fieldName <> '') and (hideNodes.IndexOf(node) = -1)then
    begin
      hideNodes.Add(node);
      treeViewProcessFields.IsVisible[node] := false;

      selectedNode := GetNextNode(node);
      treeViewProcessFields.Selected[selectedNode] := true;
      treeViewProcessFields.FocusedNode := selectedNode;
    end;
  end;
end;

function TCustomReportDetailsForm.GetNextNode(node: PVirtualNode) : PVirtualNode;
var
  resultNode: PVirtualNode;
  sublingNode: PVirtualNode;
begin
  resultNode := nil;

  sublingNode := treeViewProcessFields.GetNextVisibleSibling(node);
  if sublingNode = nil then
  begin
    resultNode := treeViewProcessFields.GetNextVisible(node);
    if resultNode <> nil then
      sublingNode := treeViewProcessFields.GetFirstVisibleChild(resultNode)
  end;

  if resultNode <> nil then
     treeViewProcessFields.Expanded[resultNode] := true;

  if sublingNode <> nil then
    resultNode := sublingNode;

  Result := resultNode;
end;

procedure TCustomReportDetailsForm.ShowNode(node: PVirtualNode);
var
  nodeData: PNodeData;
  processID: integer;
  fieldName: string;
begin
  nodeData := treeViewProcessFields.GetNodeData(node);
  processID := nodeData.RecordId;
  fieldName := nodeData.FieldValues[FieldNameIndex];

  ShowNode(processID, fieldName);
end;

procedure TCustomReportDetailsForm.ShowNode(processID: integer; fieldName: string);
var
  index: Integer;
  node: PVirtualNode;
  nodeData: PNodeData;
begin
  for index := 0 to hideNodes.Count - 1 do
  begin
    node := PVirtualNode(hideNodes[index]);
    nodeData := treeViewProcessFields.GetNodeData(Node);

    if (nodeData.RecordId = processID) and (nodeData.FieldValues[FieldNameIndex] = fieldName) then
    begin
     treeViewProcessFields.IsVisible[node] := true;
     hideNodes.Remove(node);

     break;
    end;
  end;
end;

procedure TCustomReportDetailsForm.treeViewProcessFieldsGetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
  nodeData: PNodeData;
  fieldName: string;
begin
  if Column = 0 then
  begin
    try
      begin
        nodeData := TDBVirtualStringTree(Sender).GetNodeData(Node);
        fieldName := nodeData.FieldValues[FieldNameIndex];

        if (fieldName <> '') then
           ImageIndex := 0;
      end;
    except end;
  end;
end;

procedure TCustomReportDetailsForm.treeViewProcessFieldsInitNode(
  Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
var
  nodeData: PNodeData;
  fieldName: string;
  isAdded: boolean;
begin
  nodeData := treeViewProcessFields.GetNodeData(Node);

  fieldName := nodeData.FieldValues[FieldNameIndex];

  if not FShowAdded then
  begin
    isAdded := LocateProcessFieldInReport(nodeData.RecordId, FieldName);
    if isAdded then HideNode(Node)
  end;
end;

procedure TCustomReportDetailsForm.treeViewProcessFieldsDblClick(Sender: TObject);
begin
  btAddClick(Sender);
end;

end.
