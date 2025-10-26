info = { 
    ["public/models/wheel_gn1.dff"] = 1082,
    ["public/models/wheel_gn2.dff"] = 1085,
    ["public/models/wheel_gn3.dff"] = 1096,
    ["public/models/wheel_gn4.dff"] = 1097,
    ["public/models/wheel_gn5.dff"] = 1098,
    ["public/models/wheel_lr1.dff"] = 1077,
    ["public/models/wheel_lr2.dff"] = 1083,
    ["public/models/wheel_lr3.dff"] = 1078,
    ["public/models/wheel_lr4.dff"] = 1076,
    ["public/models/wheel_lr5.dff"] = 1084,
    ["public/models/wheel_or1.dff"] = 1025,
    ["public/models/wheel_sr1.dff"] = 1079,
    ["public/models/wheel_sr2.dff"] = 1075,
    ["public/models/wheel_sr3.dff"] = 1074,
    ["public/models/wheel_sr4.dff"] = 1081,
    ["public/models/wheel_sr5.dff"] = 1080,
    ["public/models/wheel_sr6.dff"] = 1073,
}

addEventHandler("onClientResourceStart", resourceRoot, function()
    for k, v in pairs(info) do
        downloadFile(k)
    end
end)

addEventHandler("onClientFileDownloadComplete", resourceRoot, function(file, success)
    if success then
		txd = engineLoadTXD("public/models/J2_wheels.txd", info[file])
		engineImportTXD(txd, info[file])
        dff = engineLoadDFF(file, info[file])
        engineReplaceModel(dff, info[file])
    end
end)