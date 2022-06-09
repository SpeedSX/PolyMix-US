unit PmOrderRecycleBinView;

interface

uses Classes, fBaseRecycleBin, fOrderRecycleBin, PmBaseRecycleBinView,
  PmRecycleBin, PmEntity;

type
  TOrderRecycleBinView = class(TBaseRecycleBinView)
  protected
    function DoCreateFrame(Owner: TComponent): TBaseRecycleBinFrame; override;
    procedure DoRestoreSelected(Sender: TObject); override;
  public
    constructor Create(_Entity: TEntity); override;
  end;

implementation

uses SysUtils, Dialogs,

  RDialogs, CalcSettings, CalcUtils;

constructor TOrderRecycleBinView.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  FCaption := 'Удаленные заказы';
end;

function TOrderRecycleBinView.DoCreateFrame(Owner: TComponent): TBaseRecycleBinFrame;
begin
  Result := TOrderRecycleBinFrame.Create(Owner, RecycleBin);
end;

procedure TOrderRecycleBinView.DoRestoreSelected(Sender: TObject);
var
  NewIds, OldIds: TIntArray;
  I: Integer;
begin
  inherited DoRestoreSelected(Sender);

  NewIds := TOrderRecycleBin(RecycleBin).RestoredIDNumbers;
  OldIds := TOrderRecycleBin(RecycleBin).OldIDNumbers;

  for I := Low(NewIds) to High(NewIds) do
  begin
    if NewIDs[I] <> OldIDs[I] then
      RusMessageDlg('Восстановленному заказу ' + IntToStr(OldIds[I])
        + ' присвоен номер ' + IntToStr(NewIDs[I]),
        mtInformation, [mbOk], 0);
  end;
end;

end.
