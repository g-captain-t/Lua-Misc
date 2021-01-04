--[[
EVHUB
Inspired by PubSub, evhub completely removes the need to manually place remote and 
bindable events/functions. Client and server communication can be easily accessed 
only by passing on a name.

Client:
	local evhub = require(game.ReplicatedStorage.evhub)
	evhub.Fire("MessageEvent", "Hello World!")

Server:
	local evhub = require(game.ReplicatedStorage.evhub)
	evhub.Listen("MessageEvent", function(player, message)
		print(player.Name.." says "..message)
	end)

FUNCTIONS
"Env" refers to Bindables, which work in the same environment.
- hub.Fire(string name, tuple parameters)
- hub.Listen(string name, function callback)
- hub.FireEnv(string name, tuple parameters)
- hub.ListenEnv(string name, function callback)
- hub.FireClient(string name, instance player, tuple parameters)

- hub.Invoke(string name, tuple parameters)
- hub.Respond(string name, function)
- hub.InvokeEnv(string name, tuple parameters)
- hub.RespondEnv(string name, function)

]]

local hub = {}

local function context()
	local RS = game:GetService("RunService")
	return RS:IsServer() and "Server" or RS:IsClient() and "Client"
end


--// EVENTS	(Fire and Listen)

local RemoteEvents = script.RemoteEvents
local EnvEvents = script.EnvEvents

--// Servers can create remotes and bindables, 
--// Clients will wait for remotes but will create bindables
local function findEvent(Folder, name, context)
	local class = Folder==RemoteEvents and "RemoteEvent" or "BindableEvent"
	local ev
	if context=="Client" then
		ev = class=="RemoteEvent" and Folder:WaitForChild(name) or Folder:FindFirstChild(name)
		if not ev and class =="BindableEvent" then
			ev = Instance.new(class)
			ev.Name = name
			ev.Parent = Folder
		end
	elseif context=="Server" then
		ev = Folder:FindFirstChild(name)
		if not ev then 
			ev = Instance.new(class)
			ev.Name = name
			ev.Parent = Folder
		end
	end
	return ev
end

function hub.Fire(name, ...)
	local context = context()
	local connection
	local ev = findEvent(RemoteEvents, name, context)
	if context=="Server" then
		ev:FireAllClients(...)
	elseif context=="Client" then
		ev:FireServer(...)
	end
end

function hub.FireClient(name, client, ...)
	local context = context()
	local connection
	local ev = findEvent(RemoteEvents, name, context)
	if context=="Server" then
		ev:FireClient(client, ...)
	end
end

function hub.Listen (name, callback)
	local context = context()
local ev = findEvent(RemoteEvents, name,context)
	local connection = ev["On"..context.."Event"]:Connect(callback)
return connection
end

function hub.FireEnv(name, ...)
	local context = context()
	local evenv = findEvent(EnvEvents,name,context)
	evenv:Fire(...)
end

function hub.ListenEnv(name,callback)
	local context = context()
	local evenv = findEvent(EnvEvents,name,context)
	local connection = evenv.Event:Connect(callback)
	return connection
end


--// FUNCTIONS (Invoke and Respond)

local RemoteFns= script.RemoteFunctions
local EnvFns = script.EnvFunctions

local function findFunction(Folder, name, context)
	local class = Folder==RemoteFns and "RemoteFunction" or "BindableFunction"
	local fn
	if context=="Client" then
		fn = class=="RemoteFunction" and Folder:WaitForChild(name) or Folder:FindFirstChild(name)
		if not fn and class =="BindableFunction" then
			fn = Instance.new(class)
			fn.Name = name
			fn.Parent = Folder
		end
	elseif context=="Server" then
		fn = Folder:FindFirstChild(name)
		if not fn then 
			fn = Instance.new(class)
			fn.Name = name
			fn.Parent = Folder
		end
	end
	return fn
end

function hub.Invoke(name,...)
	local context = context()
	local fn = findFunction(RemoteFns,name,context)
	if context=="Server" then
		fn:InvokeClient(...)
	elseif context=="Client" then
		fn:InvokeServer(...)
	end
end

function hub.Respond(name, fnc)
	local context = context()
	local fn = findFunction(RemoteFns,name,context)
	fn["On"..context.."Invoke"] = fnc
end

function hub.InvokeEnv(name, ...)
	local context = context()
	local envfn = findFunction(EnvFns, name, context)
	envfn:Invoke(...)
end

function hub.RespondEnv(name, fnc)
	local context = context()
	local envfn = findFunction(EnvFns, name, context)
	envfn.OnInvoke = fnc
end

return hub
