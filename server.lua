--Benzinaio Base By PoLi

local fuelPrice = 3 -- prezzo del carburante al litro

function fuelVehicle(vehicle, player)
    local fuel = GetVehicleFuelLevel(vehicle)
    local money = GetPlayerMoney(player)
    local maxFuel = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fPetrolTankVolume') -- capacità massima del serbatoio
    local missingFuel = maxFuel - fuel
    local totalCost = fuelPrice * missingFuel

    if missingFuel > 0 and money >= totalCost then
        RemovePlayerMoney(player, totalCost)
        SetVehicleFuelLevel(vehicle, maxFuel)
        TriggerClientEvent('chat:addMessage', player, { args = { 'Benzinaio', 'Hai riempito il serbatoio con ' .. missingFuel .. ' litri di carburante per $' .. totalCost } })
    elseif missingFuel > 0 and money < totalCost then
        TriggerClientEvent('chat:addMessage', player, { args = { 'Benzinaio', 'Non hai abbastanza soldi per riempire il serbatoio' } })
    else
        TriggerClientEvent('chat:addMessage', player, { args = { 'Benzinaio', 'Il serbatoio è già pieno' } })
    end
end

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, 361) -- Imposta l'icona del blip come stazione di servizio
    SetBlipColour(blip, 5) -- Imposta il colore del blip
    SetBlipAsShortRange(blip, true) -- Imposta la distanza massima del blip
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Benzinaio") -- Imposta il nome del blip
    EndTextCommandSetBlipName(blip)
end)

RegisterServerEvent('fillFuelTank')
AddEventHandler('fillFuelTank', function()
    local player = source
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(player), false)

    if IsVehicleEngineOn(vehicle) then
        TriggerClientEvent('chat:addMessage', player, { args = { 'Benzinaio', 'Devi spegnere il motore per riempire il serbatoio' } })
    else
        fuelVehicle(vehicle, player)
    end
end)