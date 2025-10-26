txd = engineLoadTXD("files/cuff.txd")
dff = engineLoadDFF("files/cuff.dff")
engineImportTXD(txd, 331)
engineReplaceModel(dff, 331)