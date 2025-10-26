function startBook(id, slot)
	if client ~= source then
		return
	end
	
	if not tonumber(id) then 
		return
	end
	
	dbQuery(function(qh, client)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do
				if row then
					triggerClientEvent(client, "PlayerBook", client, row.title, row.author, row.book, row.readOnly, slot, id)
				else
					triggerClientEvent(client, "PlayerBook", client, false, false, "Error")
				end
			end
		end
	end, {client}, mysql:getConnection(), "SELECT title, author, book, readOnly FROM books WHERE id = ?", id)
end
addEvent("books:beginBook", true)
addEventHandler("books:beginBook", root, startBook)

function setData(id, title, author, book, readOnly)
	if client ~= source then
		return
	end
	
	if not tonumber(id) then
		return
	end

	if readOnly then
		readOnly = 1
	else
		readOnly = 0
	end
	
	if readOnly == 1 then
		triggerEvent("sendAme", client, "closes " ..  title .. " and clicks his pen.")
	end
	
	dbExec(mysql:getConnection(), "UPDATE books SET title = ?, author = ?, book = ?, readOnly = ? WHERE id = ?", title, author, book, readOnly, id)
end
addEvent("books:setData", true)
addEventHandler("books:setData", root, setData)