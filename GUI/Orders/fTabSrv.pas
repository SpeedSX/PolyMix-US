unit fTabSrv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, JvCtrls, JvDBControls, StdCtrls, ExtCtrls, PmProcess, fSrvTmpl,
  JvLabel, JvExControls, JvComponent, 

  DBGridEh, MyDBGridEh, CalcSettings, GridsEh, JvGradientHeaderPanel,
  DBGridEhGrouping;

type
  TfrTabSrv = class(TfrSrvTemplate)
    paBot: TPanel;
    sbAdd: TBitBtn;
    sbDel: TBitBtn;
    sbClear: TBitBtn;
    paItogoL: TPanel;
    lbWorkTotal: TLabel;
    paWorkTotal: TPanel;
    dgCommon: TMyDBGridEh;
    paTop: TPanel;
    lbMatTotal: TLabel;
    paMatTotal: TPanel;
    lbItogo: TLabel;
    paItogo: TPanel;
    lbSrvName: TJvGradientHeaderPanel;
  private
    function GetProcessGrid: TProcessGrid;
    procedure SetProcessGrid(Val: TProcessGrid);
    procedure btReset1Click(Sender: TObject);
    procedure btDel1RecordClick(Sender: TObject);
    procedure btAdd1RecordClick(Sender: TObject);
  protected
    procedure OnCreate; override;
    procedure DoSettingsChanged; override;
  public
    property ProcessGrid: TProcessGrid read GetProcessGrid;
    procedure BeforeDelete; override;
    function GetFrameTotal(var ItemCount: integer): extended; override;
    procedure OpenProcesses; override;
    procedure AddProcessGrid(AProcessGrid: TProcessGrid); override;
  end;

implementation

uses EnPaint, PmAccessManager;

{$R *.DFM}

procedure TfrTabSrv.BeforeDelete;
begin
  inherited BeforeDelete;
end;

procedure TfrTabSrv.SetProcessGrid(Val: TProcessGrid);
var
  c: boolean;
begin
  ProcessGrid.DBGrid := dgCommon;
  lbSrvName.LabelCaption := ProcessGrid.GridCfg.GridCaption;
  if ProcessGrid.ShowControlPanel then
  begin
    ProcessGrid.TotalPanel := paItogo;
    c := ProcessGrid.GridCfg.TotalFieldName <> '';
    paItogo.Visible := c;
    lbItogo.Visible := c;

    ProcessGrid.TotalWorkPanel := paWorkTotal;
    c := ProcessGrid.GridCfg.TotalWorkFieldName <> '';
    paWorkTotal.Visible := c;
    lbWorkTotal.Visible := c;

    ProcessGrid.TotalMatPanel := paMatTotal;
    c := ProcessGrid.GridCfg.TotalMatFieldName <> '';
    paMatTotal.Visible := c;
    lbMatTotal.Visible := c;

    //DBStatusLabel.DataSource := ProcessGrid.DataSource;
    c := ProcessGrid.Srv.PermitDelete;
    sbDel.Enabled := c;
    sbClear.Enabled := c;
    sbAdd.Enabled := ProcessGrid.Srv.PermitInsert;
    paItogoL.Visible := AccessManager.CurKindPerm.CostView;
  end
  else
  begin
    ProcessGrid.TotalPanel := nil;
    paItogo.Visible := false;
    lbItogo.Visible := false;

    ProcessGrid.TotalWorkPanel := nil;
    paWorkTotal.Visible := false;
    lbWorkTotal.Visible := false;

    ProcessGrid.TotalMatPanel := nil;
    paMatTotal.Visible := false;
    lbMatTotal.Visible := false;

    paBot.Visible := false;
  end;
end;

procedure TfrTabSrv.DoSettingsChanged;
begin
  inherited DoSettingsChanged;
  paItogo.Color := Options.GetColor(sProcessTotalBk);
  paItogo.Font.Color := Options.GetColor(sProcessTotalText);
  paWorkTotal.Color := Options.GetColor(sWorkTotalBk);
  paWorkTotal.Font.Color := Options.GetColor(sWorkTotalText);
  paMatTotal.Color := Options.GetColor(sMatTotalBk);
  paMatTotal.Font.Color := Options.GetColor(sMatTotalText);
  lbSrvName.LabelFont.Color := Options.GetColor(sProcessNameText);
end;

procedure TfrTabSrv.OnCreate;
begin
  inherited OnCreate;
  TSettingsManager.Instance.XPInitComponent(sbAdd);
  TSettingsManager.Instance.XPInitComponent(sbDel);
  TSettingsManager.Instance.XPInitComponent(sbClear);
  sbAdd.OnClick := btAdd1RecordClick;
  sbDel.OnClick := btDel1RecordClick;
  sbClear.OnClick := btReset1Click;
  dgCommon.OnDrawColumnCell := EnablePainter.DrawCheckBox;
  //dgCommon.OnEditButtonClick := dgEditButtonClick;
  GridOptions(dgCommon);
end;

procedure TfrTabSrv.btReset1Click(Sender: TObject); // Очистка таблички
begin
  ProcessGrid.Clear;
end;

procedure TfrTabSrv.btDel1RecordClick(Sender: TObject);    // Удаление строки в табличке
begin
  ProcessGrid.DeleteRecord;
end;

procedure TfrTabSrv.btAdd1RecordClick(Sender: TObject);   // Добавление строки
begin
  ProcessGrid.AppendRecord;
end;

function TfrTabSrv.GetFrameTotal(var ItemCount: integer): extended;
begin
  //Result := FProcessGrid.Srv.TotalCost;
  Result := ProcessGrid.TotalCost;
  ItemCount := ProcessGrid.Srv.EnabledCount;
end;

procedure TfrTabSrv.OpenProcesses;
begin
  inherited OpenProcesses;
end;

procedure TfrTabSrv.AddProcessGrid(AProcessGrid: TProcessGrid);
begin
  inherited AddProcessGrid(AProcessGrid);
  SetProcessGrid(AProcessGrid);
end;

function TfrTabSrv.GetProcessGrid: TProcessGrid;
begin
  if Assigned(FGridList) and (FGridList.Count >= 1) then
    Result := TProcessGrid(FGridList[0])
  else
    Result := nil;
end;

end.
