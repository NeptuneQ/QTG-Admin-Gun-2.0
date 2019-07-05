AddCSLuaFile()

SWEP.Base 							= 'weapon_base'
SWEP.HoldType 						= 'pistol'
SWEP.PrintName 						= 'QTG Admin Gun 2.0'
SWEP.Author 						= 'Neptune QTG'
SWEP.Slot 							= 2
SWEP.SlotPos 						= 0
SWEP.AdminSpawnable 				= true
SWEP.AdminOnly 						= true
SWEP.Spawnable 						= true
SWEP.Category 						= 'Neptune QTG SWEPs'
SWEP.ViewModel 						= 'models/weapons/c_smg1.mdl'
SWEP.WorldModel 					= 'models/weapons/w_smg1.mdl'
SWEP.ViewModelFOV 					= 90
SWEP.UseHands 						= true
SWEP.Primary.ClipSize 				= -1
SWEP.Primary.Ammo 					= 'none'
SWEP.Primary.DefaultClip 			= -1
SWEP.Primary.MouseSensitivity		= {
	0.5,
	0.3,
	0.1,
	0.05
}
SWEP.Secondary.ClipSize 			= -1
SWEP.Secondary.DefaultClip 			= -1
SWEP.Secondary.Automatic 			= false
SWEP.Secondary.Ammo 				= 'none'
SWEP.DrawAmmo 						= false
SWEP.DrawCrosshair					= true
SWEP.ZoomLevels						= {}
SWEP.ZoomLevels[1]					= 40
SWEP.ZoomLevels[2]					= 20
SWEP.ZoomLevels[3]					= 5
SWEP.ZoomLevels[4]					= 1
SWEP.SwayScale 						= 0
SWEP.BobScale 						= 0
SWEP.VElements = {
	['2'] = { type = 'Model', model = 'models/Items/combine_rifle_ammo01.mdl', bone = 'ValveBiped.base', rel = '', pos = Vector(0, -0.552, 9.487), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = '', skin = 0, bodygroup = {} },
	['1+'] = { type = 'Model', model = 'models/items/battery.mdl', bone = 'ValveBiped.base', rel = '', pos = Vector(-0.32, 0, -1.624), angle = Angle(180, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = '', skin = 0, bodygroup = {} },
	['1'] = { type = 'Model', model = 'models/items/battery.mdl', bone = 'ValveBiped.base', rel = '', pos = Vector(0.634, 0, -6.503), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = '', skin = 0, bodygroup = {} },
}
SWEP.WElements = {
	['2'] = { type = 'Model', model = 'models/Items/combine_rifle_ammo01.mdl', bone = 'ValveBiped.Bip01_R_Hand', rel = '', pos = Vector(13.97, 1.44, -7.271), angle = Angle(-102.086, 25.018, 25.031), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = '', skin = 0, bodygroup = {} },
	['1'] = { type = 'Model', model = 'models/items/battery.mdl', bone = 'ValveBiped.Bip01_R_Hand', rel = '', pos = Vector(-0.797, 1.039, -4.08), angle = Angle(0, 89.753, 102.04), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = '', skin = 0, bodygroup = {} },
	['1+'] = { type = 'Model', model = 'models/items/battery.mdl', bone = 'ValveBiped.Bip01_R_Hand', rel = '', pos = Vector(-0.797, 1.985, -4.08), angle = Angle(180, 90.219, 80.127), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = '', skin = 0, bodygroup = {} }
}
SWEP.ViewModelBoneMods = {
	['ValveBiped.Bip01_L_Clavicle'] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(180, 0, 0)}
}

if GAMEMODE.Name == 'Horror Maps' then
	SWEP.Slot 						= 5
end

local RPGLaserOn = 'Weapon_RPG.LaserOn'
local RPGLaserOff = 'Weapon_RPG.LaserOff'
local ModeSound = 'Weapon_Alyx_Gun.Special2'

local ReplaceList = {
	'prop_door_rotating',
	'prop_door',
	'func_door_rotating',
	'func_door'
}

local ReplaceList2 = {
	'func_physbox'
}

local RemoveList = {
}

function SWEP:GetFireMode()
	if !IsValid(self.Owner) then return {} end
	return QAG2.FireMode[self.Owner:GetQAG2FireMode()] or {}
end

function SWEP:FireAdminBullets(a,b,f)
	local b = {
		Callback = function(a,t,d)
			d:SetDamageType(bit.bor(DMG_AIRBOAT,DMG_BLAST))
			d:SetDamage(t.Entity:GetMaxHealth()*math.huge)
			f(a,t,d)
		end,
		Num = 10,
		Src = self.Owner:GetShootPos(),
		Dir = self.Owner:GetAimVector(),
		Spread 		= a,
		TracerName 	= b,
		Tracer = 0.2,
		Force = math.huge,
		-- Damage = math.huge,
		AmmoType = 'none'
	}
	self.Owner:FireBullets(b)
end

function SWEP:SetupDataTables()
	self:NetworkVar('Float',0,'FireType')
	self:NetworkVar('Bool',1,'Crosshair')
	self:NetworkVar('Int',2,'ZoomLvl')
	self:NetworkVar('Bool',3,'Holstering')
	self:NetworkVar('Bool',4,'HolsterCustoming')
end

function SWEP:Reload()
	if !self.Owner:KeyPressed(IN_RELOAD) then return end
	if self.Owner:KeyDown(IN_USE) then
		self:FireTypeSwitch()
	else
		if self:GetFireMode().Reload != nil then
			self:GetFireMode().Reload(self)
		end
	end
end

function SWEP:FireTypeSwitch()
	if self:GetFireMode().FireType == nil then return end
	if #self:GetFireMode().FireType<2 then return end
	self:SetFireType(self:GetFireType()+1)
	self.Owner:EmitSound(ModeSound)
	if self:GetFireType() > #self:GetFireMode().FireType then
		self:SetFireType(1)
	end
	local Text = self:GetFireMode().FireType[self:GetFireType()].TypeName
	if CLIENT then self.Owner:QAGAddNotify(Text) end
end

function SWEP:FireAnimationEvent(p,a,e,o)
	return true
end

function SWEP:DoShootEffect(hitpos,hitnormal,entity,physbone,bFirstTimePredicted,a)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound(self:GetFireMode().FireSound)
	if !bFirstTimePredicted or !a then return end
	local eff = EffectData()
	eff:SetOrigin(hitpos)
	eff:SetNormal(hitnormal)
	eff:SetEntity(entity)
	eff:SetAttachment(physbone)
	util.Effect('qtg_selection_indicator',eff)
	local eff = EffectData()
	eff:SetOrigin(hitpos)
	eff:SetStart(self.Owner:GetShootPos())
	eff:SetEntity(self)
	eff:SetAttachment(1)
	util.Effect('ToolTracer',eff,true,nil)
end

function SWEP:PrimaryAttack()
	local tr = util.GetPlayerTrace(self.Owner)
	tr.mask = bit.bor(CONTENTS_SOLID,CONTENTS_MOVEABLE,CONTENTS_MONSTER,CONTENTS_WINDOW,CONTENTS_DEBRIS,CONTENTS_GRATE,CONTENTS_AUX)
	local trace = util.TraceLine(tr)
	if !trace.Hit then return end
	if self:GetFireMode().FireType == nil then return end
	if self:GetFireMode().FireType[self:GetFireType()] == nil then
		self:SetFireType(1)
	end
	self:GetFireMode().FireType[self:GetFireType()].StartFire(self,trace)
	self:SetNextPrimaryFire(game.GetTimeScale()<1 and CurTime()+self:GetFireMode().FireTime*game.GetTimeScale() or CurTime()+self:GetFireMode().FireTime)
	self:DoShootEffect(trace.HitPos,trace.HitNormal,trace.Entity,trace.PhysicsBone,IsFirstTimePredicted(),self:GetFireMode().DrawToolTracer)
end

function SWEP:SecondaryAttack()
	self:EmitSound(ModeSound)
	if SERVER then
		net.Start('QAG2_OpenFireModeMenu')
		net.Send(self.Owner)
	end
end

function SWEP:Think()
	if self:GetFireMode().Think != nil then
		self:GetFireMode().Think(self)
	end
	
	self.Primary.Automatic = self:GetFireMode().IsAutomatic
	self:UpdateLaserPosition()
	
	if self:GetHolstering() then
		if self:GetNWFloat('QTG_Holstertime')<CurTime() then
			self:FinishHolster()
		end
	end
	
	if self:GetNWBool('QTG_Deploytweing') then
		self:SetNWBool('QTG_Deploytweing',false)
	end
	
	local dist = self.Owner:GetVelocity():LengthSqr()
	
	if self.Owner:KeyDown(IN_SPEED) and dist > self.Owner:GetWalkSpeed()^2 then
		self:SetNWBool('QTG_Running',true)
	elseif self:GetNWBool('QTG_Running') then
		self:SetNWBool('QTG_Running',false)
	end
	
	if SERVER then
		if game.GetTimeScale() < 1 then
			self.Owner:SetLaggedMovementValue(1/game.GetTimeScale())
		else
			self.Owner:SetLaggedMovementValue(1)
		end
	end
	
	if self.Owner:IsValid() then
		if SERVER then
			local hitSource = self.Owner:GetPos()
			
			for _,e in pairs(ents.FindInSphere(hitSource,70)) do
				for k, v in pairs(ReplaceList) do
					if e:IsValid() and e:GetClass() == v then
						local d = ents.Create('prop_physics')
						d:SetModel(e:GetModel())
						d:SetPos(e:GetPos())
						d:SetAngles(e:GetAngles())
						d:Spawn()
						d:Activate()
						if e:GetSkin() != nil then
							d:SetSkin(e:GetSkin())
						end
						d:SetMaterial(e:GetMaterial())
						e:Remove()
						timer.Simple(3,function()
							if IsValid(d) then
								d:SetCollisionGroup(1)
							end
						end)
						local phys = d:GetPhysicsObject()
						if phys:IsValid() then
							phys:SetVelocity(((d:GetPos()-self:GetPos())*500+(d:GetPos()+d:GetForward()*400-self:GetPos())+(d:GetPos()+d:GetUp()*200-self:GetPos())*140))
						end
					end
				end
				
				for k, v in pairs(ReplaceList2) do
					if e:IsValid() and e:GetClass() == v then
						local d = ents.Create('prop_physics')
						d:SetModel(e:GetModel())
						d:SetPos(e:GetPos())
						d:SetAngles(e:GetAngles())
						d:Spawn()
						d:Activate()
						if e:GetSkin() != nil then
							d:SetSkin(e:GetSkin())
						end
						d:SetMaterial(e:GetMaterial())
						e:Remove()
						local phys = d:GetPhysicsObject()
						if phys:IsValid() then
							phys:SetVelocity(((d:GetPos()-self:GetPos())*500+(d:GetPos()+d:GetForward()*400-self:GetPos())+(d:GetPos()+d:GetUp()*200-self:GetPos())*140))
						end
					end
				end		
				
				for k, v in pairs(RemoveList) do
					if e:IsValid() and e:GetClass() == v then
						e:Remove()
					end
				end
				
				if e:IsValid() and e:GetClass() == 'func_brush' and e:GetName() != '' then
					e:Remove()
				end
			end	
			
			for k, v in pairs(ents.FindInSphere(hitSource,150)) do
				if IsValid(v) and v:GetClass() == 'ent_undertale_bone_ground' then
					v:SetSolid(SOLID_NONE)
				end
			end
			
			for k,v in ipairs(ents.FindByClass('npc_barnacle')) do
				if math.Distance(self.Owner:GetPos().x,self.Owner:GetPos().y,v:GetPos().x,v:GetPos().y) <= 100 then
					v:NextThink(CurTime()+2)
				end
			end
		end
	end
end

function SWEP:NpcThink()
end

function SWEP:WeaponThink()
	if self.Owner != NULL then return end
	for _,e in pairs(ents.FindInSphere(self:GetPos(),10)) do
		if e:IsPlayer() and e:IsAdmin() then
			e:Give(self:GetClass())
			self:QTGRemove100()
		end
	end
end

if CLIENT then
	SWEP.Gradient = surface.GetTextureID('gui/gradient')
	SWEP.InfoIcon = surface.GetTextureID('gui/info')

	SWEP.ModeNameHeight = 0
	SWEP.InfoBoxHeight = 0

	function SWEP:DrawHUD()
	
		local tr = util.GetPlayerTrace(self.Owner)
		tr.mask = bit.bor(CONTENTS_SOLID,CONTENTS_MOVEABLE,CONTENTS_MONSTER,CONTENTS_WINDOW,CONTENTS_DEBRIS,CONTENTS_GRATE,CONTENTS_AUX)
		local trace = util.TraceLine(tr)
		if !trace.Hit then return end

		local mode = self:GetFireMode().Name or 'Invalid name'
		local subtitle = self:GetFireMode().Introduction or ''

		local x, y = 50, 40
		local w, h = 0, 0

		local TextTable = {}
		local QuadTable = {}

		QuadTable.texture = self.Gradient
		QuadTable.color = Color(10,10,10,180)

		QuadTable.x = 0
		QuadTable.y = y - 8
		QuadTable.w = 600
		QuadTable.h = self.ModeNameHeight - ( y - 8 )
		draw.TexturedQuad( QuadTable )

		TextTable.font = 'QAG2ModeName'
		TextTable.color = Color( 240, 240, 240, 255 )
		TextTable.pos = {x,y}
		TextTable.text = mode
		w, h = draw.TextShadow(TextTable,2)
		y = y + h

		TextTable.font = 'QAG2ModeSubtitle'
		TextTable.pos = {x,y}
		TextTable.text = subtitle
		w, h = draw.TextShadow(TextTable,1)
		y = y + h + 8

		self.ModeNameHeight = y

		QuadTable.y = y
		QuadTable.h = self.InfoBoxHeight
		QuadTable.color = Color(10,10,10,230)
		draw.TexturedQuad(QuadTable)

		y = y + 4

		TextTable.font = 'QAG2ModeHelp'

		local h2 = 0
		
		if self:GetFireMode().WeaponInfo != nil then
			for k,v in pairs(self:GetFireMode().WeaponInfo) do
				if !IsColor(v.color) then v.color = Color(0,0,0,255) end
				if !isfunction(v.text) then v.text = function() end end
				local txt = v.name..': '..v.text(self,trace)
				TextTable.text = txt or ''
				TextTable.pos = {x+21,y+h2}
				
				w, h = draw.TextShadow(TextTable,1)

				surface.SetDrawColor(255,255,255,255)
				surface.SetTexture(self.InfoIcon)
				surface.DrawTexturedRect(x,y+h2,16,16)

				h2 = h2 + h
			end
		end
		
		if self:GetFireMode().FireType != nil and #self:GetFireMode().FireType>1 and self:GetFireMode().FireType[self:GetFireType()].TypeName then
			local Qtype = self:GetFireMode().FireType[self:GetFireType()]
			local txt = 'Fire Type: '..Qtype.TypeName..' ( '..self:GetFireType()..'/'..#self:GetFireMode().FireType..' )'
			TextTable.text = txt or 'Invalid name'
			TextTable.pos = {x+21,y+h2}

			w, h = draw.TextShadow(TextTable,1)

			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(Material('gui/r.png'))
			surface.DrawTexturedRect(x,y+h2,16,16)
			
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(Material('gui/e.png'))
			surface.DrawTexturedRect(x-25,y+h2,16,16)

			draw.SimpleText( '+', 'default', x - 8, y + h2 + 2, color_white )

			h2 = h2 + h
		end
		
		if self:GetFireMode().Information != nil then
			for k,v in pairs(self:GetFireMode().Information) do
				if type(v) == 'string' then v = {name=v} end

				if !v.name or v.name:StartWith( 'right' ) then continue end
				if v.helptext == nil then v.helptext = 'Fire!!!' end
				local txt = v.helptext
				TextTable.text = txt
				TextTable.pos = {x+21,y+h2}

				w, h = draw.TextShadow(TextTable,1)

				if !v.icon then
					if v.name:StartWith( 'info' ) then v.icon = 'gui/info' end
					if v.name:StartWith( 'left' ) then v.icon = 'gui/lmb.png' end
					-- if v.name:StartWith( 'right' ) then v.icon = 'gui/rmb.png' end
					if v.name:StartWith( 'reload' ) then v.icon = 'gui/r.png' end
					if v.name:StartWith( 'use' ) then v.icon = 'gui/e.png' end
				end
				if !v.icon2 and !v.name:StartWith( 'use' ) and v.name:EndsWith( 'use' ) then v.icon2 = 'gui/e.png' end

				self.Icons = self.Icons or {}
				if v.icon and !self.Icons[v.icon] then self.Icons[v.icon] = Material(v.icon) end
				if v.icon2 and !self.Icons[v.icon2] then self.Icons[v.icon2] = Material(v.icon2) end

				if v.icon and self.Icons[ v.icon ] and !self.Icons[v.icon]:IsError() then
					surface.SetDrawColor(255,255,255,255)
					surface.SetMaterial(self.Icons[v.icon])
					surface.DrawTexturedRect(x,y+h2,16,16)
				end

				if v.icon2 and self.Icons[ v.icon2 ] and !self.Icons[v.icon2]:IsError() then
					surface.SetDrawColor(255,255,255,255)
					surface.SetMaterial(self.Icons[v.icon2])
					surface.DrawTexturedRect(x-25,y+h2,16,16)

					draw.SimpleText( '+', 'default', x - 8, y + h2 + 2, color_white )
				end

				h2 = h2 + h

			end
		end
		
		TextTable.text = 'Open Fire Mode Menu'
		TextTable.pos = {x+21,y+h2}

		w, h = draw.TextShadow(TextTable,1)

		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material('gui/rmb.png'))
		surface.DrawTexturedRect(x,y+h2,16,16)

		h2 = h2 + h

		self.InfoBoxHeight = h2 + 8
		
		if self:GetFireMode().DrawHUD != nil then
			self:GetFireMode().DrawHUD(self,trace)
		end
	end

	SWEP.MaterialErrer = false
	local function CheckMaterial(self,a)
		if self.MaterialErrer then
			return 'icon16/gun.png'
		end
		if Material(a):IsError() and !self.MaterialErrer then
			self.MaterialErrer = true
			Msg('Warning: WeaponIcon not found \''..a..'\'\n')
			return 'icon16/gun.png'
		end
		return a
	end

	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		y = y + 10
		x = x + 10
		wide = wide -20
		tall = tall -20
		local fsin = math.sin(CurTime()*10)*5
		surface.SetDrawColor(255,255,255,alpha)
		surface.SetMaterial(Material(CheckMaterial(self,'entities/'..self.ClassName..'.png')))
		surface.DrawTexturedRect(x+wide/4+0.5,y-fsin,wide/2,wide/2)
		draw.SimpleText(self:GetFireMode().Name or '','HudSelectionText',x+wide/2,y+tall-(tall/11),Color(0,255,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM)
		self:PrintWeaponInfo(x+wide+20,y+tall*0.95,wide,tall-(tall/3),alpha-50)
	end
	
	-- SWEP.SpeechBubbleLid = surface.GetTextureID('gui/speech_lid')
	
	local info = {
		{name = 'SWEP Author',text = function(self) return 'Neptune QTG' end,color = Color(0,0,0,255)},
		{name = 'Mode Author',text = function(self) return self:GetFireMode().Author or '' end,color = Color(0,0,0,255)},
		{name = 'Mode Name',text = function(self) return self:GetFireMode().Name or '' end,color = Color(0,0,0,255)}
	}
	
	function SWEP:PrintWeaponInfo(x,y,w,t,a)
		local pos = {x=x,y=y+5}
		local texth = 0
		local infon = 0
		local text = ''
		surface.SetDrawColor(Color(100,100,100,a))
		surface.SetTexture(self.SpeechBubbleLid)
		surface.DrawTexturedRect(x,y-64-5,128,64)
		
		if QAG2.WeaponInfo != nil then
			for k,v in pairs(QAG2.WeaponInfo) do
				for k,v in pairs(QAG2.WeaponInfo[k]) do
					v.modeonly = v.modeonly or false
					if !v.modeonly then
						infon = infon +1
					end
				end
			end
		end
		
		local tw,th = surface.GetTextSize('')
		texth = texth+th*(#info+infon)
		draw.RoundedBox(8,x-5,y-6,260,texth+18,Color(100,100,100,a))
		
		info[1].color = Color(math.random(0,255),math.random(0,255),math.random(0,255),255)
		
		for k,v in pairs(info) do
			if !IsColor(v.color) then v.color = Color(0,0,0,255) end
			if !isfunction(v.text) then v.text = function() return '' end end
			pos.y = pos.y+15
			text = v.name
			draw.SimpleText(text..': ','HudSelectionText',pos.x+5,pos.y,Color(0,0,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
			local tw,th = surface.GetTextSize(text..': ')
			text = v.text(self,trace)
			draw.SimpleText(text,'HudSelectionText',pos.x+tw+5,pos.y,v.color,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
		end
		
		if QAG2.WeaponInfo != nil then
			for k,v in pairs(QAG2.WeaponInfo) do
				for k,v in pairs(QAG2.WeaponInfo[k]) do
					v.modeonly = v.modeonly or false
					if !v.modeonly then
						if !IsColor(v.color) then v.color = Color(0,0,0,255) end
						if !isfunction(v.text) then v.text = function() return '' end end
						pos.y = pos.y+15
						text = v.name
						draw.SimpleText(text..': ','HudSelectionText',pos.x+5,pos.y,Color(0,0,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
						local tw,th = surface.GetTextSize(text..': ')
						text = v.text(self,trace)
						draw.SimpleText(text,'HudSelectionText',pos.x+tw+5,pos.y,v.color,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
					end
				end
			end
		end
	end

	function SWEP:DoDrawCrosshair()
		local pos = {x = ScrW()/2,y = ScrH()/2}
		local drawply = LocalPlayer():ShouldDrawLocalPlayer()
		h_crosshair = math.Approach(h_crosshair or 0,1,FrameTime()*5)
		if drawply then
			pos = self.Owner:GetEyeTrace().HitPos:ToScreen()
		end
		if h_crosshair > 0 or drawply then
			draw.RoundedBox(0, pos.x - 25, pos.y - 2, 12, 3, Color(0,0,0,200)) --Left
			draw.RoundedBox(0, pos.x + 12, pos.y - 2, 12, 3, Color(0,0,0,200)) --Right
			draw.RoundedBox(0, pos.x - 2, pos.y - 25, 3, 12, Color(0,0,0,200)) --Top
			draw.RoundedBox(0, pos.x - 2, pos.y + 12, 3, 12, Color(0,0,0,200)) --Bottom
			
			draw.RoundedBox(0, pos.x - 24, pos.y - 1, 12, 1, Color(0,0,255,255)) --Left
			draw.RoundedBox(0, pos.x + 11, pos.y - 1, 12, 1, Color(0,0,255,255)) --Right
			draw.RoundedBox(0, pos.x - 1, pos.y - 24, 1, 12, Color(0,0,255,255)) --Top
			draw.RoundedBox(0, pos.x - 1, pos.y + 11, 1, 12, Color(0,0,255,255)) --Bottom
		end
		return true
	end
end

function SWEP:StartGuiding()
	if self.Owner:IsNPC() then return false end
	if SERVER then
		if self:IsValid() then
			timer.Simple(1,function()
				if self:IsValid() then
					self.Owner:EmitSound(RPGLaserOn)
				end
			end)
			self:CreateLaserPointer()
		end
	end
end

function SWEP:CreateLaserPointer()
	if SERVER then
		self.LaserDot = ents.Create('env_laserdot')
		self.LaserDot:SetPos(self:GetPos())
		self.LaserDot:SetOwner(self.Owner)
		self.LaserDot:SetModel('models/error.mdl') -- shit bug
		-- self.LaserDot.m_bIsOn = true
		-- self.LaserDot:SetSaveValue('m_bIsOn',true)
		self.LaserDot:Spawn()
		self:UpdateLaserPosition()
	end
end

function SWEP:UpdateLaserPosition()
	if SERVER then
		local t = self.Owner:GetEyeTrace()
		local c = self.Owner:EyeAngles()
		if self.LaserDot:IsValid() and self.LaserDot != nil then
			self.LaserDot:SetPos(t.HitPos+c:Forward()*-64) -- Nice pos (s***)
			self.LaserDot:SetAngles((self.Owner:GetAimVector()+(t.HitNormal*1.0)):Angle())
		end
	end
end

function SWEP:StopGuiding()
	if SERVER and !self.Owner:IsNPC() and self.Owner != NULL then
		self.Owner:EmitSound(RPGLaserOff)
		if self.LaserDot:IsValid() then
			self.LaserDot:Remove()
			self.LaserDot = NULL
		end
	end
end

local function QTGPrint(a)
	if CLIENT then return end
	MsgC(Color(0,255,255),a..'\n')
end

function SWEP:Deploy()
	if self.Owner:GetQAG2FireMode() == 0 then
		local dmode = file.Exists('qtg_admin_gun_2/firemode/default.lua','LUA')
		if !dmode then
			if table.GetKeys(QAG2.FireMode)[1] != nil then
				self.Owner:SetQAG2FireMode(table.GetKeys(QAG2.FireMode)[1])
			else
				QTGPrint('[QTG Admin Gun 2.0] We did not find any fire mode.')
			end
		else
			self.Owner:SetQAG2FireMode('default')
		end
	end
	if SERVER and self.Owner:Alive() then
		if !self.Owner:IsAdmin() then
			if GetConVar('QTG_AdminGun_Language'):GetString() == 'zh-CN' then
				Text = self.Owner:Name() .. '你不是管理员禁止使用这个武器!'
			else
				Tezt = self.Owner:Name() .. ' you are not an administrator unable to use this weapon!'
			end
			if SERVER then self.Owner:QTGAddNotify(Text) end
			self.Owner:Kill()
		elseif !self.Owner:IsNPC() then
			self.Owner:QTGSuperGODEnable()
		end
		self.Owner:UnLock()
	end
	self:SetHoldType(self.HoldType)
	self:SetNWFloat('QTG_DeployTime',game.GetTimeScale()<1 and CurTime() + 0.8 * game.GetTimeScale() or CurTime() + 0.8)
	self:SetNWBool('QTG_Deployeding',true)
	self:SetNWBool('QTG_Deploytweing',true)
	self:SetNWInt('QTG_DeployGunTextTime',game.GetTimeScale()<1 and CurTime() + 0.9 * game.GetTimeScale() or CurTime() + 0.9)
	self:SetNextPrimaryFire(game.GetTimeScale()<1 and CurTime() + 1 * game.GetTimeScale() or CurTime() + 1)
	self:SetNextSecondaryFire(game.GetTimeScale()<1 and CurTime() + 0.3 * game.GetTimeScale() or CurTime() + 0.3)
	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then
		vm:SetModel(self.ViewModel)
	end
	self:StartGuiding()
	self:SetNWBool('QTG_CanHolster',false)
	self:SetHolstering(false)
	self:SetHolsterCustoming(false)
	if self:GetFireMode().Deploy != nil then
		self:GetFireMode().Deploy(self)
	end
	return true
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:AddFlags(FL_DISSOLVING,self:QTGGetKey())
	self:SetFireType(1)
	if SERVER then
		FixRemoveFunction(100)
		if self.Owner:IsNPC() then
			self:SetNpc()
		end
		if self.Owner:IsPlayer() then
			self:SetPlayer()
		end
		if self.Owner == NULL then
			hook.Add('Think',self,self.WeaponThink)
		end
	else
		if !self.Owner:IsNPC() then
			self.VElements = table.FullCopy(self.VElements)
			self.ViewModelBoneMods = table.FullCopy(self.ViewModelBoneMods)
			self:CreateModels(self.VElements)
		end	
		self.WElements = table.FullCopy(self.WElements)
		self:CreateModels(self.WElements)
		if !self.Owner:IsNPC() then
			if self.Owner:IsValid() then
				local vm = self.Owner:GetViewModel()
				if vm:IsValid() then
					self:ResetBonePositions(vm)
				end
			end	
		end
	end
end

function SWEP:SetPlayer()
end

function SWEP:SetNpc()
	if self.Owner:GetClass() == 'npc_citizen' then
		self.Owner:SetKeyValue('spawnflags',131072,self:QTGGetKey())
	end
	if self.Owner:GetClass() == 'npc_combine_s' then
		self:SetHoldType('ar2')
		self.Owner:SetKeyValue('Numgrenades',-1,self:QTGGetKey())
	end
	self.Owner:SetHullType(HULL_MEDIUM,self:QTGGetKey())
	self.Owner:SetHullSizeNormal(self:QTGGetKey())
	self.Owner:SetSolid(SOLID_BBOX,self:QTGGetKey())
	self.Owner:SetHealth(1e9,self:QTGGetKey())
	self.Owner:AddEFlags(EFL_NO_DISSOLVE,self:QTGGetKey())
	self.Owner:AddEFlags(EFL_NO_MEGAPHYSCANNON_RAGDOLL,self:QTGGetKey())
	self.Owner:AddEFlags(EFL_NO_PHYSCANNON_INTERACTION,self:QTGGetKey())
	self.Owner:AddEFlags(EFL_NO_DAMAGE_FORCES,self:QTGGetKey())
	self.Owner:AddEFlags(EFL_CHECK_UNTOUCH,self:QTGGetKey())
	self.Owner:AddFlags(FL_DISSOLVING,self:QTGGetKey())
	self.Owner:AddFlags(FL_TRANSRAGDOLL,self:QTGGetKey())
	self.Owner:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT,self:QTGGetKey())
	self:SetInitializeCapabilities()
	hook.Add('Think',self,self.Think)
	hook.Add('Think',self,self.NpcThink)
	hook.Add('EntityTakeDamage',self,self.OnNpcTakeDamage)
	hook.Add('PhysgunPickup',self,self.OnPhysgunPickup)
	hook.Add('CanTool',self,self.NpcCanTool)
	hook.Add('CanProperty',self,self,self.NpcCanProperty)
end

function SWEP:SetInitializeCapabilities()
	self.Owner:CapabilitiesAdd(CAP_ANIMATEDFACE,self:QTGGetKey())
	self.Owner:CapabilitiesAdd(CAP_TURN_HEAD,self:QTGGetKey())
	self.Owner:CapabilitiesAdd(CAP_MOVE_GROUND,self:QTGGetKey())
	self.Owner:CapabilitiesAdd(CAP_OPEN_DOORS,self:QTGGetKey())
	self.Owner:CapabilitiesAdd(CAP_AUTO_DOORS,self:QTGGetKey())
	self.Owner:CapabilitiesAdd(CAP_MOVE_JUMP,self:QTGGetKey())
	self.Owner:CapabilitiesAdd(CAP_USE,self:QTGGetKey())
	self.Owner:CapabilitiesAdd(CAP_FRIENDLY_DMG_IMMUNE,self:QTGGetKey())
	self.Owner:CapabilitiesAdd(CAP_USE,self:QTGGetKey())
	self.Owner:CapabilitiesAdd(CAP_DUCK,self:QTGGetKey())
	self.Owner:CapabilitiesAdd(CAP_SQUAD,self:QTGGetKey())
end

function SWEP:OnNpcTakeDamage(e,d)
	if e == self.Owner then
		net.Start('QTG_miss')
		net.WriteEntity(e)
		net.WriteVector(self.Owner:EyePos())
		net.Broadcast()
		self.Owner:EmitSound(Sound('undertale/qtg_attack_miss.wav'),75,100,1,CHAN_AUTO)
		return true
	end
end

function SWEP:OnPhysgunPickup(p,e)
	if e == self.Owner then
		return false
	end
end

function SWEP:NpcCanTool(p,t,l)
	if l == 'remover' and t.Entity == self.Owner then
		return false
	end
end

function SWEP:NpcCanProperty(p,pr,e)
	if e == self.Owner then
		return false
	end
end

function SWEP:Holster(w)
	if CLIENT then return end
	if !self.Owner:IsValid() then return true end
	if self.Owner:IsNPC() then return true end
	if !self.Owner:Alive() then self:FinishHolster() return true end
	if !self:GetHolstering() then
		local vm = self.Owner:GetViewModel()
		self:SetNWEntity('QTG_SelectWeapon',w)
		self:SetHolsterCustoming(true)
		self:SetHolstering(true)
		self:SetNWFloat('QTG_Holstertime',CurTime()+math.min(vm:SequenceDuration(),0.5))
		return false
	elseif self:GetNWBool('QTG_CanHolster') then
		return true
	end
end

function SWEP:FinishHolster()
	if self.Owner:IsNPC() then return end
	if SERVER and self.Owner:IsValid() then
		if !self.Owner:IsNPC() then
			if self.Owner:IsAdmin() then
				self.Owner:QTGSuperGODDisable()
			end
		end	
	end
	self:StopGuiding()
	if self:GetFireMode().Holster != nil then
		self:GetFireMode().Holster(self)
	end
	if !self.Owner:Alive() then return end
	if SERVER then
		local w = self:GetNWEntity('QTG_SelectWeapon')
		self:SetNWBool('QTG_CanHolster',true)
		self:Holster(w)
		timer.Simple(0,function()
			if self:IsValid() and self.Owner:IsValid() then
				if w:IsValid() and w:IsWeapon() then
					self:SetNWBool('QTG_Deployeding',false)
					self.Owner:SelectWeapon(w:GetClass())
				end
			end
		end)
	end
end

function SWEP:PostDrawViewModel(vm)
	if CLIENT and self.Owner:IsValid() and !self.Owner:IsNPC() and self:GetNWBool('QTG_CanHolster') then
		self:ResetBonePositions(vm)
	end
	if self.Owner:IsValid() and !self.Owner:IsNPC() and self:GetNWBool('QTG_CanHolster') then
		self:StopGuiding()
	end
end

local function OnRemoveGiveNpc(self)
	if CLIENT then return end
	local GunOwner = self:IsValid() and self.Owner or self
	timer.Simple(0,function()
		if GunOwner:IsValid() and GunOwner:IsNPC() then
			GunOwner:Give('qtg_admin_gun')
		end
	end)
end

function SWEP:OnRemove()
	self:Holster()
	self:StopGuiding()
	OnRemoveGiveNpc(self)
end

function SWEP:OnDrop()
	self:Holster()
	self:StopGuiding()
	hook.Add('Think',self,self.WeaponThink)
end

if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			-- we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == 'Model') then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == 'Sprite' or v.type == 'Quad') then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == 'Model' and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( 'RenderMultiply', matrix )
				
				if (v.material == '') then
					model:SetMaterial('')
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == 'Sprite' and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == 'Quad' and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()
			end
			
		end
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == 'Model') then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == 'Sprite' or v.type == 'Quad') then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			-- when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, 'ValveBiped.Bip01_R_Hand' )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == 'Model' and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( 'RenderMultiply', matrix )
				
				if (v.material == '') then
					model:SetMaterial('')
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == 'Sprite' and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == 'Quad' and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != '') then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			-- Technically, if there exists an element with the same name as a bone
			-- you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r -- Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end
end

function SWEP:CreateModels( tab )

	if (!tab) then return end

	-- Create the clientside models here because Garry says we can't do it in the render hook
	for k, v in pairs( tab ) do
		if (v.type == 'Model' and v.model and v.model != '' and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
				string.find(v.model, '.mdl') and file.Exists (v.model, 'GAME') ) then
				
			v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
			if (IsValid(v.modelEnt)) then
				v.modelEnt:SetPos(self:GetPos())
				v.modelEnt:SetAngles(self:GetAngles())
				v.modelEnt:SetParent(self)
				v.modelEnt:SetNoDraw(true)
				v.createdModel = v.model
			else
				v.modelEnt = nil
			end
				
		elseif (v.type == 'Sprite' and v.sprite and v.sprite != '' and (!v.spriteMaterial or v.createdSprite != v.sprite) 
			and file.Exists ('materials/'..v.sprite..'.vmt', 'GAME')) then
				
			local name = v.sprite..'-'
			local params = { ['$basetexture'] = v.sprite }
			-- make sure we create a unique name based on the selected options
			local tocheck = { 'nocull', 'additive', 'vertexalpha', 'vertexcolor', 'ignorez' }
			for i, j in pairs( tocheck ) do
				if (v[j]) then
					params['$'..j] = 1
					name = name..'1'
				else
					name = name..'0'
				end
			end

			v.createdSprite = v.sprite
			v.spriteMaterial = CreateMaterial(name,'UnlitGeneric',params)
				
		end
	end		
end
	
local allbones
local hasGarryFixedBoneScalingYet = false

function SWEP:UpdateBonePositions(vm)
		
	if self.ViewModelBoneMods then
			
		if (!vm:GetBoneCount()) then return end
			
		-- !! WORKAROUND !! --
		-- We need to check all model names :/
		local loopthrough = self.ViewModelBoneMods
		if (!hasGarryFixedBoneScalingYet) then
			allbones = {}
			for i=0, vm:GetBoneCount() do
				local bonename = vm:GetBoneName(i)
				if (self.ViewModelBoneMods[bonename]) then 
					allbones[bonename] = self.ViewModelBoneMods[bonename]
				else
					allbones[bonename] = { 
						scale = Vector(1,1,1),
						pos = Vector(0,0,0),
						angle = Angle(0,0,0)
					}
				end
			end
				
			loopthrough = allbones
		end
		-- !! ----------- !! --
			
		for k, v in pairs( loopthrough ) do
			local bone = vm:LookupBone(k)
			if (!bone) then continue end
				
			-- !! WORKAROUND !! --
			local s = Vector(v.scale.x,v.scale.y,v.scale.z)
			local p = Vector(v.pos.x,v.pos.y,v.pos.z)
			local ms = Vector(1,1,1)
			if (!hasGarryFixedBoneScalingYet) then
				local cur = vm:GetBoneParent(bone)
				while(cur >= 0) do
					local pscale = loopthrough[vm:GetBoneName(cur)].scale
					ms = ms * pscale
					cur = vm:GetBoneParent(cur)
				end
			end
				
			s = s * ms
			-- !! ----------- !! --
				
			if vm:GetManipulateBoneScale(bone) != s then
				vm:ManipulateBoneScale( bone, s )
			end
			if vm:GetManipulateBoneAngles(bone) != v.angle then
				vm:ManipulateBoneAngles( bone, v.angle )
			end
			if vm:GetManipulateBonePosition(bone) != p then
				vm:ManipulateBonePosition( bone, p )
			end
		end
	else
		self:ResetBonePositions(vm)
	end		   
end
	 
function SWEP:ResetBonePositions(vm)
	if !vm:GetBoneCount() then return end
	for i=0, vm:GetBoneCount() do
		vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
		vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
		vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
	end	
end

function table.FullCopy(tab)
	if !tab then return nil end
	local res = {}
	for k, v in pairs(tab) do
		if (type(v) == 'table') then
			res[k] = table.FullCopy(v)
		elseif (type(v) == 'Vector') then
			res[k] = Vector(v.x, v.y, v.z)
		elseif (type(v) == 'Angle') then
			res[k] = Angle(v.p, v.y, v.r)
		else
			res[k] = v
		end
	end
	return res
end

function SWEP:SetupWeaponHoldTypeForAI(t)
	self.ActivityTranslateAI = {}
	self.ActivityTranslateAI [ACT_IDLE]									= ACT_IDLE_PISTOL
	self.ActivityTranslateAI [ACT_IDLE_ANGRY]							= ACT_IDLE_ANGRY_PISTOL
	self.ActivityTranslateAI [ACT_RANGE_ATTACK1]						= ACT_RANGE_ATTACK_PISTOL
	self.ActivityTranslateAI [ACT_RELOAD]								= ACT_RELOAD_PISTOL
	self.ActivityTranslateAI [ACT_WALK_AIM]								= ACT_WALK_AIM_PISTOL
	self.ActivityTranslateAI [ACT_RUN_AIM]								= ACT_RUN_AIM_PISTOL
	self.ActivityTranslateAI [ACT_GESTURE_RANGE_ATTACK1]				= ACT_GESTURE_RANGE_ATTACK_PISTOL
	self.ActivityTranslateAI [ACT_RELOAD_LOW]							= ACT_RELOAD_PISTOL_LOW
	self.ActivityTranslateAI [ACT_RANGE_ATTACK1_LOW]					= ACT_RANGE_ATTACK_PISTOL_LOW
	self.ActivityTranslateAI [ACT_COVER_LOW]							= ACT_COVER_PISTOL_LOW
	self.ActivityTranslateAI [ACT_RANGE_AIM_LOW]						= ACT_RANGE_AIM_PISTOL_LOW
	self.ActivityTranslateAI [ACT_GESTURE_RELOAD]						= ACT_GESTURE_RELOAD_PISTOL
	if t == 'ar2' then
		self.ActivityTranslateAI [ACT_RANGE_ATTACK1]                    = ACT_RANGE_ATTACK_AR2
		self.ActivityTranslateAI [ACT_RELOAD]                           = ACT_RELOAD_SMG1
		self.ActivityTranslateAI [ACT_IDLE]                             = ACT_IDLE_SMG1
		self.ActivityTranslateAI [ACT_IDLE_ANGRY]                       = ACT_IDLE_ANGRY_SMG1
		self.ActivityTranslateAI [ACT_WALK]                             = ACT_WALK_RIFLE
		self.ActivityTranslateAI [ACT_MP_RUN] 							= ACT_HL2MP_RUN_AR2
		self.ActivityTranslateAI [ACT_IDLE_RELAXED]                     = ACT_IDLE_SMG1_RELAXED
		self.ActivityTranslateAI [ACT_IDLE_STIMULATED]                  = ACT_IDLE_SMG1_STIMULATED
		self.ActivityTranslateAI [ACT_IDLE_AGITATED]                    = ACT_IDLE_ANGRY_SMG1
		self.ActivityTranslateAI [ACT_MP_CROUCHWALK] 					= ACT_HL2MP_WALK_CROUCH_AR2
		self.ActivityTranslateAI [ACT_WALK_RELAXED]                     = ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI [ACT_WALK_STIMULATED]                  = ACT_WALK_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_WALK_AGITATED]                    = ACT_WALK_AIM_RIFLE

		self.ActivityTranslateAI [ACT_RUN_RELAXED]                      = ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI [ACT_RUN_STIMULATED]                   = ACT_RUN_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_RUN_AGITATED]                     = ACT_RUN_AIM_RIFLE
		
		self.ActivityTranslateAI [ACT_IDLE_AIM_RELAXED]                 = ACT_IDLE_SMG1_RELAXED
		self.ActivityTranslateAI [ACT_IDLE_AIM_STIMULATED]              = ACT_IDLE_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_IDLE_AIM_AGITATED]                = ACT_IDLE_ANGRY_SMG1
		
		self.ActivityTranslateAI [ACT_WALK_AIM_RELAXED]                 = ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI [ACT_WALK_AIM_STIMULATED]              = ACT_WALK_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_WALK_AIM_AGITATED]                = ACT_WALK_AIM_RIFLE

		self.ActivityTranslateAI [ACT_RUN_AIM_RELAXED]                  = ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI [ACT_RUN_AIM_STIMULATED]               = ACT_RUN_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_RUN_AIM_AGITATED]                 = ACT_RUN_AIM_RIFLE

		self.ActivityTranslateAI [ACT_WALK_AIM]                         = ACT_WALK_AIM_RIFLE
		self.ActivityTranslateAI [ACT_WALK_CROUCH]                      = ACT_WALK_CROUCH_RIFLE
		self.ActivityTranslateAI [ACT_WALK_CROUCH_AIM]                  = ACT_WALK_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI [ACT_RUN]                              = ACT_RUN_RIFLE
		self.ActivityTranslateAI [ACT_RUN_AIM]                          = ACT_RUN_AIM_RIFLE
		self.ActivityTranslateAI [ACT_RUN_CROUCH]                       = ACT_RUN_CROUCH_RIFLE
		self.ActivityTranslateAI [ACT_RUN_CROUCH_AIM]                   = ACT_RUN_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI [ACT_GESTURE_RANGE_ATTACK1]            = ACT_GESTURE_RANGE_ATTACK_AR2
		self.ActivityTranslateAI [ACT_COVER_LOW]                        = ACT_COVER_SMG1_LOW
		self.ActivityTranslateAI [ACT_RANGE_AIM_LOW]                    = ACT_RANGE_AIM_AR2_LOW
		self.ActivityTranslateAI [ACT_RANGE_ATTACK1_LOW]                = ACT_RANGE_ATTACK_SMG1_LOW
		self.ActivityTranslateAI [ACT_RELOAD_LOW]                       = ACT_RELOAD_SMG1_LOW
		self.ActivityTranslateAI [ACT_GESTURE_RELOAD]                   = ACT_GESTURE_RELOAD_SMG1
		return
	elseif t == 'shotgun' then
		self.ActivityTranslateAI [ACT_RANGE_ATTACK1]                    = ACT_RANGE_ATTACK_SHOTGUN
		self.ActivityTranslateAI [ACT_RELOAD]                           = ACT_RELOAD_SHOTGUN
		self.ActivityTranslateAI [ACT_IDLE]                             = ACT_IDLE_SMG1
		self.ActivityTranslateAI [ACT_IDLE_ANGRY]                       = ACT_IDLE_ANGRY_SHOTGUN
		self.ActivityTranslateAI [ACT_WALK]                             = ACT_WALK_RIFLE
		self.ActivityTranslateAI [ACT_MP_RUN] 							= ACT_HL2MP_RUN_SHOTGUN
		self.ActivityTranslateAI [ACT_IDLE_RELAXED]                     = ACT_IDLE_SMG1_RELAXED
		self.ActivityTranslateAI [ACT_IDLE_STIMULATED]                  = ACT_IDLE_SMG1_STIMULATED
		self.ActivityTranslateAI [ACT_IDLE_AGITATED]                    = ACT_IDLE_ANGRY_SMG1
		self.ActivityTranslateAI [ACT_MP_CROUCHWALK] 					= ACT_HL2MP_WALK_CROUCH_SHOTGUN
		self.ActivityTranslateAI [ACT_WALK_RELAXED]                     = ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI [ACT_WALK_STIMULATED]                  = ACT_WALK_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_WALK_AGITATED]                    = ACT_WALK_AIM_RIFLE

		self.ActivityTranslateAI [ACT_RUN_RELAXED]                      = ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI [ACT_RUN_STIMULATED]                   = ACT_RUN_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_RUN_AGITATED]                     = ACT_RUN_AIM_RIFLE

		self.ActivityTranslateAI [ACT_IDLE_AIM_RELAXED]                 = ACT_IDLE_SMG1_RELAXED
		self.ActivityTranslateAI [ACT_IDLE_AIM_STIMULATED]              = ACT_IDLE_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_IDLE_AIM_AGITATED]                = ACT_IDLE_ANGRY_SMG1

		self.ActivityTranslateAI [ACT_WALK_AIM_RELAXED]                 = ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI [ACT_WALK_AIM_STIMULATED]              = ACT_WALK_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_WALK_AIM_AGITATED]                = ACT_WALK_AIM_RIFLE
		self.ActivityTranslateAI [ACT_RUN_AIM_RELAXED]                  = ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI [ACT_RUN_AIM_STIMULATED]               = ACT_RUN_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_RUN_AIM_AGITATED]                 = ACT_RUN_AIM_RIFLE

		self.ActivityTranslateAI [ACT_WALK_AIM]                         = ACT_WALK_AIM_RIFLE
		self.ActivityTranslateAI [ACT_WALK_CROUCH]                      = ACT_WALK_CROUCH_RIFLE
		self.ActivityTranslateAI [ACT_WALK_CROUCH_AIM]                  = ACT_WALK_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI [ACT_RUN]                              = ACT_RUN_RIFLE
		self.ActivityTranslateAI [ACT_RUN_AIM]                          = ACT_RUN_AIM_RIFLE
		self.ActivityTranslateAI [ACT_RUN_CROUCH]                       = ACT_RUN_CROUCH_RIFLE
		self.ActivityTranslateAI [ACT_RUN_CROUCH_AIM]                   = ACT_RUN_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI [ACT_GESTURE_RANGE_ATTACK1]            = ACT_GESTURE_RANGE_ATTACK_AR2
		self.ActivityTranslateAI [ACT_COVER_LOW]                        = ACT_COVER_SMG1_LOW
		self.ActivityTranslateAI [ACT_RANGE_AIM_LOW]                    = ACT_RANGE_AIM_AR2_LOW
		self.ActivityTranslateAI [ACT_RANGE_ATTACK1_LOW]                = ACT_RANGE_ATTACK_SMG1_LOW
		self.ActivityTranslateAI [ACT_RELOAD_LOW]                       = ACT_RELOAD_SMG1_LOW
		self.ActivityTranslateAI [ACT_GESTURE_RELOAD]                   = ACT_GESTURE_RELOAD_SMG1
		return
	elseif t == 'rpg' then
		self.ActivityTranslateAI [ACT_RANGE_ATTACK1]                    = ACT_RANGE_ATTACK_RPG
		self.ActivityTranslateAI [ACT_RELOAD]                           = ACT_RELOAD_SMG1
		self.ActivityTranslateAI [ACT_IDLE]                             = ACT_IDLE_SMG1
		self.ActivityTranslateAI [ACT_IDLE_ANGRY]                       = ACT_IDLE_ANGRY_RPG
		self.ActivityTranslateAI [ACT_WALK]                             = ACT_WALK_RIFLE
		self.ActivityTranslateAI [ACT_MP_RUN] 							= ACT_HL2MP_RUN_RPG
		self.ActivityTranslateAI [ACT_IDLE_RELAXED]                     = ACT_IDLE_SMG1_RELAXED
		self.ActivityTranslateAI [ACT_IDLE_STIMULATED]                  = ACT_IDLE_SMG1_STIMULATED
		self.ActivityTranslateAI [ACT_IDLE_AGITATED]                    = ACT_IDLE_ANGRY_SMG1
		self.ActivityTranslateAI [ACT_MP_CROUCHWALK] 					= ACT_HL2MP_WALK_CROUCH_RPG
		self.ActivityTranslateAI [ACT_WALK_RELAXED]                     = ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI [ACT_WALK_STIMULATED]                  = ACT_WALK_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_WALK_AGITATED]                    = ACT_WALK_AIM_RIFLE
		self.ActivityTranslateAI [ACT_RUN_RELAXED]                      = ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI [ACT_RUN_STIMULATED]                   = ACT_RUN_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_RUN_AGITATED]                     = ACT_RUN_AIM_RIFLE
		self.ActivityTranslateAI [ACT_IDLE_AIM_RELAXED]                 = ACT_IDLE_SMG1_RELAXED
		self.ActivityTranslateAI [ACT_IDLE_AIM_STIMULATED]              = ACT_IDLE_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_IDLE_AIM_AGITATED]                = ACT_IDLE_ANGRY_SMG1

		self.ActivityTranslateAI [ACT_WALK_AIM_RELAXED]                 = ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI [ACT_WALK_AIM_STIMULATED]              = ACT_WALK_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_WALK_AIM_AGITATED]                = ACT_WALK_AIM_RIFLE

		self.ActivityTranslateAI [ACT_RUN_AIM_RELAXED]                  = ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI [ACT_RUN_AIM_STIMULATED]               = ACT_RUN_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_RUN_AIM_AGITATED]                 = ACT_RUN_AIM_RIFLE

		self.ActivityTranslateAI [ACT_WALK_AIM]                         = ACT_WALK_AIM_RIFLE
		self.ActivityTranslateAI [ACT_WALK_CROUCH]                      = ACT_WALK_CROUCH_RIFLE
		self.ActivityTranslateAI [ACT_WALK_CROUCH_AIM]                  = ACT_WALK_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI [ACT_RUN]                              = ACT_RUN_RIFLE
		self.ActivityTranslateAI [ACT_RUN_AIM]                          = ACT_RUN_AIM_RIFLE
		self.ActivityTranslateAI [ACT_RUN_CROUCH]                       = ACT_RUN_CROUCH_RIFLE
		self.ActivityTranslateAI [ACT_RUN_CROUCH_AIM]                   = ACT_RUN_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI [ACT_GESTURE_RANGE_ATTACK1]            = ACT_GESTURE_RANGE_ATTACK_AR2
		self.ActivityTranslateAI [ACT_COVER_LOW]                        = ACT_COVER_SMG1_LOW
		self.ActivityTranslateAI [ACT_RANGE_AIM_LOW]                    = ACT_RANGE_AIM_AR2_LOW
		self.ActivityTranslateAI [ACT_RANGE_ATTACK1_LOW]                = ACT_RANGE_ATTACK_SMG1_LOW
		self.ActivityTranslateAI [ACT_RELOAD_LOW]                       = ACT_RELOAD_SMG1_LOW
		self.ActivityTranslateAI [ACT_GESTURE_RELOAD]                   = ACT_GESTURE_RELOAD_SMG1
		return
	elseif t == 'smg' then
		self.ActivityTranslateAI [ACT_GESTURE_RANGE_ATTACK1]            = ACT_GESTURE_RANGE_ATTACK_SMG1 
		self.ActivityTranslateAI [ACT_RANGE_ATTACK1]                    = ACT_RANGE_ATTACK_SMG1 
		self.ActivityTranslateAI [ACT_MP_RUN] 							= ACT_HL2MP_RUN_SMG1
		self.ActivityTranslateAI [ACT_RELOAD]                           = ACT_RELOAD_SMG1
		self.ActivityTranslateAI [ACT_IDLE]                             = ACT_IDLE_SMG1
		self.ActivityTranslateAI [ACT_IDLE_ANGRY]                       = ACT_IDLE_ANGRY_SMG1
		self.ActivityTranslateAI [ACT_WALK]                             = ACT_WALK_RIFLE
		self.ActivityTranslateAI [ACT_MP_CROUCHWALK] 					= ACT_HL2MP_WALK_CROUCH_SMG1
		self.ActivityTranslateAI [ACT_IDLE_RELAXED]                     = ACT_IDLE_SMG1_RELAXED
		self.ActivityTranslateAI [ACT_IDLE_STIMULATED]                  = ACT_IDLE_SMG1_STIMULATED
		self.ActivityTranslateAI [ACT_IDLE_AGITATED]                    = ACT_IDLE_ANGRY_SMG1

		self.ActivityTranslateAI [ACT_WALK_RELAXED]                     = ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI [ACT_WALK_STIMULATED]                  = ACT_WALK_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_WALK_AGITATED]                    = ACT_WALK_AIM_RIFLE

		self.ActivityTranslateAI [ACT_RUN_RELAXED]                      = ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI [ACT_RUN_STIMULATED]                   = ACT_RUN_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_RUN_AGITATED]                     = ACT_RUN_AIM_RIFLE

		self.ActivityTranslateAI [ACT_IDLE_AIM_RELAXED]                 = ACT_IDLE_SMG1_RELAXED
		self.ActivityTranslateAI [ACT_IDLE_AIM_STIMULATED]              = ACT_IDLE_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_IDLE_AIM_AGITATED]                = ACT_IDLE_ANGRY_SMG1

		self.ActivityTranslateAI [ACT_WALK_AIM_RELAXED]                 = ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI [ACT_WALK_AIM_STIMULATED]              = ACT_WALK_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_WALK_AIM_AGITATED]                = ACT_WALK_AIM_RIFLE

		self.ActivityTranslateAI [ACT_RUN_AIM_RELAXED]                  = ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI [ACT_RUN_AIM_STIMULATED]               = ACT_RUN_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI [ACT_RUN_AIM_AGITATED]                 = ACT_RUN_AIM_RIFLE

		self.ActivityTranslateAI [ACT_WALK_AIM]							= ACT_WALK_AIM_RIFLE
		self.ActivityTranslateAI [ACT_WALK_CROUCH]                      = ACT_WALK_CROUCH_RIFLE
		self.ActivityTranslateAI [ACT_WALK_CROUCH_AIM]                  = ACT_WALK_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI [ACT_RUN]								= ACT_RUN_RIFLE
		self.ActivityTranslateAI [ACT_RUN_AIM]                          = ACT_RUN_AIM_RIFLE
		self.ActivityTranslateAI [ACT_RUN_CROUCH]                       = ACT_RUN_CROUCH_RIFLE
		self.ActivityTranslateAI [ACT_RUN_CROUCH_AIM]                   = ACT_RUN_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI [ACT_COVER_LOW]						= ACT_COVER_SMG1_LOW
		self.ActivityTranslateAI [ACT_RANGE_AIM_LOW]                    = ACT_RANGE_AIM_AR2_LOW
		self.ActivityTranslateAI [ACT_RANGE_ATTACK1_LOW]                = ACT_RANGE_ATTACK_SMG1_LOW
		self.ActivityTranslateAI [ACT_RELOAD_LOW]                       = ACT_RELOAD_SMG1_LOW
		self.ActivityTranslateAI [ACT_GESTURE_RELOAD]                   = ACT_GESTURE_RELOAD_SMG1
		return
	end
end

local c_jump = 0
local c_look = 0
local c_move = 0

local c_oang = Angle(0,0,0)
local c_dang = Angle(0,0,0)

function SWEP:GetViewModelPosition(pos,ang)
	local ct,ft = game.GetTimeScale()<1 and CurTime()/game.GetTimeScale() or CurTime(),game.GetTimeScale()<1 and FrameTime()/game.GetTimeScale() or FrameTime()
	local ct2,ft2 = CurTime(),FrameTime()
	local iftp = game.SinglePlayer() or IsFirstTimePredicted()
	if self:GetNWFloat('QTG_DeployTime') > ct2 and self:GetNWBool('QTG_Deployeding') then
		local p = (self:GetNWFloat('QTG_DeployTime')-ct2)/0.8
		ang:RotateAroundAxis(ang:Right(), -(8 * p)^2)
		ang:RotateAroundAxis(ang:Up(), -(2 * p)^2)
		ang:RotateAroundAxis(ang:Forward(), -(8 * p)^2)
	elseif !self:GetNWBool('QTG_Deployeding') then
		ang:RotateAroundAxis(ang:Right(), -64)
		ang:RotateAroundAxis(ang:Up(), -4)
		ang:RotateAroundAxis(ang:Forward(), -64)
	end
	if self:GetHolsterCustoming() then
		if iftp then
			c_holster = Lerp(math.min(ft*2,1),c_holster,1)
		end
		ang:RotateAroundAxis(ang:Right(),-25.768 * c_holster)
		ang:RotateAroundAxis(ang:Up(),-8.435 * c_holster)
		pos = pos + 20 * c_holster * ang:Right()
		pos = pos + -10.148 * c_holster * ang:Forward()
		pos = pos + -15.321 * c_holster * ang:Up()
	end
	if self:GetNWBool('QTG_Deploytweing') then
		c_holster = 0
	end
	local pos,ang = self:Sway(pos,ang,ft,iftp)
	local pos,ang = self:Movement(pos,ang,ct,ft,iftp)
	return pos,ang
end

function SWEP:Movement(pos, ang, ct, ft, iftp)
	if !IsValid(self.Owner) then return pos,ang end
	local bob = 1
	if bob == 0 then return pos,ang end
	
	local move = Vector(self.Owner:GetVelocity().x, self.Owner:GetVelocity().y, 0)
	local movement = move:LengthSqr()
	local movepercent = math.Clamp(movement/self.Owner:GetRunSpeed()^2, 0, 1)
	
	local vel = move:GetNormalized()
	local rd = self.Owner:GetRight():Dot( vel )
	local fd = (self.Owner:GetForward():Dot( vel ) + 1)/2
	
	if iftp then
		local ft8 = math.min(ft * 8, 1)
		
		c_move = Lerp(ft8, c_move or 0, self.Owner:OnGround() and movepercent or 0)
		local c_move2 = movepercent
		c_jump = Lerp(ft8, c_jump or 0, self.Owner:GetMoveType() == MOVETYPE_NOCLIP and 0 or math.Clamp(self.Owner:GetVelocity().z/120,-1.5,1))
		
		if rd > 0.5 then
			c_look = Lerp(math.Clamp(ft * 5, 0, 1), c_look, 8*c_move2)
		elseif rd < -0.5 then
			c_look = Lerp(math.Clamp(ft * 5, 0, 1), c_look, -8*c_move2)
		else
			c_look = Lerp(math.Clamp(ft * 5, 0, 1), c_look, 0)
		end
	end
	
	pos = pos + ang:Up()*0.75*c_jump
	ang.p = ang.p + (c_jump or 0)*3
	ang.r = ang.r + c_look
	
	if bob != 0 and c_move > 0 then
		local p = c_move*bob
		pos = pos - ang:Forward()*c_move*fd - ang:Up()*0.75*c_move + ang:Right()*0.5*c_move
		ang.y = ang.y + math.sin(ct*8.4)*1.2*p
		ang.p = ang.p + math.sin(ct*16.8)*0.8*p
		ang.r = ang.r + math.cos(ct*8.4)*0.3*p
	end
	
	return pos,ang
end

function SWEP:Sway(pos,ang,ft,iftp)
	local sway = 1.2
	if sway == 0 then return pos,ang end
    local angdelta = self.Owner:EyeAngles() - c_oang
	
	if angdelta.y >= 180 then
		angdelta.y = angdelta.y - 360
	elseif angdelta.y <= -180 then
		angdelta.y = angdelta.y + 360
	end
	angdelta.p = math.Clamp(angdelta.p, -5, 5)
	angdelta.y = math.Clamp(angdelta.y, -5, 5)
	angdelta.r = math.Clamp(angdelta.r, -5, 5)
	if iftp then
		local newang = LerpAngle( math.Clamp(ft * 10, 0, 1), c_dang, angdelta )
		c_dang = newang
	end
    c_oang = self.Owner:EyeAngles()
	local psway = sway / (self.SwayPosition or 2)
	ang:RotateAroundAxis( ang:Right(), -c_dang.p*sway )
	ang:RotateAroundAxis( ang:Up(), c_dang.y*sway )
	ang:RotateAroundAxis( ang:Forward(), c_dang.y*sway )
	pos = pos + ang:Right()*c_dang.y*psway + ang:Up()*c_dang.p*psway
    return pos,ang
end

local v_run = 0
function SWEP:CalcView(ply,pos,ang,fov)
	if LocalPlayer():ShouldDrawLocalPlayer() then return end
	local ft,ct = FrameTime(),CurTime()
	v_run = Lerp(ft * 5, v_run,self:GetNWBool('QTG_Running') and self.Owner:OnGround() and 10 or 0)
	return pos,ang,fov+v_run
end