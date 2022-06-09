unit fTabSrv2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  JvCtrls, JvDBControls, JvSplit, StdCtrls, ExtCtrls, Buttons,
  fSrvTmpl, JvExExtCtrls, JvComponent, JvLabel, JvAppStorage,
  JvExControls,

  PmProcess, DBGridEh, MyDBGridEh, CalcSettings, JvExtComponent, GridsEh,
  JvGradientHeaderPanel;

type
  TfrTabSrv2H = class(TfrSrvTemplate)
    paTopGrid: TPanel;
    paControl1: TPanel;
    sbAdd1: TBitBtn;
    sbDel1: TBitBtn;
    sbClear1: TBitBtn;
    paItogoL1: TPanel;
    lbItogo1: TLabel;
    paItogo1: TPanel;
    dg1: TMyDBGridEh;
    Panel76: TPanel;
    RxSplitter5: TJvxSplitter;
    paBottomGrid: TPanel;
    paControl2: TPanel;
    sbAdd2: TBitBtn;
    sbDel2: TBitBtn;
    sbClear2: TBitBtn;
    paItogoL2: TPanel;
    lbItogo2: TLabel;
    paItogo2: TPanel;
    dg2: TMyDBGridEh;
    Panel79: TPanel;
    paWorkTotal2: TPanel;
    lbWorkTotal2: TLabel;
    paMatTotal2: TPanel;
    lbMatTotal2: TLabel;
    paMatTotal1: TPanel;
    lbMatTotal1: TLabel;
    paWorkTotal1: TPanel;
    lbWorkTotal1: TLabel;
    lbSrvName1: TJvGradientHeaderPanel;
    lbSrvName2: TJvGradientHeaderPanel;
  private
    procedure SetProcessGrid1(Val: TProcessGrid);
    procedure SetProcessGrid2(Val: TProcessGrid);
    procedure btReset1Click(Sender: TObject);
    procedure btDel1RecordClick(Sender: TObject);
    procedure btAdd1RecordClick(Sender: TObject);
    procedure btReset2Click(Sender: TObject);
    procedure btDel2RecordClick(Sender: TObject);
    procedure btAdd2RecordClick(Sender: TObject);
    function GetProcessGrid1: TProcessGrid;
    function GetProcessGrid2: TProcessGrid;
  protected
    procedure OnCreate; override;
    procedure DoSettingsChanged; override;
  public
    property ProcessGrid1: TProcessGrid read GetProcessGrid1;
    property ProcessGrid2: TProcessGrid read GetProcessGrid2;
    procedure BeforeDelete; override;
    procedure SaveLayout; override;
    procedure LoadLayout; override;
    function GetFrameTotal(var ItemCount: integer): extended; override;
    procedure OpenProcesses; override;
    procedure AddProcessGrid(AProcessGrid: TProcessGrid); override;
  end;

implementation

uses EnPaint, PmAccessManager;

{$R *.DFM}

procedure TfrTabSrv2H.BeforeDelete;
begin
  inherited BeforeDelete;
end;

procedure TfrTabSrv2H.SetProcessGrid1(Val: TProcessGrid);
var c: boolean;
begin
  ProcessGrid1.DBGrid := dg1;
  lbSrvName1.LabelCaption := ProcessGrid1.GridCfg.GridCaption;
  if ProcessGrid1.ShowControlPanel then
  begin
    //DBStatusLabel1.DataSource := ProcessGrid1.DataSource;

    ProcessGrid1.TotalPanel := paItogo1;
    c := ProcessGrid1.GridCfg.TotalFieldName <> '';
    paItogo1.Visible := c;
    lbItogo1.Visible := c;

    ProcessGrid1.TotalWorkPanel := paWorkTotal1;
    c := ProcessGrid1.GridCfg.TotalWorkFieldName <> '';
    paWorkTotal1.Visible := c;
    lbWorkTotal1.Visible := c;

    ProcessGrid1.TotalMatPanel := paMatTotal1;
    c := ProcessGrid1.GridCfg.TotalMatFieldName <> '';
    paMatTotal1.Visible := c;
    lbMatTotal1.Visible := c;

    c := ProcessGrid1.Srv.PermitDelete;
    sbDel1.Enabled := c;
    sbClear1.Enabled := c;
    sbAdd1.Enabled := ProcessGrid1.Srv.PermitInsert;
    paItogoL1.Visible := AccessManager.CurKindPerm.CostView;
    paControl1.Visible := true;
  end
  else
  begin
    ProcessGrid1.TotalPanel := nil;
    paItogo1.Visible := false;
    lbItogo1.Visible := false;

    ProcessGrid1.TotalWorkPanel := nil;
    paWorkTotal1.Visible := false;
    lbWorkTotal1.Visible := false;

    ProcessGrid1.TotalMatPanel := nil;
    paMatTotal1.Visible := false;
    lbMatTotal1.Visible := false;

    paControl1.Visible := false;
  end;
end;

procedure TfrTabSrv2H.SetProcessGrid2(Val: TProcessGrid);
var c: boolean;
begin
  ProcessGrid2.DBGrid := dg2;
  lbSrvName2.LabelCaption := ProcessGrid2.GridCfg.GridCaption;
  if ProcessGrid2.ShowControlPanel then
  begin
    ProcessGrid2.TotalPanel := paItogo2;

    c := ProcessGrid2.GridCfg.TotalFieldName <> '';
    paItogo2.Visible := c;
    lbItogo2.Visible := c;

    ProcessGrid2.TotalWorkPanel := paWorkTotal2;
    c := ProcessGrid2.GridCfg.TotalWorkFieldName <> '';
    paWorkTotal2.Visible := c;
    lbWorkTotal2.Visible := c;

    ProcessGrid2.TotalMatPanel := paMatTotal2;
    c := ProcessGrid2.GridCfg.TotalMatFieldName <> '';
    paMatTotal2.Visible := c;
    lbMatTotal2.Visible := c;

    //DBStatusLabel2.DataSource := ProcessGrid2.DataSource;
    c := ProcessGrid2.Srv.PermitDelete;
    sbDel2.Enabled := c;
    sbClear2.Enabled := c;
    sbAdd2.Enabled := ProcessGrid2.Srv.PermitInsert;
    paItogoL2.Visible := AccessManager.CurKindPerm.CostView;
    paControl2.Visible := true;
  end
  else
  begin
    ProcessGrid2.TotalPanel := nil;
    paItogo2.Visible := false;
    lbItogo2.Visible := false;

    ProcessGrid2.TotalWorkPanel := nil;
    paWorkTotal2.Visible := false;
    lbWorkTotal2.Visible := false;

    ProcessGrid2.TotalMatPanel := nil;
    paMatTotal2.Visible := false;
    lbMatTotal2.Visible := false;

    paControl2.Visible := false;
  end;
end;

procedure TfrTabSrv2H.SaveLayout;
begin
  if (AppStorage <> nil) and (ProcessGrid1 <> nil) then
    AppStorage.WriteInteger(ProcessGrid1.GridCfg.GridName + '\Frame\paTopGridHeight', paTopGrid.Height);
end;

procedure TfrTabSrv2H.LoadLayout;
begin
  if (AppStorage <> nil) and (ProcessGrid1 <> nil) then
    paTopGrid.Height := AppStorage.ReadInteger(ProcessGrid1.GridCfg.GridName + '\Frame\paTopGridHeight', paTopGrid.Height);
end;

procedure TfrTabSrv2H.OnCreate;
begin
  inherited OnCreate;
  TSettingsManager.Instance.XPInitComponent(sbAdd1);
  TSettingsManager.Instance.XPInitComponent(sbDel1);
  TSettingsManager.Instance.XPInitComponent(sbClear1);
  TSettingsManager.Instance.XPInitComponent(sbAdd2);
  TSettingsManager.Instance.XPInitComponent(sbDel2);
  TSettingsManager.Instance.XPInitComponent(sbClear2);
  sbAdd1.OnClick := btAdd1RecordClick;
  sbDel1.OnClick := btDel1RecordClick;
  sbClear1.OnClick := btReset1Click;
  sbAdd2.OnClick := btAdd2RecordClick;
  sbDel2.OnClick := btDel2RecordClick;
  sbClear2.OnClick := btReset2Click;
  dg1.OnDrawColumnCell := EnablePainter.DrawCheckBox;
  //dg1.OnEditButtonClick := dgEditButtonClick;
  dg2.OnDrawColumnCell := EnablePainter.DrawCheckBox;
  //dg2.OnEditButtonClick := dgEditButtonClick;
  GridOptions(dg1);
  GridOptions(dg2);
end;

procedure TfrTabSrv2H.btReset1Click(Sender: TObject); // Очистка таблички
begin
  ProcessGrid1.Clear;
end;

procedure TfrTabSrv2H.btDel1RecordClick(Sender: TObject);    // Удаление строки в табличке
begin
  ProcessGrid1.DeleteRecord;
end;

procedure TfrTabSrv2H.btAdd1RecordClick(Sender: TObject);   // Добавление строки
begin
  ProcessGrid1.AppendRecord;
end;

procedure TfrTabSrv2H.btReset2Click(Sender: TObject); // Очистка таблички
begin
  ProcessGrid2.Clear;
end;

procedure TfrTabSrv2H.btDel2RecordClick(Sender: TObject);    // Удаление строки в табличке
begin
  ProcessGrid2.DeleteRecord;
end;

procedure TfrTabSrv2H.btAdd2RecordClick(Sender: TObject);   // Добавление строки
begin
  ProcessGrid2.AppendRecord;
end;

function TfrTabSrv2H.GetFrameTotal(var ItemCount: integer): extended;
begin
  Result := ProcessGrid1.TotalCost + ProcessGrid2.TotalCost;
  ItemCount := ProcessGrid1.Srv.EnabledCount;
  if ProcessGrid1.Srv <> ProcessGrid2.Srv then
    ItemCount := ItemCount + ProcessGrid2.Srv.EnabledCount;
end;

procedure TfrTabSrv2H.OpenProcesses;
begin
  inherited OpenProcesses;
end;

procedure TfrTabSrv2H.AddProcessGrid(AProcessGrid: TProcessGrid);
begin
  inherited AddProcessGrid(AProcessGrid);
  if FGridList.Count = 1 then SetProcessGrid1(AProcessGrid)
  else SetProcessGrid2(AProcessGrid);
end;

function TfrTabSrv2H.GetProcessGrid1: TProcessGrid;
begin
  if Assigned(FGridList) and (FGridList.Count >= 1) then
    Result := TProcessGrid(FGridList[0])
  else
    Result := nil;
end;

function TfrTabSrv2H.GetProcessGrid2: TProcessGrid;
begin
  if Assigned(FGridList) and (FGridList.Count >= 2) then
    Result := TProcessGrid(FGridList.Items[1])
  else
    Result := nil;
end;

procedure TfrTabSrv2H.DoSettingsChanged;
begin
  inherited DoSettingsChanged;

  paItogo1.Color := Options.GetColor(sProcessTotalBk);
  paItogo1.Font.Color := Options.GetColor(sProcessTotalText);
  paWorkTotal1.Color := Options.GetColor(sWorkTotalBk);
  paWorkTotal1.Font.Color := Options.GetColor(sWorkTotalText);
  paMatTotal1.Color := Options.GetColor(sMatTotalBk);
  paMatTotal1.Font.Color := Options.GetColor(sMatTotalText);

  paItogo2.Color := Options.GetColor(sProcessTotalBk);
  paItogo2.Font.Color := Options.GetColor(sProcessTotalText);
  paWorkTotal2.Color := Options.GetColor(sWorkTotalBk);
  paWorkTotal2.Font.Color := Options.GetColor(sWorkTotalText);
  paMatTotal2.Color := Options.GetColor(sMatTotalBk);
  paMatTotal2.Font.Color := Options.GetColor(sMatTotalText);

  lbSrvName1.LabelFont.Color := Options.GetColor(sProcessNameText);
  lbSrvName2.LabelFont.Color := Options.GetColor(sProcessNameText);
end;

end.
