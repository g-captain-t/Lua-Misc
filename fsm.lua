--[[
    
    Hmm....
    -- FSM.new(events, initialstate)

    local alert = FSM.new(
    {
        ["warn"] = {from="green"; to="yellow"};
        ["panic"] = {from="yellow"; to="red"};
        ["calm"] = {from="red"; to="yellow"};
        ["clear"] = {from="yellow"; to="green"};
    },
    "green"
    )

    alert.warn()
    print(alert.current)
    alert.clear()

    alert.StateChanged:Connect(function(newstate, oldstate, event)
        print(newstate)
    end)
    
]]

local FSM = {}

function FSM.new(events, initial)
    local self = {}
    self._changed = Instance.new("BindableEvent")
    self.StateChanged = self._changed.Event
    self.current = initial
    self._events = events

    for event, changes in pairs (events) do 
        self[event] = function()
            if self.current == changes.from then 
                self.current = changes.to
                self._changed:Fire(changes.to, changes.from, event)
            end
        end
    end

    self.Destroy = function(self)
        self._changed:Destroy()
        self._events = nil
        self = nil
    end

    return self
end

return FSM
