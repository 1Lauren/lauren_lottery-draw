local QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback("lauren-lottery:server:GetLotterys", function(source, cb)
	local ticketS = {}
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `lotterys`", function(result)
		if result[1] ~= nil then
			for i,v in pairs(result) do
				local ticketData = {}
					 ticketData = {
						id = v.id,
						citizenid = v.citizenid,
						name = v.name,
						price = v.price,
						biletno = v.ticketnumber
					}
				table.insert(ticketS, ticketData)
			end
		end
			cb(ticketS)
    end)
end)

QBCore.Functions.CreateCallback("lauren-lottery:server:getMinMaxNumbers", function(source, cb)
    QBCore.Functions.ExecuteSql(false, "SELECT min(id) as minid, max(id) as maxid FROM `lotterys`", function(result)
		if result[1] ~= nil then
			cb(result[1].minid,result[1].maxid)
		end
    end)
end)

QBCore.Functions.CreateCallback("lauren-lottery:server:SelectWinner", function(source, cb,id)
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `lotterys` WHERE `id` = "..id.." ", function(result)
		if result[1] ~= nil then
			cb(result[1].ticketnumber)
		end
    end)
end)

QBCore.Functions.CreateCallback("lauren-lottery:server:GetTotalMoney", function(source, cb)
local totalmoney = nil
local totaltickets = nil
	QBCore.Functions.ExecuteSql(false, "SELECT SUM(`price`) AS price FROM `lotterys`", function(result)
		if result[1].price ~= nil then
			totalmoney = result[1].price
		else
			totalmoney = 0
		end
	end)
		QBCore.Functions.ExecuteSql(false, "SELECT COUNT(*) as count FROM `lotterys`", function(result2)
			if result2[1].count ~= nil then
				totaltickets = result2[1].count	
			else
				totaltickets = 0	
			end
		cb(totalmoney,totaltickets)
    end)
end)

RegisterNetEvent("lauren-lottery:server:reset:lottery")
AddEventHandler("lauren-lottery:server:reset:lottery", function()
    QBCore.Functions.ExecuteSql(false, "DELETE FROM `lotterys` ORDER BY id ASC ")
	TriggerClientEvent('QBCore:Notify', source, "Tüm bilet datası silindi!", "success")
end)

RegisterNetEvent("lauren-lottery:server:give:ticket")
AddEventHandler("lauren-lottery:server:give:ticket", function(itemName, ticketPrice, beginNumber,rewardName)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.RemoveMoney("cash", ticketPrice) then
		local ticketNumber = ""..beginNumber.."-"..math.random(100,999)..""..math.random(100,999)..""
		local info = {}
		info.ticketnumber = ticketNumber
		info.rewardname = rewardName
		TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'add')
		Player.Functions.AddItem(itemName, 1, false, info)
		local citizenid = Player.PlayerData.citizenid
		local name = ""..Player.PlayerData.charinfo.firstname.."_"..Player.PlayerData.charinfo.lastname..""
		QBCore.Functions.ExecuteSql(false, "INSERT INTO `lotterys` (`citizenid`, `name`, `ticketnumber`, `price`) VALUES ('"..citizenid.."', '"..name.."', '"..ticketNumber.."', '"..ticketPrice.."')")
	else
		TriggerClientEvent('QBCore:Notify', src, "Yeterli paran yok! "..ticketPrice.."$", "error")
	end
end)

RegisterNetEvent("lauren-lottery:server:trigger:client")
AddEventHandler("lauren-lottery:server:trigger:client", function(biletno,parametre)
	TriggerClientEvent('lauren-lottery:result', -1, biletno, parametre)
end)


RegisterNetEvent("lauren-lottery:server:trigger:open")
AddEventHandler("lauren-lottery:server:trigger:open", function()
	TriggerClientEvent('lauren-lottery:open:sell', -1)
end)

QBCore.Commands.Add("lottery", "Lottery Menu", {}, false, function(source, args)
	TriggerClientEvent('lauren-lottery:open:menu', source)
end, "admin")