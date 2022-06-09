unit FrmlEval;

interface

const
  NameSeparator = ':';
  ToPayName = 'КОПЛАТЕ';
  ProdName = 'ПРВО';

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
    s := AnsiUpperCase(GetFormulaText(s));    // Удаляем название формулы
    s := ReplaceStr(s, ToPayName, FloatToStr(ToPay));  // Заменяем суммы к оплате на значение
    s := ReplaceStr(s, ProdName, FloatToStr(Prod));  // Заменяем стоимость пр-ва на значение
    while true do begin
      snew := '';
      p := pos('%', s);        // нашли знак процента, теперь надо считать число
      if p = 1 then Exit;
      if p = 0 then break;  // выход из цикла
      s1 := '';
      for i := p - 1 downto 1 do
        if (s[i] = DecimalSeparator) or (s[i] in ['0'..'9', 'e', 'E']) then
          s1 := s[i] + s1                          //  т.к. идем справа налево
        else break;                  // пока не наткнемся на "не цифру"
      if i <= 1 then Exit;
      try
        v1 := StrToFloat(s1);     // преобразовали число процентов
      except Exit end;
      if s[i] = '-' then v1 := 1.0 - v1 / 100.0
      else if s[i] = '+' then v1 := 1.0 + v1 / 100.0
      else Exit;
      // Копируем часть строки до знака операции, добавляем знак умножения и число
      snew := snew + copy(s, 1, i - 1) + '*' + FloatToStr(v1);
      if p < length(s) then    // Добавляем оставшуюся часть строки
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
