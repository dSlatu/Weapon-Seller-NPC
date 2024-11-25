include("shared.lua")

net.Receive("OpenWeaponMenu", function()
    net.Start("CheckWeaponDealer")
    net.SendToServer()
end)

net.Receive("WeaponDealerResponse", function()
    local active = net.ReadBool()
    if active then
        chat.AddText(Color(59, 144, 222), "Un vendeur d'arme est déjà en service, veuillez aller voir mon collègue.")
    else
        local frame = vgui.Create("DFrame")
        frame:SetTitle("")
        frame:ShowCloseButton(false)
        frame:SetSize(1000, 700)
        frame:Center()
        frame:MakePopup()
        frame.Paint = function(self, w, h)
            draw.RoundedBox(10, 0, 0, w, h, Color(24, 24, 35))
            draw.SimpleTextOutlined("Vendeur d'Armes", "DermaLarge", w / 2, 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0, 0, 0))
        end

        local logo = vgui.Create("DImage", frame)
        logo:SetPos(-45, -30)
        logo:SetSize(300, 300) 
        logo:SetImage("materials/belife/logo.png")

        local closeButton = vgui.Create("DImageButton", frame)
        closeButton:SetPos(frame:GetWide() - 40, 10)
        closeButton:SetSize(30, 30)
        closeButton:SetImage("materials/belife/x.png") 
        closeButton.DoClick = function()
            frame:Close()
        end

        local weaponList = {
            {name = "AK-47", class = "m9k_ak47", price = 130000, img = "materials/belife/ak.png"},
            {name = "AN-94", class = "m9k_an94", price = 130000, img = "materials/belife/anovember94 1.png"},
            {name = "ACR", class = "m9k_acr", price = 160000, img = "materials/belife/acr.png"},
            {name = "Mossberg", class = "m9k_mossberg590", price = 100000, img = "materials/belife/pompe.png"},
            {name = "Ithaca", class = "m9k_ithacam37", price = 100000, img = "materials/belife/Ithaca 1.png"},
            {name = "M24", class = "m9k_m24", price = 90000, img = "materials/belife/m24.png"},
        }

        local panelWidth, panelHeight = 250, 227
        local spacing = 20
        local startX = (frame:GetWide() - (3 * panelWidth + 2 * spacing)) / 2
        local startY = 180

        for i, weapon in ipairs(weaponList) do
            local weaponPanel = vgui.Create("DPanel", frame)
            weaponPanel:SetSize(panelWidth, panelHeight)
            local row = math.floor((i - 1) / 3)
            local col = (i - 1) % 3
            weaponPanel:SetPos(startX + col * (panelWidth + spacing), startY + row * (panelHeight + spacing))

            weaponPanel.Paint = function(self, w, h)
                draw.RoundedBox(10, 0, 0, w, h, Color(150, 112, 46))
                draw.RoundedBoxEx(10, 0, h - 30, w, 30, Color(255, 255, 255), false, false, true, true)
            end

            local weaponImage = vgui.Create("DImage", weaponPanel)
            weaponImage:SetSize(230, 100)

       
            local imgWidth, imgHeight = weaponImage:GetSize()
            local aspectRatio = imgWidth / imgHeight

  
            local maxWidth, maxHeight = 230, 100
            if aspectRatio > 1 then
                weaponImage:SetSize(maxWidth, maxWidth / aspectRatio)
            else
                weaponImage:SetSize(maxHeight * aspectRatio, maxHeight)
            end

            weaponImage:SetPos((panelWidth - weaponImage:GetWide()) / 2, 10)
            weaponImage:SetImage(weapon.img)

            local weaponName = vgui.Create("DLabel", weaponPanel)
            weaponName:SetPos(10, 120)
            weaponName:SetSize(230, 20)
            weaponName:SetText(weapon.name)
            weaponName:SetTextColor(color_white)
            weaponName:SetContentAlignment(5)
            weaponName.Paint = function(self, w, h)
                surface.SetFont(self:GetFont())
                local text = self:GetText()
                local textW, textH = surface.GetTextSize(text)
                draw.SimpleTextOutlined(text, self:GetFont(), w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
            end

            local weaponPrice = vgui.Create("DLabel", weaponPanel)
            weaponPrice:SetPos(10, 200)
            weaponPrice:SetSize(230, 20)
            weaponPrice:SetText(weapon.price .. " €")
            weaponPrice:SetTextColor(color_black)
            weaponPrice:SetContentAlignment(5)
            weaponPrice:SetFont("DermaDefaultBold")
            weaponPrice.Paint = function(self, w, h)
                surface.SetFont(self:GetFont())
                local text = self:GetText()
                local textW, textH = surface.GetTextSize(text)
                draw.SimpleTextOutlined(text, self:GetFont(), w / 2, h / 2, self:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(128, 128, 128))
            end

            weaponPanel:SetMouseInputEnabled(true)
            weaponPanel.OnMousePressed = function()
                net.Start("BuyWeapon")
                net.WriteString(weapon.class)
                net.WriteInt(weapon.price, 32)
                net.SendToServer()
            end
        end
    end
end)
