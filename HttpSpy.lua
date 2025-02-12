if rconsoleprint then
    rconsoleprint("\27[32m[HttpSpy]\27[0m https://eleutheri.com - #1 Whitelist Service\n\n")
end;

assert(syn or http, "Unsupported exploit (requires syn.request or http.request)");

local options = ({...})[1] or { 
    AutoDecode = true, 
    Highlighting = true, 
    SaveLogs = true, 
    CLICommands = true, 
    ShowResponse = true, 
    BlockedURLs = {}, 
    API = true 
};

local version = "v1.2.0";
local logname = string.format("%d-%s-log.txt", game.PlaceId, os.date("%d_%m_%y"));

if options.SaveLogs then
    writefile(logname, string.format("[HttpSpy] Logs from %s\n\n", os.date("%d/%m/%y"))) 
end;

local Serializer = loadstring(game:HttpGet("https://raw.githubusercontent.com/NotDSF/leopard/main/rbx/leopard-syn.lua"))();
local reqfunc = (syn or http).request;
local libtype = syn and "syn" or "http";
local blocked = options.BlockedURLs;
local enabled = true;
local hooked = {};
local proxied = {};
local OnRequest = Instance.new("BindableEvent");

-- Helper functions
local function printf(...)
    local message = string.format(...)
    if options.SaveLogs then
        appendfile(logname, message:gsub("%\27%[%d+m", ""))
    end
    return rconsoleprint(message)
end

local function getStackTrace()
    local trace = debug.traceback()
    return trace:gsub("\n", "\n\t") -- Format stack trace with indentation
end

local function logRequest(method, url, ...)
    local args = Serializer.FormatArguments(...)
    printf("\27[36m[HttpSpy] %s:\27[0m %s(%s)\n\tStack Trace:\n\t%s\n\n", method, url, args, getStackTrace())
end

-- Hooking HTTP functions
local __request = hookfunction(reqfunc, newcclosure(function(req) 
    if type(req) ~= "table" then return __request(req) end
    local RequestData = table.clone(req)

    if not enabled then return __request(req) end
    if type(RequestData.Url) ~= "string" then return __request(req) end

    if blocked[RequestData.Url] then
        printf("\27[31m[HttpSpy] Blocked:\27[0m %s\n\n", RequestData.Url)
        return {}
    end

    logRequest(libtype .. ".request", RequestData.Url, Serializer.Serialize(RequestData))

    local t = coroutine.running()
    coroutine.wrap(function()
        local ok, ResponseData = pcall(__request, RequestData)
        if not ok then
            error(ResponseData, 0)
        end

        if options.ShowResponse then
            logRequest("Response", RequestData.Url, Serializer.Serialize(ResponseData))
        end

        coroutine.resume(t, hooked[RequestData.Url] and hooked[RequestData.Url](ResponseData) or ResponseData)
    end)()
    
    return coroutine.yield()
end))

-- Hooking Namecalls (game:HttpGet, game:HttpPost, etc.)
local __namecall
__namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "HttpGet" or method == "HttpPost" then
        logRequest("game:" .. method, ...)
    end
    return __namecall(self, ...)
end))

-- WebSocket Hooking
if syn and syn.websocket then
    local wsconnect, wsbackup = debug.getupvalue(syn.websocket.connect, 1)
    wsbackup = hookfunction(wsconnect, function(...)
        logRequest("syn.websocket.connect", ...)
        return wsbackup(...)
    end)
end

-- API Functions
local API = {}
API.OnRequest = OnRequest.Event

function API:HookRequest(url, hook)
    hooked[url] = hook
end

function API:ProxyHost(host, proxy)
    proxied[host] = proxy
end

function API:RemoveProxy(host)
    if not proxied[host] then
        error("Host is not proxied", 0)
    end
    proxied[host] = nil
end

function API:BlockUrl(url)
    blocked[url] = true
end

function API:WhitelistUrl(url)
    blocked[url] = nil
end

printf("\27[32m[HttpSpy]\27[0m v%s initialized. Logs saved to: %s\n\n", version, options.SaveLogs and logname or "(Disabled)")

return API
