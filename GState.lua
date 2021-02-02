--[[

GState 
A quick state library than can be used globally (replicates from server to client)

API

function GState.new(keyvalues, globalname)
function GState.Subscribe(name) --> State.Changed RBXScriptSignal
function GState.GetGlobalState(name) 

State.State -> dictionary
State.Changed -> key, value

function State:Get(array keys)
function State:GetState()
function State:Set(dictionary keyvalue or tuple key, value)
function State:RawSet(dictionary keyvalue or tuple key, value)
function State:Increment(key, optional increment)
function State:Toggle(key, optional bool)
function State:GetKeyChangedSignal(key)
function State:GetChangedSignal()
function State:Destroy()

]]

local RunService = game:GetService("RunService")

local function context() 
    return RunService:IsClient() and "Client" or "Server"
end

-- GState
local GState = {}
GState.GlobalStates = {}
GState._changedremotes = {} -- 
local State = {}
State.__index = State

function GState.new(keyvalues, globalname)
    local self = {}
    setmetatable(self,State)

    self.State = keyvalues or {}

    self._signals = {}
    self._changed = Instance.new("BindableEvent")
    self.Changed = self._changed.Event

    if globalname then 
        -- Providing a globalname parameter will register it, allowing it to 
        -- be accessed by a client
        self._changedremote = Instance.new("RemoteEvent", script)
        GState._changedremotes[globalname] = self._changedremote
        GState.RegisteredStates[globalname] = self
    end

    return self
end

function GState.Subscribe(name)
    -- Subscribe to changes in a registered state
    local thiscontext = context()
    local State = GState.GetGlobalState(name)
    if thiscontext == "Client" then 
        -- return the remote connection
        return State._changedremote.OnServerEvent
    elseif thiscontext == "Server" then 
        -- return the .Changed signal
        return State.Changed
    end
end

function GState.GetGlobalState(name)
    -- Get a registered state
    local State = GState.GlobalStates[name]
    assert(State, "No global state of name "..name.." found!")
    return State
end

-- States

function State:_Fire(key, value)
    -- Fire a change
    self._changed:Fire(key,value)
    if self._signals[key] then
        self._signals[key]:Fire(value)
    end
    if self._changedremote then 
        self._changedremote:FireAllClients(key, value)
    end
end

function State:Set(...)
    local params = {...}
    local Type1 = type(params[1])

    if Type1 == "table" then 
        -- Set by a key-value dictionary
        -- State:Set({ ["Name"] = "John Doe", ["Age"] = 100 })
        local keyvalues = params[1]
        for key, value in ipairs(keyvalues) do 
            self.State[key] = value
            self:_Fire(key, value)
        end
    elseif Type1 == "string" or Type1 == "number" then 
        -- Set by a single key, value pairs
        -- State:Set("Name", "John Doe")
        self.State[params[1]] = params[2]
        self:_Fire(key, value)
    end
end

function State:RawSet(...)
    -- Same syntax as :Set(), but without firing a signal
    local params = {...}
    local Type1 = type(params[1])
    if Type1 == "table" then 
        local keyvalues = params[1]
        for key, value in ipairs(keyvalues) do 
            self.State[key] = value
        end
    elseif Type1 == "string" or Type1 == "number" then 
        self.State[params[1]] = params[2]
    end
end

function State:Increment(key, increment)
    increment = increment or 1
    assert(key~=nil,"GState: key expected for State:Increment()!")
    self.State[key] = self.State[key] and self.State[key] += increment or increment
    self:_Fire(key, self.State[key])
end

function State:Toggle(key, bool)
    self.State[key] == self.State[key] and (bool or not self.State[key])
        or bool
    self:_Fire(key, self.State[key])
end

function State:Get(keys)
    local Type = typeof(keys)
    local values
    if Type=="string" then 
        -- State:Get("Status")
        -- Return the requested key's value -> "meh"
        values = self.State[keys]
    elseif Type=="table" then 
        -- State:Get({"Status", "Name"})
        -- Return requested keys' values -> {["Status"]="meh",["Name"]="John Doe"}
        values = {}
        for _, key in ipairs(keys) do 
            values[key] = self.State[key]
        end
    else
        error("GState: Expected string or dictionary for State:Get(), got "..Type)
    end
    return values
end

function State:GetState()
    return self.State
end

function State:GetKeyChangedSignal(key)
    local signal
    if self.State[key] and not self._signals[key] then 
        self._signals[key] = Instance.new("BindableEvent")
        signal = self._signals[key]
    end
    local connection = signal.Event
    return connection
end

function State:GetChangedSignal()
    return self.Changed
end

function State:Destroy()
    self._changed:Destroy()
    for _, e in pairs (self._signals) do 
        e:Destroy()
    end
    self._signals = nil

    setmetatable(self)
    self = nil
end

return GState
