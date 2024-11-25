AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:Initialize()
    self:SetModel("models/players/LamarDavis.mdl")
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE, CAP_TURN_HEAD)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()
end

function ENT:AcceptInput(name, activator, caller)
    if name == "Use" and IsValid(caller) and caller:IsPlayer() then
        self:ShowWeaponMenu(caller)
    end
end

function ENT:ShowWeaponMenu(ply)
    net.Start("OpenWeaponMenu")
    net.Send(ply)
end

util.AddNetworkString("OpenWeaponMenu")
util.AddNetworkString("BuyWeapon")

net.Receive("BuyWeapon", function(len, ply)
    local weaponClass = net.ReadString()
    local price = net.ReadInt(32)

    if ply:canAfford(price) then
        ply:addMoney(-price)
        ply:Give(weaponClass)
    else

    end
end)