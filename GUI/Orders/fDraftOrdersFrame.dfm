inherited DraftOrdersFrame: TDraftOrdersFrame
  inherited paOrdMain: TPanel
    inherited spOrders: TJvNetscapeSplitter
      ExplicitLeft = -109
      ExplicitHeight = 304
    end
    inherited paOrderLeft: TPanel
      Width = 204
      ExplicitWidth = 204
      inherited dgOrders: TMyDBGridEh
        Width = 204
      end
    end
    inherited panRight: TPanel
      inherited paParams: TPanel
        inherited paCommentButtons: TPanel
          inherited btAddComment2: TBitBtn
            OnClick = nil
          end
          inherited btRemoveComment2: TBitBtn
            OnClick = nil
          end
        end
        inherited paParamsControls: TPanel
          inherited edTirazz: TDBEdit
            OnChange = nil
            OnKeyPress = nil
          end
          inherited edComment: TDBEdit
            OnChange = nil
            OnKeyPress = nil
          end
          inherited edComment2: TDBEdit
            OnChange = nil
            OnKeyPress = nil
          end
        end
      end
    end
  end
end
