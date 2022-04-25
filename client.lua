QBCore = nil
local totalTicket = 0

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)
 
Citizen.CreateThread(function()
	local hash = GetHashKey(Config.NPCHash)
	RequestModel(hash)
	while not HasModelLoaded(hash) do
		Wait(1)
	end
	local ped = CreatePed(2, hash, Config.Locations['Sell']['X'], Config.Locations['Sell']['Y'], Config.Locations['Sell']['Z']- 1, Config.Locations['Sell']['H'], false, true)
	FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
	SetModelAsNoLongerNeeded(hash)
	createBlip()
end)

CreateThread(function()
	while true do
      Citizen.Wait(3)
        local pos = GetEntityCoords(PlayerPedId())
		if Config.OpenSellTicket then
			if (GetDistanceBetweenCoords(pos.x,pos.y,pos.z, Config.Locations['Sell']['X'], Config.Locations['Sell']['Y'], Config.Locations['Sell']['Z'], true)  < 3.0) then
					DrawText3D(Config.Locations['Sell']['X'], Config.Locations['Sell']['Y'], Config.Locations['Sell']['Z'], '~g~[E]~s~ - Buy Ticket')
				if IsControlJustPressed(0, 38) then
					TriggerServerEvent("lauren-lottery:server:give:ticket", Config.ItemName, Config.TicketPrice, Config.TicketBeginNumber,Config.RewardName)
				end
			end
		end
    end
end)

RegisterNetEvent("lauren-lottery:info")
AddEventHandler("lauren-lottery:info" , function(parameter)
     QBCore.Functions.Notify(parameter,"success")
end)

RegisterNetEvent("lauren-lottery:open:trigger")
AddEventHandler("lauren-lottery:open:trigger" , function(parameter)
	TriggerServerEvent("lauren-lottery:server:trigger:open")
end)

RegisterNetEvent("lauren-lottery:open:sell")
AddEventHandler("lauren-lottery:open:sell" , function()
	Config.OpenSellTicket = not Config.OpenSellTicket
end)

RegisterNetEvent("lauren-lottery:reset")
AddEventHandler("lauren-lottery:reset" , function(parameter) 
	if totalTicket >= 1 then
		TriggerServerEvent("lauren-lottery:server:reset:lottery")
	else
		QBCore.Functions.Notify("It's already reset!", "error")
	end
end)

RegisterNetEvent("lauren-lottery:start")
AddEventHandler("lauren-lottery:start" , function(parameter) 
	if totalTicket >= 1 then
		QBCore.Functions.TriggerCallback('lauren-lottery:server:getMinMaxNumbers', function(minN,maxN)
			local randombiletno = math.random(minN, maxN)
			TriggerServerEvent("lauren-lottery:server:trigger:client",randombiletno,parameter)
		end)
	else
		QBCore.Functions.Notify("What are you going to shoot for the tickets that don't exist?!", "error")
	end
end)

RegisterNetEvent("lauren-lottery:result")
AddEventHandler("lauren-lottery:result", function(randombiletno,parameter)  
	if parameter == "Alternate" then
		QBCore.Functions.Notify("All Tickets shuffled.. The Alternate winner is announced!","success")
	else
		QBCore.Functions.Notify("All Tickets shuffled.. The Real winner is announced.","success")
	end
		Citizen.Wait(3000)
		QBCore.Functions.Notify(""..parameter.." Explanation of the ticket number 3 seconds...","success")
		TriggerServerEvent("InteractSound_SV:PlayOnAll", "second", 0.8)
		Citizen.Wait(2000)
		QBCore.Functions.Notify(""..parameter.." Explanation of the ticket number 2 seconds...","success")
		TriggerServerEvent("InteractSound_SV:PlayOnAll", "second", 0.8)
		Citizen.Wait(2000)
		QBCore.Functions.Notify(""..parameter.." Explanation of the ticket number 1 seconds...","success")
		TriggerServerEvent("InteractSound_SV:PlayOnAll", "second", 0.8)
		Citizen.Wait(3000)  
		
	QBCore.Functions.TriggerCallback('lauren-lottery:server:SelectWinner', function(biletno)
		QBCore.Functions.Notify("Lottery " ..biletno .." numbered "..parameter.." out the ticket.","success")
	end, randombiletno)
end)
 
RegisterNetEvent("lauren-lottery:open:menu")
AddEventHandler("lauren-lottery:open:menu",function()
	QBCore.Functions.TriggerCallback('lauren-lottery:server:GetTotalMoney', function(totalmoney,totaltickets)
	if totalmoney == nil then
		totalmoney = 0
	else
		totalmoney = totalmoney
	end
	QBCore.Functions.TriggerCallback('lauren-lottery:server:GetLotterys', function(ticketS)
		totalTicket = totaltickets
		exports['qb-menu']:SetTitle("Lottery Menu")
		exports['qb-menu']:AddButton("Total Tickets Sold" , ""..totaltickets.." Pieces" ,'lottery:info' ,""..totaltickets.." Pieces" , "totaltickets" )
		exports['qb-menu']:AddButton("Total Missing Money" , ""..totalmoney.."$" ,'lottery:info' ,""..totalmoney.."$" , "totaltickets" )
		for i, v in pairs(ticketS) do
			exports['qb-menu']:AddButton(v.name , v.biletno ,"lauren-lottery:info" ,""..v.name.."-"..v.biletno.."", 'taketicket')
		end
		exports['qb-menu']:AddButton("Pull the lucky number" , "Start Lottery" ,"lauren-lottery:start" ,"", 'lotteryme')
		exports['qb-menu']:AddButton("Attract Backup Winner" , "Alternate winner" ,"lauren-lottery:start" ,"Alternate", 'lotteryme')
		exports['qb-menu']:AddButton("Close/Open Ticket Sale" , "Close Buy Ticket" ,"lauren-lottery:open:trigger" ,"", 'lotteryme')
		exports['qb-menu']:AddButton("Reset" , "Reset Lottery" ,"lauren-lottery:reset" ,"", 'lotteryme')
		
		exports['qb-menu']:SubMenu("Lottery Status" , "Lottery Status" , "totaltickets" )
		exports['qb-menu']:SubMenu("Ticket Buyers" , "Ticket Buyers" , "taketicket" )
		exports['qb-menu']:SubMenu("Lottery Settings" , "Draw start/reset etc" , "lotteryme" )
		end)
	end)
end)

function createBlip()
	if Config.OpenBlip then
	npcBlip = AddBlipForCoord(Config.Locations['Sell']['X'], Config.Locations['Sell']['Y'], Config.Locations['Sell']['Z'])
		SetBlipSprite (npcBlip, 388)
		SetBlipDisplay(npcBlip, 4)
		SetBlipScale  (npcBlip, 0.8)
		SetBlipAsShortRange(npcBlip, true)
		SetBlipColour(npcBlip, 2)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName("Ticket Seller")
		EndTextCommandSetBlipName(npcBlip)        
	end
end


DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z+0.1, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    ClearDrawOrigin()
end