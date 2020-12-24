# evhub

Inspired by HuotChu/roblox-pubsub, evhub completely removes the need to manually create, manage and locate object remote and bindable events/functions. Client and server communication can be easily accessed only by passing on a name.

Here's an example of a client sending a message to the server:

```lua
--// Client
local evhub = require(game.ReplicatedStorage.evhub)

evhub.Fire("MessageEvent", "Hello World!")
```
```lua
--// Server
local evhub = require(game.ReplicatedStorage.evhub)

evhub.Listen("MessageEvent", function(player, message)
  print(player.Name.." says "..message)   
end)
```



### Functions
The functions are used exactly like their object counterpart, only with the string name referred. \
Note: the term "Env" or "Environment" refers to Bindables (which work only in the same environment).

Events:
- ``hub.Fire (string name, tuple parameters)``
- ``hub.Listen (string name, function callback)``
- ``hub.FireEnv (string name, tuple parameters)``
- ``hub.ListenEnv (string name, function callback)``

Functions:
- ``hub.Invoke (string name, tuple parameters)``
- ``hub.Respond (string name, function)``
- ``hub.InvokeEnv (string name, tuple parameters)``
- ``hub.RespondEnv (string name, function)``
