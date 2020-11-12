local frame = CreateFrame("FRAME");
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("VIGNETTES_UPDATED");

local ICECROWN_MAP_ID = 118
local SEDONDS_UNTIL_BOSS_IS_ATTACKABLE = 120 - 3; -- alert up to 3 seconds earlier

local vignetteUpdatedCounter = 0;
local lastBossVignetteUpdate = 0;
local spawnTime = 0;
local hasAnnouncedAttackble = false;
local isBossVignetteUp = false;

function frame:OnEvent(event, arg1, arg2) 
    if event == "ADDON_LOADED" and arg1 == "IcecrownBossAlert" then
        -- print("IcecrownBossAlert loaded.");
    end

    if (event == "VIGNETTES_UPDATED") then -- check zone

        if C_Map.GetBestMapForUnit("player") ~= ICECROWN_MAP_ID then
            -- Don't do anything if player is not in Icecrown
            return;
        end

        for i,v in pairs(C_VignetteInfo.GetVignettes()) do 
            -- check if vignette is different from Bonfire
            if C_VignetteInfo.GetVignetteInfo(v).vignetteID ~= 4194 then 
                isBossVignetteUp = true;
            end
        end

        if not isBossVignetteUp then
            return;
        end

        -- Reset counter and timer variables on new boss
        if lastBossVignetteUpdate + 60 < GetTime() then
            hasAnnouncedAttackble = false;
            vignetteUpdatedCounter = 0;
            isBossVignetteUp = false;
        end
   
        -- Play spawn sound on second vignette update. The first one might be just the removal of an old vignette from another session
        if vignetteUpdatedCounter == 1 then
            PlaySoundFile("Interface\\AddOns\\IcecrownBossAlert\\boss_spawned.ogg", "Master");
            spawnTime = GetTime();        
        end

        if vignetteUpdatedCounter > 1 and not hasAnnouncedAttackble and spawnTime + SEDONDS_UNTIL_BOSS_IS_ATTACKABLE < GetTime() then
            hasAnnouncedAttackble = true;
            PlaySoundFile("Interface\\AddOns\\IcecrownBossAlert\\boss_attackable.ogg", "Master")

        end

        vignetteUpdatedCounter = vignetteUpdatedCounter + 1
        lastBossVignetteUpdate = GetTime();
        -- print("debug: " .. vignetteUpdatedCounter)
        -- print("debug: " .. lastBossVignetteUpdate)
    end
end

frame:SetScript("OnEvent", frame.OnEvent);