local socials

local function announceSocialMediaAccounts()
    if not localPlayer:getData("logged") then
        return false
    end

    if not socials then
        socials = {
            { key = "discord", header = "Discord Sunucumuz", url = ("Toplulukla buluşmak için %s\nsunucumuza katılın!\nBuraya tıklayarak kopyalayın."):format("discord.gg/Revalroleplay"), value = "https://discord.gg/Revalroleplay" },
            { key = "youtube", header = "Youtube Kanalımız", url = ("Sistem tanıtımlarından anında haberdar olmak için %s\nKanalımıza abone olun!\nBuraya tıklayarak kopyalayın."):format("https://www.youtube.com/@Revalroleplay00"), value = "https://www.youtube.com/@Revalroleplay" }
		}
    end

    local social = socials[math.random(1, #socials)]
    addBox(social.key, { header = social.header, message = social.url }, 15000, "bottom-center", social.value)
end
setTimer(announceSocialMediaAccounts, 1000 * 60 * 10, 0)

function announceSocialMediaWarn()
    if exports.rl_integration:isPlayerDeveloper(localPlayer) then
        announceSocialMediaAccounts()
    end
end
addCommandHandler("duyuruyap", announceSocialMediaWarn, false, false)