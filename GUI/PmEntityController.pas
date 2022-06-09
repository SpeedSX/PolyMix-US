unit PmEntityController;

interface

uses Classes, DB, ADODB, Variants, Forms,

  JvFormPlacement, JvAppStorage,

  NotifyEvent, MainFilter, PmEntity, fBaseFrame, JvSpeedBar;

{$I calc.inc}

type
  TEntityController = class(TObject)
  private
    procedure AfterOpen_Handler(Sender: TObject);
  protected
    FSettingsID: TNotifyHandlerID;
    FEntity: TEntity;
    //FGrid: TOrderGridClass;
    FFilter: TFilterObj;
    FReadOnly: boolean;
    FCaption: string;
    //FMainStorage: TJvFormStorage;
    FFrame: TBaseFrame;
    //FAfterRefresh: TNotifier;
    FAfterRefresh: TNotifyEvent;
    FOpenID: TNotifyHandlerID;
    FOnCloseMe: TNotifyEvent;
    procedure DoBeforeEditEntityProperties; virtual;
    procedure DoAfterOpen; virtual;
    procedure HandleSettingsChanged(Sender: TObject);
    procedure SettingsChanged; virtual;
  public
    constructor Create(_Entity: TEntity); virtual;
    destructor Destroy; override;
    function Visible: boolean; virtual; abstract;
    //function Modified: boolean; virtual;
    //procedure EditCurrent; virtual; abstract;
    //procedure CancelCurrent; virtual; abstract;

    //procedure DeleteCurrent(Confirm: boolean); virtual; abstract;
    function CreateFrame(Owner: TComponent): TBaseFrame; virtual; abstract;
    // Вызывается при входе на страницу
    procedure Activate; virtual;
    // Вызывается при выходе из страницы и перед закрытием
    procedure Deactivate(var AllowLeave: boolean); virtual;
    procedure LoadSettings; virtual;
    procedure SaveSettings; virtual;
    procedure ImportData; virtual;
    procedure RefreshData; virtual;
    function GetFilterPhrase: string; virtual;
    function Description: string; virtual;
    function GetToolbar: TJvSpeedBar; virtual; abstract;
    function CanClose: boolean; virtual;
    // Выводит отчет. AllowInside означает, что отчет доступен в режиме редактирования.
    procedure PrintReport(ReportKey: integer; AllowInside: boolean); virtual;

    property Entity: TEntity read FEntity;
    property ReadOnly: boolean read FReadOnly;
    property Caption: string read FCaption;
    //property MainStorage: TJvFormStorage read FMainStorage write FMainStorage;
    property Frame: TBaseFrame read FFrame write FFrame;
    //property AfterRefresh: TNotifier read FAfterRefresh;
    property AfterRefresh: TNotifyEvent read FAfterRefresh write FAfterRefresh;
    // Запрос на закрытие этого отображения
    property OnCloseMe: TNotifyEvent read FOnCloseMe write FOnCloseMe;
  end;

  TEntityControllerClass = class of TEntityController;

  // Not implemented
  TContractView = class(TEntityController)
    //function Visible: boolean; override;
    procedure EditCurrent;
  end;

implementation

uses Controls, SysUtils, FileCtrl, JvJclUtils, TLoggerUnit, DateUtils,

  RDialogs, Dialogs, CalcSettings;

{$REGION 'TEntityView'}

constructor TEntityController.Create(_Entity: TEntity);
begin
  inherited Create;
  FEntity := _Entity;
  FOpenID := FEntity.OpenNotifier.RegisterHandler(AfterOpen_Handler);
  FSettingsID := TSettingsManager.Instance.SettingsChanged.RegisterHandler(HandleSettingsChanged);
  //FAfterRefresh := TNotifier.Create;
end;

destructor TEntityController.Destroy;
begin
  //FAfterRefresh.Free;
  FEntity.OpenNotifier.UnregisterHandler(FOpenID);
  if TSettingsManager.Instance.SettingsChanged <> nil then
    TSettingsManager.Instance.SettingsChanged.UnregisterHandler(FSettingsID);
  inherited;
end;

procedure TEntityController.DoBeforeEditEntityProperties;
begin
end;

procedure TEntityController.Activate;
begin
end;

procedure TEntityController.Deactivate(var AllowLeave: boolean);
begin
  AllowLeave := true;
end;

procedure TEntityController.LoadSettings;
begin
  if FFrame <> nil then // на всякий аварийный
    FFrame.LoadSettings;
end;

procedure TEntityController.SaveSettings;
begin
  if FFrame <> nil then // на всякий аварийный
    FFrame.SaveSettings;
  // сохраняется фильтр  
  if (FFilter <> nil) and (FEntity <> nil) then
    FFilter.StoreFilter(TSettingsManager.Instance.Storage, iniFilter + FEntity.InternalName);
end;

procedure TEntityController.ImportData;
begin
end;

procedure TEntityController.AfterOpen_Handler(Sender: TObject);
begin
  DoAfterOpen;
  //FAfterRefresh.Notify(Self);
  if Assigned(FAfterRefresh) then FAfterRefresh(FEntity);
end;

procedure TEntityController.DoAfterOpen;
begin
end;

procedure TEntityController.RefreshData;
begin
  FEntity.Reload;
end;

function TEntityController.GetFilterPhrase: string;
begin
  Result := FFilter.GetFilterPhrase(FEntity);
end;

function TEntityController.Description: string;
begin
  Result := '';
end;

function TEntityController.CanClose: boolean;
var
  Allow: boolean;
begin
  Allow := true;
  Deactivate(Allow);
  Result := Allow;
end;

procedure TEntityController.PrintReport(ReportKey: integer; AllowInside: boolean);
begin
end;

procedure TEntityController.HandleSettingsChanged(Sender: TObject);
begin
  SettingsChanged;
  FFrame.SettingsChanged;
end;

procedure TEntityController.SettingsChanged;
begin

end;

{$ENDREGION}

// ----- TContractView -----

procedure TContractView.EditCurrent;
begin
{$IFNDEF NoDocs}
    EditDoc(dmd.cdContract, qiContract, true);  // редактирование текста документа
{$ENDIF}
end;

end.
