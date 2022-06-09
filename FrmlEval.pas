unit FrmlEval;

interface

const
  NameSeparator = ':';
  ToPayName = '�������';
  ProdName = '����';

function EvalFormula(Expr: string; ToPay, Prod: extended; var Res: extended): boolean;
function GetFormulaComment(s: string): string;
function GetFormulaText(s: string): string;

implementation

uses SysUtils, JvJCLUtils, JvParsing;

function GetFormulaComment(s: string): string;
begin
  Result := DelRSpace(ExtractWord(1, s, [NameSeparator]));
end;

function GetFormulaText(s: string): string;
var p: integer;
begin
  p := Pos(NameSeparator, s);
  if p <> 0 then begin
    if p = length(s) then Exit;
    Result := DelRSpace(copy(s, p + 1, length(s) - p));
  end else
    Result := s;
end;

function EvalFormula(Expr: string; ToPay, Prod: extended; var Res: extended): boolean;
var
  p, i: integer;
  s, s1, snew: string;
  v1: extended;
begin
  Result := false;
  try
    s := DelSpace(Expr);
    if s = '' then Exit;
    s := AnsiUpperCase(GetFormulaText(s));    // ������� �������� �������
    s := ReplaceStr(s, ToPayName, FloatToStr(ToPay));  // �������� ����� � ������ �� ��������
    s := ReplaceStr(s, ProdName, FloatToStr(Prod));  // �������� ��������� ��-�� �� ��������
    while true do begin
      snew := '';
      p := pos('%', s);        // ����� ���� ��������, ������ ���� ������� �����
      if p = 1 then Exit;
      if p = 0 then break;  // ����� �� �����
      s1 := '';
      for i := p - 1 downto 1 do
        if (s[i] = DecimalSeparator) or (s[i] in ['0'..'9', 'e', 'E']) then
          s1 := s[i] + s1                          //  �.�. ���� ������ ������
        else break;                  // ���� �� ��������� �� "�� �����"
      if i <= 1 then Exit;
      try
        v1 := StrToFloat(s1);     // ������������� ����� ���������
      except Exit end;
      if s[i] = '-' then v1 := 1.0 - v1 / 100.0
      else if s[i] = '+' then v1 := 1.0 + v1 / 100.0
      else Exit;
      // �������� ����� ������ �� ����� ��������, ��������� ���� ��������� � �����
      snew := snew + copy(s, 1, i - 1) + '*' + FloatToStr(v1);
      if p < length(s) then    // ��������� ���������� ����� ������
        s := Copy(s, p + 1, Length(s) - p) else s := '';
      s := snew + s;
    end;
    try
      Res := GetFormulaValue(s);
      Result := true;
    except end;
  except end;
end;

end.
