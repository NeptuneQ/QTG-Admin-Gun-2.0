QAG2M.Name 			= 'Crossbow'
QAG2M.Author 		= 'Neptune QTG'
QAG2M.Introduction 	= 'Launching crossbow entity'
QAG2M.IsAutomatic	= true
QAG2M.FireSound		= 'Airboat.FireGunRevDown'
QAG2M.FireTime		= 0

QAG2M.Information = {
	{name = 'left',helptext = 'Launching crossbow'}
}

QAG2M.FireType[1] = {
	TypeName = 'Type 1',
	StartFire = function(self)
		if SERVER then
			for i=1,5 do				
				local c = self.Owner:EyeAngles()
				local b = ents.Create('crossbow_bolt')
				b:SetOwner(self.Owner)
				b:SetPos(self.Owner:GetShootPos()+c:Forward()*32+c:Right()*6-c:Up()*4+Vector(math.Rand(10,-10),math.Rand(10,-10),math.Rand(10,-10)))
				b:SetAngles(self.Owner:EyeAngles())
				b:Spawn()
				b:Activate()
				b:SetVelocity(self.Owner:GetAimVector()*3500)
				b:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
				b.Gun = self
			end
		end
	end
}

function QAG2M:Reload() end
function QAG2M:Think() end
