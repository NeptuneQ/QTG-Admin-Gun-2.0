QAG2M.Name			= 'Universal Kill'
QAG2M.Author		= 'Neptune QTG'
QAG2M.Introduction 	= 'Kill (delete) anything'
QAG2M.IsAutomatic	= true
QAG2M.FireSound		= 'Airboat.FireGunRevDown'
QAG2M.FireTime		= 0.1
QAG2M.DrawToolTracer= true

QAG2M.Information = {
	{name = 'left',helptext = 'Kill (delete) anything'}
}

local dontremeve = {
	'qtg_ent_barrier',
	'qtg_grenade_ar2',
	'qtg_grenade_frag',
	'qtg_nuke_explosion',
	'qtg_ent_barrier',
	'qtg_ent_bullet',
	'qtg_ent_timestop',
	'qtg_ent_timestop_bomb',
	'qtg_explosion',
	'qtg_nuke_bomb',
	'env_spritetrail',
	'predicted_viewmodel',
	'info_player_start',
	'func_precipitation',
	'beam',
	'env_laserdot'
}

QAG2M.FireType[1] = {
	TypeName = '',
	StartFire = function(self,t)
		if t.Entity:IsValid() then
			if t.Entity:IsPlayer() and t.Entity != self.Owner then
				if t.Entity:GetActiveWeaponClass() != 'qtg_admin_gun' and t.Entity:Alive() then
					if SERVER then
						t.Entity:KillSilent()
						net.Start('PlayerKilledByPlayer')
							net.WriteEntity(t.Entity)
							net.WriteString('qtg_universal_kill')
							net.WriteEntity(self.Owner)
						net.Broadcast()
						MsgAll(self.Owner:Nick()..' killed '..t.Entity:Nick()..' using '..self.ClassName..'\n')
					end
					local ed = EffectData()
					ed:SetOrigin(t.Entity:GetPos())
					ed:SetEntity(t.Entity)
					util.Effect('entity_remove',ed,true,true)
				end
			else
				if SERVER then
					t.Entity:QTGRemove50()
					t.Entity.OnRemove = function(self)
						self:QTGRemove25()
						self:StopSound('windgrinpanic')
						self:StopSound('lubenweipanic')
					end
					net.Start('PlayerKilledNPC')
						net.WriteString(t.Entity:GetClass())
						net.WriteString('qtg_universal_kill')
						net.WriteEntity(self.Owner)
					net.Broadcast()
				end
				local ed = EffectData()
				ed:SetOrigin(t.Entity:GetPos())
				ed:SetEntity(t.Entity)
				util.Effect('entity_remove',ed,true,true)
			end
		end
		for k,v in pairs(ents.FindAlongRay(self.Owner:GetShootPos()+self.Owner:GetAimVector()*80,t.HitPos,Vector(-10,-10,-10),Vector(15,15,15))) do
			timer.Simple(0,function()
				if v:IsValid() then
					if v:IsPlayer() and v != self.Owner then
						if v:GetActiveWeaponClass() != 'qtg_admin_gun' and v:Alive() then
							if SERVER then
								v:KillSilent()
								net.Start('PlayerKilledByPlayer')
									net.WriteEntity(v)
									net.WriteString('qtg_universal_kill')
									net.WriteEntity(self.Owner)
								net.Broadcast()
								MsgAll(self.Owner:Nick()..' killed '..v:Nick()..' using '..self.ClassName..'\n')
							end
							local ed = EffectData()
							ed:SetOrigin(v:GetPos())
							ed:SetEntity(v)
							util.Effect('entity_remove',ed,true,true)
						end
					elseif v != self and !v:IsWeapon() and !v:IsPlayer() and !table.HasValue(dontremeve,v:GetClass()) then
						if t.Entity:IsNPC() and t.Entity:GetNPCState() == NPC_STATE_DEAD then
						else
							if SERVER then
								v:QTGRemove50()
								net.Start('PlayerKilledNPC')
									net.WriteString(v:GetClass())
									net.WriteString('qtg_universal_kill')
									net.WriteEntity(self.Owner)
								net.Broadcast()
							end
							local ed = EffectData()
							ed:SetOrigin(v:GetPos())
							ed:SetEntity(v)
							util.Effect('entity_remove',ed,true,true)
						end
					end
				end
			end)
		end
	end
}

function QAG2M:Reload()
end

function QAG2M:Think()
end