getJobTitleFromID = function(jobID)
	if (tonumber(jobID)==1) then
		return 'Oduncu'
	elseif (tonumber(jobID)==2) then
		return 'Çimento Şoförü'
	elseif (tonumber(jobID)==3) then
		return 'Çöpçü Şoförü'
	elseif (tonumber(jobID)==4) then
		return 'Temizlikçi'
	elseif (tonumber(jobID)==5) then
		return 'Kargo Paketlemeci'
	elseif (tonumber(jobID)==6) then
		return 'Uyuşturucu Kaçakcısı'
	elseif (tonumber(jobID)==7) then
		return 'Araç Mekanikçisi'
	else
		return 'İşsiz'
	end
end