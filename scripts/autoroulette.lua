local spin_enabled = true
local roulette_checked = false

-- Настройки ВК
local vk_token = "token"
local vk_peer_id = "id" 
local vk_api_version = "5.199"

function onSpawned()
    if spin_enabled and not roulette_checked then
        roulette_checked = true
        sendInput("/рулетка")
        
        -- Через 3 секунды сбрасываем флаг для следующего спавна
        defCallAdd(3000, false, function()
            roulette_checked = false
        end)
    end
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

        local params = {
            peer_id = vk_peer_id,
            message = getNickName() .. "\\n" .. currentServerName .. "\\n" .. message,
            random_id = randomNumber(1, 2147483647),
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
        if spin_enabled then sendInput("/рулетка") end
    end
end

function onScriptStart()
end

function onScriptExit()
end