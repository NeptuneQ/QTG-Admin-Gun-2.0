local QAG2M = {}

function QAG2M:Init()
	local p = LocalPlayer()
	self:SetSize(ScrW(),ScrH())
	self:Center()
	local frame = self:Add('DPanel')
	frame:SetSize(300,700)
	frame:Center()
	frame.Paint = function(self,w,h)
		surface.SetDrawColor(60,60,60)
		surface.DrawRect(0,0,w,h)
	end
	self:CFrame(frame)
	local label_choose = frame:Add('DLabel')
	label_choose:SetFont('QAG2MTitle')
	label_choose:SetText('Fire Mode Menu')
	label_choose:SizeToContents()	
	label_choose:SetTextColor(Color(255,255,255))
	label_choose:SetPos(0,20)
	label_choose:CenterHorizontal()
	local CloseButton = frame:Add('DButton')
	CloseButton:SetPos(279, 2)
	CloseButton:SetFont('marlett')
	CloseButton:SetText('r')
	CloseButton.Paint = function(self,w,h)
		if CloseButton:IsHovered() then
			surface.SetDrawColor(80,0,200)
			surface.DrawRect(0,0,w,h)
		end
	end
	CloseButton:SetColor(Color(255, 255, 255))
	CloseButton:SetSize(20, 20)
	CloseButton.DoClick = function()
		self:Remove()
	end
	local SButton = frame:Add('DImageButton')
	SButton:SetPos(5,5)			
	SButton:SetImage('icon16/wrench.png')
	SButton:SizeToContents()			
	SButton.DoClick = function()
		RunConsoleCommand('QTG_AdminGun_OpenSettingMenu')
	end
	self:MakePopup()
	self:SetKeyboardInputEnabled(false)
	self:FireModeList()
end

function QAG2M:CFrame(p)
	local frame = p:Add('DPanel')
	frame:SetSize(290,620)
	frame:Center()
	frame:CenterVertical(0.55)
	frame.Paint = function(self,w,h)
		surface.SetDrawColor(60,60,60)
		surface.DrawRect(0,0,w,h)
	end
	self.Scroll = frame:Add('DScrollPanel')
	self.Scroll:Dock(FILL)
	local sbar = self.Scroll:GetVBar()
	local sbar2 = self.Scroll
	function sbar:Paint(w,h)
		draw.RoundedBox(3,5,0,w-5,h,Color(60,60,60))
	end
	function sbar.btnUp:Paint(w,h)
		draw.RoundedBox(3,5,0,w-5,h-5,Color(40,40,40))
	end
	function sbar.btnDown:Paint(w,h)
		draw.RoundedBox(3,5,5,w-5,h-5,Color(40,40,40))
	end
	function sbar.btnGrip:Paint(w,h)
		draw.RoundedBox(3,5,0,w-5,h,Color(40,40,40))
		if self.Hovered then
			draw.RoundedBox(3,5,0,w-5,h,Color(80,0,200))
		end
		if self.Depressed then
			draw.RoundedBox(3,5,0,w-5,h,Color(60,0,100))
		end
	end
end

function QAG2M:AddOption(b,t)
	local db = self.Scroll:Add('DButton')
	db:SetSize(290,30)
	db:SetText('')
	db:Dock(TOP)
	db:DockMargin(0,0,0,5)
	db.DoClick = function()
		self:Remove()
		net.Start('QAG2_SetFireMode')
			net.WriteString(b)
			net.WriteEntity(LocalPlayer())
		net.SendToServer()
	end
	db.Paint = function(self,w,h)
		if self:IsHovered() then
			surface.SetDrawColor(80,0,200)
		else
			surface.SetDrawColor(40,40,40)
		end
		surface.DrawRect(0,0,w,h)
		surface.SetFont('QAG2MName')
		local str = string.upper(t.Name[1]) .. string.sub(t.Name,2)
		local TextW, TextH = surface.GetTextSize(str)
		surface.SetTextColor(200, 200, 200)
		surface.SetTextPos(w/2-TextW/2,h/2-TextH/2)
		surface.DrawText(str)
	end
end

function QAG2M:FireModeList()
	for k,v in SortedPairs(QAG2.FireMode) do
		if v.AddToMenu or v.AddToMenu == nil then
			self:AddOption(k,v,imenu,self.name)
		end
	end
end

vgui.Register('QAG2_FireModeMenu',QAG2M)

function QAG2:OpenMenu()
	if IsValid(qag2m) then
		if !qag2m:IsVisible() then
			qag2m:Show()
		end
	else
		qag2m = vgui.Create('QAG2_FireModeMenu')
	end
end