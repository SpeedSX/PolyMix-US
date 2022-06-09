unit PmProcessGridEditorFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PmBaseConfigEditorFrame, JvExControls, JvGradientHeaderPanel,
  StdCtrls, Mask, JvExMask, JvSpin, JvDBSpinEdit, DBCtrls, Menus,

  PmConfigTree, DB;

type
  TProcessGridEditorFrame = class(TBaseConfigEditorFrame)
    btGridProps: TButton;
    btCols: TButton;
    btGridCode: TButton;
    pmProcessGrid: TPopupMenu;
    N10: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N6: TMenuItem;
    miDelete: TMenuItem;
    dsGrids: TDataSource;
    procedure btGridCodeClick(Sender: TObject);
    procedure btColsClick(Sender: TObject);
    procedure btGridPropsClick(Sender: TObject);
    procedure btDeleteGridClick(Sender: TObject);
  private
    FOnDeleteGrid, FOnEditGridCode, FOnEditGridProperties, FOnEditGridCols: TNotifyEvent;
  protected
    procedure SetNode(ANode: TMVCNode); override;
  public
    function AllowLeaveEditor: boolean; override;
    function GetPopupMenu: TPopupMenu; override;
    property OnDeleteGrid: TNotifyEvent read FOnDeleteGrid write FOnDeleteGrid;
    property OnEditGridCode: TNotifyEvent read FOnEditGridCode write FOnEditGridCode;
    property OnEditGridProperties: TNotifyEvent read FOnEditGridProperties write FOnEditGridProperties;
    property OnEditGridCols: TNotifyEvent read FOnEditGridCols write FOnEditGridCols;
  end;

implementation

uses ExHandler, PmConfigManager, PmProcessCfgData, PmProcessCfg, PmConfigObjects;

{$R *.dfm}

procedure TProcessGridEditorFrame.SetNode(ANode: TMVCNode);
var
  en, IsBased, Act: boolean;
  Srv: TPolyProcessCfg;
begin
  inherited SetNode(ANode);

  dsGrids.DataSet := TConfigManager.Instance.ProcessGridCfgData.DataSet;
  
  if not TConfigManager.Instance.ProcessGridCfgData.Locate((Node as TCfgProcessGrid).GridID) then
    ExceptionHandler.Raise_('SetNode: Таблица не найдена');

  Srv := TConfigManager.Instance.ServiceByID((ANode.Parent as TCfgProcess).ProcessID);
  Act := Srv.IsActive;
  IsBased := Srv.BaseSrvID > 0;
  {lkSrvPage.Enabled := Act;
  lbSrvPage.Enabled := Act;
  lbGrpNum.Enabled := Act;
  edGrpNum.Enabled := Act;}
end;

procedure TProcessGridEditorFrame.btColsClick(Sender: TObject);
begin
  FOnEditGridCols(Self);
end;

procedure TProcessGridEditorFrame.btDeleteGridClick(Sender: TObject);
begin
  FOnDeleteGrid(Self);
end;

procedure TProcessGridEditorFrame.btGridCodeClick(Sender: TObject);
begin
  FOnEditGridCode(Self);
end;

procedure TProcessGridEditorFrame.btGridPropsClick(Sender: TObject);
begin
  OnEditGridProperties(Self);
end;

function TProcessGridEditorFrame.AllowLeaveEditor: boolean;
var
  CfgData: TProcessGridCfgData;
begin
  if Node <> nil then
  begin
    // Вносим изменения в исходный набор данных
    {if (FGridData <> nil) and FGridData.Modified then
      TConfigManager.Instance.ProcessGridCfgData.MergeData(FGridData);
    dsProcessGrids.DataSet := nil;
    FreeAndNil(FGridData);}
    CfgData := TConfigManager.Instance.ProcessGridCfgData;
    if CfgData.DataSet.State in [dsInsert, dsEdit] then
      CfgData.DataSet.Post;
  end;

  Result := true;
end;

function TProcessGridEditorFrame.GetPopupMenu: TPopupMenu;
begin
  Result := pmProcessGrid;
end;

end.
