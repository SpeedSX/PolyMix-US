unit RAI2_SrvPage;

interface

uses JvInterpreter, JvInterpreterFm, Forms, Classes, ComCtrls, CalcUtils;

procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);

var
  ScriptFrame: TFrame;
  ScriptPageGrids: TList;
  ScriptPage: TPageClass;
  ScriptSetActiveControl: boolean;

implementation

uses ServData, JvInterpreter_Reports, MainForm;

procedure RAI2_Frame(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(ScriptFrame);
end;

procedure RAI2_PageServices(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(ScriptPageGrids);
end;

procedure RAI2_Page(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(ScriptPage);
end;

procedure RAI2_SetActiveControl(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptSetActiveControl;
end;

procedure TFrame_FindChildControl(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TFrame(Args.Obj).FindChildControl(string(Args.Values[0])));
end;

procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter );
begin
  with JvInterpreterAdapter do
  begin
    AddClass('SrvPages', TFrame, 'TFrame');
    AddGet(TFrame, 'FindChildControl', TFrame_FindChildControl, 1, [varEmpty], varEmpty);
    AddFunction('SrvPages', 'PageFrame', RAI2_Frame, 0, [0], varEmpty);
    AddFunction('SrvPages', 'PageGrids', RAI2_PageServices, 0, [0], varEmpty);
    AddFunction('SrvPages', 'Page', RAI2_Page, 0, [0], varEmpty);
    AddFunction('SrvPages', 'SetActiveControl', RAI2_SetActiveControl, 0, [0], varEmpty);
  end;
end;

end.
