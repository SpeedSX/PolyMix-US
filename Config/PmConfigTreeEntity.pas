unit PmConfigTreeEntity;

interface

uses PmEntity;

type
   { Ничего не делает, нужна просто для отображения дерева конфигурации в табчике }
   TConfigTreeEntity = class(TEntity)
   public
     constructor Create; override;
     function TotalRecordCount: integer; override;
    function IsEmpty: boolean; override;
   end;

implementation

uses SysUtils;

{ TConfigTreeEntity }

constructor TConfigTreeEntity.Create;
begin
  inherited Create;
  FKeyField := 'ConfigTreeEntity';
end;

function TConfigTreeEntity.TotalRecordCount: integer;
begin
  Result := 1;
end;

function TConfigTreeEntity.IsEmpty: boolean;
begin
  Result := false;
end;

end.
