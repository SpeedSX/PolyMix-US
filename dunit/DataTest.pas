unit DataTest;

interface

uses Classes, SysUtils, DateUtils,
  TestFrameWork,
  Variants, PmEntity, PmHistory;

type
  TEntityTests = class(TTestCase)
  protected
  published
    procedure Test_AddCustomer;
    procedure Test_RemoveCustomer;
    procedure Test_UpdateCustomer;
  end;

implementation

procedure TEntityTests.Test_AddCustomer;
begin

end;

procedure TEntityTests.Test_RemoveCustomer;
begin

end;

procedure TEntityTests.Test_UpdateCustomer;
begin

end;

{procedure TDataTests.TestPagerCursorMemory;
var
  I: Integer;
  Hist: TGlobalHistoryView;
  HistCriteria: TGlobalHistoryCriteria;
begin
  Hist := TGlobalHistoryView.Create;
  Hist.UsePager := true;
  try
  for I := 0 to 1 do
  begin
    HistCriteria.StartDate := IncDay(Now, -1000);
    HistCriteria.EndDate := Now;
    Hist.Criteria := HistCriteria;
    Hist.Reload;
    //Hist.Open;
    //Hist.Close;
  end;
  finally
    Hist.Free;
  end;
end;}

initialization

  TestFramework.RegisterTest('EntityTests Suite',
    TEntityTests.Suite);

end.
