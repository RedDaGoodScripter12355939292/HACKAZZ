if rconsoleprint then
    rconsoleprint("https://eleutheri.com - #1 Whitelist Service\n\n")
end;

assert(syn or http, "Unsupported exploit (should support syn.request or http.request)");

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
    writefile(logname, string.format("Http Logs from %s\n\n", os.date("%d/%m/%y"))) 
end;

local Serializer = loadstring(game:HttpGet("https://raw.githubusercontent.com/NotDSF/leopard/main/rbx/leopard-syn.lua"))();
local clonef = clonefunction;
local pconsole = clonef(rconsoleprint);
local format = clonef(string.format);
local gsub = clonef(string.gsub);
local append = clonef(appendfile);
local Type = clonef(type);
local Pcall = clonef(pcall);
local Pairs = clonef(pairs);
local Error = clonef(error);
local getnamecallmethod = clonef(getnamecallmethod);
local blocked = options.BlockedURLs;
local enabled = true;
local reqfunc = (syn or http).request;
local libtype = syn and "syn" or "http";
local hooked = {};
local proxied = {};
local methods = {
    HttpGet = true, -- ✅ Fully enabled for all exploits
    HttpGetAsync = true,
    GetObjects = true,
    HttpPost = true,
    HttpPostAsync = true
}

Serializer.UpdateConfig({ highlighting = options.Highlighting });

local function printf(...) 
    if options.SaveLogs then
        append(logname, gsub(format(...), "%\27%[%d+m", ""));
    end;
    return pconsole(format(...));
end;

local function DeepClone(tbl, cloned)
    cloned = cloned or {};
    for i, v in Pairs(tbl) do
        cloned[i] = Type(v) == "table" and DeepClone(v) or v;
    end;
    return cloned;
end;

local function LogRequest(name, data)
    printf("%s(%s)\n\n", name, Serializer.FormatArguments(data));
    print("[HttpSpy] Intercepted:", name, data);
end;

local __namecall, __request;
__namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod();
    if methods[method] then
        LogRequest("game:" .. method, ...);
    end;
    return __namecall(self, ...);
end));

__request = hookfunction(reqfunc, newcclosure(function(req) 
    if Type(req) ~= "table" then return __request(req); end;
    local RequestData = DeepClone(req);
    if not enabled then return __request(req); end;
    
    if Type(RequestData.Url) ~= "string" then return __request(req); end;

    print("[HttpSpy] Request sent to:", RequestData.Url); -- 🔍 Debug print for all requests

    if not options.ShowResponse then
        LogRequest(libtype .. ".request", RequestData);
        return __request(req);
    end;

    local ok, ResponseData = Pcall(__request, RequestData);
    if not ok then Error(ResponseData, 0); end;

    local BackupData = DeepClone(ResponseData);
    if BackupData.Headers and BackupData.Headers["Content-Type"] and string.match(BackupData.Headers["Content-Type"], "application/json") and options.AutoDecode then
        local body = BackupData.Body;
        local json_ok, res = Pcall(game.HttpService.JSONDecode, game.HttpService, body);
        if json_ok then BackupData.Body = res; end;
    end;

    LogRequest(libtype .. ".request", { Request = RequestData, Response = BackupData });
    return BackupData;
end));

local OldHttpGet;
OldHttpGet = hookfunction(game.HttpGet, newcclosure(function(self, ...)
    LogRequest("game.HttpGet", ...);
    return OldHttpGet(self, ...);
end));

if request then
    replaceclosure(request, reqfunc);
end;

if syn and syn.websocket then
    local WsConnect, WsBackup = debug.getupvalue(syn.websocket.connect, 1);
    WsBackup = hookfunction(WsConnect, function(...) 
        LogRequest("syn.websocket.connect", ...);
        return WsBackup(...);
    end);
end;

for method, enabled in Pairs(methods) do
    if enabled then
        local b;
        b = hookfunction(game[method], newcclosure(function(self, ...) 
            LogRequest("game." .. method, ...);
            return b(self, ...);
        end));
    end;
end;

if not debug.info(2, "f") then
    pconsole("You are running an outdated version, please use the loadstring at https://github.com/NotDSF/HttpSpy\n");
end;

pconsole(format("HttpSpy %s (Creator: https://github.com/NotDSF)\nLogs saved to: \27[32m%s\27[0m\n\n", version, options.SaveLogs and logname or "(SaveLogs disabled)"));

if not options.API then return end;

local API = {};
API.OnRequest = Instance.new("BindableEvent").Event;

function API:HookRequest(url, hook) 
    hooked[url] = hook;
end;

function API:BlockUrl(url) 
    blocked[url] = true;
end;

function API:WhitelistUrl(url) 
    blocked[url] = false;
end;

return API;
