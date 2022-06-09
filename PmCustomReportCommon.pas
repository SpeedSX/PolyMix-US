unit PmCustomReportCommon;

interface

const
  OrderDetails_InvoiceItems = -1;
  OrderDetails_Payments = -2;
  OrderDetails_Shipment = -3;

  //StdFormat2 = '#,###,###.00';
  //StdFormat4 = '#,###,###.0000';
  ExcelDateFormat = 'dd.mm.yy';//'��.��.��';
  ExcelTimeFormat = 'h:mm';//'��:��';
  ExcelMoneyFormat = '# ##0,00';

  // ���� ������� ����������
  FilterType_ProcessRow = 1;
  FilterType_ReportRow = 2;
  FilterType_CellValue = 3;

  ClientPriceTableName = 'ClientPrice';
  ShipmentTableName = 'StoreOut';
  
implementation

end.
