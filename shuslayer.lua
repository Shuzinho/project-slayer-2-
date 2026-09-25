--========================================================--
--        PROJECT SLAYER 2 - CLAN SPINNER
--        Auto Spin + Target + Rarity + Auto Redeem + Auto Skip
--        Visual Confirmation
--        Custom Size + Position Saving
--        Created by ! Shu神
--        Integrado ao Farmer Blox Switcher
--========================================================--


--========================================================--
-- RAYFIELD
--========================================================--

local Rayfield = loadstring(
    game:HttpGet("https://sirius.menu/rayfield")
)()


--========================================================--
-- SERVICES
--========================================================--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer

local safeName = tostring(LocalPlayer.Name):gsub("[^%w_%-]", "_")
local doneFile = "done_" .. safeName .. ".txt"
local heartbeatFile = "heartbeat_" .. safeName .. ".txt"
local clanFile = "clan_" .. safeName .. ".txt"
local errorFile = "error_" .. safeName .. ".txt"

-- Monitor de Desconexão / Queda (Estilo Yummy checkyummy)
local DisconnectErrors = Enum.ConnectionError.DisconnectErrors.Value
local PlaceLaunchOtherError = Enum.ConnectionError.PlacelaunchOtherError.Value
task.spawn(function()
    while task.wait(3) do
        pcall(function()
            local code = GuiService:GetErrorCode().Value
            if code == 1 or code == 773 or code == 772 or code == 769 or (code >= DisconnectErrors and code < PlaceLaunchOtherError) or code >= 256 then
                writefile(errorFile, tostring(code))
            end
        end)
    end
end)


--========================================================--
-- CUSTOM UI CONFIG
--========================================================--

local CONFIG_FOLDER = "ShuClanSpinner"
local CONFIG_FILE = CONFIG_FOLDER .. "/window.cfg"

local DEFAULT_WIDTH = 850
local DEFAULT_HEIGHT = 650

local MIN_WIDTH = 600
local MAX_WIDTH = 1100

local MIN_HEIGHT = 450
local MAX_HEIGHT = 850

local DEFAULT_POS_X = 0.5
local DEFAULT_POS_Y = 0.5

local DEFAULT_POS_OFFSET_X = 0
local DEFAULT_POS_OFFSET_Y = 0


--========================================================--
-- FILE SYSTEM
--========================================================--

local function canUseFiles()
    return type(isfolder) == "function"
        and type(makefolder) == "function"
        and type(isfile) == "function"
        and type(readfile) == "function"
        and type(writefile) == "function"
end

local function ensureConfigFolder()
    if not canUseFiles() then return end
    pcall(function()
        if not isfolder(CONFIG_FOLDER) then
            makefolder(CONFIG_FOLDER)
        end
    end)
end

local function getDefaultWindowConfig()
    return {
        Width = DEFAULT_WIDTH,
        Height = DEFAULT_HEIGHT,
        PosX = DEFAULT_POS_X,
        PosY = DEFAULT_POS_Y,
        OffsetX = DEFAULT_POS_OFFSET_X,
        OffsetY = DEFAULT_POS_OFFSET_Y
    }
end

local function saveWindowConfig(width, height, posX, posY, offsetX, offsetY)
    if not canUseFiles() then return end
    ensureConfigFolder()
    local data = tostring(math.floor(width)) .. "\n" .. tostring(math.floor(height)) .. "\n" .. tostring(posX) .. "\n" .. tostring(posY) .. "\n" .. tostring(math.floor(offsetX)) .. "\n" .. tostring(math.floor(offsetY))
    pcall(function()
        writefile(CONFIG_FILE, data)
    end)
end

local function loadWindowConfig()
    if not canUseFiles() then return getDefaultWindowConfig() end
    ensureConfigFolder()
    if not isfile(CONFIG_FILE) then return getDefaultWindowConfig() end
    local success, content = pcall(function() return readfile(CONFIG_FILE) end)
    if not success or not content then return getDefaultWindowConfig() end

    local values = {}
    for line in string.gmatch(content, "[^\r\n]+") do
        table.insert(values, line)
    end

    local width = tonumber(values[1]) or DEFAULT_WIDTH
    local height = tonumber(values[2]) or DEFAULT_HEIGHT
    local posX = tonumber(values[3]) or DEFAULT_POS_X
    local posY = tonumber(values[4]) or DEFAULT_POS_Y
    local offsetX = tonumber(values[5]) or DEFAULT_POS_OFFSET_X
    local offsetY = tonumber(values[6]) or DEFAULT_POS_OFFSET_Y

    return {
        Width = math.clamp(width, MIN_WIDTH, MAX_WIDTH),
        Height = math.clamp(height, MIN_HEIGHT, MAX_HEIGHT),
        PosX = posX,
        PosY = posY,
        OffsetX = offsetX,
        OffsetY = offsetY
    }
end

local WindowConfig = loadWindowConfig()


--========================================================--
-- RAYFIELD WINDOW
--========================================================--

local Window = Rayfield:CreateWindow({
    Name = "PROJECT SLAYER 2 | Clan Spinner",
    Icon = 0,
    LoadingTitle = "PROJECT SLAYER 2",
    LoadingSubtitle = "by ! Shu神 • Farmer Blox",
    Theme = "Default",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ShuClanSpinner",
        FileName = "ClanSpinner"
    },
    Discord = {
        Enabled = true,
        Invite = "hhXm4tmyhJ",
        RememberJoins = true
    },
    KeySystem = false
})


--========================================================--
-- FIND RAYFIELD MAIN
--========================================================--

local RayfieldGui = nil
local RayfieldMain = nil

local function getUIRoot()
    if type(gethui) == "function" then
        local success, hui = pcall(function() return gethui() end)
        if success and hui then return hui end
    end
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success then return coreGui end
    return nil
end

local function findRayfieldWindow()
    local root = getUIRoot()
    if not root then return nil end
    local gui = root:FindFirstChild("Rayfield")
    if not gui then
        for _, child in ipairs(root:GetChildren()) do
            if child:IsA("ScreenGui") then
                local main = child:FindFirstChild("Main", true)
                if main and main:FindFirstChild("Topbar", true) then
                    gui = child
                    break
                end
            end
        end
    end
    if not gui then return nil end
    local main = gui:FindFirstChild("Main", true)
    return gui, main
end

for i = 1, 100 do
    local gui, main = findRayfieldWindow()
    if gui and main then
        RayfieldGui = gui
        RayfieldMain = main
        break
    end
    task.wait(0.1)
end

local currentWidth = WindowConfig.Width
local currentHeight = WindowConfig.Height

local function applyWindowSize(width, height)
    if not RayfieldMain then return false end
    width = math.clamp(math.floor(width), MIN_WIDTH, MAX_WIDTH)
    height = math.clamp(math.floor(height), MIN_HEIGHT, MAX_HEIGHT)
    currentWidth, currentHeight = width, height
    return pcall(function()
        RayfieldMain.Size = UDim2.fromOffset(width, height)
    end)
end

local function applyWindowPosition(posX, posY, offsetX, offsetY)
    if not RayfieldMain then return false end
    return pcall(function()
        RayfieldMain.Position = UDim2.new(posX, offsetX, posY, offsetY)
    end)
end

task.wait(0.5)
if RayfieldMain then
    applyWindowSize(WindowConfig.Width, WindowConfig.Height)
    applyWindowPosition(WindowConfig.PosX, WindowConfig.PosY, WindowConfig.OffsetX, WindowConfig.OffsetY)
end

local savePositionToken = 0
local function schedulePositionSave()
    if not RayfieldMain then return end
    savePositionToken += 1
    local token = savePositionToken
    task.delay(0.5, function()
        if token ~= savePositionToken or not RayfieldMain then return end
        local position = RayfieldMain.Position
        saveWindowConfig(currentWidth, currentHeight, position.X.Scale, position.Y.Scale, position.X.Offset, position.Y.Offset)
    end)
end

if RayfieldMain then
    pcall(function()
        RayfieldMain:GetPropertyChangedSignal("Position"):Connect(schedulePositionSave)
    end)
end


--========================================================--
-- SERVICES / MODULES
--========================================================--

local ClanEvents = require(ReplicatedStorage.CAM.Global.ClanEvents)
local Spinners = require(ReplicatedStorage.CAM.Global.Spinners)
local SignalFunction = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction)
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent)
local LiveConfig = require(ReplicatedStorage.CAM.Global.LiveConfig)

local autoRedeemEnabled = true
local redeemRunning = false

local function waitForLiveConfigCodes(timeout)
    timeout = timeout or 45
    local started = os.clock()
    while os.clock() - started < timeout do
        local ok, codesData = pcall(function() return LiveConfig.get("Codes") end)
        if ok and typeof(codesData) == "table" and typeof(codesData.free) == "table" then
            return codesData
        end
        task.wait(0.5)
    end
    return nil
end

local function getAvailableCodes()
    local result = {}
    local codesData = waitForLiveConfigCodes(45)
    if typeof(codesData) ~= "table" or typeof(codesData.free) ~= "table" then return result end
    for code, data in pairs(codesData.free) do
        if type(code) == "string" and code ~= "" then
            table.insert(result, {code = code, data = data})
        end
    end
    table.sort(result, function(a, b) return a.code < b.code end)
    return result
end

local function getCodeStatus(timeout)
    timeout = timeout or 15
    local started = os.clock()
    while os.clock() - started < timeout do
        local ok, result = pcall(function() return SignalFunction.ToServer("CodeStatus") end)
        if ok and typeof(result) == "table" then return result end
        task.wait(0.5)
    end
    return nil
end

local function hasSpinReward(value, visited)
    if type(value) == "string" then
        local text = string.lower(value)
        return string.find(text, "spin", 1, true) ~= nil or string.find(text, "giro", 1, true) ~= nil
    end
    if type(value) ~= "table" then return false end
    visited = visited or {}
    if visited[value] then return false end
    visited[value] = true
    for key, child in pairs(value) do
        if type(key) == "string" and (string.find(string.lower(key), "spin", 1, true) ~= nil or string.find(string.lower(key), "giro", 1, true) ~= nil) then
            return true
        end
        if hasSpinReward(child, visited) then return true end
    end
    return false
end

local function isCodeAlreadyRedeemed(code, status)
    if not status or typeof(status.codes) ~= "table" then return false end
    local codeData = status.codes[code]
    return typeof(codeData) == "table" and codeData.redeemed == true or codeData == true
end

local function isCodeExpired(data)
    if typeof(data) ~= "table" or type(data.expires) ~= "number" then return false end
    return data.expires > 0 and data.expires <= os.time()
end

local function redeemSingleCode(code)
    local ok, result = pcall(function() return SignalFunction.ToServer("RedeemCode", code) end)
    return ok and result == true, result
end

local function redeemAllCodes()
    if redeemRunning then return end
    redeemRunning = true
    local codes = getAvailableCodes()
    if #codes == 0 then redeemRunning = false; return end
    local status = getCodeStatus()

    for _, entry in ipairs(codes) do
        if not autoRedeemEnabled then break end
        local code, data = entry.code, entry.data
        if hasSpinReward(data) and not isCodeExpired(data) and not isCodeAlreadyRedeemed(code, status) then
            local success = redeemSingleCode(code)
            if success then
                task.wait(0.35)
                local newStatus = getCodeStatus()
                if newStatus then status = newStatus end
            end
            task.wait(0.5)
        end
    end
    redeemRunning = false
end


--========================================================--
-- RARITIES & CLANS
--========================================================--

local RARITY_NAMES = {[1] = "Common", [2] = "Uncommon", [3] = "Rare", [5] = "Legendary", [6] = "Mythic", [7] = "Supreme"}
local RARITY_ORDER = {"Rare", "Legendary", "Mythic", "Supreme"}

local clansByRarity = {Rare = {}, Legendary = {}, Mythic = {}, Supreme = {}}

for clanName, weight in pairs(Spinners.Clan.Weights) do
    local ok, rarityIndex = pcall(function() return ClanEvents.RarityOf(clanName) end)
    if ok and rarityIndex and RARITY_NAMES[rarityIndex] and clansByRarity[RARITY_NAMES[rarityIndex]] then
        table.insert(clansByRarity[RARITY_NAMES[rarityIndex]], clanName)
    end
end

for _, rarity in ipairs(RARITY_ORDER) do
    table.sort(clansByRarity[rarity])
end

local selectedClans = {}
local selectedRarities = {
    ["Mythic"] = true,
    ["Supreme"] = true
}

-- ========================================================
-- FARMER BLOX: Lê configs injetadas pelo sistema Python
-- via _G.ClanConfig (gerado pelo main.py a partir do
-- games/projectslayers.json)
-- ========================================================
local _cfgAutoSpin = true -- valor padrão: auto giro ligado

pcall(function()
    local cfg = _G.ClanConfig or (type(getgenv) == "function" and getgenv().ClanConfig) or nil
    if not cfg then return end

    -- Auto Giro: controla se começa ligado ou desligado
    if cfg["autoSpin"] ~= nil then
        _cfgAutoSpin = cfg["autoSpin"] == true
    end

    -- Raridades (ex: {"Rare"=false, "Legendary"=true, "Mythic"=true, "Supreme"=true})
    if type(cfg["Rarities"]) == "table" then
        for rarity, enabled in pairs(cfg["Rarities"]) do
            selectedRarities[rarity] = enabled == true
        end
    end

    -- Clãs específicos (ex: {"Kamado"=true, "Rengoku"=true})
    if type(cfg["Clans"]) == "table" then
        for clan, enabled in pairs(cfg["Clans"]) do
            selectedClans[clan] = enabled == true
        end
    end

    print("[FARMER BLOX] Configs carregadas do sistema:")
    print("  Auto Giro:", _cfgAutoSpin)
    for r, v in pairs(selectedRarities) do
        print("  Raridade:", r, "=", v)
    end
end)

local autoSpin = _cfgAutoSpin  -- usa o valor do _G.ClanConfig (ou true se não definido)
local autoSpinStarting = false
local targetLockedUntilReload = false
local targetLockedClan = nil
local startupSequenceDone = false
local loadingConfiguration = true
local spinning = false
local spinCount = 0
local lastResult = "Nenhum"
local lastRarity = "-"
local targetFound = false

local function getRarityName(clanName)
    if not clanName then return "Unknown" end
    local ok, rarityIndex = pcall(function() return ClanEvents.RarityOf(clanName) end)
    return (ok and rarityIndex and RARITY_NAMES[rarityIndex]) or "Unknown"
end

local function isTarget(clanName)
    if not clanName then return false end
    if selectedClans[clanName] then return true end
    local rarity = getRarityName(clanName)
    return selectedRarities[rarity] == true
end

local function getCurrentClan()
    local playerService = ReplicatedStorage:FindFirstChild("Player_Service")
    local data = playerService and playerService:FindFirstChild("Data")
    local playerData = data and data:FindFirstChild(LocalPlayer.Name)
    local slotEquipped = playerData and playerData:FindFirstChild("slotEquipped")
    local slots = playerData and playerData:FindFirstChild("slots")
    if not slotEquipped or not slots then return nil end

    local slotNumber = tonumber(slotEquipped.Value)
    local slot = slotNumber and slots:FindFirstChild("Slot" .. tostring(slotNumber))
    local clan = slot and slot:FindFirstChild("Clan")
    local clanName = clan and tostring(clan.Value)
    if clanName == "" or clanName == "None" then return nil end
    return clanName
end

local function isClanProtected(clanName)
    return clanName and isTarget(clanName)
end

local function waitForCurrentClan(timeout)
    local deadline = os.clock() + (timeout or 20)
    repeat
        local clan = getCurrentClan()
        if clan then return clan end
        task.wait(0.25)
    until os.clock() >= deadline
    return nil
end


--========================================================--
-- AUTO SKIP LOADING & CUSTOMIZE
--========================================================--

local function getExactSkipButton()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local components = playerGui and playerGui:FindFirstChild("Components")
    local holder = components and components:FindFirstChild("Holder")
    local skipHolder = holder and holder:FindFirstChild("Skip_n_Loading_Holder")
    local buttonHolder = skipHolder and skipHolder:FindFirstChild("ButtonHolder")
    local content = buttonHolder and buttonHolder:FindFirstChild("Content")
    local button = content and content:FindFirstChild("TextButton")
    return (button and button:IsA("TextButton")) and button or nil
end

local function waitForExactSkipButton(timeout)
    timeout = timeout or 30
    local started = os.clock()
    while os.clock() - started < timeout do
        local button = getExactSkipButton()
        if button and button.Visible and button.Active ~= false then return button end
        task.wait(0.1)
    end
    return nil
end

local function waitAndSkipLoading(timeout)
    local button = waitForExactSkipButton(timeout or 30)
    if not button then return false end
    for attempt = 1, 3 do
        if type(firesignal) == "function" and button.Parent then
            pcall(function() firesignal(button.MouseButton1Click) end)
            task.wait(2)
            return true
        end
        task.wait(0.25)
    end
    return false
end

local function waitForCustomizeButton(timeout)
    timeout = timeout or 45
    local started = os.clock()
    while os.clock() - started < timeout do
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        local components = playerGui and playerGui:FindFirstChild("Components")
        local menu = components and components:FindFirstChild("Menu")
        local optionsHolder = menu and menu:FindFirstChild("OptionsHolder")
        local presenter = optionsHolder and optionsHolder:FindFirstChild("2-CUSTOMIZE-Presenter")
        local button = presenter and presenter:FindFirstChild("Button")
        if button and button:IsA("TextButton") then return button end
        task.wait(0.25)
    end
    return nil
end

local function openCustomizeAndWait()
    if startupSequenceDone then return true end
    waitAndSkipLoading(30)
    local button = waitForCustomizeButton(45)
    if not button then return false end
    for attempt = 1, 3 do
        if type(firesignal) == "function" and button.Parent then
            pcall(function() firesignal(button.MouseButton1Click) end)
            task.wait(1.5)
            startupSequenceDone = true
            return true
        end
        task.wait(0.5)
    end
    return false
end


--========================================================--
-- TABS & INTERFACE
--========================================================--

local SpinTab = Window:CreateTab("🌀 Spin", 4483362458)
local ClansTab = Window:CreateTab("🎯 Clans", 4483362458)
local RarityTab = Window:CreateTab("⭐ Raridade", 4483362458)
local SettingsTab = Window:CreateTab("⚙️ Interface", 4483362458)
local CodesTab = Window:CreateTab("🎁 Codes", 4483362458)

local StatusParagraph = SpinTab:CreateParagraph({Title = "🟢 Status", Content = "Iniciando..."})
local ResultParagraph = SpinTab:CreateParagraph({Title = "🎲 Último Resultado", Content = "Nenhum spin realizado."})
local TargetParagraph = SpinTab:CreateParagraph({Title = "🎯 Confirmação", Content = "Nenhum alvo encontrado."})

local function updateResultVisual(clanName)
    local rarity = getRarityName(clanName)
    lastResult = clanName or "nil"
    lastRarity = rarity
    pcall(function()
        ResultParagraph:Set({
            Title = "🎲 Último Resultado",
            Content = "Clan: " .. tostring(lastResult) .. "\nRaridade: " .. tostring(lastRarity) .. "\nSpin #: " .. tostring(spinCount)
        })
    end)
end

local function updateStatusVisual()
    pcall(function()
        StatusParagraph:Set({
            Title = "🟢 Status",
            Content = (autoSpin and "🟢 AUTO SPIN ATIVO" or "🔴 AUTO SPIN PARADO") .. "\nSpins realizados: " .. tostring(spinCount)
        })
    end)
end

-- ========================================================
-- INTEGRAÇÃO FARMER BLOX: SALVAMENTO E NOTIFICAÇÃO
-- ========================================================
local function showTargetFound(clanName)
    local rarity = getRarityName(clanName)
    targetFound = true
    targetLockedUntilReload = true
    targetLockedClan = clanName

    pcall(function()
        TargetParagraph:Set({
            Title = "🎯 ALVO ENCONTRADO!",
            Content = "╔══════════════════════╗\n   CLAN: " .. tostring(clanName) .. "\n   RARIDADE: " .. tostring(rarity) .. "\n╚══════════════════════╝\n\n✅ Salvo no Farmer Blox!\n🛑 Trocando para próxima conta..."
        })
    end)

    print("========================================")
    print("[FARMER BLOX - ALVO OBTIDO]")
    print("Conta:", LocalPlayer.Name)
    print("Clan:", clanName, "| Raridade:", rarity)
    print("========================================")

    -- SINALIZA O PYTHON PARA SALVAR E TROCAR CONTA
    pcall(function()
        writefile(clanFile, tostring(clanName))
        writefile(doneFile, "Clan:" .. tostring(clanName))
    end)
end

local function notifyProtectedClan(clanName)
    local rarity = getRarityName(clanName)
    print("[PROTEÇÃO] A conta já possui o clã alvo:", clanName, "(Raridade: " .. rarity .. ")")
    
    -- SINALIZA O PYTHON: CONTA JÁ PRONTA, SALVAR E IR PRA PRÓXIMA
    showTargetFound(clanName)
end


--========================================================--
-- AUTO SPIN LOOP
--========================================================--

local function startAutoSpinLoop()
    if not autoSpin or spinning or autoSpinStarting then return end
    autoSpinStarting = true

    task.spawn(function()
        if loadingConfiguration then
            local deadline = os.clock() + 5
            while loadingConfiguration and os.clock() < deadline do task.wait(0.1) end
        end

        if not openCustomizeAndWait() then
            autoSpinStarting = false
            return
        end

        local currentClan = waitForCurrentClan(20)
        if not currentClan then
            warn("[Proteção] Não detectou Clan atual.")
            autoSpinStarting = false
            return
        end

        -- Se a conta já começa com clã bom, finaliza imediatamente!
        if isClanProtected(currentClan) then
            notifyProtectedClan(currentClan)
            autoSpinStarting = false
            return
        end

        updateStatusVisual()
        autoSpinStarting = false

        while autoSpin do
            if spinning then task.wait(0.2); continue end
            spinning = true

            local ok, result = pcall(function()
                return SignalFunction.ToServer("ClanSpin")
            end)

            if not ok then
                warn("[Auto Spin] Erro na requisição do ClanSpin:", result)
                spinning = false
                task.wait(2)
                continue
            end

            -- Acabaram os spins na conta!
            if result == nil then
                print("[Auto Spin] Spins esgotados na conta!")
                autoSpin = false
                spinning = false
                updateResultVisual("Spins Esgotados")
                updateStatusVisual()
                
                -- Avisa o Python que a conta finalizou (sem o clã) para trocar de conta
                pcall(function()
                    writefile(doneFile, "Clan:SemSpins")
                end)
                break
            end

            spinCount += 1
            local clanName = tostring(result)
            local rarity = getRarityName(clanName)

            updateResultVisual(clanName)
            updateStatusVisual()

            -- Atualiza heartbeat com o clã atual
            pcall(function()
                writefile(heartbeatFile, tostring(os.time()) .. "|" .. clanName)
            end)

            print("[Auto Spin] #" .. tostring(spinCount) .. " → " .. clanName .. " [" .. rarity .. "]")

            -- ALVO ENCONTRADO!
            if isTarget(clanName) then
                autoSpin = false
                spinning = false
                showTargetFound(clanName)
                updateStatusVisual()
                break
            end

            task.wait(2)
            pcall(function()
                SignalEvent.ToServer("ClanSpinComplete")
            end)

            spinning = false
            task.wait(0.5)
        end
        spinning = false
        updateStatusVisual()
    end)
end

SpinTab:CreateToggle({
    Name = "🌀 Auto Spin",
    CurrentValue = true,
    Flag = "AutoSpin",
    Callback = function(Value)
        autoSpin = Value
        if Value then startAutoSpinLoop() else spinning = false; updateStatusVisual() end
    end
})


--========================================================--
-- CLANS & RARITIES SELECTIONS
--========================================================--

for _, rarity in ipairs(RARITY_ORDER) do
    ClansTab:CreateSection("⭐ " .. rarity)
    for _, clanName in ipairs(clansByRarity[rarity]) do
        -- Marca como selecionado se veio do Farmer Blox
        local defaultClan = selectedClans[clanName] == true
        ClansTab:CreateToggle({
            Name = clanName,
            CurrentValue = defaultClan,
            Flag = "Clan_" .. clanName,
            Callback = function(Value) selectedClans[clanName] = Value end
        })
    end
end

for _, rarity in ipairs(RARITY_ORDER) do
    -- Usa o valor do Farmer Blox se foi injetado, senão usa o padrão (Mythic/Supreme)
    local defaultVal = selectedRarities[rarity]
    if defaultVal == nil then
        defaultVal = (rarity == "Mythic" or rarity == "Supreme")
    end
    RarityTab:CreateToggle({
        Name = "⭐ " .. rarity .. " (" .. tostring(#clansByRarity[rarity]) .. " Clans)",
        CurrentValue = defaultVal,
        Flag = "Rarity_" .. rarity,
        Callback = function(Value) selectedRarities[rarity] = Value end
    })
end


--========================================================--
-- INICIALIZAÇÃO
--========================================================--

task.delay(2, function()
    if autoRedeemEnabled then task.spawn(redeemAllCodes) end
end)

pcall(function() Rayfield:LoadConfiguration() end)
loadingConfiguration = false

task.delay(1.5, function()
    startAutoSpinLoop()
end)
