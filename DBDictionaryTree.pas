unit DBDictionaryTree;

interface

uses
  DBVirtualStringTree, Classes;

type
  TDBDictionaryTree = class(TDBVirtualStringTree)
    private
    protected
    public
      constructor Create(AOwner:TComponent); override;
  end;
implementation
  constructor TDBDictionaryTree.Create(AOwner:TComponent);
  begin
    inherited Create(AOwner);
  end;
end.
