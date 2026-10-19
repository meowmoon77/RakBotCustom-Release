-- Скрипт автоматической рулетки + отправка призов в VK

local spin_enabled = true
local roulette_checked = false
local roulette_dialog_id = 10294

-- НАСТРОЙКИ VK API
local vk_token = "vk1."
local vk_peer_id = "301769883"
local vk_api_version = "5.199"

function onSetSpawnPos(x, y, z)
    if spin_enabled and not roulette_checked then
        roulette_checked = true
        sendInput("/рулетка")
    end
end

-- Срабатывает, если бот заспавнился
function onSpawned()
    if spin_enabled and not roulette_checked then
        roulette_checked = true
        sendInput("/рулетка")
    end
end

-- Перехват сообщений сервера
function onServerMessage(color, message)
    if not spin_enabled then return false end

    -- Проверяем, начинается ли сообщение со слова "Приз:"
    if message:find("^Приз:") then
        print("Обнаружен выигрыш: " .. message)
        
        local encoded_message = encodeUrl(message)
        local random_id = randomNumber(1, 2147483647)
        
        local url = string.format(
            "https://api.vk.com/method/messages.send?access_token=%s&v=%s&peer_id=%s&message=%s&random_id=%d",
            vk_token, vk_api_version, vk_peer_id, encoded_message, random_id
        )
        
        local response, code = getUrl(url)
        
        if code == 0 then
            if response:find('"error"') then
                print("[VK] Ошибка API: " .. response)
            else
                print("[VK] Сообщение успешно отправлено в VK")
            end
        else
            print("[VK] Ошибка HTTP-запроса. Код: " .. tostring(code))
        end
        
        return false
    end

    if message:find("Рулетка готова") or message:find("Дополнительная прокрутка") then
        sendInput("/рулетка")
        return true 
    end
    
    return false
end

-- Перехват открытия диалогов
function onDialogShow(id, style, title, ok_text, cancel_text, text)
    if not spin_enabled then return false end

    if id == roulette_dialog_id and text:find("Крутить") then
        sendDialog(id, 1, 0xFFFF, "")
        return true 
    end
    
    return false
end

-- Срабатывает при загрузке скрипта
function onScriptStart()
end

-- Срабатывает при выгрузке скрипта
function onScriptExit()
end