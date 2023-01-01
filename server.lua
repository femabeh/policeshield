ESX = nil

ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterUsableItem(Config.Item, function()
  TriggerClientEvent('policeshield:shield')
end)

ESX.RegisterServerCallback('policeshield:getItemAmount', function(source, cb, item)
  local xPlayer = ESX.GetPlayerFromId(source)
  local qtty = xPlayer.getInventoryItem(item).count
  cb(qtty)
end)
