self = {}

function self:constructor()
    self.regions = {}
    self.jobEntryZones = {
        {1, 'Dolmus Mesleği', 1751.6904296875, -1899.9541015625, 13.557600021362}, --yapıldı
        {2, 'Çimento Mesleği', 2136.0068359375, -2102.6865234375, 13.554370880127},
        {3, 'Çöpçülük Mesleği', 2195.7021484375, -1969.9404296875, 13.78413105011}, --yapıldı
        {4, 'Temizlikçi Mesleği', 2048.7177734375, -1900.2548828125, 13.553800582886}, --yapıldı
        {5, 'Kargo Paketleme Mesleği', 2748.654296875, -2454.4111328125, 13.86225605011},
        {6, 'Şarap Taşıma Mesleği', 2568.5693359375, -2425.8095703125, 13.63266658783}, --yapıldı
        --{7, 'Mekanik Mesleği', 617.4404296875, -1522.830078125, 15.110894203186},
	}
    for index, value in ipairs(self.jobEntryZones) do
        self.pickup = Pickup(value[3], value[4], value[5], 3, 1314)
        self.pickup:setData('informationicon:information', '#FFDB86/meslekgir#ffffff\n'..value[2]..'')
        local i = #self.regions + 1
		if not self.regions[i] then
			self.regions[i] = {}
		end
		self.regions[i][1] = ColShape.Sphere(value[3], value[4], value[5], 1.5)
        self.regions[i][2] = value[1]
        self.regions[i][3] = value[2]
    end

    addEventHandler('onPickupHit', root, self.cancelPickup)

    addEventHandler('onVehicleStartEnter', getRootElement(), function(player, seat, jacked)
        if seat == 0 then
            if source:getData('job') > 0 then
                if source:getData('job') == player:getData('job') then else
                    player:outputChat('►#D0D0D0 Meslek aracına binebilmek için mesleğe giriş yapmalısınız.',195,184,116,true)
                    cancelEvent()
                end
            end
        end
    end)

    addCommandHandler('meslekgir', function(player, command) 
        if player:getData('loggedin') == 1 then
            for index, value in ipairs(self.regions) do
                if player:isWithinColShape(value[1]) then
                    if player:getData('job') <= 0 then
                        if value[2] == 7 then
                            player:outputChat('►#D0D0D0 Bu mesleğe giriş kapalıdır.',195,184,116,true)
                        else
                            player:setData('job', tonumber(value[2]))
                            dbExec(exports.rl_mysql:getConn(), "UPDATE `characters` SET `job`='"..value[2].."' WHERE id='" ..(player:getData('dbid')).. "' LIMIT 1")
                            player:outputChat('►#D0D0D0 Başarıyla giriş yaptınız: '..value[3]..'.',195,184,116,true)
                        end
                    else
                        player:outputChat('►#D0D0D0 Şu anda başka bir meslektesiniz, bulunduğunuz meslekten çıkmak için /meslekayril',195,184,116,true)
                    end
                end
            end
        end
    end)

    addCommandHandler('meslekayril', function(player, command) 
        if player:getData('loggedin') == 1 then
            player:setData('job', tonumber(0))
            dbExec(exports.rl_mysql:getConn(), "UPDATE `characters` SET `job`='0' WHERE id='" ..(player:getData('dbid')).. "' LIMIT 1")
            player:outputChat('►#D0D0D0 Bulunduğunuz meslekten başarıyla ayırldınız.',195,184,116,true)
        end
    end)

    local list = function(player, command)
        self = self;
        if player:getData('loggedin') == 1 then
            player:outputChat('►#D0D0D0 Meslekler listeleniyor:',195,184,116,true)
            for index, value in ipairs(self.jobEntryZones) do
                player:outputChat('►#D0D0D0 "'..value[2]..'" ID: '..value[1],195,184,116,true)
            end
        end
    end
    addCommandHandler('jobs', list)
    addCommandHandler('joblist', list)
    addCommandHandler('meslekler', list)

    local setJob = function(thePlayer, command, targetPlayer, jobID)
        if exports.rl_integration:isPlayerSupporter(thePlayer) or exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
            if targetPlayer and tonumber(jobID) then
                local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
                if targetPlayer then
                    targetPlayer:setData('job', tonumber(jobID))
                    dbExec(exports.rl_mysql:getConn(), "UPDATE `characters` SET `job`='"..jobID.."' WHERE id='" ..(targetPlayer:getData('dbid')).. "' LIMIT 1")
                    thePlayer:outputChat('►#D0D0D0 '..targetPlayer.name..' isimli oyuncunun mesleğini '..jobID..' olarak değiştirdiniz.',195,184,116,true)
                    targetPlayer:outputChat('►#D0D0D0 '..thePlayer.name..' isimli yetkili mesleğinizi '..jobID..' olarak değiştirdi.',195,184,116,true)
                end
            else
                thePlayer:outputChat('►#D0D0D0 /'..command..' [ID/Partial Nick] [JobID]',195,184,116,true)
            end
        end
    end
    addCommandHandler('setjob', setJob)

    addEventHandler("onVehicleExit", getRootElement(), function(thePlayer, seat)
        if thePlayer and source then
            if seat == 0 then
                if source:getData('job') > 0 then
                    if source:getData('job') == 1 then return false end
                    respawnVehicle(source)
                end
            end
        end
    end)
	
	addEvent('job.givemoney', true)
	addEventHandler('job.givemoney', root, function(price)
		if source and tonumber(price) then
			cash = price
			if source:getData('vip') == 4 then
				cash = price + 100
			elseif source:getData('vip') == 3 then
				cash = price + 75
			elseif source:getData('vip') == 2 then
				cash = price + 50
			elseif source:getData('vip') == 1 then
				cash = price + 25
			end
            exports.rl_global:giveMoney(source, cash)
			source:outputChat('►#D0D0D0 Bu meslek turundan '..cash..'$ para kazandınız.',195,184,116,true)
		end
	end)
end

function self:cancelPickup()
    cancelEvent()
end

self:constructor()