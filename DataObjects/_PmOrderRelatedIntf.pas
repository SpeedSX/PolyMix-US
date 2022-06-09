unit PmOrderRelatedIntf;

interface
type
  IOrderRelated = interface(IUnknown)
    ['{1db77170-2d83-11dd-bd0b-0800200c9a66}']
    function GetOrderPrefix: string;
    property NumberField: string read GetNumberField;
  end;

implementation

end.
