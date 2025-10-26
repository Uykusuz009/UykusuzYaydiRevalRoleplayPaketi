function getCommandArguments(msg)
    local arguments, command = {}
    for argument in utf8.gmatch(msg, '%S+') do
        if utf8.sub(argument, 1, 1) == '/' and not command then
            command = utf8.sub(argument, 2)
        else
            table.insert(arguments, argument)
        end
    end

    return command, arguments
end