unit PmStates;

interface

uses Classes, Graphics, DB, DicObj;

type
  TOrderState = class(TObject)
    Code: integer;
    Graphic: TBitmap;
    DisabledGraphic: TBitmap;
    RowColorCode: integer;
    Text: string;
    IsFinal: boolean;
    destructor Destroy; override;
  end;

procedure UpdateOrderStates(var OrdStateList: TStringList;
  Dic: TDictionary;
  var DefState: variant;
  ColorFieldIndex, ImageFieldIndex, FileFieldIndex, DisImageFieldIndex,
  DisFileFieldIndex, IsDefaultFieldIndex, IsFinalOrderStateFieldIndex: integer);

procedure DoneOrderStates(var OrdSt: TStringList);

implementation

uses SysUtils, Variants, RDBUtils, JvJCLUtils;

destructor TOrderState.Destroy;
begin
  if Graphic <> nil then Graphic.Free;
  inherited Destroy;
end;

procedure UpdateOrderStates(var OrdStateList: TStringList;
  Dic: TDictionary;
  var DefState: variant;
  ColorFieldIndex, ImageFieldIndex, FileFieldIndex, DisImageFieldIndex,
  DisFileFieldIndex, IsDefaultFieldIndex, IsFinalOrderStateFieldIndex: integer);
var
  os: TOrderState;
  ss: string;
  HexColor: boolean;
begin
  // �������, ���� ���
  if (OrdStateList <> nil) and (OrdStateList.Count > 0) then
    DoneOrderStates(OrdStateList);
  // �������, ���� �� ���� ��� �������
  if OrdStateList = nil then
    OrdStateList := TStringList.Create;
  // ���� ���� ����� ���������, �� �������������� ��� HEX(RGB)-��� �����
  HexColor := false;//Dic.CurrentValue[ColorFieldName];
  DefState := null;
  Dic.DicItems.First;
  while not Dic.DicItems.eof do
  try
    ss := IntToStr(Dic.CurrentCode);
    os := TOrderState.Create;
    os.Code := Dic.CurrentCode;
    os.Text := Dic.CurrentName;
    if not VarIsNull(Dic.CurrentValue[ColorFieldIndex]) then
    begin
      if HexColor then
        try os.RowColorCode := Hex2Dec(Dic.CurrentValue[ColorFieldIndex])
        except os.RowColorCode := 0; end
      else os.RowColorCode := Dic.CurrentValue[ColorFieldIndex]
    end else
      os.RowColorCode := 0;

    // ���� �������� ��������� �� ���������
    if IsDefaultFieldIndex <> 0 then
    begin
      if NvlBoolean(Dic.CurrentValue[IsDefaultFieldIndex]) then
        DefState := Dic.CurrentCode;
    end;

    // �������� �� ����������� ����������
    if IsFinalOrderStateFieldIndex > 0 then
      os.IsFinal := NvlBoolean(Dic.CurrentValue[IsFinalOrderStateFieldIndex]);

    // �����������
    if not Dic.CurrentIsNull[ImageFieldIndex] then
    begin
      os.Graphic := TBitmap.Create;
      Dic.LoadImage(os.Graphic, ImageFieldIndex);
      // ��������� ������ ������ �������� Win98|Me (������? - �����, �������� ������)
      //os.Graphic.Assign(dq.FieldByName(ImageFieldName));
      // �������� �������� �� �������, ���� ���� ���� � ������ �����
    end else if {(dq.FindField(FileFieldName) <> nil)
        and }not Dic.CurrentIsNull[FileFieldIndex] and (Dic.CurrentValue[FileFieldIndex] <> '') then
      try
        os.Graphic := TBitmap.Create;
        os.Graphic.LoadFromResourceName(hInstance, AnsiUpperCase(Dic.CurrentValue[FileFieldIndex]));
      except
        if os.Graphic <> nil then
        begin
          os.Graphic.Free;
          os.Graphic := nil;
        end;
      end;

    if DisImageFieldIndex <> 0 then
    begin
      // ���������� � ���������� ������������
      if not Dic.CurrentIsNull[DisImageFieldIndex] then
      begin
        os.DisabledGraphic := TBitmap.Create;
        Dic.LoadImage(os.DisabledGraphic, DisImageFieldIndex);
        //os.DisabledGraphic.Assign(dq.FieldByName(DisImageFieldName));
        // �������� �������� �� �������, ���� ���� ���� � ������ �����
      end else if {(dq.FindField(DisFileFieldName) <> nil)
          and }not VarIsNull(Dic.CurrentValue[DisFileFieldIndex])
          and (Dic.CurrentValue[DisFileFieldIndex] <> '') then
        try
          os.DisabledGraphic := TBitmap.Create;
          os.DisabledGraphic.LoadFromResourceName(hInstance, AnsiUpperCase(Dic.CurrentValue[DisFileFieldIndex]));
        except
          if os.DisabledGraphic <> nil then
          begin
            os.DisabledGraphic.Free;
            os.DisabledGraphic := nil;
          end;
        end;
    end;

    // ������ ����������� ������ ����������� � ��������� TOrderState
    OrdStateList.AddObject(ss, os);
  finally
    Dic.DicItems.Next;
  end;
end;

procedure DoneOrderStates(var OrdSt: TStringList);
var
  i: integer;
begin
  if OrdSt <> nil then begin
    if OrdSt.Count > 0 then
      for i := 0 to Pred(OrdSt.Count) do
        if OrdSt.Objects[i] <> nil then
          OrdSt.Objects[i].Free;
    OrdSt.Free;
    OrdSt := nil;
  end;
end;

end.
