--========================================================--
--        PROJECT SLAYER 2 - CLAN SPINNER
--        Auto Spin + Target + Rarity + Auto Redeem
--        Visual Confirmation
--        Custom Size + Position Saving
--        Created by ! Shu神
--        © 2026 ! Shu神
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


local function getAvailableCodes()

    local result = {}

    local ok, codesData = pcall(function()
        return LiveConfig.get("Codes")
    end)

    if not ok or typeof(codesData) ~= "table" then
        warn("[Auto Redeem] Não foi possível obter LiveConfig.Codes")
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


local function getCodeStatus()

    local ok, result = pcall(function()
        return SignalFunction.ToServer("CodeStatus")
    end)

    if ok and typeof(result) == "table" then
        return result
    end

    warn(
        "[Auto Redeem] CodeStatus falhou:",
        tostring(result)
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
-- TARGETS
--========================================================--

local selectedClans = {}
local selectedRarities = {}


--========================================================--
-- STATE
--========================================================--

local autoSpin = false
local spinning = false

local spinCount = 0

local lastResult = "Nenhum"
local lastRarity = "-"

local targetFound = false

local targetClan = "-"
local targetRarity = "-"


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


local function getPlayerDataContainer()

    local roots = {
        LocalPlayer,
        ReplicatedStorage
    }

    for _, root in ipairs(roots) do

        local playerService = root:FindFirstChild("Player_Service")

        if playerService then

            local dataRoot = playerService:FindFirstChild("Data")

            if dataRoot then

                -- Primeiro tenta pelo nome do jogador.
                local exact = dataRoot:FindFirstChild(LocalPlayer.Name)

                if exact then
                    return exact
                end

                -- Também procura um container de dados que possua
                -- RedeemedCodes, estrutura já observada neste jogo.
                for _, child in ipairs(dataRoot:GetChildren()) do
                    if child:FindFirstChild("RedeemedCodes", true) then
                        return child
                    end
                end
            end
        end
    end

    return nil
end


local function isKnownClanName(value)

    if type(value) ~= "string" or value == "" then
        return false
    end

    -- clansByRarity já foi montado antes desta seção.
    for _, rarity in ipairs(RARITY_ORDER) do
        for _, clanName in ipairs(clansByRarity[rarity]) do
            if clanName == value then
                return true
            end
        end
    end

    return false
end


local function readClanFromRoot(root)

    if not root then
        return nil
    end

    -- 1. Atributos conhecidos.
    for _, attributeName in ipairs({
        "Clan",
        "CurrentClan",
        "ClanName",
        "Current_Clan"
    }) do

        local ok, value = pcall(function()
            return root:GetAttribute(attributeName)
        end)

        if ok and isKnownClanName(value) then
            return value
        end
    end

    -- 2. Qualquer atributo que contenha exatamente o nome de um Clan.
    local attributesOK, attributes = pcall(function()
        return root:GetAttributes()
    end)

    if attributesOK and type(attributes) == "table" then
        for _, value in pairs(attributes) do
            if isKnownClanName(value) then
                return value
            end
        end
    end

    -- 3. StringValues/objetos nomeados Clan ou CurrentClan.
    for _, obj in ipairs(root:GetDescendants()) do

        if obj.Name == "Clan"
            or obj.Name == "CurrentClan"
            or obj.Name == "ClanName"
            or obj.Name == "Current_Clan"
        then

            if obj:IsA("StringValue") then
                local value = obj.Value
                if isKnownClanName(value) then
                    return value
                end
            end
        end
    end

    -- 4. Fallback seguro: procura qualquer StringValue cujo valor
    -- seja exatamente um Clan conhecido do jogo. Isso evita depender
    -- do nome interno que o servidor usa para guardar o Clan.
    for _, obj in ipairs(root:GetDescendants()) do

        if obj:IsA("StringValue") then

            local value = obj.Value

            if isKnownClanName(value) then
                return value
            end
        end
    end

    return nil
end


local function getCurrentClan()

    -- 1. Dados/atributos diretamente no Player.
    local clan = readClanFromRoot(LocalPlayer)

    if clan then
        return clan
    end

    -- 2. Container de dados do jogador.
    local data = getPlayerDataContainer()

    clan = readClanFromRoot(data)

    if clan then
        return clan
    end

    -- 3. Fallback: procura em Player_Service/Data inteiro.
    -- Isso é útil quando o nome do container da conta é dinâmico.
    local playerService = ReplicatedStorage:FindFirstChild("Player_Service")

    if playerService then

        local dataRoot = playerService:FindFirstChild("Data")

        if dataRoot then

            clan = readClanFromRoot(dataRoot)

            if clan then
                return clan
            end
        end
    end

    return nil
end


local function isClanProtected(clanName)

    if not clanName then
        return false
    end

    if not PROTECT_SELECTED_ONLY then
        return false
    end

    -- A mesma lógica usada para decidir se o resultado do spin é alvo.
    -- Portanto, a proteção acompanha exatamente as raridades/Clans
    -- marcados pelo usuário.
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
            print("[Proteção] Clan atual detectado:", clan, "[" .. getRarityName(clan) .. "]")
            return clan
        end

        task.wait(0.25)

    until os.clock() >= deadline

    return nil
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


        -- 🛡️ Proteção também vale para o spin manual.
        -- Se o Clan atual for Rare+ (ou um alvo configurado),
        -- o script não envia ClanSpin.
        local currentClan = waitForCurrentClan(10)

        if currentClan and isClanProtected(currentClan) then
            notifyProtectedClan(currentClan)
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

SpinTab:CreateToggle({

    Name = "🌀 Auto Spin",

    CurrentValue = false,

    Flag = "AutoSpin",

    Callback = function(
        Value
    )

        autoSpin = Value


        -- DESLIGAR
        if not Value then

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


        if spinning then
            return
        end


        -- 🛡️ ANTES DE QUALQUER ClanSpin, confirma o Clan atual.
        -- Isso é especialmente importante após relogar, quando o
        -- Rayfield pode restaurar o Auto Spin automaticamente.
        task.spawn(function()

            local currentClan = waitForCurrentClan(15)

            -- O usuário desligou enquanto estávamos esperando.
            if not autoSpin then
                return
            end

            -- Se não conseguimos descobrir o Clan, NÃO arrisca girar.
            if not currentClan then

                autoSpin = false
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

            -- Se já possui Clan bom, NÃO envia ClanSpin.
            if isClanProtected(currentClan) then

                autoSpin = false
                spinning = false
                updateStatusVisual()

                notifyProtectedClan(currentClan)
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


                -- RESULTADO NIL
                if result == nil then

                    print(
                        "[Auto Spin] Resultado nil - Spin não autorizado"
                    )

                    autoSpin = false
                    spinning = false

                    updateResultVisual(
                        "nil"
                    )

                    updateStatusVisual()


                    Rayfield:Notify({

                        Title =
                            "🚫 Spin bloqueado",

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


                    -- IMPORTANTE:
                    -- Não envia ClanSpinComplete
                    -- quando encontra o alvo.

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
                false,

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
            false,

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

-- O Auto Redeem inicia sozinho alguns instantes depois
-- que o script e a interface terminam de carregar.
-- Nao e necessario clicar no botao.

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


--========================================================--
-- REAPPLY CUSTOM WINDOW CONFIG
--========================================================--

-- O LoadConfiguration pode alterar os sliders.
-- Reaplica o tamanho personalizado depois dele.

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
