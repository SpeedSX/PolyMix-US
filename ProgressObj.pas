unit ProgressObj;

interface

uses JvProgressBar, Forms;

type
  TProgressObj = class(TObject)
  private
    FProgressBar: TjvProgressBar;
    procedure SetMin(Value: integer);
    function GetMin: integer;
    procedure SetMax(Value: integer);
    function GetMax: integer;
    procedure SetPosition(Value: integer);
    function GetPosition: integer;
    procedure SetVisible(Value: boolean);
    function GetVisible: boolean;
    procedure SetProgressBar(Value: TjvProgressBar);
  public
    property ProgressBar: TjvProgressBar read FProgressBar write SetProgressBar;
    property Min: integer read GetMin write SetMin;
    property Max: integer read GetMax write SetMax;
    property Position: integer read GetPosition write SetPosition;
    property Visible: boolean read GetVisible write SetVisible;
  end;

implementation

procedure TProgressObj.SetMin(Value: integer);
begin
  ProgressBar.Min := Value;
end;

function TProgressObj.GetMin: integer;
begin
  Result := ProgressBar.Min;
end;

procedure TProgressObj.SetMax(Value: integer);
begin
  ProgressBar.Max := Value;
end;

function TProgressObj.GetMax: integer;
begin
  Result := ProgressBar.Max;
end;

procedure TProgressObj.SetPosition(Value: integer);
begin
  ProgressBar.Position := Value;
end;

function TProgressObj.GetPosition: integer;
begin
  Result := ProgressBar.Position;
end;

procedure TProgressObj.SetVisible(Value: boolean);
begin
  ProgressBar.Visible := Value;
  (ProgressBar.Owner as TFrame).Update;
end;

function TProgressObj.GetVisible: boolean;
begin
  Result := ProgressBar.Visible;
end;

procedure TProgressObj.SetProgressBar(Value: TjvProgressBar);
begin
  FProgressBar := Value;
end;

end.
