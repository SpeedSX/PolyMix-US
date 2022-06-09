inherited WorkOrdersFrame: TWorkOrdersFrame
  inherited paOrdMain: TPanel
    inherited spOrders: TJvNetscapeSplitter
      ExplicitLeft = 299
      ExplicitHeight = 571
    end
    inherited paOrderLeft: TPanel
      Width = 102
      ExplicitWidth = 102
      inherited dgOrders: TMyDBGridEh
        Width = 102
      end
    end
    inherited panRight: TPanel
      inherited paParams: TPanel
        inherited paParamsControls: TPanel
          inherited edComment2: TDBEdit
            OnKeyPress = nil
          end
        end
      end
      inherited paOrdInfo: TPanel
        inherited paOrdInfoTop: TPanel
          ExplicitLeft = 40
          ExplicitTop = 6
        end
      end
    end
  end
end
