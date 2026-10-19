-- Пример работы с JSON

function onScriptStart()
    print("[JSON] --- Тест Encode/Decode ---")

    -- 1. ENCODE (Таблица -> JSON)
    local my_data = {
        bot_name = "RakBot_NG",
        version = 0.85,
        online = true,
        features = { "roulette", "parser", "map" }
    }
    
    -- encodeJson(таблица, unicode, pretty)
    local json_str = encodeJson(my_data, true, true)
    print("[JSON] Результат Encode:")
    print(json_str)

    -- 2. DECODE (JSON -> Таблица)
    -- Представим, что это ответ от какого-то API
    local raw_response = '{"status":"ok","user":{"id":777,"name":"Meow"}}'
    
    local decoded = decodeJson(raw_response)
    
    -- ВАЖНО: Обязательно проверяем на nil!
    if decoded then
        print("[JSON] Результат Decode:")
        print("Статус: " .. decoded.status)
        print("ID юзера: " .. tostring(decoded.user.id))
        print("Имя юзера: " .. decoded.user.name)
    else
        print("[JSON][ERROR] Не удалось распарсить JSON (строка битая)")
    end
end