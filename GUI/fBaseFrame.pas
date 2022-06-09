unit fBaseFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, jvFormPlacement, ExtCtrls,

  MainFilter, fBaseFilter, PmEntity;

type
  TBaseFrame = class(TFrame)
    paFilter: TPanel;
  private
    FFilterFrame: TBaseFilterFrame;
    //FFilterEnabled: boolean;
    FOnFilterChange: TFilterEvent;
    FOnDisableFilter: TFilterEvent;
    FOnHideFilter: TNotifyEvent; // Ќ≈ »—ѕќЋ№«”≈“—я
    FShowFilterPanel: boolean;
    FEntity: TEntity;
    procedure FilterChange;
    procedure DisableFilter;
    procedure HideFilter(Sender: TObject);
    procedure ShowFilterChanged;
    procedure SetFilterObject(Value: TFilterObj);
    function GetFilterObject: TFilterObj;
    procedure SetShowFilterPanel(_Value: boolean);
  protected
    property FilterFrame: TBaseFilterFrame read FFilterFrame;
    function GetIniSection: string; virtual;

    //property FormStorage: TJvFormPlacement read FMainStorage;
  public
    // если установить в true, то создает фрейм фильтра, если false, то пр€чет панель фильтра!
    //property FilterEnabled: boolean read FFilterEnabled write SetFilterEnabled;

    property FilterObject: TFilterObj read GetFilterObject write SetFilterObject;

    constructor Create(Owner: TComponent; _Entity: TEntity{; _Name: string}); virtual;
    procedure AfterCreate; virtual;
    procedure OpenData; virtual;
    procedure SaveSettings; virtual;
    procedure LoadSettings; virtual;
    function CreateFilterFrame: TBaseFilterFrame; virtual;
    procedure SettingsChanged; virtual;

    property Entity: TEntity read FEntity;
    property OnFilterChange: TFilterEvent read FOnFilterChange write FOnFilterChange;
    property OnDisableFilter: TFilterEvent read FOnDisableFilter write FOnDisableFilter;
    property ShowFilterPanel: boolean read FShowFilterPanel write SetShowFilterPanel;
    
    // Ќ≈ »—ѕќЋ№«”≈“—я
    property OnHideFilter: TNotifyEvent read FOnHideFilter write FOnHideFilter;
  end;

  TBaseFrameClass = class of TBaseFrame;

implementation

uses DateUtils, CalcSettings, CalcUtils;

{$R *.dfm}

constructor TBaseFrame.Create(Owner: TComponent; _Entity: TEntity{; _Name: string});
begin
  inherited Create(Owner);
  FEntity := _Entity;
  //Name := _Name;
  Name := GetComponentName(Owner, _Entity.InternalName);
end;

procedure TBaseFrame.AfterCreate;
begin
end;

procedure TBaseFrame.OpenData;
begin
end;

procedure TBaseFrame.SaveSettings;
begin
  TSettingsManager.Instance.Storage.WriteInteger(GetIniSection + '\ShowFilter', Ord(FShowFilterPanel));
end;

procedure TBaseFrame.LoadSettings;
begin
  try
    FShowFilterPanel := TSettingsManager.Instance.Storage.ReadInteger(GetIniSection + '\ShowFilter', 1) = 1;
  except
    FShowFilterPanel := true;
  end;
end;

function TBaseFrame.GetFilterObject: TFilterObj;
begin
  if FFilterFrame = nil then Result := nil
  else Result := FFilterFrame.FilterObj;
end;

procedure TBaseFrame.SetFilterObject(Value: TFilterObj);
begin
  if (FFilterFrame = nil) and (Value <> nil) then
  begin
      // —оздаем фрейм фильтра
      FFilterFrame := CreateFilterFrame;
      paFilter.Width := FFilterFrame.Width + 2;
      FFilterFrame.Parent := paFilter;
      FFilterFrame.OnCreate;
      FFilterFrame.OnFilterChange := FilterChange;
      FFilterFrame.OnDisableFilter := DisableFilter;
      FFilterFrame.OnHideFrame := HideFilter;
      //FFilterFrame.AppStorage := FMainStorage.AppStorage;
      FFilterFrame.FilterObj := Value;

      FFilterFrame.Activate;
  end
  else
  if FFilterFrame <> nil then
    FFilterFrame.FilterObj := Value;

  paFilter.Visible := Value <> nil;
  FShowFilterPanel := Value <> nil;
end;

function TBaseFrame.CreateFilterFrame: TBaseFilterFrame;
begin
  Result := nil;
end;

function TBaseFrame.GetIniSection: string;
begin
  Result := Name;
end;

procedure TBaseFrame.HideFilter(Sender: TObject);
begin
  ShowFilterPanel := false;
end;

procedure TBaseFrame.SetShowFilterPanel(_Value: boolean);
begin
  FShowFilterPanel := _Value;
  ShowFilterChanged;
end;

procedure TBaseFrame.ShowFilterChanged;
begin
  paFilter.Visible := FShowFilterPanel;
end;

procedure TBaseFrame.FilterChange;
begin
  FOnFilterChange;
end;

procedure TBaseFrame.DisableFilter;
begin
  FOnDisableFilter;
end;

procedure TBaseFrame.SettingsChanged;
begin

end;

end.
