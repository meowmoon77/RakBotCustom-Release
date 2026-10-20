local spin_enabled = true
local roulette_checked = false
local roulette_dialog_id = 10294

-- Настройки ВК
local vk_token = "vk1."
local vk_peer_id = "id"
local vk_api_version = "5.199"

-- Универсальная функция запуска рулетки (с защитой от спама)
local function try_spin()
    -- Проверяем, что рулетка включена, нет активного кулдауна и бот подключен
    if spin_enabled and not roulette_checked and isBotConnected() then
        roulette_checked = true
        sendInput("/рулетка")
        
        -- Через 3 секунды сбрасываем флаг
        defCallAdd(3000, false, function()
            roulette_checked = false
        end)
    end
end

function onSpawned()
    try_spin()
end

function onScriptStart()
    try_spin()
end

function onDialogShow(id, style, title, ok_text, cancel_text, text)
    if spin_enabled then
        if id == roulette_dialog_id and text:find("Крутить") then
            sendDialog(id, 1, 0xFFFF, "")
            return true 
        end
    end
    return false
end

function onServerMessage(color, message)
    if not spin_enabled then return false end

    if message:find("^Приз:") then
        local serverName = {}
        serverName[7771] = "Platinum [RP1]"
        serverName[7772] = "Titanium [RP2]"
        serverName[7773] = "Chromium [RP3]"
        serverName[7774] = "Aurum [RP4]"
        serverName[7775] = "Lithium [RP5]"
        
        local currentPort = getServerPort()
        local currentServerName = serverName[currentPort] or ("Unknown")

        -- Соль для random_id (время + рандом), чтобы ВК не блочил
        local safe_random_id = os.time() + randomNumber(1, 100000)

        local params = {
            peer_id = vk_peer_id,
            message = getNickName() .. "\\n" .. currentServerName .. "\\n" .. message,
            random_id = safe_random_id,
            access_token = vk_token,
            v = vk_api_version
        }
        
        local response, status = postUrl("https://api.vk.com/method/messages.send", params)
        
        if status == 0 then
            if response:find('"error"') then
                print("[VK] Ошибка API: " .. response)
            else
                print("[VK] Приз отправлен в VK")
            end
        else
            print("[VK] Ошибка HTTP: " .. tostring(status))
        end
        return true
    end

    if message:find("Рулетка готова") or message:find("Дополнительная прокрутка") then
        roulette_checked = false
        try_spin()
    end
end

function onScriptExit()
end