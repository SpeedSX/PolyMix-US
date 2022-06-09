unit PmProcessEditorFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PmBaseConfigEditorFrame, JvExControls, JvGradientHeaderPanel,
  Buttons, StdCtrls, DBCtrls, Mask, JvExMask, JvSpin, JvDBSpinEdit, GridsEh,
  DBGridEh, MyDBGridEh, ExtCtrls, DB, DBClient, Menus,

  RDBUtils, PmConfigManager, PmConfigTree, PmConfigObjects, PmProcessCfg;

type
  TProcessEditorFrame = class(TBaseConfigEditorFrame)
    paProcessParams: TPanel;
    Panel13: TPanel;
    btEditSrv: TButton;
    btCode: TBitBtn;
    btStruct: TBitBtn;
    btCreateTriggers: TBitBtn;
    pmProcess: TPopupMenu;
    N10: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N11: TMenuItem;
    miExportProcess: TMenuItem;
    N6: TMenuItem;
    miDelete: TMenuItem;
    N1: TMenuItem;
    btAddGrid: TSpeedButton;
    N2: TMenuItem;
    procedure btEditSrvClick(Sender: TObject);
    procedure btCodeClick(Sender: TObject);
    procedure btStructClick(Sender: TObject);
    procedure btCreateTriggersClick(Sender: TObject);
    procedure miDeleteClick(Sender: TObject);
    procedure miExportProcessClick(Sender: TObject);
    procedure btAddGridClick(Sender: TObject);
  private
    FOnAddProcess, FOnDeleteProcess, FOnModifyStructure, FOnEditCode, FOnEditProperties: TNotifyEvent;
    FOnCreateTriggers, FOnExportProcess: TNotifyEvent;
    FOnAddGrid: TNotifyEvent;
    //FGridData: TClientDataSet;
  protected
    procedure SetNode(ANode: TMVCNode); override;
  public
    destructor Destroy; override;
    function GetPopupMenu: TPopupMenu; override;
    function AllowLeaveEditor: boolean; override;

    property OnAddProcess: TNotifyEvent read FOnAddProcess write FOnAddProcess;
    property OnDeleteProcess: TNotifyEvent read FOnDeleteProcess write FOnDeleteProcess;
    property OnExportProcess: TNotifyEvent read FOnExportProcess write FOnExportProcess;
    property OnModifyStructure: TNotifyEvent read FOnModifyStructure write FOnModifyStructure;
    property OnEditCode: TNotifyEvent read FOnEditCode write FOnEditCode;
    property OnEditProperties: TNotifyEvent read FOnEditProperties write FOnEditProperties;
    property OnCreateTriggers: TNotifyEvent read FOnCreateTriggers write FOnCreateTriggers;

    property OnAddGrid: TNotifyEvent read FOnAddGrid write FOnAddGrid;
  end;

implementation

{$R *.dfm}

destructor TProcessEditorFrame.Destroy;
begin
  //dsProcessGrids.DataSet := nil;
  //FreeAndNil(FGridData);
  inherited;
end;

procedure TProcessEditorFrame.btAddGridClick(Sender: TObject);
begin
  FOnAddGrid(Self);
end;

procedure TProcessEditorFrame.btCodeClick(Sender: TObject);
begin
  FOnEditCode(Self);
end;

procedure TProcessEditorFrame.btCreateTriggersClick(Sender: TObject);
begin
  FOnCreateTriggers(Self);
end;

procedure TProcessEditorFrame.btEditSrvClick(Sender: TObject);
begin
  FOnEditProperties(Self);
end;

procedure TProcessEditorFrame.btStructClick(Sender: TObject);
begin
  FOnModifyStructure(Self);
end;

procedure TProcessEditorFrame.SetNode(ANode: TMVCNode);
var
  en, IsBased, Act: boolean;
  Srv: TPolyProcessCfg;
begin
  inherited SetNode(ANode);

  Srv := TConfigManager.Instance.ServiceByID((ANode as TCfgProcess).ProcessID);
  Act := Srv.IsActive;
  IsBased := Srv.BaseSrvID > 0;
  btCode.Enabled := not IsBased and Act;
  if Act then
  begin
    btStruct.Enabled := (Srv <> nil) and not IsBased;
  end
  else
    btStruct.Enabled := false;

  //TConfigManager.Instance.ProcessGridCfgData.SetProcessFilter(Srv.SrvID);
  //FGridData := TConfigManager.Instance.ProcessGridCfgData.CopyData(false);
  //dsProcessGrids.DataSet := FGridData;
  //TConfigManager.Instance.ProcessGridCfgData.ResetFilter;
end;

function TProcessEditorFrame.GetPopupMenu: TPopupMenu;
begin
  Result := pmProcess;
end;

procedure TProcessEditorFrame.miDeleteClick(Sender: TObject);
begin
  FOnDeleteProcess(Self);
end;

procedure TProcessEditorFrame.miExportProcessClick(Sender: TObject);
begin
  FOnExportProcess(Self);
end;

function TProcessEditorFrame.AllowLeaveEditor: boolean;
begin
  {if Node <> nil then
  begin
    // Вносим изменения в исходный набор данных
    if (FGridData <> nil) and FGridData.Modified then
      TConfigManager.Instance.ProcessGridCfgData.MergeData(FGridData);
    dsProcessGrids.DataSet := nil;
    FreeAndNil(FGridData);
  end;}

  Result := true;
end;

end.
