-- ============================================================================
-- BALL KUN  UNIVERSAL MAP DUMP (UI)        CREDIT : BALL KUN  V.0.2.4
-- ดึงข้อมูลโครงสร้างแมพ / ระบบ / Remote / UI / Value / Script (ฝั่ง Client)
-- บันทึกลง workspace : BALL_KUN_Dump/<ชื่อแมพ>_<PlaceId>/
-- ============================================================================

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")

if not game:IsLoaded() then
	pcall(function() game.Loaded:Wait() end)
end

local lp = Players.LocalPlayer
if not lp then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	lp = Players.LocalPlayer
end
local pg = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui", 15)

local CFG = {
	AutoStart = false,
	RequireAllModules = false,
	AutoStartDelay = 2,
	RootFolder = "BALL_KUN_Dump",
	PartLines = 50000,
	MaxTreeLines = 300000,
	MaxServiceLines = 90000,
	MaxGuiLines = 90000,
	MaxScanLines = 30000,
	MaxScripts = 5000,
	MaxModShape = 1000,
	MaxNil = 40000,
	IncludeCoreScripts = false,
	DecompileTimeout = 10,
	IncludeNilScripts = true,
	MaxNilScripts = 1000,
	MaxValues = 90000,
	MaxRemoteHooks = 8000,
	Radius = nil,
	OnlyServices = nil,
	HookClientInvoke = false,
	MaxSysGraph = 800,
}

local T = {
	Bg = Color3.fromRGB(10, 18, 16),
	Panel = Color3.fromRGB(16, 28, 25),
	Input = Color3.fromRGB(8, 14, 13),
	Green = Color3.fromRGB(20, 235, 130),
	GreenDark = Color3.fromRGB(14, 120, 78),
	Text = Color3.fromRGB(225, 255, 240),
	Dim = Color3.fromRGB(130, 170, 155),
	Red = Color3.fromRGB(255, 85, 105),
}

local HAS = {
	write = type(writefile) == "function",
	decompile = type(decompile) == "function",
	nilinst = type(getnilinstances) == "function",
	scripts = type(getscripts) == "function",
	modules = type(getloadedmodules) == "function",
}

local SERVICE_NAMES = {
	"Workspace", "ReplicatedStorage", "ReplicatedFirst", "StarterGui", "StarterPack", "StarterPlayer",
	"Lighting", "SoundService", "Teams", "TextChatService", "Chat", "MaterialService",
}

local SYSTEM_KEYS = {
	-- งาน / เควส / ฟาร์ม / เก็บเกี่ยว
	"job", "work", "rider", "delivery", "deliver", "cargo", "package", "parcel", "courier",
	"order", "quest", "mission", "task", "shift", "pay", "salary", "tip", "beacon", "contract",
	"farm", "harvest", "mine", "mining", "fish", "fishing", "craft", "cook", "chop", "collect", "gather",
	"งาน", "ส่งของ", "ไรเดอร์", "รับงาน", "ลูกค้า", "ฟาร์ม", "ขุด", "ตกปลา", "คราฟต์", "ทำอาหาร", "เควส", "ภารกิจ", "เก็บ",
	-- ร้านค้า / การเงิน / พาส / สุ่มรางวัล
	"shop", "store", "market", "sell", "buy", "trade", "bank", "atm", "cash", "coin", "money", "gem", "robux", "gamepass", "pass", "vip", "bundle",
	"gacha", "spin", "roll", "summon", "pull", "crate", "case", "box", "chest", "redeem", "code", "daily", "reward", "claim", "lucky",
	"ร้าน", "ตลาด", "ซื้อ", "ขาย", "แลกเปลี่ยน", "ธนาคาร", "เงิน", "ทอง", "เพชร", "พาส", "สุ่ม", "กาชา", "กล่อง", "โค้ด", "รางวัล", "รับของ",
	-- ยานพาหนะ / จูนแต่ง / วาร์ป / จุดเกิด
	"vehicle", "car", "bike", "moto", "motorcycle", "truck", "van", "boat", "ship", "plane", "heli", "helicopter", "drift", "race", "track",
	"spawn", "tune", "tuning", "garage", "wash", "fuel", "gas", "repair", "care", "custom", "suspension", "camber", "tyre", "tire", "exhaust", "ecu", "dyno",
	"seat", "drive", "engine", "gear", "speed", "nitro", "boost", "wheel", "teleport", "portal", "tp", "waypoint", "checkpoint", "station",
	"รถ", "แต่งรถ", "จูนรถ", "อู่", "ล้างรถ", "น้ำมัน", "ซ่อม", "เครื่องยนต์", "เกียร์", "ไนโตร", "จุดเกิด", "วาร์ป", "สนาม", "ดริฟต์", "แข่ง",
	-- ไอเทม / สัตว์เลี้ยง / สกิล / อัปเกรด / โซน / บอส
	"inventory", "inv", "item", "tool", "weapon", "gun", "sword", "skin", "pet", "egg", "hatch", "bag", "storage", "equip",
	"level", "rebirth", "upgrade", "skill", "stat", "exp", "xp", "rank", "clan", "guild", "house", "plot", "base", "boss", "raid", "dungeon", "wave", "round",
	"กระเป๋า", "ไอเทม", "อาวุธ", "ปืน", "สกิน", "สัตว์เลี้ยง", "ไข่", "ฟักไข่", "เวล", "สกิล", "อัปเกรด", "บ้าน", "ที่ดิน", "บอส", "ดันเจี้ยน", "รอบ",
}

local SERVICE_SKIP = {
	CoreGui = true, CorePackages = true, RobloxPluginGuiService = true, Players = true,
	NetworkClient = true, Visit = true, ScriptContext = true, Studio = true, RunService = true,
	UserInputService = true, TweenService = true, CollectionService = true, MarketplaceService = true,
}

local function refreshServices()
	local have = {}
	for _, n in ipairs(SERVICE_NAMES) do have[n] = true end
	local okK, kids = pcall(function() return game:GetChildren() end)
	if not okK or type(kids) ~= "table" then return end
	for _, c in ipairs(kids) do
		local okC, cn = pcall(function() return c.ClassName end)
		if okC and type(cn) == "string" and cn ~= "" and not have[cn] and not SERVICE_SKIP[cn] then
			local okS, s = pcall(function() return game:GetService(cn) end)
			if okS and typeof(s) == "Instance" then
				have[cn] = true
				SERVICE_NAMES[#SERVICE_NAMES + 1] = cn
			end
		end
	end
end
refreshServices()

local KEYS_LOW = {}
for i, k in ipairs(SYSTEM_KEYS) do KEYS_LOW[i] = k:lower() end

-- ============================================================================
-- Helpers
-- ============================================================================
local cancelled = false
local lastYield = os.clock()
local function pace()
	if cancelled then error("__cancel", 0) end
	if os.clock() - lastYield > 0.015 then
		task.wait()
		lastYield = os.clock()
	end
end

local function cutBytes(s, n)
	s = tostring(s or "")
	if #s <= n then return s end
	local i = n
	while i > 0 do
		local b = s:byte(i + 1)
		if not b or b < 0x80 or b >= 0xC0 then break end
		i = i - 1
	end
	return s:sub(1, i)
end

local function cut(s, n)
	s = tostring(s or "")
	if n <= 0 then return "" end
	if #s <= n then return s end
	local okL, len = pcall(utf8.len, s)
	if okL and len then
		if len <= n then return s end
		local off = utf8.offset(s, n + 1)
		return off and s:sub(1, off - 1) or s
	end
	return cutBytes(s, n)
end

local function oneLine(s)
	return (tostring(s or ""):gsub("[\r\n\t]+", " "))
end

local function safeFile(s, n)
	local r = tostring(s or ""):gsub("[^%w_%-\128-\255]+", "_")
	r = r:gsub("^_+", ""):gsub("_+$", "")
	r = cutBytes(r, n or 40)
	if r == "" then r = "x" end
	return r
end

local function svc(name)
	local ok, s = pcall(function() return game:GetService(name) end)
	if ok and typeof(s) == "Instance" then return s end
	return nil
end

local function safeNameOf(o)
	local ok, nm = pcall(function() return o.Name end)
	return (ok and type(nm) == "string") and nm or "?"
end

local function safeClassOf(o)
	local ok, cn = pcall(function() return o.ClassName end)
	return (ok and type(cn) == "string") and cn or "Instance"
end

local function fullPath(o)
	if typeof(o) ~= "Instance" then return tostring(o) end
	local t, c, guard = {}, o, 0
	while c and c ~= game and guard < 250 do
		guard = guard + 1
		table.insert(t, 1, safeNameOf(c))
		local okP, par = pcall(function() return c.Parent end)
		c = okP and par or nil
	end
	return table.concat(t, "/")
end

local function getAttrsTable(o)
	local ok, a = pcall(function() return o:GetAttributes() end)
	if ok and type(a) == "table" then return a end
	return nil
end

local function fmtVal(v)
	local t = typeof(v)
	if t == "string" or t == "number" or t == "boolean" then return tostring(v)
	elseif t == "Vector3" then return string.format("Vector3(%.2f, %.2f, %.2f)", v.X, v.Y, v.Z)
	elseif t == "Vector2" then return string.format("Vector2(%.2f, %.2f)", v.X, v.Y)
	elseif t == "CFrame" then
		local p = v.Position
		return string.format("CFrame(pos %.2f, %.2f, %.2f)", p.X, p.Y, p.Z)
	elseif t == "Color3" then
		local r, g, b = math.floor(v.R * 255 + 0.5), math.floor(v.G * 255 + 0.5), math.floor(v.B * 255 + 0.5)
		return string.format("Color3(%d,%d,%d #%02X%02X%02X)", r, g, b, r, g, b)
	elseif t == "BrickColor" then return "BrickColor(" .. v.Name .. ")"
	end
	return t .. "(" .. tostring(v) .. ")"
end

local function attrStr(o)
	local a = getAttrsTable(o)
	if not a then return "" end
	local t = {}
	for k, v in pairs(a) do
		t[#t + 1] = tostring(k) .. "=" .. cut(oneLine(fmtVal(v)), 70)
	end
	if #t == 0 then return "" end
	table.sort(t)
	return " attrs{" .. table.concat(t, ", ") .. "}"
end

local function attrLong(o)
	local a = getAttrsTable(o)
	if not a then return {} end
	local t = {}
	for k, v in pairs(a) do
		t[#t + 1] = tostring(k) .. "=" .. cut(oneLine(fmtVal(v)), 180)
	end
	table.sort(t)
	return t
end

local function tagsStr(o)
	local ok, tags = pcall(function() return CollectionService:GetTags(o) end)
	if ok and type(tags) == "table" and #tags > 0 then
		return " tags[" .. table.concat(tags, ",") .. "]"
	end
	return ""
end

local function valStr(d)
	local v = ""
	pcall(function() v = " = " .. cut(oneLine(d.Value), 80) end)
	return v
end

local function getHrp()
	local c = lp.Character
	return c and c:FindFirstChild("HumanoidRootPart")
end

local function posOf(o)
	local p
	pcall(function()
		local c = o
		for _ = 1, 6 do
			if not c then break end
			if c:IsA("BasePart") then p = c.Position break end
			if c:IsA("Attachment") then p = c.WorldPosition break end
			if c:IsA("Model") then p = c:GetPivot().Position break end
			c = c.Parent
		end
	end)
	return p
end

local function inRadius(dist)
	if not CFG.Radius then return true end
	return dist >= 0 and dist <= CFG.Radius
end

local function distOf(o)
	local p, h = posOf(o), getHrp()
	if p and h then return math.floor((p - h.Position).Magnitude) end
	return -1
end

local function posStr(o)
	local p = posOf(o)
	if not p then return "pos=?" end
	return string.format("pos=%.0f,%.0f,%.0f", p.X, p.Y, p.Z)
end

local function matchKeywords(text, keys)
	local low = tostring(text or ""):lower()
	local matched = {}
	local cached = (keys == SYSTEM_KEYS)
	for i, kw in ipairs(keys) do
		local k = cached and KEYS_LOW[i] or kw:lower()
		if low:find(k, 1, true) then
			matched[#matched + 1] = kw
		end
	end
	return matched
end

local function buildSearchBlob(o)
	local parts = { safeNameOf(o), fullPath(o), safeClassOf(o) }
	if o:IsA("ValueBase") then
		pcall(function() parts[#parts + 1] = tostring(o.Value) end)
	elseif o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then
		pcall(function() parts[#parts + 1] = tostring(o.Text) end)
	elseif o:IsA("ProximityPrompt") then
		pcall(function() parts[#parts + 1] = tostring(o.ActionText) .. " " .. tostring(o.ObjectText) end)
	end
	local a = getAttrsTable(o)
	if a then
		for k, v in pairs(a) do
			parts[#parts + 1] = tostring(k) .. "=" .. tostring(v)
		end
	end
	return table.concat(parts, " ")
end

local function isPlayerDescendant(o)
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Character and o:IsDescendantOf(p.Character) then
			return true
		end
	end
	return false
end

local function isRemoteLike(d)
	return d:IsA("RemoteEvent") or d:IsA("BaseRemoteEvent") or d:IsA("RemoteFunction")
		or d:IsA("BindableEvent") or d:IsA("BindableFunction")
end

local function lit(s)
	local r = tostring(s):gsub("[\r\n]", ""):gsub('[\\"]', "\\%0")
	return '"' .. r .. '"'
end

local function pathExpr(o)
	local chain, c, guard = {}, o, 0
	while c and c ~= game and guard < 250 do
		guard = guard + 1
		table.insert(chain, 1, c)
		local okP, par = pcall(function() return c.Parent end)
		c = okP and par or nil
	end
	if not c or #chain == 0 then return "nil --[[ ไม่อยู่ใน game: " .. fullPath(o) .. " ]]" end
	local first = chain[1]
	local expr, start
	if first == workspace then
		expr, start = "workspace", 2
	elseif lp.Parent and first == lp.Parent and chain[2] == lp then
		expr, start = 'game:GetService("Players").LocalPlayer', 3
	else
		expr, start = "game:GetService(" .. lit(safeClassOf(first)) .. ")", 2
	end
	for i = start, #chain do
		expr = expr .. ":FindFirstChild(" .. lit(safeNameOf(chain[i])) .. ")"
	end
	return expr
end

-- ============================================================================
-- ชื่อแมพ / โฟลเดอร์บันทึก
-- ============================================================================
local mapName = "Place"
do
	local ok, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
	if ok and type(info) == "table" and info.Name then mapName = tostring(info.Name) end
end
local safeName = safeFile(mapName, 40)
if safeName == "x" then safeName = "Place" end
local dir = CFG.RootFolder .. "/" .. safeName .. "_" .. tostring(game.PlaceId)

-- ============================================================================
-- UI
-- ============================================================================
local function uiParent()
	if type(gethui) == "function" then
		local ok, h = pcall(gethui)
		if ok and typeof(h) == "Instance" then
			local okTest = pcall(function()
				local f = Instance.new("Folder")
				f.Parent = h
				f:Destroy()
			end)
			if okTest then return h end
		end
	end
	local okCore, core = pcall(function() return game:GetService("CoreGui") end)
	if okCore and core then
		local okTest = pcall(function()
			local f = Instance.new("Folder")
			f.Parent = core
			f:Destroy()
		end)
		if okTest then return core end
	end
	return pg
end

local parent = uiParent()
if parent then
	pcall(function()
		local old = parent:FindFirstChild("BALLKUN_UniversalMapDump")
		if old then old:Destroy() end
	end)
end

local function corner(i, r) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r or 8) c.Parent = i end
local function stroke(i, col, th, tr)
	local s = Instance.new("UIStroke")
	s.Color, s.Thickness, s.Transparency = col, th or 1, tr or 0
	s.Parent = i
	return s
end
local function mk(class, props, par)
	local o = Instance.new(class)
	for k, v in pairs(props) do o[k] = v end
	if par then o.Parent = par end
	return o
end
local function label(par, text, size, color, font, x, y, w, h, align)
	return mk("TextLabel", {
		BackgroundTransparency = 1, Text = text, TextSize = size, TextColor3 = color, Font = font or Enum.Font.GothamMedium,
		Position = UDim2.fromOffset(x, y), Size = UDim2.new(0, w, 0, h), TextXAlignment = align or Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}, par)
end

local function grad(i, c1, c2, rot)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(c1, c2)
	g.Rotation = rot or 0
	g.Parent = i
	return g
end
local TEAL = Color3.fromRGB(0, 190, 200)

local gui = mk("ScreenGui", {
	Name = "BALLKUN_UniversalMapDump", ResetOnSpawn = false, IgnoreGuiInset = true,
	DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, nil)
pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
gui.Parent = parent or pg

local vp = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(800, 400)
local W = math.min(620, math.max(320, vp.X - 24))
local H = math.max(290, math.min(500, vp.Y - 16))

local main = mk("Frame", {
	Size = UDim2.fromOffset(W, H), Position = UDim2.new(0.5, -W / 2, 0.5, -H / 2),
	BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Active = true
}, gui)
corner(main, 16)
grad(main, Color3.fromRGB(15, 29, 26), Color3.fromRGB(6, 11, 11), 90)
grad(stroke(main, T.Green, 2), T.Green, TEAL, 45)

-- ===== Header =====
local header = mk("Frame", { Size = UDim2.new(1, 0, 0, 56), BackgroundColor3 = T.Panel, BorderSizePixel = 0 }, main)
corner(header, 16)
mk("Frame", { Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 1, -16), BackgroundColor3 = T.Panel, BorderSizePixel = 0 }, header)
local accent = mk("Frame", { Size = UDim2.new(1, -32, 0, 2), Position = UDim2.new(0, 16, 1, -1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0 }, header)
grad(accent, T.Green, TEAL, 0)

local logo = mk("Frame", { Size = UDim2.fromOffset(36, 36), Position = UDim2.fromOffset(12, 10), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0 }, header)
corner(logo, 10)
grad(logo, T.Green, TEAL, 45)
mk("TextLabel", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "BK", TextSize = 17, Font = Enum.Font.GothamBlack, TextColor3 = T.Bg }, logo)

local titleW = W - 56 - 176
label(header, "UNIVERSAL MAP DUMP", 16, T.Text, Enum.Font.GothamBlack, 58, 7, titleW, 22)
label(header, "CREDIT • BALL KUN  V.0.2.4", 11, T.Green, Enum.Font.GothamBold, 58, 29, titleW, 16)

local chip = mk("Frame", { Size = UDim2.fromOffset(78, 22), Position = UDim2.new(1, -172, 0, 17), BackgroundColor3 = T.GreenDark, BorderSizePixel = 0 }, header)
corner(chip, 11)
mk("TextLabel", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "อ่านอย่างเดียว", TextSize = 10, Font = Enum.Font.GothamBold, TextColor3 = T.Text }, chip)

local closeBtn = mk("TextButton", {
	Text = "×", TextSize = 22, Font = Enum.Font.GothamBold, TextColor3 = T.Bg,
	BackgroundColor3 = T.Green, Size = UDim2.fromOffset(34, 30), Position = UDim2.new(1, -46, 0, 13), AutoButtonColor = true
}, header)
corner(closeBtn, 9)
local miniBtn = mk("TextButton", {
	Text = "–", TextSize = 22, Font = Enum.Font.GothamBold, TextColor3 = T.Text,
	BackgroundColor3 = T.GreenDark, Size = UDim2.fromOffset(34, 30), Position = UDim2.new(1, -86, 0, 13)
}, header)
corner(miniBtn, 9)

local conns = {}
local cleanup = {}
do
	local dragging, startPos, startInput
	header.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging, startInput, startPos = true, i.Position, main.Position
			i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	conns[#conns + 1] = UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - startInput.Position
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
end

-- ===== Info chips =====
local infoLbl = mk("Frame", { Size = UDim2.new(1, -24, 0, 22), Position = UDim2.fromOffset(12, 64), BackgroundTransparency = 1 }, main)
local mapChip = mk("Frame", { Size = UDim2.new(0.6, -3, 1, 0), BackgroundColor3 = T.Input, BorderSizePixel = 0 }, infoLbl)
corner(mapChip, 7)
mk("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(8, 0), Text = "แมพ: " .. cut(mapName, 40),
	TextSize = 11, Font = Enum.Font.GothamMedium, TextColor3 = T.Text, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd }, mapChip)
local idChip = mk("Frame", { Size = UDim2.new(0.4, -3, 1, 0), Position = UDim2.new(0.6, 3, 0, 0), BackgroundColor3 = T.Input, BorderSizePixel = 0 }, infoLbl)
corner(idChip, 7)
mk("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(8, 0), Text = "PlaceId: " .. tostring(game.PlaceId),
	TextSize = 11, Font = Enum.Font.GothamMedium, TextColor3 = T.Dim, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd }, idChip)

-- ===== Body =====
local body = mk("Frame", { Size = UDim2.new(1, -24, 1, -232), Position = UDim2.fromOffset(12, 94), BackgroundTransparency = 1 }, main)
local listW = math.floor((W - 24) * 0.46)

local modWrap = mk("Frame", { Size = UDim2.new(0, listW, 1, 0), BackgroundColor3 = T.Panel, BorderSizePixel = 0 }, body)
corner(modWrap, 12)
stroke(modWrap, T.GreenDark, 1, 0.5)
label(modWrap, "ระบบที่จะดัมพ์ (แตะเพื่อเปิด/ปิด)", 11, T.Green, Enum.Font.GothamBold, 10, 5, listW - 16, 16)
local modPanel = mk("ScrollingFrame", {
	Size = UDim2.new(1, 0, 1, -24), Position = UDim2.fromOffset(0, 24), BackgroundTransparency = 1, BorderSizePixel = 0,
	ScrollBarThickness = 3, ScrollBarImageColor3 = T.Green, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y
}, modWrap)
mk("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, modPanel)
mk("UIPadding", { PaddingTop = UDim.new(0, 2), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 6) }, modPanel)

local logWrap = mk("Frame", { Size = UDim2.new(1, -listW - 8, 1, 0), Position = UDim2.new(0, listW + 8, 0, 0), BackgroundColor3 = T.Input, BorderSizePixel = 0 }, body)
corner(logWrap, 12)
stroke(logWrap, T.GreenDark, 1, 0.5)
label(logWrap, "LOG", 11, T.Green, Enum.Font.GothamBold, 10, 5, 100, 16)
local logPanel = mk("ScrollingFrame", {
	Size = UDim2.new(1, 0, 1, -24), Position = UDim2.fromOffset(0, 24), BackgroundTransparency = 1, BorderSizePixel = 0,
	ScrollBarThickness = 3, ScrollBarImageColor3 = T.Green, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y
}, logWrap)
local logLbl = mk("TextLabel", {
	BackgroundTransparency = 1, Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -16, 0, 0),
	AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top, Font = Enum.Font.Code, TextSize = 12, TextColor3 = T.Text, Text = ""
}, logPanel)

local logLines = {}
local function log(s)
	logLines[#logLines + 1] = "[" .. os.date("%H:%M:%S") .. "] " .. tostring(s)
	while #logLines > 200 do table.remove(logLines, 1) end
	logLbl.Text = table.concat(logLines, "\n")
	logPanel.CanvasPosition = Vector2.new(0, 1e7)
end

local UI = {}
do
	local function smallBtn(text, xOff, cb)
		local b = mk("TextButton", {
			Text = text, TextSize = 10, Font = Enum.Font.GothamBold, TextColor3 = T.Text, BackgroundColor3 = T.GreenDark,
			Size = UDim2.fromOffset(40, 16), Position = UDim2.new(1, xOff, 0, 4), BorderSizePixel = 0,
		}, logWrap)
		corner(b, 5)
		b.MouseButton1Click:Connect(cb)
	end
	UI.smallBtn = smallBtn
	smallBtn("CLR", -90, function()
		logLines = {}
		logLbl.Text = ""
	end)
	smallBtn("COPY", -46, function()
		local fn = setclipboard or toclipboard
		if type(fn) == "function" then
			pcall(fn, table.concat(logLines, "\n"))
			log("copied log to clipboard")
		else
			log("no setclipboard in this executor")
		end
	end)
end

-- ===== Footer =====
local footer = mk("Frame", { Size = UDim2.new(1, -24, 0, 122), Position = UDim2.new(0, 12, 1, -130), BackgroundTransparency = 1 }, main)
local barBg = mk("Frame", { Size = UDim2.new(1, 0, 0, 12), BackgroundColor3 = T.Input, BorderSizePixel = 0 }, footer)
corner(barBg, 6)
local barFill = mk("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0 }, barBg)
corner(barFill, 6)
grad(barFill, T.Green, TEAL, 0)
local statusLbl = label(footer, "พร้อมเริ่ม — เลือกระบบที่ต้องการแล้วกด START", 12, T.Dim, Enum.Font.GothamMedium, 0, 17, W - 24, 16)
local startBtn = mk("TextButton", {
	Text = "START DUMP", TextSize = 16, Font = Enum.Font.GothamBlack, TextColor3 = T.Bg,
	BackgroundColor3 = Color3.new(1, 1, 1), Size = UDim2.new(0.6, -4, 0, 36), Position = UDim2.fromOffset(0, 38)
}, footer)
corner(startBtn, 10)
local startGrad = grad(startBtn, T.Green, TEAL, 0)
local allBtn = mk("TextButton", {
	Text = "เลือกทั้งหมด / ล้าง", TextSize = 13, Font = Enum.Font.GothamBold, TextColor3 = T.Text,
	BackgroundColor3 = T.GreenDark, Size = UDim2.new(0.4, -4, 0, 36), Position = UDim2.new(0.6, 4, 0, 38)
}, footer)
corner(allBtn, 10)
local tagBox = mk("TextBox", {
	Text = "", PlaceholderText = "ชื่อสถานะ เช่น เปิดหน้าต่างร้าน", PlaceholderColor3 = T.Dim, TextSize = 12,
	Font = Enum.Font.GothamMedium, TextColor3 = T.Text, BackgroundColor3 = T.Input, ClearTextOnFocus = false,
	Size = UDim2.new(0.4, -4, 0, 36), Position = UDim2.fromOffset(0, 80), TextTruncate = Enum.TextTruncate.AtEnd
}, footer)
corner(tagBox, 10)
stroke(tagBox, T.GreenDark, 1, 0.3)
local snapBtn = mk("TextButton", {
	Text = "SNAPSHOT สถานะปัจจุบัน (นับถอยหลัง 8 วิ)", TextSize = 13, Font = Enum.Font.GothamBold,
	TextColor3 = T.Bg, BackgroundColor3 = Color3.new(1, 1, 1), Size = UDim2.new(0.6, -4, 0, 36), Position = UDim2.new(0.4, 4, 0, 80)
}, footer)
corner(snapBtn, 10)
grad(snapBtn, TEAL, T.Green, 0)

local function setProgress(frac, text)
	TweenService:Create(barFill, TweenInfo.new(0.15), { Size = UDim2.new(math.clamp(frac, 0, 1), 0, 1, 0) }):Play()
	if text then statusLbl.Text = text end
end

local minimized = false
miniBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	body.Visible, footer.Visible, infoLbl.Visible = not minimized, not minimized, not minimized
	main.Size = minimized and UDim2.fromOffset(W, 56) or UDim2.fromOffset(W, H)
end)
closeBtn.MouseButton1Click:Connect(function()
	cancelled = true
	for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
	for _, f in ipairs(cleanup) do pcall(f) end
	gui:Destroy()
end)

pcall(function()
	main.Size = UDim2.fromOffset(W * 0.9, H * 0.9)
	main.Position = UDim2.new(0.5, -W * 0.45, 0.5, -H * 0.45)
	TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.fromOffset(W, H), Position = UDim2.new(0.5, -W / 2, 0.5, -H / 2)
	}):Play()
end)

-- ============================================================================
-- บันทึกไฟล์ / หน่วยความจำ
-- ============================================================================
local canWrite = HAS.write
local function ensureFolders()
	if canWrite and type(makefolder) == "function" then
		for _, p in ipairs({ CFG.RootFolder, dir, dir .. "/scripts", dir .. "/snapshots" }) do
			pcall(function() if type(isfolder) ~= "function" or not isfolder(p) then makefolder(p) end end)
		end
	end
end

local MEM = {}
local function saveMem(fileName, text)
	MEM[fileName] = text
	pcall(function() ((getgenv and getgenv()) or _G).BALL_KUN_DUMP = MEM end)
end

local function save(fileName, lines)
	local fullText = table.concat(lines, "\n")
	if not canWrite then
		saveMem(fileName, fullText)
		return true, 'memory: getgenv().BALL_KUN_DUMP["' .. fileName .. '"]', 1
	end
	local function put(name, chunk)
		local text = table.concat(chunk, "\n")
		if pcall(writefile, dir .. "/" .. name, text) then return true, dir .. "/" .. name end
		local alt = CFG.RootFolder .. "_" .. safeName .. "_" .. (name:gsub("/", "_"))
		if pcall(writefile, alt, text) then return true, alt end
		local flat = safeName .. "_" .. (name:gsub("/", "_"))
		if pcall(writefile, flat, text) then return true, flat end
		saveMem(name, text)
		return true, "memory:" .. name
	end
	if #lines <= CFG.PartLines then
		local ok, p = put(fileName, lines)
		return ok, p, 1
	end
	local base, ext = fileName:match("^(.*)(%.[^%.]+)$")
	base, ext = base or fileName, ext or ""
	local part, allOk, first = 0, true, nil
	for i = 1, #lines, CFG.PartLines do
		part = part + 1
		local chunk = {}
		for j = i, math.min(i + CFG.PartLines - 1, #lines) do chunk[#chunk + 1] = lines[j] end
		local ok, p = put(base .. "_part" .. part .. ext, chunk)
		allOk = allOk and ok
		first = first or p
	end
	return allOk, first, part
end

-- ============================================================================
-- สแกน Instance ทั้งแมพ (Service + ผู้เล่น + PlayerScripts + nil instances)
-- ============================================================================
local ALL, DESC, SRC, NIL, IDX

local function buildAll()
	local A, n = {}, 0
	local seen = {}
	local function add(o)
		if typeof(o) == "Instance" and not seen[o] then
			seen[o] = true
			n = n + 1
			A[n] = o
		end
	end
	local wsList
	local function addTree(root)
		if typeof(root) ~= "Instance" then return nil end
		add(root)
		local ok, d = pcall(function() return root:GetDescendants() end)
		if ok and type(d) == "table" then
			for _, x in ipairs(d) do add(x) end
		end
		pace()
		return (ok and type(d) == "table") and d or nil
	end

	for _, name in ipairs(SERVICE_NAMES) do
		local sv = svc(name)
		local allowed = true
		if CFG.OnlyServices then
			allowed = false
			for _, w in ipairs(CFG.OnlyServices) do if w == name then allowed = true break end end
		end
		if sv and allowed then
			local got = addTree(sv)
			if name == "Workspace" then wsList = got end
		end
	end

	add(lp)
	local okLpKids, lpKids = pcall(function() return lp:GetChildren() end)
	if okLpKids and type(lpKids) == "table" then
		for _, c in ipairs(lpKids) do
			if c == pg then
				add(pg)
				local okG, gKids = pcall(function() return pg:GetChildren() end)
				if okG and type(gKids) == "table" then
					for _, g in ipairs(gKids) do
						if g ~= gui then addTree(g) end
					end
				end
			else
				addTree(c)
			end
		end
	end

	local N = {}
	if HAS.nilinst then
		pcall(function()
			local nilInsts = getnilinstances()
			if type(nilInsts) == "table" then
				for _, o in ipairs(nilInsts) do
					if #N >= CFG.MaxNil then break end
					if typeof(o) == "Instance" and o ~= gui and not seen[o] then
						local okP, par = pcall(function() return o.Parent end)
						if okP and par == nil then
							seen[o] = true
							N[#N + 1] = o
						end
					end
				end
			end
		end)
	end
	return A, N, wsList
end

local function buildIndex()
	local I = { prompts = {}, clicks = {}, remotes = {}, values = {}, seats = {} }
	for i, o in ipairs(ALL or {}) do
		if i % 2000 == 0 then pace() end
		if typeof(o) == "Instance" then
			if o:IsA("ProximityPrompt") then I.prompts[#I.prompts + 1] = o
			elseif o:IsA("ClickDetector") then I.clicks[#I.clicks + 1] = o
			elseif isRemoteLike(o) then I.remotes[#I.remotes + 1] = o
			elseif o:IsA("VehicleSeat") then I.seats[#I.seats + 1] = o
			elseif o:IsA("ValueBase") then I.values[#I.values + 1] = o end
		end
	end
	return I
end

local function guiList()
	local list = {}
	if pg then
		local okK, kids = pcall(function() return pg:GetChildren() end)
		if okK and type(kids) == "table" then
			for _, g0 in ipairs(kids) do
				if g0 ~= gui then
					list[#list + 1] = g0
					local okD, desc = pcall(function() return g0:GetDescendants() end)
					if okD and type(desc) == "table" then
						for _, d in ipairs(desc) do list[#list + 1] = d end
					end
				end
			end
		end
	end
	return list
end

local function effVisible(o)
	local c, guard = o, 0
	while c and c ~= pg and guard < 100 do
		guard = guard + 1
		local okV = true
		if c:IsA("GuiObject") then
			pcall(function() if not c.Visible then okV = false end end)
		elseif c:IsA("ScreenGui") then
			pcall(function() if not c.Enabled then okV = false end end)
		end
		if not okV then return false end
		local okP, par = pcall(function() return c.Parent end)
		c = okP and par or nil
	end
	return true
end

local function describe(o)
	local t = {}
	pcall(function()
		if o:IsA("BasePart") then
			local p, s = o.Position, o.Size
			t[#t + 1] = string.format("pos=%.0f,%.0f,%.0f size=%.0fx%.0fx%.0f%s%s", p.X, p.Y, p.Z, s.X, s.Y, s.Z,
				o.Anchored and " anch" or "", o.CanCollide and "" or " nocol")
		elseif o:IsA("Model") then
			local pv = o:GetPivot().Position
			t[#t + 1] = string.format("pivot=%.0f,%.0f,%.0f", pv.X, pv.Y, pv.Z)
		elseif o:IsA("ValueBase") then
			t[#t + 1] = "val=" .. cut(oneLine(o.Value), 80)
		elseif o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then
			t[#t + 1] = "text=[" .. cut(oneLine(o.Text), 60) .. "] vis=" .. tostring(o.Visible)
		elseif o:IsA("GuiObject") then
			t[#t + 1] = "vis=" .. tostring(o.Visible)
		elseif o:IsA("ScreenGui") then
			t[#t + 1] = "enabled=" .. tostring(o.Enabled)
		elseif o:IsA("ProximityPrompt") then
			t[#t + 1] = "act=[" .. oneLine(o.ActionText) .. "] obj=[" .. oneLine(o.ObjectText) .. "] hold=" .. tostring(o.HoldDuration) .. " en=" .. tostring(o.Enabled)
		elseif o:IsA("ClickDetector") then
			t[#t + 1] = "max=" .. tostring(o.MaxActivationDistance)
		elseif o:IsA("BaseScript") then
			t[#t + 1] = "enabled=" .. tostring(o.Enabled)
		elseif o:IsA("Sound") then
			t[#t + 1] = "sound=" .. cut(tostring(o.SoundId), 60)
		end
	end)
	if #t == 0 then return "" end
	return " | " .. table.concat(t, " ")
end

local function nodeStr(o)
	return cut(safeNameOf(o), 60) .. " [" .. safeClassOf(o) .. "]" .. describe(o) .. attrStr(o) .. tagsStr(o)
end

local PLAIN = {
	Decal = true, Texture = true, SpecialMesh = true, BlockMesh = true, Weld = true, WeldConstraint = true,
	Motor6D = true, Attachment = true, SurfaceAppearance = true,
}

local function isPlain(c)
	local cn = safeClassOf(c)
	if c:IsA("Seat") or c:IsA("VehicleSeat") or c:IsA("SpawnLocation") then return false end
	if not (c:IsA("BasePart") or PLAIN[cn]) then return false end
	local okK, k = pcall(function() return #c:GetChildren() end)
	if okK and k > 0 then return false end
	local a = getAttrsTable(c)
	if a and next(a) ~= nil then return false end
	local ok, tags = pcall(function() return CollectionService:GetTags(c) end)
	if ok and type(tags) == "table" and #tags > 0 then return false end
	return true
end

local function treeLines(root, L, collapse, maxLines, skipFn)
	local stack = { { root, 0 } }
	while #stack > 0 do
		local it = table.remove(stack)
		local o, depth = it[1], it[2]
		pace()
		if #L >= maxLines then
			L[#L + 1] = "... ตัดที่ " .. maxLines .. " บรรทัด"
			return
		end
		local pre = string.rep("  ", depth)
		L[#L + 1] = pre .. nodeStr(o)
		local keep, counts, order = {}, {}, {}
		local okK, kids = pcall(function() return o:GetChildren() end)
		if okK and type(kids) == "table" then
			for _, c in ipairs(kids) do
				if not (skipFn and skipFn(c)) then
					if collapse and isPlain(c) then
						local cn = safeClassOf(c)
						if not counts[cn] then counts[cn] = 0 order[#order + 1] = cn end
						counts[cn] = counts[cn] + 1
					else
						keep[#keep + 1] = c
					end
				end
			end
		end
		if #order > 0 then
			local t = {}
			for _, cn in ipairs(order) do t[#t + 1] = counts[cn] .. "x " .. cn end
			L[#L + 1] = pre .. "  (ย่อ: " .. table.concat(t, ", ") .. ")"
		end
		for i = #keep, 1, -1 do stack[#stack + 1] = { keep[i], depth + 1 } end
	end
end

local function notPlayerChar(c)
	local ok, pl = pcall(function() return Players:GetPlayerFromCharacter(c) end)
	return ok and pl ~= nil
end

local function runWithTimeout(fn, timeout)
	local result, done, okRun = nil, false, false
	local th = task.spawn(function()
		okRun, result = pcall(fn)
		done = true
	end)
	local t0 = os.clock()
	while not done and os.clock() - t0 < timeout do
		if cancelled then pcall(task.cancel, th) error("__cancel", 0) end
		task.wait(0.05)
	end
	if not done then
		pcall(task.cancel, th)
		return false, "timeout"
	end
	return okRun, result
end

local function sortRows(rows)
	table.sort(rows, function(a, b)
		if a.dist >= 0 and b.dist >= 0 and a.dist ~= b.dist then return a.dist < b.dist end
		return a.line < b.line
	end)
end

-- ============================================================================
-- ตัวแปลงค่า & Remote Log
-- ============================================================================
local function ser(v, depth, maxD, seen)
	local tv = typeof(v)
	if tv == "string" then return '"' .. cut(oneLine(v), 100) .. '"'
	elseif tv == "number" or tv == "boolean" or tv == "nil" then return tostring(v)
	elseif tv == "Instance" then return "<" .. safeClassOf(v) .. ":" .. cut(fullPath(v), 90) .. ">"
	elseif tv == "function" then return "<function>"
	elseif tv == "buffer" then
		local okB, bs = pcall(function()
			local n = buffer.len(v)
			local hex = {}
			for i = 0, math.min(n, 32) - 1 do hex[#hex + 1] = string.format("%02x", buffer.readu8(v, i)) end
			return "<buffer len=" .. n .. " hex=" .. table.concat(hex) .. (n > 32 and "..." or "") .. ">"
		end)
		return okB and bs or "<buffer>"
	elseif tv == "table" then
		if seen[v] then return "<cycle>" end
		if depth >= maxD then return "{...}" end
		seen[v] = true
		local parts, n = {}, 0
		local okP = pcall(function()
			for k, x in pairs(v) do
				n = n + 1
				if n > 20 then parts[#parts + 1] = "..." break end
				parts[#parts + 1] = "[" .. ser(k, depth + 1, maxD, seen) .. "]=" .. ser(x, depth + 1, maxD, seen)
			end
		end)
		seen[v] = nil
		if not okP then return "{...}" end
		return "{" .. table.concat(parts, ", ") .. "}"
	end
	return "<" .. tv .. ":" .. cut(tostring(v), 50) .. ">"
end

local function dumpTable(t, L, indent, depth, seen, budget)
	if seen[t] then L[#L + 1] = indent .. "<cycle>" return end
	seen[t] = true
	local keys = {}
	pcall(function()
		for k in pairs(t) do keys[#keys + 1] = k end
	end)
	table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
	for i, k in ipairs(keys) do
		if i > 250 then L[#L + 1] = indent .. "... (" .. #keys .. " keys)" break end
		if budget.n <= 0 then break end
		budget.n = budget.n - 1
		local okV, v = pcall(function() return t[k] end)
		if not okV then v = "<err>" end
		if type(v) == "table" and depth < 6 then
			L[#L + 1] = indent .. tostring(k) .. " = {"
			dumpTable(v, L, indent .. "  ", depth + 1, seen, budget)
			L[#L + 1] = indent .. "}"
		else
			L[#L + 1] = indent .. tostring(k) .. " = " .. ser(v, 0, 2, {})
		end
	end
	seen[t] = nil
end

local RL = { on = false, buf = {}, hooked = false, conns = {}, count = 0, cnt = {}, wrapped = {} }
local function rlRecord(dirTxt, remote, ...)
	local ck = (dirTxt:match("^%S+") or "?") .. " " .. fullPath(remote)
	RL.cnt[ck] = (RL.cnt[ck] or 0) + 1
	if #RL.buf >= 10000 then
		if not RL.full then
			RL.full = true
			pcall(log, "⚠ Remote Log buffer full (10000) - ปิดแล้วเปิดใหม่เพื่อดักชุดถัดไป")
		end
		return
	end
	local args = table.pack(...)
	local parts = {}
	for i = 1, math.min(args.n, 16) do parts[i] = ser(args[i], 0, 3, {}) end
	RL.count = RL.count + 1
	RL.buf[#RL.buf + 1] = string.format("[%s] #%d %s | %s [%s] | args(%d): %s", os.date("%H:%M:%S"), RL.count, dirTxt,
		fullPath(remote), safeClassOf(remote), args.n, table.concat(parts, ", "))
end

local function rlToggle(on)
	if not on then
		RL.on = false
		for _, c in ipairs(RL.conns) do pcall(function() c:Disconnect() end) end
		RL.conns = {}
		for rf, orig in pairs(RL.wrapped) do pcall(function() rf.OnClientInvoke = orig end) end
		RL.wrapped = {}
		log("■ หยุดบันทึก Remote (เก็บได้ " .. #RL.buf .. " รายการ)")
		return
	end
	RL.on = true
	RL.full = false
	local hookOk = RL.hooked
	if not RL.hooked then
		if type(hookmetamethod) == "function" and type(getnamecallmethod) == "function" then
			local old
			local function handler(self, ...)
				local m = getnamecallmethod()
				if RL.on and (m == "FireServer" or m == "InvokeServer") then
					local packed = table.pack(...)
					pcall(function()
						local cn = safeClassOf(self)
						if cn == "RemoteEvent" or cn == "RemoteFunction" or cn == "UnreliableRemoteEvent" then
							rlRecord("C→S " .. m, self, table.unpack(packed, 1, packed.n))
						end
					end)
				end
				return old(self, ...)
			end
			local okH, err = pcall(function()
				old = hookmetamethod(game, "__namecall", (type(newcclosure) == "function") and newcclosure(handler) or handler)
			end)
			if okH and old then
				RL.hooked, hookOk = true, true
			else
				log("✗ hook ฝั่งส่ง (C→S) ไม่สำเร็จ: " .. cut(tostring(err), 60))
			end
		else
			log("⚠ ตัวรันไม่มี hookmetamethod — บันทึกได้เฉพาะฝั่งรับ (S→C)")
		end
	end
	local n = 0
	local hookedSet = {}
	local function hookRemote(d)
		if typeof(d) ~= "Instance" or hookedSet[d] or n >= CFG.MaxRemoteHooks then return end
		if not (d:IsA("RemoteEvent") or d:IsA("UnreliableRemoteEvent")) then return end
		hookedSet[d] = true
		local okC, conn = pcall(function()
			return d.OnClientEvent:Connect(function(...)
				if RL.on then
					local packed = table.pack(...)
					pcall(rlRecord, "S→C OnClientEvent", d, table.unpack(packed, 1, packed.n))
				end
			end)
		end)
		if okC and conn then
			n = n + 1
			RL.conns[#RL.conns + 1] = conn
		end
	end
	for _, name in ipairs(SERVICE_NAMES) do
		local root = svc(name)
		if root then
			local okD, desc = pcall(function() return root:GetDescendants() end)
			if okD and type(desc) == "table" then for _, d in ipairs(desc) do hookRemote(d) end end
			local okA, ca = pcall(function() return root.DescendantAdded:Connect(hookRemote) end)
			if okA and ca then RL.conns[#RL.conns + 1] = ca end
		end
	end
	if CFG.HookClientInvoke and type(getcallbackvalue) == "function" then
		local wn = 0
		for _, name in ipairs(SERVICE_NAMES) do
			local root = svc(name)
			if root then
				local okD, desc = pcall(function() return root:GetDescendants() end)
				if okD and type(desc) == "table" then
					for _, rf in ipairs(desc) do
						if rf:IsA("RemoteFunction") and not RL.wrapped[rf] then
							local okG, orig = pcall(getcallbackvalue, rf, "OnClientInvoke")
							if okG and type(orig) == "function" then
								local okS = pcall(function()
									rf.OnClientInvoke = function(...)
										if RL.on then pcall(rlRecord, "S→C OnClientInvoke", rf, ...) end
										return orig(...)
									end
								end)
								if okS then RL.wrapped[rf] = orig wn = wn + 1 end
							end
						end
					end
				end
			end
		end
		log("OnClientInvoke wrapped: " .. wn)
	end
	log("● เริ่มบันทึก Remote แล้ว (" .. (hookOk and "C→S+" or "") .. "S→C " .. n .. " ตัว) — เล่นเกมทำสิ่งที่อยากดัก แล้วกด START")
end

cleanup[#cleanup + 1] = function() if RL.on then rlToggle(false) end end
UI.smallBtn("LAST", -134, function()
	local fn = setclipboard or toclipboard
	local last = RL.buf[#RL.buf]
	if not last then log("Remote Log is empty") return end
	if type(fn) == "function" then
		pcall(fn, last)
		log("copied last remote call")
	else
		log(last)
	end
end)

local function classify(o)
	local top, d, guard = o, 0, 0
	while guard < 250 do
		guard = guard + 1
		local okP, par = pcall(function() return top.Parent end)
		if not okP or not par or par == game then break end
		top = par
		d = d + 1
	end
	local okP2, par2 = pcall(function() return top.Parent end)
	if not okP2 or par2 ~= game then return "nil" end
	local cn = safeClassOf(top)
	if cn == "CoreGui" or cn == "CorePackages" or cn == "RobloxReplicatedStorage" then return "core" end
	return "game"
end

-- ============================================================================
-- โมดูลการดึงข้อมูล
-- ============================================================================
local M = {}
local function addModule(def, default) def.default = default ~= false M[#M + 1] = def end

addModule({
	id = "remotelog", label = "● Remote Log (เปิดก่อนแล้วเล่นเกม)", file = "23_remote_log.txt", onToggle = rlToggle, run = function()
		local L = {
			"บันทึกการเรียก Remote ระหว่างเล่น (C→S = ส่งไปเซิร์ฟเวอร์ / S→C = เซิร์ฟเวอร์ส่งมา)",
			"==========================================================================",
		}
		local cl = {}
		for k, v in pairs(RL.cnt) do cl[#cl + 1] = { k, v } end
		table.sort(cl, function(a, b) return a[2] > b[2] end)
		L[#L + 1] = "--- call counts (top 120) ---"
		for i = 1, math.min(120, #cl) do L[#L + 1] = string.format("%6d  %s", cl[i][2], cl[i][1]) end
		L[#L + 1] = ""
		if #RL.buf == 0 then
			L[#L + 1] = "(ยังไม่มีข้อมูล — เปิดสวิตช์ Remote Log ก่อน แล้วเล่นเกมทำ action ที่ต้องการ จากนั้นกด START)"
		end
		for _, l in ipairs(RL.buf) do L[#L + 1] = l end
		L[#L + 1] = "total: " .. #RL.buf
		return L
	end
}, false)

addModule({
	id = "summary", label = "สรุปแมพ & Services", file = "01_summary.txt", run = function()
		local S = {}
		local info = {}
		pcall(function() info = MarketplaceService:GetProductInfo(game.PlaceId) end)
		local ex = "?"
		pcall(function() if identifyexecutor then ex = tostring(identifyexecutor()) end end)
		S[#S + 1] = "MapName         : " .. mapName
		S[#S + 1] = "Creator         : " .. tostring(info.Creator and info.Creator.Name or "?")
		S[#S + 1] = "Desc            : " .. cut(oneLine(info.Description), 300)
		S[#S + 1] = "PlaceId         : " .. tostring(game.PlaceId) .. "   GameId: " .. tostring(game.GameId) .. "   PlaceVersion: " .. tostring(game.PlaceVersion)
		S[#S + 1] = "JobId           : " .. tostring(game.JobId)
		S[#S + 1] = "Player          : " .. lp.Name .. " (" .. tostring(lp.UserId) .. ")   Players online: " .. #Players:GetPlayers()
		S[#S + 1] = "Time            : " .. os.date("%Y-%m-%d %H:%M:%S")
		S[#S + 1] = "StreamingEnabled: " .. tostring(workspace.StreamingEnabled) .. "   Gravity: " .. tostring(workspace.Gravity)
		if workspace.StreamingEnabled then
			S[#S + 1] = "WARNING: StreamingEnabled=true -> เดินไปหลายจุดหรือขึ้นรถสำรวจแมพ แล้วกด START/SNAPSHOT ซ้ำ"
		end
		S[#S + 1] = "Executor        : " .. ex
		S[#S + 1] = string.format("ฟีเจอร์ตัวรัน   : writefile=%s decompile=%s getnilinstances=%s getscripts=%s getloadedmodules=%s",
			tostring(HAS.write), tostring(HAS.decompile), tostring(HAS.nilinst), tostring(HAS.scripts), tostring(HAS.modules))
		S[#S + 1] = "Instances ที่สแกน: " .. #(ALL or {}) .. "   (nil-parent แยกเก็บ: " .. #(NIL or {}) .. ")"
		if NIL and #NIL > 0 then
			local nc = {}
			for _, o in ipairs(NIL) do local cn = safeClassOf(o); nc[cn] = (nc[cn] or 0) + 1 end
			local arr0 = {}
			for cn, k in pairs(nc) do arr0[#arr0 + 1] = { cn, k } end
			table.sort(arr0, function(x, y) return x[2] > y[2] end)
			local t0 = {}
			for i = 1, math.min(16, #arr0) do t0[#t0 + 1] = arr0[i][1] .. "=" .. arr0[i][2] end
			S[#S + 1] = "nil-parent Top: " .. table.concat(t0, ", ")
		end
		local h = getHrp()
		if h then S[#S + 1] = string.format("MyPos           : %.0f,%.0f,%.0f", h.Position.X, h.Position.Y, h.Position.Z) end
		S[#S + 1] = "Workspace attrs :" .. attrStr(workspace)
		S[#S + 1] = ""
		S[#S + 1] = "--- Lighting ---"
		pcall(function()
			S[#S + 1] = string.format("ClockTime=%.2f TimeOfDay=%s Brightness=%s Ambient=%s FogEnd=%s",
				Lighting.ClockTime, tostring(Lighting.TimeOfDay), tostring(Lighting.Brightness),
				tostring(Lighting.Ambient), tostring(Lighting.FogEnd))
			S[#S + 1] = "Lighting attrs:" .. attrStr(Lighting)
		end)
		S[#S + 1] = ""
		S[#S + 1] = "--- Teams ---"
		local okT, teams = pcall(function() return game:GetService("Teams"):GetChildren() end)
		if okT and type(teams) == "table" then
			for _, t in ipairs(teams) do S[#S + 1] = safeNameOf(t) .. " [" .. safeClassOf(t) .. "]" end
		end
		S[#S + 1] = ""
		S[#S + 1] = "--- Services (children | descendants) ---"
		for _, name in ipairs(SERVICE_NAMES) do
			local s = svc(name)
			if s then
				local nd, nk = 0, 0
				pcall(function() nk = #s:GetChildren() end)
				pcall(function() nd = #s:GetDescendants() end)
				S[#S + 1] = string.format("%-20s %6d | %d", name, nk, nd)
			end
		end
		S[#S + 1] = ""
		S[#S + 1] = "--- สถิติชนิด Instance (Top 100) ---"
		local counts = {}
		for i, o in ipairs(ALL or {}) do
			if i % 2000 == 0 then pace() end
			local cn = safeClassOf(o)
			counts[cn] = (counts[cn] or 0) + 1
		end
		local arr = {}
		for cn, n in pairs(counts) do arr[#arr + 1] = { cn, n } end
		table.sort(arr, function(a, b) return a[2] > b[2] end)
		for i = 1, math.min(100, #arr) do S[#S + 1] = string.format("%-28s %d", arr[i][1], arr[i][2]) end
		S[#S + 1] = ""
		S[#S + 1] = "--- Workspace ชั้นบนสุด (class | name | descendants) ---"
		for _, c in ipairs(workspace:GetChildren()) do
			if not notPlayerChar(c) then
				local n = 0
				pcall(function() n = #c:GetDescendants() end)
				S[#S + 1] = string.format("%-18s %-32s %d%s", safeClassOf(c), cut(safeNameOf(c), 32), n, attrStr(c))
			end
		end
		S[#S + 1] = ""
		S[#S + 1] = "--- PlayerGui (ScreenGui ทั้งหมดในแมพนี้) ---"
		if pg then
			for _, g in ipairs(pg:GetChildren()) do
				if g:IsA("ScreenGui") and g ~= gui then
					local nd = 0
					pcall(function() nd = #g:GetDescendants() end)
					S[#S + 1] = string.format("%-28s Enabled=%s descendants=%d", cut(safeNameOf(g), 28), tostring(g.Enabled), nd)
				end
			end
		end
		return S
	end
})

addModule({
	id = "services", label = "แผนผังทุก Service (RS/Starter/…)", file = "02_services_tree.txt", run = function()
		local L = {}
		for _, name in ipairs(SERVICE_NAMES) do
			if name ~= "Workspace" then
				local s = svc(name)
				if s and #s:GetChildren() > 0 then
					L[#L + 1] = "################ " .. name .. " ################"
					local sub = {}
					treeLines(s, sub, false, CFG.MaxServiceLines)
					for _, l in ipairs(sub) do L[#L + 1] = l end
					L[#L + 1] = ""
				end
			end
		end
		return L
	end
})

addModule({
	id = "tree", label = "แผนผัง Workspace (ย่อพาร์ทธรรมดา)", file = "03_workspace_tree.txt", run = function()
		local L = {}
		treeLines(workspace, L, true, CFG.MaxTreeLines, notPlayerChar)
		return L
	end
})

addModule({
	id = "treefull", label = "แผนผัง Workspace เต็ม (ทุกชิ้น • ใหญ่)", file = "04_workspace_tree_FULL.txt", run = function()
		local L = {}
		treeLines(workspace, L, false, CFG.MaxTreeLines, notPlayerChar)
		return L
	end
}, false)

addModule({
	id = "gui", label = "GUI ทั้งหมด (รวมที่ซ่อน)", file = "05_playergui_all.txt", run = function()
		local G = { "class | vis | eff | text | name | size | path(ใต้ PlayerGui)" }
		local n = 0
		for _, g in ipairs(guiList()) do
			pace()
			n = n + 1
			if n <= CFG.MaxGuiLines then
				local isObj = g:IsA("GuiObject")
				local isText = g:IsA("TextLabel") or g:IsA("TextButton") or g:IsA("TextBox")
				if isObj or g:IsA("ScreenGui") then
					local rel = fullPath(g):gsub("^Players/[^/]+/PlayerGui/", "")
					local img = ""
					if g:IsA("ImageLabel") or g:IsA("ImageButton") then
						pcall(function() img = " img=" .. cut(tostring(g.Image), 50) end)
					end
					local txt = ""
					if isText then pcall(function() txt = cut(oneLine(g.Text), 50) end) end
					local visFlag = false
					pcall(function() visFlag = isObj and g.Visible or g.Enabled end)
					local szStr = ""
					if isObj then pcall(function() szStr = math.floor(g.AbsoluteSize.X) .. "x" .. math.floor(g.AbsoluteSize.Y) end) end
					G[#G + 1] = string.format("%s | vis=%s | eff=%s | %s | %s | %s | %s%s%s",
						safeClassOf(g), tostring(visFlag), tostring(effVisible(g)),
						txt, cut(safeNameOf(g), 30), szStr, cut(rel, 150), img, attrStr(g))
				end
			end
		end
		G[#G + 1] = "total: " .. n .. (n > CFG.MaxGuiLines and (" (ตัดที่ " .. CFG.MaxGuiLines .. ")") or "")
		local SUM = { "--- SUMMARY per ScreenGui (buttons / labels / boxes / scrolls + sample button texts) ---" }
		if pg then
			for _, g0 in ipairs(pg:GetChildren()) do
				if g0:IsA("ScreenGui") and g0 ~= gui then
					pace()
					local cb, cl, cx, cs = 0, 0, 0, 0
					local texts, seenT = {}, {}
					local okD, desc = pcall(function() return g0:GetDescendants() end)
					if okD and type(desc) == "table" then
						for _, d in ipairs(desc) do
							if d:IsA("TextButton") then
								cb = cb + 1
								local tx = ""
								pcall(function() tx = cut(oneLine(d.Text), 30) end)
								if #tx > 0 and not seenT[tx] and #texts < 16 then seenT[tx] = true texts[#texts + 1] = tx end
							elseif d:IsA("TextLabel") then cl = cl + 1
							elseif d:IsA("TextBox") then cx = cx + 1
							elseif d:IsA("ScrollingFrame") then cs = cs + 1 end
						end
					end
					SUM[#SUM + 1] = string.format("%s | enabled=%s | buttons=%d labels=%d boxes=%d scrolls=%d | btn: %s",
						cut(safeNameOf(g0), 30), tostring(g0.Enabled), cb, cl, cx, cs, table.concat(texts, " / "))
				end
			end
		end
		SUM[#SUM + 1] = ""
		for _, l in ipairs(G) do SUM[#SUM + 1] = l end
		return SUM
	end
})

addModule({
	id = "prompts", label = "จุดโต้ตอบ (ProximityPrompt)", file = "06_proximity_prompts.txt", run = function()
		local rows, n = {}, 0
		for i, d in ipairs(IDX.prompts) do
			if i % 500 == 0 then pace() end
			local dist = distOf(d)
			if inRadius(dist) then
				n = n + 1
				rows[#rows + 1] = {
					dist = dist,
					line = string.format("d=%-4s | [%s] | [%s] | en=%s | hold=%s | max=%s | key=%s | %s | %s%s%s",
						tostring(dist), oneLine(d.ActionText), oneLine(d.ObjectText),
						tostring(d.Enabled), tostring(d.HoldDuration), tostring(d.MaxActivationDistance),
						tostring(d.KeyboardKeyCode), posStr(d), fullPath(d), attrStr(d.Parent or d), tagsStr(d))
				}
			end
		end
		sortRows(rows)
		local P = { "dist | [action] | [object] | enabled | hold | maxDist | key | pos | path (เรียงจากใกล้ที่สุด)" }
		for _, r in ipairs(rows) do P[#P + 1] = r.line end
		P[#P + 1] = "total: " .. n
		return P
	end
})

addModule({
	id = "clicks", label = "ClickDetector / ปุ่มในโลก", file = "07_click_detectors.txt", run = function()
		local rows, n = {}, 0
		for i, d in ipairs(IDX.clicks) do
			if i % 500 == 0 then pace() end
			local dist = distOf(d)
			if inRadius(dist) then
				n = n + 1
				rows[#rows + 1] = {
					dist = dist,
					line = string.format("d=%-4s | max=%s | %s | %s%s%s",
						tostring(dist), tostring(d.MaxActivationDistance), posStr(d),
						fullPath(d), attrStr(d.Parent or d), tagsStr(d))
				}
			end
		end
		sortRows(rows)
		local C = { "dist | maxDist | pos | path (เรียงจากใกล้ที่สุด)" }
		for _, r in ipairs(rows) do C[#C + 1] = r.line end
		C[#C + 1] = "total: " .. n
		return C
	end
})

addModule({
	id = "remotes", label = "Remote / Bindable ทั้งเกม", file = "08_remotes_bindables.txt", run = function()
		local rows = {}
		for i, d in ipairs(IDX.remotes) do
			if i % 500 == 0 then pace() end
			rows[#rows + 1] = safeClassOf(d) .. " | " .. fullPath(d) .. " | parent=" .. (d.Parent and safeClassOf(d.Parent) or "nil") .. attrStr(d)
		end
		for _, d in ipairs(NIL or {}) do
			if isRemoteLike(d) then rows[#rows + 1] = safeClassOf(d) .. " | (nil)/" .. safeNameOf(d) .. " | parent=nil" .. attrStr(d) end
		end
		table.sort(rows)
		local R = { "class | path | parent   (รายชื่อเท่านั้น ไม่เรียกใช้)" }
		for _, r in ipairs(rows) do R[#R + 1] = r end
		R[#R + 1] = "total: " .. #rows
		return R
	end
})

addModule({
	id = "scripts", label = "สคริปต์ของเกมทั้งหมด + ถอดโค้ด", file = "09_scripts_inventory.txt", run = function()
		local cand, seen = {}, {}
		local nCore, nNil = 0, 0
		local nilList = {}
		local nilCand, nilSet = {}, {}
		local function consider(o)
			if typeof(o) ~= "Instance" or seen[o] then return end
			seen[o] = true
			if not o:IsA("LuaSourceContainer") then return end
			local kind = classify(o)
			if kind == "game" then
				cand[#cand + 1] = o
			elseif kind == "core" then
				nCore = nCore + 1
				if CFG.IncludeCoreScripts then cand[#cand + 1] = o end
			else
				nNil = nNil + 1
				if CFG.IncludeNilScripts and #nilCand < CFG.MaxNilScripts then
					nilCand[#nilCand + 1] = o
				elseif not o:IsA("ModuleScript") and #nilList < 400 then
					nilList[#nilList + 1] = o
				end
			end
		end

		for i, o in ipairs(ALL or {}) do
			if i % 1000 == 0 then pace() end
			consider(o)
		end
		for _, o in ipairs(NIL or {}) do
			consider(o)
		end
		for _, getter in ipairs({ HAS.scripts and getscripts or false, HAS.modules and getloadedmodules or false }) do
			if getter then
				pcall(function()
					local res = getter()
					if type(res) == "table" then
						for _, sc in ipairs(res) do
							if typeof(sc) == "Instance" then consider(sc) end
						end
					end
				end)
			end
		end

		for _, o in ipairs(nilCand) do
			nilSet[o] = true
			cand[#cand + 1] = o
		end

		local list = {}
		for _, sc in ipairs(cand) do
			local path = fullPath(sc)
			if nilSet[sc] then path = "(nil)/" .. path end
			local rank = 1
			if path:find("PlayerModule", 1, true) or path:find("RbxCharacterSounds", 1, true) or path:find("ChatScript", 1, true) then rank = 9
			elseif nilSet[sc] then rank = 5
			elseif path:sub(1, 9) == "Workspace" then rank = 6
			elseif sc:IsA("ModuleScript") then rank = 3 end
			list[#list + 1] = { s = sc, path = path, rank = rank }
		end
		table.sort(list, function(a2, b2)
			if a2.rank ~= b2.rank then return a2.rank < b2.rank end
			return a2.path < b2.path
		end)

		SRC = {}
		local L = {
			"class | status | enabled/run | path | file",
			string.format("สคริปต์ของเกม=%d  | ข้ามสคริปต์ภายใน Roblox=%d%s | nil-parent=%d", #list, nCore, CFG.IncludeCoreScripts and " (ถอดด้วย)" or "", nNil),
			HAS.decompile and ("ถอดโค้ดลงโฟลเดอร์ " .. dir .. "/scripts") or "(ตัวรันนี้ไม่มี decompile — จะได้เฉพาะรายชื่อสคริปต์)",
		}
		local okN, failN, dupN = 0, 0, 0
		local seenSrc, usedNames = {}, {}
		local total = math.min(#list, CFG.MaxScripts)
		for i, e in ipairs(list) do
			pace()
			local sc = e.s
			local status, fname = "listed", ""
			local extra = ""
			pcall(function()
				if sc:IsA("BaseScript") then extra = tostring(sc.Enabled) end
				if sc:IsA("Script") then extra = extra .. "/" .. tostring(sc.RunContext) end
			end)
			if HAS.decompile and i <= CFG.MaxScripts then
				local ok, src = runWithTimeout(function() return decompile(sc) end, CFG.DecompileTimeout)
				if ok and type(src) == "string" and #src > 0 then
					local key = #src .. ":" .. src:sub(1, 300) .. src:sub(-300)
					if seenSrc[key] then
						status = "dup"
						fname = "(เหมือนกับ " .. seenSrc[key] .. ")"
						dupN = dupN + 1
					else
						local rel = (e.path:gsub("^Players/[^/]+/", ""))
						local base = "scripts/" .. safeFile(rel, 110)
						local name = base .. ".lua"
						if usedNames[name] then name = base .. "_" .. i .. ".lua" end
						usedNames[name] = true
						local header = string.format("-- Path: %s\n-- Class: %s  %s\n-- Decompiled by BALL KUN Universal Map Dump\n\n", e.path, safeClassOf(sc), extra)
						local sOk = save(name, { header .. src })
						status = sOk and "ok" or "write-fail"
						fname = name
						seenSrc[key] = name
						okN = okN + 1
						SRC[#SRC + 1] = { path = e.path, src = src, class = safeClassOf(sc) }
					end
				else
					status = "fail:" .. cut(tostring(src), 40)
					failN = failN + 1
				end
				if i % 20 == 0 then
					log(string.format("ถอดโค้ด %d/%d ...", i, total))
					setProgress(i / math.max(1, total), string.format("ถอดโค้ด %d/%d", i, total))
				end
			end
			L[#L + 1] = string.format("%s | %s | %s | %s | %s", safeClassOf(sc), status, extra, e.path, fname)
		end
		if #nilList > 0 then
			L[#L + 1] = ""
			L[#L + 1] = "--- สคริปต์ nil-parent (ไม่ใช่ Module, ไม่ถอด) ---"
			for _, o in ipairs(nilList) do L[#L + 1] = safeClassOf(o) .. " | " .. safeNameOf(o) end
		end
		L[#L + 1] = ""
		L[#L + 1] = "total game scripts: " .. #list .. "   decompiled ok=" .. okN .. " dup=" .. dupN .. " fail=" .. failN
		return L
	end
})

addModule({
	id = "usage", label = "ดัชนีการใช้ Remote ในโค้ด", file = "10_remote_usage_index.txt", run = function()
		local out = { "ดัชนีการใช้ Remote ในสคริปต์ (จากโค้ดที่ถอดได้)", "==========================================" }
		if not SRC or #SRC == 0 then
			out[#out + 1] = "(ไม่มีซอร์ส — ต้องเปิด 'สคริปต์ทั้งหมด + ถอดโค้ด' และตัวรันต้องรองรับ decompile)"
			return out
		end
		local pats = { "FireServer", "InvokeServer", "OnClientEvent", "OnClientInvoke" }
		out[#out + 1] = ""
		out[#out + 1] = "### A) บรรทัดที่เรียก/ฟัง Remote"
		for _, s in ipairs(SRC) do
			pace()
			local ln, first = 0, true
			for line in (s.src .. "\n"):gmatch("([^\n]*)\n") do
				ln = ln + 1
				for _, p in ipairs(pats) do
					if line:find(p, 1, true) then
						if first then out[#out + 1] = "" out[#out + 1] = ">>> " .. s.path first = false end
						out[#out + 1] = "  L" .. ln .. ": " .. cut((line:gsub("^%s+", "")), 220)
						break
					end
				end
			end
			if #out > 60000 then out[#out + 1] = "... ตัด" break end
		end
		out[#out + 1] = ""
		out[#out + 1] = "### B) ชื่อ Remote → สคริปต์ที่อ้างถึงชื่อนั้น"
		local names, done = {}, {}
		for i, d in ipairs(ALL or {}) do
			if i % 1000 == 0 then pace() end
			local nm = safeNameOf(d)
			if isRemoteLike(d) and #nm >= 2 and not done[nm] then
				done[nm] = true
				names[#names + 1] = { nm, safeClassOf(d) }
			end
		end
		table.sort(names, function(a, b) return a[1] < b[1] end)
		for _, nm in ipairs(names) do
			pace()
			local hits = {}
			for _, s in ipairs(SRC) do
				if s.src:find(nm[1], 1, true) then hits[#hits + 1] = s.path end
			end
			if #hits > 0 then
				local shown = {}
				for i = 1, math.min(10, #hits) do shown[i] = hits[i] end
				out[#out + 1] = string.format("%s [%s] | %d สคริปต์ | %s%s", nm[1], nm[2], #hits, table.concat(shown, " ; "), #hits > 10 and " ; ..." or "")
			end
		end
		return out
	end
})

addModule({
	id = "player", label = "ผู้เล่น / ค่าเงิน / รถ & ไอเทมของฉัน", file = "11_player_and_assets.txt", run = function()
		local V = { "--- ค่าใน Player (leaderstats / Data / Stats ฯลฯ) ---" }
		for _, c in ipairs(lp:GetChildren()) do
			if c ~= pg and (c:IsA("Folder") or c:IsA("ValueBase") or c:IsA("Configuration")) then
				V[#V + 1] = safeClassOf(c) .. " | " .. safeNameOf(c) .. (c:IsA("ValueBase") and valStr(c) or "") .. attrStr(c)
				if not c:IsA("ValueBase") then
					local okD, desc = pcall(function() return c:GetDescendants() end)
					if okD and type(desc) == "table" then
						for _, d in ipairs(desc) do
							pace()
							V[#V + 1] = "   " .. safeClassOf(d) .. " | " .. cut((fullPath(d):gsub("^Players/[^/]+/", "")), 100) .. (d:IsA("ValueBase") and valStr(d) or "") .. attrStr(d)
						end
					end
				end
			end
		end
		V[#V + 1] = "--- Player Attributes ---"
		for _, l in ipairs(attrLong(lp)) do V[#V + 1] = "   " .. l end
		V[#V + 1] = ""
		V[#V + 1] = "--- Backpack & Character Tools ---"
		local bp = lp:FindFirstChildOfClass("Backpack")
		if bp then
			for _, t in ipairs(bp:GetChildren()) do
				V[#V + 1] = "   Backpack: " .. safeNameOf(t) .. " [" .. safeClassOf(t) .. "]" .. attrStr(t)
			end
		end
		if lp.Character then
			for _, t in ipairs(lp.Character:GetChildren()) do
				if t:IsA("Tool") then V[#V + 1] = "   Equipped: " .. safeNameOf(t) .. " [" .. safeClassOf(t) .. "]" .. attrStr(t) end
			end
			V[#V + 1] = "--- Character Attributes ---"
			for _, l in ipairs(attrLong(lp.Character)) do V[#V + 1] = "   " .. l end
			local hum0 = lp.Character:FindFirstChildOfClass("Humanoid")
			if hum0 then
				V[#V + 1] = "--- Humanoid Attributes ---"
				for _, l in ipairs(attrLong(hum0)) do V[#V + 1] = "   " .. l end
			end
		end
		V[#V + 1] = ""
		V[#V + 1] = "--- ยานพาหนะ / ที่นั่งที่พบในแมพ ---"
		local seatCount = 0
		for i, d in ipairs(IDX.seats) do
			if i % 500 == 0 then pace() end
			if d:IsA("VehicleSeat") then
				seatCount = seatCount + 1
				local m = d:FindFirstAncestorOfClass("Model") or d.Parent
				local occName = "none"
				pcall(function() if d.Occupant and d.Occupant.Parent then occName = safeNameOf(d.Occupant.Parent) end end)
				V[#V + 1] = string.format("VehicleSeat | model=%s | d=%s | %s | occupant=%s%s",
					m and safeNameOf(m) or "?", distOf(d), posStr(d), occName, m and attrStr(m) or "")
			end
		end
		if seatCount == 0 then V[#V + 1] = "(ไม่พบ VehicleSeat ใน Workspace)" end
		V[#V + 1] = ""
		V[#V + 1] = "--- My vehicle (seated in it, or model named after me) ---"
		local mine = false
		for _, d in ipairs(IDX.seats) do
			local m = d:FindFirstAncestorOfClass("Model")
			local occ
			pcall(function() occ = d.Occupant end)
			local isMe = (occ and lp.Character and occ.Parent == lp.Character) or (m and safeNameOf(m):lower():find(lp.Name:lower(), 1, true))
			if isMe and m then
				mine = true
				V[#V + 1] = "Vehicle: " .. fullPath(m) .. " | " .. posStr(m) .. " | d=" .. distOf(m)
				for _, l in ipairs(attrLong(m)) do V[#V + 1] = "   " .. cut(l, 180) end
			end
		end
		if not mine then V[#V + 1] = "(none found)" end
		return V
	end
})

addModule({
	id = "world", label = "ป้ายในโลก / NPC / ที่นั่ง / ค่าในแมพ", file = "12_world_labels_npc_seats.txt", run = function()
		local W1, W2, W3, W4 = { "--- ป้ายข้อความในโลก (Billboard/SurfaceGui) ---" }, { "--- NPC (Humanoid ที่ไม่ใช่ผู้เล่น) ---" },
			{ "--- ที่นั่งทั้งหมด ---" }, { "--- ค่า Value ใน Workspace ---" }
		for i, d in ipairs(DESC or {}) do
			if i % 400 == 0 then pace() end
			if (d:IsA("TextLabel") or d:IsA("TextButton")) and #W1 < 4500
				and (d:FindFirstAncestorOfClass("BillboardGui") or d:FindFirstAncestorOfClass("SurfaceGui")) then
				local tx = ""
				pcall(function() tx = d.Text end)
				if #tx > 0 then
					W1[#W1 + 1] = string.format("[%s] d=%s | %s | %s", cut(oneLine(tx), 70), distOf(d), posStr(d), fullPath(d))
				end
			elseif d:IsA("Humanoid") and #W2 < 2500 then
				local m = d.Parent
				if m and not notPlayerChar(m) then
					W2[#W2 + 1] = string.format("%s | d=%s | %s | %s%s", cut(safeNameOf(m), 35), distOf(m), posStr(m), fullPath(m), attrStr(m))
				end
			elseif (d:IsA("Seat") or d:IsA("VehicleSeat")) and #W3 < 3500 then
				W3[#W3 + 1] = string.format("%s | d=%s | %s | %s%s", safeClassOf(d), distOf(d), posStr(d), fullPath(d), attrStr(d))
			elseif d:IsA("ValueBase") and #W4 < 4000 and not d:IsDescendantOf(Players) then
				W4[#W4 + 1] = safeClassOf(d) .. " | " .. fullPath(d) .. valStr(d) .. attrStr(d)
			end
		end
		local out = {}
		for _, part in ipairs({ W1, W2, W3, W4 }) do
			for _, l in ipairs(part) do out[#out + 1] = l end
			out[#out + 1] = ""
		end
		return out
	end
})

addModule({
	id = "sysscan", label = "คัดกรอง Remote/Module/Value ระบบหลัก", file = "13_systems_keyword_scan.txt", run = function()
		local REM, MOD, VAL = {}, {}, {}
		for i, d in ipairs(ALL or {}) do
			if i % 300 == 0 then pace() end
			local isRem = isRemoteLike(d)
			local isMod = d:IsA("LuaSourceContainer")
			local isVal = d:IsA("ValueBase")
			if (isRem or isMod or isVal) and (#REM + #MOD + #VAL) < CFG.MaxScanLines then
				local hit = matchKeywords(buildSearchBlob(d), SYSTEM_KEYS)
				if #hit > 0 then
					local line = string.format("%s | keys[%s] | %s%s%s",
						safeClassOf(d), table.concat(hit, ","), fullPath(d), isVal and valStr(d) or "", attrStr(d))
					if isRem then REM[#REM + 1] = line
					elseif isMod then MOD[#MOD + 1] = line
					else VAL[#VAL + 1] = line end
				end
			end
		end
		local out = {
			"BALL KUN • UNIVERSAL SYSTEMS SCAN (อ่านอย่างเดียว)",
			"==================================================",
			"",
			"--- Remotes / Bindables (" .. #REM .. ") ---",
		}
		for _, l in ipairs(REM) do out[#out + 1] = l end
		out[#out + 1] = ""
		out[#out + 1] = "--- Scripts / ModuleScripts (" .. #MOD .. ") ---"
		for _, l in ipairs(MOD) do out[#out + 1] = l end
		out[#out + 1] = ""
		out[#out + 1] = "--- ValueBases (" .. #VAL .. ") ---"
		for _, l in ipairs(VAL) do out[#out + 1] = l end
		return out
	end
})

addModule({
	id = "locations", label = "ตำแหน่งจุดโต้ตอบ/ป้าย/จุดสำคัญในแมพ", file = "14_world_locations_index.txt", run = function()
		local locRows = {}
		local kindCount = {}
		local ZONE_KEYS = { "spawn", "location", "job", "vehicle", "shop", "zone", "teleport", "warp", "checkpoint", "station", "garage", "npc", "farm", "mine", "fish", "race" }
		for i, d in ipairs(DESC or {}) do
			if i % 300 == 0 then pace() end
			if #locRows >= CFG.MaxScanLines then break end
			local kind, extra
			if d:IsA("ProximityPrompt") then
				kind = "PROMPT"
				extra = string.format("act=[%s] obj=[%s] en=%s", oneLine(d.ActionText), oneLine(d.ObjectText), tostring(d.Enabled))
			elseif d:IsA("ClickDetector") then
				kind, extra = "CLICK", "max=" .. tostring(d.MaxActivationDistance)
			elseif d:IsA("SpawnLocation") then
				kind, extra = "SPAWN", "team=" .. tostring(d.TeamColor)
			elseif d:IsA("Seat") or d:IsA("VehicleSeat") then
				kind, extra = "SEAT", safeClassOf(d)
			elseif (d:IsA("TextLabel") or d:IsA("TextButton"))
				and (d:FindFirstAncestorOfClass("BillboardGui") or d:FindFirstAncestorOfClass("SurfaceGui")) then
				local tx = ""
				pcall(function() tx = d.Text end)
				if #tx > 0 and #tx <= 70 then
					kind, extra = "SIGN", "text=[" .. cut(oneLine(tx), 60) .. "]"
				end
			elseif d:IsA("BasePart") or d:IsA("Model") or d:IsA("Attachment") then
				local dName = safeNameOf(d)
				local hit = matchKeywords(dName .. " " .. table.concat(attrLong(d), " "), SYSTEM_KEYS)
				if #hit > 0 then
					kind, extra = "SPOT", "keys[" .. table.concat(hit, ",") .. "]"
				else
					local invisible = d:IsA("Attachment") or (d:IsA("BasePart") and (d.Transparency >= 0.9 or not d.CanCollide))
					local direct = d:IsA("Model")
					if invisible or direct then
						local c, depth = d.Parent, 0
						while c and c ~= workspace and depth < (direct and 1 or 5) do
							local ln = safeNameOf(c):lower()
							for _, zk in ipairs(ZONE_KEYS) do
								if ln:find(zk, 1, true) then kind, extra = "ZONE", "in[" .. safeNameOf(c) .. "]" break end
							end
							if kind then break end
							c, depth = c.Parent, depth + 1
						end
					end
				end
			end
			if kind and not isPlayerDescendant(d) and inRadius(distOf(d)) then
				local p = posOf(d)
				if p then
					kindCount[kind] = (kindCount[kind] or 0) + 1
					local dist = distOf(d)
					locRows[#locRows + 1] = {
						dist = dist,
						line = string.format("%-8s | d=%-4s | pos=%.0f,%.0f,%.0f | %s | %s%s",
							kind, tostring(dist), p.X, p.Y, p.Z, extra, cut(fullPath(d), 140), attrStr(d))
					}
				end
			end
		end
		sortRows(locRows)
		local out = {
			"KIND     | dist | pos | detail | path (เรียงจากระยะใกล้ผู้เล่นที่สุด)",
			"======================================================================",
		}
		for _, r in ipairs(locRows) do out[#out + 1] = r.line end
		local kc = {}
		for k, v in pairs(kindCount) do kc[#kc + 1] = k .. "=" .. v end
		table.sort(kc)
		out[#out + 1] = "counts: " .. table.concat(kc, " ")
		out[#out + 1] = "total: " .. #locRows
		return out
	end
})

addModule({
	id = "tagsattrs", label = "Tags & Attributes ทั้งเกม", file = "15_tags_attributes.txt", run = function()
		local L = { "--- CollectionService Tags ---" }
		local okT, tags = pcall(function() return CollectionService:GetAllTags() end)
		if okT and type(tags) == "table" then
			table.sort(tags)
			for _, tg in ipairs(tags) do
				pace()
				local okG, objs = pcall(function() return CollectionService:GetTagged(tg) end)
				objs = (okG and type(objs) == "table") and objs or {}
				L[#L + 1] = "# tag: " .. tostring(tg) .. "  (" .. #objs .. ")"
				for i = 1, math.min(#objs, 250) do
					L[#L + 1] = "   " .. safeClassOf(objs[i]) .. " | " .. fullPath(objs[i])
				end
			end
		else
			L[#L + 1] = "(อ่าน tag ไม่ได้)"
		end
		L[#L + 1] = ""
		L[#L + 1] = "--- Instances ที่มี Attributes ---"
		local n = 0
		for i, o in ipairs(ALL or {}) do
			if i % 500 == 0 then pace() end
			if n < 25000 then
				local a = attrLong(o)
				if #a > 0 and not isPlayerDescendant(o) then
					n = n + 1
					L[#L + 1] = safeClassOf(o) .. " | " .. cut(fullPath(o), 160)
					for _, l in ipairs(a) do L[#L + 1] = "      " .. l end
				end
			end
		end
		L[#L + 1] = "total instances with attrs: " .. n
		return L
	end
})

addModule({
	id = "settings", label = "ตั้งค่าเกมที่เจ้าของตั้งไว้ (Service props)", file = "16_game_settings.txt", run = function()
		local L = { "ค่าที่เจ้าของแมพตั้งไว้ (อ่านค่าเท่านั้น)", "=========================================" }
		local function dumpProps(inst, props)
			if not inst then return end
			L[#L + 1] = ""
			L[#L + 1] = "### " .. safeClassOf(inst) .. " (" .. safeNameOf(inst) .. ")"
			for _, p in ipairs(props) do
				local ok, v = pcall(function() return inst[p] end)
				if ok then L[#L + 1] = "  " .. p .. " = " .. cut(oneLine(v), 140) end
			end
		end
		dumpProps(workspace, { "Gravity", "FallenPartsDestroyHeight", "StreamingEnabled", "StreamingMinRadius", "StreamingTargetRadius",
			"StreamingIntegrityMode", "AirDensity", "GlobalWind", "PhysicsSteppingMethod", "Retargeting", "AllowThirdPartySales",
			"FilteringEnabled", "SignalBehavior", "InterpolationThrottling", "MeshPartHeadsAndAccessories" })
		pcall(function()
			dumpProps(workspace.Terrain, { "WaterColor", "WaterReflectance", "WaterTransparency", "WaterWaveSize", "WaterWaveSpeed", "Decoration" })
		end)
		if workspace.CurrentCamera then
			dumpProps(workspace.CurrentCamera, { "FieldOfView", "CameraType", "CameraSubject", "NearPlaneZ", "MaxAxisFieldOfView" })
		end
		dumpProps(Lighting, { "Ambient", "Brightness", "ClockTime", "TimeOfDay", "ColorShift_Bottom", "ColorShift_Top",
			"EnvironmentDiffuseScale", "EnvironmentSpecularScale", "ExposureCompensation", "FogColor", "FogEnd", "FogStart",
			"GeographicLatitude", "GlobalShadows", "OutdoorAmbient", "ShadowSoftness", "Technology" })
		for _, c in ipairs(Lighting:GetChildren()) do
			local propsByClass = {
				Atmosphere = { "Density", "Color", "Decay", "Glare", "Haze", "Offset" },
				BloomEffect = { "Intensity", "Size", "Threshold", "Enabled" },
				ColorCorrectionEffect = { "Brightness", "Contrast", "Saturation", "TintColor", "Enabled" },
				SunRaysEffect = { "Intensity", "Spread", "Enabled" },
				DepthOfFieldEffect = { "FarIntensity", "FocusDistance", "InFocusRadius", "NearIntensity", "Enabled" },
				BlurEffect = { "Size", "Enabled" },
				Sky = { "SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp", "StarCount", "CelestialBodiesShown" },
			}
			if propsByClass[safeClassOf(c)] then dumpProps(c, propsByClass[safeClassOf(c)]) end
		end
		local sp = svc("StarterPlayer")
		if sp then
			dumpProps(sp, { "CameraMaxZoomDistance", "CameraMinZoomDistance", "CameraMode", "CharacterWalkSpeed", "CharacterJumpPower",
				"CharacterJumpHeight", "CharacterUseJumpPower", "CharacterMaxSlopeAngle", "HealthDisplayDistance", "NameDisplayDistance",
				"LoadCharacterAppearance", "UserEmotesEnabled", "DevComputerMovementMode", "DevTouchMovementMode",
				"DevComputerCameraMovementMode", "DevTouchCameraMovementMode", "EnableMouseLockOption", "AutoJumpEnabled",
				"AvatarJointUpgrade" })
		end
		dumpProps(Players, { "RespawnTime", "CharacterAutoLoads", "MaxPlayers", "PreferredPlayers", "LocalPlayer", "BubbleChat",
			"UseStrafingAnimations", "ClassicChat" })
		local ss = svc("SoundService")
		if ss then dumpProps(ss, { "AmbientReverb", "DistanceFactor", "DopplerScale", "RolloffScale", "RespectFilteringEnabled" }) end
		dumpProps(StarterGui, { "ScreenOrientation", "ShowDevelopmentGui", "VirtualCursorMode" })
		local tcs = svc("TextChatService")
		if tcs then dumpProps(tcs, { "ChatVersion", "CreateDefaultCommands", "CreateDefaultTextChannels" }) end
		L[#L + 1] = ""
		L[#L + 1] = "### ผู้เล่นในเซิร์ฟเวอร์ (ชื่อ | UserId | ทีม | leaderstats)"
		for _, pl in ipairs(Players:GetPlayers()) do
			local stats = {}
			local ls = pl:FindFirstChild("leaderstats")
			if ls then
				for _, v in ipairs(ls:GetChildren()) do
					if v:IsA("ValueBase") then stats[#stats + 1] = safeNameOf(v) .. "=" .. cut(oneLine(v.Value), 30) end
				end
			end
			L[#L + 1] = string.format("  %s | %s | %s | %s", pl.Name, tostring(pl.UserId), tostring(pl.Team), table.concat(stats, ", "))
		end
		L[#L + 1] = ""
		L[#L + 1] = "### LocalPlayer"
		for _, p in ipairs({ "AccountAge", "MembershipType", "CameraMode", "DevCameraOcclusionMode", "DevComputerMovementMode",
			"DevTouchMovementMode", "NameDisplayDistance", "HealthDisplayDistance", "Neutral", "Team", "TeamColor", "UserId" }) do
			local ok, v = pcall(function() return lp[p] end)
			if ok then L[#L + 1] = "  " .. p .. " = " .. cut(oneLine(v), 100) end
		end
		return L
	end
})

addModule({
	id = "assets", label = "Asset ID ทั้งหมด (Mesh/เสียง/รูป/อนิเมชัน)", file = "17_asset_ids.txt", run = function()
		local seen, rows = {}, {}
		local function add(kind, id, o)
			id = tostring(id or "")
			if id == "" or id == "0" then return end
			local key = kind .. "|" .. id
			local e = seen[key]
			if e then
				e.n = e.n + 1
			else
				e = { kind = kind, id = id, n = 1, path = cut(fullPath(o), 130) }
				seen[key] = e
				rows[#rows + 1] = e
			end
		end
		for i, o in ipairs(ALL or {}) do
			if i % 400 == 0 then pace() end
			pcall(function()
				if o:IsA("MeshPart") then add("Mesh", o.MeshId, o) add("Texture", o.TextureID, o)
				elseif o:IsA("SpecialMesh") then add("Mesh", o.MeshId, o) add("Texture", o.TextureId, o)
				elseif o:IsA("Sound") then add("Sound", o.SoundId, o)
				elseif o:IsA("ImageLabel") or o:IsA("ImageButton") then add("Image", o.Image, o)
				elseif o:IsA("Decal") or o:IsA("Texture") then add("Decal", o.Texture, o)
				elseif o:IsA("Animation") then add("Animation", o.AnimationId, o)
				elseif o:IsA("Sky") then
					add("Sky", o.SkyboxBk, o) add("Sky", o.SkyboxDn, o) add("Sky", o.SkyboxFt, o)
					add("Sky", o.SkyboxLf, o) add("Sky", o.SkyboxRt, o) add("Sky", o.SkyboxUp, o)
				elseif o:IsA("Shirt") then add("Clothing", o.ShirtTemplate, o)
				elseif o:IsA("Pants") then add("Clothing", o.PantsTemplate, o)
				end
			end)
		end
		table.sort(rows, function(a, b)
			if a.kind ~= b.kind then return a.kind < b.kind end
			return a.id < b.id
		end)
		local L = { "kind | assetId | ใช้กี่ที่ | ตัวอย่าง path" }
		for i, r in ipairs(rows) do
			if i > 40000 then L[#L + 1] = "... ตัด" break end
			L[#L + 1] = string.format("%-9s | %s | x%d | %s", r.kind, r.id, r.n, r.path)
		end
		L[#L + 1] = "total unique: " .. #rows
		return L
	end
})

addModule({
	id = "listeners", label = "ผู้ฟัง/handler (ใครฟัง Remote/ปุ่ม)", file = "18_listeners.txt", run = function()
		local L = { "handler ที่ผูกไว้ (จาก getconnections)  kind | path | จำนวน | สคริปต์:บรรทัด" }
		if type(getconnections) ~= "function" then
			L[#L + 1] = "(ตัวรันไม่มี getconnections)"
			return L
		end
		local function where(c)
			local fn
			pcall(function() fn = c.Function end)
			if type(fn) ~= "function" then return "?" end
			local scr, line = "", 0
			pcall(function()
				if type(getfenv) == "function" then
					local env = getfenv(fn)
					if env and typeof(env.script) == "Instance" then scr = fullPath(env.script) end
				end
			end)
			if scr == "" then
				pcall(function()
					if debug.info then
						local src2 = debug.info(fn, "s")
						if src2 then scr = tostring(src2) end
					end
				end)
			end
			pcall(function()
				local info = debug.getinfo(fn, "sl")
				if info then
					line = info.linedefined or info.currentline or 0
					if scr == "" then scr = tostring(info.source or "?") end
				end
			end)
			return (scr ~= "" and scr or "?") .. ":" .. tostring(line)
		end
		local function conn(kind, d, sig)
			local ok, cs = pcall(function() return getconnections(sig) end)
			if ok and type(cs) == "table" and #cs > 0 then
				local ws = {}
				for i = 1, math.min(#cs, 5) do ws[i] = where(cs[i]) end
				L[#L + 1] = kind .. " | " .. cut(fullPath(d), 130) .. " | x" .. #cs .. " | " .. table.concat(ws, " ; ")
			end
		end
		for i, d in ipairs(ALL or {}) do
			if i % 150 == 0 then pace() end
			if #L > 9000 then L[#L + 1] = "... ตัด" break end
			pcall(function()
				if d:IsA("RemoteEvent") or d:IsA("UnreliableRemoteEvent") then
					conn("OnClientEvent", d, d.OnClientEvent)
				elseif d:IsA("BindableEvent") then
					conn("Bindable.Event", d, d.Event)
				elseif (d:IsA("TextButton") or d:IsA("ImageButton")) and pg and d:IsDescendantOf(pg) then
					conn("Button.Click", d, d.MouseButton1Click)
					conn("Button.Activated", d, d.Activated)
				elseif d:IsA("ProximityPrompt") then
					conn("Prompt.Triggered", d, d.Triggered)
				elseif d:IsA("ClickDetector") then
					conn("ClickDetector", d, d.MouseClick)
				elseif (d:IsA("RemoteFunction") or d:IsA("BindableFunction")) and type(getcallbackvalue) == "function" then
					local prop = d:IsA("RemoteFunction") and "OnClientInvoke" or "OnInvoke"
					local okF, fnv = pcall(getcallbackvalue, d, prop)
					if okF and type(fnv) == "function" then
						L[#L + 1] = prop .. " | " .. cut(fullPath(d), 130) .. " | callback | " .. where({ Function = fnv })
					end
				end
			end)
		end
		return L
	end
})

addModule({
	id = "moddata", label = "ข้อมูล/Config ในโมดูล (ราคา ไอเทม ค่าตั้ง)", file = "19_module_data.txt", run = function()
		local L = { "ค่าที่ ModuleScript คืนมา (require ได้เฉพาะโมดูลที่เกมโหลดแล้ว) — มักเป็น config/ราคา/ไอเทม/สูตร", "" }
		local loaded, haveLoaded = {}, false
		if HAS.modules then
			pcall(function()
				local lm = getloadedmodules()
				if type(lm) == "table" then
					for _, m in ipairs(lm) do loaded[m] = true end
					haveLoaded = true
				end
			end)
		end
		if not haveLoaded and not CFG.RequireAllModules then
			L[#L + 1] = "(ตัวรันไม่มี getloadedmodules และ RequireAllModules=false จึงข้ามเพื่อความปลอดภัย — แตะปุ่ม CFG RequireAllModules ด้านล่างเพื่อเปิด)"
			return L
		end
		local n, skipped = 0, 0
		local PRI = { "config", "data", "item", "shop", "car", "vehicle", "job", "quest", "setting", "stat", "tune", "pet", "pass" }
		local modsSorted = {}
		for i, o in ipairs(ALL or {}) do
			if i % 2000 == 0 then pace() end
			if o:IsA("ModuleScript") then
				local ln, pr = safeNameOf(o):lower(), 1
				for _, k in ipairs(PRI) do if ln:find(k, 1, true) then pr = 0 break end end
				modsSorted[#modsSorted + 1] = { o = o, pr = pr, i = i }
			end
		end
		table.sort(modsSorted, function(a, b)
			if a.pr ~= b.pr then return a.pr < b.pr end
			return a.i < b.i
		end)
		for i2, e in ipairs(modsSorted) do
			local i, o = i2, e.o
			if i % 300 == 0 then pace() end
			if o:IsA("ModuleScript") and o:IsDescendantOf(game) then
				if haveLoaded and not loaded[o] and not CFG.RequireAllModules then
					skipped = skipped + 1
				elseif n < CFG.MaxModShape then
					n = n + 1
					local ok, res = runWithTimeout(function() return require(o) end, 4)
					L[#L + 1] = ">>> " .. fullPath(o)
					if ok and type(res) == "table" then
						dumpTable(res, L, "    ", 1, {}, { n = 800 })
					elseif ok then
						L[#L + 1] = "    = " .. ser(res, 0, 2, {})
					else
						L[#L + 1] = "    (error: " .. cut(tostring(res), 90) .. ")"
					end
				end
			end
		end
		L[#L + 1] = ""
		L[#L + 1] = "dumped=" .. n .. " skipped(not loaded)=" .. skipped
		return L
	end
})

addModule({
	id = "allvalues", label = "ค่าทั้งหมดในเกม (ValueBase ทุก Service + ผู้เล่นอื่น + Humanoid)", file = "20_all_values.txt", run = function()
		local L = { "class | path | value | attrs" }
		local n = 0
		local function valLong(o)
			local s = ""
			pcall(function() s = " = " .. cut(oneLine(o.Value), 220) end)
			return s
		end
		local function emit(o)
			if n >= CFG.MaxValues then return end
			if o:IsA("ValueBase") then
				n = n + 1
				L[#L + 1] = safeClassOf(o) .. " | " .. cut(fullPath(o), 190) .. valLong(o) .. attrStr(o)
			end
		end
		for i, o in ipairs(IDX.values) do
			if i % 500 == 0 then pace() end
			emit(o)
		end
		for _, o in ipairs(NIL or {}) do emit(o) end
		L[#L + 1] = "total ValueBase: " .. n .. (n >= CFG.MaxValues and " (capped)" or "")
		L[#L + 1] = ""
		L[#L + 1] = "--- Other players (name | userId | team | attrs | stats) ---"
		for _, pl in ipairs(Players:GetPlayers()) do
			if pl ~= lp then
				pace()
				L[#L + 1] = pl.Name .. " | " .. tostring(pl.UserId) .. " | " .. tostring(pl.Team) .. attrStr(pl)
				for _, c in ipairs(pl:GetChildren()) do
					if c:IsA("Folder") or c:IsA("ValueBase") or c:IsA("Configuration") then
						L[#L + 1] = "   " .. safeClassOf(c) .. " | " .. safeNameOf(c) .. (c:IsA("ValueBase") and valLong(c) or "") .. attrStr(c)
						if not c:IsA("ValueBase") then
							local okD, desc = pcall(function() return c:GetDescendants() end)
							if okD and type(desc) == "table" then
								for _, d in ipairs(desc) do
									L[#L + 1] = "      " .. safeClassOf(d) .. " | " .. safeNameOf(d) .. (d:IsA("ValueBase") and valLong(d) or "") .. attrStr(d)
								end
							end
						end
					end
				end
			end
		end
		L[#L + 1] = ""
		L[#L + 1] = "--- Humanoids (name | walk | jump | health | path) ---"
		local hn = 0
		for i, d in ipairs(DESC or {}) do
			if i % 500 == 0 then pace() end
			if hn < 1200 and d:IsA("Humanoid") then
				hn = hn + 1
				pcall(function()
					L[#L + 1] = string.format("%s | walk=%.1f | jump=%.1f | hp=%.0f/%.0f | %s",
						cut(d.Parent and safeNameOf(d.Parent) or safeNameOf(d), 35), d.WalkSpeed, d.JumpPower, d.Health, d.MaxHealth, cut(fullPath(d), 140))
				end)
			end
		end
		return L
	end
})

addModule({
	id = "sysgraph", label = "แผนที่ระบบอัตโนมัติ (จัดกลุ่ม Script/Remote/Module)", file = "21_systems_graph.txt", run = function()
		local out = {
			"AUTO SYSTEM MAP - works on any game (no keyword list needed)",
			"A) top-level containers   B) clusters of scripts that share Remotes/Modules   C) loose ends",
			"==========================================================================",
			"",
			"### A) Top-level containers (a folder is usually one system)",
		}
		local rows = {}
		for _, name in ipairs(SERVICE_NAMES) do
			local sv = svc(name)
			if sv and name ~= "Lighting" then
				for _, c in ipairs(sv:GetChildren()) do
					if not (name == "Workspace" and (notPlayerChar(c) or c:IsA("Camera") or c:IsA("Terrain"))) then
						pace()
						local nd, nr, ns, nv, np = 0, 0, 0, 0, 0
						local okD, dd = pcall(function() return c:GetDescendants() end)
						if okD and type(dd) == "table" then
							nd = #dd
							for i, x in ipairs(dd) do
								if i % 2000 == 0 then pace() end
								if isRemoteLike(x) then nr = nr + 1
								elseif x:IsA("LuaSourceContainer") then ns = ns + 1
								elseif x:IsA("ValueBase") then nv = nv + 1
								elseif x:IsA("ProximityPrompt") then np = np + 1 end
							end
						end
						rows[#rows + 1] = { nd = nd, line = string.format("%s/%s [%s] desc=%d remotes=%d scripts=%d values=%d prompts=%d",
							name, cut(safeNameOf(c), 40), safeClassOf(c), nd, nr, ns, nv, np) }
					end
				end
			end
		end
		table.sort(rows, function(a, b) return a.nd > b.nd end)
		for i, r in ipairs(rows) do
			if i > 800 then out[#out + 1] = "... (cut)" break end
			out[#out + 1] = r.line
		end
		out[#out + 1] = ""

		if not SRC or #SRC == 0 then
			out[#out + 1] = "(B/C skipped: no decompiled source. Enable the 'scripts + decompile' module - it runs before this one)"
			return out
		end

		local remNames, remPath, modNames, oddRem = {}, {}, {}, {}
		local function regRemote(d, pth)
			local nm = safeNameOf(d)
			if #nm >= 2 and not remNames[nm] then
				remNames[nm] = safeClassOf(d)
				remPath[nm] = pth
				if nm:find("[^%w_]") then oddRem[#oddRem + 1] = nm end
			end
		end
		for i, d in ipairs(ALL or {}) do
			if i % 1000 == 0 then pace() end
			local nm = safeNameOf(d)
			if isRemoteLike(d) then
				regRemote(d, cut(fullPath(d), 150))
			elseif d:IsA("ModuleScript") and #nm >= 2 and not modNames[nm] then
				modNames[nm] = cut(fullPath(d), 150)
			end
		end
		for _, d in ipairs(NIL or {}) do
			if isRemoteLike(d) then regRemote(d, "(nil)/" .. safeNameOf(d)) end
		end

		local remUsers, modUsers = {}, {}
		local function addUse(map, key, si)
			local l = map[key]
			if not l then l = {} map[key] = l end
			l[#l + 1] = si
		end
		for si, s in ipairs(SRC) do
			pace()
			local code = s.src
			local hasReq = code:find("require", 1, true) ~= nil
			local myName = s.path:match("[^/]+$")
			local seenR, seenM = {}, {}
			for tok in code:gmatch("[%w_]+") do
				if remNames[tok] and not seenR[tok] then
					seenR[tok] = true
					addUse(remUsers, tok, si)
				elseif hasReq and modNames[tok] and tok ~= myName and not seenM[tok] then
					seenM[tok] = true
					addUse(modUsers, tok, si)
				end
			end
			for _, nm in ipairs(oddRem) do
				if not seenR[nm] and code:find(nm, 1, true) then
					seenR[nm] = true
					addUse(remUsers, nm, si)
				end
			end
		end

		local par = {}
		local function find(x)
			local r = x
			while par[r] ~= r do r = par[r] end
			while par[x] ~= r do
				local nx = par[x]
				par[x] = r
				x = nx
			end
			return r
		end
		local function link(a, b)
			if not par[a] then par[a] = a end
			if not par[b] then par[b] = b end
			local ra, rb = find(a), find(b)
			if ra ~= rb then par[ra] = rb end
		end
		local HUB = 35
		local hubs, linked = {}, {}
		local function process(users, kind)
			for nm, list in pairs(users) do
				if #list > HUB then
					hubs[#hubs + 1] = string.format("%s %s used by %d scripts", kind == "R" and "REMOTE" or "MODULE", nm, #list)
				else
					for _, si in ipairs(list) do
						linked[si] = true
						link("S:" .. si, kind .. ":" .. nm)
					end
				end
			end
		end
		process(remUsers, "R")
		process(modUsers, "M")

		local comps = {}
		for k in pairs(par) do
			local r = find(k)
			local c = comps[r]
			if not c then c = { S = {}, R = {}, M = {} } comps[r] = c end
			local kind, rest = k:sub(1, 1), k:sub(3)
			if kind == "S" then c.S[#c.S + 1] = tonumber(rest) else c[kind][#c[kind] + 1] = rest end
		end
		local list = {}
		for _, c in pairs(comps) do
			table.sort(c.R) table.sort(c.M) table.sort(c.S)
			list[#list + 1] = c
		end
		table.sort(list, function(a, b)
			local sa, sb = #a.S + #a.R + #a.M, #b.S + #b.R + #b.M
			if sa ~= sb then return sa > sb end
			return (a.S[1] or 0) < (b.S[1] or 0)
		end)

		out[#out + 1] = "### B) Systems (scripts grouped by shared Remote / ModuleScript) - " .. #list .. " clusters"
		for ci, c in ipairs(list) do
			if ci > CFG.MaxSysGraph then out[#out + 1] = "... (cut)" break end
			pace()
			local kc, kw = {}, {}
			local function tally(text)
				for _, k in ipairs(matchKeywords(text, SYSTEM_KEYS)) do
					if not kc[k] then kc[k] = 0 kw[#kw + 1] = k end
					kc[k] = kc[k] + 1
				end
			end
			for _, si in ipairs(c.S) do tally(SRC[si].path) end
			for _, nm in ipairs(c.R) do tally(nm) end
			for _, nm in ipairs(c.M) do tally(nm) end
			table.sort(kw, function(a, b) return kc[a] > kc[b] end)
			local guess = {}
			for i = 1, math.min(8, #kw) do guess[i] = kw[i] end
			out[#out + 1] = ""
			out[#out + 1] = string.format("=== SYSTEM #%d  scripts=%d remotes=%d modules=%d  guess[%s]", ci, #c.S, #c.R, #c.M, table.concat(guess, ","))
			for i, si in ipairs(c.S) do
				if i > 60 then out[#out + 1] = "  SCRIPT  ... +" .. (#c.S - 60) break end
				out[#out + 1] = "  SCRIPT  " .. SRC[si].class .. " | " .. SRC[si].path
			end
			for i, nm in ipairs(c.R) do
				if i > 60 then out[#out + 1] = "  REMOTE  ... +" .. (#c.R - 60) break end
				out[#out + 1] = "  REMOTE  " .. tostring(remNames[nm]) .. " | " .. nm .. " | " .. tostring(remPath[nm])
			end
			for i, nm in ipairs(c.M) do
				if i > 60 then out[#out + 1] = "  MODULE  ... +" .. (#c.M - 60) break end
				out[#out + 1] = "  MODULE  " .. nm .. " | " .. tostring(modNames[nm])
			end
		end

		out[#out + 1] = ""
		out[#out + 1] = "### C) Loose ends"
		out[#out + 1] = "--- Shared hubs (used by more than " .. HUB .. " scripts - not used to cluster) ---"
		table.sort(hubs)
		for _, h in ipairs(hubs) do out[#out + 1] = "  " .. h end
		out[#out + 1] = "--- Remotes no decompiled script mentions (server-driven or unused) ---"
		local unref = {}
		for nm, cn in pairs(remNames) do
			if not remUsers[nm] then unref[#unref + 1] = cn .. " | " .. nm .. " | " .. tostring(remPath[nm]) end
		end
		table.sort(unref)
		for i, l in ipairs(unref) do
			if i > 800 then out[#out + 1] = "  ... (cut)" break end
			out[#out + 1] = "  " .. l
		end
		out[#out + 1] = "--- Scripts with no Remote/Module link ---"
		local iso = 0
		for si, s in ipairs(SRC) do
			if not linked[si] then
				iso = iso + 1
				if iso <= 400 then out[#out + 1] = "  " .. s.class .. " | " .. s.path end
			end
		end
		out[#out + 1] = "  total isolated: " .. iso
		return out
	end
})

local TR = { on = false, buf = {}, seen = {} }
local function trToggle(on)
	if not on then
		TR.on = false
		log("Trail stopped (" .. #TR.buf .. " lines)")
		return
	end
	if TR.on then return end
	TR.on = true
	log("Trail started: walk around - every 25 studs the prompts/clicks within 80 studs are recorded")
	task.spawn(function()
		local last
		while TR.on and gui.Parent do
			local h = getHrp()
			if h and (not last or (h.Position - last).Magnitude >= 25) and #TR.buf < 6000 then
				last = h.Position
				TR.buf[#TR.buf + 1] = string.format("[%s] pos=%.0f,%.0f,%.0f", os.date("%H:%M:%S"), last.X, last.Y, last.Z)
				local k = 0
				for _, d in ipairs(workspace:GetDescendants()) do
					k = k + 1
					if k % 1500 == 0 then task.wait() end
					if (d:IsA("ProximityPrompt") or d:IsA("ClickDetector")) and not TR.seen[d] then
						local dist = distOf(d)
						if dist >= 0 and dist <= 80 then
							TR.seen[d] = true
							local info = d:IsA("ProximityPrompt") and ("act=[" .. oneLine(d.ActionText) .. "] obj=[" .. oneLine(d.ObjectText) .. "]") or "click"
							TR.buf[#TR.buf + 1] = string.format("   NEW %s | d=%s | %s | %s | %s", safeClassOf(d), dist, info, posStr(d), cut(fullPath(d), 150))
						end
					end
				end
			end
			task.wait(1)
		end
	end)
end
cleanup[#cleanup + 1] = function() TR.on = false end

addModule({
	id = "trail", label = "บันทึกจุดที่เดินผ่าน (เปิดก่อน แล้วเดินสำรวจแมพ)", file = "24_trail_log.txt", onToggle = trToggle, run = function()
		local L = { "Trail log: positions you walked + prompts/clicks first seen near each stop (useful with StreamingEnabled)", "" }
		for _, l in ipairs(TR.buf) do L[#L + 1] = l end
		L[#L + 1] = "total lines: " .. #TR.buf
		return L
	end
}, false)

addModule({
	id = "paths", label = "ตัวอย่าง path Lua ไว้เขียนสคริปต์", file = "22_lua_path_snippets.txt", run = function()
		local L = {
			"-- BALL KUN: path พร้อม copy ไปใช้เขียนสคริปต์ (สร้างอัตโนมัติ)",
			"-- ใช้ FindFirstChild ตามชื่อจริงในแมพนี้: " .. mapName .. " (" .. game.PlaceId .. ")",
			"",
			"-- ===== REMOTES / BINDABLES =====",
		}
		local used = {}
		local function varName(prefix, name)
			local v = tostring(name):gsub("[^%w_]", "_")
			if v:match("^%d") or v == "" then v = "_" .. v end
			v = prefix .. v
			local base, k = v, 1
			while used[v] do k = k + 1 v = base .. "_" .. k end
			used[v] = true
			return v
		end
		local rem = {}
		for i, d in ipairs(ALL or {}) do
			if i % 1000 == 0 then pace() end
			if isRemoteLike(d) and d:IsDescendantOf(game) then rem[#rem + 1] = d end
		end
		table.sort(rem, function(a, b) return fullPath(a) < fullPath(b) end)
		for _, d in ipairs(rem) do
			L[#L + 1] = "local " .. varName("R_", safeNameOf(d)) .. " = " .. pathExpr(d) .. "  -- " .. safeClassOf(d)
		end
		L[#L + 1] = ""
		L[#L + 1] = "-- ===== PROXIMITY PROMPTS (ใกล้สุด 500 อัน) ====="
		local pr = {}
		for i, d in ipairs(ALL or {}) do
			if i % 1000 == 0 then pace() end
			if d:IsA("ProximityPrompt") and d:IsDescendantOf(workspace) then
				pr[#pr + 1] = { d = d, dist = distOf(d) }
			end
		end
		table.sort(pr, function(a, b)
			if a.dist >= 0 and b.dist >= 0 then return a.dist < b.dist end
			return a.dist > b.dist
		end)
		for i = 1, math.min(500, #pr) do
			local d = pr[i].d
			local pName = d.Parent and safeNameOf(d.Parent) or safeNameOf(d)
			L[#L + 1] = string.format("-- [%s] [%s] d=%s %s", oneLine(d.ActionText), oneLine(d.ObjectText), tostring(pr[i].dist), posStr(d))
			L[#L + 1] = "local " .. varName("P_", pName) .. " = " .. pathExpr(d)
		end
		L[#L + 1] = ""
		L[#L + 1] = "-- ===== ค่า/ข้อมูลผู้เล่น (Folder/Value ใต้ LocalPlayer) ====="
		for _, c in ipairs(lp:GetChildren()) do
			if c ~= pg and (c:IsA("Folder") or c:IsA("ValueBase") or c:IsA("Configuration")) then
				L[#L + 1] = "local " .. varName("D_", safeNameOf(c)) .. " = " .. pathExpr(c)
			end
		end
		return L
	end
})

addModule({
	id = "domains", label = "แยกหมวดตามระบบ (ร้าน/รถ/งาน/ไอเทม/สุ่ม/วาร์ป)", file = "25_systems_deep_index.txt", run = function()
		local BUCKETS = {
			{ key = "SHOP_ECONOMY", title = "ร้านค้า / เงิน / ธนาคาร / พาส / ซื้อขาย", words = { "shop", "store", "market", "sell", "buy", "trade", "bank", "atm", "cash", "coin", "money", "gem", "robux", "pass", "vip", "ร้าน", "ซื้อ", "ขาย", "เงิน", "พาส" } },
			{ key = "VEHICLE_TUNE", title = "ยานพาหนะ / จูนแต่ง / อู่ / ดริฟต์ / แข่ง", words = { "vehicle", "car", "bike", "moto", "truck", "boat", "plane", "heli", "drift", "race", "tune", "tuning", "garage", "wash", "fuel", "repair", "suspension", "camber", "tyre", "tire", "exhaust", "ecu", "gear", "nitro", "รถ", "จูน", "แต่งรถ", "อู่", "ไนโตร" } },
			{ key = "JOB_QUEST_FARM", title = "งาน / เควส / ภารกิจ / ฟาร์ม / ขุด / ตกปลา", words = { "job", "work", "rider", "delivery", "deliver", "cargo", "order", "quest", "mission", "task", "farm", "harvest", "mine", "fish", "craft", "cook", "งาน", "ส่งของ", "ไรเดอร์", "เควส", "ฟาร์ม", "ขุด", "ตกปลา" } },
			{ key = "ITEM_PET_INV", title = "กระเป๋า / ไอเทม / อาวุธ / สัตว์เลี้ยง / สกิล", words = { "inventory", "inv", "item", "tool", "weapon", "gun", "sword", "skin", "pet", "egg", "hatch", "bag", "storage", "skill", "upgrade", "level", "rebirth", "กระเป๋า", "ไอเทม", "อาวุธ", "สัตว์เลี้ยง", "ไข่", "สกิล", "อัปเกรด" } },
			{ key = "GACHA_REWARD", title = "สุ่ม / กาชา / กล่อง / โค้ด / รางวัลประจำวัน", words = { "gacha", "spin", "roll", "summon", "crate", "case", "box", "chest", "redeem", "code", "daily", "reward", "claim", "สุ่ม", "กาชา", "กล่อง", "โค้ด", "รางวัล" } },
			{ key = "WARP_SPAWN_PVP", title = "วาร์ป / จุดเกิด / โซน / บอส / ดันเจี้ยน", words = { "teleport", "portal", "tp", "waypoint", "checkpoint", "spawn", "zone", "boss", "raid", "dungeon", "wave", "round", "วาร์ป", "จุดเกิด", "บอส", "ดันเจี้ยน" } },
		}
		local out = {
			"BALL KUN • DEEP SYSTEMS INDEX BY DOMAIN",
			"=======================================",
		}
		for _, b in ipairs(BUCKETS) do
			pace()
			local hits = {}
			for i, d in ipairs(ALL or {}) do
				if i % 500 == 0 then pace() end
				if #hits >= 400 then break end
				if isRemoteLike(d) or d:IsA("LuaSourceContainer") or d:IsA("ProximityPrompt") or d:IsA("ValueBase") then
					local m = matchKeywords(buildSearchBlob(d), b.words)
					if #m > 0 then
						hits[#hits + 1] = string.format("  [%s] %s | match[%s] | %s%s",
							safeClassOf(d), cut(safeNameOf(d), 35), table.concat(m, ","), cut(fullPath(d), 140),
							d:IsA("ValueBase") and valStr(d) or "")
					end
				end
			end
			out[#out + 1] = ""
			out[#out + 1] = "### " .. b.key .. " — " .. b.title .. " (" .. #hits .. " รายการ)"
			if #hits == 0 then
				out[#out + 1] = "  (ไม่พบรายการที่ตรงคีย์เวิร์ดในหมวดนี้)"
			else
				for _, l in ipairs(hits) do out[#out + 1] = l end
			end
		end
		return out
	end
})

-- ============================================================================
-- ผูกปุ่ม UI
-- ============================================================================
local enabled = {}
local rowBtns = {}
local function paintRow(m)
	local r = rowBtns[m.id]
	if not r then return end
	local on = enabled[m.id]
	r.btn.BackgroundColor3 = on and Color3.fromRGB(18, 58, 46) or T.Input
	r.sw.BackgroundColor3 = on and T.Green or Color3.fromRGB(60, 80, 74)
	r.knob.Position = on and UDim2.fromOffset(16, 2) or UDim2.fromOffset(2, 2)
	r.txt.TextColor3 = on and T.Text or T.Dim
end

for i, m in ipairs(M) do
	enabled[m.id] = m.default
	local b = mk("TextButton", {
		Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = T.Input, BorderSizePixel = 0, AutoButtonColor = false,
		Text = "", LayoutOrder = i
	}, modPanel)
	corner(b, 8)
	local sw = mk("Frame", { Size = UDim2.fromOffset(32, 18), Position = UDim2.new(0, 8, 0.5, -9), BackgroundColor3 = T.Green, BorderSizePixel = 0 }, b)
	corner(sw, 9)
	local knob = mk("Frame", { Size = UDim2.fromOffset(14, 14), Position = UDim2.fromOffset(16, 2), BackgroundColor3 = T.Text, BorderSizePixel = 0 }, sw)
	corner(knob, 7)
	local txt = mk("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.fromOffset(48, 0), Size = UDim2.new(1, -52, 1, 0), Text = m.label,
		Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = T.Text, TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd
	}, b)
	rowBtns[m.id] = { btn = b, sw = sw, knob = knob, txt = txt }
	paintRow(m)
	b.MouseButton1Click:Connect(function()
		enabled[m.id] = not enabled[m.id]
		paintRow(m)
		if m.onToggle then pcall(m.onToggle, enabled[m.id]) end
	end)
end

do
	local function cfgRow(order, getText, onClick)
		local b = mk("TextButton", { Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = T.Panel, BorderSizePixel = 0, Text = "", LayoutOrder = order }, modPanel)
		corner(b, 8)
		stroke(b, T.GreenDark, 1, 0.3)
		local t = mk("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(8, 0), Text = getText(),
			Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = T.Green, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd }, b)
		b.MouseButton1Click:Connect(function() onClick() t.Text = getText() end)
	end
	local function onoff(v) return v and "ON" or "OFF" end
	cfgRow(900, function() return "CFG Radius: " .. (CFG.Radius and (CFG.Radius .. " studs") or "ทั้งแมพ") end, function()
		local r = CFG.Radius
		if not r then CFG.Radius = 150 elseif r == 150 then CFG.Radius = 300 elseif r == 300 then CFG.Radius = 600 else CFG.Radius = nil end
	end)
	cfgRow(901, function() return "CFG IncludeNilScripts: " .. onoff(CFG.IncludeNilScripts) end, function() CFG.IncludeNilScripts = not CFG.IncludeNilScripts end)
	cfgRow(902, function() return "CFG RequireAllModules: " .. onoff(CFG.RequireAllModules) end, function() CFG.RequireAllModules = not CFG.RequireAllModules end)
	cfgRow(903, function() return "CFG HookClientInvoke: " .. onoff(CFG.HookClientInvoke) end, function()
		CFG.HookClientInvoke = not CFG.HookClientInvoke
		if RL.on then
			rlToggle(false)
			rlToggle(true)
		end
	end)
end

allBtn.MouseButton1Click:Connect(function()
	local anyOn = false
	for _, m in ipairs(M) do if enabled[m.id] then anyOn = true break end end
	for _, m in ipairs(M) do
		local isLiveStream = (m.id == "remotelog" or m.id == "trail")
		local newV = (not anyOn) and (not isLiveStream)
		if enabled[m.id] ~= newV then
			enabled[m.id] = newV
			paintRow(m)
			if m.onToggle and not isLiveStream then pcall(m.onToggle, newV) end
		end
	end
	if not anyOn then
		log("เลือกโมดูลสแกนทั้งหมดแล้ว (ข้าม Remote Log และ Trail ที่บันทึกสดเพื่อลดอาการค้างบนมือถือ)")
	end
end)

log("พร้อมใช้งาน • แมพ: " .. cut(mapName, 30))
do
	local ex = "?"
	pcall(function() if identifyexecutor then ex = tostring(identifyexecutor()) end end)
	local caps = {
		{ "writefile", HAS.write }, { "decompile", HAS.decompile }, { "getscripts", HAS.scripts },
		{ "getloadedmodules", HAS.modules }, { "getnilinstances", HAS.nilinst },
		{ "hookmetamethod", type(hookmetamethod) == "function" }, { "getconnections", type(getconnections) == "function" },
		{ "getcallbackvalue", type(getcallbackvalue) == "function" }, { "setclipboard", type(setclipboard) == "function" or type(toclipboard) == "function" },
	}
	local miss = {}
	for _, c in ipairs(caps) do if not c[2] then miss[#miss + 1] = c[1] end end
	log("Executor: " .. ex .. (#miss == 0 and " | full support" or (" | missing: " .. table.concat(miss, ", "))))
end
log(canWrite and ("ไฟล์จะถูกบันทึกที่: " .. dir) or "⚠ ตัวรันนี้ไม่รองรับ writefile — จะเก็บไว้ใน getgenv().BALL_KUN_DUMP แทน")
log(HAS.decompile and "✓ รองรับ decompile (จะถอดโค้ดสคริปต์ได้)" or "⚠ ไม่มี decompile — ได้เฉพาะรายชื่อสคริปต์")
log("กด START เพื่อดัมพ์ • ถ้าจะดักข้อมูล Remote: เปิดสวิตช์ \"Remote Log\" ก่อน แล้วเล่นเกม แล้วค่อยกด START")

-- ============================================================================
-- START & SNAPSHOT
-- ============================================================================
local running = false

local function runDumpPipeline(tagLabel)
	ensureFolders()
	local sel = {}
	for _, m in ipairs(M) do if enabled[m.id] then sel[#sel + 1] = m end end
	if #sel == 0 then
		log("ยังไม่ได้เลือกระบบ — เปิดอย่างน้อย 1 ระบบก่อน")
		return
	end

	local prefix = ""
	if tagLabel and tagLabel ~= "" then
		prefix = "snapshots/" .. safeFile(tagLabel, 32) .. "_"
	end

	local okFiles, index = 0, {
		"BALL KUN UNIVERSAL MAP DUMP V.0.2.4",
		"Map: " .. mapName .. " (" .. game.PlaceId .. ")",
		"Tag: " .. ((tagLabel and tagLabel ~= "") and tagLabel or "FULL_DUMP"),
		"Time: " .. os.date("%Y-%m-%d %H:%M:%S"),
		"",
	}
	local t0 = os.clock()
	setProgress(0, "กำลังสแกนทุก Service...")

	local okB, errB = pcall(function()
		refreshServices()
		ALL, NIL, DESC = buildAll()
		DESC = DESC or workspace:GetDescendants()
		IDX = buildIndex()
	end)
	if not okB then
		log("✗ สแกนไม่สำเร็จ: " .. cut(tostring(errB), 80))
		return
	end

	log("สแกนทั้งเกม " .. #(ALL or {}) .. " วัตถุ (Workspace " .. #(DESC or {}) .. ", nil " .. #(NIL or {}) .. ")")
	SRC = nil

	for i, m in ipairs(sel) do
		if cancelled then error("__cancel", 0) end
		setProgress((i - 0.5) / #sel, string.format("[%d/%d] %s", i, #sel, m.label))
		log("▶ กำลังดึง: " .. m.label)
		local okM, linesOrErr = runWithTimeout(m.run, 45)
		if okM and type(linesOrErr) == "table" then
			local outName = prefix .. m.file
			local okS, outPath, parts = save(outName, linesOrErr)
			if okS then
				okFiles = okFiles + 1
				index[#index + 1] = string.format("✓ %-28s | %6d lines | %s%s",
					outName, #linesOrErr, tostring(outPath), (parts and parts > 1) and (" (" .. parts .. " parts)") or "")
			else
				index[#index + 1] = "✗ " .. outName .. " | save failed"
			end
		else
			log("⚠ ข้าม/ผิดพลาดที่ " .. m.id .. ": " .. cut(tostring(linesOrErr), 70))
			index[#index + 1] = "✗ " .. m.file .. " | err: " .. cut(tostring(linesOrErr), 70)
		end
		setProgress(i / #sel, string.format("เสร็จ %d/%d", i, #sel))
	end

	index[#index + 1] = ""
	index[#index + 1] = string.format("Finished in %.2fs | files saved: %d/%d", os.clock() - t0, okFiles, #sel)
	save(prefix .. "00_INDEX.txt", index)
	log(string.format("✔ ดัมพ์เสร็จสิ้นใน %.2f วิ (%d/%d ไฟล์)", os.clock() - t0, okFiles, #sel))
end

local function finishRunUi()
	running = false
	cancelled = false
	startBtn.Text, startBtn.BackgroundColor3, startGrad.Enabled = "START DUMP", Color3.new(1, 1, 1), true
	snapBtn.Active = true
end

local function startDump()
	if running then
		if not cancelled then
			cancelled = true
			startBtn.Text = "กำลังหยุด..."
			log("กำลังหยุด...")
		end
		return
	end
	running, cancelled = true, false
	snapBtn.Active = false
	startBtn.Text, startBtn.BackgroundColor3, startGrad.Enabled = "⏹ หยุด (กำลังเก็บข้อมูล...)", T.Red, false
	task.spawn(function()
		local okR, errR = pcall(function() runDumpPipeline(nil) end)
		if not okR and tostring(errR):find("__cancel", 1, true) then
			log("■ ยกเลิกการดัมพ์แล้ว")
			setProgress(0, "ยกเลิกแล้ว")
		elseif not okR then
			log("✗ เกิดข้อผิดพลาดระหว่างดัมพ์: " .. cut(tostring(errR), 80))
		end
		finishRunUi()
	end)
end

startBtn.MouseButton1Click:Connect(startDump)

snapBtn.MouseButton1Click:Connect(function()
	if running then return end
	running, cancelled = true, false
	snapBtn.Active = false
	startBtn.Text, startBtn.BackgroundColor3, startGrad.Enabled = "⏹ หยุด (กำลังเก็บข้อมูล...)", T.Red, false
	task.spawn(function()
		local rawTag = tagBox.Text
		for sec = 8, 1, -1 do
			if cancelled then
				log("■ ยกเลิกนับถอยหลัง Snapshot")
				finishRunUi()
				return
			end
			setProgress((8 - sec) / 8, string.format("เตรียม Snapshot ใน %d วิ... (เปิดหน้าต่าง/ระบบที่ต้องการ)", sec))
			task.wait(1)
		end
		local labelTag = (rawTag and rawTag ~= "") and rawTag or ("snap_" .. os.date("%H%M%S"))
		log("📸 เก็บ Snapshot สถานะ: " .. labelTag)
		local okR, errR = pcall(function() runDumpPipeline(labelTag) end)
		if not okR and tostring(errR):find("__cancel", 1, true) then
			log("■ ยกเลิก Snapshot แล้ว")
		elseif not okR then
			log("✗ Snapshot ผิดพลาด: " .. cut(tostring(errR), 80))
		end
		finishRunUi()
	end)
end)

if CFG.AutoStart then
	task.delay(CFG.AutoStartDelay or 2, function()
		if not running and gui.Parent then
			startDump()
		end
	end)
end
