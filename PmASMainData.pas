unit PmASMainData;

interface

uses
  SysUtils, Classes, Provider, DB, ADODB;

type
  TSrvDM = class(TDataModule)
    aqItemMaterial: TADOQuery;
    aqItemOperation: TADOQuery;
    pvItemMaterial: TDataSetProvider;
    pvItemOperation: TDataSetProvider;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SrvDM: TSrvDM;

implementation

{$R *.dfm}

end.
