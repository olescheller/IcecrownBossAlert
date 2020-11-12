local frame = CreateFrame("FRAME");
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("VIGNETTES_UPDATED");

local vignetteUpdatedCounter = 0;
local lastVignetteUpdate = 0;
local spawnTime = 0;
local timeToBeAttackable = 120 - 3; -- alert up to 3 seconds earlier
local hasAnnouncedAttackble = false;
local isBossVignetteUp = false;

function frame:OnEvent(event, arg1, arg2) 
    local vignetteGUIDs = {};

    if event == "ADDON_LOADED" and arg1 == "IcecrownBossAlert" then
        print("IcecrownBossAlert loaded.");

    elseif (event == "VIGNETTES_UPDATED") then -- check zone
        vignetteGUIDs = C_VignetteInfo.GetVignettes()

        for i,v in pairs(vignetteGUIDs) do 
            vignetteInfo = C_VignetteInfo.GetVignetteInfo(v)
            print("debug: " ..  vignetteInfo.vignetteID)

            if vignetteInfo.vignetteID ~= 4194 then
                isBossVignetteUp = true;
            end
        end

        if not isBossVignetteUp then
            return;
        end

        -- Reset counter and timer variables on new boss
        if lastVignetteUpdate + 60 < GetTime() then
            hasAnnouncedAttackble = false;
            vignetteUpdatedCqqqounter = 0;
            isBossVignetteUp = false;
        end
   
        -- Play spawn sound on second vignette update. The first one might be just the removal of an old vignette from another session
        if vignetteUpdatedCounter == 1 then
            PlaySoundFile("Interface\\AddOns\\IcecrownBossAlert\\boss_spawned.ogg", "Master");
            spawnTime = GetTime();        
        end

        if vignetteUpdatedCounter > 1 and not hasAnnouncedAttackble and spawnTime + timeToBeAttackable < GetTime() then
            hasAnnouncedAttackble = true;
            PlaySoundFile("Interface\\AddOns\\IcecrownBossAlert\\boss_attackable.ogg", "Master")

        end

        vignetteUpdatedCounter = vignetteUpdatedCounter + 1
        lastVignetteUpdate = GetTime();

        print("debug: " .. vignetteUpdatedCounter)
        print("debug: " .. lastVignetteUpdate)
    end
end

-- 521308
-- 521428

frame:SetScript("OnEvent", frame.OnEvent);