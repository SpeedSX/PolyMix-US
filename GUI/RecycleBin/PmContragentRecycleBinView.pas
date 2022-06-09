unit PmContragentRecycleBinView;

interface

uses Classes, fBaseRecycleBin, fContragentRecycleBin, PmBaseRecycleBinView,
  PmEntity;

type
  TContragentRecycleBinView = class(TBaseRecycleBinView)
  protected
    function DoCreateFrame(Owner: TComponent): TBaseRecycleBinFrame; override;
  public
    constructor Create(_Entity: TEntity); override;
  end;

implementation

constructor TContragentRecycleBinView.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  FCaption := 'Удаленные контрагенты';
end;

function TContragentRecycleBinView.DoCreateFrame(Owner: TComponent): TBaseRecycleBinFrame;
begin
  Result := TContragentRecycleBinFrame.Create(Owner, RecycleBin);
end;

end.

