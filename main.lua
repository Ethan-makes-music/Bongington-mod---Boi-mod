local mod = RegisterMod("Bongington Mod", 1)

local bongington = Isaac.GetItemIdByName("Bongington")

function mod:BongButtonUse(item)
    local roomEntities = Isaac.GetRoomEntities()
    for _, entity in ipairs(roomEntities) do
        if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() then
            entity:Kill()
        end
    end

    return
    {
        Discharged = true,
        Remove = false,
        ShowAnim = true
    }
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.BongButtonUse, bongington)