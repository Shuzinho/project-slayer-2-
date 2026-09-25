--========================================================--
--        PROJECT SLAYER 2 - CLAN SPINNER
--        Auto Spin + Target + Rarity + Auto Redeem + Auto Skip
--        Visual Confirmation
--        Custom Size + Position Saving
--        Created by ! Shu神
--        © 2026 ! Shu神
--        Integrado ao Farmer Blox
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
local LocalPlayer = Players.LocalPlayer


--========================================================--
-- CUSTOM UI CONFIG
--========================================================--

local CONFIG_FOLDER = "ShuClanSpinner"
local CONFIG_FILE = CONFIG_FOLDER .. "/window.cfg"

-- Tamanho inicial
local DEFAULT_WIDTH = 850
local DEFAULT_HEIGHT = 650

-- Limites
local MIN_WIDTH = 600
local MAX_WIDTH = 1100

local MIN_HEIGHT = 450
local MAX_HEIGHT = 850

-- Posição inicial
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
    if not canUseFiles() then
        return
    end

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


local function saveWindowConfig(
    width,
    height,
    posX,
    posY,
    offsetX,
    offsetY
)
    if not canUseFiles() then
        return
    end

    ensureConfigFolder()

    local data =
        tostring(math.floor(width))
        .. "\n"
        .. tostring(math.floor(height))
        .. "\n"
        .. tostring(posX)
        .. "\n"
        .. tostring(posY)
        .. "\n"
        .. tostring(math.floor(offsetX))
        .. "\n"
        .. tostring(math.floor(offsetY))

    pcall(function()
        writefile(CONFIG_FILE, data)
    end)
end


local function loadWindowConfig()

    if not canUseFiles() then
        return getDefaultWindowConfig()
    end

    ensureConfigFolder()

    if not isfile(CONFIG_FILE) then
        return getDefaultWindowConfig()
    end

    local success, content = pcall(function()
        return readfile(CONFIG_FILE)
    end)

    if not success or not content then
        return getDefaultWindowConfig()
    end

    local values = {}

    for line in string.gmatch(content, "[^\r\n]+") do
        table.insert(values, line)
    end

    local width = tonumber(values[1])
    local height = tonumber(values[2])

    local posX = tonumber(values[3])
    local posY = tonumber(values[4])

    local offsetX = tonumber(values[5])
    local offsetY = tonumber(values[6])

    if not width or not height then
        width = DEFAULT_WIDTH
        height = DEFAULT_HEIGHT
    end

    if not posX or not posY then
        posX = DEFAULT_POS_X
        posY = DEFAULT_POS_Y
    end

    if not offsetX or not offsetY then
        offsetX = DEFAULT_POS_OFFSET_X
        offsetY = DEFAULT_POS_OFFSET_Y
    end

    return {
        Width = math.clamp(
            width,
            MIN_WIDTH,
            MAX_WIDTH
        ),

        Height = math.clamp(
            height,
            MIN_HEIGHT,
            MAX_HEIGHT
        ),

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

    LoadingSubtitle = "by ! Shu神",

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
local RayfieldTopbar = nil


local function getUIRoot()

    -- Primeiro tenta gethui
    if type(gethui) == "function" then

        local success, hui = pcall(function()
            return gethui()
        end)

        if success and hui then
            return hui
        end
    end

    -- Fallback CoreGui
    local success, coreGui = pcall(function()
        return game:GetService("CoreGui")
    end)

    if success then
        return coreGui
    end

    return nil
end


local function findRayfieldWindow()

    local root = getUIRoot()

    if not root then
        return nil
    end

    -- Procura pelo nome padrão
    local gui = root:FindFirstChild("Rayfield")

    -- Procura alternativa
    if not gui then

        for _, child in ipairs(root:GetChildren()) do

            if child:IsA("ScreenGui") then

                local main = child:FindFirstChild(
                    "Main",
                    true
                )

                if main then

                    local topbar =
                        main:FindFirstChild(
                            "Topbar",
                            true
                        )

                    if topbar then
                        gui = child
                        break
                    end
                end
            end
        end
    end

    if not gui then
        return nil
    end

    local main =
        gui:FindFirstChild(
            "Main",
            true
        )

    if not main then
        return nil
    end

    return gui, main
end


-- Espera o Rayfield montar
for i = 1, 100 do

    local gui, main =
        findRayfieldWindow()

    if gui and main then

        RayfieldGui = gui
        RayfieldMain = main

        break
    end

    task.wait(0.1)
end


if RayfieldMain then

    RayfieldTopbar =
        RayfieldMain:FindFirstChild(
            "Topbar",
            true
        )
end


if RayfieldGui then

    print(
        "[Interface] Rayfield encontrado: "
        .. RayfieldGui:GetFullName()
    )
end


if RayfieldMain then

    print(
        "[Interface] Main encontrado: "
        .. RayfieldMain:GetFullName()
    )

else

    warn(
        "[Interface] Não foi possível encontrar o Main do Rayfield."
    )
end


--========================================================--
-- WINDOW SIZE / POSITION
--========================================================--

local currentWidth = WindowConfig.Width
local currentHeight = WindowConfig.Height


local function applyWindowSize(
    width,
    height
)

    if not RayfieldMain then

        warn(
            "[Interface] RayfieldMain não encontrado."
        )

        return false
    end

    width = math.clamp(
        math.floor(width),
        MIN_WIDTH,
        MAX_WIDTH
    )

    height = math.clamp(
        math.floor(height),
        MIN_HEIGHT,
        MAX_HEIGHT
    )

    currentWidth = width
    currentHeight = height

    local success = pcall(function()

        RayfieldMain.Size =
            UDim2.fromOffset(
                width,
                height
            )

    end)

    return success
end


local function applyWindowPosition(
    posX,
    posY,
    offsetX,
    offsetY
)

    if not RayfieldMain then

        warn(
            "[Interface] RayfieldMain não encontrado."
        )

        return false
    end

    local success = pcall(function()

        RayfieldMain.Position =
            UDim2.new(
                posX,
                offsetX,
                posY,
                offsetY
            )

    end)

    return success
end


--========================================================--
-- APPLY SAVED CONFIG
--========================================================--

task.wait(0.5)

if RayfieldMain then

    applyWindowSize(
        WindowConfig.Width,
        WindowConfig.Height
    )

    applyWindowPosition(
        WindowConfig.PosX,
        WindowConfig.PosY,
        WindowConfig.OffsetX,
        WindowConfig.OffsetY
    )

    print(
        "[Interface] Configuração carregada:"
    )

    print(
        "[Interface] "
        .. tostring(currentWidth)
        .. "x"
        .. tostring(currentHeight)
    )

else

    warn(
        "[Interface] Não foi possível aplicar a configuração."
    )
end


--========================================================--
-- AUTO SAVE POSITION
--========================================================--

local savePositionToken = 0


local function schedulePositionSave()

    if not RayfieldMain then
        return
    end

    savePositionToken += 1

    local token =
        savePositionToken

    task.delay(
        0.5,
        function()

            if token ~= savePositionToken then
                return
            end

            if not RayfieldMain then
                return
            end

            local position =
                RayfieldMain.Position

            saveWindowConfig(
                currentWidth,
                currentHeight,

                position.X.Scale,
                position.Y.Scale,

                position.X.Offset,
                position.Y.Offset
            )

            print(
                "[Interface] Posição salva"
            )

        end
    )
end


if RayfieldMain then

    pcall(function()

        RayfieldMain:
            GetPropertyChangedSignal(
                "Position"
            ):
            Connect(function()

                schedulePositionSave()

            end)

    end)
end


--========================================================--
-- SERVICES / MODULES
--========================================================--

local ClanEvents = require(
    ReplicatedStorage.CAM.Global.ClanEvents
)

local Spinners = require(
    ReplicatedStorage.CAM.Global.Spinners
)

local SignalFunction = require(
    ReplicatedStorage
        .Communication
        .ServerAndClient
        .Signals
        .SignalFunction
)

local SignalEvent = require(
    ReplicatedStorage
        .Communication
        .ServerAndClient
        .Signals
        .SignalEvent
)


--========================================================--
-- 🎁 AUTO REDEEM CODES
--========================================================--

local LiveConfig = require(
    ReplicatedStorage.CAM.Global.LiveConfig
)

local autoRedeemEnabled = true
local redeemRunning = false


local function waitForLiveConfigCodes(timeout)

    timeout = timeout or 45

    local started = os.clock()
    local announced = false

    while os.clock() - started < timeout do

        local ok, codesData = pcall(function()
            return LiveConfig.get("Codes")
        end)

        if ok and typeof(codesData) == "table" then

            local freeCodes = codesData.free

            if typeof(freeCodes) == "table" then
                print(
                    "[Auto Redeem] ✅ LiveConfig.Codes carregado após "
                    .. string.format("%.1f", os.clock() - started)
                    .. "s."
                )

                return codesData
            end
        end

        if not announced then
            announced = true
            print(
                "[Auto Redeem] ⏳ Aguardando carregamento dos códigos..."
            )
        end

        task.wait(0.5)
    end

    warn(
        "[Auto Redeem] ❌ LiveConfig.Codes não carregou dentro de "
        .. tostring(timeout)
        .. "s."
    )

    return nil
end


local function getAvailableCodes()

    local result = {}

    local codesData = waitForLiveConfigCodes(45)

    if typeof(codesData) ~= "table" then
        return result
    end

    local freeCodes = codesData.free

    if typeof(freeCodes) ~= "table" then
        warn("[Auto Redeem] Codes.free não está disponível")
        return result
    end

    for code, data in pairs(freeCodes) do

        if type(code) == "string" and code ~= "" then

            table.insert(result, {
                code = code,
                data = data
            })

        end
    end

    table.sort(result, function(a, b)
        return a.code < b.code
    end)

    return result
end


local function getCodeStatus(timeout)

    timeout = timeout or 15

    local started = os.clock()
    local warned = false

    while os.clock() - started < timeout do

        local ok, result = pcall(function()
            return SignalFunction.ToServer("CodeStatus")
        end)

        if ok and typeof(result) == "table" then
            return result
        end

        if not warned then
            warned = true
            print(
                "[Auto Redeem] ⏳ Aguardando CodeStatus..."
            )
        end

        task.wait(0.5)
    end

    warn(
        "[Auto Redeem] ❌ CodeStatus não ficou disponível."
    )

    return nil
end


-- Retorna true somente quando os dados do codigo indicam recompensa de Spin/Giro.
local function hasSpinReward(value, visited)
    if type(value) == "string" then
        local text = string.lower(value)
        return string.find(text, "spin", 1, true) ~= nil
            or string.find(text, "giro", 1, true) ~= nil
    end

    if type(value) ~= "table" then
        return false
    end

    visited = visited or {}
    if visited[value] then
        return false
    end
    visited[value] = true

    for key, child in pairs(value) do
        if type(key) == "string" then
            local keyText = string.lower(key)
            if string.find(keyText, "spin", 1, true) ~= nil
                or string.find(keyText, "giro", 1, true) ~= nil then
                return true
            end
        end

        if hasSpinReward(child, visited) then
            return true
        end
    end

    return false
end


local function isCodeAlreadyRedeemed(code, status)

    if not status or typeof(status.codes) ~= "table" then
        return false
    end

    local codeData = status.codes[code]

    if typeof(codeData) == "table" then
        return codeData.redeemed == true
    end

    return codeData == true
end


local function isCodeExpired(data)

    if typeof(data) ~= "table" then
        return false
    end

    local expires = data.expires

    if type(expires) ~= "number" then
        return false
    end

    return expires > 0 and expires <= os.time()
end


local function redeemSingleCode(code)

    local ok, result = pcall(function()
        return SignalFunction.ToServer("RedeemCode", code)
    end)

    if ok and result == true then
        return true, "success"
    end

    return false, result
end


local function redeemAllCodes()

    if redeemRunning then

        Rayfield:Notify({
            Title = "🎁 Auto Redeem",
            Content = "O resgate já está em andamento.",
            Duration = 3
        })

        return
    end

    redeemRunning = true

    local codes = getAvailableCodes()

    if #codes == 0 then

        Rayfield:Notify({
            Title = "🎁 Auto Redeem",
            Content = "Nenhum código disponível foi encontrado.",
            Duration = 4
        })

        redeemRunning = false
        return
    end

    local status = getCodeStatus()

    local redeemed = 0
    local skipped = 0
    local failed = 0

    Rayfield:Notify({
        Title = "🎁 Auto Redeem",
        Content = "Verificando " .. tostring(#codes) .. " código(s)...",
        Duration = 3
    })

    print("========================================")
    print("[Auto Redeem] Códigos encontrados:", #codes)
    print("========================================")

    for _, entry in ipairs(codes) do

        if not autoRedeemEnabled then
            print("[Auto Redeem] Processo interrompido.")
            break
        end

        local code = entry.code
        local data = entry.data

        -- Somente resgata codigos que entregam Spins/Giros.
        -- Codigos de reset sao ignorados antes de chamar RedeemCode.
        if not hasSpinReward(data) then
            skipped += 1
            print("[Auto Redeem] ⏭️ Ignorado (sem Spin/Giro):", code)

        elseif isCodeExpired(data) then

            skipped += 1

            print(
                "[Auto Redeem] ⏭️ Expirado:",
                code
            )

        elseif isCodeAlreadyRedeemed(code, status) then

            skipped += 1

            print(
                "[Auto Redeem] ⏭️ Já resgatado:",
                code
            )

        else

            print(
                "[Auto Redeem] 🎁 Tentando:",
                code
            )

            local success, reason =
                redeemSingleCode(code)

            if success then

                redeemed += 1

                print(
                    "[Auto Redeem] ✅ Resgatado:",
                    code
                )

                Rayfield:Notify({
                    Title = "🎁 Código Resgatado",
                    Content = code,
                    Duration = 3
                })

                task.wait(0.35)

                local newStatus = getCodeStatus()

                if newStatus then
                    status = newStatus
                end

            else

                failed += 1

                print(
                    "[Auto Redeem] ❌ Falhou:",
                    code,
                    tostring(reason)
                )

            end

            task.wait(0.5)
        end
    end

    task.wait(0.25)

    local finalStatus = getCodeStatus()

    if finalStatus then
        status = finalStatus
    end

    redeemRunning = false

    local interrupted = not autoRedeemEnabled

    if interrupted then

        Rayfield:Notify({
            Title = "🎁 Auto Redeem",
            Content = "Processo interrompido.",
            Duration = 4
        })

    else

        Rayfield:Notify({
            Title = "🎁 Auto Redeem",
            Content =
                "Resgatados: " .. tostring(redeemed)
                .. " | Ignorados: " .. tostring(skipped)
                .. " | Falhas: " .. tostring(failed),
            Duration = 5
        })

    end

    print("========================================")
    print("[Auto Redeem] Finalizado")
    print("[Auto Redeem] Resgatados:", redeemed)
    print("[Auto Redeem] Ignorados:", skipped)
    print("[Auto Redeem] Falhas:", failed)
    print("========================================")
end


--========================================================--
-- RARITIES
--========================================================--

local RARITY_NAMES = {

    [1] = "Common",

    [2] = "Uncommon",

    [3] = "Rare",

    [5] = "Legendary",

    [6] = "Mythic",

    [7] = "Supreme"
}


local RARITY_ORDER = {

    "Rare",

    "Legendary",

    "Mythic",

    "Supreme"
}


--========================================================--
-- CLAN DATA
--========================================================--

local clansByRarity = {

    Rare = {},

    Legendary = {},

    Mythic = {},

    Supreme = {}
}


for clanName, weight in pairs(
    Spinners.Clan.Weights
) do

    local ok, rarityIndex =
        pcall(function()

            return ClanEvents.RarityOf(
                clanName
            )

        end)

    if ok and rarityIndex then

        local rarityName =
            RARITY_NAMES[rarityIndex]

        if rarityName
            and clansByRarity[rarityName]
        then

            table.insert(
                clansByRarity[rarityName],
                clanName
            )
        end
    end
end


for _, rarity in ipairs(
    RARITY_ORDER
) do

    table.sort(
        clansByRarity[rarity]
    )

end


--========================================================--
-- TARGETS & GLOBAL CONFIG (_G.ClanConfig)
--========================================================--

local selectedClans = {}
local selectedRarities = {}

-- Integração Farmer Blox / Configuração Standalone
pcall(function()
    local cfg = _G.ClanConfig or (type(getgenv) == "function" and getgenv().ClanConfig) or nil
    if not cfg then return end

    if type(cfg["Rarities"]) == "table" then
        for rarity, enabled in pairs(cfg["Rarities"]) do
            selectedRarities[rarity] = (enabled == true)
        end
    end

    if type(cfg["Get Clã"]) == "table" then
        for rarity, enabled in pairs(cfg["Get Clã"]) do
            local properName = RARITY_NAMES[rarity] or (tostring(rarity):sub(1,1):upper() .. tostring(rarity):sub(2):lower())
            if properName == "Mitico" then properName = "Mythic" end
            if properName == "Raro" then properName = "Rare" end
            if properName == "Lendario" then properName = "Legendary" end
            if properName == "Supremo" then properName = "Supreme" end
            if enabled == true then
                selectedRarities[properName] = true
            end
        end
    end

    if type(cfg["Clans"]) == "table" then
        for clan, enabled in pairs(cfg["Clans"]) do
            selectedClans[clan] = (enabled == true)
        end
    end

    print("[FARMER BLOX] Configurações de alvos importadas com sucesso!")
end)


--========================================================--
-- STATE
--========================================================--

local autoSpin = false
local autoSpinStarting = false

-- Quando um Clan alvo é encontrado, o jogo mantém o Clan antigo
-- na interface/Data até reiniciar/recarregar a sessão.
-- Portanto, não permitimos iniciar outro ClanSpin nesta mesma sessão.
local targetLockedUntilReload = false
local targetLockedClan = nil
local startupSequenceDone = false
-- Impede o Auto Spin de iniciar enquanto o Rayfield restaura a configuração.
-- As raridades podem ser restauradas depois do toggle AutoSpin.
local loadingConfiguration = true
local spinning = false

local spinCount = 0

local lastResult = "Nenhum"
local lastRarity = "-"

local targetFound = false

local targetClan = "-"
local targetRarity = "-"

local AutoSpinToggle = nil


--========================================================--
-- HELPERS
--========================================================--

local function getRarityName(
    clanName
)

    if not clanName then
        return "Unknown"
    end

    local ok, rarityIndex =
        pcall(function()

            return ClanEvents.RarityOf(
                clanName
            )

        end)

    if ok and rarityIndex then

        return RARITY_NAMES[
            rarityIndex
        ] or "Unknown"

    end

    return "Unknown"
end


local function isTarget(
    clanName
)

    if not clanName then
        return false
    end

    -- Target individual
    if selectedClans[
        clanName
    ] then

        return true
    end

    -- Target por raridade
    local rarity =
        getRarityName(
            clanName
        )

    if selectedRarities[
        rarity
    ] then

        return true
    end

    return false
end


local function clearTarget()

    targetFound = false

    targetClan = "-"
    targetRarity = "-"
end


--========================================================--
-- 🛡️ PROTEÇÃO DO CLAN ATUAL
--========================================================--

-- A proteção é baseada SOMENTE no que o usuário selecionou.
-- Ex.: Legendary selecionado + conta começa com Supreme = pode girar.
-- Ex.: Legendary + Supreme selecionados + conta começa com qualquer
-- um deles = não gira.
--
-- Importante: antes de qualquer ClanSpin, o script precisa conseguir
-- confirmar o Clan atual. Se não conseguir, ele BLOQUEIA o spin por
-- segurança, evitando perder um Clan bom após relogar.
local PROTECT_SELECTED_ONLY = true


-- Retorna SOMENTE o Clan do slot atualmente equipado.
-- Estrutura: Player_Service > Data > LocalPlayer.Name > slots > SlotX > Clan
-- Não procura outros StringValues/fallbacks, evitando detectar Clan errado.
local function getCurrentClan()

    local playerService =
        ReplicatedStorage:FindFirstChild("Player_Service")

    if not playerService then
        return nil
    end

    local data =
        playerService:FindFirstChild("Data")

    if not data then
        return nil
    end

    local playerData =
        data:FindFirstChild(LocalPlayer.Name)

    if not playerData then
        return nil
    end

    local slotEquipped =
        playerData:FindFirstChild("slotEquipped")

    local slots =
        playerData:FindFirstChild("slots")

    if not slotEquipped or not slots then
        return nil
    end

    local slotNumber =
        tonumber(slotEquipped.Value)

    if not slotNumber then
        return nil
    end

    local slot =
        slots:FindFirstChild("Slot" .. tostring(slotNumber))

    if not slot then
        return nil
    end

    local clan =
        slot:FindFirstChild("Clan")

    if not clan then
        return nil
    end

    local clanName =
        tostring(clan.Value)

    if clanName == "" or clanName == "None" then
        return nil
    end

    return clanName
end


local function isClanProtected(clanName)

    if not clanName then
        return false
    end

    if not PROTECT_SELECTED_ONLY then
        return false
    end

    return isTarget(clanName)
end


local function notifyProtectedClan(clanName)

    local rarity = getRarityName(clanName)

    print("========================================")
    print("[🛡️ PROTEÇÃO] Spin bloqueado")
    print("Clan atual:", tostring(clanName))
    print("Raridade:", tostring(rarity))
    print("Motivo: Clan atual está entre os alvos selecionados.")
    print("========================================")

    Rayfield:Notify({
        Title = "🛡️ Clan Protegido",
        Content =
            tostring(clanName)
            .. " | "
            .. tostring(rarity)
            .. "\nEstá entre seus alvos selecionados.",
        Duration = 8
    })
end


local function waitForCurrentClan(timeout)

    local deadline = os.clock() + (timeout or 20)

    repeat

        local clan = getCurrentClan()

        if clan then
            print(
                "[Proteção] Clan atual detectado: "
                .. tostring(clan)
                .. " ["
                .. tostring(getRarityName(clan))
                .. "]"
            )
            return clan
        end

        task.wait(0.25)

    until os.clock() >= deadline

    return nil
end


--========================================================--
-- ⏩ AUTO SKIP DO LOADING (CAMINHO EXATO)
--========================================================--

local function getExactSkipButton()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then
        return nil
    end

    local components = playerGui:FindFirstChild("Components")
    if not components then
        return nil
    end

    local holder = components:FindFirstChild("Holder")
    if not holder then
        return nil
    end

    local skipHolder = holder:FindFirstChild("Skip_n_Loading_Holder")
    if not skipHolder then
        return nil
    end

    local buttonHolder = skipHolder:FindFirstChild("ButtonHolder")
    if not buttonHolder then
        return nil
    end

    local content = buttonHolder:FindFirstChild("Content")
    if not content then
        return nil
    end

    local button = content:FindFirstChild("TextButton")

    if button and button:IsA("TextButton") then
        return button
    end

    return nil
end


local function waitForExactSkipButton(timeout)
    timeout = timeout or 30

    local started = os.clock()
    local lastLog = -5

    while os.clock() - started < timeout do
        local button = getExactSkipButton()

        if button then
            local visible = true
            local active = true

            pcall(function()
                visible = button.Visible
            end)

            pcall(function()
                active = button.Active
            end)

            if visible and active ~= false then
                print(
                    "[Loading] 🎯 Skip encontrado após "
                    .. string.format("%.1f", os.clock() - started)
                    .. "s: "
                    .. button:GetFullName()
                )
                return button
            end
        end

        if os.clock() - lastLog >= 5 then
            lastLog = os.clock()
            print(
                "[Loading] ⏳ Aguardando Skip... "
                .. string.format("%.1f", os.clock() - started)
                .. "s"
            )
        end

        task.wait(0.1)
    end

    return nil
end


local function clickExactSkipButton(button)
    if not button or not button.Parent then
        return false
    end

    if type(firesignal) ~= "function" then
        warn("[Loading] ❌ firesignal não está disponível.")
        return false
    end

    local success, err = pcall(function()
        firesignal(button.MouseButton1Click)
    end)

    if success then
        print("[Loading] ✅ Skip loading acionado!")
        return true
    end

    warn("[Loading] ❌ Falha ao clicar no Skip:", tostring(err))
    return false
end


local function waitAndSkipLoading(timeout)
    timeout = timeout or 30

    print("[Loading] ⏳ Procurando o botão Skip pelo caminho exato...")

    local button = waitForExactSkipButton(timeout)

    if not button then
        print(
            "[Loading] ℹ️ Skip não apareceu dentro de "
            .. tostring(timeout)
            .. "s. Continuando normalmente."
        )
        return false
    end

    for attempt = 1, 3 do
        if not button.Parent then
            button = waitForExactSkipButton(3)
        end

        if button and clickExactSkipButton(button) then
            task.wait(2)
            print("[Loading] ✅ Loading pulado; aguardando interface estabilizar.")
            return true
        end

        if attempt < 3 then
            task.wait(0.25)
        end
    end

    warn("[Loading] ❌ Não foi possível acionar o Skip.")
    return false
end


--========================================================--
-- 🎨 CUSTOMIZE
--========================================================--

local function waitForCustomizeButton(timeout)
    timeout = timeout or 45

    local started = os.clock()
    local lastLog = -5

    while os.clock() - started < timeout do
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")

        if playerGui then
            local components = playerGui:FindFirstChild("Components")
            local menu = components and components:FindFirstChild("Menu")
            local optionsHolder = menu and menu:FindFirstChild("OptionsHolder")
            local presenter = optionsHolder
                and optionsHolder:FindFirstChild("2-CUSTOMIZE-Presenter")
            local button = presenter and presenter:FindFirstChild("Button")

            if button and button:IsA("TextButton") then
                print(
                    "[Customize] 🎯 Botão encontrado após "
                    .. string.format("%.1f", os.clock() - started)
                    .. "s: "
                    .. button:GetFullName()
                )
                return button
            end
        end

        if os.clock() - lastLog >= 5 then
            lastLog = os.clock()
            print(
                "[Customize] ⏳ Aguardando interface... "
                .. string.format("%.1f", os.clock() - started)
                .. "s"
            )
        end

        task.wait(0.25)
    end

    warn(
        "[Customize] ❌ Botão CUSTOMIZE não apareceu dentro de "
        .. tostring(timeout)
        .. "s."
    )

    return nil
end


local function openCustomize()
    if type(firesignal) ~= "function" then
        warn("[Customize] firesignal não está disponível.")
        return false
    end

    waitAndSkipLoading(30)

    local button = waitForCustomizeButton(45)

    if not button then
        return false
    end

    for attempt = 1, 3 do
        if not button.Parent then
            button = waitForCustomizeButton(10)
        end

        if not button then
            return false
        end

        local success, err = pcall(function()
            firesignal(button.MouseButton1Click)
        end)

        if success then
            print(
                "[Customize] ✅ Botão CUSTOMIZE acionado. Tentativa "
                .. tostring(attempt)
                .. "."
            )
            return true
        end

        warn(
            "[Customize] Falha na tentativa "
            .. tostring(attempt)
            .. ": "
            .. tostring(err)
        )

        task.wait(0.5)
    end

    warn("[Customize] ❌ Não foi possível acionar o botão CUSTOMIZE.")
    return false
end


local function openCustomizeAndWait()
    if startupSequenceDone then
        print("[Customize] ✅ Sequência inicial já concluída; pulando Loading/Customize.")
        return true
    end

    local opened = openCustomize()

    if not opened then
        return false
    end

    task.wait(1.5)

    startupSequenceDone = true
    print("[Customize] Área de Customize carregada.")
    print("[Customize] ✅ Sequência inicial concluída; não será repetida ao reativar Auto Spin.")
    return true
end


--========================================================--
-- TABS
--========================================================--

local SpinTab = Window:CreateTab(
    "🌀 Spin",
    4483362458
)

local ClansTab = Window:CreateTab(
    "🎯 Clans",
    4483362458
)

local RarityTab = Window:CreateTab(
    "⭐ Raridade",
    4483362458
)

local SettingsTab = Window:CreateTab(
    "⚙️ Interface",
    4483362458
)

local CreditsTab = Window:CreateTab(
    "👤 Créditos",
    4483362458
)

local CodesTab = Window:CreateTab(
    "🎁 Codes",
    4483362458
)


--========================================================--
-- CODES TAB
--========================================================--

CodesTab:CreateSection(
    "🎁 Resgate de Códigos"
)


CodesTab:CreateParagraph({

    Title = "Auto Redeem",

    Content =
        "Encontra automaticamente os códigos atuais do jogo "
        .. "e tenta resgatar os que ainda não foram utilizados."

})


CodesTab:CreateToggle({

    Name = "🎁 Auto Redeem",

    CurrentValue = true,

    Flag = "AutoRedeem",

    Callback = function(Value)

        autoRedeemEnabled = Value

        if Value then

            task.spawn(function()
                redeemAllCodes()
            end)

        end
    end
})


CodesTab:CreateButton({

    Name = "🔄 Resgatar Todos os Códigos",

    Callback = function()

        if redeemRunning then

            Rayfield:Notify({
                Title = "🎁 Auto Redeem",
                Content = "O resgate já está em andamento.",
                Duration = 3
            })

            return
        end

        autoRedeemEnabled = true

        task.spawn(function()
            redeemAllCodes()
        end)
    end
})


CodesTab:CreateButton({

    Name = "📋 Ver Códigos Disponíveis",

    Callback = function()

        local allCodes = getAvailableCodes()
        local codes = {}

        for _, entry in ipairs(allCodes) do
            if hasSpinReward(entry.data) then
                table.insert(codes, entry)
            end
        end

        print("========== CÓDIGOS DE SPIN/GIRO ==========")
        if #codes == 0 then
            print("Nenhum código de Spin/Giro encontrado.")
        else
            for _, entry in ipairs(codes) do
                print("•", entry.code)
            end
        end

        print("Total:", #codes)
        print("=========================================")

        Rayfield:Notify({
            Title = "📋 Códigos",
            Content =
                "Encontrados "
                .. tostring(#codes)
                .. " código(s) de Spin/Giro. Veja o Output.",
            Duration = 4
        })
    end
})


CodesTab:CreateButton({

    Name = "📊 Atualizar Status",

    Callback = function()

        local status = getCodeStatus()

        if not status then

            Rayfield:Notify({
                Title = "📊 Status",
                Content = "Não foi possível consultar o status.",
                Duration = 4
            })

            return
        end

        local redeemed = tonumber(status.redeemed) or 0
        local total = tonumber(status.total) or 0

        Rayfield:Notify({
            Title = "📊 Status dos Códigos",
            Content =
                tostring(redeemed)
                .. " / "
                .. tostring(total)
                .. " códigos resgatados.",
            Duration = 4
        })

        print("[Auto Redeem] Status:", redeemed, "/", total)
    end
})


--========================================================--
-- SPIN TAB
--========================================================--

SpinTab:CreateSection(
    "Controle"
)


local StatusParagraph =
    SpinTab:CreateParagraph({

        Title = "🟢 Status",

        Content =
            "🔴 AUTO SPIN PARADO"

    })


local ResultParagraph =
    SpinTab:CreateParagraph({

        Title =
            "🎲 Último Resultado",

        Content =
            "Nenhum spin realizado."

    })


local TargetParagraph =
    SpinTab:CreateParagraph({

        Title =
            "🎯 Confirmação",

        Content =
            "Nenhum alvo encontrado."

    })


--========================================================--
-- VISUAL UPDATE
--========================================================--

local function updateResultVisual(
    clanName
)

    local rarity =
        getRarityName(
            clanName
        )

    lastResult =
        clanName or "nil"

    lastRarity =
        rarity

    pcall(function()

        ResultParagraph:Set({

            Title =
                "🎲 Último Resultado",

            Content =
                "Clan: "
                .. tostring(
                    lastResult
                )

                .. "\nRaridade: "
                .. tostring(
                    lastRarity
                )

                .. "\nSpin #: "
                .. tostring(
                    spinCount
                )

        })

    end)
end


local function updateStatusVisual()

    pcall(function()

        local text

        if autoSpin then

            text =
                "🟢 AUTO SPIN ATIVO"

                .. "\nSpins realizados: "
                .. tostring(
                    spinCount
                )

        else

            text =
                "🔴 AUTO SPIN PARADO"

                .. "\nSpins realizados: "
                .. tostring(
                    spinCount
                )

        end

        StatusParagraph:Set({

            Title =
                "🟢 Status",

            Content = text

        })

    end)
end


local function showTargetFound(
    clanName
)

    local rarity =
        getRarityName(
            clanName
        )

    targetFound = true

    targetClan =
        clanName

    targetRarity =
        rarity

    pcall(function()

        TargetParagraph:Set({

            Title =
                "🎯 ALVO ENCONTRADO!",

            Content =

                "╔══════════════════════╗"

                .. "\n   CLAN: "
                .. tostring(
                    clanName
                )

                .. "\n   RARIDADE: "
                .. tostring(
                    rarity
                )

                .. "\n╚══════════════════════╝"

                .. "\n"

                .. "\n✅ Resultado recebido do servidor"

                .. "\n🛑 Auto Spin parado"

                .. "\n"

                .. "\nO resultado acima é o valor"

                .. "\nretornado pelo ClanSpin."

        })

    end)


    -- O jogo só aplica/mostra o novo Clan após reiniciar/recarregar a sessão.
    -- Bloqueia um novo Auto Spin nesta mesma sessão para não ler o Clan antigo.
    targetLockedUntilReload = true
    targetLockedClan = clanName

    -- Sinaliza arquivos para o Farmer Blox switcher salvar a conta e trocar
    pcall(function()
        if canUseFiles() then
            local safeName = tostring(LocalPlayer.Name):gsub("[^%w_%-]", "_")
            writefile("clan_" .. safeName .. ".txt", tostring(clanName))
            writefile("done_" .. safeName .. ".txt", "Clan:" .. tostring(clanName))
        end
    end)

    Rayfield:Notify({

        Title =
            "🎯 CLAN ENCONTRADO!",

        Content =
            tostring(
                clanName
            )

            .. " | "

            .. tostring(
                rarity
            )

            .. "\nAuto Spin parado.",

        Duration = 15

    })


    print(
        "========================================"
    )

    print(
        "[TARGET ENCONTRADO]"
    )

    print(
        "Clan: "
        .. tostring(
            clanName
        )
    )

    print(
        "Raridade: "
        .. tostring(
            rarity
        )
    )

    print(
        "Auto Spin: PARADO"
    )

    print(
        "ClanSpinComplete: NÃO ENVIADO"
    )

    print(
        "========================================"
    )
end


--========================================================--
-- MANUAL SPIN
--========================================================--

SpinTab:CreateButton({

    Name = "🎲 Girar 1x",

    Callback = function()

        if spinning then

            Rayfield:Notify({

                Title =
                    "⏳ Aguarde",

                Content =
                    "Um spin já está sendo processado.",

                Duration = 3

            })

            return
        end


        local currentClan = waitForCurrentClan(10)

        if currentClan and isClanProtected(currentClan) then
            notifyProtectedClan(currentClan)
            showTargetFound(currentClan)
            return
        end

        if not currentClan then
            Rayfield:Notify({
                Title = "🛡️ Proteção",
                Content =
                    "Não foi possível confirmar seu Clan atual.\n"
                    .. "Spin bloqueado por segurança.",
                Duration = 8
            })
            warn("[Proteção] Clan atual não foi detectado. Spin manual bloqueado.")
            return
        end

        spinning = true


        local ok, result =
            pcall(function()

                return SignalFunction.ToServer(
                    "ClanSpin"
                )

            end)


        if not ok then

            spinning = false

            Rayfield:Notify({

                Title =
                    "❌ Erro no Spin",

                Content =
                    tostring(
                        result
                    ),

                Duration = 6

            })

            return
        end


        if result == nil then

            spinning = false

            updateResultVisual(
                "nil"
            )

            Rayfield:Notify({

                Title =
                    "🚫 Spin não autorizado",

                Content =
                    "O servidor não retornou um Clan.",

                Duration = 7

            })

            return
        end


        spinCount += 1


        updateResultVisual(
            result
        )


        print(

            "[Manual Spin] #"
            .. tostring(
                spinCount
            )

            .. " → "
            .. tostring(
                result
            )

            .. " ["
            .. tostring(
                getRarityName(
                    result
                )
            )
            .. "]"

        )


        task.wait(2)


        pcall(function()

            SignalEvent.ToServer(
                "ClanSpinComplete"
            )

        end)


        spinning = false

        updateStatusVisual()

    end
})


--========================================================--
-- AUTO SPIN
--========================================================--

AutoSpinToggle = SpinTab:CreateToggle({

    Name = "🌀 Auto Spin",

    CurrentValue = false,

    Flag = "AutoSpin",

    Callback = function(
        Value
    )

        autoSpin = Value


        -- DESLIGAR
        if not Value then

            autoSpinStarting = false
            spinning = false

            updateStatusVisual()

            Rayfield:Notify({

                Title =
                    "🛑 Auto Spin",

                Content =
                    "Auto Spin desativado.",

                Duration = 3

            })

            return
        end


        -- Se um alvo já foi encontrado nesta sessão, o jogo ainda pode
        -- mostrar o Clan antigo até reiniciar. Não faça outro giro.
        if targetLockedUntilReload then

            autoSpin = false
            spinning = false
            autoSpinStarting = false
            updateStatusVisual()

            local lockedName = targetLockedClan or targetClan or "o Clan alvo"

            Rayfield:Notify({
                Title = "🛑 Reinício necessário",
                Content =
                    tostring(lockedName)
                    .. " foi encontrado.\n"
                    .. "O jogo só aplica o Clan após reiniciar.\n"
                    .. "Auto Spin continua bloqueado nesta sessão.",
                Duration = 10
            })

            warn(
                "[Proteção] Novo Auto Spin bloqueado: alvo encontrado = "
                .. tostring(lockedName)
                .. ". Reinicie a sessão para aplicar o Clan."
            )

            return
        end

        if spinning or autoSpinStarting then
            return
        end

        autoSpinStarting = true


        task.spawn(function()

            if loadingConfiguration then
                local deadline = os.clock() + 5
                while loadingConfiguration and os.clock() < deadline do
                    task.wait(0.1)
                end
            end

            if not autoSpin then
                autoSpinStarting = false
                return
            end

            if not openCustomizeAndWait() then

                autoSpin = false
                autoSpinStarting = false
                spinning = false
                updateStatusVisual()

                Rayfield:Notify({
                    Title = "🎨 Customize",
                    Content =
                        "Não foi possível abrir o menu CUSTOMIZE.\n"
                        .. "Auto Spin foi bloqueado por segurança.",
                    Duration = 8
                })

                warn("[Customize] Auto Spin bloqueado porque CUSTOMIZE não pôde ser aberto.")
                return
            end

            if not autoSpin then
                autoSpinStarting = false
                return
            end

            local currentClan = waitForCurrentClan(20)

            if not autoSpin then
                autoSpinStarting = false
                return
            end

            if not currentClan then

                autoSpin = false
                autoSpinStarting = false
                spinning = false
                updateStatusVisual()

                Rayfield:Notify({
                    Title = "🛡️ Proteção ativada",
                    Content =
                        "Não foi possível confirmar seu Clan atual.\n"
                        .. "Auto Spin foi bloqueado por segurança.",
                    Duration = 10
                })

                warn("[Proteção] Clan atual não foi detectado. Auto Spin bloqueado.")
                return
            end

            if isClanProtected(currentClan) then

                autoSpin = false
                spinning = false
                updateStatusVisual()

                notifyProtectedClan(currentClan)
                showTargetFound(currentClan)
                return
            end

            clearTarget()
            updateStatusVisual()

            Rayfield:Notify({

                Title =
                    "🌀 Auto Spin",

                Content =
                    "Auto Spin iniciado.\nClan atual: "
                    .. tostring(currentClan),

                Duration = 4

            })

            autoSpinStarting = false

            while autoSpin do

                if spinning then

                    task.wait(
                        0.2
                    )

                    continue
                end


                spinning = true


                local ok, result =
                    pcall(function()

                        return SignalFunction.ToServer(
                            "ClanSpin"
                        )

                    end)


                -- ERRO
                if not ok then

                    print(
                        "[Auto Spin] ERRO: "
                        .. tostring(
                            result
                        )
                    )

                    autoSpin = false
                    spinning = false

                    updateStatusVisual()


                    Rayfield:Notify({

                        Title =
                            "❌ Auto Spin parado",

                        Content =
                            "Erro ao solicitar ClanSpin.",

                        Duration = 7

                    })

                    break
                end


                -- RESULTADO NIL (Spins esgotados ou não autorizado)
                if result == nil then

                    print(
                        "[Auto Spin] Resultado nil - Spin não autorizado ou sem giros"
                    )

                    autoSpin = false
                    spinning = false

                    updateResultVisual(
                        "nil"
                    )

                    updateStatusVisual()

                    -- Avisa Farmer Blox que acabaram os spins nesta conta
                    pcall(function()
                        if canUseFiles() then
                            local safeName = tostring(LocalPlayer.Name):gsub("[^%w_%-]", "_")
                            writefile("done_" .. safeName .. ".txt", "Clan:SemSpins")
                        end
                    end)

                    Rayfield:Notify({

                        Title =
                            "🚫 Spin bloqueado / Sem Giros",

                        Content =
                            "O servidor não retornou um Clan."
                            .. "\nAuto Spin foi parado.",

                        Duration = 8

                    })

                    break
                end


                -- RESULTADO
                spinCount += 1


                local clanName =
                    tostring(
                        result
                    )


                local rarity =
                    getRarityName(
                        clanName
                    )


                updateResultVisual(
                    clanName
                )

                updateStatusVisual()

                -- Heartbeat para o Farmer Blox
                pcall(function()
                    if canUseFiles() then
                        local safeName = tostring(LocalPlayer.Name):gsub("[^%w_%-]", "_")
                        writefile("heartbeat_" .. safeName .. ".txt", tostring(os.time()) .. "|" .. tostring(clanName))
                    end
                end)


                print(

                    "[Auto Spin] #"
                    .. tostring(
                        spinCount
                    )

                    .. " → "
                    .. clanName

                    .. " ["
                    .. rarity
                    .. "]"

                )


                --================================================--
                -- TARGET
                --================================================--

                if isTarget(
                    clanName
                ) then

                    autoSpin = false
                    spinning = false


                    showTargetFound(
                        clanName
                    )


                    updateStatusVisual()

                    break
                end


                --================================================--
                -- COMPLETE
                --================================================--

                task.wait(2)


                local completeOK,
                    completeError =
                    pcall(function()

                        return SignalEvent.ToServer(
                            "ClanSpinComplete"
                        )

                    end)


                if completeOK then

                    print(
                        "[Auto Spin] Complete enviado"
                    )

                else

                    print(

                        "[Auto Spin] Erro no Complete: "
                        .. tostring(
                            completeError
                        )

                    )

                end


                spinning = false


                task.wait(
                    0.5
                )

            end


            spinning = false

            updateStatusVisual()

        end)

    end
})


--========================================================--
-- CLEAR CONFIRMATION
--========================================================--

SpinTab:CreateButton({

    Name =
        "🔄 Limpar confirmação",

    Callback = function()

        clearTarget()


        pcall(function()

            TargetParagraph:Set({

                Title =
                    "🎯 Confirmação",

                Content =
                    "Nenhum alvo encontrado."

            })

        end)


        Rayfield:Notify({

            Title =
                "🔄 Limpo",

            Content =
                "A confirmação visual foi limpa.",

            Duration = 3

        })

    end
})


--========================================================--
-- CLANS TAB
--========================================================--

ClansTab:CreateSection(
    "Selecione os Clans"
)


ClansTab:CreateParagraph({

    Title =
        "ℹ️ Como funciona",

    Content =

        "Marque um ou mais Clans."

        .. "\n"

        .. "\nO Auto Spin irá parar imediatamente"

        .. "\nquando o servidor retornar um deles."

        .. "\n"

        .. "\nVocê também pode usar"

        .. "\n⭐ Raridade para parar por raridade."

})


for _, rarity in ipairs(
    RARITY_ORDER
) do

    ClansTab:CreateSection(
        "⭐ " .. rarity
    )


    for _, clanName in ipairs(
        clansByRarity[rarity]
    ) do

        ClansTab:CreateToggle({

            Name =
                clanName,

            CurrentValue =
                selectedClans[clanName] or false,

            Flag =
                "Clan_" .. clanName,

            Callback =
                function(
                    Value
                )

                    selectedClans[
                        clanName
                    ] = Value


                    print(

                        "[Target Clan] "
                        .. clanName
                        .. " = "
                        .. tostring(
                            Value
                        )

                    )

                end
        })

    end
end


--========================================================--
-- RARITY TAB
--========================================================--

RarityTab:CreateSection(
    "Selecione as raridades"
)


RarityTab:CreateParagraph({

    Title =
        "⭐ Target por Raridade",

    Content =

        "Se uma raridade estiver ativada,"

        .. "\no Auto Spin irá parar quando"

        .. "\nqualquer Clan daquela raridade"

        .. "\nfor retornado pelo servidor."

})


for _, rarity in ipairs(
    RARITY_ORDER
) do

    local count =
        #clansByRarity[rarity]


    RarityTab:CreateToggle({

        Name =

            "⭐ "
            .. rarity
            .. " ("
            .. tostring(
                count
            )
            .. " Clans)",

        CurrentValue =
            selectedRarities[rarity] or false,

        Flag =
            "Rarity_" .. rarity,

        Callback =
            function(
                Value
            )

                selectedRarities[
                    rarity
                ] = Value


                print(

                    "[Target Raridade] "
                    .. rarity
                    .. " = "
                    .. tostring(
                        Value
                    )

                )

            end

    })

end


--========================================================--
-- RARITY INFORMATION
--========================================================--

RarityTab:CreateSection(
    "📋 Clans por Raridade"
)


for _, rarity in ipairs(
    RARITY_ORDER
) do

    local names = {}


    for _, clanName in ipairs(
        clansByRarity[rarity]
    ) do

        table.insert(
            names,
            clanName
        )

    end


    RarityTab:CreateParagraph({

        Title =

            rarity
            .. " | "
            .. tostring(
                #names
            )
            .. " Clans",

        Content =

            table.concat(
                names,
                ", "
            )

    })

end


--========================================================--
-- INTERFACE TAB
--========================================================--

SettingsTab:CreateSection(
    "📐 Tamanho da janela"
)


SettingsTab:CreateParagraph({

    Title =
        "⚙️ Configuração da Interface",

    Content =

        "Altere o tamanho da janela usando"

        .. "\nos sliders abaixo."

        .. "\n"

        .. "\nO tamanho e a posição são salvos"

        .. "\nautomaticamente."

})


--========================================================--
-- WIDTH SLIDER
--========================================================--

local WidthSlider


WidthSlider =
    SettingsTab:CreateSlider({

        Name =
            "↔️ Largura",

        Range = {
            MIN_WIDTH,
            MAX_WIDTH
        },

        Increment = 10,

        Suffix =
            " px",

        CurrentValue =
            currentWidth,

        Flag =
            "WindowWidth",

        Callback =
            function(
                Value
            )

                currentWidth =
                    math.floor(
                        Value
                    )


                applyWindowSize(
                    currentWidth,
                    currentHeight
                )

            end

    })


--========================================================--
-- HEIGHT SLIDER
--========================================================--

local HeightSlider


HeightSlider =
    SettingsTab:CreateSlider({

        Name =
            "↕️ Altura",

        Range = {
            MIN_HEIGHT,
            MAX_HEIGHT
        },

        Increment = 10,

        Suffix =
            " px",

        CurrentValue =
            currentHeight,

        Flag =
            "WindowHeight",

        Callback =
            function(
                Value
            )

                currentHeight =
                    math.floor(
                        Value
                    )


                applyWindowSize(
                    currentWidth,
                    currentHeight
                )

            end

    })


--========================================================--
-- SAVE SIZE + POSITION
--========================================================--

SettingsTab:CreateButton({

    Name =
        "💾 Salvar tamanho e posição",

    Callback =
        function()

            if not RayfieldMain then

                Rayfield:Notify({

                    Title =
                        "❌ Erro",

                    Content =
                        "Não encontrei a janela do Rayfield.",

                    Duration = 5

                })

                return
            end


            local position =
                RayfieldMain.Position


            saveWindowConfig(

                currentWidth,
                currentHeight,

                position.X.Scale,
                position.Y.Scale,

                position.X.Offset,
                position.Y.Offset

            )


            Rayfield:Notify({

                Title =
                    "💾 Configuração salva",

                Content =

                    "Tamanho: "
                    .. tostring(
                        currentWidth
                    )
                    .. " x "
                    .. tostring(
                        currentHeight
                    )

                    .. "\nPosição também salva.",

                Duration = 5

            })


            print(
                "[Interface] Configuração salva"
            )


            print(

                "[Interface] Size: "
                .. tostring(
                    currentWidth
                )
                .. "x"
                .. tostring(
                    currentHeight
                )

            )


            print(

                "[Interface] Position: "
                .. tostring(
                    position
                )

            )

        end
})


--========================================================--
-- RESET SIZE
--========================================================--

SettingsTab:CreateButton({

    Name =
        "🔄 Restaurar tamanho padrão",

    Callback =
        function()

            currentWidth =
                DEFAULT_WIDTH

            currentHeight =
                DEFAULT_HEIGHT


            applyWindowSize(
                currentWidth,
                currentHeight
            )


            if RayfieldMain then

                local position =
                    RayfieldMain.Position


                saveWindowConfig(

                    currentWidth,
                    currentHeight,

                    position.X.Scale,
                    position.Y.Scale,

                    position.X.Offset,
                    position.Y.Offset

                )

            end


            Rayfield:Notify({

                Title =
                    "🔄 Tamanho restaurado",

                Content =

                    tostring(
                        DEFAULT_WIDTH
                    )
                    .. " x "
                    .. tostring(
                        DEFAULT_HEIGHT
                    ),

                Duration = 4

            })

        end
})


--========================================================--
-- RESET POSITION
--========================================================--

SettingsTab:CreateButton({

    Name =
        "📍 Centralizar janela",

    Callback =
        function()

            if not RayfieldMain then
                return
            end


            pcall(function()

                RayfieldMain.Position =
                    UDim2.new(
                        0.5,
                        0,
                        0.5,
                        0
                    )

            end)


            task.wait(0.2)


            schedulePositionSave()


            Rayfield:Notify({

                Title =
                    "📍 Janela centralizada",

                Content =
                    "Nova posição salva.",

                Duration = 3

            })

        end
})


--========================================================--
-- RESET EVERYTHING
--========================================================--

SettingsTab:CreateButton({

    Name =
        "🗑️ Resetar tamanho + posição",

    Callback =
        function()

            currentWidth =
                DEFAULT_WIDTH

            currentHeight =
                DEFAULT_HEIGHT


            applyWindowSize(
                currentWidth,
                currentHeight
            )


            if RayfieldMain then

                pcall(function()

                    RayfieldMain.Position =
                        UDim2.new(
                            DEFAULT_POS_X,
                            DEFAULT_POS_OFFSET_X,
                            DEFAULT_POS_Y,
                            DEFAULT_POS_OFFSET_Y
                        )

                end)

            end


            task.wait(0.2)


            if RayfieldMain then

                local position =
                    RayfieldMain.Position


                saveWindowConfig(

                    currentWidth,
                    currentHeight,

                    position.X.Scale,
                    position.Y.Scale,

                    position.X.Offset,
                    position.Y.Offset

                )

            end


            Rayfield:Notify({

                Title =
                    "🔄 Interface resetada",

                Content =
                    "Tamanho e posição voltaram ao padrão.",

                Duration = 4

            })

        end
})


--========================================================--
-- CURRENT SIZE INFO
--========================================================--

SettingsTab:CreateSection(
    "📊 Atual"
)


local CurrentSizeParagraph =
    SettingsTab:CreateParagraph({

        Title =
            "📐 Tamanho atual",

        Content =

            tostring(
                currentWidth
            )

            .. " x "

            .. tostring(
                currentHeight
            )

            .. " px"

    })


task.spawn(function()

    while task.wait(1) do

        if CurrentSizeParagraph then

            pcall(function()

                CurrentSizeParagraph:Set({

                    Title =
                        "📐 Tamanho atual",

                    Content =

                        tostring(
                            currentWidth
                        )

                        .. " x "

                        .. tostring(
                            currentHeight
                        )

                        .. " px"

                })

            end)

        end

    end

end)


--========================================================--
-- CREDITS TAB
--========================================================--

CreditsTab:CreateSection(
    "! Shu神"
)


CreditsTab:CreateParagraph({

    Title =
        "PROJECT SLAYER 2 | Clan Spinner",

    Content =

        "Desenvolvido por ! Shu神"

        .. "\n\n"

        .. "© 2026 ! Shu神"

        .. "\nTodos os direitos reservados."

        .. "\n\n"

        .. "Discord: discord.gg/hhXm4tmyhJ"

})


CreditsTab:CreateSection(
    "💬 Discord"
)


CreditsTab:CreateButton({

    Name =
        "💬 Copiar Discord",

    Callback =
        function()

            local copied = false


            if type(setclipboard) == "function" then

                copied =
                    pcall(function()

                        setclipboard(
                            "https://discord.gg/hhXm4tmyhJ"
                        )

                    end)

            elseif type(toclipboard) == "function" then

                copied =
                    pcall(function()

                        toclipboard(
                            "https://discord.gg/hhXm4tmyhJ"
                        )

                    end)

            end


            if copied then

                Rayfield:Notify({

                    Title =
                        "💬 Discord",

                    Content =
                        "Link copiado para a área de transferência!",

                    Duration = 4

                })

            else

                Rayfield:Notify({

                    Title =
                        "💬 Discord",

                    Content =
                        "discord.gg/hhXm4tmyhJ",

                    Duration = 6

                })

            end

        end
})


CreditsTab:CreateButton({

    Name =
        "👤 Criador: ! Shu神",

    Callback =
        function()

            Rayfield:Notify({

                Title =
                    "! Shu神",

                Content =
                    "© 2026 ! Shu神",

                Duration = 4

            })

        end
})


--========================================================--
-- STARTUP
--========================================================--

print(
    "========================================"
)

print(
    "     PROJECT SLAYER 2 | CLAN SPINNER"
)

print(
    "     Created by ! Shu神"
)

print(
    "     © 2026 ! Shu神"
)

print(
    "========================================"
)

print("")

print(
    "Clans carregados:"
)


for _, rarity in ipairs(
    RARITY_ORDER
) do

    print(

        rarity
        .. " = "
        .. tostring(
            #clansByRarity[rarity]
        )

    )

end


print("")


print(

    "Window Size: "
    .. tostring(
        currentWidth
    )
    .. "x"
    .. tostring(
        currentHeight
    )

)


print(

    "Window Config: "
    .. tostring(
        CONFIG_FILE
    )

)


print("")

print(
    "Discord: discord.gg/hhXm4tmyhJ"
)

print("")

print(
    "========================================"
)


Rayfield:Notify({

    Title =
        "PROJECT SLAYER 2",

    Content =

        "Clan Spinner carregado."

        .. "\nby ! Shu神"

        .. "\nTamanho: "
        .. tostring(
            currentWidth
        )
        .. "x"
        .. tostring(
            currentHeight
        ),

    Duration = 5

})


--========================================================--
-- AUTO REDEEM AO INICIAR
--========================================================--

task.delay(2, function()

    if not autoRedeemEnabled then
        return
    end

    task.spawn(function()
        redeemAllCodes()
    end)

end)


--========================================================--
-- RAYFIELD CONFIG
--========================================================--

pcall(function()

    Rayfield:LoadConfiguration()

end)

loadingConfiguration = false
print("[Proteção] LoadConfiguration concluído; Auto Spin liberado para verificar o Clan.")


-- Se configurado via Farmer Blox / global config para auto-girar, ativa o toggle
task.delay(3, function()
    pcall(function()
        local cfg = _G.ClanConfig or (type(getgenv) == "function" and getgenv().ClanConfig) or nil
        if cfg and (cfg.autoSpin == true or cfg.autoSpin == nil) then
            if AutoSpinToggle and not autoSpin and not targetFound then
                print("[Farmer Blox] Auto Spin ativado automaticamente via configuração global.")
                AutoSpinToggle:Set(true)
            end
        end
    end)
end)


--========================================================--
-- REAPPLY CUSTOM WINDOW CONFIG
--========================================================--

task.delay(
    0.5,
    function()

        if RayfieldMain then

            applyWindowSize(
                currentWidth,
                currentHeight
            )

            applyWindowPosition(
                WindowConfig.PosX,
                WindowConfig.PosY,
                WindowConfig.OffsetX,
                WindowConfig.OffsetY
            )

        end

    end
)
