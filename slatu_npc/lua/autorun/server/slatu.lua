

util.AddNetworkString("BuyWeapon")
util.AddNetworkString("CheckWeaponDealer")
util.AddNetworkString("WeaponDealerResponse")

local function IsWeaponDealerActive()
    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() == TEAM_ARMURIER then 
            return true
        end
    end
    return false
end

net.Receive("CheckWeaponDealer", function(len, ply)
    local active = IsWeaponDealerActive()
    net.Start("WeaponDealerResponse")
    net.WriteBool(active)
    net.Send(ply)
end)

net.Receive("BuyWeapon", function(len, ply)
    local weaponClass = net.ReadString()
    local weaponPrice = net.ReadInt(32)


    if ply:canAfford(weaponPrice) then 
        ply:addMoney(-weaponPrice) 
        ply:Give(weaponClass)
        ply:ChatPrint("Vous avez acheté " .. weaponClass .. " pour " .. weaponPrice .. " €")
    else
        ply:ChatPrint("Vous n'avez pas assez d'argent pour acheter cette arme.")
    end
end)
