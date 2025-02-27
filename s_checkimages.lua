local function CheckMissingItemImages()
    local missingImages = {}
    local itemCount = 0
    local missingCount = 0
    
    local items = exports.ox_inventory:Items()
    local imagePath = GetResourcePath('ox_inventory') .. '/web/images/'
    
    for name, item in pairs(items) do
        itemCount = itemCount + 1
        
        local imageFile = imagePath .. name .. '.png'
        local f = io.open(imageFile, 'r')
        
        if not f then
            imageFile = imagePath .. name .. '.jpg'
            f = io.open(imageFile, 'r')
            
            if not f then
                table.insert(missingImages, name)
                missingCount = missingCount + 1
            else
                f:close()
            end
        else
            f:close()
        end
    end
    
    return missingImages, itemCount, missingCount
end

lib.addCommand('checkmissingimages', {
    help = 'Check for missing inventory item images',
    restricted = 'admin'
}, function(source, args, raw)
    local missingImages, totalItems, missingCount = CheckMissingItemImages()
    
    if missingCount > 0 then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Missing Images Check',
            description = 'Found ' .. missingCount .. ' items missing images out of ' .. totalItems .. ' total items',
            type = 'error',
            position = 'top',
            duration = 5000
        })
        
        print('^1[Missing Images Check] Found ' .. missingCount .. ' items missing images out of ' .. totalItems .. ' total items^7')
        
        for i, itemName in ipairs(missingImages) do
            if i % 10 == 1 then
                local batch = {}
                for j = i, math.min(i + 9, #missingImages) do
                    table.insert(batch, missingImages[j])
                end
                TriggerClientEvent('chat:addMessage', source, {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {'Missing Images', table.concat(batch, ', ')}
                })
            end
            
            print('^3Missing image for item: ^7' .. itemName)
        end
        
        local timestamp = os.date('%Y-%m-%d_%H-%M-%S')
        local logFile = GetResourcePath(GetCurrentResourceName()) .. '/missing_images_' .. timestamp .. '.txt'
        local file = io.open(logFile, 'w')
        
        if file then
            file:write('Missing Item Images Report - ' .. os.date('%Y-%m-%d %H:%M:%S') .. '\n\n')
            file:write('Total Items: ' .. totalItems .. '\n')
            file:write('Missing Images: ' .. missingCount .. '\n\n')
            file:write('--- Missing Item List ---\n')
            
            for _, itemName in ipairs(missingImages) do
                file:write(itemName .. '\n')
            end
            
            file:close()
            
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Report Saved',
                description = 'Missing images report saved to server resources folder',
                type = 'inform',
                position = 'top',
                duration = 5000
            })
        end
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Missing Images Check',
            description = 'All ' .. totalItems .. ' items have images!',
            type = 'success',
            position = 'top',
            duration = 5000
        })
        
        print('^2[Missing Images Check] All ' .. totalItems .. ' items have images!^7')
    end
end)

print('^2[Missing Images Check] Command registered: /checkmissingimages^7')