QAG2M.Name 			= 'Combine Ball'
QAG2M.Author 		= 'Neptune QTG'
QAG2M.Introduction 	= 'Launching combine ball entity'
QAG2M.IsAutomatic	= true
QAG2M.FireSound		= 'Airboat.FireGunRevDown'
QAG2M.FireTime		= 0.05

QAG2M.Information = {
	{name = 'left',helptext = 'Launching combine ball'}
}

QAG2M.FireType[1] = {
	TypeName = 'Ordinary type',
	StartFire = function(self)
		if SERVER then
			for i=1,6 do
				local f = self.Owner:EyeAngles():Forward()
				local b = ents.Create('prop_combine_ball')
				b:SetPos(self.Owner:GetShootPos()+f*32+Vector(math.Rand(25,-25),math.Rand(25,-25),math.Rand(25,-25))+(self.Owner:GetRight()*10+self.Owner:GetUp()*-10))
				b:Spawn()
				b:Activate()
				b:SetOwner(self.Owner)
				b:Fire('explode','',20)
				b:SetSaveValue('m_flRadius',10)
				b:SetSaveValue('m_nState',110)
				b:SetSaveValue('m_bLaunched',true)
				b:SetSaveValue('m_bBounceDie',false)
				b:SetSaveValue('m_bWeaponLaunched',false)
				b.Gun = self
				local p = b:GetPhysicsObject()
				p:SetVelocity(self.Owner:GetAimVector()*1e9)
			end
		end
	end
}

QAG2M.FireType[2] = {
	TypeName = 'Global type',
	StartFire = function(self)
		if SERVER then
			for k,v in pairs (ents.GetAll()) do
				if (v:IsNPC() and v:Disposition(self.Owner)!=D_LI) or (v:IsPlayer() and v:Alive() and v!=self.Owner) or (v:Health() > 0 and v:IsScripted()) then
					local b = ents.Create('prop_combine_ball')
					b:SetAngles((v:GetPos()+Vector(0,0,100)):Angle())
					b:SetPos(v:GetPos()+Vector(0,0,100))
					b:Spawn()
					b:Activate()
					b:SetOwner(self.Owner)
					b:Fire('explode','',20)
					b:SetSaveValue('m_flRadius',10)
					b:SetSaveValue('m_nState',110)
					b:SetSaveValue('m_bLaunched',true)
					b:SetSaveValue('m_bBounceDie',false)
					b:SetSaveValue('m_bWeaponLaunched',false)
					b.Gun = self
					local p = b:GetPhysicsObject()
					p:SetVelocity(v:GetPos()-Vector(0,0,100)*1e9)
				end
			end
		end
	end
}

function QAG2M:Reload() end
function QAG2M:Think() end
