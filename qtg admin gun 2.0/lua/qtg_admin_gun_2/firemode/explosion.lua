QAG2M.Name			= 'Explosion'
QAG2M.Author		= 'Neptune QTG'
QAG2M.Introduction 	= 'Create an explosive entity'
QAG2M.IsAutomatic	= true
QAG2M.FireSound		= 'Airboat.FireGunRevDown'
QAG2M.FireTime		= 0
QAG2M.DrawToolTracer= true

QAG2M.Information = {
	{name = 'left',helptext = 'Create an explosive entity'}
}

QAG2M.FireType[1] = {
	TypeName = '',
	StartFire = function(self,t)
		if SERVER then
			local bomb = ents.Create('qtg_ent_explosion')
			bomb:SetPos(t.HitPos)
			bomb:SetOwner(self.Owner) 
			bomb:Spawn()
		end
	end
}

function QAG2M:Reload()
end

function QAG2M:Think()
end