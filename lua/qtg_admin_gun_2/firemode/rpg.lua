QAG2M.Name 			= 'RPG missile'
QAG2M.Author 		= 'Neptune QTG'
QAG2M.Introduction 	= 'Launching RPG missile'
QAG2M.IsAutomatic	= true
QAG2M.FireSound		= 'Weapon_RPG.Single'
QAG2M.FireTime		= 0.05

QAG2M.Information = {
	{name = 'left',helptext = 'Launching RPG missile'}
}

QAG2M.FireType[1] = {
	TypeName = 'Ordinary type',
	StartFire = function(self,t)
		if SERVER then
			for i=1,2 do
				local a = self.Owner:GetAimVector():Angle()
				local r = ents.Create('rpg_missile')
				r:SetPos(self.Owner:GetShootPos()+a:Forward()*64+a:Right()*8-a:Up()*8+Vector(math.Rand(5,-5),math.Rand(5,-5),math.Rand(5,-5)))
				r:SetAngles(self.Owner:GetAngles())
				r:SetVelocity(self.Owner:GetAimVector()*1000)
				r:SetOwner(self.Owner)
				r:Spawn()
				r:SetSaveValue('m_flDamage',200)
				r:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
				r.Gun = self
			end
		end
	end
}

QAG2M.FireType[2] = {
	TypeName = 'Global type',
	StartFire = function(self,t)
		if SERVER then
			local a = self.Owner:GetAimVector():Angle()
			for k,v in pairs(ents.GetAll()) do
				if (v:IsNPC() and v:Disposition(self.Owner)!=D_LI) or (v:IsPlayer() and v:Alive() and v!=self.Owner) or (v:Health() > 0 and v:IsScripted()) then
					local r = ents.Create('rpg_missile')
					r:SetPos(v:GetPos())
					r:SetAngles((v:WorldSpaceCenter()):Angle())
					r:SetOwner(self.Owner)
					r:Spawn()
					r:SetSaveValue('m_flDamage',200)
					r:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
					r.Gun = self
				end
			end
		end
	end
}

function QAG2M:Reload() end
function QAG2M:Think() end