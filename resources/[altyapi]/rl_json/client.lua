function jsonGet(file, private)
    if private then
        file = "@JSON_FILES/" .. file .. ".json"
    else
        file = "JSON_FILES/" .. file .. ".json"
    end
    local fileHandle
    local jsonData = {}
    if not fileExists(file) then
        return {}, false
    else
        fileHandle = fileOpen(file)
    end
    if fileHandle then
        local buffer
        local allBuffer = ""
        while not fileIsEOF(fileHandle) do
            buffer = fileRead(fileHandle, 500)
            allBuffer = allBuffer .. buffer
        end
        jsonData = fromJSON(allBuffer)
        fileClose(fileHandle)
    end
    return jsonData, true
end

function jsonSave(file, data, private)
    if private then
        file = "@JSON_FILES/" .. file .. ".json"
    else
        file = "JSON_FILES/" .. file .. ".json"
    end
    if fileExists(file) then
        fileDelete(file)
    end
    local fileHandle = fileCreate(file)
    fileWrite(fileHandle, toJSON(data))
    fileFlush(fileHandle)
    fileClose(fileHandle)
    return true
end

function jsonDelete(file, private)
    if private then
        file = "@JSON_FILES/" .. file .. ".json"
    else
        file = "JSON_FILES/" .. file .. ".json"
    end
    if fileExists(file) then
        fileDelete(file)
    end
    return true
end