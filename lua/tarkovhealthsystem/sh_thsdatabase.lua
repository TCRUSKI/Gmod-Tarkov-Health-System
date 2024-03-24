if SERVER then 
    FLAG_ENABLED = true


    hook.Add("Initialize", "Alexi_Tarkov_Health_System_Init", function()
        CreateHealthTable()
    end)
    hook.Add("PlayerInitialSpawn", "Alexi_Tarkov_Health_System_Player_Init", function(player)
        AddToHealthTable(player)
    end)
    hook.Add("PlayerSpawn", "Alexi_Tarkov_Health_Player_Spawn", function(player)
        ResetHealth(player)
    end)
    hook.Add( "EntityTakeDamage", "Alexi_Tarkov_Health_Take_Damage", function( target, dmginfo )
        if(FLAG_ENABLED && target:IsPlayer() && dmginfo:GetDamageType() != DMG_BULLET && dmginfo:GetDamageType() != DMG_FALL) then
            local health = getHealth(target)
            local damage = math.floor((dmginfo:GetDamage() * 4.4) + 0.5)
            local healthLeft = health - damage
            healthLeft = math.floor(healthLeft + 0.5)
            if(healthLeft <= 0) then
                dmginfo:SetDamage(10000000000000)
            else
                takeRemainderDamage(target, damage)
                target:SetHealth(getHealth(target))
                dmginfo:SetDamage(-(target:Health() - getHealth(target)))
                if(tonumber(sql.QueryValue("SELECT Head FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(target:SteamID()) .. ";")) <= 0 || tonumber(sql.QueryValue("SELECT Torso FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(target:SteamID()) .. ";")) <= 0) then
                    dmginfo:SetDamage(10000000000000)
                end
            end
        elseif(target:IsPlayer() && dmginfo:GetDamageType() == DMG_FALL) then
            damageLegs(target, dmginfo:GetDamage())
            target:SetHealth(getHealth(target))
            dmginfo:SetDamage(-(target:Health() - getHealth(target)))
            if(tonumber(sql.QueryValue("SELECT Head FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(target:SteamID()) .. ";")) <= 0 || tonumber(sql.QueryValue("SELECT Torso FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(target:SteamID()) .. ";")) <= 0) then
                dmginfo:SetDamage(10000000000000)
            end
        end
    end )
    hook.Add( "ScalePlayerDamage", "Alexi_Tarkov_Health_Take_Damage_Bullet", function( ply, hitgroup, dmginfo)
        if( hitgroup == HITGROUP_HEAD) then
            local headHealth = tonumber(sql.QueryValue("SELECT Head FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";"))
            headHealth = headHealth - dmginfo:GetDamage()
            headHealth = math.floor(headHealth + 0.5)
            if(headHealth <= 0) then
                dmginfo:SetDamage(10000000000000)
            else
                sql.Query("UPDATE alexi_tarkov_health_system_table SET Head = " .. headHealth .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
                ply:SetHealth(getHealth(ply))
                dmginfo:SetDamage(-(ply:Health() - getHealth(ply)))
            end
        elseif( hitgroup == HITGROUP_CHEST) then
            local torsoHealth = tonumber(sql.QueryValue("SELECT Torso FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";"))
            torsoHealth = torsoHealth - dmginfo:GetDamage()
            torsoHealth = math.floor(torsoHealth + 0.5)
            if(torsoHealth <= 0) then
                dmginfo:SetDamage(10000000000000)
            else
                sql.Query("UPDATE alexi_tarkov_health_system_table SET Torso = " .. torsoHealth .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
                ply:SetHealth(getHealth(ply))
                dmginfo:SetDamage(-(ply:Health() - getHealth(ply)))
            end
        elseif( hitgroup == HITGROUP_STOMACH) then
            local stomachHealth = tonumber(sql.QueryValue("SELECT Stomach FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";"))
            stomachHealth = stomachHealth - dmginfo:GetDamage()
            stomachHealth = math.floor(stomachHealth + 0.5)
            if(stomachHealth <= 0) then
                sql.Query("UPDATE alexi_tarkov_health_system_table SET Stomach = " .. 0 .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
                local remainingHealth = stomachHealth * -1
                takeRemainderDamage(ply, remainingHealth)
                ply:SetHealth(getHealth(ply))
                dmginfo:SetDamage(-(ply:Health() - getHealth(ply)))
                if(tonumber(sql.QueryValue("SELECT Head FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) <= 0 || tonumber(sql.QueryValue("SELECT Torso FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) <= 0) then
                    dmginfo:SetDamage(10000000000000)
                end
            else
                sql.Query("UPDATE alexi_tarkov_health_system_table SET Stomach = " .. stomachHealth .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
                ply:SetHealth(getHealth(ply))
                dmginfo:SetDamage(-(ply:Health() - getHealth(ply)))
            end
        elseif( hitgroup == HITGROUP_LEFTARM) then
            local Left_ArmHealth = tonumber(sql.QueryValue("SELECT Left_Arm FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";"))
            Left_ArmHealth = Left_ArmHealth - dmginfo:GetDamage()
            Left_ArmHealth = math.floor(Left_ArmHealth + 0.5)
            if(Left_ArmHealth <= 0) then
                sql.Query("UPDATE alexi_tarkov_health_system_table SET Left_Arm = " .. 0 .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
                local remainingHealth = Left_ArmHealth * -1
                takeRemainderDamage(ply, remainingHealth)
                ply:SetHealth(getHealth(ply))
                dmginfo:SetDamage(-(ply:Health() - getHealth(ply)))
                if(tonumber(sql.QueryValue("SELECT Head FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) <= 0 || tonumber(sql.QueryValue("SELECT Torso FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) <= 0) then
                    dmginfo:SetDamage(10000000000000)
                end
            else
                sql.Query("UPDATE alexi_tarkov_health_system_table SET Left_Arm = " .. Left_ArmHealth .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
                ply:SetHealth(getHealth(ply))
                dmginfo:SetDamage(-(ply:Health() - getHealth(ply)))
            end
        elseif( hitgroup == HITGROUP_RIGHTARM) then
            local Right_ArmHealth = tonumber(sql.QueryValue("SELECT Right_Arm FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";"))
            Right_ArmHealth = Right_ArmHealth - dmginfo:GetDamage()
            Right_ArmHealth = math.floor(Right_ArmHealth + 0.5)
            if(Right_ArmHealth <= 0) then
                sql.Query("UPDATE alexi_tarkov_health_system_table SET Right_Arm = " .. 0 .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
                local remainingHealth = Right_ArmHealth * -1
                takeRemainderDamage(ply, remainingHealth)
                ply:SetHealth(getHealth(ply))
                dmginfo:SetDamage(-(ply:Health() - getHealth(ply)))
                if(tonumber(sql.QueryValue("SELECT Head FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) <= 0 || tonumber(sql.QueryValue("SELECT Torso FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) <= 0) then
                    dmginfo:SetDamage(10000000000000)
                end
            else
                sql.Query("UPDATE alexi_tarkov_health_system_table SET Right_Arm = " .. Right_ArmHealth .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
                ply:SetHealth(getHealth(ply))
                dmginfo:SetDamage(-(ply:Health() - getHealth(ply)))
            end
        elseif( hitgroup == HITGROUP_LEFTLEG) then
            local Left_LegHealth = tonumber(sql.QueryValue("SELECT Left_Leg FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";"))
            Left_LegHealth = Left_LegHealth - dmginfo:GetDamage()
            Left_LegHealth = math.floor(Left_LegHealth + 0.5)
            if(Left_LegHealth <= 0) then
                sql.Query("UPDATE alexi_tarkov_health_system_table SET Left_Leg = " .. 0 .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
                local remainingHealth = Left_LegHealth * -1
                takeRemainderDamage(ply, remainingHealth)
                ply:SetHealth(getHealth(ply))
                dmginfo:SetDamage(-(ply:Health() - getHealth(ply)))
                if(tonumber(sql.QueryValue("SELECT Head FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) <= 0 || tonumber(sql.QueryValue("SELECT Torso FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) <= 0) then
                    dmginfo:SetDamage(10000000000000)
                end
            else
                sql.Query("UPDATE alexi_tarkov_health_system_table SET Left_Leg = " .. Left_LegHealth .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
                ply:SetHealth(getHealth(ply))
                dmginfo:SetDamage(-(ply:Health() - getHealth(ply)))
            end
        elseif( hitgroup == HITGROUP_RIGHTLEG) then
            local Right_LegHealth = tonumber(sql.QueryValue("SELECT Right_Leg FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";"))
            Right_LegHealth = Right_LegHealth - dmginfo:GetDamage()
            Right_LegHealth = math.floor(Right_LegHealth + 0.5)
            if(Right_LegHealth <= 0) then
                sql.Query("UPDATE alexi_tarkov_health_system_table SET Right_Leg = " .. 0 .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
                local remainingHealth = Right_LegHealth * -1
                takeRemainderDamage(ply, remainingHealth)
                ply:SetHealth(getHealth(ply))
                dmginfo:SetDamage(-(ply:Health() - getHealth(ply)))
                if(tonumber(sql.QueryValue("SELECT Head FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) <= 0 || tonumber(sql.QueryValue("SELECT Torso FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) <= 0) then
                    dmginfo:SetDamage(10000000000000)
                end
            else
                sql.Query("UPDATE alexi_tarkov_health_system_table SET Right_Leg = " .. Right_LegHealth .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
                ply:SetHealth(getHealth(ply))
                dmginfo:SetDamage(-(ply:Health() - getHealth(ply)))
            end
        end
    
    end)
end

function takeRemainderDamage(ply, damage)
    local totalLimbs = 0
    local headHealth = tonumber(sql.QueryValue("SELECT Head FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";"))
    local torsoHealth = tonumber(sql.QueryValue("SELECT Torso FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) 
    local Left_ArmHealth = tonumber(sql.QueryValue("SELECT Left_Arm FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) 
    local Right_ArmHealth = tonumber(sql.QueryValue("SELECT Right_Arm FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) 
    local StomachHealth = tonumber(sql.QueryValue("SELECT Stomach FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) 
    local Left_LegHealth = tonumber(sql.QueryValue("SELECT Left_Leg FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) 
    local Right_LegHealth = tonumber(sql.QueryValue("SELECT Right_Leg FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) 
    if(headHealth > 0) then totalLimbs = totalLimbs + 1 end
    if(torsoHealth > 0) then totalLimbs = totalLimbs + 1 end
    if(Left_ArmHealth > 0) then totalLimbs = totalLimbs + 1 end
    if(Right_ArmHealth > 0) then totalLimbs = totalLimbs + 1 end
    if(StomachHealth > 0) then totalLimbs = totalLimbs + 1 end
    if(Left_LegHealth > 0) then totalLimbs = totalLimbs + 1 end
    if(Right_LegHealth > 0) then totalLimbs = totalLimbs + 1 end

    local remainingDamage = damage / totalLimbs
    remainingDamage = math.floor(remainingDamage + 0.5)
    if(headHealth > 0) then
        headHealth = headHealth - remainingDamage
        if(headHealth <= 0)then
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Head = " .. 0 .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
            takeRemainderDamage(ply, headHealth * -1)
        else
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Head = " .. headHealth .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
        end
    end
    if(torsoHealth > 0) then
        torsoHealth = torsoHealth - remainingDamage
        if(torsoHealth <= 0)then
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Torso = " .. 0 .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
            takeRemainderDamage(ply, torsoHealth * -1)
        else
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Torso = " .. torsoHealth .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
        end
    end
    if(Left_ArmHealth > 0) then
        Left_ArmHealth = Left_ArmHealth - remainingDamage
        if(Left_ArmHealth <= 0)then
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Left_Arm = " .. 0 .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
            takeRemainderDamage(ply, Left_ArmHealth * -1)
        else
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Left_Arm = " .. Left_ArmHealth .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
        end
    end
    if(Right_ArmHealth > 0) then
        Right_ArmHealth = Right_ArmHealth - remainingDamage
        if(Right_ArmHealth <= 0)then
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Right_Arm = " .. 0 .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
            takeRemainderDamage(ply, Right_ArmHealth * -1)
        else
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Right_Arm = " .. Right_ArmHealth .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
        end
    end
    if(StomachHealth > 0) then
        StomachHealth = StomachHealth - remainingDamage
        if(StomachHealth <= 0)then
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Stomach = " .. 0 .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
            takeRemainderDamage(ply, StomachHealth * -1)
        else
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Stomach = " .. StomachHealth .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
        end
    end
    if(Left_LegHealth > 0) then
        Left_LegHealth = Left_LegHealth - remainingDamage
        if(Left_LegHealth <= 0)then
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Left_Leg = " .. 0 .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
            takeRemainderDamage(ply, Left_LegHealth * -1)
        else
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Left_Leg = " .. Left_LegHealth .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
        end
    end
    if(Right_LegHealth > 0) then
        Right_LegHealth = Right_LegHealth - remainingDamage
        if(Right_LegHealth <= 0)then
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Right_Leg = " .. 0 .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
            takeRemainderDamage(ply, Right_LegHealth * -1)
        else
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Right_Leg = " .. Right_LegHealth .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
        end
    end

    
        
end

function damageLegs(ply, damage)
    local damageToEach = math.floor(((damage * 4.4)/ 2)+0.5)
    local Left_LegHealth = tonumber(sql.QueryValue("SELECT Left_Leg FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) 
    local Right_LegHealth = tonumber(sql.QueryValue("SELECT Right_Leg FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")) 
    if(Left_LegHealth > 0) then
        Left_LegHealth = Left_LegHealth - damageToEach
        if(Left_LegHealth <= 0)then
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Left_Leg = " .. 0 .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
            takeRemainderDamage(ply, Left_LegHealth * -1)
        else
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Left_Leg = " .. Left_LegHealth .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
            print(sql.LastError())
        end
    else
        takeRemainderDamage(ply, damageToEach)
    end
    if(Right_LegHealth > 0) then
        Right_LegHealth = Right_LegHealth - damageToEach
        if(Right_LegHealth <= 0)then
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Right_Leg = " .. 0 .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
            takeRemainderDamage(ply, Right_LegHealth * -1)
        else
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Right_Leg = " .. Right_LegHealth .. " WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
        end
    else
        takeRemainderDamage(ply, damageToEach)
    end
end

function getHealth(ply)
    local table = sql.Query("SELECT Head, Torso, Left_Arm, Right_Arm, Stomach, Left_Leg, Right_Leg FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
    local health = 0
    health = health + tonumber(sql.QueryValue("SELECT Head FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";"))
    health = health + tonumber(sql.QueryValue("SELECT Torso FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";"))
    health = health + tonumber(sql.QueryValue("SELECT Left_Arm FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";"))
    health = health + tonumber(sql.QueryValue("SELECT Right_Arm FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";"))
    health = health + tonumber(sql.QueryValue("SELECT Stomach FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";"))
    health = health + tonumber(sql.QueryValue("SELECT Left_Leg FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";"))
    health = health + tonumber(sql.QueryValue("SELECT Right_Leg FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";"))
    health = (health / 440) * 100
    health = math.floor(health + 0.5)
    return health
end

function CreateHealthTable()
    sql.Query("CREATE TABLE IF NOT EXISTS alexi_tarkov_health_system_table ( PlayerSteamID TEXT, Head INTEGER, Torso INTEGER, Left_Arm INTEGER, Right_Arm INTEGER, Stomach INTEGER, Left_Leg INTEGER, Right_Leg INTEGER )" )
end

function AddToHealthTable(player)
    if((sql.Query("SELECT 1 FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(player:SteamID()) .. ";")) != nil) then 
        return
    else
        sql.Query("INSERT INTO alexi_tarkov_health_system_table ( PlayerSteamID, Head, Torso, Left_Arm, Right_Arm, Stomach, Left_Leg, Right_Leg ) VALUES ( " .. sql.SQLStr(player:SteamID()) .. ", " .. 35 .. ", " .. 85 .. ", " .. 60 .. ", " .. 60 .. ", " .. 70 .. ", " .. 65 .. ", " .. 65 .. ")")
        return
    end

end

function ResetHealth(player)
    sql.Query("UPDATE alexi_tarkov_health_system_table SET Head = 35, Torso = 85, Left_Arm = 60, Right_Arm = 60, Stomach = 70, Left_Leg = 65, Right_Leg = 65 WHERE PlayerSteamID =" .. sql.SQLStr(player:SteamID()) .. ";")
end

concommand.Add("TarkovHealth_PrintTable", function(ply, cmd, args)
    if(ply:IsSuperAdmin()) then
        local table = sql.Query("SELECT * FROM alexi_tarkov_health_system_table ;")
        PrintTable(table)
    else
        print("You must be an admin to run this command")
    end
end)

concommand.Add("TarkovHealth_CurrentHealth", function(ply, cmd, args)
    local table = sql.Query("SELECT * FROM alexi_tarkov_health_system_table WHERE PlayerSteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
    PrintTable(table)
end)

concommand.Add("TarkovHealth_ToggleEnable", function(ply, cmd, args)
    if(ply:IsSuperAdmin()) then
        if(FLAG_ENABLED) then
            sql.Query("UPDATE alexi_tarkov_health_system_table SET Head = 35, Torso = 85, Left_Arm = 60, Right_Arm = 60, Stomach = 70, Left_Leg = 65, Right_Leg = 65;")
            print("Tarkov health system disabled")
            FLAG_ENABLED = false
        else
            for i,v in ipairs(player.GetAll()) do
                takeRemainderDamage(v, ((100 - v:Health()) / 100) * 440)
            end
            print("Tarkov health system enabled")
            FLAG_ENABLED = true
        end
    else
        print("You must be an admin to run this command")
    end
end)

