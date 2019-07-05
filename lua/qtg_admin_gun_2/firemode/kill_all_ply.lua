QAG2M.Name			= 'Kill All Players'
QAG2M.Author		= 'Neptune QTG'
QAG2M.Introduction 	= 'Kill all players except yourself'
QAG2M.IsAutomatic	= false
QAG2M.FireTime		= 0.3
QAG2M.FireSound		= ''
QAG2M.DrawToolTracer= false

QAG2M.Information = {
	{name = 'left',helptext = 'Kill all players'}
}

QAG2M.WeaponInfo = {
	{name = 'Players',text = function(self,t)
		local plys = {}
		for k,v in pairs(player.GetAll()) do
			if v != self.Owner and v:Alive() and v:GetActiveWeaponClass() != self.ClassName then
				plys[#plys+1] = v
			end
		end
		return #plys
	end}
}

QAG2M.FireType[1] = {
	TypeName = '',
	StartFire = function(self,t)
		for k,v in pairs(player.GetAll()) do
			if v != self.Owner and v:Alive() and v:GetActiveWeaponClass() != self.ClassName then
				if SERVER then
					v:KillSilent()
					net.Start('PlayerKilledByPlayer')
						net.WriteEntity(v)
						net.WriteString(self.ClassName)
						net.WriteEntity(self.Owner)
					net.Broadcast()
					MsgAll(self.Owner:Nick()..' killed '..v:Nick()..' using '..self.ClassName.. '\n')
				end
				local ed = EffectData()
				ed:SetOrigin(v:GetPos())
				ed:SetEntity(v)
				util.Effect('entity_remove',ed,true,true)
			end
			if SERVER then
				v:QAGAddNotify(self.Owner:Name()..' Kill All Player',NOTIFY_CLEANUP,5,1)
			end
		end
	end
}