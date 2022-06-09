unit UpdData;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  Tudm = class(TDataModule)
    aqImage: TADOQuery;
    aqImageFileID: TAutoIncField;
    aqImageFileName: TStringField;
    aqImageFileVersion: TIntegerField;
    aqImageFileDate: TDateTimeField;
    aqImageFileImage: TBlobField;
    aqClear: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  udm: Tudm;

implementation

{$R *.dfm}

end.
