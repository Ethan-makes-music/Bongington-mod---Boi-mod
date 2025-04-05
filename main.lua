local mod = RegisterMod("Bongington Mod", 1)
local bongington = Isaac.GetItemIdByName("Bongington")

local EFFECT_VARIANT_MIST = 9876
local mistDuration = 150
local mistDPS = 10 / 30

function mod:BongButtonUse(item, rng, player)
    local direction = player:GetAimDirection()
    if direction:Length() == 0 then
        direction = player:GetLastDirection()
    end

    local spawnPos = player.Position + direction:Resized(40)

    local mist = Isaac.Spawn(EntityType.ENTITY_EFFECT, EFFECT_VARIANT_MIST, 0, spawnPos, Vector(0, 0), player)
    mist:GetSprite():Load("bong_smoke_effect.anm2", true)
    mist:GetSprite():Play("BongSmokeEffect", true)

    local data = mist:GetData()
    data.life = mistDuration
    data.owner = player

    return 
    {
        Discharged = true,
        Remove = false,
        ShowAnim = true
    }
end

function mod:UpdateMist(effect)
    if effect.Variant ~= EFFECT_VARIANT_MIST then return end
    local data = effect:GetData()
    if not data.life then return end

    data.life = data.life - 1

    local enemies = Isaac.FindInRadius(effect.Position, 60, EntityPartition.ENEMY)
    for _, enemy in ipairs(enemies) do
        if enemy:IsVulnerableEnemy() and not enemy:IsDead() then
            enemy:TakeDamage(mistDPS, DamageFlag.DAMAGE_POISON_BURN, EntityRef(data.owner), 0)
        end
    end

    if data.life <= 0 then
        effect:Remove()
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.BongButtonUse, bongington)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.UpdateMist, EFFECT_VARIANT_MIST)