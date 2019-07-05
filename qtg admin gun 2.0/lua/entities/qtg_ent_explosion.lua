AddCSLuaFile()

ENT.Type 			= 'anim'
ENT.Base 			= 'base_anim'

ENT.Spawnable		= false
ENT.AdminOnly		= false

ENT.Radius 			= 200
ENT.Damage			= 1e9

local ReplaceList = {
	'prop_door_rotating',
	'prop_door',
	'func_door_rotating',
	'func_door'
}
local ReplaceList2 = {
	'func_physbox'
}

function ENT:Initialize()
	local t = self.Owner:GetEyeTrace()
	local Pos1 = t.HitPos + t.HitNormal
	local Pos2 = t.HitPos - t.HitNormal
	if SERVER then
		self:SetNoDraw(true)
		self:DrawShadow(false)
		util.BlastDamage(self,self.Owner,self:GetPos(),self.Radius,self.Damage)
		local lt = ents.Create('light_dynamic')
		lt:SetPos(t.HitPos+(t.HitNormal*3))
		lt:Spawn()
		lt:SetKeyValue('_light','255 100 0')
		lt:SetKeyValue('distance',500)
		lt:SetParent()
		lt:Fire('kill','',0.1)
		for _,e in ipairs(ents.FindInSphere(self:GetPos(),self.Radius)) do
			for k, v in pairs(ReplaceList) do
				if e:IsValid() and e:GetClass() == v then
					local d = ents.Create('prop_physics')
					d:SetModel(e:GetModel())
					d:SetPos(e:GetPos())
					d:SetAngles(e:GetAngles())
					d:Spawn()
					d:Activate()
					if v:GetSkin() != nil then
						d:SetSkin(e:GetSkin())
					end
					d:SetMaterial(e:GetMaterial())
					e:Remove()
					timer.Simple(3,function()
						if d:IsValid() then
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
						phys:SetVelocity(((d:GetPos() -self:GetPos()) *500 +(d:GetPos() +d:GetForward() *400 -self:GetPos()) +(d:GetPos() +d:GetUp() *200 -self:GetPos()) *140))
					end
				end
			end
		end
		self:Remove()
	else
		local eff = EffectData()
		eff:SetStart(self:GetPos())
		eff:SetOrigin(self:GetPos())
		eff:SetScale(1)
		util.Effect('Explosion',eff)
		util.Decal('Scorch',Pos1,Pos2)
	end
end