unit JvInterpreter_Settings;

interface

uses JvInterpreter;

procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);

implementation

uses PmEntSettings;

type
  TEntSettingsClass = class(TObject)
  end;

var
  EntSettingsObj: TEntSettingsClass;

procedure RAI2_GetEntSettings(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(EntSettingsObj);
end;

procedure TEntSettings_NewPlanInterface(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := EntSettings.NewPlanInterface;
end;

procedure TEntSettings_NativeCurrency(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := EntSettings.NativeCurrency;
end;

procedure TEntSettings_VATPercent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := EntSettings.VATPercent;
end;

procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);
begin
  with JvInterpreterAdapter do
  begin
    AddFunction('EntSettings', 'EntSettings', RAI2_GetEntSettings, 0, [0], varEmpty);
    AddClass('PmEntSettings', TEntSettingsClass, 'TEntSettings');
    AddGet(TEntSettingsClass, 'NewPlanInterface', TEntSettings_NewPlanInterface, 0, [0], varEmpty);
    AddGet(TEntSettingsClass, 'NativeCurrency', TEntSettings_NativeCurrency, 0, [0], varEmpty);
    AddGet(TEntSettingsClass, 'VATPercent', TEntSettings_VATPercent, 0, [0], varEmpty);
 end;
end;

end.
