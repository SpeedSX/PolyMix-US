unit PmCustomReportCommon;

interface

const
  OrderDetails_InvoiceItems = -1;
  OrderDetails_Payments = -2;
  OrderDetails_Shipment = -3;

  //StdFormat2 = '#,###,###.00';
  //StdFormat4 = '#,###,###.0000';
  ExcelDateFormat = 'dd.mm.yy';//'ДД.ММ.ГГ';
  ExcelTimeFormat = 'h:mm';//'чч:мм';
  ExcelMoneyFormat = '# ##0,00';

  // Виды условий фильтрации
  FilterType_ProcessRow = 1;
  FilterType_ReportRow = 2;
  FilterType_CellValue = 3;

  ClientPriceTableName = 'ClientPrice';
  ShipmentTableName = 'StoreOut';
  
implementation

end.
