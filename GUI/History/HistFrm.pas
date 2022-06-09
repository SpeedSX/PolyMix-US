unit HistFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGridEh, MyDBGridEh, JvComponent, JvFormPlacement,
  StdCtrls, ExtCtrls, DB, ADODB, Provider, DBClient, JvAppStorage,
  JvComponentBase, GridsEh, Buttons, DBGridEhGrouping;

type
  THistoryForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    FormStorage: TJvFormStorage;
    dgHistory: TMyDBGridEh;
    Panel3: TPanel;
    btClose: TButton;
    dsHistory: TDataSource;
    btRefresh: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure btRefreshClick(Sender: TObject);
  private
    WasActive: boolean;
    procedure SetMainStorage(Value: TJvCustomAppStorage);
  protected
    // Здесь не делает ничего. Для унаследованных классов.
    procedure DoFormActivate; virtual;
    // Здесь не делает ничего. Для унаследованных классов.
    procedure DoRefreshHistory; virtual;
  public
    property MainStorage: TJvCustomAppStorage write SetMainStorage;

    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

procedure THistoryForm.btRefreshClick(Sender: TObject);
begin
  DoRefreshHistory;
end;

constructor THistoryForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure THistoryForm.FormActivate(Sender: TObject);
begin
  if not WasActive then   // activate only once
    DoFormActivate;
end;

procedure THistoryForm.SetMainStorage(Value: TJvCustomAppStorage);
begin
  FormStorage.AppStorage := Value;
end;

procedure THistoryForm.DoFormActivate;
begin
end;

procedure THistoryForm.DoRefreshHistory;
begin
end;

end.
