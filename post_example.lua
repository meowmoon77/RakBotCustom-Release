-- Пример отправки POST-запроса

function onScriptStart()
    print("[POST] --- Тест POST-запроса ---")

    local url = "https://httpbin.org/post"
    
    -- Данные, которые мы хотим отправить
    local payload = {
        username = "Test_User",
        password = "secret_password",
        action = "login",
        text = "Привет, мир!" -- Русский текст автоматически закодируется
    }

    print("[POST] Отправляем данные на " .. url)
    
    -- postUrl(URL, Таблица_параметров)
    local response, code = postUrl(url, payload)
    
    if code == 0 then
        print("[POST] Успех! Ответ сервера:")
        print(response)
    else
        print("[POST][ERROR] Ошибка HTTP. Код: " .. tostring(code))
    end
end