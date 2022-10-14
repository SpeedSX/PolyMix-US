program Paper_OnContextPopup;
uses uTriadaUtils, fPaperSelect;

  procedure SelectPaper;
  var
    PaperSelectForm: TPaperSelectForm;
    PaperDS: TDataSource;
    s: string;
    de: TDictionary;
  begin
    PaperSelectForm := TPaperSelectForm.Create(nil);
    PaperSelectForm.dsPaperList.DataSet := GetDictionary('PaperCat').DataSet;

    if PaperSelectForm.ShowModal = mrOk then
    begin
      de := GetDictionary('PaperCat');
      PaperType := de.CurrentCode;
      PaperPrice := de.CurrentValue(1);
    end;
    PaperSelectForm.Free;
  end;

begin
  if CurrentField = 'PaperTypeName' then
    SelectPaper
  else if CurrentField = 'PaperDensity' then
    MakeMenu('PaperD')
  else if CurrentField = 'PaperFormatX' then
    //MakeMenu('PaperX')
    MakeMenu('PrintFormat')
  else if CurrentField = 'PaperFormatY' then
    //MakeMenu('PaperY')
    MakeMenu('PrintFormat')
  else if CurrentField = 'PaperPrice' then
  begin
    MakeMenu('PaperCat')
    //MakeMenuClientFilter('Paper', 'A2');
  end;
end.
