QAG2M.Name			= 'Flame'
QAG2M.Author		= 'Neptune QTG'
QAG2M.Introduction 	= 'Create a flame entity'
QAG2M.IsAutomatic	= true
QAG2M.FireSound		= 'Airboat.FireGunRevDown'
QAG2M.FireTime		= 0
QAG2M.DrawToolTracer= true

QAG2M.FireType[1] = {
	TypeName = '',
	StartFire = function(self,t)
		if SERVER then			
			local f = ents.Create('env_fire')
			if !f:IsValid() then return end
			f:SetPos(t.HitPos)
			f:SetAngles(self.Owner:EyeAngles())
			f:SetKeyValue('health','2')
			f:SetKeyValue('firesize','250')
			f:SetKeyValue('damagescale','999999')
			f:SetKeyValue('spawnflags','128')
			f:Spawn()
			f:Activate()
			f.Gun = self
			f.Owner = self.Owner
			f:Fire('StartFire','',0)
		end
	end
}

function QAG2M:Reload()
end

function QAG2M:Think()
end