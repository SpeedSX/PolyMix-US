unit fDiff;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fDiffBase, Menus, ComCtrls, ExtCtrls;

type
  TDiffForm = class(TDiffBaseForm)
    procedure FormActivate(Sender: TObject);
  private
    FFile1: string;
    FFile2: string;
    FFilesLoaded: boolean;
    { Private declarations }
  public
    property File1: string read FFile1 write FFile1;
    property File2: string read FFile2 write FFile2;
  end;

var
  DiffForm: TDiffForm;

implementation

{$R *.dfm}

procedure TDiffForm.FormActivate(Sender: TObject);
begin
  inherited;
  if not FFilesLoaded then begin
    DoOpenFile(FFile1, true);
    DoOpenFile(FFile2, false);
    Compare;
    FFilesLoaded := true;
  end;
end;

end.
