unit fTabSrv3L1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, JvExExtCtrls, JvComponent, JvSplit, 
  StdCtrls, ExtCtrls, JvLabel, JvDBControls,
  JvExControls, DBGridEh,

  PmProcess, fSrvTmpl, MyDBGridEh, CalcSettings, JvExtComponent, GridsEh,
  JvGradientHeaderPanel;

type
  TfrTabSrv3L1 = class(TfrSrvTemplate)
    paPrint1: TPanel;
    Panel45: TPanel;
    dg1: TMyDBGridEh;
    splPrint1: TJvxSplitter;
    paPrint2: TPanel;
    Panel49: TPanel;
    dg2: TMyDBGridEh;
    Panel50: TPanel;
    dg3: TMyDBGridEh;
    Panel51: TPanel;
    splPrint2: TJvxSplitter;
    Panel1: TPanel;
    sbAdd1: TBitBtn;
    sbDel1: TBitBtn;
    sbClear1: TBitBtn;
    paBotLeft: TPanel;
    lbTotal: TLabel;
    paTotal: TPanel;
    lbSrvName1: TJvGradientHeaderPanel;
    lbSrvName2: TJvGradientHeaderPanel;
    lbSrvName3: TJvGradientHeaderPanel;
  private
    procedure SetProcessGrid1(Val: TProcessGrid);
    procedure SetProcessGrid2(Val: TProcessGrid);
    procedure SetProcessGrid3(Val: TProcessGrid);
    procedure btReset1Click(Sender: TObject);
    procedure btDel1RecordClick(Sender: TObject);
    procedure btAdd1RecordClick(Sender: TObject);
    function GetProcessGrid1: TProcessGrid;
    function GetProcessGrid2: TProcessGrid;
    function GetProcessGrid3: TProcessGrid;
  protected
    procedure OnCreate; override;
    procedure DoSettingsChanged; override;
  public
    property ProcessGrid1: TProcessGrid read GetProcessGrid1;
    property ProcessGrid2: TProcessGrid read GetProcessGrid2;
    property ProcessGrid3: TProcessGrid read GetProcessGrid3;
    procedure BeforeDelete; override;
    procedure SaveLayout; override;
    procedure LoadLayout; override;
    function GetFrameTotal(var ItemCount: integer): extended; override;
    procedure OpenProcesses; override;
    procedure AddProcessGrid(AProcessGrid: TProcessGrid); override;
  end;

var
  frTabSrv3L1: TfrTabSrv3L1;

implementation

uses EnPaint, PmAccessManager;

{$R *.dfm}

procedure TfrTabSrv3L1.BeforeDelete;
begin
  inherited BeforeDelete;
end;

procedure TfrTabSrv3L1.SetProcessGrid1(Val: TProcessGrid);
var c: boolean;
begin
  ProcessGrid1.DBGrid := dg1;
  lbSrvName1.LabelCaption := ProcessGrid1.GridCfg.GridCaption;
  if ProcessGrid1.ShowControlPanel then
  begin
    //DBStatusLabel1.DataSource := ProcessGrid1.DataSource;

    ProcessGrid1.TotalPanel := paTotal;
    c := ProcessGrid1.GridCfg.TotalFieldName <> '';
    paTotal.Visible := c;
    lbTotal.Visible := c;

    c := ProcessGrid1.Srv.PermitDelete;
    sbDel1.Enabled := c;
    sbClear1.Enabled := c;
    sbAdd1.Enabled := ProcessGrid1.Srv.PermitInsert;
    paBotLeft.Visible := AccessManager.CurKindPerm.CostView;
    Panel1.Visible := true;
  end
  else
  begin
    Panel1.Visible := false;
    ProcessGrid1.TotalPanel := nil;
    paTotal.Visible := false;
    lbTotal.Visible := false;
  end;
end;

procedure TfrTabSrv3L1.SetProcessGrid2(Val: TProcessGrid);
begin
  ProcessGrid2.DBGrid := dg2;
  lbSrvName2.LabelCaption := ProcessGrid2.GridCfg.GridCaption;
  {if FProcessGrid2.ShowControlPanel then begin
    FProcessGrid2.TotalPanel := paItogo2;
    DBStatusLabel2.DataSource := FProcessGrid2.DataSource
  end else
    Panel2.Visible := false;}
end;

procedure TfrTabSrv3L1.SetProcessGrid3(Val: TProcessGrid);
begin
  ProcessGrid3.DBGrid := dg3;
  lbSrvName3.LabelCaption := ProcessGrid3.GridCfg.GridCaption;
end;

procedure TfrTabSrv3L1.SaveLayout;
begin
  if (AppStorage <> nil) and (ProcessGrid1 <> nil) then begin
    AppStorage.WriteInteger(ProcessGrid1.GridCfg.GridName + '\Frame\paPrint1Height', paPrint1.Height);
    AppStorage.WriteInteger(ProcessGrid1.GridCfg.GridName + '\Frame\paPrint2Width', paPrint2.Width);
  end;
end;

procedure TfrTabSrv3L1.LoadLayout;
begin
  if (AppStorage <> nil) and (ProcessGrid1 <> nil) then begin
    paPrint1.Height := AppStorage.ReadInteger(ProcessGrid1.GridCfg.GridName + '\Frame\paPrint1Height', paPrint1.Height);
    paPrint2.Width := AppStorage.ReadInteger(ProcessGrid1.GridCfg.GridName + '\Frame\paPrint2Width', paPrint2.Width);
  end;
end;

procedure TfrTabSrv3L1.OnCreate;
begin
  inherited OnCreate;
  TSettingsManager.Instance.XPInitComponent(sbAdd1);
  TSettingsManager.Instance.XPInitComponent(sbDel1);
  TSettingsManager.Instance.XPInitComponent(sbClear1);
  // в этом Layout только одна панель с кнопками
  sbAdd1.OnClick := btAdd1RecordClick;
  sbDel1.OnClick := btDel1RecordClick;
  sbClear1.OnClick := btReset1Click;
  dg1.OnDrawColumnCell := EnablePainter.DrawCheckBox;
  //dg1.OnEditButtonClick := dgEditButtonClick;
  dg2.OnDrawColumnCell := EnablePainter.DrawCheckBox;
  //dg2.OnEditButtonClick := dgEditButtonClick;
  dg3.OnDrawColumnCell := EnablePainter.DrawCheckBox;
  //dg3.OnEditButtonClick := dgEditButtonClick;
  GridOptions(dg1);
  GridOptions(dg2);
  GridOptions(dg3);
end;

{ TODO: НАДО ДОДЕЛАТЬ случай, если гриды относятся к разным процессам }

procedure TfrTabSrv3L1.btReset1Click(Sender: TObject); // Очистка таблички
begin
  ProcessGrid1.Clear;
end;

procedure TfrTabSrv3L1.btDel1RecordClick(Sender: TObject);    // Удаление строки в табличке
begin
  ProcessGrid1.DeleteRecord;
end;

procedure TfrTabSrv3L1.btAdd1RecordClick(Sender: TObject);   // Добавление строки
begin
  ProcessGrid1.AppendRecord;
end;

function TfrTabSrv3L1.GetFrameTotal(var ItemCount: integer): extended;
begin
  {Result := FProcessGrid1.Srv.TotalCost;
  ItemCount := FProcessGrid1.Srv.EnabledCount;
  if FProcessGrid1.Srv <> FProcessGrid2.Srv then begin
    Result := Result + FProcessGrid2.Srv.TotalCost;
    ItemCount := ItemCount + FProcessGrid2.Srv.EnabledCount;
  end;
  if (FProcessGrid3.Srv <> FProcessGrid2.Srv) and (FProcessGrid3.Srv <> FProcessGrid1.Srv) then begin
    Result := Result + FProcessGrid3.Srv.TotalCost;
    ItemCount := ItemCount + FProcessGrid3.Srv.EnabledCount;
  end;}
  Result := ProcessGrid1.TotalCost + ProcessGrid2.TotalCost + ProcessGrid3.TotalCost;
  ItemCount := ProcessGrid1.Srv.EnabledCount;
  if ProcessGrid1.Srv <> ProcessGrid2.Srv then
    ItemCount := ItemCount + ProcessGrid2.Srv.EnabledCount;
  if (ProcessGrid3.Srv <> ProcessGrid2.Srv) and (ProcessGrid3.Srv <> ProcessGrid1.Srv) then
    ItemCount := ItemCount + ProcessGrid3.Srv.EnabledCount;
end;

procedure TfrTabSrv3L1.OpenProcesses;
begin
  inherited OpenProcesses;
end;

procedure TfrTabSrv3L1.AddProcessGrid(AProcessGrid: TProcessGrid);
begin
  inherited AddProcessGrid(AProcessGrid);
  if FGridList.Count = 1 then SetProcessGrid1(AProcessGrid)
  else if FGridList.Count = 2 then SetProcessGrid2(AProcessGrid)
  else SetProcessGrid3(AProcessGrid);
end;

function TfrTabSrv3L1.GetProcessGrid1: TProcessGrid;
begin
  if Assigned(FGridList) and (FGridList.Count >= 1) then
    Result := TProcessGrid(FGridList.Items[0])
  else
    Result := nil;
end;

function TfrTabSrv3L1.GetProcessGrid2: TProcessGrid;
begin
  if Assigned(FGridList) and (FGridList.Count >= 2) then
    Result := TProcessGrid(FGridList.Items[1])
  else
    Result := nil;
end;

function TfrTabSrv3L1.GetProcessGrid3: TProcessGrid;
begin
  if Assigned(FGridList) and (FGridList.Count >= 3) then
    Result := TProcessGrid(FGridList.Items[2])
  else
    Result := nil;
end;

procedure TfrTabSrv3L1.DoSettingsChanged;
begin
  inherited DoSettingsChanged;
  paTotal.Color := Options.GetColor(sProcessTotalBk);
  paTotal.Font.Color := Options.GetColor(sProcessTotalText);
  lbSrvName1.LabelFont.Color := Options.GetColor(sProcessNameText);
  lbSrvName2.LabelFont.Color := Options.GetColor(sProcessNameText);
  lbSrvName3.LabelFont.Color := Options.GetColor(sProcessNameText);
end;

end.
