QAG2M.Name			= 'Kill All Npcs'
QAG2M.Author		= 'Neptune QTG'
QAG2M.Introduction 	= 'Kill all npcs on the map'
QAG2M.IsAutomatic	= false
QAG2M.FireTime		= 0.3
QAG2M.FireSound		= ''
QAG2M.DrawToolTracer= false

QAG2M.Information = {
	{name = 'left',helptext = 'Kill all npcs'}
}

QAG2M.WeaponInfo = {
	{name = 'NPCs',text = function(self,t)
		local npcs = {}
		for k,v in pairs(ents.GetAll()) do
			if IsValid(v) and v:IsNPC() or type(v) == 'NextBot' then
				npcs[#npcs+1] = v
			end
		end
		return #npcs
	end}
}

QAG2M.FireType[1] = {
	TypeName = '',
	StartFire = function(self,t)
		for k, v in pairs(ents.GetAll()) do
			if v:IsNPC() or type(v) == 'NextBot' then
				if SERVER then
					v:QTGRemove4()
					net.Start('PlayerKilledNPC')
						net.WriteString(v:GetClass())
						net.WriteString(self.ClassName)
						net.WriteEntity(self.Owner)
					net.Broadcast()
				end
				local ed = EffectData()
				ed:SetOrigin(v:GetPos())
				ed:SetEntity(v)
				util.Effect('entity_remove',ed,true,true)
			end
		end
		if SERVER then
			for k, v in pairs(player.GetAll()) do
				v:QAGAddNotify(self.Owner:Name()..' Kill All NPC',NOTIFY_CLEANUP,5,1)
			end
		end
	end
}